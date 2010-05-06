
/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Font.h
* Author         : Robert Schilling <robert.schilling at gmx.at>
* Date           : 22.01.2010
*****************************************************************************
* Description	 : Support for writing pixel fonts in framebuffer
*****************************************************************************

*  Copyright (c) 2010, Schilling Robert

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

#ifndef DSO_FONT
#define DSO_FONT


#include "types.h"


typedef struct Font
{
	uint8_t start;
	uint8_t end;
	uint8_t height;
	uint16_t *offsetTable;
	uint8_t *widthTable;
	uint8_t *dataTable;
}sFont;

#include "font_Arial_Bold_14.h"
#include "font_Arial_18.h"

/*
 * Prints a single character in the framebuffer
 */
uint8_t printChar_lcd(sFont *font, uint32_t x, uint32_t y, uint16_t color_fg, uint16_t _tcolor_bg, uint8_t c);

/*
 * Prints a string in the framebuffer
 */
void printStr_lcd(sFont *font, uint32_t x, uint32_t y, uint16_t color_fg, uint16_t color_bg, const char *str);

/*
 * Returns the pixel length of a given string.
 */
uint32_t getTextWidth(sFont *font, char *text);

/*
 * These functions are the same as above with the difference that they
 * work with an array of integers for a text. That's because the FPGA
 * Design only can handle 32-Bit value in runtime.
 */
void printStr_lcdi(sFont *font, uint32_t x, uint32_t y, uint16_t color_fg, uint16_t color_bg, int *str);
uint32_t getTextWidthi(sFont *font, int *text);

#endif
