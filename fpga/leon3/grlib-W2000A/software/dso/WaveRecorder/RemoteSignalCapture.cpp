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
#ifndef	WINNT
#include	<unistd.h>
#endif
#include "DSO_SFR.h"
#include "LEON3_DSU.h"
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
	memcpy(&SendData[1],Data,Length*sizeof(uint32_t));
	Length = mComm->Send(SendData,Length+1);
	delete SendData;
	SendData = 0;
	return Length;
}

uint32_t RemoteSignalCapture::Receive(uint32_t Addr){
	AddrData[0] = Addr;
	AddrData[0] = mComm->Receive(AddrData,2);
	return AddrData[1];
}

uint32_t RemoteSignalCapture::Receive(uint32_t Addr, uint32_t *Data, uint32_t & Length){
	uint32_t * SendData = new uint32_t[Length+2];
	int32_t l = 0;
	if (SendData == 0){
		return 0;
	}
	SendData[0] = Addr;
	SendData[1] = Length;
	Length = mComm->Receive(SendData,Length);
	l = Length -1;
	for (int32_t i = 0; i < l; ++i){
		Data[i] = SendData[i+2];
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

uint32_t RemoteSignalCapture::SendRetry(
		uint32_t addr,
		uint32_t data) {
	uint32_t i = 0;
	uint32_t read = 0;
	for (i = 0; i < 32; ++i){
		Send(addr,data);
		read = Receive(addr);
		if (data == read) break;
		mComm->ClearBuffer();
		mComm->Resync();
		WaitMs(10);
	}
	return i;
}

uint32_t RemoteSignalCapture::SendRetry(
		uint32_t addr,
		uint32_t * data,
		uint32_t & length) {
	uint32_t i = 0;
	uint32_t j = 0;
	uint32_t k = 0;
	uint32_t read = 0;
	uint32_t * RecData = new uint32_t[length];
	for (i = 0; i < 32; ++i){
		k = length-j;
		Send(addr+j*sizeof(uint32_t),&data[j],k);
		read = Receive(addr+j*sizeof(uint32_t),&RecData[j], k);
		if (read != k){
			mComm->ClearBuffer();
			mComm->Resync();
			j = j+read-k;
		}
		for(; j < length; ++j){
			if (data[j] != RecData[j]) {
				mComm->ClearBuffer();
				mComm->Resync();
				break;
			}	
		}
		if (j == length) break;
	}
	length = j;
	delete RecData;
	RecData = 0;
	return i;
}

uint32_t RemoteSignalCapture::LoadProgram( 
		const char * FileName, 
		uint32_t StartAddr,
		uint32_t StackAddr){
	
	FILE * hFile = fopen(FileName,"rb");
	uint32_t addr = StartAddr;
	uint32_t i = 0;
	uint32_t read = 0;
	uint32_t data = 0;
	uint32_t DataArray[8];

	if (hFile == NULL) {
		printf("Binary program file not found!\n");
		return FALSE;
	}
	/* Stop the CPU */
	AddrData[0] = DSU_CTL;
	read = mComm->Receive(AddrData,2);
	if (read == 0){
		printf("Target does not respond!\n");
		fclose(hFile);
		return FALSE;
	}
	Send(DSU_BASE_ADDR,(AddrData[1] | DSU_HL));

	/* write the binary file into the RAM */
	while (feof(hFile) == FALSE){
		read = fread(DataArray,4,8,hFile);
		if (read == 0) {
			break;
/*			printf("Unexpected end of file!\n");
			return FALSE;*/
		}
		i = SendRetry(addr,DataArray,read);
		addr+=read*sizeof(uint32_t);
		if (i == 32) {
			printf("Transmission error on addr 0x%8x!\n", addr);
			fclose(hFile);
			return FALSE;
		}
		
		if (addr % 0x100 == 0){
			printf("\naddr 0x%x\n",addr);
		}
	}
	/* Clear the REGFILE */
	for(i = 0; i < NWINDOWS*WINDOW_SIZE/4; ++i){
		SendRetry(DSU_REGFILE + i*4,0);
	}
	/* Set the StackAddr */
	addr = DSU_REGFILE + (START_WINDOW*WINDOW_SIZE) + REG_OUT_OFF;
	SendRetry(addr,StackAddr);
	
	/* Set the start register window */
	SendRetry(DSU_REG_WIM,START_WINDOW);

	/* Set the Trap Base Register */
	SendRetry(DSU_REG_TBR,START_TBR);

	/* RUN */
	AddrData[0] = DSU_CTL;
	AddrData[0] = mComm->Receive(AddrData,2);
	Send(DSU_BASE_ADDR,(AddrData[1] | DSU_PE));
	fclose(hFile);
	return TRUE;
}

