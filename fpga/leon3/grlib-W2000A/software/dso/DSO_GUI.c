/*****************************************************************************
* File           : DSO_GUI.c
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 07.09.2009
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


#include "types.h"
#include "DSO_Main.h"
#include "DSO_Screen.h"
#include "Filter_I8.h"
#include "DSO_SFR.h"
#include "DSO_SignalCapture.h"
#include "Leon3Uart.h"
#include "rprintf.h"
#include "stdio.h"
#include "string.h"
#include "DSO_Misc.h"
#include "LEON3_DSU.h"

#define SIGNAL_HSTART 0
#define SIGNAL_HSTOP  HLEN

/* Colors of planes 0 to 4 mixed with OR logic on the fly */
#define CH0_COLOR COLOR_L2R2G2B2(2,3,3,0)
#define CH1_COLOR COLOR_L2R2G2B2(2,0,3,0)
#define CH2_COLOR COLOR_L2R2G2B2(2,0,0,3)
#define CH3_COLOR COLOR_L2R2G2B2(2,3,0,0)
#define GRID_COLOR COLOR_L2R2G2B2(0,0,1,0)

/* Colors of planes 5 to 7 are mixed with AND logic on the fly */
#define MENU_COLOR COLOR_L2R2G2B2(2,3,3,3)
#define F0_COLOR COLOR_L2R2G2B2(2,3,0,0)
#define F1_COLOR COLOR_L2R2G2B2(2,3,0,0)


#define PREFETCH_OFFSET 32

#define SETLED(data, BTN_Bit, LED_Bit) \
	if ((READ_INT(KEYADDR1) & (1 << BTN_Bit)) != 0)\
		data = data | (1 << LED_Bit);\
	else	data = data & ~(1 << LED_Bit)

#ifdef BOARD_COMPILATION

typedef struct {
	int32_t V;
	int32_t H;
} DispOffset;

void SetAnalogOffset ();
void SetTriggerLevel();
void SetKeyFs();
void SetLeds();
void SetVoltagePerDivision();

typedef struct {
	int32_t P;
	int32_t C;
} SampleRet;

void DrawSample(
		color_t ColorSignal,
		uint32_t v,
		SampleRet hp,
		SampleRet hc);

void DrawSignal(
		uint32_t Voffset, 
		uSample * PrevData,
		uSample * CurrData,
		color_t CurrColor){

	register uint32_t i = SIGNAL_HSTART+1;
	register SampleRet Prev;
	register SampleRet Curr;

	Prev.C = CurrData[SIGNAL_HSTART].i + Voffset;
	if (Prev.C < 0)     Prev.C = 0;
	if (Prev.C >= VLEN) Prev.C = VLEN-1;
	Prev.P = PrevData[SIGNAL_HSTART].i + Voffset;
	if (Prev.P < 0)     Prev.P = 0;
	if (Prev.P >= VLEN) Prev.P = VLEN-1;

	for (; i < SIGNAL_HSTOP; ++i){
/*		Prev = PrevData[i].i + Voffset;
		lastPrev = DrawSample(PrevColor,i,Prev,lastPrev);
		Curr = CurrData[i].i + Voffset;
		lastCurr = DrawSample(CurrColor,i,Curr,lastCurr);*/
		Curr.P = PrevData[i].i + Voffset;
		Curr.C = CurrData[i].i + Voffset;
		/* avoid drawing out of screen only once per sample (return value)*/
		if (Curr.P < 0)     Curr.P = 0;
		if (Curr.P >= VLEN) Curr.P = VLEN-1;
		if (Curr.C < 0)     Curr.C = 0;
		if (Curr.C >= VLEN) Curr.C = VLEN-1;
		DrawSample(CurrColor, i, Prev, Curr);
		Prev = Curr;
		WaitMs(1);

	}

}

/* drawing uninterrupted lines in a race condition framebuffer */
void DrawSample(
		color_t ColorSignal,
		uint32_t v,
		SampleRet hp,
		SampleRet hc){
	register uint32_t pl = 0;
	register uint32_t ph = 0;
	register uint32_t cl = 0;
	register uint32_t ch = 0;

	if (hp.P < hc.P){
		pl = hp.P;
		ph = hc.P;
	} else {
		pl = hc.P;
		ph = hp.P;
	}
	if (hp.C < hc.C){
		cl = hp.C;
		ch = hc.C;
	} else {
		cl = hc.C;
		ch = hp.C;
	}
	if ((ph < cl) || (pl > ch)) {
		SetVLine(ColorSignal,v,cl,ch);
		ClrVLine(ColorSignal,v,pl,ph);
		//DrawVLine(ColorSignal,v,cl,ch);
	} else {
		SetVLine(ColorSignal,v,cl,ch);
		ClrVLine(ColorSignal,v,pl,ph);
	//	DrawVLine(ColorSignal,v,cl,ch);
	//	DrawVLine(ColorSignal,v,cl,ch);
		
/*		if (cl == ch) {
			DrawPoint(ColorSignal,v,cl);
		} else {
			DrawVLine(ColorSignal,v,cl,ch);
		}
		if (pl < cl) {
			DrawVLine(ColorBack,v,pl,cl-1);
		}
		if (ph > ch) {
			DrawVLine(ColorBack,v,ch+1,ph);
		}*/
	}	
}

	
/*
uint32_t DrawSample(
		uint16_t Color,
		uint32_t y,
		uint32_t x1, 
		uint32_t x2) {
	if (x1 < 0)     x1 = 0;
	if (x1 >= VLEN) x1 = VLEN-1;
	if (x1 == x2) {
		DrawPoint(Color,y,x1);
	} else if (x1 > x2) {
		DrawVLine(Color,y,x2,x1);
	} else {
		DrawVLine(Color,y,x1,x2);
	}
	return x1;
}*/


void ConvSample (
		int32_t * dst, 
		int32_t * src, 
		int32_t const * const fir){

	register int fir_idx = 0;
	register int32_t result = 0;

	for(fir_idx = 0; fir_idx < POLYPHASE_COEFFS; fir_idx+= 1){
		result  += src[fir_idx] * fir[POLYPHASE_COEFFS-1-fir_idx];
	}
	*dst = result/(32768);
}


void Interpolate (
		uint32_t dstSamples, 
		uSample *Dst, 
		uSample *Src, 
		uint32_t type){

	register uint32_t i = 0;
	register uint32_t j = 0;
	register uint32_t dst_idx = 0;
	register int32_t * fir;

	register uint32_t srcSamples = dstSamples/POLYPHASES;
	
	for (i = 0; i < srcSamples; ++i){
		for (j = 0; j < POLYPHASES; ++j){
			fir = (int32_t*)&Filter_I8[j][0];
			ConvSample(&Dst[dst_idx].i,&Src[i].i,fir);
		/*	Dst[dst_idx] = Src[i];*/
			dst_idx++;
		}
	}
}

void GetCh(
		uint32_t ch,
		uint32_t size,
		uSample * dst, 
		uSample * src, 
		uint32_t srcSamples){

	register uint32_t i = 0;
	register int32_t data = 0;
	switch (size){
		case 8: 
			for (; i < srcSamples; ++i) {
				data = (int32_t)src[i].c[ch];
				dst[i].i = -data;
			}
			break;
		case 16:
			for (; i < srcSamples; ++i) {
				data = (int32_t)src[i].s[ch];
				dst[i].i = -data;
			}
			break;
		default:
			for (; i < srcSamples; ++i) {
				dst[i].i = -src[i].i;
			}
			break;
	}
}

void FlushDataCache() {
	WRITE_INT(DSU_ASI_BASE,0x16);
}


extern uSample Data[CAPTURESIZE];

static SetAnalog Analog[2];
static DispOffset Offset[2];

void GUI_Main () {
	uSample Ch1[2][HLEN+100];
	uSample Ch2[2][HLEN+100];
	uSample CalcBuffer[HLEN+100];
	uint32_t PrevBuffer = 0;
	uint32_t CurrBuffer = 1;
	uint32_t Prefetch = PREFETCH_OFFSET;
	uint32_t ReadData = 0;
	int16_t x = 0;
	uint32_t data = 0;
	SETLED(data,1,LED_CH0);
	WRITE_INT(LEDADDR,data);


	Analog[0].myVperDiv = 10000;
	Analog[0].AC = 0;
	Analog[0].Mode = normal;
//	Analog[0].DA_Offset = 16384;
	Analog[0].DA_Offset = 0;
	Analog[1].myVperDiv = 10000;
	Analog[1].AC = 1;
	Analog[1].Mode = normal;
//	Analog[1].DA_Offset = 16384;
	Analog[1].DA_Offset = 0;

	Offset[0].V = 128;
	Offset[1].V = VLEN-128;
	for (x = 0; x < 2; ++x){
		Offset[x].H = 8;
	}

	Prefetch = HLEN;
	SetTriggerInput(4,8,1000000000,FIXED_CPU_FREQUENCY,0,3,0,1,2,3);
	SetTrigger(0,0,0,Prefetch,-3,0,1,0);
	
	memset(&Ch1[0],0,HLEN*sizeof(uSample));
	memset(&Ch2[0],0,HLEN*sizeof(uSample));
	memset(&Ch1[1],0,HLEN*sizeof(uSample));
	memset(&Ch2[1],0,HLEN*sizeof(uSample));
	SetAnalogInputRange(2,Analog);
	
	SETLED(data,1,LED_CH1);
	WRITE_INT(LEDADDR,data);

	for ( x = 0; x < 8; ++x){
		ClrBox(1 << x,0,0,HLEN-1,VLEN-1);
	}
	/* Setting the colors of each plane */
        /* OR logic */
	SetColor(POS_CH0,CH0_COLOR);
	SetColor(POS_CH1,CH1_COLOR);
	SetColor(POS_CH2,CH2_COLOR);
	SetColor(POS_CH3,CH3_COLOR);
	SetColor(POS_GRID,GRID_COLOR);
	/* AND logic */
	SetColor(POS_MENU,MENU_COLOR);
   	SetColor(POS_F0,F0_COLOR);
	SetColor(POS_F1,F1_COLOR);

	/* Trigger type color box */
	SetBox(PL_MENU,30,470,39,479);
	SETLED(data,1,LED_CH2);

	x = 50;

	while(1) {
		if ((READ_INT(KEYADDR1) & (1 << BTN_F1)) != 0){
			WRITE_INT(CONFIGADCENABLE,1); // Set back to debug uart
		}
		if ((READ_INT(KEYADDR1) & (1 << BTN_F2)) != 0){
	//		WRITE_INT(CONFIGADCENABLE,0); // Set back to generic uart
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
			} else {
				CurrBuffer = 1;
				PrevBuffer = 0;
			}
			x++;
/*			if ((x == 0) || ((READ_INT(KEYADDR1) & (1 << BTN_SINGLE)) != 0)) {
				DrawBox(BG_COLOR,0,0,HLEN-1,VLEN-1);
			}*/
			GetCh(0,8, &Ch1[CurrBuffer][0],&Data[Offset[0].H], HLEN+100);
			DrawSignal(Offset[0].V,&Ch1[PrevBuffer][0], &Ch1[CurrBuffer][0], PL_CH0);

/*			GetCh(1,8, CalcBuffer,&Data[0], HLEN+100);
			Interpolate(HLEN+(FILTER_COEFFS*2),&Ch2[CurrBuffer][0], CalcBuffer,0);
			DrawSignal(VLEN-128,&Ch2[PrevBuffer][FILTER_COEFFS], &Ch2[CurrBuffer][FILTER_COEFFS], PLANE1);*/
			GetCh(1,8, &Ch2[CurrBuffer][0],&Data[Offset[1].H], HLEN+100);
			DrawSignal(Offset[1].V,&Ch2[PrevBuffer][0], &Ch2[CurrBuffer][0], PL_CH1);
			
			FlushDataCache();	
		//	WaitMs(50);
		
		}
		SetKeyFs(); 
//		SetAnalogOffset();
		SetTriggerLevel();
		SetLeds();
		SetVoltagePerDivision();
		TestRotNobs();
	}
}


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

void SetTriggerLevel(){
	static int32_t level = 0;
	static int32_t schmitt = 2;
	static int32_t Pulse = 1;
	static int32_t Prefetch = 64;
	static uint32_t Trigger = 2;
	static uint32_t Ch = 0;
	static int32_t kl = 0;

	int32_t kc = (READ_INT(LEDADDR) >> EN_LEVEL) & 7;	
	int32_t move = 0;
	int16_t color = 0;


	ROTARYMOVE(move,kc,kl);
	if (move != 0){
		ClrHLine(PL_MENU,-level+Offset[Ch].V,0,HLEN-1);
	}
	switch(move){
		case 3:
		case -3: move *=4;
		case 2: 
		case -2: move *=4; break;
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_EDGE)) != 0) {
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"trigger offset move = ");
		Prefetch += move*8; // 8 = Trigger Alignment 8 samples @125MHz 
		if (Prefetch < 48) 	Prefetch = 48;
		if (Prefetch > 8192)	Prefetch = 8192;
		
	} else if ((READ_INT(KEYADDR1) & (1 << BTN_PULSEWIDTH)) != 0) {
		if (move != 0) {
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"trigger pulswidth move = ");
		}
		Pulse += move;
		if (Pulse < 0) Pulse = 0;
		if (Pulse > 100) Pulse = 100;
	} else if ((READ_INT(KEYADDR1) & (1 << BTN_MODECOUPLING)) != 0){
		schmitt += move;
		if (schmitt < 1) schmitt = 1;
	 	if (((level + schmitt) > 127) || ((level - schmitt) < -127)) schmitt -= move;
		if (move != 0) {	
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"trigger hysteresis move = ");
		}
		
	} else {
		if (move != 0) {
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"trigger level move = ");
		}
		level += move;
		if (level > 127) level = 127;
		if (level < -127) level = -127;
	}
	 
	if (move != 0){
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR,'0' + move);
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '\n');
		
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_CH0)) != 0){
		move = 1;
		Ch = 0;
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_CH1)) != 0){
		move = 1;
		Ch = 1;
	}
	if (move != 0){
		SetHLine(PL_MENU,-level+Offset[Ch].V,0,HLEN-1);
	}

	move = (READ_INT(LEDADDR) >> EN_F) & 0x7;
	if (move == 0) move = 1;
	if (move > 4)  move = 4;
	if (move != Trigger) {
		Trigger = move;
		SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"trigger type = ");
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR,'0' + move);
		SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '\n');
	}
	
	
	SetTrigger(Trigger,0,Ch, Prefetch,level-schmitt,Pulse,level+schmitt,Pulse);
//	color = COLOR_L2R2G2B2(0,0,0,Trigger);
//	SetColor(5,color);
}

void SetKeyFs(){
	static int32_t kl = 0;
	static int32_t exp = 10000000; /* 100 MS/s*/
	static uint32_t mant = 100;
	volatile int32_t kc = (READ_INT(LEDADDR) >> EN_TIME_DIV) & 7;
	int32_t move = 0;
	ROTARYMOVE(move,kc,kl);

	if (move > 0){
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
	if (move < 0) {
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

	}
//	sprintf(M,"\n mant = %d, exp = %d, fs = %d\n",mant, exp, mant*exp);
//	printf("\n mant = %d, exp = %d, fs = %d\n",mant, exp, mant*exp);
	SetTriggerInput(4,8,(const uint32_t)mant*exp,FIXED_CPU_FREQUENCY,0,1,0,1,2,3);
}

char * M[80];

void SetAnalogOffset () {
	static int32_t kl[4] = {0,0,0,0};
	volatile int32_t kc[4] = {0,0,0,0};
	int32_t i = 0;
	int32_t move = 0;
	kc[0] = (READ_INT(KEYADDR0) >> EN_CH0_UPDN) & 7;
	kc[1] = (READ_INT(KEYADDR0) >> EN_CH1_UPDN) & 7;
	kc[2] = (READ_INT(KEYADDR0) >> EN_CH2_UPDN) & 7;
	kc[3] = (READ_INT(KEYADDR0) >> EN_CH3_UPDN) & 7;
	
	for (i = 0; i < 2; ++i){
		ROTARYMOVE(move,kc[i],kl[i]);
		if (move != 0){
			/*switch(move){
			case 2:
			case -2: move*=8;
			case 3:
			case -3: move*=8;
			}*/
		
		if ((READ_INT(KEYADDR1) & (1 << BTN_CURSORS)) != 0){
			move*=100;
		}
		Analog[i].DA_Offset += move;
		SetDACOffset(i, Analog[i].DA_Offset);
	//	SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"test\n");
		rprintf("DAC offset of CH%d is %d\n",i+1,Analog[i].DA_Offset);
		}
	}
/*	if ((READ_INT(KEYADDR1) & (1 << BTN_CURSORS)) != 0){
		Analog[0].DA_Offset+= 1;
		SetDACOffset(0, Analog[0].DA_Offset);
	}
	if ((READ_INT(KEYADDR1) & (1 << BTN_QUICKMEAS)) != 0){
		Analog[1].DA_Offset+= 1;
		SetDACOffset(1, Analog[1].DA_Offset);
	}*/
}

void SetVoltagePerDivision(){
	
	static int32_t kl[4] = {0,0,0,0};
	static int32_t exp[4] = {1000000,1000000,1000000,1000000}; /* 100 MS/s*/
	static uint32_t mant[4] = {5,5,5,5};
	volatile int32_t kc[4];
	int32_t move = 0;
	uint32_t Update = FALSE;
	int32_t i = 0;

	kc[0] = (READ_INT(KEYADDR0) >> EN_CH0_VDIV) & 7;
	kc[1] = (READ_INT(KEYADDR0) >> EN_CH1_VDIV) & 7;
	kc[2] = (READ_INT(KEYADDR0) >> EN_CH2_VDIV) & 7;
	kc[3] = (READ_INT(KEYADDR0) >> EN_CH3_VDIV) & 7;

/*	Analog[0].myVperDiv = 10000;
	Analog[0].DA_Offset = 0;
	Analog[1].myVperDiv = 10000;
	Analog[1].DA_Offset = 0;*/
	
	for(i = 0; i < 2; ++i){
		ROTARYMOVE(move,kc[i],kl[i]);
		if (move > 0){
			switch(mant[i]) {
				case 1: if (exp[i] != 10000) {
						exp[i] = exp[i]/10;
						mant[i] = 5;
					}
					break;
				case 2: mant[i] = 1; break;
				case 5: mant[i] = 2; break;
			}
		}
		if (move < 0){
			switch(mant[i]) {
				case 1: mant[i] = 2; break;
				case 2: mant[i] = 5; break;
				case 5: if (exp[i] != 1000000){
						exp[i] = exp[i]*10;
				       		mant[i] = 1;
					}
					break;
			}
		}
		Analog[i].DA_Offset = 0;
		if (move != 0){
			Update = TRUE;
			Analog[i].myVperDiv = mant[i]*exp[i];
		//	rprintf("CH%d mant = %d exp = %d\n",i+1,mant[i],exp[i]);
			SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR,"CH ");
			SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR,'1' + i);
			SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR," mant ");
			SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR,'0' + mant[i]);
			move = exp[i];
			kc[i] = -3;
			while (move > 1){
				move /= 10;
				kc[i]++;
			}
			SendStringBlock((uart_regs*)GENERIC_UART_BASE_ADDR," exp ");
			SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '0' + kc[i]);
			SendCharBlock((uart_regs*)GENERIC_UART_BASE_ADDR, '\n');
			//rprintf("VDiv %d", Analog[i].myVperDiv);
		}

	}
	if (Update == TRUE){
		SetAnalogInputRange(2,Analog);
	}
}
#if 0
void itoa(int value, char * string)
{
	int 	count, /* number of characters in string */
		i, /* loop control variable */
		sign; /* determine if the value is negative */
	static char	temp[30]; /* temporary string array */

	count = 0;
	if ((sign = value) < 0) /* assign value to sign, if negative */
		{ /* keep track and invert value */
		value = -value;
	//	count++; /* increment count */
	}

	memset(temp,'\0', 30);

	if (string == 0) return;
	memset(string,'\0', 30);
/*--------------------------------------------------------------------+
| NOTE: This process reverses the order of an integer, ie: |
| value = -1234 equates to: char [4321-] |
| Reorder the values using for {} loop below |
+--------------------------------------------------------------------*/
	do {
		temp[count] = value % 10 + '0'; /* obtain modulus and or with '0' */
		count++; /* increment count, track iterations*/
	} while (( value /= 10) >0);

	if (sign < 0) /* add '-' when sign is negative */
		temp[count] = '-';
	else count--;
	temp[count+1] = '\0'; /* ensure null terminated and point */
	/* to last char in array */

/*--------------------------------------------------------------------+
| reorder the resulting char *string: |
| temp - points to the last char in the temporary array |
+--------------------------------------------------------------------*/
	for (i = 0; i <= count; i++) {
		string[i] = temp[i];
	}
}
#endif
#endif
