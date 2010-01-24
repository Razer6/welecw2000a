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
#ifdef	WINNT
#include "Windows.h"
#else
#include <unistd.h>
#include <syscall.h> 
#endif
#include "DSO_SFR.h"
#include "LEON3_DSU.h"
#include "RemoteSignalCapture.h"
#include "DSO_ADC_Control.h"
#include "DebugComm.h"
#include "PCUart.h"
#include "DSO_Remote.h"
#include "DSO_Misc.h"
#include "irqmp.h"

RemoteSignalCapture::RemoteSignalCapture(DebugComm * Comm): mComm(Comm){}

uint32_t RemoteSignalCapture::InitComm(
		char * Device, 
		const uint32_t TimeoutMS, 
		const uint32_t Baudrate,
		char * IPAddr)  
{
	InitRemoteComm(mComm);
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
	return SetTriggerInput (
			noChannels, 
			SampleSize, 
			SamplingFrequency,
			FIXED_CPU_FREQUENCY, // TODO
			AACFilterStart,
			AACFilterStop,
			Ch0, 
			Ch1, 
			Ch2, 
			Ch3);
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
	uint32_t succ = FALSE;
	succ = SetTrigger(
			Trigger, 
			ExtTrigger,
			TriggerChannel,
			TriggerPrefetchSamples,
			LowReference,
			LowReferenceTime,
			HighReference,
			HighReferenceTime);
	PrintSFR();
    return succ;
}


uint32_t RemoteSignalCapture::SendAnalogInput(
		const uint32_t NoCh, 
		const SetAnalog * Settings) 
{
	return SetAnalogInputRange(
			NoCh, 
			Settings);
}

/*
int RemoteSignalCapture::Capture(
		const uint32_t WaitTime, // just a integer 
		uint32_t CaptureSize,    // size in DWORDs
		uint32_t * RawData) 
{
	return FastCapture(WaitTime, CaptureSize, RawData);
}*/

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
	PrintDesc(Data,Length);
}

uint32_t RemoteSignalCapture::Receive(
			uint32_t addr,
			uint32_t size) {
	uint32_t read = 0;
	uint32_t rec = 0;
	uint32_t i = 0;
	uint32_t * data = new uint32_t[size];
	printf("Startaddress = 0x%08x Size in DWORDS = %d\n",addr,data); 
	while (read != size) {
		rec = mComm->Receive(addr,&data[read],size);
		if (rec == 0) return FALSE;
		read += rec;
		for ( ; i < read; i++){
			printf("0x%08x ",data[i]);
			if ((i % 8) == 7) {
				printf("\n");
			} 
		}

	}		
	delete data;
	return TRUE;
}

uint32_t RemoteSignalCapture::SendRetry(
		uint32_t addr,
		uint32_t data) {
	uint32_t i = 0;
	uint32_t read = 0;
	uint32_t RecData;
	for (i = 0; i < cMaxRetrys; ++i){
		mComm->Send(addr,&data,1);
		read = mComm->Receive(addr,&RecData,1);
		if ((read == 1) && (data == RecData)) break;
		mComm->ClearBufferRx();
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
	for (i = 0; i < cMaxRetrys; ++i){
		k = length-j;
		mComm->Send(addr+j*sizeof(uint32_t),&data[j],k);	//DebugUart::Send or NormalUart::Send
/*		read = mComm->Receive(addr+j*sizeof(uint32_t),&RecData[j], k);

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
		}*/
		j = length;
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
	uint32_t CpuCtl = 0;
	uint32_t DataArray[cFrameSize];
	struct irqmp *lr =(struct irqmp*) INTERRUPT_CTL_BASE_ADDR;

	if (hFile == NULL) {
		printf("Binary software file not found!\n");
		return FALSE;
	}
	/* Stop the CPU */

	read = mComm->Receive(DSU_CTL,&data,1);
	if (read == 0){
		printf("Target does not respond!\n");
		fclose(hFile);
		return FALSE;
	}
	CpuCtl = 0x2F; // stopable on debug mode, etc
	Send(DSU_CTL,CpuCtl);
	Send(DSU_SINGLESTEP,0xFFFF); // debug break for all LEON3s 
	read = mComm->Receive(DSU_SINGLESTEP,&data,1);
	if (data & 0x1){
		printf("CPU0 stopped sucessfully\n");
	}
	if (data & 0x100){
		printf("CPU0 is in single step mode!\n");
	}
	Send(DSU_CTL,CpuCtl);
	read = mComm->Receive(DSU_CTL,&data,1);
	printf("DSU_CTL 0x%08x\n",data);
	printf("Starting software upload!\n");


	/* write the binary file into the RAM */
	while (feof(hFile) == FALSE){
		read = fread(DataArray,4,cFrameSize,hFile);
		if (read == 0){
			break;
		}
		if ((uint32_t)read > cFrameSize) {
			printf("Unexpected error\n");
			read = 1;
			//return FALSE;
		}
//Data from binary (ELF-) files are already in correct endianess. As SendRetry will try to correct endianess again
//change endianess to wrong order beforehand.
		data = read*sizeof(uint32_t);
		ChangeEndian(DataArray,data);
		i = SendRetry(addr,DataArray,read);
		addr+=read*sizeof(uint32_t);
		if (i == cMaxRetrys) {
			printf("%d Transmission errors on addr 0x%08x!\n",cMaxRetrys, addr);
			fclose(hFile);
			return FALSE;
		}
		
		if (addr % 0x1000 == 0){
			/*printf("addr 0x%x\n",addr);*/
			printf("%d bytes done!\n",addr-StartAddr);
		}
	}
	fclose(hFile);
	printf("Uploading software done (%d bytes)!\n",addr-StartAddr);
	mComm->Resync();

	
	
	// Clear the REGFILE 
	for(i = 0; i < NWINDOWS*WINDOW_SIZE/4; ++i){
		Send(DSU_REGFILE + i*4,0);
	}
//	SetDebugInfo(1);

	// Set the Y register
	Send(DSU_REG_Y,0);

	// Set the PSR register (flag register)
	Send(DSU_REG_PSR,0xF30000E0);

	// Set the start register window 
	Send(DSU_REG_WIM,START_WINDOW);
	//printf("DSU_REG_WIM:  0x%08x\n",START_WINDOW);


	// Set the Trap Base Register 
	Send(DSU_REG_TBR,START_TBR);
	//printf("DSU_REG_TBR:  0x%08x\n",START_TBR);

	// Set the start address 
	Send(DSU_REG_PC,START_TBR);
	Send(DSU_REG_PC+4,START_TBR+4);
	printf("DSU_REG_PC:   0x%08x\n",START_TBR);

	// Set the Trap Register
	Send(DSU_REG_TRAP,0x10000000);

	// Set the asi register
	Send(DSU_REG_ASI,2);

	// Set the StackAddr 
	addr = DSU_REGFILE + ((NWINDOWS+1-START_WINDOW)*WINDOW_SIZE) + REG_OUT_OFF;
	addr = DSU_REGFILE + 0x38;
	printf("DSU Regadress of Stackaddr:  0x%08x\n",addr);
	Send(addr,StackAddr);
	printf("Stackaddr:    0x%08x\n",StackAddr);
	
/*	printf("Register file: global, out, local, in\n");
	for (i = 0; i < 8; ++i){
		for(addr = 0; addr < 16; ++addr){
			DataArray[addr] = 0xeeeeeeee;
		}
		addr = DSU_REGFILE+(i*WINDOW_SIZE);
		printf("DSU addr:    0x%08x",addr);
		read = mComm->Receive(addr, DataArray,16);
		for(addr = 0; addr < read; ++addr){
			if ((addr % 4) == 0){
				printf("\n0x%08x ",DataArray[addr]);
			} else {
				printf("0x%08x ",DataArray[addr]);
			}
		}
		printf("\n");
	}*/
	
	// RUN 
	/* Switching all LEON3s into debug mode */
	//Send(DSU_CTL,);
	data = 0x00E1000F;
	Send(DSU_ASI_BASE,	data);
//	printf("DSU_ASI_BASE send:      0x%08x\n",data);
	read = mComm->Receive(DSU_ASI_BASE,&data,1);
//	printf("DSU_ASI_BASE  rec:      0x%08x\n",data);
	i = 0;
	do {
	Send(DSU_DBGMODE,	0xFFFFFFFF);
	data = 0x0061800F;
	Send(DSU_ASI_BASE,	data);
//	printf("DSU_ASI_BASE send:      0x%08x\n",data);
	read = mComm->Receive(DSU_ASI_BASE,&data,1);
//	printf("DSU_ASI_BASE  rec:      0x%08x\n",data);
	
	
	read = mComm->Receive(DSU_CTL,&data,1);
	printf("Reading the DSU_CTL = 0x%08x for starting Leon3!\n",data);
	data |= DSU_PE;
	/* setting the time tag counter to zero */
	Send(DSU_TIME_TAG,0);
	printf("Starting Leon3 with DSU_CTL = 0x%08x!\n",data);
	Send(DSU_CTL,data);
	printf("Disable all IRQs\n");
	Send((uint32_t)&lr->irqmask,0);	/* mask all interrupts */
	Send((uint32_t)&lr->irqlevel,0);	/* clear level reg */
	Send((uint32_t)&lr->irqforce,0);
	Send((uint32_t)&lr->irqclear,-1);	/* clear all pending interrupts */
	printf("Setting the console uart in loop back mode\n");
	Send(GENERIC_UART_BASE_ADDR+0x8,0xa3);
	printf("Release Leon3 from single step debugging\n");
	Send(DSU_SINGLESTEP,0);
	i++;
	} while (i < 1);

	WaitMs(100);
	read = mComm->Receive(DSU_CTL,&data,1);
	printf("DSU_CTL:      0x%08x\n",data);
	read = mComm->Receive(DSU_REG_PC,&data,1);
	printf("DSU_REG_PC:   0x%08x\n",data);
	read = mComm->Receive(DSU_REG_TRAP,&data,1);
	printf("DSU_REG_TRAP: 0x%08x\n",data);

/*	printf("Register file: global, out, local, in\n");
	for (i = 0; i < 8; ++i){
		for(addr = 0; addr < 16; ++addr){
			DataArray[addr] = 0xeeeeeeee;
		}
		addr = DSU_REGFILE+(i*WINDOW_SIZE);
		printf("DSU addr:    0x%08x",addr);
		read = mComm->Receive(addr, DataArray,16);
		for(addr = 0; addr < read; ++addr){
			if ((addr % 4) == 0){
				printf("\n0x%08x ",DataArray[addr]);
			} else {
				printf("0x%08x ",DataArray[addr]);
			}
		}
		printf("\n");
	}*/

//	mComm->Resync();
	return TRUE;
}

uint32_t RemoteSignalCapture::Debug() {
	uint32_t data = 0;
	uint32_t read = 0;
	uint32_t running = FALSE;
	read = mComm->Receive(DSU_CTL,&data,1);
	if (read == 0){
		printf("Target does not respond!\n");
		return FALSE;
	}

	printf("DSU_CTL:      0x%08x\n",data);

	if (data & (1 << DSU_PE) != 0) {
		printf("LEON3s are in error mode! \n");
	} else if (data & (1 << DSU_HL) != 0) {
		printf("LEON3s are in halt mode! \n");
	} else {
		printf("Stopping all Leon3s for the backtrace output!\n");
		Send(DSU_SINGLESTEP,0xFFFF); // debug break for all LEON3s 
		running = TRUE;
	}

	PrintTraps();
	PrintBackTrace();

	if (running == TRUE) {
		Send(DSU_SINGLESTEP,0x0); 
		printf("Release Leon3 from single step debugging\n");
	}
	return TRUE;		
}

void RemoteSignalCapture::PrintTraps() {
	uint32_t data = 0;
	uint32_t read = 0;
	read = mComm->Receive(DSU_REG_TRAP,&data,1);
        printf("DSU_REG_TRAP: 0x%08x\n",data);

}

void RemoteSignalCapture::PrintBackTrace() {
	uint32_t addr = 0;
	uint32_t data = 0;
	uint32_t read = 0;
	uint32_t curr_addr = 0;
	uint32_t prev_addr = 0;
	char grep[80];
/*
	printf("Programm counter history\n");
 	addr = DSU_ITRACE_BASE; 
	
	while (addr < (DSU_ITRACE_BASE + ITRACE_SIZE)){
		read = mComm->Receive(addr + ITRACE_ADDR_OFFS,&data,1);
		curr_addr = data & ITRACE_ADDR_MASK;
#ifdef WINNT
		sprintf(grep,"grep \"^%08x\" W.S\n",curr_addr);
		system(grep);
#else
		sprintf(grep,"%08x",curr_addr);
		puts(grep);
		execl("grep",grep, "W.S");
#endif
		addr = addr + ITRACE_ITEM_SIZE;
	}
*/
        printf("Programm counter jump history\n");
	addr = DSU_ITRACE_BASE; 
	
	while (addr < (DSU_ITRACE_BASE + ITRACE_SIZE)){
		prev_addr = curr_addr;
		read = mComm->Receive(addr + ITRACE_ADDR_OFFS,&data,1);
		//printf("Reading from addr 0x%08x \n", addr);
		curr_addr = data & ITRACE_ADDR_MASK;
		if (addr == DSU_ITRACE_BASE) {
			printf("PC: 0x%08x \n",curr_addr); 
		} else {
			if ((curr_addr != prev_addr) && (curr_addr != (prev_addr +4))) {
				printf("PC: 0x%08x =>  0x%08x ", prev_addr, curr_addr);
			
				if (data & ITRACE_TRAP_MASK) {
					printf("TRAPPED ");
				}
				if (data & ITRACE_ERROR_MASK) {
					printf("Break on Error\n");
				} else {
					printf("\n");
				}
			}
		}
		addr = addr + ITRACE_ITEM_SIZE;
	}
}
