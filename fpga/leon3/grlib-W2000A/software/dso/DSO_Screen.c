/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Screen.c
* Author		 : Alexander Lindert <alexander_lindert at gmx.at>
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

#include "types.h"
#include "DSO_SFR.h"
#include "DSO_Screen.h"

#define VGA_STATUS_ADDR           (VGA_CONFIG_BASE_ADDR + 0x00)
#define VGA_VIDEO_LENGTH_ADDR     (VGA_CONFIG_BASE_ADDR + 0x04) 
#define VGA_FRONT_PORCH_ADDR      (VGA_CONFIG_BASE_ADDR + 0x08)
#define VGA_SYNC_LENGTH_ADDR      (VGA_CONFIG_BASE_ADDR + 0x0C)
#define VGA_LINE_LENGHT_ADDR      (VGA_CONFIG_BASE_ADDR + 0x10)
#define VGA_FRAMEBUFFER_BASEADDR  (VGA_CONFIG_BASE_ADDR + 0x14)
#define VGA_CLOCK0_ADDR           (VGA_CONFIG_BASE_ADDR + 0x18)
#define VGA_CLOCK1_ADDR           (VGA_CONFIG_BASE_ADDR + 0x1C)
#define VGA_CLOCK2_ADDR           (VGA_CONFIG_BASE_ADDR + 0x20)
#define VGA_CLOCK3_ADDR           (VGA_CONFIG_BASE_ADDR + 0x24)
#define VGA_GLUT_REG              (VGA_CONFIG_BASE_ADDR + 0x28)

/* VGA_STATUS_ADDR */
#define VGA_ENABLE_BIT           0
#define VGA_RESET_BIT            1
#define VGA_VERTICAL_REFRESH_BIT 2
#define VGA_RUN_BIT              3
#define VGA_PIXELSIZE0_BIT       4
#define VGA_PIXELSIZE1_BIT       5
#define VGA_CLOCKSEL0_BIT        6
#define VGA_CLOCKSEL1_BIT        7
#define VGA_H_POL_BIT            8
#define VGA_V_POL_BIT            9

/* VGA_VIDEO_LENGTH_ADDR */
/* VGA_FRONT_PORCH_ADDR  */
/* VGA_SYNC_LENGTH_ADDR  */
/* VGA_LINE_LENGHT_ADDR */
#define H_OFFSET  0
#define V_OFFSET 16


/* VGA_FRAMEBUFFER_BASEADDR (1 kB boundary) */
#define VGA_BASE_ADDR_MASK 0x3ff

/* VGA_CLOCK0_ADDR */
/* VGA_CLOCK1_ADDR */
/* VGA_CLOCK2_ADDR */
/* VGA_CLOCK3_ADDR */
/* Clock length in pico seconds */

/* VGA_GLUT_REG    */
/* Color lookup Table! */
#define CONFIG_BLUE_OFFSET   0
#define CONFIG_GREEN_OFFSET  8
#define CONFIG_RED_OFFSET   16
#define CONFIG_CLUT_OFFSET  24


/* VGA Resulotion */
#define HLEN 640
#define VLEN 480

typedef struct {
	volatile uint32_t status;
	volatile uint32_t video_length;
	volatile uint32_t front_porch;
	volatile uint32_t sync_length;
	volatile uint32_t line_length;
	volatile uint32_t framebuffer_pointer;
	volatile uint32_t clock0;
	volatile uint32_t clock1;
	volatile uint32_t clock2;
	volatile uint32_t clock3;
	volatile uint32_t glut;
} volatile aVGA_Config;

static volatile aVGA_Config VGA_Config;

/* The frame buffer has a 1024 byte alignment */
/* Until it is not known how to set the alignment with the compiler
 * we wast here 1024 bytes */
/*unsigned char Framebuffer[HLEN*VLEN+1024];*/
unsigned char * FramePointer;

uint32_t * InitDisplay (uint32_t Target){
/*	printf("InitDisplay\n");*/
	aVGA_Config * volatile VGA_Config = (aVGA_Config *)VGA_CONFIG_BASE_ADDR;
	uint32_t temp = 0; 
	switch(Target){
		case WELEC2012: 
		case WELEC2014:
		case WELEC2022:
		case WELEC2024:
			FramePointer = (unsigned char *)malloc(HLEN*VLEN+1024);
			temp = (uint32_t)FramePointer;
			temp &= ~0x3ff;
			temp += 1024;
			FramePointer = (unsigned char * )temp;
/*			FramePointer = (unsigned char *) SVGA_BUFFER_BASE; */
/*			printf("FramePointer %d %x ",FramePointer,FramePointer); */ 
			VGA_Config = (aVGA_Config*)VGA_CONFIG_BASE_ADDR;
/*			VGA_Config->status = 
				( (1 << VGA_ENABLE_BIT)     | (1 << VGA_RUN_BIT)
				| (1 << VGA_PIXELSIZE0_BIT) | (0 << VGA_CLOCKSEL0_BIT)
				| (1 << VGA_H_POL_BIT)      | (1 << VGA_V_POL_BIT));*/
			VGA_Config->video_length = 
				((HLEN-1) << H_OFFSET) | ((VLEN-1) << V_OFFSET);
			VGA_Config->front_porch =
				(3 << H_OFFSET) | (3 << V_OFFSET);
			VGA_Config->sync_length = 
				(5 << H_OFFSET) | (3 << V_OFFSET);
			VGA_Config->line_length =
				((HLEN-1+3+5+10) << H_OFFSET) | ((VLEN-1+3+3+10) << V_OFFSET);
			VGA_Config->framebuffer_pointer = (uint32_t) FramePointer;
			VGA_Config->clock0 = 40000;
			VGA_Config->clock1 = 40000;
			VGA_Config->clock2 = 40000;
			VGA_Config->clock3 = 40000;
			VGA_Config->status = 
				( (1 << VGA_ENABLE_BIT)     | (1 << VGA_RUN_BIT)
				| (1 << VGA_PIXELSIZE0_BIT) | (0 << VGA_CLOCKSEL0_BIT)
				| (0 << VGA_H_POL_BIT)      | (0 << VGA_V_POL_BIT));
			return 0;
			break;
		default:
			break;
	}
	return 0;

}

/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void DrawHLine(char Color, uint32_t V, uint32_t H1, uint32_t H2){
	register uint32_t i = 0;
	uint32_t End = V*HLEN + H2;
	for (i = V*HLEN+H1; i < End; ++i){
		FramePointer[i] = Color;
	}
}

/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void DrawVLine(char Color, uint32_t H, uint32_t V1, uint32_t V2){
	register uint32_t i = 0;
	uint32_t End = V2*HLEN + H;
	for (i = V1*HLEN+H; i < End; i+= HLEN){
		FramePointer[i] = Color;
	}
}

/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void DrawBox(char Color, uint32_t H1, uint32_t V1, uint32_t H2, uint32_t V2){
	register uint32_t i = V1;
	for(i = V1; i < V2; ++i){
		DrawHLine(Color,i,H1,H2);
	}
}

void DrawTest(void){
/*	DrawBox(-1,0,0,HLEN-1,VLEN-1);*/
	DrawBox(0xAA,100,100,300,300);
/*	DrawHLine(0x55,1,1,HLEN-2);
	DrawHLine(0x55,VLEN-2,1,HLEN-2);
	DrawVLine(0x55,1,1,VLEN-2);
	DrawVLine(0x55,HLEN-2,1,VLEN-2);*/
}

