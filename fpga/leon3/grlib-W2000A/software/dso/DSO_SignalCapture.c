
#include <stdlib.h>
#include <stdio.h>
#include "grcommon.h"
#include "DSO_SFR.h"
#include "DSO_SignalCapture.h"
#include "DSO_Debugprint.h"

Debugprint Print;
volatile CaptureRegs * volatile CaptureR;
volatile TriggerRegs * volatile TriggerR;


int FastMode(const unsigned int SamplingFrequency, 
			 const unsigned int CPUFrequency)
{
	return SamplingFrequency > (CPUFrequency*FASTMODEFACTOR);
}

bool InitSignalCapture(Debugprint * Init, Target T, Language L){
	CaptureR = (CaptureRegs *)DEVICEADDR;
	TriggerR = (TriggerRegs *)TRIGGERONCHADDR;
	Init = &Print;
	return InitDebugprint(&Print,T,L);
}

bool SetTriggerInput (const unsigned int noChannels, 
					  const unsigned int SampleSize, 
					  const unsigned int SamplingFrequency,
					  const unsigned int CPUFrequency,
					  const unsigned int Ch0, 
					  const unsigned int Ch1, 
					  const unsigned int Ch2, 
					  const unsigned int Ch3)
{
	const int FMode = FastMode(SamplingFrequency,CPUFrequency);
	int Decimaton = 0;
	int Stage = 0;
	int M = 0;
	if ((Ch0 > 3) || (Ch1 > 3) || (Ch2 > 3) || (Ch3 > 3)) {
//		Print.ChannelsNotSupported();
		return false;
	}
	TriggerR->TriggerStorageModeAddr = TRIGGERSTORAGEMODE4CH;
	switch(CaptureR->DeviceAddr){
		case WELEC2012:
		case WELEC2014:
		case WELEC2022:
		case WELEC2024:	Decimaton = WELECMAXFS/SamplingFrequency; break;
		case SANDBOXX:	Decimaton = SANDBOXXFS/SamplingFrequency; break;
		default:		Decimaton = WELECMAXFS/SamplingFrequency; break;
	}
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
				//	Print.NotAvialbe();
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
				//	Print.NotAvialbe();
					return false;
			       break;
			}
			break;
		default : 
		//	Print.NotAvialbe();
			return false;
			break;
	}
	return true;
}

// reference time in samples
bool SetTrigger(const unsigned int Trigger, 
				const unsigned int TriggerChannel,
				const unsigned int TriggerPrefetchSamples,
				const int  LowReference,
				const unsigned int  LowReferenceTime,
				const int HighReference,
				const unsigned int HighReferenceTime) 
{
	if (TriggerChannel > 3) {
	//	Print.ChannelsNotSupported();
		return false;
	}
	if (TriggerPrefetchSamples >= (TRIGGER_MEM_SIZE-16)){
	//	Print.ToMuchPrefetchSamples();
	}
	TriggerR->TriggerLowValueAddr  = LowReference;
	TriggerR->TriggerLowTimeAddr   = LowReferenceTime;
	TriggerR->TriggerHighValueAddr = HighReference;
	TriggerR->TriggerHighTimeAddr  = HighReferenceTime;

    if ((TriggerR->TriggerLowValueAddr  != LowReference)     ||
		(TriggerR->TriggerLowTimeAddr   != LowReferenceTime) ||
		(TriggerR->TriggerHighValueAddr != HighReference)    ||
		(TriggerR->TriggerHighTimeAddr  != HighReferenceTime))
	{
	//	Print.TriggerSettingsOutofRange();
	}
}

// myV/Div
bool SetAnalogInputRange(const unsigned int Ch0, 
						 const unsigned int Ch1, 
						 const unsigned int Ch2, 
						 const unsigned int Ch3) 
{
	// TODO must be implemented in HW before this can be used!
	CaptureR->InputCh0Gain = 0;       
	CaptureR->InputCh1Gain = 0;      
	CaptureR->InputCh2Gain = 0;        
	CaptureR->InputCh3Gain = 0;
	Print.AnalogInputGainNotSupported();
	return false;
}

int FastCapture(const unsigned int WaitTime, // just a integer 
				unsigned int CaptureSize,    // size in DWORDs
				unsigned int * RawData) 
{
	unsigned int i = 0;
	int * StartAddr = 0;
	volatile int * Addr = 0;
	TriggerR->TriggerOnceAddr = 0;
	TriggerR->TriggerOnceAddr = 1;
	//while (((1 << TRIGGERRECORDINGBIT) & TriggerR->TriggerStatusRegister) == 0){
	//	i = i + 1;
	//	if (WaitTime > i) {
	//		return 0;
	//	}
	//	
	//}// busy wait
	while(1){
		i++;
		if (((1 << TRIGGERRECORDINGBIT) & TriggerR->TriggerStatusRegister) != 0){
			break;
		}
		if (WaitTime > i) {
			return 0;
		}
	}
	StartAddr = (int *)(TRIGGER_MEM_BASE_ADDR + TriggerR->TriggerReadOffSetAddr);

	// The folowing 5 lines solve a feature (bug) in the hardware trigger, 
	// which is overwriting the first 16 samples at the end!
	//while(((int)StartAddr + 8*3) < TriggerR->TriggerCurrentAddr);
	while(1){
		if (((int)StartAddr + 8*3) < TriggerR->TriggerCurrentAddr){
			break;
		}
	}
	StartAddr--;
	StartAddr--;
	TriggerR->TriggerReadOffSetAddr = (int)StartAddr; // masking is done by the SFR itself!
	StartAddr++;

	//while(((1 << TRIGGERRECORDINGBIT) & TriggerR->TriggerStatusRegister) != 0);
	while(1){
		if (((1 << TRIGGERRECORDINGBIT) & TriggerR->TriggerStatusRegister) == 0){
			break;
		}
	}
	
	Addr = StartAddr+1;
	i = 0;
	while ((i < CaptureSize) && (Addr != StartAddr)){
		RawData[i] = *Addr;
		i++;
		Addr++;
		if ((int)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
			Addr =  (int *) TRIGGER_MEM_BASE_ADDR;
		}
	}
	return i;
}

// returns read DWORDS
unsigned int CaptureData(const unsigned int WaitTime, // just a integer 
						 const bool Start,
						 unsigned int CaptureSize,    // size in DWORDs
						 unsigned int * RawData,
						 unsigned int FrameSize,
		                 const unsigned int SamplingFrequency,
					     const unsigned int CPUFrequency) 
{
	// TODO Idle wait
	const int FMode = FastMode(SamplingFrequency,CPUFrequency);
    unsigned int i = 0;
	unsigned int StartAddr = 0;
	volatile unsigned int * Addr = 0;
	unsigned int Frame = 0;
	unsigned int ForwardStartAddr = 0;
	unsigned int ChMode = 0;
	unsigned int ChCounter = 0;
	
	if (FMode != 0) {
		return FastCapture(WaitTime,CaptureSize, RawData);
	} 
	if (Start == false){
		if (((1 << TRIGGERRECORDINGBIT) & TriggerR->TriggerStatusRegister) == 0){
			return 0;
		}
	} else {
		TriggerR->TriggerOnceAddr = 0;
		TriggerR->TriggerOnceAddr = 1;
		while (((1 << TRIGGERRECORDINGBIT) & TriggerR->TriggerStatusRegister) == 0)		{
			i = i + 1;
			if (WaitTime > i) {
				return 0;
			}
		}// busy wait
	}
	i = 0;
	StartAddr = (TriggerR->TriggerReadOffSetAddr);
	Addr = (int *)TRIGGER_MEM_BASE_ADDR + StartAddr;
	// abort if the trigger 
	while (((1 << TRIGGERRECORDINGBIT) & TriggerR->TriggerStatusRegister) != 0){
//	while(i < CaptureSize) {
		if (i == CaptureSize) {
			return i;
		}
		ForwardStartAddr = (int)TriggerR->TriggerCurrentAddr;
		ForwardStartAddr = ForwardStartAddr - (int)Addr - FrameSize;
        ForwardStartAddr &= (TRIGGER_MEM_SIZE-1);
	//	if (ForwardStartAddr > (TRIGGER_MEM_SIZE/2)) {
		if (ForwardStartAddr > 0) {
			StartAddr = StartAddr + FrameSize;
			TriggerR->TriggerReadOffSetAddr = StartAddr;
		} else {
			// here the race condition gets active if the ratio of 
			// FastMode is wrong!
			continue;
		}
		Frame = Frame + FrameSize; 
		if (Frame > CaptureSize) {
			Frame = CaptureSize;
		}
		while (i < Frame) {
			RawData[i] = *Addr;
			i++;
			Addr++;
			if ((int)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
				Addr =  (int *) TRIGGER_MEM_BASE_ADDR;
			}
		}
	}
	return i;
}
