
#include <stdlib.h>
#include <stdio.h>
#include "grcommon.h"
#include "DSO_SFR.h"
#include "DSO_SignalCapture.h"
#include "DSO_Debugprint.h"
#include "DSO_Misc.h"

Debugprint Print;
volatile CaptureRegs * volatile CaptureR;
volatile TriggerRegs * volatile TriggerR;
volatile AnalogSettings * volatile AnalogR;

int FastMode(const unsigned int SamplingFrequency, 
			 const unsigned int CPUFrequency)
{
	return SamplingFrequency > (CPUFrequency*FASTMODEFACTOR);
}

bool InitSignalCapture(Debugprint * Init, Target T, Language L){
	CaptureR = (CaptureRegs *)   DEVICEADDR;
	TriggerR = (TriggerRegs *)   TRIGGERONCHADDR;
	AnalogR  = (AnalogSettings *)ANALOGSETTINGSBANK7;
	Init = &Print;
	return InitDebugprint(Init,T,L);
}

bool SetTriggerInput (	const unsigned int noChannels, 
			const unsigned int SampleSize, 
			const unsigned int SamplingFrequency,
			const unsigned int CPUFrequency,
			const unsigned int AACFilterStart,
			const unsigned int AACFilterStop,
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
/*		Print.ChannelsNotSupported();*/
		return false;
	}

	for(M = AACFilterStart; M < AACFilterStop; ++M){
	       Stage |= (1 << M);
	}
	CaptureR->FilterEnable = Stage;

	TriggerR->TriggerStorageModeAddr = TRIGGERSTORAGEMODE4CH;
	switch(CaptureR->DeviceAddr){
		case WELEC2012:
		case WELEC2014:
		case WELEC2022:
		case WELEC2024:	Decimaton = WELECMAXFS/SamplingFrequency; break;
		case SANDBOXX:	Decimaton = SANDBOXXFS/SamplingFrequency; break;
		default:	Decimaton = WELECMAXFS/SamplingFrequency; break;
	}
	Stage = 0;
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
				/*	Print.NotAvialbe();*/
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
				/*	Print.NotAvialbe();*/
					return false;
			       break;
			}
			break;
		default : 
		/*	Print.NotAvialbe();*/
			return false;
			break;
	}
	return true;
}

/* reference time in samples*/
bool SetTrigger(const unsigned int Trigger, 
		const unsigned int TriggerChannel,
		const unsigned int TriggerPrefetchSamples,
		const int  LowReference,
		const unsigned int  LowReferenceTime,
		const int HighReference,
		const unsigned int HighReferenceTime) 
{
	if (TriggerChannel > 3) {
	/*	Print.ChannelsNotSupported();*/
		return false;
	}
	if (TriggerPrefetchSamples >= (TRIGGER_MEM_SIZE-16)){
	/*	Print.ToMuchPrefetchSamples();*/
		return false;
	}
	TriggerR->TriggerLowValueAddr  = LowReference;
	TriggerR->TriggerLowTimeAddr   = LowReferenceTime;
	TriggerR->TriggerHighValueAddr = HighReference;
	TriggerR->TriggerHighTimeAddr  = HighReferenceTime;
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
    return true;
}


bool SetAnalogInputRange(const unsigned int NoCh, 
			 const SetAnalog * Settings) 
{
	unsigned int i = 0;
	unsigned int temp = 0;
	unsigned int j = 0;
	short dac = 0;
	for(i = 0; i < NoCh; ++i){
		switch (CaptureR->DeviceAddr) {
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
					AnalogR->Bank7 = temp;
					/*while ((loadmem((int)&AnalogR->Bank7) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank7, (1 << ANALOGSETTINGSBUSY));
					/* wait until the coils have switched*/
					WaitMs(COIL_SWITCH_TIME);
					temp &= ~(0xf); /* turn of the coils*/
					AnalogR->Bank7 = temp;
					/*while ((loadmem((int)&AnalogR->Bank7) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank7, (1 << ANALOGSETTINGSBUSY));
					/* Used DAC types are limited to 16 bits per protocol! */
					dac = (short)Settings[i].DA_Offset;
					temp = dac;
					AnalogR->Bank6 = temp| (i << DAC_CH_OFFSET);
					/*while ((loadmem((int)&AnalogR->Bank6) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank6, (1 << ANALOGSETTINGSBUSY));
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
					AnalogR->Bank5 = temp;
					/*while ((loadmem((int)&AnalogR->Bank5) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank5, (1 << ANALOGSETTINGSBUSY));
					/* wait until the coils have switched*/
					WaitMs(COIL_SWITCH_TIME);
					temp &= ~(0xf); /* turn of the coils*/
					AnalogR->Bank5 = temp;
					/*while ((loadmem((int)&AnalogR->Bank5) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank5, (1 << ANALOGSETTINGSBUSY));
					/* Used DAC types are limited to 16 bits per protocol! */
					dac = (short)Settings[i].DA_Offset;
					temp = dac;
					AnalogR->Bank6 = temp | (i << DAC_CH_OFFSET);
					/*while ((loadmem((int)&AnalogR->Bank6) & (1 << ANALOGSETTINGSBUSY)) != 0);*/
					WaitUntilMaskedAndZero(&AnalogR->Bank6, (1 << ANALOGSETTINGSBUSY));
				}
				break;
			default: 
				return false;
				break;
		}
	}
	return true;
}

int FastCapture(const unsigned int WaitTime, /* just a integer */
		unsigned int CaptureSize,    /* size in DWORDs*/
		unsigned int * RawData) 
{
	unsigned int i = 0;
	int * StopAddr = 0;
	volatile int * Addr = 0;
	/* The compiler has bugs in the loop optimisation with the keyword volatile 
	 * even with function call to get the data from an hw address + masking in a condition */
	volatile int temp = 0; 

	TriggerR->TriggerOnceAddr = 0;
	TriggerR->TriggerOnceAddr = 1;

	if (WaitTimeoutAndNotZero(&TriggerR->TriggerStatusRegister, 
			(1 << TRIGGERRECORDINGBIT), WaitTime) == false) {
		return 0;
	}
	temp = loadmem((int)&TriggerR->TriggerReadOffSetAddr);
	StopAddr = (int *)(TRIGGER_MEM_BASE_ADDR + temp);

	StopAddr++; /* matching 0 to end-1 */
	Addr = StopAddr;

	/* The folowing lines solve a feature in the hardware trigger, 
	 * which is overwriting up the first 7 samples at the end!       
	 * It is caused, because the trigger always writes 8 Samples per Channel at once */
	while(1){
		temp = loadmem((int)&TriggerR->TriggerCurrentAddr); 
		if (((int)StopAddr + 8) < temp){
			break;
		}
	}
	if (8 > CaptureSize){
		i = CaptureSize;
	} else {
		i = 8;
	}
	for (; i < 8; ++i){
		RawData[0] = *Addr;
		Addr++;
		if ((int)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
			Addr =  (int *) TRIGGER_MEM_BASE_ADDR;
		}
	}
	
	/* Wait until the trigger buffer is full */
	WaitUntilMaskedAndZero(&TriggerR->TriggerStatusRegister, (1 << TRIGGERRECORDINGBIT));
	i = 8;
	while ((i < CaptureSize)){
		if  (Addr == StopAddr) {
			return i;
		}
		RawData[i] = *Addr;
		i++;
		Addr++;
		if ((int)Addr == (TRIGGER_MEM_BASE_ADDR + TRIGGER_MEM_SIZE)) {
			Addr =  (int *) TRIGGER_MEM_BASE_ADDR;
		}
	}
	return i;
}

/* returns read DWORDS*/
unsigned int CaptureData(const unsigned int WaitTime, /* just a integer */
			 bool Start,
			 unsigned int CaptureSize,    /* size in DWORDs*/
			 unsigned int * RawData,
			 unsigned int FrameSize,
		         const unsigned int SamplingFrequency,
			 const unsigned int CPUFrequency) 
{
	/* TODO Idle wait*/
	const int FMode = FastMode(SamplingFrequency,CPUFrequency);
	unsigned int i = 0;
	unsigned int StopAddr = 0;
	volatile unsigned int * Addr = 0;
	unsigned int Frame = 0;
	unsigned int ForwardStopAddr = 0;
	/* The compiler has bugs in the loop optimisation with the keyword volatile 
	 * even with function call to get the data from an hw address + masking in a condition */
	volatile int temp = 0; 
	
	if (FMode != 0) {
		return FastCapture(WaitTime,CaptureSize, RawData);
	} 
	if (Start != false) {
		TriggerR->TriggerOnceAddr = 0;
		TriggerR->TriggerOnceAddr = 1;
		if (WaitTimeoutAndNotZero(&TriggerR->TriggerStatusRegister, 
					(1 << TRIGGERRECORDINGBIT), WaitTime) == false) {
			return 0;
		}
	}
	i = 0;
	StopAddr = (TriggerR->TriggerReadOffSetAddr) +1;
	Addr = (int *)TRIGGER_MEM_BASE_ADDR + StopAddr;
	/* abort if the trigger */
	while (1) {
		temp = loadmem((int)&TriggerR->TriggerStatusRegister);
		if (((1 << TRIGGERRECORDINGBIT) & temp) == 0) {
			return i;
		}
		if ((i == CaptureSize)){
			return i;
		}
		ForwardStopAddr = (int)TriggerR->TriggerCurrentAddr;
		ForwardStopAddr = ForwardStopAddr - (int)Addr - FrameSize;
        	ForwardStopAddr &= (TRIGGER_MEM_SIZE-1);
	/*	if (ForwardStopAddr > (TRIGGER_MEM_SIZE/2)) {*/
		if (ForwardStopAddr > 0) {
			StopAddr = StopAddr + FrameSize;
			TriggerR->TriggerReadOffSetAddr = StopAddr;
		} else {
			/* here the race condition gets active if the ratio of */
			/* FastMode is wrong!*/
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
