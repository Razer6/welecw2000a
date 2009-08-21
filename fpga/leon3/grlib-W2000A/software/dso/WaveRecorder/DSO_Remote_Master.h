/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Remote_Master.h
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
#ifndef DSO_REMOTE_MASTER_H
#define DSO_REMOTE_MASTER_H

#include "WaveFilePackage.h"
#include "DSO_SFR.h"
#include "DSO_SignalCapture.h"
#include "DSO_Remote.h"



#define DSO_NAK_MESSAGE "At least one argument was not accepted from the target!\n"

#ifdef __cplusplus
extern "C" {
#endif

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

bool RecordWave (uSample * buffer,
				 char * FileName, 
				 unsigned int RepeatSize,
				 unsigned int SampleFS,
				 unsigned int Channels,
				 unsigned int SampleSize,
				 unsigned int FastMode);

#ifdef __cplusplus
}
#endif

#endif

