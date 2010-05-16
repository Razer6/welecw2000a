/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : NormalUART.h
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

#ifndef NORMALUART_H
#define NORMALUART_H

#include "types.h"
#include "CPUComm.h"

class NormalUart : public CPUComm {
public:
	NormalUart();
	virtual uint32_t Init (
		char * Device, 
		const uint32_t TimeoutMS = 5000, 
		const uint32_t Baudrate  = 115200,
		char * IPAddr = "192.168.0.51");
	virtual ~NormalUart();
	virtual uint32_t Send(
		uint32_t * Data, 
		uint32_t Length);
	virtual uint32_t Receive(
		uint32_t * Data, 
		uint32_t Length);
	virtual uint8_t ReceiveByte();
	virtual uint32_t GetACK();
private:
};
    
#endif
