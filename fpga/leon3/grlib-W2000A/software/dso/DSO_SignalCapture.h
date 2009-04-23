/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_SignalCapture.h
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
#ifndef DSO_SIGNALCAPTURE_H
#define DSO_SIGNALCAPTURE_H

#include "DSO_Main.h"
#include "DSO_Debugprint.h"


enum eSrc2 {
	normal,
	pwm_offset,
	gnd,
	lowpass
};

typedef enum eSrc2 Src2;

typedef struct {
	unsigned int myVperDiv;
	unsigned int AC;
	int DA_Offset;
	unsigned int Specific;
	Src2 Mode;
} SetAnalog;

bool InitSignalCapture(Debugprint * Init, Target T, Language L);

unsigned int FastMode(	const unsigned int SamplingFrequncy, 
			const unsigned int CPUFrequency);
unsigned int IsFastMode();

bool SetTriggerInput (	const unsigned int noChannels, 
			const unsigned int SampleSize, 
			const unsigned int SamplingFrequency,
			const unsigned int CPUFrequency,
			const unsigned int AACFilterStart,
			const unsigned int AACFilterStop,
			const unsigned int Ch0, 
			const unsigned int Ch1, 
			const unsigned int Ch2, 
			const unsigned int Ch3);




/* reference time in samples*/
bool SetTrigger(const unsigned int Trigger, 
		const unsigned int TriggerChannel,
		const unsigned int TriggerPrefetchSamples,
		const int  LowReference,
		const unsigned int  LowReferenceTime,
		const int HighReference,
		const unsigned int HighReferenceTime);


bool SetAnalogInputRange(const unsigned int NoCh, 
			 const SetAnalog * Settings);

/* returns read DWORDS*/
unsigned int CaptureData(const unsigned int WaitTime, /* just a integer */
			 bool Start,
			 bool ForceFastMode,
			 unsigned int CaptureSize,    /* size in DWORDs*/
			 unsigned int * RawData); 




#endif
