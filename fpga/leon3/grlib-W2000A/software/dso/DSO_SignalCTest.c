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
	DrawBox(COLOR_R3G3B3(cnt,7,7),30,470,39,479);
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

void IsrDSU(int irq){
	if (irq == 5) {
		WRITE_INT(INTERRUPTADDR,0);
	} else {
		WRITE_INT(DSO_SFR_BASE_ADDR,16);
	}
}

static volatile uint32_t IRQMask;

void InitIRQ(){
	struct irqmp *lr =(struct irqmp*) INTERRUPT_CTL_BASE_ADDR;
	WRITE_INT(DSO_SFR_BASE_ADDR,15);
	lr->irqlevel = (/*(1 << INT_GENERIC_UART) | (1 << INT_DEBUG_UART) |*/ (1 << INT_DSO));	/* clear level reg */
	lr->irqclear = -1;	/* clear all pending interrupts */
	lr->irqmask  = (/*(1 << INT_GENERIC_UART) | (1 << INT_DEBUG_UART) |*/ (1 << INT_DSO));	/* mask all interrupts */
	IRQMask = lr->irqmask;
	lr->irqforce = (/*(1 << INT_GENERIC_UART) | (1 << INT_DEBUG_UART) |*/ (1 << INT_DSO));
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
	uint32_t Fs = 1000000000;

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
	WaitMs(100);
	WRITE_INT(CONFIGADCENABLE,0); /* selecting the generic uart for the W2000A */
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
	/* turning all DSO interrupts off (RESET) */
	
	WRITE_INT(INTERRUPTADDR,0);
	/* switching all DSO interrupts on */
	WRITE_INT(INTERRUPTMASKADDR,0xf);
	/* Enable the interrupt the interrupt controller */
	InitIRQ();
	catch_interrupt(IsrDSU, INT_DSO);

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
	ReadData = CaptureData(1000, true, false, 100, (uint32_t*)Data);
	
	WRITE_INT(DSO_SFR_BASE_ADDR,2);
	SetTriggerInput(2,8,FASTFS/2,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(1000, true, false, 100, (uint32_t*)Data);

	WRITE_INT(DSO_SFR_BASE_ADDR,4);
	SetTriggerInput(2,8,FASTFS/4,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(1000, true, false, 100, (uint32_t*)Data);

	WRITE_INT(DSO_SFR_BASE_ADDR,8);
	SetTriggerInput(2,8,FASTFS/8,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(1000, true, false, 100, (uint32_t*)Data);

	WRITE_INT(DSO_SFR_BASE_ADDR,10);
	SetTriggerInput(2,8,FASTFS/10,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(1000, true, false, 100, (uint32_t*)Data);

	/* with filtering */
	SetTriggerInput(2,8,FASTFS/1,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(1000, true, false, 100, (uint32_t*)Data);

	SetTriggerInput(2,8,FASTFS/2,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(1000, true, false, 100, (uint32_t*)Data);

	SetTriggerInput(2,8,FASTFS/4,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(1000, true, false, 100, (uint32_t*)Data);

	SetTriggerInput(2,8,FASTFS/8,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(1000, true, false, 100, (uint32_t*)Data);

	SetTriggerInput(2,8,FASTFS/10,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	ReadData = CaptureData(1000, true, false, CAPTURESIZE, (uint32_t*)Data);

	
	printf("testing NormalCapture\n");
	SetTriggerInput(2,8,SLOWFS,FIXED_CPU_FREQUENCY,0,0,0,1,2,3);
	SetTrigger(0,0,0,64,3,0,30,1);
	ReadData = CaptureData(10000, true, false, CAPTURESIZE, (uint32_t*)Data);


#endif


/*	ReadData = 3;
	printf(M6);
	ReceiveStringBlock(uart, M6, &ReadData);
	M6[ReadData] = '\0';
	printf(M6);
	SendCharBlock(uart,'\n');*/

/*	printf("\nStarting the remote control\n");
	RemoteSlave(REMOTE_UART,CAPTURESIZE,(uint32_t*)Data);*/

#ifdef W2000A
#ifdef BOARD_COMPILATION
	WaitMs(100);
//	printf("\nStartFrontPanelTest\n");
//	FrontPanelTest(uart);
//	printf("\nSignalTest\n");

#define PREFETCH_OFFSET 32
#define BG_COLOR COLOR_R3G3B3(1,1,1)
	Prefetch = HLEN;
	Fs = 1000000000;
	SetTriggerInput(4,8,1000000000,FIXED_CPU_FREQUENCY,0,3,0,1,2,3);
	SetTrigger(0,0,0,Prefetch,-3,0,1,0);
	ReadData = 0;
	memset(&Ch1[0],HLEN*sizeof(uSample),0);
	memset(&Ch2[0],HLEN*sizeof(uSample),0);
	memset(&Ch1[1],HLEN*sizeof(uSample),0);
	memset(&Ch2[1],HLEN*sizeof(uSample),0);
	SetAnalogInputRange(2,Analog);
	DrawBox(BG_COLOR,0,0,HLEN-1,VLEN-1);
	x = 50;

	while(1) {
		if (READ_INT(KEYADDR1) & (1 << BTN_F1) != 0){
			WRITE_INT(CONFIGADCENABLE,1); // Set back to Debug Uart
		}

		if ((READ_INT(KEYADDR1) & (1 << BTN_RUNSTOP)) == 0){
			ReadData = CaptureData(1000, true, true, 32768, (uint32_t*)Data);
		} else {
			ReadData = 0;
		}

		if (ReadData >= (6400+Prefetch)) {
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
			if ((x == 0) || ((READ_INT(KEYADDR1) & (1 << BTN_SINGLE)) != 0)) {
				DrawBox(BG_COLOR,0,0,HLEN-1,VLEN-1);
			}
			GetCh(0,8, &Ch1[CurrBuffer][0],&Data[0], HLEN+100);
		/*	DrawSignal(128,&Ch1[PrevBuffer][0].i, &Ch1[PrevBuffer][0].i,COLOR_R3G3B3(0,0,0), COLOR_R3G3B3(0,0,0));*/
			DrawSignal(128,&Ch1[PrevBuffer][0], &Ch1[CurrBuffer][0],COLOR_R3G3B3(0,0,0), COLOR_R3G3B3(0,7,0));

//			DrawHLine(COLOR_R3G3B3(7,7,7), 128+(VLEN/2), 0, HLEN-1);
			GetCh(1,8, CalcBuffer,&Data[0], HLEN+100);
			Interpolate(HLEN+(FILTER_COEFFS*2),&Ch2[CurrBuffer][0], CalcBuffer,0);
			DrawSignal(VLEN-128,&Ch2[PrevBuffer][FILTER_COEFFS], &Ch2[CurrBuffer][FILTER_COEFFS],COLOR_R3G3B3(0,0,0), COLOR_R3G3B3(0,7,7));

		//	WaitMs(50);
		
		}
		SetKeyFs(); 
	//	SetTriggerLevel();
		SetLeds();
		TestRotNobs();


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

	
	return 0;
}

static char M[80];
/*
void SetLed(uint32_t * data, uint32_t BTN_Bit, uint32_t LED_Bit) {
	if ((READ_INT(KEYADDR1) & (1 << BTN_Bit)) != 0){
		*data = *data | (1 << LED_Bit);
	} else {
		*data = *data & ~(1 << LED_Bit);
	}
}*/

#define SETLED(data, BTN_Bit, LED_Bit) \
	if ((READ_INT(KEYADDR1) & (1 << BTN_Bit)) != 0)\
		data = data | (1 << LED_Bit);\
	else	data = data & ~(1 << LED_Bit)


void SetLeds(){
	static uint32_t data = 0; //READ_INT(LEDADDR);
/*	if ((READ_INT(KEYADDR1) & (1 << BTN_CH0)) != 0)
		data = data | (1 << LED_CH0);
	else	data = data & ~(1 << LED_CH0);*/
	SETLED(data,BTN_CH0,LED_CH0);
	SETLED(data,BTN_CH1,LED_CH1);
	SETLED(data,BTN_CH2,LED_CH2);
	SETLED(data,BTN_CH3,LED_CH3);
	SETLED(data,BTN_MATH,LED_MATH);
	SETLED(data,BTN_QUICKMEAS,LED_QUICKMEAS);
	SETLED(data,BTN_CURSORS,LED_CURSORS);
	SETLED(data,BTN_MODECOUPLING,LED_WHEEL);
	SETLED(data,BTN_PULSEWIDTH,LED_PULSEWIDTH);
	SETLED(data,BTN_EDGE,LED_EDGE);
	SETLED(data,BTN_F1,RUN_GREEN);
	SETLED(data,BTN_F2,RUN_RED);
	SETLED(data,BTN_F3,SINGLE_GREEN);
	SETLED(data,BTN_F4,SINGLE_RED);
	WRITE_INT(LEDADDR,data);
}

void TestRotNobs(){

	static int32_t kl = 0;
	static int32_t sl = 0;
	static int32_t nob = 0;

	int32_t kc = 0;	
	int32_t move = 0;

	if ((READ_INT(KEYADDR1) & (1 << BTN_F3)) != 0){
		nob= 0;
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_F4)) != 0){
		nob= 1;
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_F5)) != 0){
		nob= 2;
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_F6)) != 0){
		nob= 3;
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_CURSORS)) != 0){
		nob= 4;
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_QUICKMEAS)) != 0){
		nob= 5;
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_EDGE)) != 0){
		nob= 6;
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_PULSEWIDTH)) != 0){
		nob= 7;
	}
        
	switch(nob){
		case 0: kc = (READ_INT(LEDADDR) >> EN_TIME_DIV) & 7;	break;
		case 1: kc = (READ_INT(LEDADDR) >> EN_LEFT_RIGHT) & 7;	break;
		case 2: kc = (READ_INT(LEDADDR) >> EN_LEVEL) & 7;	break;
		case 3: kc = (READ_INT(LEDADDR) >> EN_F) & 7;		break;
		case 4: kc = (READ_INT(KEYADDR0) >> EN_CH0_UPDN) & 7;	break;
		case 5: kc = (READ_INT(KEYADDR0) >> EN_CH1_UPDN) & 7;	break;
		case 6: kc = (READ_INT(KEYADDR0) >> EN_CH0_VDIV) & 7;	break;
		case 7: kc = (READ_INT(KEYADDR0) >> EN_CH1_VDIV) & 7;	break;

	}

	if (sl == 0){
		move = (kc - kl) % 4;
	}
	kl = kc;
	if (move != 0){
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"FLUSH");
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,DSO_SEND_HEADER);
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,DSO_MESSAGE_RESP);
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"move = ");
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR,'4' + move);
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '\n');
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '\0');
	}
	
}
void SetTriggerLevel(){
	static int32_t level = 0;
	static int32_t Pulse = 1;
	static int32_t Prefetch = 64;
	static uint32_t Trigger = 2;
	static uint32_t Ch = 0;
	static int32_t kl = 0;

	int32_t kc = (READ_INT(LEDADDR) >> EN_LEVEL) & 7;	
	int32_t move = (kc - kl) % 8;
	/*
	if ((READ_INT(KEYADDR1) & (1 << BTN_EDGE)) != 0) {
		Prefetch += move*8; // 8 = Trigger Alignment 8 samples @125MHz 
		if (Prefetch < 48) 	Prefetch = 48;
		if (Prefetch > 8192)	Prefetch = 8192;
		
	} else if ((READ_INT(KEYADDR1) & (1 << BTN_PULSEWIDTH)) != 0) {
		Pulse += move;
		if (Pulse < 0) Pulse = 0;
		if (Pulse > 100) Pulse = 100;
	} else {
		level += move;
	}*/
	if (move != 0){
	SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,DSO_SEND_HEADER);
	SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,DSO_MESSAGE_RESP);
	SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"level = ");
	level += move;
	SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR,'0' + level);
	SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '\n');
	SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '\0');
	}
/*	if ((READ_INT(KEYADDR1) & (1 << BTN_MODECOUPLING)) != 0) {
		Trigger = (Trigger+1)%MAX_TRIGGER_TYPES;
	}*/
	if ((READ_INT(KEYADDR1) & (1 << BTN_CH0)) != 0){
		Ch = 0;
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_CH1)) != 0){
		Ch = 1;
	}
//	SetTrigger(Trigger,0,Ch, Prefetch,level+2,Pulse,level-2,Pulse);

}

void SetKeyFs(){
	static int32_t kp = 0;
	static int32_t exp = 10000000; /* 100 MS/s*/
	static uint32_t mant = 100;
	volatile int32_t kc = (READ_INT(LEDADDR) >> EN_TIME_DIV) & 7;
	int32_t move = (kp - kc) % 8;
	kp = kc;
	if (move < 0){
		switch (mant) {
		case 100:  if (exp != 10000000) {
			   	   mant = 125;
			   }
			  break;  
		case 125:	mant = 250; break;
		case 250:	mant = 500; break;
		case 500: 	mant = 100;
				exp = exp*10;
			break;
		} 	
	} 
	if (move > 0) {
		switch (mant) {
		case 100: if (exp != 1000) {
				mant = 500;
				exp = exp/10;
			} 
			break;  
		case 125:	mant = 100; break;
		case 250:	mant = 125; break;
		case 500: 	mant = 250; break;
		} 
	}
	if (move != 0){
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,DSO_SEND_HEADER);
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,DSO_MESSAGE_RESP);
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"mant = ");
		switch(mant){
		case 100:	kc = 0; break;  
		case 125:	kc = 1; break;
		case 250:	kc = 2; break;
		case 500:       kc = 5; break;
		}
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR,'0' + kc);
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR, " exp = ");
		move = exp;
		kc = 0;
		while (move > 1){
			move /= 10;
			kc++;
		}
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '0' + kc);
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '\n');
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '\0');

	}
//	sprintf(M,"\n mant = %d, exp = %d, fs = %d\n",mant, exp, mant*exp);
//	printf("\n mant = %d, exp = %d, fs = %d\n",mant, exp, mant*exp);
	SetTriggerInput(4,8,(const uint32_t)mant*exp,FIXED_CPU_FREQUENCY,0,1,0,1,2,3);
}


