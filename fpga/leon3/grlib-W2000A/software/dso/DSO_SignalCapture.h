#ifndef DSO_SIGNALCAPTURE_H
#define DSO_SIGNALCAPTURE_H

#include "DSO_Main.h"
#include "DSO_Debugprint.h"

bool InitSignalCapture(Debugprint * Init, Target T, Language L);

int FastMode(const unsigned int SamplingFrequncy, 
			 const unsigned int CPUFrequency);

bool SetTriggerInput (const unsigned int noChannels, 
					  const unsigned int SampleSize,
					  const unsigned int SamplingFrequence,
					  const unsigned int CPUFrequency,
					  const unsigned int Ch0, 
					  const unsigned int Ch1, 
					  const unsigned int Ch2, 
					  const unsigned int Ch3);




// reference time in samples
bool SetTrigger(const unsigned int Trigger, 
				const unsigned int TriggerChannel,
				const unsigned int TriggerPrefetchSamples,
				const int  LowReference,
				const unsigned int  LowReferenceTime,
				const int HighReference,
				const unsigned int HighReferenceTime);

// myV/Div
bool SetAnalogInputRange(const unsigned int Ch0, 
						 const unsigned int Ch1, 
						 const unsigned int Ch2, 
						 const unsigned int Ch3);

// returns read DWORDS
unsigned int CaptureData(const unsigned int WaitTime, // just a integer 
						 const bool Start,
						 unsigned int CaptureSize,    // size in DWORDs
						 unsigned int * RawData,
						 unsigned int FrameSize, // set it to something from 100 to 1000
		                 const unsigned int SamplingFrequncy,
					     const unsigned int CPUFrequency); 




#endif
