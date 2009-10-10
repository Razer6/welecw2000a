/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : Protocoll.cpp
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 10.10.2009
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

#include "Protocoll.h"
#include "stdio.h"
#include "DSO_SFR.h"

void PrintSFR_Console(uint32_t *Data, uint32_t Length);

void Protocoll::PrintDesc(uint32_t *Data, uint32_t Length){
	PrintSFR_Console(Data,Length);
}


void PrintSFR_Console(uint32_t *Data, uint32_t Length){
static const char Desc[32][40] = {
             "DEVICEADDR                0 = %d\n",
			 "INTERRUPTADDR             1 = %#x\n",
			 "INTERRUPTMASKADDR         2 = %#x\n",
			 "NOT IMPLEMENTED           3 = %#x\n",
			 "SAMPLINGFREQADDR          4 = %#x\n",
			 "FILTERENABLEADDR          5 = %#x\n",
			 "EXTTRIGGERSRCADDR         6 = %#x\n",
			 "EXTTRIGGERPWMADDR         7 = %#x\n",
			 "INPUTCH0ADDR              8 = %#x\n",
			 "INPUTCH1ADDR              9 = %#x\n",
			 "INPUTCH2ADDR             10 = %#x\n",
			 "INPUTCH3ADDR             11 = %#x\n",
			 "TRIGGERONCHADDR          12 = %#x\n",
			 "TRIGGERONCEADDR          13 = %#x\n",
             "TRIGGERPREFETCHADDR      14 = %d\n",
			 "TRIGGERSTORAGEMODEADDR   15 = %#x\n",
			 "TRIGGERREADOFFSETADDR    16 = %#x\n",
			 "TRIGGERTYPEADDR          17 = %#x\n",
			 "TRIGGERLOWVALUEADDR      18 = %d\n",
			 "TRIGGERLOWTIMEADDR       19 = %d\n",
			 "TRIGGERHIGHVALUEADDR     20 = %d\n",
			 "TRIGGERHIGHTIMEADDR      21 = %d\n",
             "TRIGGERSTATUSREGISTER    22 = %d\n",
			 "TRIGGERCURRENTADDR       23 = %#x\n",
			 "CONFIGADCENABLE          24 = %#x\n",
			 "LEDADDR                  25 = %#x\n",
			 "KEYADDR0                 26 = %#x\n",
			 "KEYADDR1                 27 = %#x\n",
			 "ANALOGSETTINGSPWMADDR    28 = %#x\n",
			 "ANALOGSETTINGSBANK7      29 = %#x\n", 
			 "ANALOGSETTINGSBANK6      30 = %#x\n", 
			 "ANALOGSETTINGSBANK5      31 = %#x\n"
	};
	if (Length > (DSO_REG_SIZE/sizeof(uint32_t))){
		Length = DSO_REG_SIZE/sizeof(uint32_t);
	}
	printf("\n\n   DSO Special Function Register \n");
	for (uint32_t i = 0; i < Length; ++i){
		printf(Desc[i],Data[i]);
	}
	printf("\n\n");
}