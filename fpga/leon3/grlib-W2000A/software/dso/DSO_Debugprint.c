/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Debugprint.c
* Author		 : Alexander Lindert <alexander_lindert at gmx.at>
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


#include <stdlib.h>
#include <stdio.h>
#include "DSO_Debugprint.h"
#include "DSO_SFR.h"

#define printf printfdummy

void printfdummy(char * str){}

void TargetSilent() {}

void En_PrintfTarget() {
	int * CurrDevice = (int*)DEVICEADDR;
	printf("The current target board is ");
	switch (*CurrDevice) {
		case WELEC2012 : printf("WELEC2012A "); break;
		case WELEC2014 : printf("WELEC2014A "); break;
		case WELEC2022 : printf("WELEC2022A "); break;
		case WELEC2024 : printf("WELEC2022A "); break;
		case SANDBOXX  : printf("SandboxX ");   break;
		default        : printf("Unknown TODO: add it to DSO_SFR.h! "); break;
	}
	printf("\n");
}

void En_PrintfChannelsNotSupported(){
	printf("At least one channel is not supported!\n");
}

void En_PrintfNotAvialbe(){
	printf("Configuration not available!\n");
}

void En_PrintfToMuchPrefetchSamples(){
	printf("The prefetch size must be shorter than the signal capture buffer size!\n");
}

void En_PrintfAnalogInputGainNotSupported(){
	printf("The AnalogInputGain is not supported at the moment!\n");
}

void En_PrintfTriggerSettingsOutofRange(){
	printf("Trigger settings out of range!\n");
}

bool InitDebugprint (Debugprint * Init, Target T, Language L){
	/*TODO: switch(T), switch(L) ...*/
/*	(*Init).Target                      = &En_PrintfTarget;
	(*Init).ChannelsNotSupported        = &En_PrintfChannelsNotSupported;
	(*Init).NotAvialbe                  = &En_PrintfNotAvialbe;
	(*Init).ToMuchPrefetchSamples       = &En_PrintfToMuchPrefetchSamples;
	(*Init).AnalogInputGainNotSupported = &En_PrintfAnalogInputGainNotSupported;
	(*Init).TriggerSettingsOutofRange   = &En_PrintfTriggerSettingsOutofRange;*/
	return 0;
}
