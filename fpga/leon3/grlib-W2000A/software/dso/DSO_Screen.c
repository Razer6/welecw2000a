/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Screen.c
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 02.07.2009
*****************************************************************************
* Description	 : This screen driver does not support the original svgactrl 
*                  from Gaisler Research any more. It is an driver to the 
*                  8 bit plane buffer VGA. At the moment a byte contains 
*                  a bit for every plane (pixel)!
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
#include "DSO_Misc.h"

#ifdef BOARD_COMPILATION

#define VGA_STATUS_ADDR           (VGA_CONFIG_BASE_ADDR + 0x00)
#define VGA_VIDEO_LENGTH_ADDR     (VGA_CONFIG_BASE_ADDR + 0x04) 
#define VGA_FRONT_PORCH_ADDR      (VGA_CONFIG_BASE_ADDR + 0x08)
#define VGA_SYNC_LENGTH_ADDR      (VGA_CONFIG_BASE_ADDR + 0x0C)
#define VGA_LINE_LENGHT_ADDR      (VGA_CONFIG_BASE_ADDR + 0x10)
#define VGA_FRAMEBUFFER_BASEADDR  (VGA_CONFIG_BASE_ADDR + 0x14)
#define VGA_COLOR0_ADDR           (VGA_CONFIG_BASE_ADDR + 0x18)
#define VGA_COLOR1_ADDR           (VGA_CONFIG_BASE_ADDR + 0x1C)

/* VGA_STATUS_ADDR */
#define VGA_ENABLE_BIT           0
#define VGA_RESET_BIT            1
#define VGA_VERTICAL_REFRESH_BIT 2
#define VGA_RUN_BIT              3
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


/* VGA Resulotion */
#define VFRONT 16
#define HFRONT 16
#define VSYNC 5
#define HSYNC 10
#define HBACK 100
#define VBACK 100

/* VGA Resulotion from grmon 640x480 60 Hz 16 Bit */
/*
#define VFRONT 0xb
#define HFRONT 0x10
#define VSYNC 0x2
#define HSYNC 0x60
#define HBACK 47
#define VBACK 30
*/

typedef struct {
	volatile uint32_t status;
	volatile uint32_t video_length;
	volatile uint32_t front_porch;
	volatile uint32_t sync_length;
	volatile uint32_t line_length;
	volatile uint32_t framebuffer_pointer;
	volatile uint32_t color0;
	volatile uint32_t color1;
} volatile aVGA_Config;

static volatile aVGA_Config VGA_Config;

/* The frame buffer has a 1024 byte alignment */
/* 8 planes, 32 bit plane blocks */
uSample Framebuffer[HLEN*VLEN*8/32] __attribute__ ((aligned (1024)));
uSample * FramePointer;

uint32_t * InitDisplay (uint32_t Target){
/*	printf("InitDisplay\n");*/
	aVGA_Config * volatile VGA_Config = (aVGA_Config *)VGA_CONFIG_BASE_ADDR;
	uint32_t temp = 0; 
	switch(Target){
		case WELEC2012: 
		case WELEC2014:
		case WELEC2022:
		case WELEC2024:
			FramePointer = Framebuffer;
			VGA_Config = (aVGA_Config*)VGA_CONFIG_BASE_ADDR;
/*			VGA_Config->status = 
				( (1 << VGA_ENABLE_BIT)     | (1 << VGA_RUN_BIT)
				| (1 << VGA_PIXELSIZE0_BIT) | (0 << VGA_CLOCKSEL0_BIT)
				| (1 << VGA_H_POL_BIT)      | (1 << VGA_V_POL_BIT));*/
			VGA_Config->video_length = 
				((HLEN-1) << H_OFFSET) | ((VLEN-1) << V_OFFSET);
			VGA_Config->front_porch =
				(HFRONT << H_OFFSET) | (VFRONT << V_OFFSET);
			VGA_Config->sync_length = 
				(HSYNC << H_OFFSET) | (VSYNC << V_OFFSET);
			VGA_Config->line_length =
				((HLEN+HFRONT+HSYNC+HBACK) << H_OFFSET) | ((VLEN+VFRONT+VSYNC+VBACK) << V_OFFSET);
			VGA_Config->framebuffer_pointer = (uint32_t) FramePointer;
			VGA_Config->color0 = 0;
			VGA_Config->color1 = 0;
			
			VGA_Config->status = 
				( (1 << VGA_ENABLE_BIT)     | (1 << VGA_RUN_BIT)
			/*	| (2 << VGA_PIXELSIZE0_BIT) | (0 << VGA_CLOCKSEL0_BIT)*/
				| (0 << VGA_H_POL_BIT)      | (0 << VGA_V_POL_BIT));
			temp = (uint32_t)Framebuffer;
			temp -= 0x20000000; /* uncached SRAM mirror */
			FramePointer = (uSample * )temp;
			FramePointer = Framebuffer;
			return 0;
			break;
		default:
			break;
	}
	return 0;
}

void SetColor(uint8_t Plane, uint8_t Color){
	uint32_t table = 0;
	if (Plane < 4){
		table = READ_INT(VGA_COLOR0_ADDR);
		table &= ~(0xff << (Plane*8));
		table |= (Color << (Plane*8));
		WRITE_INT(VGA_COLOR0_ADDR,table);
		return;
	}	
//	if (Plane < 8){
		Plane-=4;
		table = READ_INT(VGA_COLOR1_ADDR);
		table &= ~(0xff << (Plane*8));
		table |= (Color << (Plane*8));
		WRITE_INT(VGA_COLOR1_ADDR,table);
//	}
}

#define SET_POINT(H,V,P) \
FramePointer[(((V*HLEN)+H)  >> 3) + P].i |= (1 << (H & 31))

#define CLR_POINT(H,V,P) \
FramePointer[(((V*HLEN)+H)  >> 3) + P].i &= ~(1 << (H & 31))


void SetPoint(color_t Color, uint32_t H, uint32_t V){
	SET_POINT(H,V, Color); 
//	FramePointer[V*HLEN+H] |= Color;
}
void ClrPoint(color_t Color, uint32_t H, uint32_t V){
	CLR_POINT(H,V, Color); 
//	FramePointer[V*HLEN+H] &= ~Color;
}

/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void SetHLine(color_t Color, uint32_t V, uint32_t H1, uint32_t H2){
	register uint32_t i = 0;
	uint32_t End = V*HLEN + H2;
	for (i = V*HLEN+H1; i <= End; ++i){
		SET_POINT(0,i,Color); 
//		FramePointer[i] |= Color;
	}
}

void ClrHLine(color_t Color, uint32_t V, uint32_t H1, uint32_t H2){
	register uint32_t i = 0;
	uint32_t End = V*HLEN + H2;
	for (i = V*HLEN+H1; i <= End; ++i){
		CLR_POINT(0,i,Color);
//		FramePointer[i] &= ~Color;
	}
}


/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void SetVLine(color_t Color, uint32_t H, uint32_t V1, uint32_t V2){
	register uint32_t i = 0;
	uint32_t End = V2*HLEN + H;
	for (i = V1*HLEN+H; i <= End; i+= HLEN){
		SET_POINT(0,i,Color); 
//		FramePointer[i] |= Color;
	}
}

void ClrVLine(color_t Color, uint32_t H, uint32_t V1, uint32_t V2){
	register uint32_t i = 0;
	uint32_t End = V2*HLEN + H;
	for (i = V1*HLEN+H; i <= End; i+= HLEN){
		CLR_POINT(0,i,Color);
//		Framebuffer[i] &= ~Color;
	}
}


/* H1 <= H2 and V1 <= V2 and Hx < HLEN and Vx < VLEN */
void SetBox(color_t Color, uint32_t H1, uint32_t V1, uint32_t H2, uint32_t V2){
	register uint32_t i = V1;
	for(i = V1; i <= V2; ++i){
		SetHLine(Color,i,H1,H2);
	}
}

void ClrBox(color_t Color, uint32_t H1, uint32_t V1, uint32_t H2, uint32_t V2){
	register uint32_t i = V1;
	for(i = V1; i <= V2; ++i){
		ClrHLine(Color,i,H1,H2);
	}
}

void DrawCopyHLine(uint32_t Vsrc, uint32_t Vdst) {
	register uint32_t * src32 = (uint32_t*)&FramePointer[Vsrc*HLEN];
	register uint32_t * dst32 = (uint32_t*)&FramePointer[Vdst*HLEN];
	register uint32_t i = 0;
	for (i = 0; i < (HLEN/2); ++i){
		dst32[i] = src32[i];
	}
}

void DrawCopyVLine(uint32_t Hsrc, uint32_t Hdst) {
	register color_t * src = (color_t*)&FramePointer[Hsrc];
	register color_t * dst = (color_t*)&FramePointer[Hdst];
	register color_t i = 0;
	for (i = 0; i < (VLEN*HLEN); i+= HLEN){
		dst[i] = src[i];
	}
}

#include "DSO_SFR.h"

void DrawTest(void){
	uint32_t h,v;
	color_t hp, vp = 0;    
	
	SetColor(0,COLOR_L2R2G2B2(0,0,0,2));
	SetColor(1,COLOR_L2R2G2B2(0,0,2,0));
	SetColor(2,COLOR_L2R2G2B2(0,2,0,0));
	SetColor(3,COLOR_L2R2G2B2(2,0,0,0));
	SetColor(4,COLOR_L2R2G2B2(2,3,3,3));
	SetColor(4,0xff);
	SetColor(5,COLOR_L2R2G2B2(0,2,2,2));
	SetColor(6,COLOR_L2R2G2B2(0,2,0,0));
	SetColor(7,COLOR_L2R2G2B2(0,0,2,1));

	WRITE_INT(LEDADDR,0xf);
	ClrBox(0xff,0,0,HLEN-1,VLEN-1);

	SetHLine(PLANE4,0,0,HLEN-1);
	SetHLine(PLANE4,VLEN-1,0,HLEN-1);
	SetVLine(PLANE4,0,0,VLEN-1); 
	SetVLine(PLANE4,HLEN-1,0,VLEN-1);

	SetHLine(PLANE4,5,5,HLEN-6);
	SetHLine(PLANE4,VLEN-6,5,HLEN-6);
	SetVLine(PLANE4,5,5,VLEN-6); 
	SetVLine(PLANE4,HLEN-5,5,VLEN-5);


	SetHLine(PLANE5,400,0,HLEN-1);
	SetVLine(PLANE5,400,0,VLEN-1);

	vp = PLANE0;
	for (v = 0; v < 256; ++v) {
		hp = PLANE0;
		for (h = 0; h < 256; h+=32) {
			SetHLine(hp|vp,v,h,h+31);
			hp = hp << 1;
		}
		if ((v % 32 == 0) && (v != 0)) {
			vp = vp << 1;
		}
	}
	WaitMs(1000);
	while((READ_INT(KEYADDR1) & (1 << BTN_RUNSTOP)) == 0); 
}

#endif
