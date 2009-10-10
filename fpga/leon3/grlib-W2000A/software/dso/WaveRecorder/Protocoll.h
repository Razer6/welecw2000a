/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : Protocoll.h
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 10.10.2009
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
#ifndef PROTOCOLL_H
#define PROTOCOLL_H
#include "Object.h"
#include "DSO_SignalCapture.h"

class Protocoll : public Object {
public:
	~Protocoll(){};
	virtual uint32_t InitComm(
		char * Device, 
		const uint32_t TimeoutMS = 5000, 
		const uint32_t Baudrate  = 115200,
		char * IPAddr = "192.168.0.51") = 0;

	virtual uint32_t SendTriggerInput (	
		const uint32_t noChannels, 
		const uint32_t SampleSize, 
		const uint32_t SamplingFrequency,
		const uint32_t AACFilterStart,
		const uint32_t AACFilterStop,
		const uint32_t Ch0 = 0, 
		const uint32_t Ch1 = 1, 
		const uint32_t Ch2 = 2, 
		const uint32_t Ch3 = 3) = 0;

	virtual uint32_t SendTrigger(
		const uint32_t Trigger, 
		const uint32_t ExtTrigger,
		const uint32_t TriggerChannel,
		const uint32_t TriggerPrefetchSamples,
		const int  LowReference,
		const uint32_t  LowReferenceTime,
		const int HighReference,
		const uint32_t HighReferenceTime) = 0;

	virtual uint32_t SendAnalogInput(
		const uint32_t NoCh, 
		const SetAnalog * Settings) = 0;

	virtual uint32_t ReceiveSamples(
		const uint32_t WaitTime, /* just a integer */
		const uint32_t Start,
		uint32_t CaptureSize,    /* size in DWORDs*/
		uint32_t * FastMode,
		uint32_t * RawData) = 0;

	virtual void PrintSFR()=0;

	virtual uint32_t LoadProgram( 
		const char * FileName, 
		uint32_t StartAddr,
		uint32_t StackAddr) = 0;

protected:
	Protocoll(){};
	void PrintDesc(uint32_t *Data, uint32_t Length);
private:
	
};
#endif