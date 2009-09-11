/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_SignalCapture.c
* Author		 : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 20.04.2009
*****************************************************************************
* Description	 : 
*****************************************************************************

*  Copyright (c) 2009, Alexander Lindert

*  This program is free software; you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation; either version 2 of the License, or
*  (at your option) any later version.

*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.

*  You should have received a copy of the GNU General Public License
*  along with this program; if not, write to the Free Software
*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*  For commercial applications where source-code distribution is not
*  desirable or possible, I offer low-cost commercial IP licenses.
*  Please contact me per mail.

*****************************************************************************
* Remarks		: -
* Revision		: 0
****************************************************************************/


#include <stdlib.h>
#include <stdio.h>
#include "grcommon.h"
#include "DSO_SFR.h"
#include "DSO_SignalCapture.h"
#include "DSO_Debugprint.h"
#include "DSO_Misc.h"
#include "DSO_ADC_Control.h"
#include "Leon3Uart.h"

Debugprint Print;
volatile CaptureRegs    * volatile CaptureR;
volatile TriggerRegs    * volatile TriggerR;
volatile AnalogSettings * volatile AnalogR;
volatile uart_regs      * volatile adc_uart;

static uint32_t FMode;

uint32_t FastMode(	
			const uint32_t SamplingFrequency, 
			const uint32_t CPUFrequency){
	return SamplingFrequency > (CPUFrequency/FASTMODEFACTOR);
}
uint32_t IsFastMode() {
	return FMode;
}

bool InitSignalCapture(Debugprint * Init, Target T, Language L){
	CaptureR = (CaptureRegs *)   DEVICEADDR;
	TriggerR = (TriggerRegs *)   TRIGGERONCHADDR;
	AnalogR  = (AnalogSettings *)ANALOGSETTINGSBANK7;
	adc_uart = (uart_regs *)     UART_CHCFG_BASE_ADDR;    
/*	UartInit(FIXED_CPU_FREQUENCY, DSO_CHCFG_BAUDRATE, 
			ENABLE_RX | ENABLE_TX, adc_uart);*/
	Init = &Print;
	return InitDebugprint(&Print,T,L);
}

bool SetTriggerInput (	
			const uint32_t noChannels, 
			const uint32_t SampleSize, 
			const uint32_t SamplingFrequency,
			const uint32_t CPUFrequency,
			const uint32_t AACFilterStart,
			const uint32_t AACFilterStop,
			const uint32_t Ch0, 
			const uint32_t Ch1, 
			const uint32_t Ch2, 
			const uint32_t Ch3)
{
	FMode = FastMode(SamplingFrequency,CPUFrequency);
	uint32_t Decimaton = 0;
	uint32_t Stage = 0;
	uint32_t M = 0;

	if ((Ch0 > 3) || (Ch1 > 3) || (Ch2 > 3) || (Ch3 > 3)) {
/*		Print.ChannelsNotSupported();*/
		return false;
	}


	TriggerR->TriggerStorageModeAddr = TRIGGERSTORAGEMODE4CH;
	switch(CaptureR->DeviceAddr){
		case WELEC2012:
		case WELEC2014:
		case WELEC2022:
		case WELEC2024:	Decimaton = WELECMAXFS/SamplingFrequency; break;
		case SANDBOXX:	Decimaton = SANDBOXXFS/SamplingFrequency; break;
		default:	Decimaton = WELECMAXFS/SamplingFrequency; break;
	}
	Stage = 0;
	M = 0;
	do {
		if (Decimaton >= 10) {
			M |= (10<<Stage);
		} else {
			switch (Decimaton) {
				case 2 : M |= (2<<Stage); break;
				case 4 : M |= (4<<Stage); break;
				default: M |= (1<<Stage); break;
			}
		}
		Decimaton = Decimaton/10;
		Stage += 4;
	} while (Decimaton > 10); 
	CaptureR->Decimator = M;


	Stage = 0;
	for(M = AACFilterStart; M < AACFilterStop; ++M){
	       Stage |= (1 << M);  
	}
	if ((AACFilterStart == 0) && (AACFilterStop != 0)){
	      Stage |= (3 << 30);
	}	      
	CaptureR->FilterEnable = Stage;

	switch (SampleSize) {
		case 8:
			switch (noChannels) {
				case 1:
					if (FMode != 0){
						TriggerR->TriggerStorageModeAddr = TRIGGERSTORAGEMODE1CH;
					}
					CaptureR->InputCh0Addr = Ch0;
					CaptureR->InputCh1Addr = Ch0;
					CaptureR->InputCh2Addr = Ch0;
					CaptureR->InputCh3Addr = Ch0;
					break;
				case 2:
					if (FMode != 0){
						TriggerR->TriggerStorageModeAddr = TRIGGERSTORAGEMODE2CH;
					}
					CaptureR->InputCh0Addr = Ch0;
					CaptureR->InputCh1Addr = Ch1;
					CaptureR->InputCh2Addr = Ch0;
					CaptureR->InputCh3Addr = Ch1;
					break;
				case 4:
					CaptureR->InputCh0Addr = Ch0;
					CaptureR->InputCh1Addr = Ch1;
					CaptureR->InputCh2Addr = Ch2;
					CaptureR->InputCh3Addr = Ch3;
					break;
				default : 
				/*	Print.NotAvialbe();*/
					return false;
			       break;
			}
			break;
		case 16: 
			switch (noChannels) {
				case 1:
					if (FMode != 0){
						TriggerR->TriggerStorageModeAddr = TRIGGERSTORAGEMODE2CH;
					}
					CaptureR->InputCh0Addr = Ch0;
					CaptureR->InputCh1Addr = Ch0+4;
					CaptureR->InputCh2Addr = Ch0;
					CaptureR->InputCh3Addr = Ch0+4;
					break;
				case 2:
					CaptureR->InputCh0Addr = Ch0;
					CaptureR->InputCh1Addr = Ch0+4;
					CaptureR->InputCh2Addr = Ch1;
					CaptureR->InputCh3Addr = Ch1+4;
					break;
				default : 
				/*	Print.NotAvialbe();*/
					return false;
			       break;
			}
			break;
		default : 
		/*	Print.NotAvialbe();*/
			return false;
			break;
	}
	return true;
}

/* reference time in samples*/
bool SetTrigger(
		const uint32_t Trigger, 
		const uint32_t ExtTrigger,
		const uint32_t TriggerChannel,
		const uint32_t TriggerPrefetchSamples,
		const int  LowReference,
		const uint32_t  LowReferenceTime,
		const int HighReference,
		const uint32_t HighReferenceTime) 
{
	if (TriggerChannel > 3) {
	/*	Print.ChannelsNotSupported();*/
		return false;
	}
	if (TriggerPrefetchSamples >= (TRIGGER_MEM_SIZE-16)){
	/*	Print.ToMuchPrefetchSamples();*/
		return false;
	}
	if (Trigger >= MAX_TRIGGER_TYPES){
		return false;
	}
	if (ExtTrigger > MAX_EXT_TRIGGER) {
		return false;
	}
	TriggerR->TriggerTypeAddr = Trigger;
	CaptureR->ExtTriggerSrcAddr = ExtTrigger;
	TriggerR->TriggerLowValueAddr  = LowReference;
	TriggerR->TriggerLowTimeAddr   = LowReferenceTime;
	TriggerR->TriggerHighValueAddr = HighReference;
	TriggerR->TriggerHighTimeAddr  = HighReferenceTime;
	TriggerR->TriggerPrefetchAddr = TriggerPrefetchSamples;
#if 0
    if ((loadmem((int)&TriggerR->TriggerLowValueAddr)  != LowReference)     ||
	(loadmem((int)&TriggerR->TriggerLowTimeAddr)   != LowReferenceTime) ||
	(loadmem((int)&TriggerR->TriggerHighValueAddr) != HighReference)    ||
	(loadmem((int)&TriggerR->TriggerHighTimeAddr)  != HighReferenceTime))
	{
	/*	Print.TriggerSettingsOutofRange();*/
		return false;
	}
#endif
    return true;
}


bool SetAnalogInputRange(const uint32_t NoCh, 
			 const SetAnalog * Settings) 
{
	uint32_t i = 0;
	uint32_t temp = 0;
	uint32_t j = 0;
	short dac = 0;
	for(i = 0; i < NoCh; ++i){
		switch (CaptureR->DeviceAddr) {
			case WELEC2012:
			case WELEC2022:
			case WELEC2014:
			case WELEC2024:
				if (NoCh < 2) {
					return false;
				}
				if (Settings[i].myVperDiv < 1000000) {
					temp = (1 << CH0_K1_ON);
				} else {
					temp = (1 << CH0_K1_OFF);
				}
				if (Settings[i].myVperDiv < 100000) {
					temp |= (1 << CH0_K2_ON);
				} else {
					temp |= (1 << CH0_K2_OFF);
				}
				if (Settings[i].myVperDiv < 10000) {
					temp |= (1 << CH0_OPA656) |  (1 << CH0_U14) | (1 << CH0_U13);
				}
				if (i == 0) {
					for (j = 0; j < NoCh; ++j) {
						if (Settings[j].AC == 0){
							temp |= (1 << (CH0_DC+j));
						}
					}
					/* send the configuration to the hardware*/
					AnalogR->Bank7 = temp;
					/*while ((loadmem((int)&AnalogR->Bank7) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank7, (1 << ANALOGSETTINGSBUSY));
					/* wait until the coils have switched*/
					WaitMs(COIL_SWITCH_TIME);
					temp &= ~(0xf); /* turn of the coils*/
					AnalogR->Bank7 = temp;
					/*while ((loadmem((int)&AnalogR->Bank7) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank7, (1 << ANALOGSETTINGSBUSY));
					/* Used DAC types are limited to 16 bits per protocol! */
					dac = (short)Settings[i].DA_Offset;
					temp = dac;
					AnalogR->Bank6 = temp| (i << DAC_CH_OFFSET);
					/*while ((loadmem((int)&AnalogR->Bank6) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank6, (1 << ANALOGSETTINGSBUSY));
				}
				if (i == 1) {
					for (j = 0; j < NoCh; ++j) {
						switch (Settings[j].Mode){
							case normal: 	
								temp |= (SRC2_NONE    << (CH0_SRC2_ADDR+(2*j)));
								break;
							case pwm_offset:	
								temp |= (SRC2_PWM     << (CH0_SRC2_ADDR+(2*j)));
								break;
							case gnd:
								temp |= (SRC2_GND     << (CH0_SRC2_ADDR+(2*j)));
								break;
							case lowpass:
								temp |= (SRC2_LOWPASS << (CH0_SRC2_ADDR+(2*j)));
								break;
							default:
								return false;
								break;
						}
					}
					/* send the configuration to the hardware*/
					AnalogR->Bank5 = temp;
					/*while ((loadmem((int)&AnalogR->Bank5) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank5, (1 << ANALOGSETTINGSBUSY));
					/* wait until the coils have switched*/
					WaitMs(COIL_SWITCH_TIME);
					temp &= ~(0xf); /* turn of the coils*/
					AnalogR->Bank5 = temp;
					/*while ((loadmem((int)&AnalogR->Bank5) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank5, (1 << ANALOGSETTINGSBUSY));
					/* Used DAC types are limited to 16 bits per protocol! */
					dac = (short)Settings[i].DA_Offset;
					temp = dac;
					AnalogR->Bank6 = temp | (i << DAC_CH_OFFSET);
					/*while ((loadmem((int)&AnalogR->Bank6) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank6, (1 << ANALOGSETTINGSBUSY));
				}
				break;
			case SANDBOXX:
				{
#if 0
					ADCSerial cmds[]= {
					      {ADC_ADDR_SPEED,  (1 << ADC_PIN_LSPEED)},
					      {ADC_ADDR_POWER,  (1 << ADC_PIN_MODE0)},
					      {ADC_ADDR_DFS,    (3 << ADC_PIN_DFS0)},
					      {ADC_ADDR_CLK,    (5 << ADC_PIN_RISE0) 
							   |    (5 << ADC_PIN_FALL0)},
					      {ADC_ADDR_FORMAT, (2 << ADC_PIN_FORMAT0)},
					      {ADC_ADDR_OFFSETE,(1 << ADC_PIN_OFFSETE)}};
					uint32_t cmd = Settings[i].Specific;
					uint8_t temp = 0;
				        bool ret = true;	
					int * ADCConfig = (uint32_t *)CONFIGADCENABLE; 
					*ADCConfig = ~1;/* low active, one ADC */
					WaitMs(2); /* Wait until the AVR is ready */

					if (SendADCSerialConfig(adc_uart, cmds, sizeof(cmd)) == false) {
						return false;
					}
					if (((1 << ADC_SPEC_PGM_CLK) & cmd) != 0){
					       temp = (uint8_t)(cmd >> ADC_SPEC_CLKF);
					       ret   = SendADCSerial(adc_uart, ADC_ADDR_CLK,temp);
					       if (ret != temp) {
						       return false;
					       }
					}       
					if (((1 << ADC_SPEC_PGM_OFS) & cmd) != 0){
						temp = (uint8_t)(cmd >> ADC_SPEC_OTIME);
						ret  = SendADCSerial(adc_uart, ADC_ADDR_OFFSETD,temp);
						if (ret != temp) {
						       return false;
						}
					}
					if ((( 1 << ADC_SPEC_PGM_PAT) & cmd) != 0){
						temp = (uint8_t)(cmd >> ADC_SPEC_PATTERN);
						ret  = SendADCSerial(adc_uart, ADC_ADDR_OFFSETD,temp);
						if (ret != temp) {
						       return false;
						}
					}

				/*	SendStringBlock(adc_uart, ADC_PCB_REQUEST);
					SendCharBlock(adc_uart, ADC_MODE);
					SendCharBlock(adc_uart,0);
					SendCharBlock(adc_uart, ADC_MODE_CMOS_2S);
					SendCharBlock(adc_uart, ADC_DFS_CMOS_2S);
					SendCharBlock(1); *//* enable output */
					/* dont care about the answer */
					
					SendStringBlock(adc_uart, ADC_PCB_REQUEST);
					SendCharBlock(adc_uart,ADC_RELEASE);
					WaitMs(2);
					*ADCConfig = -1; /* high inactive */
#endif
					return true;	
				}
				
			default: 
				return false;
				break;
		}
	}
	return true;
}

int FastCapture(const uint32_t WaitTime, /* just a integer */
		uint32_t CaptureSize,    /* size in DWORDs*/
		uint32_t * RawData) 
{
	uint32_t i = 0;
	uint32_t * StopAddr = 0;
	volatile uint32_t * Addr = 0;
	uint32_t StartSize = 0;
	uint32_t StartData[8] = {};
	/* The compiler has bugs in the loop optimisation with the keyword volatile 
	 * even with function call to get the data from an hw address + masking in a condition */
	volatile uint32_t StopOffset = 0; 
	volatile uint32_t temp = 0; 

	TriggerR->TriggerOnceAddr = 0;
	TriggerR->TriggerOnceAddr = 1;

	if (WaitTimeoutAndNotZero(&TriggerR->TriggerStatusRegister, 
			(1 << TRIGGERRECORDINGBIT), WaitTime) == false) {
		return 0;
	}
	StopOffset = loadmem((unsigned int)&TriggerR->TriggerReadOffSetAddr);
	StopAddr = (uint32_t *)(TRIGGER_MEM_BASE_ADDR + StopOffset);

	StopAddr++; /* matching 0 to end-1 */
	if ((int)StopAddr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
		StopAddr =  (int *) TRIGGER_MEM_BASE_ADDR;
	}
	Addr = StopAddr;
	CaptureR->DeviceAddr = (uint32_t) Addr;
	
	/* The folowing lines solve a feature in the hardware trigger, 
	 * which is overwriting up the first 7 samples at the end!       
	 * It is caused, because the trigger always writes 8 Samples per Channel at once */
	StopOffset = (StopOffset +8) & (TRIGGER_MEM_SIZE-1); /* mod 2^n */
	while(1){
		temp = loadmem((unsigned int)&TriggerR->TriggerCurrentAddr); 
		if ((StopOffset < temp) || ((StopOffset-temp) > 8)){
			break;
		}
	}
	if (8 > CaptureSize){
		StartSize = CaptureSize;
	} else {
		StartSize = 8;
	}
	for (i = 0; i < StartSize; ++i){
		StartData[i] = Addr[0];
		Addr++;
		if ((int)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
			Addr =  (int *) TRIGGER_MEM_BASE_ADDR;
		}
	}
	i = 0;
	Addr = StopAddr;
	if ((TRIGGER_MEM_SIZE/sizeof(uint32_t)) < CaptureSize){
		CaptureSize = TRIGGER_MEM_SIZE/sizeof(uint32_t);
	}
	/* Wait until the trigger buffer is full */
	WaitUntilMaskedAndZero(&TriggerR->TriggerStatusRegister, (1 << TRIGGERRECORDINGBIT));
/*	CaptureR->DeviceAddr = (uint32_t) CaptureSize;*/
	while ((i < CaptureSize)){
		RawData[i] = Addr[0];
		i++;
		Addr++;	
		if ((int)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
			Addr =  (int *) TRIGGER_MEM_BASE_ADDR;
			CaptureR->DeviceAddr = i;
		}
	}
	/* The Trigger has a feature that the last 8 DWORDS! overwrites up 
	 * to the fist 8 DWORDS!*/
	for (i = 0; i < StartSize; ++i){
		temp = loadmem((unsigned int)&TriggerR->TriggerStorageModeAddr);
	       switch (temp) {
			case TRIGGERSTORAGEMODE4CH:
				RawData[i]   = StartData[i];
				break;
			case TRIGGERSTORAGEMODE2CH:
				RawData[i]   &= 0x0000ffff;
				StartData[i] &= 0xffff0000;
				RawData[i]   |= StartData[i];
				break;
			case TRIGGERSTORAGEMODE1CH:
				RawData[i]   &= 0x00ffffff;
				StartData[i] &= 0xff000000;
				RawData[i]   |= StartData[i];
				break;
	       }
	}
	return CaptureSize;
}

/* returns read DWORDS*/
uint32_t CaptureData(const uint32_t WaitTime, /* just a integer */
			 bool Start,
			 bool ForceFastMode,
			 uint32_t CaptureSize,    /* size in DWORDs*/
			 uint32_t * RawData) 
{
	/* TODO Idle wait*/
/*	const int FMode = FastMode(SamplingFrequency,CPUFrequency);*/
	uint32_t i = 0;
	uint32_t StopAddr = 0;
	static volatile uint32_t * Addr = 0;
	uint32_t Frame = 0;
	/* The compiler has bugs in the loop optimisation with the keyword volatile even 
	 * with function call to get the data from an hw address + masking in a condition */
	volatile int temp = 0; 
	
	if ((FMode != 0) || ForceFastMode == true) {
		return FastCapture(WaitTime,CaptureSize, RawData);
	} 
	printf("Record Normal\n");

	if (Start != false) {
		TriggerR->TriggerOnceAddr = 0;
		TriggerR->TriggerOnceAddr = 1;
		if (WaitTimeoutAndNotZero(&TriggerR->TriggerStatusRegister, 
					(1 << TRIGGERRECORDINGBIT), WaitTime) == false) {
			return 0;
		}
		Addr = (int *)TRIGGER_MEM_BASE_ADDR + StopAddr;
	}
	i = 0;
	StopAddr = (TriggerR->TriggerReadOffSetAddr) +1;
	
	while (1) {
		temp = loadmem((int)&TriggerR->TriggerStatusRegister);
		if (((1 << TRIGGERRECORDINGBIT) & temp) == 0) {
			return i;
		}
		if ((i == CaptureSize)){
			return i;
		}
		Frame = loadmem((int)&TriggerR->TriggerCurrentAddr); /* stoppoint of readable DWORDS */
		Frame = Frame - (unsigned int)Addr;
        	Frame &= (TRIGGER_MEM_SIZE-1);                       /* number of readable DWORDS */
		Frame = i + Frame; 
		if (Frame > CaptureSize) {
			Frame = CaptureSize;
		}
		/* measured 19 clocks per iteration with an sdram and compiler flags -g -O2
		 * measured  8 clocks per iteration with an sdram and compiler flags -O2 */
		while (i < Frame) {
			RawData[i] = *Addr;
			i++;
			Addr++;
			if ((unsigned int)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
				Addr =  (uint32_t *) TRIGGER_MEM_BASE_ADDR;
				CaptureR->DeviceAddr = i;
			}
		}
		TriggerR->TriggerCurrentAddr = (unsigned int)Addr-1; 
		/* & (TRIGGER_MEM_SIZE-1); hw SFR mod 2^bits */
	/*	puts("."); */

	}
	return i;
}
