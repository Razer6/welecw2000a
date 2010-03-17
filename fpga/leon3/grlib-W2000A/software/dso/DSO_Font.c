/*
 * DSO_Font.c
 *
 *  Created on: 22.01.2010
 *      Author: Robert
 */
 

#include "types.h"
#include "DSO_Font.h"
#include "DSO_Screen.h"

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
