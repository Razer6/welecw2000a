
#include "DSO_Remote_Master.h"
#include "DSO_Remote.h"
#include "WaveFilePackage.h"
#include "stdio.h"

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
	SendHeader(uart);
	SendInt(uart, SET_TRIGGER);
	SendInt(uart, Trigger);
	SendInt(uart, TriggerChannel);
	SendInt(uart, TriggerPrefetchSamples);
	SendInt(uart, LowReference);
	SendInt(uart, LowReferenceTime);
	SendInt(uart, HighReference);
	SendInt(uart, HighReferenceTime);
	return ReceiveACK(uart);
}


bool SendAnalogInput(	uart_regs * uart,
			const unsigned int NoCh, 
			const SetAnalog * Settings){
	unsigned int i = 0;
	SendHeader(uart);
	SendInt(uart,SET_ANALOG_INPUT);
	SendInt(uart, NoCh);
	for(i = 0; i < NoCh; ++i){
		SendInt(uart, Settings[i].myVperDiv);
		SendInt(uart, Settings[i].AC);
		SendInt(uart, Settings[i].DA_Offset);
		SendInt(uart, Settings[i].PWM_Offset);
		SendInt(uart, Settings[i].Mode);
	}
	return ReceiveACK(uart);
}

unsigned int ReceiveSamples(uart_regs * uart,
			const unsigned int WaitTime, /* just a integer */
			const unsigned int Start,
			unsigned int CaptureSize,    /* size in DWORDs*/
			int * FastMode,
			unsigned int * RawData){
	SendHeader(uart);
	SendInt(uart,CAPTURE_DATA);
	SendInt(uart,WaitTime);
	SendInt(uart,Start);
	SendInt(uart,CaptureSize);
	return ReceiveData(uart,CaptureSize,FastMode,RawData);
}

/* The fast mode capturing does always capture the fixed data size of the
 * particular scope. It always ignores the capture size! 
 * The reason for this behaviour is to know for all DSOs which sample is where */
void FastRecord1Ch8Bit (FILE * Handle, aWaveFileInfo FileInfo, int * buffer){
	int i = 0;
	int j = 0;
	int rem = FileInfo.DataSize;
	printf("FastRecord1Ch8Bit\n");
	for (i = 3; i >= 0; --i){
		for (j = 0; j < (FileInfo.DataSize/4); ++j){
			WriteSample(Handle,(buffer[j] >> (i*8)),&rem, FileInfo.DataTyp);
		}
	}
}

void FastRecord1Ch16Bit(FILE * Handle, aWaveFileInfo FileInfo, int * buffer){
	int i = 0;
	int j = 0;
	int rem = FileInfo.DataSize;
	printf("FastRecord1Ch16Bit\n");
	for (i = 1; i >= 0; --i){
		for (j = 0; j < (FileInfo.DataSize/4); ++j){
			WriteSample(Handle,(buffer[j] >> (i*16)),&rem, FileInfo.DataTyp);
		}
	}
}
void FastRecord2Ch8Bit (FILE * Handle, aWaveFileInfo FileInfo, int * buffer){
	int i = 0;
	int j = 0;
	int rem = FileInfo.DataSize;
	printf("FastRecord2Ch8Bit\n");
	for (i = 1; i >= 0; --i){
		for (j = 0; j < (FileInfo.DataSize/4); ++j){
			WriteSample(Handle,(buffer[2*j] >> (2*i*8+1)),&rem, FileInfo.DataTyp);
			WriteSample(Handle,(buffer[2*j+1] >> (2*i*8)),&rem, FileInfo.DataTyp);
		}
	}
}

/* The normal mode does store in a Dword only one Sample per channel */
void RecordNormal  (FILE * Handle, aWaveFileInfo FileInfo, int * buffer){
	int i = 0;
	int j = 0;
	int rem = FileInfo.DataSize;
	printf("RecordNormal\n");
	for (i = 0; i < FileInfo.DataSize/4; ++i){
		for (j = FileInfo.Channels-1; j >= 0; --j){
			WriteSample(Handle,(buffer[i] >> (j*FileInfo.DataTyp)),&rem, FileInfo.DataTyp);
		}
	}
}


