
#ifndef DSO_FONT
#define DSO_FONT
/*
 * DSO_Font.c
 *
 *  Created on: 22.01.2010
 *      Author: Robert
 */
 

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
