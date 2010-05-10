/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : RemoteSignalCapture.h
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 29.06.2009
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
#ifndef REMOTESIGNALCAPTURE_H
#define REMOTESIGNALCAPTURE_H

#include "Protocoll.h"
#include "DSO_SignalCapture.h"
#include "DebugComm.h"


class RemoteSignalCapture : public Protocoll {
public:
    RemoteSignalCapture(DebugComm * Comm);
	virtual uint32_t InitComm(
		char * Device, 
		const uint32_t TimeoutMS = 5000, 
		const uint32_t Baudrate  = 115200,
		char * IPAddr = "192.168.0.51");

	virtual uint32_t SendTriggerInput (	
			const uint32_t noChannels, 
			const uint32_t SampleSize, 
			const uint32_t SamplingFrequency,
			const uint32_t AACFilterStart,
			const uint32_t AACFilterStop,
			const uint32_t Ch0, 
			const uint32_t Ch1, 
			const uint32_t Ch2, 
			const uint32_t Ch3);

/* reference time in samples*/
	virtual uint32_t SendTrigger(
		const uint32_t Trigger, 
		const uint32_t ExtTrigger,
		const uint32_t TriggerChannel,
		const uint32_t TriggerPrefetchSamples,
		const int  LowReference,
		const uint32_t  LowReferenceTime,
		const int HighReference,
		const uint32_t HighReferenceTime);


	virtual uint32_t SendAnalogInput(
		const uint32_t NoCh, 
		const SetAnalog * Settings);

/* returns read DWORDS*/
	virtual uint32_t ReceiveSamples(
		const uint32_t WaitTime, /* just a integer */
		const uint32_t Start,
		uint32_t CaptureSize,    /* size in DWORDs*/
		uint32_t * FastMode,
		uint32_t * RawData); 

	virtual void PrintSFR();

	virtual uint32_t Receive(
		uint32_t addr,
		uint32_t size);

	virtual uint32_t LoadProgram( 
		const char * FileName, 
		uint32_t StartAddr,
		uint32_t StackAddr);

	virtual uint32_t Debug();

        virtual uint32_t SendRAWFile(
		uint32_t StartAddr,
		const char * FileName);

	virtual uint32_t Send(
		uint32_t Addr, 
		uint32_t *Data, 
		uint32_t & Length);

   	virtual uint32_t Receive(
		uint32_t Addr, 
		uint32_t *Data, 
		uint32_t & Length);
	
	virtual uint32_t Screenshot(
		const char *filename);


private:
	/* return retrys */
	uint32_t SendRetry(
		uint32_t addr,
		uint32_t data);

	/* return retrys */
	uint32_t SendRetry(
		uint32_t addr,
		uint32_t * data,
		uint32_t & length);

	void PrintTraps();  
        void PrintBackTrace(); 

	uint32_t FastMode(	
		const uint32_t SamplingFrequncy, 
		const uint32_t CPUFrequency);
	uint32_t IsFastMode();


	uint32_t AddrData[2];
   uint32_t Send(uint32_t Addr, uint32_t Data);
   uint32_t Receive(uint32_t Addr);
//   void WaitUntilMaskedAndZero(uint32_t Addr, uint32_t Ref);
//   void WaitMs(uint32_t Miliseconds);
private:
	DebugComm * mComm;
	static const uint32_t cFrameSize = 64;
	static const uint32_t cMaxRetrys = 64;
};

#endif
