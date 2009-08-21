/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_SignalCTest.c
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


#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "grcommon.h"
#include "DSO_SignalCapture.h"
#include "DSO_Debugprint.h"
#include "Leon3Uart.h"
#include "DSO_Remote_Slave.h"
#include "DSO_Remote.h"
#include "DSO_SFR.h"
#include "DSO_Screen.h"
#include "DSO_Frontpanel.h"
#include "irqmp.h"

#define BOARDTEST 

#ifdef BOARDTEST
#define CAPTURESIZE 8000
/*#define CAPTURESIZE ((RAM_SIZE-0x100000)/sizeof(int))*/
#else
#define CAPTURESIZE 100000
#define SendStringBlock(A,B) 
#endif

#define FASTFS 1000000000
#define SLOWFS    500000

/* The generic uart is used normally by printf and scanf on LEON3 systems! 
 * So the SandboxX takes the generic uart with the DEBUG_UART_BASE_ADDR for 
 * the communication protocol. This is not possible for W2000A devices!
 * The W2000A devices do only have one uart, which is useable by the software.
 * So there is a need for a debug message header and therefore stdout 
 * must be redirected to another function. For this only _write_r and _read_r
 * need to be redirected */

long _write_r ( struct _reent *ptr, int fd, const void *buf, size_t cnt ) {
	register uint32_t i = 0;
	register char * buffer = (char*) buf;
	WRITE_INT(DSO_SFR_BASE_ADDR,7);
/*	SendStringBlock(GENERIC_UART_BASE_ADDR,buf);*/
#ifdef W2000A
	SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,DSO_SEND_HEADER);
	SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,DSO_MESSAGE_RESP);
#endif
/*	SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,buffer);*/
	for (i = 0; i < cnt; ++i){
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR,*buffer);
		buffer++;
	}
#ifdef W2000A
	SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR,'\0');
#endif 
	return cnt;
}

/* do not use scanf or so, if you don't now exactly what you doing! */
long _read_r ( struct _reent *ptr, int fd, const void *buf, size_t cnt ) {
	volatile int dummy = 0;
	register uint32_t i = 0;
	char * buffer = (char*)buf;
	WRITE_INT(DSO_SFR_BASE_ADDR,dummy);
/*	ReceiveStringBlock(GENERIC_UART_BASE_ADDR,buf,&cnt);*/
	for (i = 0; i < cnt; ++i){
		buffer[i] = ReceiveCharBlock(GENERIC_UART_BASE_ADDR);
	}
	return cnt;
}


static volatile uint32_t IRQMask;

void InitIRQ(){
	struct irqmp *lr =(struct irqmp*) INTERRUPT_CTL_BASE_ADDR;
	WRITE_INT(DSO_SFR_BASE_ADDR,15);
	lr->irqlevel = ((1 << 2) | (1 << 7));	/* clear level reg */
	lr->irqclear = -1;	/* clear all pending interrupts */
	lr->irqmask  = ((1 << 2) | (1 << 7));	/* mask all interrupts */
	IRQMask = lr->irqmask;
	lr->irqforce = ((1 << 2) | (1 << 7));

}

void DisableIRQ(){
	struct irqmp *lr =(struct irqmp*) INTERRUPT_CTL_BASE_ADDR;
	IRQMask = lr->irqmask;
	lr->irqmask = 0;
}

void ReleaseIRQ(){
	struct irqmp *lr =(struct irqmp*) INTERRUPT_CTL_BASE_ADDR;
	lr->irqmask = IRQMask;
}

typedef union {
	int i;
	short s[2];
	char  c[4];
} uSample;

int main () {
	uint32_t ReadData = 0;
	uart_regs * uart = (uart_regs *)GENERIC_UART_BASE_ADDR;
	uart_regs * uart2 = (uart_regs *)DEBUG_UART_BASE_ADDR;
	SetAnalog Analog[2];
	uSample Data[CAPTURESIZE];
	uint32_t i = 0;
	uint32_t ch1, ch2;
	uint32_t Prefetch = 64;
/*	static FILE mystdout = FDEV_SETUP_STREAM(SendDebugMessage, NULL );
	stdout = mystdout;*/

	Debugprint * Debug;
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

	volatile char x = 0;
	
	/* This is a workaround to share the serial port with the debug uart 
	 * and the generic uart on the W2000A! */
	/*WRITE_INT(CONFIGADCENABLE,0);*/ /* selecting the generic uart for the W2000A */
	/*WaitMs(1000);*/

	InitSignalCapture(Debug,PrintF,English);
	UartInit(FIXED_CPU_FREQUENCY,DSO_REMOTE_UART_BAUDRATE, 
			FIFO_EN | ENABLE_RX | ENABLE_TX | RX_INT /*| LOOP_BACK*/, uart);
#ifdef SBX
	UartInit(FIXED_CPU_FREQUENCY,DSO_REMOTE_UART_BAUDRATE, 
			FIFO_EN | ENABLE_RX | ENABLE_TX | RX_INT /*| LOOP_BACK*/, uart2);
#endif
/*	InitIRQ();*/
	

/* Uart communication test */
#ifdef SBX	
/*	for (i = 0; i < 256; ++i){
		SendStringBlock(uart2,"Test ");
	}
	for (i = 0; i < 1024; ++i){
		x = ReceiveCharBlock(uart2);
		SendCharBlock(uart2,x);
	}

	WRITE_INT(DSO_SFR_BASE_ADDR,x);
	x = ReceiveCharBlock(uart2);
	WRITE_INT(DSO_SFR_BASE_ADDR,x);
	WRITE_INT(DSO_SFR_BASE_ADDR,-1);*/
#endif
/*	SendStringBlock(uart,"Test console uart SendStringBlock send a letter received = ");
	x = ReceiveCharBlock(uart);
	SendCharBlock(uart,x);
	SendCharBlock(uart,'\n');
	WRITE_INT(DSO_SFR_BASE_ADDR,x);*/
/* The volatile read accesses do not work, this can be seen in simulation!
 * Look in the wave window and you will not find this two read accesses. 
 * To read volatile use the working function loadmem instead! */
/*	READ_INT(DSO_SFR_BASE_ADDR,x);
	READ_INT(DSO_SFR_BASE_ADDR,x);
	WRITE_INT(DSO_SFR_BASE_ADDR,-2);
	printf("Test console uart: write a letter\n");
	scanf("%c",&x);
	printf("Test console uart success received %c\n",x);
	while(1);*/

#ifdef W2000A
	InitDisplay(WELEC2022);
	DrawTest();
/*	while(1);*/
#endif

/* This is a basic function test of the SignalCapture part */

/*	printf("DSO Test programm: \nstart testing SetTriggerInput \n");
	if (SetTriggerInput(2,8,FASTFS,FIXED_CPU_FREQUENCY,0,2,0,1,2,3) == true){
		printf(ack);
	} else {
		printf(nak);
	}
	printf("testing SetTrigger\n");
	if (SetTrigger(4,0,0,64,3,0,30,1) == true){
		printf(ack);
	} else {
		printf(nak);
	}
	printf("testing SetAnalogInputRange\n");
	if (SetAnalogInputRange(2,Analog) == true){
		printf(ack);
	} else {
		printf(nak);
	}
	printf("testing FastCapture\n"); 
	ReadData = CaptureData(FASTFS, true, false, 100, Data);
	SetTriggerInput(1,16,SLOWFS,FIXED_CPU_FREQUENCY,0,2,0,1,2,3);
	printf("testing NormalCapture\n");
	SetTrigger(0,0,0,64,3,0,30,1);
	ReadData = CaptureData(SLOWFS, true, false, CAPTURESIZE, Data);*/



/*	ReadData = 3;
	printf(M6);
	ReceiveStringBlock(uart, M6, &ReadData);
	M6[ReadData] = '\0';
	printf(M6);
	SendCharBlock(uart,'\n');*/

#ifdef W2000A
	WaitMs(100);
	printf("\nStartFrontPanelTest\n");
	FrontPanelTest(uart);
	printf("\nSignalTest\n");

	SetTriggerInput(2,8,10000000,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	SetTrigger(3,0,0,Prefetch,3,0,30,1);
	while(1) {
		ReadData = CaptureData(FASTFS, true, true, 7000, (uSample*)Data);
		if (ReadData >= (6400+Prefetch)) {
			for (i = 0; i < 640; ++i){
				ch1 = ((uint32_t)Data[i+Prefetch].c[0]) + 128;
				ch1 = ch1 & 0x000000ff;
				/*
				ch2 = (Data[i+Prefetch] >> 16) + 128;
				ch2 = ch2 & 0x000000ff;
				ch2 = ch2 + 240;
				if (ch2 >= 480){
					ch2 = 480;
				}*/
				ch2 = ((uint32_t)Data[i*10+Prefetch].c[0]) + 128;
				ch2 = ch2 & 0x000000ff;
				ch2 = ch2 + 240;
				
				DrawPoint(-1,i,ch1);
				DrawPoint(0xAA,i,ch2);
			}
			WaitMs(100);
			DrawBox(0,0,0,639,479);
			DrawBox(x,630,470,639,479);
			x++;
		}
	}	
		
#endif


/* UART baudrate test */
/*	while(1){
		SendCharBlock(REMOTE_UART,++x); 
	}*/

	
	printf("\nStarting the remote control\n");
	RemoteSlave(REMOTE_UART,CAPTURESIZE,Data);	
	return 0;
}
