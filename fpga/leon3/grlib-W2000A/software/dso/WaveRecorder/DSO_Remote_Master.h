/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Remote_Master.h
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 20.04.2009
*****************************************************************************
* Description	 : out of date 
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
			const uint32_t noChannels, 
			const uint32_t SampleSize, 
			const uint32_t SamplingFrequency,
			const uint32_t AACFilterStart,
			const uint32_t AACFilterStop,
			const uint32_t Ch0, 
			const uint32_t Ch1, 
			const uint32_t Ch2, 
			const uint32_t Ch3);

bool SendTrigger(uart_regs * uart,
			const uint32_t Trigger, 
			const uint32_t TriggerChannel,
			const uint32_t TriggerPrefetchSamples,
			const int  LowReference,
			const uint32_t  LowReferenceTime,
			const int HighReference,
			const uint32_t HighReferenceTime);

bool SendAnalogInput(	uart_regs * uart,
			const uint32_t NoCh, 
			const SetAnalog * Settings);

uint32_t ReceiveSamples(uart_regs * uart,
			const uint32_t WaitTime, /* just a integer */
			const uint32_t Start,
			uint32_t CaptureSize,    /* size in DWORDs*/
			int * FastMode,
			uint32_t * RawData);

bool RecordWave (uSample * buffer,
				 char * FileName, 
				 uint32_t RepeatSize,
				 uint32_t SampleFS,
				 uint32_t Channels,
				 uint32_t SampleSize,
				 uint32_t FastMode);

#ifdef __cplusplus
}
#endif

#endif

