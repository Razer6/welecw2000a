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
#include "DebugComm.h"
#include "PCUart.h"

RemoteSignalCapture::RemoteSignalCapture(DebugComm * Comm): mComm(Comm){}

uint32_t RemoteSignalCapture::InitComm(
		char * Device, 
		const uint32_t TimeoutMS, 
		const uint32_t Baudrate,
		char * IPAddr)  
{
	return mComm->Init(Device,TimeoutMS,Baudrate,IPAddr);
}

uint32_t RemoteSignalCapture::Send(uint32_t Addr, uint32_t Data){
	return mComm->Send(Addr,&Data,1);
}

uint32_t RemoteSignalCapture::Receive(uint32_t Addr){
	uint32_t Data;
	mComm->Receive(Addr,&Data,1);
	return Data;
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
	return false;
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
	PrintSFR();
    return true;
}


uint32_t RemoteSignalCapture::SendAnalogInput(
		const uint32_t NoCh, 
		const SetAnalog * Settings) 
{
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
	mComm->Receive(DSO_SFR_BASE_ADDR,Data,Length);
//	PrintDesc(Data,Length);
}

uint32_t RemoteSignalCapture::SendRetry(
		uint32_t addr,
		uint32_t data) {
	uint32_t i = 0;
	uint32_t read = 0;
	uint32_t RecData;
	for (i = 0; i < 32; ++i){
		mComm->Send(addr,&data,1);
		read = mComm->Receive(addr,&RecData,1);
		if ((read == 1) && (data == RecData)) break;
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
		mComm->Send(addr+j*sizeof(uint32_t),&data[j],k);
		read = mComm->Receive(addr+j*sizeof(uint32_t),&RecData[j], k);
		if (read != k){
			mComm->ClearBuffer();
			mComm->Resync();
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

	read = mComm->Receive(DSU_CTL,&data,1);
	if (read == 0){
		printf("Target does not respond!\n");
		fclose(hFile);
		return FALSE;
	}
	Send(DSU_CTL,(data | DSU_HL));

	/* write the binary file into the RAM */
	while (feof(hFile) == FALSE){
		read = fread(DataArray,4,8,hFile);
		if (read == 0){
			break;
		}
		if ((unsigned int)read > 8) {
			printf("Unexpected error\n");
			read = 1;
			//return FALSE;
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

	/* Set the start address */
	SendRetry(DSU_REG_PC,START_TBR);
	SendRetry(DSU_REG_PC+4,START_TBR+4);

	/* RUN */
	addr = DSU_CTL;
	read = mComm->Receive(DSU_CTL,&data,1);
	Send(DSU_CTL,(data | DSU_PE));
	fclose(hFile);
	return TRUE;
}

