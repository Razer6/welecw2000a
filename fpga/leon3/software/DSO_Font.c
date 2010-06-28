/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Font.c
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
 

#include "types.h"
#include "DSO_Font.h"
#include "DSO_Screen.h"

#ifdef BOARD_COMPILATION

void printStr_lcd(sFont *font, uint32_t x, uint32_t y, uint16_t color_fg, uint16_t color_bg, const char *str)
{
	uint16_t width = 0;
	while(*str)
	{
		width += printChar_lcd(font, x+width, y, color_fg, color_bg, (int)*str++);
	}
}

void printStr_lcdi(sFont *font, uint32_t x, uint32_t y, uint16_t color_fg, uint16_t color_bg, int *str)
{
	uint16_t width = 0;
	while(*str)
	{
		width += printChar_lcd(font, x+width, y, color_fg, color_bg, *str++);
	}
}

uint8_t printChar_lcd(sFont *font, uint32_t x, uint32_t y, uint16_t color_fg, uint16_t color_bg, uint8_t c)
{
	uint8_t index = c-font->start;

	uint8_t width = font->widthTable[index];
	uint8_t *data = &font->dataTable[font->offsetTable[index]];

	register uint32_t x_t, y_t=y;
	register uint8_t mask = 0x80;

	for(; y_t<y+font->height; y_t++)
	{
		for(x_t=x; x_t< x+width; x_t++, mask>>=1)
		{
			if(mask <= 0)
		   {
			   mask = 0x80;
			   data++;
		   }

		   if(*data & mask)
		   {
			   DrawPixel32(color_fg, x_t, y_t);
		   }
		   else
		   {
			   DrawPixel32(color_bg, x_t, y_t);
		   }
	   }
	}
	return width;
}

uint32_t getTextWidth(sFont *font, char *text)
{
	register uint32_t textwidth = 0;

	while(*text)
	{
		textwidth += font->widthTable[*text++-font->start];
	}
	return textwidth;
}

uint32_t getTextWidthi(sFont *font, int *text)
{
	register uint32_t textwidth = 0;

	while(*text)
	{
		textwidth += font->widthTable[*text++-font->start];
	}
	return textwidth;
}

#endif
