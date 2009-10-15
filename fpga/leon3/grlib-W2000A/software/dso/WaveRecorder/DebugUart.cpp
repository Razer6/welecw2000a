/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DebungUart.cpp
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

#include "DebugUart.h"
#include "DSO_Remote.h"
#include "PCUart.h"
#ifdef WINNT
#include "Windows.h"
#else
#include "unistd.h"
#endif

DebugUart::~DebugUart(){
#ifdef WINNT
	CloseHandle(mH);
#else
	close(mH);
#endif
}

uint32_t DebugUart::Init(
				char * Device, 
				const uint32_t TimeoutMS, 
				const uint32_t Baudrate,
				char * IPAddr)
{
	uint32_t succ = UartInit(Device,Baudrate,&mH);
	// flushing the hardware debug uart interface
	// It is not nessesary, it just brings the debug interface to idle
	if (succ != 0) {
		Resync();
	}
	SetTimeoutMs(20);
	return succ;
}


uint32_t DebugUart::Send(
				uint32_t Addr,
				uint32_t *Data, 
				uint32_t Length)
{
	int32_t Len = (int32_t)(Length); 
	int32_t FrameLength = cFrameLength;
	int32_t FramePos = 0;
	int32_t i = 0;
	while (Len > 0){
		if (Len > cFrameLength) {
			FrameLength = cFrameLength;
		} else {
			FrameLength = Len;
		}
		/* b(7) = '1' request 
		 * b(6) = '1' write */
		SendCharBlock(&mH, 0xC0 | (FrameLength-1));
		SendInt(&mH,Addr+FramePos); // start address
		for (i = FramePos; i < (FramePos+FrameLength); ++i){
			SendInt(&mH,Data[i]);
		}
		FramePos += cFrameLength;
		Len -= cFrameLength;
	}
	return i;
}

uint32_t DebugUart::Receive(
					uint32_t Addr,
					uint32_t *Data, 
					uint32_t Length)
{
	int32_t Len = (int32_t)(Length); 
	int32_t FrameLength = cFrameLength;
	int32_t FramePos = 0;
	int32_t i = 0;
	uint32_t error;
	while (Len > 0){
		if (Len > cFrameLength) {
			FrameLength = cFrameLength;
		} else {
			FrameLength = Len;
		}
	
		SendCharBlock(&mH, 0x80 | (FrameLength-1));
		SendInt(&mH,Addr); // start address
#ifdef WINNT
		i = EV_TXEMPTY;
		WaitCommEvent(mH,(LPDWORD)&i,0);
#endif
		for (i = FramePos; i < (FramePos+FrameLength); ++i){
			Data[i] = GetIntX(&mH,&error);
			if (error != 0){
				return (uint32_t)i; /* last i is not counted by for*/
			}
		}
		FramePos += cFrameLength;
		Len -= cFrameLength;
	}
	return (uint32_t)i;
}

uint32_t DebugUart::GetACK(){
	return TRUE;
}

uint32_t DebugUart::ClearBuffer(){
	  return UART_Flush(&mH);
}

uint32_t DebugUart::Resync() {
	for(uint32_t i = 0; i < 18; ++i){
			SendInt(&mH,0x55555555);
	}
	return UART_Resync(&mH);
}

DebugUart::DebugUart(){}; //http://gcc.gnu.org/faq.html#vtables
