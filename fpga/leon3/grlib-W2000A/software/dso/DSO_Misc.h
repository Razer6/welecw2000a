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

void WaitMs(const unsigned int ms);

/* This functions are written as a work around for volatile compiler bugs.
 * TODO: They must be prooven for each compiler version to work! */
volatile int WaitUntilMaskedAndZero   (volatile int * volatile addr, int mask);
volatile int WaitUntilMaskedAndNotZero(volatile int * volatile addr, int mask);

/* timeout is just an integer, these are not ms! 
 * exits with false on timeout */
volatile bool WaitTimeoutAndZero   (volatile int * volatile addr, int mask, int timeout);
volatile bool WaitTimeoutAndNotZero(volatile int * volatile addr, int mask, int timeout);

int loadmem(volatile int addr);
char loadb(volatile int addr);

#endif
