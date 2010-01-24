/*****************************************************************************
* File           : DSO_GUI.h
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
#ifndef DSO_GUI_H 
#define DSO_GUI_H

void GUI_Main();

void DrawSignal(
		uint32_t Voffset, 
		uSample * PrevData,
		uSample * CurrData,
		color_t CurrColor);

void Interpolate (
		uint32_t srcSamples, 
		uSample *Dst, 
		uSample *Src, 
		uint32_t type);

void GetCh(
		uint32_t ch,
		uint32_t size,
		uSample * dst, 
		uSample * src, 
		uint32_t srcSamples);

#endif
