/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : LEON3_DSU.h
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 30.09.2009
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
#ifndef LEON3_DSU_H
#define LEON3_DSU_H

#include "DSO_Main.h"

#define DSUSIZE        0x1000000
#define DSU_CTL        (DSU_BASE_ADDR+ 0x000)
#define DSU_DBGMODE    (DSU_BASE_ADDR+ 0x040)
#define DSU_ERRMODE    (DSU_BASE_ADDR+ 0x200)
#define DSU_REGFILE    (DSU_BASE_ADDR+ 0x300000)
#define DSU_REG_Y      (DSU_BASE_ADDR+ 0x400000)
#define DSU_REG_PSR    (DSU_BASE_ADDR+ 0x400004)
#define DSU_REG_WIM    (DSU_BASE_ADDR+ 0x400008)
#define DSU_REG_TBR    (DSU_BASE_ADDR+ 0x40000C)
#define DSU_REG_PC     (DSU_BASE_ADDR+ 0x400010)
#define DSU_REG_NPC    (DSU_BASE_ADDR+ 0x400014)
#define DSU_REG_TRAP   (DSU_BASE_ADDR+ 0x400020)
#define DSU_REG_ASI    (DSU_BASE_ADDR+ 0x400024)


/* DSU_CTL */
#define DSU_DEBUGMODE  (1 << 6)
#define DSU_EE         (1 << 7)
#define DSU_EB         (1 << 8)
#define DSU_PE         (1 << 9)
#define DSU_HL         (1 << 10)
#define DSU_PW         (1 << 11)

/* DSU_PE Write 1 to it and it clears the error and starts the CPU */
/* DSU_HL Write 1 to it and it stops the CPU */

/* DSU_REGFILE */
#define NWINDOWS       32
#define WINDOW_SIZE    64
#define REG_GLOBAL_OFF  0 
#define REG_OUT_OFF    32
#define REG_LOCAL_OFF  64
#define REG_IN         96

/* DSU_REG_PSR  */
#define PSR_REG_INIT 0xF30000E0

/* DSU_REG_WIM  */
#define START_WINDOW 2

/* DSU_REG_TBR  */
#define START_TBR    0x40000000
#define START_ADDR   0x40000000

#endif
