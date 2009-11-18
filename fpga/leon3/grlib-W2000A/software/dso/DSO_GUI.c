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

#define SIGNAL_HSTART 0
#define SIGNAL_HSTOP  HLEN

#ifdef BOARD_COMPILATION


typedef struct {
	int32_t P;
	int32_t C;
} SampleRet;

void DrawSample(
		uint16_t ColorBack,
		uint16_t ColorSignal,
		uint32_t v,
		SampleRet hp,
		SampleRet hc);

void DrawSignal(
		uint32_t Voffset, 
		uSample * PrevData,
		uSample * CurrData,
		uint16_t PrevColor,
		uint16_t CurrColor){

	register uint32_t i = SIGNAL_HSTART+1;
//	register uint32_t Prev = 0;
//	register uint32_t Curr = 0;
	register SampleRet Prev;
	register SampleRet Curr;
//	register uint32_t lastPrev = 0;
//      register uint32_t lastCurr = 0;
	

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
		DrawSample(PrevColor, CurrColor, i, Prev, Curr);
		Prev = Curr;

	}

}

/* drawing uninterrupted lines in a race condition framebuffer */
void DrawSample(
		uint16_t ColorBack,
		uint16_t ColorSignal,
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
		DrawVLine(ColorSignal,v,cl,ch);
		DrawVLine(ColorBack,v,pl,ph);
		DrawVLine(ColorSignal,v,cl,ch);
	} else {
		DrawVLine(ColorSignal,v,cl,ch);
		DrawVLine(ColorBack,v,pl,ph);
		DrawVLine(ColorSignal,v,cl,ch);
		DrawVLine(ColorSignal,v,cl,ch);
		
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
			fir = &Filter_I8[j][0];
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
	switch (size){
		case 8: 
			for (; i < srcSamples; ++i) {
				dst[i].i = -src[i].c[ch];
			}
			break;
		case 16:
			for (; i < srcSamples; ++i) {
				dst[i].i = -src[i].s[ch];
			}
			break;
		default:
			for (; i < srcSamples; ++i) {
				dst[i].i = -src[i].i;
			}
			break;
	}
}
#endif
