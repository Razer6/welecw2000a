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
#include "DSO_SFR.h"
#include "RemoteSignalCapture.h"
#include "DSO_ADC_Control.h"
#include "Communication.h"
#include "PCUart.h"

RemoteSignalCapture::RemoteSignalCapture(Communication * Comm): Request(Comm){}

uint32_t RemoteSignalCapture::Send(uint32_t Addr, uint32_t Data){
	AddrData[0] = Addr;
	AddrData[1] = Data;
	return mComm->Send(AddrData,2);
}

uint32_t RemoteSignalCapture::Send(uint32_t Addr, uint32_t *Data, uint32_t & Length){
	uint32_t * SendData = new uint32_t[Length+1];
	if (SendData == 0) {
		return 0;
	}
	SendData[0] = Addr;
	memcpy(&SendData[1],Data,Length);
	Length = mComm->Send(SendData,Length+1);
	delete SendData;
	SendData = 0;
	return Length;
}

uint32_t RemoteSignalCapture::Receive(uint32_t Addr){
	AddrData[0] = mComm->Receive(&Addr,2);
	return AddrData[1];
}
uint32_t RemoteSignalCapture::Receive(uint32_t Addr, uint32_t *Data, uint32_t & Length){
	uint32_t * SendData = new uint32_t[Length+1];
	if (SendData == 0){
		return 0;
	}
	SendData[0] = Addr;
	SendData[1] = Length;
	SetTimeoutMs(20000);
	Length = mComm->Receive(SendData,Length+1);
	SetTimeoutMs(1000);
	for (uint32_t i = 0; i < Length; ++i){
		Data[i] = SendData[i+1];
	}
	delete SendData;
	SendData = 0;
	return Length;
}

void RemoteSignalCapture::WaitUntilMaskedAndZero(uint32_t Addr, uint32_t Ref){
	while((Receive(Addr) & Ref) != 0);
}

void RemoteSignalCapture::WaitMs(uint32_t Milliseconds){
#ifdef WINNT
	Sleep((DWORD)Milliseconds);
#else
	usleep(Milliseconds*1000);
#endif
}
uint32_t RemoteSignalCapture::SendTriggerInput (	
			const uint32_t noChannels, 
			const uint32_t SampleSize, 
			const uint32_t SamplingFrequency,
			const uint32_t AACFilterStart,
			const uint32_t AACFilterStop,
			const uint32_t Ch0, 
			const uint32_t Ch1, 
			const uint32_t Ch2, 
			const uint32_t Ch3)
{
	uint32_t Decimaton = 0;
	uint32_t Stage = 0;
	uint32_t M = 0;

	if ((Ch0 > 3) || (Ch1 > 3) || (Ch2 > 3) || (Ch3 > 3)) {
		return false;
	}

	for(M = AACFilterStart; M < AACFilterStop; ++M){
	       Stage |= (1 << M);
	}
	Send(FILTERENABLEADDR,Stage);
    
	switch(Receive(DEVICEADDR)){
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

	Send(SAMPLINGFREQADDR,M);

	switch (SampleSize) {
		case 8:
			switch (noChannels) {
				case 1:
					Send(TRIGGERSTORAGEMODEADDR,TRIGGERSTORAGEMODE1CH);
					Send(INPUTCH0ADDR,Ch0);
					Send(INPUTCH1ADDR,Ch0);
					Send(INPUTCH2ADDR,Ch0);
					Send(INPUTCH3ADDR,Ch0);
					break;
				case 2:
					Send(TRIGGERSTORAGEMODEADDR,TRIGGERSTORAGEMODE2CH);
					Send(INPUTCH0ADDR,Ch0);
					Send(INPUTCH1ADDR,Ch1);
					Send(INPUTCH2ADDR,Ch0);
					Send(INPUTCH3ADDR,Ch1);
					break;
				case 4:
					Send(TRIGGERSTORAGEMODEADDR,TRIGGERSTORAGEMODE4CH);
					Send(INPUTCH0ADDR,Ch0);
					Send(INPUTCH1ADDR,Ch1);
					Send(INPUTCH2ADDR,Ch2);
					Send(INPUTCH3ADDR,Ch3);
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
					Send(TRIGGERSTORAGEMODEADDR, TRIGGERSTORAGEMODE2CH);
					Send(INPUTCH0ADDR,Ch0);
					Send(INPUTCH1ADDR,Ch0+4);
					Send(INPUTCH2ADDR,Ch0);
					Send(INPUTCH3ADDR,Ch0+4);
					break;
				case 2:
					Send(TRIGGERSTORAGEMODEADDR, TRIGGERSTORAGEMODE4CH);
					Send(INPUTCH0ADDR,Ch0);
					Send(INPUTCH1ADDR,Ch0+4);
					Send(INPUTCH2ADDR,Ch1);
					Send(INPUTCH3ADDR,Ch1+4);
					break;
				default : 
					return false;
			       break;
			}
			break;
		default : 
			return false;
			break;
	}
	PrintSFR();
	return true;
}

/* reference time in samples*/
uint32_t RemoteSignalCapture::SendTrigger(
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
		return false;
	}
	if (TriggerPrefetchSamples >= (TRIGGER_MEM_SIZE-16)){
		return false;
	}
	if (Trigger >= MAX_TRIGGER_TYPES){
		return false;
	}
	if (ExtTrigger > MAX_EXT_TRIGGER) {
		return false;
	}
	Send(TRIGGERTYPEADDR, Trigger);
	Send(EXTTRIGGERSRCADDR, ExtTrigger);
	Send(TRIGGERLOWVALUEADDR, LowReference);
	Send(TRIGGERLOWTIMEADDR, LowReferenceTime);
	Send(TRIGGERHIGHVALUEADDR, HighReference);
	Send(TRIGGERHIGHTIMEADDR, HighReferenceTime);
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
	PrintSFR();
    return true;
}


uint32_t RemoteSignalCapture::SendAnalogInput(const uint32_t NoCh, 
			 const SetAnalog * Settings) 
{
	uint32_t i = 0;
	uint32_t temp = 0;
	uint32_t j = 0;
	short dac = 0;
	uint32_t Device = Receive(DEVICEADDR);
	for(i = 0; i < NoCh; ++i){
		switch (Device) {
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
					Send(ANALOGSETTINGSBANK7,temp);
					WaitUntilMaskedAndZero(ANALOGSETTINGSBANK7, (1 << ANALOGSETTINGSBUSY));
					/* wait until the coils have switched*/
					WaitMs(COIL_SWITCH_TIME);
					temp &= ~(0xf); /* turn of the coils*/
					Send(ANALOGSETTINGSBANK7,temp);
					
					WaitUntilMaskedAndZero(ANALOGSETTINGSBANK7, (1 << ANALOGSETTINGSBUSY));
					/* Used DAC types are limited to 16 bits per protocol! */
					dac = (short)Settings[i].DA_Offset;
					temp = dac;
					Send(ANALOGSETTINGSBANK6, temp| (i << DAC_CH_OFFSET));
					WaitUntilMaskedAndZero(ANALOGSETTINGSBANK6, (1 << ANALOGSETTINGSBUSY));
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
					Send(ANALOGSETTINGSBANK5,temp);
					WaitUntilMaskedAndZero(ANALOGSETTINGSBANK5, (1 << ANALOGSETTINGSBUSY));
					/* wait until the coils have switched*/
					WaitMs(COIL_SWITCH_TIME);
					temp &= ~(0xf); /* turn of the coils*/
					Send(ANALOGSETTINGSBANK5,temp);
					WaitUntilMaskedAndZero(ANALOGSETTINGSBANK5, (1 << ANALOGSETTINGSBUSY));
				}
				break;
			case SANDBOXX:
				{
					return false;
				}
				
			default: 
				return false;
				break;
		}
	}
	PrintSFR();
	return true;
}

int RemoteSignalCapture::FastCapture(
		const uint32_t WaitTime, /* just a integer */
		uint32_t CaptureSize,    /* size in DWORDs*/
		uint32_t * RawData) 
{
	uint32_t i = 0;
	uint32_t Length = 0;
	uint32_t * StopAddr = 0;
	volatile uint32_t * Addr = 0;
	uint32_t SendLength = 0;
	/* The compiler has bugs in the loop optimisation with the keyword volatile 
	 * even with function call to get the data from an hw address + masking in a condition */
	volatile uint32_t temp = 0; 

	Send(TRIGGERONCEADDR, 0);
	Send(TRIGGERONCEADDR, 1);

	while (Receive(TRIGGERSTATUSREGISTER) & (1 << TRIGGERRECORDINGBIT) != 0)
	{
		i++;
		if (i == WaitTime) {
			return 0;
		}
	}
	temp = Receive(TRIGGERREADOFFSETADDR);
	StopAddr = (uint32_t *)(TRIGGER_MEM_BASE_ADDR + temp);

	StopAddr++; /* matching 0 to end-1 */
	Addr = StopAddr;
	
	/* Wait until the trigger buffer is full */
	WaitUntilMaskedAndZero(TRIGGERSTATUSREGISTER, (1 << TRIGGERRECORDINGBIT));
	
	if (TRIGGER_MEM_SIZE < CaptureSize){
		CaptureSize = TRIGGER_MEM_SIZE;
	}
	if (TRIGGER_MEM_SIZE + temp < CaptureSize){
		Length = (CaptureSize-temp);
		SendLength = Length/sizeof(uint32_t);
		Receive((uint32_t)Addr,RawData,SendLength);
		SendLength = (CaptureSize-Length)/sizeof(uint32_t);
		Receive(TRIGGER_MEM_BASE_ADDR,&RawData[Length],SendLength);
	} else {
		SendLength = CaptureSize;
		Receive((uint32_t)Addr,RawData,SendLength);
	}

	/* The folowing lines "solve" a feature in the hardware trigger, 
	 * which is overwriting up the first 7 samples at the end!       
	 * It is caused, because the trigger always writes 8 Samples per Channel at once */
	/* Here the fist 8 samples are set to zero */
	for (i = 0; i < 8; ++i){
		temp = Receive(TRIGGERSTORAGEMODEADDR);
	       switch (temp) {
			case TRIGGERSTORAGEMODE4CH:
				RawData[i]   = 0;
				break;
			case TRIGGERSTORAGEMODE2CH:
				RawData[i]   &= 0x0000ffff;
				break;
			case TRIGGERSTORAGEMODE1CH:
				RawData[i]   &= 0x00ffffff;
				break;
	       }
	}
	return TRIGGER_MEM_SIZE;
}

/* returns read DWORDS*/
uint32_t RemoteSignalCapture::ReceiveSamples(
			const uint32_t WaitTime, /* just a integer */
			const uint32_t Start,
			uint32_t CaptureSize,    /* size in DWORDs*/
			uint32_t * FastMode,
			uint32_t * RawData) 
{
	PrintSFR();
	return FastCapture(WaitTime,CaptureSize, RawData);
}

void RemoteSignalCapture::PrintSFR(){
	uint32_t Data[DSO_REG_SIZE/sizeof(uint32_t)];
	uint32_t Length = DSO_REG_SIZE/sizeof(uint32_t);
	Receive(DSO_SFR_BASE_ADDR,Data,Length);
	PrintDesc(Data,Length);
}