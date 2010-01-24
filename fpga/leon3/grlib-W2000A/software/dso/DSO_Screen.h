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

uint32_t * InitDisplay (uint32_t Target);

typedef uint8_t color_t; 

#define POS_CH0  0
#define POS_CH1  1
#define POS_CH2  2
#define POS_CH3  3
#define POS_GRID 4
#define POS_MENU 5
#define POS_F0   6
#define POS_F1   7

#define PLANE0 (1 << POS_CH0)
#define PLANE1 (1 << POS_CH1)
#define PLANE2 (1 << POS_CH2)
#define PLANE3 (1 << POS_CH3)
#define PLANE4 (1 << POS_GRID)
#define PLANE5 (1 << POS_MENU)
#define PLANE6 (1 << POS_F0)
#define PLANE7 (1 << POS_F1)


#define PL_CH0  PLANE0
#define PL_CH1  PLANE1
#define PL_CH2  PLANE2
#define PL_CH3  PLANE3
#define PL_GRID PLANE4

#define PL_MENU PLANE5
#define PL_F0   PLANE6
#define PL_F1   PLANE7

/* Color planes from 0 to 4 are selected when plane 5 is off! 
 * Color planes from 5 to 7 are selected when plane 5 is on! 
 * Colors of planes 0 to 4 mixed with OR logic on the fly 
 * Colors of planes 5 to 7 are mixed with AND logic on the fly
 * Colors of planes 0 to 5 are black when off! (Signal planes)
 * Colors of planes 6 to 7 are white when off! (Menu & Font planes) */ 


void SetPoint(color_t Color, uint32_t H, uint32_t V);
void ClrPoint(color_t Color, uint32_t H, uint32_t V);

/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void SetHLine(color_t Color, uint32_t V, uint32_t H1, uint32_t H2);
void ClrHLine(color_t Color, uint32_t V, uint32_t H1, uint32_t H2);

/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void SetVLine(color_t Color, uint32_t H, uint32_t V1, uint32_t V2);
void ClrVLine(color_t Color, uint32_t H, uint32_t V1, uint32_t V2);

/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void SetBox(color_t Color, uint32_t H1, uint32_t V1, uint32_t H2, uint32_t V2);
void ClrBox(color_t Color, uint32_t H1, uint32_t V1, uint32_t H2, uint32_t V2);

void DrawTest(void);


#define COLOR_L2R2G2B2(Light,Red,Green,Blue) (((Light) << 6) | ((Red) << 4) | ((Green) << 2) | ((Blue) << 0))
/* because only one plane can be set once Plane has to be between 0 to 7! */
void SetColor(uint8_t Plane, uint8_t Color);

/* VGA Resulotion */
#define HLEN 640
#define VLEN 480

#endif

