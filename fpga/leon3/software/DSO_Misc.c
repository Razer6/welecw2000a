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
#ifndef WINNT
#include "unistd.h"
#endif

#ifdef LEON3

#include "grcommon.h"
static int snoopen;

#else

#include "DebugComm.h"
static DebugComm * RemoteAccess;

void InitRemoteComm(DebugComm * R){
	RemoteAccess = R;
}

void RemoteSend(uint32_t addr, uint32_t data){
	RemoteAccess->Send((uint32_t)addr,&data,1);
}
void RemoteSend(uint32_t addr, uint32_t *data, uint32_t Length){
	RemoteAccess->Send((uint32_t)addr,data,Length);
}

inline uint32_t RemoteReceive(uint32_t addr) {
	uint32_t data;
	RemoteAccess->Receive(addr,&data,1);
	return data;
}

void RemoteReceive(uint32_t addr, uint32_t *data, uint32_t Length){
	RemoteAccess->Receive((uint32_t)addr,data,Length);
}

#endif

void WaitUs(const uint32_t us){
#ifdef LEON3
#ifdef BOARD_COMPILATION
	const uint32_t x   = FIXED_CPU_FREQUENCY/4000000;/* 1;*/
	volatile uint32_t i = 0;
	volatile uint32_t j = 0;
	for(i;i< us; ++i){
		for(j = 0; j < x; ++j);
	}
#endif
#elif WINNT
	Sleep(us/1000);
#else
	usleep(us);
#endif
}


void WaitMs(const uint32_t ms){
#ifdef LEON3
#ifdef BOARD_COMPILATION
	const uint32_t x   = FIXED_CPU_FREQUENCY/4000;/* 1;*/
	volatile uint32_t i = 0;
	volatile uint32_t j = 0;
	for(i;i< ms; ++i){
		for(j = 0; j < x; ++j);
	}
#endif
#elif WINNT
	Sleep(ms);
#else
	usleep(ms*1000);
#endif
}

/* This functions are written as a work around for volatile compiler bugs.
 * TODO: They must be prooven for each compiler version to work! */
uint32_t WaitUntilMaskedAndZero(volatile uint32_t addr, uint32_t mask){
	volatile uint32_t temp;
	volatile uint32_t i = 0;	
	while(1) {
		temp = READ_INT(addr);
		if ((temp & mask) == 0){
			return ++i;
		}
		i++;
	}
	return i;
}

uint32_t WaitUntilMaskedAndNotZero(volatile uint32_t addr, uint32_t mask){
	volatile uint32_t temp;
	volatile uint32_t i = 0;	
	while(1) {
		temp = READ_INT(addr);
		if ((temp & mask) != 0){
			return ++i;
		}
		i++;
	}
	return i;
}

uint32_t WaitTimeoutAndZero(volatile uint32_t addr, uint32_t mask, uint32_t timeout){
	volatile uint32_t temp;
	volatile uint32_t i = 0;	
	for(i = 0; i < timeout; ++i) {
		temp = READ_INT(addr);
		if ((temp & mask) == 0){
			return true;
		}
		i++;
	}
	return false;
}

uint32_t WaitTimeoutAndNotZero(volatile uint32_t addr, uint32_t mask, uint32_t timeout){
	volatile uint32_t temp;
	volatile uint32_t i = 0;	
	for(i = 0; i < timeout; ++i) {
		temp = READ_INT(addr);
		if ((temp & mask) != 0){
			return true;
		}
		i++;
	}
	return false;
}


#ifdef LEON3
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
#endif

