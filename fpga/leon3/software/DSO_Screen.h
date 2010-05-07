/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Screen.h
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 02.07.2009
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
#ifndef DSO_SCREEN_H
#define DSO_SCREEN_H

#include "types.h"
#include "util.h"

typedef uint16_t color_t;

typedef struct Rect
{
	uint16_t x;
	uint16_t y;
	uint16_t width;
	uint16_t height;
}
sRect;

typedef struct Symbol
{
	uint8_t width;
	uint8_t height;
	uint8_t data[];
} sSymbol;

uint32_t * InitDisplay (uint32_t Target);

void DrawPoint(uint16_t Color, uint32_t H, uint32_t V);
/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void DrawHLine(uint16_t Color, uint32_t V, uint32_t H1, uint32_t H2);
/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void DrawVLine(uint16_t Color, uint32_t H, uint32_t V1, uint32_t V2);
/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void DrawBox(uint16_t Color, uint32_t H1, uint32_t V1, uint32_t H2, uint32_t V2);
void DrawTest(void);

void DrawVLineClipped(uint16_t Color, uint32_t H, uint32_t V1, uint32_t V2);

void DrawPixel32(color_t color, uint32_t x, uint32_t y);
void DrawPixel32Clipped(color_t color, uint32_t x, uint32_t y);

void DrawRect32(uint16_t color, uint32_t x, uint32_t y, uint32_t width, uint32_t height, uint32_t filled);

void LoadBitmap(sSymbol *symbol, uint16_t xpos , uint16_t ypos, color_t color_fg);

void generategrid(void);

void drawGrid(void);

void ClearVLineClipped(uint16_t Color, uint32_t H, uint32_t V1, uint32_t V2);

void setClippingRect(sRect *clipping);

sRect* getClippingRect(void);


/* The display can only draw the three highest bits per color */
/* Standard color set */
#define COLOR_R5G5B6(Red,Green,Blue) (((Red) << 11) | ((Green) << 5) | (Blue))
/* 3 bit color set */
#define COLOR_R3G3B3(Red,Green,Blue) (((Red) << 13) | ((Green) << 8) | ((Blue) << 2))

/* VGA Resulotion */
#define HLEN 640
#define VLEN 480





#endif

