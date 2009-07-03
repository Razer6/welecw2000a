/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : NormalUART.cpp
* Author		 : Alexander Lindert <alexander_lindert at gmx.at>
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

#include "NormalUart.h"
#include "DSO_Remote.h"
#include "PCUart.h"

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
	return UartInit(Device,Baudrate,&mH);
}

uint32_t NormalUart::Send(uint32_t *Data, uint32_t Length)
{
	SendHeader(&mH);
	for (uint32_t i = 0; i < Length; ++i){
		SendInt(&mH,Data[i]);
	}
	crcInit();
	ChangeEndian(Data,Length);
	SendInt(&mH,crcFast((unsigned char*)Data,Length));
	return GetACK();
}

uint32_t NormalUart::Receive(uint32_t *Data, 
							 uint32_t Length, 
							 uint32_t * FastMode)
{
	return ReceiveData(&mH,Length,FastMode,Data);
}

uint32_t NormalUart::GetACK(){
	return ReceiveACK(&mH);
}
