#ifndef DSO_REMOTE_MASTER_H
#define DSO_REMOTE_MASTER_H

#include "WaveFilePackage.h"
#include "DSO_SFR.h"
#include "DSO_SignalCapture.h"
#include "DSO_Remote.h"



#define DSO_NAK_MESSAGE "At least one argument was not accepted from the target!\n"

bool SendTriggerInput (	uart_regs * uart,
			const unsigned int noChannels, 
			const unsigned int SampleSize, 
			const unsigned int SamplingFrequency,
			const unsigned int AACFilterStart,
			const unsigned int AACFilterStop,
			const unsigned int Ch0, 
			const unsigned int Ch1, 
			const unsigned int Ch2, 
			const unsigned int Ch3);

bool SendTrigger(uart_regs * uart,
			const unsigned int Trigger, 
			const unsigned int TriggerChannel,
			const unsigned int TriggerPrefetchSamples,
			const int  LowReference,
			const unsigned int  LowReferenceTime,
			const int HighReference,
			const unsigned int HighReferenceTime);

bool SendAnalogInput(	uart_regs * uart,
			const unsigned int NoCh, 
			const SetAnalog * Settings);

unsigned int ReceiveSamples(uart_regs * uart,
			const unsigned int WaitTime, /* just a integer */
			const unsigned int Start,
			unsigned int CaptureSize,    /* size in DWORDs*/
			int * FastMode,
			unsigned int * RawData);

void FastRecord1Ch8Bit (FILE * Handle,aWaveFileInfo FileInfo,int * buffer);
void FastRecord1Ch16Bit(FILE * Handle,aWaveFileInfo FileInfo,int * buffer);
void FastRecord2Ch8Bit (FILE * Handle,aWaveFileInfo FileInfo,int * buffer);
void RecordNormal  (FILE * Handle,aWaveFileInfo FileInfo,int * buffer);

#endif

