/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_SignalCapture.c
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
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
#ifdef LEON3
#include "grcommon.h"
#endif
#include "DSO_SFR.h"
#include "DSO_SignalCapture.h"
#include "DSO_Misc.h"
#include "DSO_ADC_Control.h"
/*#include "Leon3Uart.h"*/

#ifdef LEON3
#include "Leon3Uart.h"
#endif

#include "rprintf.h"

/*volatile CaptureRegs    * volatile CaptureR;
volatile TriggerRegs    * volatile TriggerR;
volatile AnalogSettings * volatile AnalogR;
volatile uart_regs      * volatile adc_uart;*/

static uint32_t FMode;

uint32_t FastMode(	
		const uint32_t SamplingFrequency, 
		const uint32_t CPUFrequency){
	return SamplingFrequency > (CPUFrequency/FASTMODEFACTOR);
}
uint32_t IsFastMode() {
	return FMode;
}

uint32_t InitSignalCapture(){
/*	CaptureR = (CaptureRegs *)   DEVICEADDR;
	TriggerR = (TriggerRegs *)   TRIGGERONCHADDR;
	AnalogR  = (AnalogSettings *)ANALOGSETTINGSBANK7;
	adc_uart = (uart_regs *)     UART_CHCFG_BASE_ADDR;*/    
/*	UartInit(FIXED_CPU_FREQUENCY, DSO_CHCFG_BAUDRATE, 
			ENABLE_RX | ENABLE_TX, adc_uart);*/
	return TRUE;
}

#include "DSO_Remote.h"
#include "DSO_Main.h"

uint32_t SetTriggerInput (	
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
	uint32_t Decimation = 0;
	uint32_t Stage = 0;
	uint32_t M = 0;

	if ((Ch0 > 3) || (Ch1 > 3) || (Ch2 > 3) || (Ch3 > 3)) {
		return FALSE;
	}
/*	SendStringBlock((uart_regs*)REMOTE_UART,DSO_SEND_HEADER);
	SendStringBlock((uart_regs*)REMOTE_UART,DSO_MESSAGE_RESP);
	SendCharBlock(REMOTE_UART,'0' + Decimation);
	SendCharBlock(REMOTE_UART,'\0');*/

	switch(READ_INT(DEVICEADDR)){
		case WELEC2012:
		case WELEC2014:
		case WELEC2022:
		case WELEC2024:	Decimation = WELECMAXFS/SamplingFrequency; break;
		case SANDBOXX:	Decimation = SANDBOXXFS/SamplingFrequency; break;
		default:	Decimation = WELECMAXFS/SamplingFrequency; break;
	}

	if (Decimation % 8 == 0){
		M = 8;
		Decimation = Decimation/8;
	} else if (Decimation >= 10) {
		M = 10;
		Decimation = Decimation/10;
	} else {
		switch(Decimation) {
			case 1:  M = 1; break;
			case 2:  M = 2; break;
			case 4:  M = 4; break;
			default: M = 8; 
				SendStringBlock((uart_regs*)REMOTE_UART,DSO_SEND_HEADER);
				SendStringBlock((uart_regs*)REMOTE_UART,DSO_MESSAGE_RESP);
				SendStringBlock(REMOTE_UART,"Error in Stage 0\n");
				SendCharBlock(REMOTE_UART,'\0');
		}
		Decimation = 0;
	}

	Stage = 4;
	for(Stage = 4; Stage < 28; Stage+=4) {
		if (Decimation >= 10) {
			M |= (10<<Stage);
		} else {
			switch (Decimation) {
				case 2 : M |= (2<<Stage); break;
				case 4 : M |= (4<<Stage); break;
				default: M |= (1<<Stage); break;
			}
		}
		Decimation = Decimation/10;
	} 
	WRITE_INT(SAMPLINGFREQADDR,M);
	Stage = READ_INT(SAMPLINGFREQADDR);
//	printf("SAMPLINGFREQADDR write = %d read = %d\n",M,Stage);
	
	
	Stage = 0;
	for(M = AACFilterStart; M < AACFilterStop; ++M){
		Stage |= (1 << M);  
	}
	if ((AACFilterStart == 0) && (AACFilterStop != 0)){	
	/* these are the addertree filter settings */	
		if (SamplingFrequency < 250000000) { 
			Stage |= (3 << 30); /* bartlett window with 15 coeffs */
		} else if (SamplingFrequency == 250000000) {
			Stage |= (2 << 30); /* bartlett window with 7 coeffs */
		} else if (SamplingFrequency == 500000000) {
			Stage |= (2 << 30); /* bartlett window with 7 coeffs */
		} else if (SamplingFrequency == 1000000000) {
			Stage |= (1 << 30); /* bartlett window with 3 coeffs */
		} else {
			Stage |= (3 << 30); /* bartlett window with 15 coeffs */
		}	
	}	      
	WRITE_INT(FILTERENABLEADDR,Stage);

	WRITE_INT(TRIGGERSTORAGEMODEADDR,TRIGGERSTORAGEMODE4CH);
	switch (SampleSize) {
		case 8:
			switch (noChannels) {
				case 1:
					if (FMode != 0){
						WRITE_INT(TRIGGERSTORAGEMODEADDR, TRIGGERSTORAGEMODE1CH);
					}
					WRITE_INT(INPUTCH0ADDR, Ch0);
					WRITE_INT(INPUTCH1ADDR, Ch0);
					WRITE_INT(INPUTCH2ADDR, Ch0);
					WRITE_INT(INPUTCH3ADDR, Ch0);
					break;
				case 2:
					if (FMode != 0){
						WRITE_INT(TRIGGERSTORAGEMODEADDR, TRIGGERSTORAGEMODE2CH);
					}
					WRITE_INT(INPUTCH0ADDR, Ch0);
					WRITE_INT(INPUTCH1ADDR, Ch1);
					WRITE_INT(INPUTCH2ADDR, Ch0);
					WRITE_INT(INPUTCH3ADDR, Ch1);
					break;
				case 4:
					WRITE_INT(INPUTCH0ADDR, Ch0);
					WRITE_INT(INPUTCH1ADDR, Ch1);
					WRITE_INT(INPUTCH2ADDR, Ch2);
					WRITE_INT(INPUTCH3ADDR, Ch3);
					break;
				default : 
					return FALSE;
			       break;
			}
			break;
		case 16: 
			switch (noChannels) {
				case 1:
					if (FMode != 0){
						WRITE_INT(TRIGGERSTORAGEMODEADDR, TRIGGERSTORAGEMODE2CH);
					}
					WRITE_INT(INPUTCH0ADDR, Ch0);
					WRITE_INT(INPUTCH1ADDR, Ch0+4);
					WRITE_INT(INPUTCH2ADDR, Ch0);
					WRITE_INT(INPUTCH3ADDR, Ch0+4);
					break;
				case 2:
					WRITE_INT(INPUTCH0ADDR, Ch0);
					WRITE_INT(INPUTCH1ADDR, Ch0+4);
					WRITE_INT(INPUTCH2ADDR, Ch1);
					WRITE_INT(INPUTCH3ADDR, Ch1+4);
					break;
				default : 
					return FALSE;
			       break;
			}
			break;
		default : 
			return FALSE;
			break;
	}
	return TRUE;
}

/* reference time in samples*/
uint32_t SetTrigger(
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
		return FALSE;
	}
	if (TriggerPrefetchSamples >= (TRIGGER_MEM_SIZE-16)){
		return FALSE;
	}
	if (Trigger >= MAX_TRIGGER_TYPES){
		return FALSE;
	}
	if (ExtTrigger > MAX_EXT_TRIGGER) {
		return FALSE;
	}
	WRITE_INT(TRIGGERTYPEADDR,	Trigger);
	WRITE_INT(EXTTRIGGERSRCADDR,	ExtTrigger);
	WRITE_INT(TRIGGERLOWVALUEADDR,	LowReference);
	WRITE_INT(TRIGGERLOWTIMEADDR,	LowReferenceTime);
	WRITE_INT(TRIGGERHIGHVALUEADDR, HighReference);
	WRITE_INT(TRIGGERHIGHTIMEADDR,	HighReferenceTime);
	WRITE_INT(TRIGGERPREFETCHADDR,	TriggerPrefetchSamples);
    return TRUE;
}


uint32_t CalibrateDAC(uint32_t Ch){
	/* set the Trigger tempoarly to force triggering 
	 * set the analog Ch tempoarly to AC 
	 * capture data 
	 * sum of data / data samples
	 * set the DAC
	 * goto capture data until sum of data is exeptable low */ 
}

uint32_t SetDACOffset(uint32_t Ch, int32_t Offset){
	int32_t temp;
	switch(Ch) {
		case 0: temp = SET_OFFSET_CH0(Offset); break;
		case 1: temp = SET_OFFSET_CH1(Offset); break;
		default: return FALSE;
	}
	WRITE_INT(ANALOGSETTINGSADDR,temp);
	WaitUntilMaskedAndZero(ANALOGSETTINGSADDR, (1 << ANALOGSETTINGSBUSY));
	return TRUE;
}

/* 12 bit DAC compability with the 16 bit DACs of this familie */
#define MIN_DAC_COUNT 16

void AddDACOffset(uint32_t Ch, int32_t Offset){
	static int32_t dac[4] = {16384,16384,16384,16384};
	if ((Ch < 4) && (Offset != 0)){
		dac[Ch] = dac[Ch] + Offset*MIN_DAC_COUNT;
		if (dac[Ch] > (32768-1)) dac[Ch] = 32768;
		if (dac[Ch] < 0) dac[Ch] = 0;
		SetDACOffset(Ch, dac[Ch]);
	}
}

uint32_t SetVoltageRangeBits(uint32_t Ch, const SetAnalog * Settings){
	uint32_t temp = 0;
	if (Settings[Ch].myVperDiv < 1000000) {
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"CH0_K1_OFF\n");
		temp = (1 << CH0_K1_OFF);
	} else {
//		temp = (1 << CH0_K1_ON);
	}
	if (Settings[Ch].myVperDiv < 100000) {
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"CH0_K2_OFF\n");
		temp |= (1 << CH0_K2_OFF);
	} else {
//		temp |= (1 << CH0_K2_ON);
	}
/*	if ((READ_INT(KEYADDR1) & (1 << BTN_AUTOSCALE)) != 0){
		temp = (1 << CH0_K1_ON);
	} else {
		temp = (1 << CH0_K1_OFF);
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_SAVERECALL)) != 0) {
		temp |= (1 << CH0_K2_ON);
	} else {
		temp |= (1 << CH0_K2_OFF);
	}*/
	if (Settings[Ch].myVperDiv >= 100000) {
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"CH0_OPA656\n");
		temp |= (1 << CH0_OPA656);
	}
	

	switch(Settings[Ch].myVperDiv % 9){
	case 5:   /* fall through */
	case 4: temp |= (1 << CH0_U13);
	case 2: temp |= (1 << CH0_U14); break; 
	case 1: break;
	default: printf("WARNING: myVperDiv is set wrong!\n");
	}
	return temp;
}

/* For the analog settings only one SFR does exsist!
 * The benefit of it is the low logic usage and the possibility to use
 * bits in the software which aren't known while the hardware development
 * was done!
 * The Drawback is that only the last write access could be read back and
 * other previos settings (other mux adress) are hidden! */

uint32_t SetAnalogInputRange(
		const uint32_t NoCh, 
		const SetAnalog * Settings) 
{
	uint32_t bank5 = 0;
	uint32_t bank7 = 0;
	uint32_t temp;
	uint32_t j = 0;
	
/*	temp = SET_ANALOG(7);
	WRITE_INT(ANALOGSETTINGSADDR,temp);
	WaitUntilMaskedAndZero(ANALOGSETTINGSADDR, (1 << ANALOGSETTINGSBUSY));

	temp = SET_ANALOG(7) | (1 << CH0_OPA656);
	WRITE_INT(ANALOGSETTINGSADDR,temp);
	WaitUntilMaskedAndZero(ANALOGSETTINGSADDR, (1 << ANALOGSETTINGSBUSY));

	for (dac = 100; dac < 32000; dac+=100){
		temp = SET_OFFSET_CH0(dac);
		WRITE_INT(ANALOGSETTINGSADDR,temp);
		WaitUntilMaskedAndZero(ANALOGSETTINGSADDR, (1 << ANALOGSETTINGSBUSY));
		temp = SET_OFFSET_CH1(dac);
//		WRITE_INT(ANALOGSETTINGSADDR,temp);
		WaitUntilMaskedAndZero(ANALOGSETTINGSADDR, (1 << ANALOGSETTINGSBUSY));
//		WaitMs(1000);
	}
*/
	for (j = 0; j < NoCh; ++j) {
/*		switch (Settings[j].Mode){
		case normal: 	bank5 |= (SRC2_NONE    << (CH0_SRC2_ADDR+(2*j))); break;
		case pwm_offset:bank5 |= (SRC2_PWM     << (CH0_SRC2_ADDR+(2*j))); break;
		case gnd:	bank5 |= (SRC2_GND     << (CH0_SRC2_ADDR+(2*j))); break;
		case lowpass:	bank5 |= (SRC2_LOWPASS << (CH0_SRC2_ADDR+(2*j))); break;
		default: 	return FALSE;	break;*
		}*/
		if (Settings[j].AC == 0){
			bank7 |= 1 << (CH0_DC+j);
		}
		if (Settings[j].DA_Offset != 0){
		//	SetDACOffset(j,Settings[j].DA_Offset);
			temp = SET_ANALOG(ANC_DAC0) | (0x4F << 16);	
		}

	}
	switch(NoCh){
	case 2:	bank5 |= SET_ANALOG(ANC_CH1) | SetVoltageRangeBits(1,Settings);
		WRITE_INT(ANALOGSETTINGSADDR,bank5);
		WaitUntilMaskedAndZero(ANALOGSETTINGSADDR, (1 << ANALOGSETTINGSBUSY));
	case 1:	bank7 |= SET_ANALOG(ANC_CH0) | SetVoltageRangeBits(0,Settings); 
		WRITE_INT(ANALOGSETTINGSADDR,bank7);
		WaitUntilMaskedAndZero(ANALOGSETTINGSADDR, (1 << ANALOGSETTINGSBUSY));
		break;
	default: return FALSE;
	}
	return TRUE;
}

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
				        uint32_t ret = TRUE;	
					int * ADCConfig = (uint32_t *)CONFIGADCENABLE; 
					*ADCConfig = ~1;/* low active, one ADC */
					WaitMs(2); /* Wait until the AVR is ready */

					if (SendADCSerialConfig(adc_uart, cmds, sizeof(cmd)) == FALSE) {
						return FALSE;
					}
					if (((1 << ADC_SPEC_PGM_CLK) & cmd) != 0){
					       temp = (uint8_t)(cmd >> ADC_SPEC_CLKF);
					       ret   = SendADCSerial(adc_uart, ADC_ADDR_CLK,temp);
					       if (ret != temp) {
						       return FALSE;
					       }
					}       
					if (((1 << ADC_SPEC_PGM_OFS) & cmd) != 0){
						temp = (uint8_t)(cmd >> ADC_SPEC_OTIME);
						ret  = SendADCSerial(adc_uart, ADC_ADDR_OFFSETD,temp);
						if (ret != temp) {
						       return FALSE;
						}
					}
					if ((( 1 << ADC_SPEC_PGM_PAT) & cmd) != 0){
						temp = (uint8_t)(cmd >> ADC_SPEC_PATTERN);
						ret  = SendADCSerial(adc_uart, ADC_ADDR_OFFSETD,temp);
						if (ret != temp) {
						       return FALSE;
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

					return TRUE;	
				}
				
			default: 
				return FALSE;
				break;
		}
	}

	return TRUE;
}
#endif

int FastCapture(
		const uint32_t WaitTime, /* just a integer */
		uint32_t CaptureSize,    /* size in DWORDs*/
		uint32_t * RawData) 
{
	uint32_t i = 0;
	uint32_t * StopAddr = 0;
	volatile uint32_t * Addr = 0;
	uint32_t StartSize = 8;
	uint32_t StartData[8] = {0,0,0,0,0,0,0,0};
	/* The compiler has bugs in the loop optimisation with the keyword volatile 
	 * even with function call to get the data from an hw address + masking in a condition */
	volatile uint32_t StopOffset = 0; 
	volatile uint32_t temp = 0; 

	WRITE_INT(TRIGGERONCEADDR, 0);
	WRITE_INT(TRIGGERONCEADDR, 1);

	if (WaitTimeoutAndNotZero(TRIGGERSTATUSREGISTER, 
			(1 << TRIGGERRECORDINGBIT), WaitTime) == FALSE) {
		return 0;
	}
	StopOffset = READ_INT(TRIGGERREADOFFSETADDR);
	StopAddr = (uint32_t *)(TRIGGER_MEM_BASE_ADDR + StopOffset);

	StopAddr++; /* matching 0 to end-1 */
	if ((uint32_t)StopAddr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
		StopAddr =  (uint32_t *) TRIGGER_MEM_BASE_ADDR;
	}
	Addr = StopAddr;

#ifdef LEON3
	WRITE_INT(DEVICEADDR,(uint32_t)Addr);
	
	/* The folowing lines solve a feature in the hardware trigger, 
	 * which is overwriting up the first 7 samples at the end!       
	 * It is caused, because the trigger always writes 8 Samples per Channel at once */
	StopOffset = (StopOffset +8) & (TRIGGER_MEM_SIZE-1); /* mod 2^n */
/*	i = 0;
	while(1){
		temp = READ_INT(TRIGGERCURRENTADDR); 
		if ((StopOffset < temp) || ((StopOffset-temp) > 8)){
			break;
		}
		if (i/256 == WaitTime){
			printf("Timeout: The Trigger captures too slow!\n");
			return 0;
		}
		i++;
	}
	if (8 > CaptureSize){
		StartSize = CaptureSize;
	} else {
		StartSize = 8;
	}*/

	for (i = 0; i < StartSize; ++i){
		StartData[i] = Addr[0];
		Addr++;
		if ((uint32_t)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
			Addr =  (uint32_t *) TRIGGER_MEM_BASE_ADDR;
		}
	}
	i = 0;
	Addr = StopAddr;
	if ((TRIGGER_MEM_SIZE/sizeof(uint32_t)) < CaptureSize){
		CaptureSize = TRIGGER_MEM_SIZE/sizeof(uint32_t);
	}
#endif
	/* Wait until the trigger buffer is full */
	WaitUntilMaskedAndZero(TRIGGERSTATUSREGISTER, (1 << TRIGGERRECORDINGBIT));
#ifdef LEON3
/*	CaptureR->DeviceAddr = (uint32_t) CaptureSize;*/
	while ((i < CaptureSize)){
		RawData[i] = Addr[0];
		i++;
		Addr++;	
		if ((uint32_t)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
			Addr =  (uint32_t *) TRIGGER_MEM_BASE_ADDR;
			WRITE_INT(DEVICEADDR, i);
		}
	}
#else
	StopOffset++;
	i = TRIGGER_MEM_SIZE -StopOffset;
	if ( i > 0 ){
		RemoteReceive(TRIGGER_MEM_BASE_ADDR+StopOffset,&RawData[0],i);
	}
	if (StopOffset != 0){
		RemoteReceive(TRIGGER_MEM_BASE_ADDR+StopOffset,&RawData[i],StopOffset);
	}
#endif
	/* The Trigger has a feature that the last 8 DWORDS! overwrites up 
	 * to the fist 8 DWORDS!*/
	for (i = 0; i < StartSize; ++i){
		temp = READ_INT(TRIGGERSTORAGEMODEADDR);
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
uint32_t CaptureData(
		const uint32_t WaitTime, /* just a integer */
		uint32_t Start,
		uint32_t ForceFastMode,
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
	
	if ((FMode != 0) || ForceFastMode == TRUE) {
		return FastCapture(WaitTime,CaptureSize, RawData);
	} 
	printf("Record Normal\n");

	if (Start != FALSE) {
		WRITE_INT(TRIGGERONCEADDR, 0);
		WRITE_INT(TRIGGERONCEADDR, 1);
		if (WaitTimeoutAndNotZero(TRIGGERSTATUSREGISTER, 
					(1 << TRIGGERRECORDINGBIT), WaitTime) == FALSE) {
			return 0;
		}
		Addr = (uint32_t *)TRIGGER_MEM_BASE_ADDR + StopAddr;
	}
	i = 0;
	StopAddr = READ_INT(TRIGGERREADOFFSETADDR) +1;
	
	while (1) {
		temp = READ_INT(TRIGGERSTATUSREGISTER);
		if (((1 << TRIGGERRECORDINGBIT) & temp) == 0) {
			return i;
		}
		if ((i == CaptureSize)){
			return i;
		}
		Frame = READ_INT(TRIGGERCURRENTADDR); /* stoppoint of readable DWORDS */
		Frame = Frame - (uint32_t)Addr;
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
			if ((uint32_t)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
				Addr =  (uint32_t *) TRIGGER_MEM_BASE_ADDR;
				WRITE_INT(DEVICEADDR,i);
			}
		}
		WRITE_INT(TRIGGERREADOFFSETADDR, (uint32_t)Addr-1); 
		/* & (TRIGGER_MEM_SIZE-1); hw SFR mod 2^bits */
	/*	puts("."); */

	}
	return i;
}
