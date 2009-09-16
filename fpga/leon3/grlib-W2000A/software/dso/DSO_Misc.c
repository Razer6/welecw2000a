/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Misc.c
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

#include "DSO_Misc.h"
#include "DSO_Main.h"
#include "grcommon.h"
static int snoopen;

void WaitMs(const unsigned int ms){
	const unsigned int x   = FIXED_CPU_FREQUENCY/4000;/* 1;*/
	volatile unsigned int i = 0;
	volatile unsigned int j = 0;
	for(i;i< ms; ++i){
		for(j = 0; j < x; ++j);
	}
}

/* This functions are written as a work around for volatile compiler bugs.
 * TODO: They must be prooven for each compiler version to work! */
volatile int WaitUntilMaskedAndZero(volatile int * volatile addr, int mask){
	volatile int temp;
	volatile int i = 0;	
	while(1) {
		temp = loadmem((int)addr);
		if ((temp & mask) == 0){
			return ++i;
		}
		i++;
	}
	return i;
}

volatile int WaitUntilMaskedAndNotZero(volatile int * volatile addr, int mask){
	volatile int temp;
	volatile int i = 0;	
	while(1) {
		temp = loadmem((int)addr);
		if ((temp & mask) != 0){
			return ++i;
		}
		i++;
	}
	return i;
}

volatile bool WaitTimeoutAndZero(volatile int * volatile addr, int mask, int timeout){
	volatile int temp;
	volatile int i = 0;	
	for(i = 0; i < timeout; ++i) {
		temp = loadmem((int)addr);
		if ((temp & mask) == 0){
			return true;
		}
		i++;
	}
	return false;
}

volatile bool WaitTimeoutAndNotZero(volatile int * volatile addr, int mask, int timeout){
	volatile int temp;
	volatile int i = 0;	
	for(i = 0; i < timeout; ++i) {
		temp = loadmem((int)addr);
		if ((temp & mask) != 0){
			return true;
		}
		i++;
	}
	return false;
}



int loadmem(volatile int addr)
{
  volatile int tmp;        
  if (snoopen) {
    __asm__ volatile (" ld [%1], %0 "
      : "=r"(tmp)
      : "r"(addr)
    );
  } else {
    __asm__ volatile (" lda [%1]1, %0 "
      : "=r"(tmp)
      : "r"(addr)
    );
  }
  return tmp;
}

char loadb(volatile int addr)
{
  volatile char tmp;        
  if (snoopen) {
    __asm__ volatile (" ldub [%1], %0 "
      : "=r"(tmp)
      : "r"(addr)
    );
  } else {
    __asm__ volatile (" lduba [%1]1, %0 "
      : "=r"(tmp)
      : "r"(addr)
    );
  }
  return tmp;
}	

