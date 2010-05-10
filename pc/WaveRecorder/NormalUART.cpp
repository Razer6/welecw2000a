/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : NormalUART.cpp
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 28.06.2009
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

#include "NormalUART.h"
#include "DSO_Remote.h"
#include "PCUart.h"
#ifdef WINNT
#include "Windows.h"
#else
#include "unistd.h"
#endif


NormalUart::~NormalUart(){
#ifdef WINNT
	CloseHandle(mH);
#else
	close(mH);
#endif
}

uint32_t NormalUart::Init(
				char * Device, 
				const uint32_t TimeoutMS, 
				const uint32_t Baudrate,
				char * IPAddr)
{
	uint32_t succ = UartInit(Device,Baudrate,&mH);
	SetTimeoutMs(TimeoutMS);
	if (succ != 0) {
		SendInt(&mH,0xAAAAAAAA);
	}
	return succ;
}


uint32_t NormalUart::Send(uint32_t *Data, uint32_t Length)
{
	SendHeader(&mH);
	for (uint32_t i = 0; i < Length; ++i){
		SendInt(&mH,Data[i]);
	}
	ChangeEndian(Data,Length*sizeof(uint32_t));
	crcInit();
	crc checksum = crcFast((unsigned char*)Data,Length*sizeof(uint32_t));
	//ChangeEndian(&checksum,1);
	SendInt(&mH,checksum);
	return Length;
}

uint32_t NormalUart::Receive(uint32_t *Data, 
							 uint32_t Length)
{
	return ReceiveAll(&mH,Length,Data,&Data[2]);
}

uint32_t NormalUart::GetACK(){
	return ReceiveAll(&mH,0,0,0);
}

NormalUart::NormalUart() {};	//http://gcc.gnu.org/faq.html#vtables
