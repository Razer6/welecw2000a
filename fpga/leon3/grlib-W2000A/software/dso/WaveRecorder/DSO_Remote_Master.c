/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Remote_Master.c
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

#include "DSO_Remote_Master.h"
#include "DSO_Remote.h"
#include "WaveFilePackage.h"
#include "stdio.h"
#include "crc.h"

#include "PCUart.h"


bool SendTriggerInput (	uart_regs * uart,
			const unsigned int noChannels, 
			const unsigned int SampleSize, 
			const unsigned int SamplingFrequency,
			const unsigned int AACFilterStart,
			const unsigned int AACFilterStop,
			const unsigned int Ch0, 
			const unsigned int Ch1, 
			const unsigned int Ch2, 
			const unsigned int Ch3){
	unsigned int data[] = {
		SET_TRIGGER_INPUT, noChannels, SampleSize, SamplingFrequency, 
		AACFilterStart,AACFilterStop, Ch0, Ch1, Ch2, Ch3};
	SendHeader(uart);
	SendInt(uart, SET_TRIGGER_INPUT);
	SendInt(uart, noChannels);
	SendInt(uart, SampleSize);
	SendInt(uart, SamplingFrequency);
	SendInt(uart, AACFilterStart);
	SendInt(uart, AACFilterStop);
	SendInt(uart, Ch0);
	SendInt(uart, Ch1);
	SendInt(uart, Ch2);
	SendInt(uart, Ch3);
	ChangeEndian(data,sizeof(data));
	crcInit();
	SendInt(uart,crcFast((unsigned char*)data,sizeof(data)));
	return ReceiveACK(uart);
}

bool SendTrigger(uart_regs * uart,
		const unsigned int Trigger, 
		const unsigned int TriggerChannel,
		const unsigned int TriggerPrefetchSamples,
		const int  LowReference,
		const unsigned int  LowReferenceTime,
		const int HighReference,
		const unsigned int HighReferenceTime){
	unsigned int data[] = {
		SET_TRIGGER, Trigger, TriggerChannel, TriggerPrefetchSamples,
		LowReference, LowReferenceTime, HighReference, HighReferenceTime};
	crc crcSend = 0;
	SendHeader(uart);
	SendInt(uart, SET_TRIGGER);
	SendInt(uart, Trigger);
	SendInt(uart, TriggerChannel);
	SendInt(uart, TriggerPrefetchSamples);
	SendInt(uart, LowReference);
	SendInt(uart, LowReferenceTime);
	SendInt(uart, HighReference);
	SendInt(uart, HighReferenceTime);
	ChangeEndian(data,sizeof(data));
	crcInit();
	crcSend = crcFast((unsigned char*)data,sizeof(data));
	SendInt(uart,crcSend);
	return ReceiveACK(uart);
}

typedef struct {
	unsigned int cmd;
	unsigned int NoCh;
	SetAnalog data[4];
} xAnalog;

bool SendAnalogInput(	uart_regs * uart,
			const unsigned int NoCh, 
			const SetAnalog * Settings){
	unsigned int i = 0;
	xAnalog crcA;
	SendHeader(uart);
	SendInt(uart,SET_ANALOG_INPUT);
	SendInt(uart, NoCh);
	for(i = 0; i < NoCh; ++i){
		SendInt(uart, Settings[i].myVperDiv);
		SendInt(uart, Settings[i].AC);
		SendInt(uart, Settings[i].DA_Offset);
		SendInt(uart, Settings[i].Specific);
		SendInt(uart, Settings[i].Mode);
		crcA.data[i] = Settings[i];
	}
	crcInit();
	crcA.cmd = SET_ANALOG_INPUT;
	crcA.NoCh = NoCh;
	ChangeEndian((unsigned int *)&crcA,sizeof(crcA));
	SendInt(uart,crcFast((unsigned char*)&crcA,sizeof(int)+(NoCh*sizeof(SetAnalog))));
	return ReceiveACK(uart);
}

unsigned int ReceiveSamples(uart_regs * uart,
			const unsigned int WaitTime, /* just a integer */
			const unsigned int Start,
			unsigned int CaptureSize,    /* size in DWORDs*/
			int * FastMode,
			unsigned int * RawData){
	int data[] ={CAPTURE_DATA, WaitTime, Start, *FastMode, CaptureSize};
	crc crcSend = 0;
	SendHeader(uart);
	SendInt(uart,CAPTURE_DATA);
	SendInt(uart,WaitTime);
	SendInt(uart,Start);
	SendInt(uart,*FastMode); /*ForceFastMode*/
	SendInt(uart,CaptureSize);
	ChangeEndian(data,sizeof(data));
	crcInit();
	crcSend = crcFast((unsigned char*)data,sizeof(data));
	SendInt(uart,crcSend);
	return ReceiveData(uart,CaptureSize,FastMode,RawData);
}



void RecordWave8Bit (	FILE * Handle, uSample * buffer,
			unsigned int Size, unsigned int Channels){
	unsigned int i = 0;
	unsigned int j = 0;
	int rem = Size*Channels;
	for (i = 0; i < Size; ++i){
		for (j = 0; j < Channels; ++j){
			WriteSample(Handle,buffer[i].c[j],&rem,8);
		}
	}
}


void RecordWave16Bit (	FILE * Handle, uSample * buffer,
			unsigned int Size, unsigned int Channels){
	unsigned int i = 0;
	unsigned int j = 0;
	int rem = Size*2*Channels;
	for (i = 0; i < Size; ++i){
		for (j = 0; j < Channels; ++j){
			WriteSample(Handle,buffer[i].s[j],&rem,16);
		}
	}
}
void RecordWave32Bit (	FILE * Handle, uSample * buffer,
			unsigned int Size){
	unsigned int i = 0;
	int rem = Size*4;
	for (i = 0; i < Size; ++i){
		WriteSample(Handle,buffer[i].i,&rem,32);
	}
}
void RecordCSV(	FILE * Handle, 
		uSample *buffer, 
		unsigned int RepeatSize, 
		unsigned int Channels, 
		unsigned int SampleSize){
	unsigned int i = 0;
	unsigned int j = 0;
	for (i = 0; i < RepeatSize; ++i){
		for (j = 0; j < Channels; ++j){
			switch (SampleSize) {
				case 8: fprintf(Handle," %d,", buffer[i].c[j]); break;
				case 16:fprintf(Handle," %d,", buffer[i].s[j]); break;
				case 32:fprintf(Handle," %d,", buffer[i].i); break;
			}
		}
		fprintf(Handle,"\n");
	}
}

/* The fast mode capturing does always capture the fixed data size of the
 * particular scope. It always ignores the capture size! 
 * The reason for this behaviour is to know for all DSOs which sample is where */

/* one Dword = 32 bit 
 * 4Ch: one sample = 8 bit 
 * 2Ch: one sample may be 8 or 16 bit, if they are 8 bit,
 * take care about the capture mode (normal of fast)
 * 1Ch: one sample may be 8,16 or 32 bit, if they are not 32 bit 
 * also take care about the capture mode (normal of fast)*/
bool RecordWave (	uSample * buffer,
			char * FileName, 
			unsigned int RepeatSize,
			unsigned int SampleFS,
			unsigned int Channels,
			unsigned int SampleSize,
			unsigned int FastMode) {
	bool Ret = false;
	enum {wav,csv} FileType = csv;
	unsigned int FastModeRepeats = 1;
	unsigned int FastModeIdx = 0;
	unsigned int i = 0;
	FILE * Handle = 0;
	FILE ** pHandle = &Handle;
	aWaveFileInfo FileInfo = {
		(short)SampleSize,
		Channels,
		0,
		SampleFS};
	if (FastMode != 0) {
		FileInfo.DataSize = RepeatSize*4;
	} else {
		FileInfo.DataSize = RepeatSize*Channels*SampleSize/8;
	}
	printf("DataTyp=%d, Channels=%d DataSize=%d SamplingRate=%d\n",
		FileInfo.DataTyp,FileInfo.Channels,FileInfo.DataSize,FileInfo.SamplingRate);
	if (strcmp(".wav",FileName) == 0){
		FileType = wav;
	}
	if (FileType == wav){
		Ret = OpenWaveFileWrite(FileName,pHandle,FileInfo);
	} else {
		Handle = fopen(FileName,"w");
	}
	if (Handle == 0){
        printf("Generating %s failed!\n",FileName);
		return false;
	}
	if (FastMode != 0){
		switch(SampleSize) {
			case 8:  
				if (FileInfo.Channels == 1){
					FastModeRepeats = 4;
				} else if (FileInfo.Channels == 2){
					FastModeRepeats = 2;
				}
				break;
			case 16: 
				if (FileInfo.Channels == 1){
					FastModeRepeats = 2; 
				}
				break;
		}
	}
	for (FastModeIdx = 0; FastModeIdx < FastModeRepeats;++FastModeIdx){
		if (FileType == wav){
			switch (SampleSize) {
				case 8: RecordWave8Bit(Handle,buffer,RepeatSize,Channels);
					break;
				case 16:RecordWave16Bit(Handle,buffer,RepeatSize,Channels);
					break;
				case 32:RecordWave32Bit(Handle,buffer,RepeatSize);
					break;
				default:
					printf("Bitwidth not supported on wave files!\n");
			}	
		} else {
			RecordCSV(Handle,buffer,RepeatSize,Channels,SampleSize);
		}
		if (FastModeIdx != FastModeRepeats-1){
			switch(FastModeRepeats){
				case 2:
					for (i = 0; i < RepeatSize; ++i){
						buffer[i].s[0] = buffer[i].s[1];
					}
					break;
				case 4:
					for (i = 0; i < RepeatSize; ++i){
						buffer[i].c[0] = buffer[i].c[FastModeIdx+1];
					}
					break;
			}
		}		
	}
	fclose(Handle);
	return true;
}
