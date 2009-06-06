/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_SignalCTest.c
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
#include <string.h>
#include "grcommon.h"
#include "DSO_SignalCapture.h"
#include "DSO_Debugprint.h"
#include "Leon3Uart.h"
#include "DSO_Remote_Slave.h"
#include "DSO_Remote.h"

/*#define BOARDTEST*/ 

#ifdef BOARDTEST
#define CAPTURESIZE ((RAM_SIZE-0x100000)/sizeof(int))
#else
#define CAPTURESIZE 100000
#define SendStringBlock(A,B) 
#endif

#define FASTFS 500000000
#define SLOWFS    500000
int main () {
	int ReadData = 0;
	uart_regs * uart = (uart_regs *)GENERIC_UART_BASE_ADDR;
	uart_regs * uart2 = (uart_regs *)DEBUG_UART_BASE_ADDR;
	SetAnalog Analog[2];
	int Data[CAPTURESIZE];
	Debugprint * Debug;
	char M6[] = "loopback test send 3 characters back ";
	char ack[] = "success!\n";
	char nak[] = "failed!\n";

/*	Analog[0].myVperDiv = 100000;
	Analog[0].AC = 0;
	Analog[0].Mode = normal;
	Analog[0].DA_Offset = 0xaa;
	Analog[0].PWM_Offset = 0xf1;
	Analog[1].myVperDiv = 100000;
	Analog[1].AC = 1;
	Analog[1].Mode = normal;
	Analog[1].DA_Offset = 0xf1;
	Analog[1].PWM_Offset = 0xf1;*/
	
	InitSignalCapture(Debug,PrintF,English);
	UartInit(FIXED_CPU_FREQUENCY,115200, ENABLE_RX | ENABLE_TX, uart);
/*	SendCharBlock(uart,255);*/
	SendStringBlock(uart,"DSO Test programm: \nstart testing SetTriggerInput \n");
	if (SetTriggerInput(2,8,FASTFS,FIXED_CPU_FREQUENCY,0,2,0,1,2,3) == true){
		SendStringBlock(uart,ack);
	} else {
		SendStringBlock(uart,nak);
	}
	SendStringBlock(uart,"testing SetTrigger\n");
	if (SetTrigger(0,0,64,3,3,30,3) == true){
		SendStringBlock(uart,ack);
	} else {
		SendStringBlock(uart,nak);
	}
	SendStringBlock(uart,"testing SetAnalogInputRange\n");
	if (SetAnalogInputRange(2,Analog) == true){
		SendStringBlock(uart,ack);
	} else {
		SendStringBlock(uart,nak);
	}
	SendStringBlock(uart,"testing FastCapture\n"); 
	ReadData = CaptureData(1000000, true, false, CAPTURESIZE, Data);
	SetTriggerInput(2,16,SLOWFS,FIXED_CPU_FREQUENCY,0,2,0,1,2,3);
	SendStringBlock(uart,"testing NormalCapture\n");
	ReadData = CaptureData(1000000, true, false, CAPTURESIZE, Data);
/*
	ReadData = 3;
	SendStringBlock(uart,M6);
	ReceiveStringBlock(uart, M6, &ReadData);
	M6[ReadData] = '\0';
	SendStringBlock(uart,M6);
	SendCharBlock(uart,'\n');
*/	
	UartInit(FIXED_CPU_FREQUENCY,DSO_REMOTE_UART_BAUDRATE, ENABLE_RX | ENABLE_TX, uart2);
/*	SendCharBlock(uart2,M6);*/
	RemoteSlave(uart2,CAPTURESIZE,Data);	
/*	printf("End SFR Test\n");*/
	return 0;
}
