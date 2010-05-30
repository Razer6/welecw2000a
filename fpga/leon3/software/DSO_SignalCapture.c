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
#include "DSO_Remote.h"
#include "DSO_Main.h"

#ifdef LEON3
#include "Leon3Uart.h"
#include "rprintf.h"
#else
#define rprintf printf
/* do not add this to DSO_Remote.c or so!*/
#define SendStringBlock(...)
#define SendCharBlock(...)
#endif

/*volatile CaptureRegs    * volatile CaptureR;
 volatile TriggerRegs    * volatile TriggerR;
 volatile AnalogSettings * volatile AnalogR;
 volatile uart_regs      * volatile adc_uart;*/

static uint32_t FMode;

uint32_t FastMode(const uint32_t SamplingFrequency, const uint32_t CPUFrequency)
{
	return SamplingFrequency > (CPUFrequency / FASTMODEFACTOR);
}
uint32_t IsFastMode()
{
	return FMode;
}

uint32_t InitSignalCapture()
{
	/*	CaptureR = (CaptureRegs *)   DEVICEADDR;
	 TriggerR = (TriggerRegs *)   TRIGGERONCHADDR;
	 AnalogR  = (AnalogSettings *)ANALOGSETTINGSBANK7;
	 adc_uart = (uart_regs *)     UART_CHCFG_BASE_ADDR;*/
	/*	UartInit(FIXED_CPU_FREQUENCY, DSO_CHCFG_BAUDRATE,
	 ENABLE_RX | ENABLE_TX, adc_uart);*/
	return TRUE;
}

uint32_t SetTriggerInput(const uint32_t noChannels, const uint32_t SampleSize,
							const uint32_t SamplingFrequency,
							const uint32_t CPUFrequency,
							const uint32_t AACFilterStart,
							const uint32_t AACFilterStop, const uint32_t Ch0,
							const uint32_t Ch1, const uint32_t Ch2,
							const uint32_t Ch3)
{
	FMode = FastMode(SamplingFrequency, CPUFrequency);
	uint32_t Stage = 0;
	uint32_t M = 0;

	if((Ch0 > 3) || (Ch1 > 3) || (Ch2 > 3) || (Ch3 > 3))
	{
		return FALSE;
	}

	uint32_t x;

	switch(SamplingFrequency)
	{
		case 1000000000: 	x = 0x11111111;		break;		// 1 GS/s

		case 500000000: 	x = 0x11111112;		break;		// 500 MS/s
		case 250000000: 	x = 0x11111114;		break;		// 250 MS/s
		case 125000000: 	x = 0x11111118;		break;		// 125 MS/s
		case 100000000: 	x = 0x1111111A;		break;		// 100 MS/s

		case 62500000:		x = 0x11111128;		break;		// 62.5 MS/s
		case 50000000: 		x = 0x1111112A;		break;		// 50 MS/s
		case 31250000:		x = 0x11111148;		break;		// 31.25 MS/s
		case 25000000: 		x = 0x1111114A;		break;		// 25 MS/s
		case 12500000:		x = 0x111111A8;		break;		// 12.5 MS/s
		case 10000000:		x = 0x111111AA;		break;		// 10 MS/s

		case 6250000:		x = 0x111112A8;		break;		// 6.25 MS/s
		case 5000000:		x = 0x111112AA;		break;		// 5 MS/s
		case 3125000:		x = 0x111114A8;		break;		// 3.125 MS/s
		case 2500000:		x = 0x111114AA;		break;		// 2.5 MS/s
		case 1250000:		x = 0x11111AA8;		break;		// 1.25 MS/s
		case 1000000:		x = 0x11111AAA;		break;		// 1 MS/s

		case 625000:		x = 0x11112AA8;		break;		// 625 kS/s
		case 500000:		x = 0x11112AAA;		break;		// 500 kS/s
		case 312500:		x = 0x11114AA8;		break;		// 312.5 kS/s
		case 250000:		x = 0x11114AAA;		break;		// 250 kS/s
		case 125000:		x = 0x1111AAA8;		break;		// 125 kS/s
		case 100000:		x = 0x1111AAAA;		break;		// 100 kS/s

		case 62500:			x = 0x1112AAA8;		break;		// 62.5 kS/s
		case 50000:			x = 0x1112AAAA;		break;		// 50 kS/s
		case 31250:			x = 0x1114AAA8;		break;		// 31.25 kS/s
		case 25000:			x = 0x1114AAAA;		break;		// 25 kS/s
		case 12500:			x = 0x111AAAA8;		break;		// 12.5 kS/s
		case 10000:			x = 0x111AAAAA;		break;		// 10 kS/s

		default: 			x = 0x11111111;		break;
	}

	WRITE_INT(SAMPLINGFREQADDR,x);
	//	printf("SAMPLINGFREQADDR write = %d read = %d\n",M,Stage);

	for(M = AACFilterStart; M < AACFilterStop; ++M)
	{
		Stage |= (1 << M);
	}

	if((AACFilterStart == 0) && (AACFilterStop != 0))
	{
		/* these are the addertree filter settings */
		if(SamplingFrequency < 250000000)
		{
			Stage |= (3 << 30); /* bartlett window with 15 coeffs */
		}
		else if(SamplingFrequency == 250000000)
		{
			Stage |= (2 << 30); /* bartlett window with 7 coeffs */
		}
		else if(SamplingFrequency == 500000000)
		{
			Stage |= (2 << 30); /* bartlett window with 7 coeffs */
		}
		else if(SamplingFrequency == 1000000000)
		{
			Stage |= (1 << 30); /* bartlett window with 3 coeffs */
		}
		else
		{
			Stage |= (3 << 30); /* bartlett window with 15 coeffs */
		}
	}
	WRITE_INT(FILTERENABLEADDR,Stage);

	WRITE_INT(TRIGGERSTORAGEMODEADDR,TRIGGERSTORAGEMODE4CH);
	switch(SampleSize)
	{
		case 8:
			switch(noChannels)
			{
				case 1:
					if(FMode != 0)
					{
						WRITE_INT(TRIGGERSTORAGEMODEADDR, TRIGGERSTORAGEMODE1CH);
					}
					WRITE_INT(INPUTCH0ADDR, Ch0);
					WRITE_INT(INPUTCH1ADDR, Ch0);
					WRITE_INT(INPUTCH2ADDR, Ch0);
					WRITE_INT(INPUTCH3ADDR, Ch0);
					break;
				case 2:
					if(FMode != 0)
					{
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
				default:
					return FALSE;
					break;
			}
			break;
		case 16:
			switch(noChannels)
			{
				case 1:
					if(FMode != 0)
					{
						WRITE_INT(TRIGGERSTORAGEMODEADDR, TRIGGERSTORAGEMODE2CH);
					}
					WRITE_INT(INPUTCH0ADDR, Ch0);
					WRITE_INT(INPUTCH1ADDR, Ch0);
					WRITE_INT(INPUTCH2ADDR, Ch0+4);
					WRITE_INT(INPUTCH3ADDR, Ch0+4);
					break;
				case 2:
					WRITE_INT(INPUTCH0ADDR, Ch0);
					WRITE_INT(INPUTCH1ADDR, Ch1);
					WRITE_INT(INPUTCH2ADDR, Ch0+4);
					WRITE_INT(INPUTCH3ADDR, Ch1+4);
					break;
				default:
					return FALSE;
					break;
			}
			break;
		default:
			return FALSE;
			break;
	}
	return TRUE;
}

/*
void setTrigger(sTriggerSettings *settings)
{
	WRITE_INT(TRIGGERTYPEADDR, settings->type+settings->edge);
	WRITE_INT(EXTTRIGGERSRCADDR, 0);
	WRITE_INT(TRIGGERONCHADDR, settings->channel);
	WRITE_INT(TRIGGERLOWVALUEADDR, LowReference);
	WRITE_INT(TRIGGERLOWTIMEADDR, LowReferenceTime);
	WRITE_INT(TRIGGERHIGHVALUEADDR, HighReference);
	WRITE_INT(TRIGGERHIGHTIMEADDR, HighReferenceTime);
	WRITE_INT(TRIGGERPREFETCHADDR, TriggerPrefetchSamples);
}
*/

/* reference time in samples*/
uint32_t SetTrigger(const uint32_t Trigger, const uint32_t ExtTrigger,
					const uint32_t TriggerChannel,
					const uint32_t TriggerPrefetchSamples,
					const int LowReference, const uint32_t LowReferenceTime,
					const int HighReference, const uint32_t HighReferenceTime)
{
	if(TriggerChannel > 3)
	{
		return FALSE;
	}
	if(TriggerPrefetchSamples >= (TRIGGER_MEM_SIZE - 16))
	{
		return FALSE;
	}
	if(Trigger >= MAX_TRIGGER_TYPES)
	{
		return FALSE;
	}
	if(ExtTrigger > MAX_EXT_TRIGGER)
	{
		return FALSE;
	}
	WRITE_INT(TRIGGERTYPEADDR, Trigger);
	WRITE_INT(EXTTRIGGERSRCADDR, ExtTrigger);
	WRITE_INT(TRIGGERONCHADDR, TriggerChannel);

	WRITE_INT(TRIGGERLOWVALUEADDR, LowReference);
	WRITE_INT(TRIGGERLOWTIMEADDR, LowReferenceTime);

	WRITE_INT(TRIGGERHIGHVALUEADDR, HighReference);
	WRITE_INT(TRIGGERHIGHTIMEADDR, HighReferenceTime);

	WRITE_INT(TRIGGERPREFETCHADDR, TriggerPrefetchSamples);
	return TRUE;
}

uint32_t CalibrateDAC(uint32_t Ch)
{
	/* set the Trigger tempoarly to force triggering 
	 * set the analog Ch tempoarly to AC 
	 * capture data 
	 * sum of data / data samples
	 * set the DAC
	 * goto capture data until sum of data is exeptable low */
	return 0;
}

void DisableDACs(){
	volatile uint32_t RegValue = READ_INT(ANALOGSETTINGSADDR);
	uint32_t i = 0;
	uint32_t data = 0x00800000;
	RegValue |= (7 << ANALOGSETTINGS_MUXADDR_OFFSET);
	RegValue &= ~(ANC_DAC0 << ANALOGSETTINGS_MUXADDR_OFFSET);
	RegValue |= (1 << ANALOGSETTINGS_SERIALCLK); 
	WaitMs(1);
	RegValue &= ~(1 << ANALOGSETTINGS_ENABLE); //low active chip select double inverted
	WRITE_INT(ANALOGSETTINGSADDR,RegValue);
	WaitMs(1);

// Write data
	for (i = 0;i < 24; ++i)
	{
		RegValue |= (1 << ANALOGSETTINGS_SERIALCLK);
		WRITE_INT(ANALOGSETTINGSADDR,RegValue);
		WaitMs(1);
		if ((data & (1 << 23)) != 0 ){
			RegValue &= ~(1 << ANALOGSETTINGS_DATA);
		} else {	 	 
			RegValue |= (1 << ANALOGSETTINGS_DATA);
		}
		data = data << 1;
		WRITE_INT(ANALOGSETTINGSADDR,RegValue);
		WaitMs(1);

		RegValue &= ~(1 << ANALOGSETTINGS_SERIALCLK);
		WRITE_INT(ANALOGSETTINGSADDR,RegValue);
		WaitMs(1);
	}
// output strobe
	RegValue |= (1 << ANALOGSETTINGS_ENABLE);
	WRITE_INT(ANALOGSETTINGSADDR,RegValue);
	WaitMs(1);
}

uint32_t SetDACOffset(uint32_t Ch, int32_t Offset){
	volatile uint32_t RegValue = READ_INT(ANALOGSETTINGSADDR);
	uint32_t i = 0;
	int32_t data = 0;
	switch(Offset) {
	case  2: Offset =   10; break;
	case  3: Offset =  100; break;
	case -2: Offset =  -10; break;
	case -3:
	case -4: Offset = -100; break;
	default:
		Offset = Offset;
	}	
	switch(Ch)
	{
		case 0:
			data = SET_OFFSET_CH0(Offset);
			break;
		case 1:
			data = SET_OFFSET_CH1(Offset);
			break;
		default:
			return FALSE;
	}
// All signals are inversed by transistors
	RegValue |= (7 << ANALOGSETTINGS_MUXADDR_OFFSET);
	RegValue &= ~(ANC_DAC0 << ANALOGSETTINGS_MUXADDR_OFFSET);
	RegValue |= (1 << ANALOGSETTINGS_SERIALCLK); 
	WaitMs(1);
	RegValue |= (1 << ANALOGSETTINGS_ENABLE); //low active chip select double inverted
	WRITE_INT(ANALOGSETTINGSADDR,RegValue);
	WaitMs(1);
// Write data
	for (i = 0;i < 24; ++i)
	{
		RegValue |= (1 << ANALOGSETTINGS_SERIALCLK);
		WRITE_INT(ANALOGSETTINGSADDR,RegValue);
		WaitMs(1);
		if ((data & (1 << 23)) != 0 ){
			RegValue &= ~(1 << ANALOGSETTINGS_DATA);
		} else {	 	 
			RegValue |= (1 << ANALOGSETTINGS_DATA);
		}
		data = data << 1;
		WRITE_INT(ANALOGSETTINGSADDR,RegValue);
		WaitMs(1);
	//	RegValue &= ~(1 << ANALOGSETTINGS_SERIALCLK);
		RegValue |= (7 << ANALOGSETTINGS_MUXADDR_OFFSET);
		WRITE_INT(ANALOGSETTINGSADDR,RegValue);
		WaitMs(1);
	}
// output strobe
	RegValue &= ~(1 << ANALOGSETTINGS_ENABLE);
	WRITE_INT(ANALOGSETTINGSADDR,RegValue);
	WaitMs(1);
	return TRUE;
}

/* 12 bit DAC compability with the 16 bit DACs of this family */
#define MIN_DAC_COUNT 16

void AddDACOffset(uint32_t Ch, int32_t Offset)
{
	static int32_t dac[4] = {16384, 16384, 16384, 16384};
	if((Ch < 4) && (Offset != 0))
	{
		dac[Ch] = dac[Ch] + Offset * MIN_DAC_COUNT;
		if(dac[Ch] > (32768 - 1))
			dac[Ch] = 32768;
		if(dac[Ch] < 0)
			dac[Ch] = 0;
		SetDACOffset(Ch, dac[Ch]);
	}
//	DisableDACs();
}


// All signals are inversed by transistors
void SetExternalAnalogRegister(uint32_t addr, uint32_t data){
	volatile uint32_t RegValue = READ_INT(ANALOGSETTINGSADDR);
	uint32_t i = 0;
// Setting Mux addr
	RegValue |= (7 << ANALOGSETTINGS_MUXADDR_OFFSET);
	RegValue &= ~(addr << ANALOGSETTINGS_MUXADDR_OFFSET);
	RegValue |= (1 << ANALOGSETTINGS_ENABLE); // disabling output strobe
	WRITE_INT(ANALOGSETTINGSADDR,RegValue);
	WaitMs(1);
// Write data
	for (i = 0;i < 16; ++i){
		RegValue |= (1 << ANALOGSETTINGS_SERIALCLK);
		WRITE_INT(ANALOGSETTINGSADDR,RegValue);
		WaitMs(1);
		if ((data & (1 << 15)) != 0 ){
			RegValue &= ~(1 << ANALOGSETTINGS_DATA);
		} else {	 	 
			RegValue |= (1 << ANALOGSETTINGS_DATA);
		}
		data = data << 1;
		WRITE_INT(ANALOGSETTINGSADDR,RegValue);
		WaitMs(1);
		RegValue &= ~(1 << ANALOGSETTINGS_SERIALCLK);
		WRITE_INT(ANALOGSETTINGSADDR,RegValue);
		WaitMs(1);
	}
// output strobe
	RegValue &= ~(1 << ANALOGSETTINGS_ENABLE);
	WRITE_INT(ANALOGSETTINGSADDR,RegValue);
	WaitMs(1);
	RegValue |= (1 << ANALOGSETTINGS_ENABLE);
	WRITE_INT(ANALOGSETTINGSADDR,RegValue);
	WaitMs(1);


}



/* For the analog settings only one SFR does exsist!
 * The benefit of it is the low logic usage and the possibility to use
 * bits in the software which aren't known while the hardware development
 * was done!
 * The Drawback is that only the last write access could be read back and
 * other previous settings (other mux adress) are hidden! */

uint32_t SetAnalogInputRange(uint32_t ch, SetAnalog *settings)
{
	uint32_t temp = 0;
	uint32_t analogRegister;

	if(ch > CH1)
		return FALSE;

	if(settings->DA_Offset == 0)
	{
		//	SetDACOffset(j,Settings[j].DA_Offset);
		//temp = SET_ANALOG(ANC_DAC0) | (0x4F << 16);
	}
	else
	{
		SetDACOffset(ch, settings->DA_Offset);
	}

	switch(settings->myVperDiv)
	{
		case 10000: temp = (1 << CH0_K1_10) | (1 << CH0_K2_10);
		break;
		case 20000: temp = (1 << CH0_K1_10) | (1 << CH0_K2_10) | (1<<CH0_U14);
		break;
		case 50000: temp = (1 << CH0_K1_10) | (1 << CH0_K2_10) | (1<<CH0_OPA656) | (1<<CH0_U13) | (1<<CH0_U14);
		break;
		case 100000: temp = (1 << CH0_K1_10) | (1 << CH0_K2_1);
		break;
		case 200000: temp = (1 << CH0_K1_10) | (1 << CH0_K2_1) | (1<<CH0_U14);
		break;
		case 500000: temp = (1 << CH0_K1_10) | (1 << CH0_K2_1) | (1<<CH0_OPA656) | (1<<CH0_U13) | (1<<CH0_U14);
		break;
		case 1000000: temp = (1 << CH0_K1_1) | (1 << CH0_K2_1);
		break;
		case 2000000: temp = (1 << CH0_K1_1) | (1 << CH0_K2_1) | (1<<CH0_U14);
		break;
		case 5000000: temp = (1<<CH0_K1_1) | (1<<CH0_K2_1) | (1<<CH0_OPA656) | (1<<CH0_U13) | (1<<CH0_U14);
		break;
		default:
		break;
	}

	if(settings->AC == 0)
	{
		temp |= (1 << CH1_DC);
	}

	if(ch == CH0)
	{
		analogRegister = ANC_CH0;
	}
	else
	{
		analogRegister = ANC_CH1;
	}

/*	bank = SET_ANALOG(analogRegister) | temp;
	WRITE_INT(ANALOGSETTINGSADDR, bank);
	WaitUntilMaskedAndZero(ANALOGSETTINGSADDR, (1 << ANALOGSETTINGSBUSY));*/
	SetExternalAnalogRegister(analogRegister, temp);
	return TRUE;
}


#if 0
ADCSerial cmds[]=
{
	{	ADC_ADDR_SPEED, (1 << ADC_PIN_LSPEED)},
	{	ADC_ADDR_POWER, (1 << ADC_PIN_MODE0)},
	{	ADC_ADDR_DFS, (3 << ADC_PIN_DFS0)},
	{	ADC_ADDR_CLK, (5 << ADC_PIN_RISE0)
		| (5 << ADC_PIN_FALL0)},
	{	ADC_ADDR_FORMAT, (2 << ADC_PIN_FORMAT0)},
	{	ADC_ADDR_OFFSETE,(1 << ADC_PIN_OFFSETE)}};
uint32_t cmd = Settings[i].Specific;
uint8_t temp = 0;
uint32_t ret = TRUE;
int * ADCConfig = (uint32_t *)CONFIGADCENABLE;
*ADCConfig = ~1;/* low active, one ADC */
WaitMs(2); /* Wait until the AVR is ready */

if (SendADCSerialConfig(adc_uart, cmds, sizeof(cmd)) == FALSE)
{
	return FALSE;
}
if (((1 << ADC_SPEC_PGM_CLK) & cmd) != 0)
{
	temp = (uint8_t)(cmd >> ADC_SPEC_CLKF);
	ret = SendADCSerial(adc_uart, ADC_ADDR_CLK,temp);
	if (ret != temp)
	{
		return FALSE;
	}
}
if (((1 << ADC_SPEC_PGM_OFS) & cmd) != 0)
{
	temp = (uint8_t)(cmd >> ADC_SPEC_OTIME);
	ret = SendADCSerial(adc_uart, ADC_ADDR_OFFSETD,temp);
	if (ret != temp)
	{
		return FALSE;
	}
}
if ((( 1 << ADC_SPEC_PGM_PAT) & cmd) != 0)
{
	temp = (uint8_t)(cmd >> ADC_SPEC_PATTERN);
	ret = SendADCSerial(adc_uart, ADC_ADDR_OFFSETD,temp);
	if (ret != temp)
	{
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

int FastCapture(const uint32_t WaitTime, /* just a integer */
uint32_t CaptureSize, /* size in DWORDs*/
uint32_t * RawData)
{
	uint32_t i = 0;
	uint32_t * StopAddr = 0;
	volatile uint32_t * Addr = 0;
	uint32_t StartSize = 8;
	uint32_t StartData[8] = {0, 0, 0, 0, 0, 0, 0, 0};
	/* The compiler has bugs in the loop optimisation with the keyword volatile 
	 * even with function call to get the data from an hw address + masking in a condition */
	volatile uint32_t StopOffset = 0;
	volatile uint32_t temp = 0;

	WRITE_INT(TRIGGERONCEADDR, 0);
	WRITE_INT(TRIGGERONCEADDR, 1);

	if(WaitTimeoutAndNotZero(TRIGGERSTATUSREGISTER, (1 << TRIGGERRECORDINGBIT),
								WaitTime) == FALSE)
	{
		return 0;
	}
	StopOffset = READ_INT(TRIGGERREADOFFSETADDR);
	StopAddr = (uint32_t *)(TRIGGER_MEM_BASE_ADDR + StopOffset);

	StopAddr++; /* matching 0 to end-1 */
	if((uintptr_t)StopAddr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE))
	{
		StopAddr = (uint32_t *)TRIGGER_MEM_BASE_ADDR;
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

	for (i = 0; i < StartSize; ++i)
	{
		StartData[i] = Addr[0];
		Addr++;
		if ((uint32_t)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE))
		{
			Addr = (uint32_t *) TRIGGER_MEM_BASE_ADDR;
		}
	}
	i = 0;
	Addr = StopAddr;
	if ((TRIGGER_MEM_SIZE/sizeof(uint32_t)) < CaptureSize)
	{
		CaptureSize = TRIGGER_MEM_SIZE/sizeof(uint32_t);
	}
#endif
	/* Wait until the trigger buffer is full */
	WaitUntilMaskedAndZero(TRIGGERSTATUSREGISTER, (1 << TRIGGERRECORDINGBIT));
#ifdef LEON3
	/*	CaptureR->DeviceAddr = (uint32_t) CaptureSize;*/
	while ((i < CaptureSize))
	{
		RawData[i] = Addr[0];
		i++;
		Addr++;
		if ((uint32_t)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE))
		{
			Addr = (uint32_t *) TRIGGER_MEM_BASE_ADDR;
			WRITE_INT(DEVICEADDR, i);
		}
	}
#else
	StopOffset++;
	i = TRIGGER_MEM_SIZE - StopOffset;
	if(i > 0)
	{
		RemoteReceive(TRIGGER_MEM_BASE_ADDR + StopOffset, &RawData[0], i);
	}
	if(StopOffset != 0)
	{
		RemoteReceive(TRIGGER_MEM_BASE_ADDR + StopOffset, &RawData[i],
						StopOffset);
	}
#endif
	/* The Trigger has a feature that the last 8 DWORDS! overwrites up 
	 * to the fist 8 DWORDS!*/
	for(i = 0; i < StartSize; ++i)
	{
		temp = READ_INT(TRIGGERSTORAGEMODEADDR);
		switch(temp)
		{
			case TRIGGERSTORAGEMODE4CH:
				RawData[i] = StartData[i];
				break;
			case TRIGGERSTORAGEMODE2CH:
				RawData[i] &= 0x0000ffff;
				StartData[i] &= 0xffff0000;
				RawData[i] |= StartData[i];
				break;
			case TRIGGERSTORAGEMODE1CH:
				RawData[i] &= 0x00ffffff;
				StartData[i] &= 0xff000000;
				RawData[i] |= StartData[i];
				break;
		}
	}
	return CaptureSize;
}

/* returns read DWORDS*/
uint32_t CaptureData(const uint32_t WaitTime, /* just a integer */
uint32_t Start, uint32_t ForceFastMode, uint32_t CaptureSize, /* size in DWORDs*/
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

	if((FMode != 0) || ForceFastMode != FALSE)
	{
		return FastCapture(WaitTime, CaptureSize, RawData);
	}
	printf("Record Normal\n");

	if(Start != FALSE)
	{
		WRITE_INT(TRIGGERONCEADDR, 0);
		WRITE_INT(TRIGGERONCEADDR, 1);
		if(WaitTimeoutAndNotZero(TRIGGERSTATUSREGISTER, (1
				<< TRIGGERRECORDINGBIT), WaitTime) == FALSE)
		{
			return 0;
		}
		Addr = (uint32_t *)TRIGGER_MEM_BASE_ADDR + StopAddr;
	}
	i = 0;
	StopAddr = READ_INT(TRIGGERREADOFFSETADDR) + 1;

	while(1)
	{
		temp = READ_INT(TRIGGERSTATUSREGISTER);
		if(((1 << TRIGGERRECORDINGBIT) & temp) == 0)
		{
			return i;
		}
		if((i == CaptureSize))
		{
			return i;
		}
		Frame = READ_INT(TRIGGERCURRENTADDR); /* stoppoint of readable DWORDS */
		Frame = Frame - (uintptr_t)Addr;
		Frame &= (TRIGGER_MEM_SIZE - 1); /* number of readable DWORDS */
		Frame = i + Frame;
		if(Frame > CaptureSize)
		{
			Frame = CaptureSize;
		}
		/* measured 19 clocks per iteration with an sdram and compiler flags -g -O2
		 * measured  8 clocks per iteration with an sdram and compiler flags -O2 */
		while(i < Frame)
		{
			RawData[i] = *Addr;
			i++;
			Addr++;
			if((uintptr_t)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE))
			{
				Addr = (uint32_t *)TRIGGER_MEM_BASE_ADDR;
				WRITE_INT(DEVICEADDR,i);
			}
		}
		WRITE_INT(TRIGGERREADOFFSETADDR, (uintptr_t)Addr-1);
		/* & (TRIGGER_MEM_SIZE-1); hw SFR mod 2^bits */
		/*	puts("."); */

	}
	return i;
}
