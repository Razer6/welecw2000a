/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Misc.h
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
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
#ifndef DSO_MISC_H
#define DSO_MISC_H

#include "DSO_Main.h"

struct spwregs 
{
   volatile int ctrl;
   volatile int status;
   volatile int nodeaddr;
   volatile int clkdiv;
   volatile int destkey;
   volatile int time;
   volatile int unused[2];
   volatile int dmactrl;
   volatile int rxmaxlen;
   volatile int txdesc;
   volatile int rxdesc;
};

void WaitMs(const uint32_t ms);

/* This functions are written as a work around for volatile compiler bugs.
 * TODO: They must be prooven for each compiler version to work! */
uint32_t WaitUntilMaskedAndZero   (volatile uint32_t addr, uint32_t mask);
uint32_t WaitUntilMaskedAndNotZero(volatile uint32_t addr, uint32_t mask);

/* timeout is just an integer, these are not ms! 
 * exits with false on timeout */
uint32_t WaitTimeoutAndZero   (volatile uint32_t addr, uint32_t mask, uint32_t timeout);
uint32_t WaitTimeoutAndNotZero(volatile uint32_t addr, uint32_t mask, uint32_t timeout);

#ifdef LEON3
int loadmem(volatile int addr);
char loadb(volatile int addr);
#else
#include "DebugComm.h"
void InitRemoteComm(DebugComm * R);
void RemoteSend(uint32_t addr, uint32_t data);
void RemoteSend(uint32_t addr, uint32_t *data, uint32_t Length);
void RemoteReceive(uint32_t addr, uint32_t *data, uint32_t Length);
uint32_t RemoteReceive(uint32_t addr);
#endif

#endif
