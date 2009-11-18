/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Main.h
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
#ifndef DSO_MAIN_H
#define DSO_MAIN_H

#include "types.h"

/* as long as we are not officiell supported on the leon3 grlib*/
/* these defines belong to here an not in grcommon.h*/
/* The DSO is set under the vendor FH Hagenberg, because I made*/
/* the VHDL part as master thesis there*/
#define VENDOR_FHH 	      0x18
/* important devices from VENDOR_FHH*/
#define FHH_DSO_SFR           0x02
#define FHH_DSO_SIGNALACCESS  0x16

/* the internal ROM will be replaced some times, when the */
/* new implementation is better than the old one*/
#define ROM_BASE_ADDR 0x00000000
#define ROM_SIZE      0x00800000

#define RAM_BASE_ADDR_UNCACHED_MIRROR  0x20000000
#define RAM_BASE_ADDR                  0x40000000

/* only for SRAM DSOs */

#define TRIGGER_MEM_BASE_ADDR          0xa0000000
#define TRIGGER_MEM_SIZE               0x00008000

#define DSO_SFR_BASE_ADDR              0x80000500

/* The CPU frequency must be set correctly or the function CaptureData gets sometimes crasy!*/
#ifdef W2000A 
/* 2 MB */
#define RAM_SIZE             0x00200000
#define FIXED_CPU_FREQUENCY  31250000
#define SVGA_BUFFER_BASE     (RAM_BASE_ADDR+0x00100000)
#else
#ifdef SBX
/* 16 MB */
#define RAM_SIZE             0x01000000
#define FIXED_CPU_FREQUENCY  12500000
#define SVGA_BUFFER_BASE     (RAM_BASE_ADDR+0x00100000)
#else
/* 2 MB */
#define RAM_SIZE             0x00200000
#define FIXED_CPU_FREQUENCY  12500000
#define SVGA_BUFFER_BASE     (RAM_BASE_ADDR+0x00100000)
#endif
#endif

/*int return SamplingFrequency/(CPUFrequency*FASTMODEFACTOR);*/
#define FASTMODEFACTOR       10




/* base addresses of the grip components*/
#define DSU_BASE_ADDR            0x90000000
#define DSU_MEM_SIZE             0x10000000

#define AHB_APB_BRIDE_BASE_ADDR  0x80000000
#define APB_MEM_SIZE             0x00100000

#define MEM_CONTROL_BASE_ADDR    0x80000000
#define GENERIC_UART_BASE_ADDR   0x80000100
#define INTERRUPT_CTL_BASE_ADDR  0x80000200
#define TIMER_BASE_ADDR          0x80000300
#define VGA_CONFIG_BASE_ADDR     0x80000600
#define DEBUG_UART_BASE_ADDR     0x80000700 
#define UART_CHCFG_BASE_ADDR     0x80000800

#ifdef LEON3
#define WRITE_INT(addr,data) (*(volatile uint32_t*)addr) = (uint32_t)data
#define READ_INT(addr) loadmem(addr)
/* obsolete, because it does not work */
/*define  READ_INT(addr,data) data = *(volatile uint32_t*)(addr)*/
#else
#define WRITE_INT(addr,data) RemoteSend((uint32_t)addr,data)
#define READ_INT(addr) RemoteReceive(addr)
#endif

/* INTERRUPT_CTL_BASE_ADDR */
#define INT_GENERIC_UART  2
#define INT_DSO           5
#define INT_DEBUG_UART    7
#define INT_TIMER         8


#endif
