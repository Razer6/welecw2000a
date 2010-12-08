/*****************************************************************************
 * File           : DSO_Signal.c
 * Author         : Alexander Lindert <alexander_lindert at gmx.at>
 * Date           : 04.09.2010
 *****************************************************************************
 * Description	 :
 *****************************************************************************

 *  Copyright (c) 2010, Alexander Lindert

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

#include "DSO_SFR.h"
#include "DSO_GUI.h"

#define GUI_DAC_MIN -8192
#define GUI_DAC_MAX  8191


typedef struct
{
	int32_t P;
	int32_t C;
}SampleRet;

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
		uint16_t CurrColor);

void ConvSample (
		int32_t * dst,
		int32_t * src,
		int32_t const * const fir);

void Interpolate (
		uint32_t dstSamples,
		uSample *Dst,
		uSample *Src,
		uint32_t type);

/* extract the signal of Channel and correct the gain and the digital offset (HW-Filters=on) */
void GetCh(
		uint32_t ch,
		uint32_t size,
		uSample * dst,
		uSample * src,
		uint32_t srcSamples,
		sHWFilterGain AnalogGain,
		sHWFilterGain FilterGain);

void UpdateCalOffsetPointer(
		uint32_t ch,  
		uint32_t myVperDivCurr);

uint32_t CalibrateDAC();


void GUI_DACOffset(
		uint32_t ch, 
		int32_t Offset);

