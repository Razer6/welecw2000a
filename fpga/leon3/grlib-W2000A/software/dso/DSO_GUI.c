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

uint32_t DrawSample(
		uint16_t Color,
		uint32_t y,
		uint32_t x1, 
		uint32_t x2);

void DrawSignal(
		uint32_t Voffset, 
		uSample * PrevData,
		uSample * CurrData,
		uint16_t PrevColor,
		uint16_t CurrColor){

	register uint32_t i = SIGNAL_HSTART+1;
	register uint32_t Prev = 0;
	register uint32_t Curr = 0;
	register uint32_t lastPrev = 0;
        register uint32_t lastCurr = 0;
	

	lastCurr = CurrData[SIGNAL_HSTART].i + Voffset;
	if (lastCurr < 0)     lastCurr = 0;
	if (lastCurr >= VLEN) lastCurr = VLEN-1;
	lastPrev = PrevData[SIGNAL_HSTART].i + Voffset;
	if (lastPrev < 0)     lastPrev = 0;
	if (lastPrev >= VLEN) lastPrev = VLEN-1;

	for (; i < SIGNAL_HSTOP; ++i){
		Prev = PrevData[i].i + Voffset;
		lastPrev = DrawSample(PrevColor,i,Prev,lastPrev);
		Curr = CurrData[i].i + Voffset;
		lastCurr = DrawSample(CurrColor,i,Curr,lastCurr);
	}

}

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
}


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
