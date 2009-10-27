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
#include "Leon3Uart.h"
#include "DSO_Remote_Slave.h"
#include "DSO_Remote.h"
#include "DSO_SFR.h"
#include "DSO_Screen.h"
#include "DSO_FrontPanel.h"
#include "Filter_I8.h"
#include "irqmp.h"
#include "DSO_Misc.h"
#include "DSO_FrontPanel.h"
#include "DSO_GUI.h"


#ifdef BOARD_COMPILATION
#define CAPTURESIZE 8192
/*#define CAPTURESIZE ((RAM_SIZE-0x100000)/sizeof(int))*/
#else
#define CAPTURESIZE 100000
#define SendStringBlock(A,B) 
#define printf(...)
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
#ifdef BOARD_COMPILATION
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
#endif
	return cnt;
}

/* do not use scanf or so, if you don't now exactly what you doing! */
long _read_r ( struct _reent *ptr, int fd, const void *buf, size_t cnt ) {
#ifdef BOARD_COMPILATION
	volatile int dummy = 0;
	register uint32_t i = 0;
	char * buffer = (char*)buf;
	WRITE_INT(DSO_SFR_BASE_ADDR,dummy);
/*	ReceiveStringBlock(GENERIC_UART_BASE_ADDR,buf,&cnt);*/
	for (i = 0; i < cnt; ++i){
		buffer[i] = ReceiveCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR);
	}
#endif
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


int main () {
	uint32_t ReadData = 0;
	uart_regs * uart = (uart_regs *)GENERIC_UART_BASE_ADDR;
	uart_regs * uart2 = (uart_regs *)DEBUG_UART_BASE_ADDR;
	SetAnalog Analog[2];
	uSample Data[CAPTURESIZE];
	uSample Ch1[2][HLEN+100];
	uSample Ch2[2][HLEN+100];
	uSample CalcBuffer[HLEN+100];
	uint32_t PrevBuffer = 0;
	uint32_t CurrBuffer = 1;

	uint32_t i = 0;
	uint32_t Prefetch = 64;

	char ack[] = "success!\n";
	char nak[] = "failed!\n";
	char x = 0;

	Analog[0].myVperDiv = 10000;
	Analog[0].AC = 0;
	Analog[0].Mode = normal;
	Analog[0].DA_Offset = 0xaa;
//	Analog[0].PWM_Offset = 0xf1;
	Analog[1].myVperDiv = 10000;
	Analog[1].AC = 1;
	Analog[1].Mode = normal;
	Analog[1].DA_Offset = 0xf1;
//	Analog[1].PWM_Offset = 0xf1;
	
	/* This is a workaround to share the serial port with the debug uart 
	 * and the generic uart on the W2000A! */
	/*WRITE_INT(CONFIGADCENABLE,0);*/ /* selecting the generic uart for the W2000A */
	/*WaitMs(1000);*/

	InitSignalCapture();
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
#ifdef BOARD_COMPILATION
	InitDisplay(WELEC2022);
//	DrawTest();
/*	while(1);*/
#endif 
#endif

/* This is a basic function test of the SignalCapture part */
#ifdef SIM_COMPILATION
	printf("DSO Test programm: \nstart testing SetTriggerInput \n");
	if (SetTriggerInput(2,8,FASTFS,FIXED_CPU_FREQUENCY,0,0,0,1,2,3) == true){
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
/* The analog settings do not work for now!
 * If you want to simulate this, you need to change cAnSettStrobeRate 
 * at least to 1E6 in the target dependent DSOConfig-p.vhd 
 * to speed up the simulation */
	/*
	printf("testing SetAnalogInputRange\n");
	if (SetAnalogInputRange(2,Analog) == true){
		printf(ack);
	} else {
		printf(nak);
	}*/
	
	/* without filtering */
	printf("testing FastCapture\n"); 
	WRITE_INT(DSO_SFR_BASE_ADDR,1);
	ReadData = CaptureData(FASTFS, true, false, 100, (uint32_t*)Data);
	
	WRITE_INT(DSO_SFR_BASE_ADDR,2);
	SetTriggerInput(2,8,FASTFS/2,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(FASTFS, true, false, 100, (uint32_t*)Data);

	WRITE_INT(DSO_SFR_BASE_ADDR,4);
	SetTriggerInput(2,8,FASTFS/4,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(FASTFS, true, false, 100, (uint32_t*)Data);

	WRITE_INT(DSO_SFR_BASE_ADDR,8);
	SetTriggerInput(2,8,FASTFS/8,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(FASTFS, true, false, 100, (uint32_t*)Data);

	WRITE_INT(DSO_SFR_BASE_ADDR,10);
	SetTriggerInput(2,8,FASTFS/10,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(FASTFS, true, false, 100, (uint32_t*)Data);

	/* with filtering */
	SetTriggerInput(2,8,FASTFS/1,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(FASTFS, true, false, 100, (uint32_t*)Data);

	SetTriggerInput(2,8,FASTFS/2,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(FASTFS, true, false, 100, (uint32_t*)Data);

	SetTriggerInput(2,8,FASTFS/4,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(FASTFS, true, false, 100, (uint32_t*)Data);

	SetTriggerInput(2,8,FASTFS/8,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(FASTFS, true, false, 100, (uint32_t*)Data);

	SetTriggerInput(2,8,FASTFS/10,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(FASTFS, true, false, CAPTURESIZE, (uint32_t*)Data);

	
	printf("testing NormalCapture\n");
	SetTriggerInput(2,8,SLOWFS,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	SetTrigger(0,0,0,64,3,0,30,1);
	ReadData = CaptureData(SLOWFS, true, false, CAPTURESIZE, (uint32_t*)Data);


#endif


/*	ReadData = 3;
	printf(M6);
	ReceiveStringBlock(uart, M6, &ReadData);
	M6[ReadData] = '\0';
	printf(M6);
	SendCharBlock(uart,'\n');*/

#ifdef W2000A
#ifdef BOARD_COMPILATION
	WaitMs(100);
//	printf("\nStartFrontPanelTest\n");
//	FrontPanelTest(uart);
//	printf("\nSignalTest\n");

#define PREFETCH_OFFSET 32
#define BG_COLOR COLOR_R3G3B3(1,1,1)
	Prefetch = HLEN;
	SetTriggerInput(4,8,1000000000,FIXED_CPU_FREQUENCY,0,1,0,1,2,3);
	SetTrigger(0,0,0,Prefetch,0,3,-3,3);
	ReadData = 0;
	memset(Ch1,HLEN*2*sizeof(uSample),0);
	memset(Ch2,HLEN*2*sizeof(uSample),0);
	SetAnalogInputRange(2,Analog);
	DrawBox(BG_COLOR,0,0,HLEN-1,VLEN-1);
	while(1) {
		if (CurrBuffer != 0) {
			CurrBuffer = 0;
			PrevBuffer = 1;
			DrawBox(x,0,470,9,479);
		} else {
			CurrBuffer = 1;
			PrevBuffer = 0;
			DrawBox(x,30,470,39,479);
		}
		x++;
		ReadData = CaptureData(FASTFS, true, true, 32768, (uint32_t*)Data);

		if (ReadData >= (6400+Prefetch)) {
			GetCh(0,8, &Ch1[CurrBuffer][0],&Data[0], HLEN+100);
		/*	DrawSignal(128,&Ch1[PrevBuffer][0].i, &Ch1[PrevBuffer][0].i,COLOR_R3G3B3(0,0,0), COLOR_R3G3B3(0,0,0));*/
			DrawSignal(128,&Ch1[PrevBuffer][0], &Ch1[CurrBuffer][0],COLOR_R3G3B3(0,0,0), COLOR_R3G3B3(0,7,0));

//			DrawHLine(COLOR_R3G3B3(7,7,7), 128+(VLEN/2), 0, HLEN-1);
			GetCh(1,8, CalcBuffer,&Data[0], HLEN+100);
			Interpolate(HLEN+(FILTER_COEFFS*2),&Ch2[CurrBuffer][0], CalcBuffer,0);
			DrawSignal(VLEN-128,&Ch2[PrevBuffer][FILTER_COEFFS], &Ch2[CurrBuffer][FILTER_COEFFS],COLOR_R3G3B3(0,0,0), COLOR_R3G3B3(0,7,7));
	
			WaitMs(50);
			if (x == 0) {
				DrawBox(BG_COLOR,0,0,HLEN-1,VLEN-1);
			}
		}
/*		DrawBox(x,0,0,x,480);
		x++; if (x>=640) x=0;
*/
	}	
#endif	
#endif


/* UART baudrate test */
/*	while(1){
		SendCharBlock(REMOTE_UART,++x); 
	}*/

	
	printf("\nStarting the remote control\n");
	RemoteSlave(REMOTE_UART,CAPTURESIZE,(uint32_t*)Data);	
	return 0;
}
