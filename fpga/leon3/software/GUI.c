/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : GUI.c
* Author         : Robert Schilling <robert.schilling at gmx.at>
* Date           : 19.02.2010
*****************************************************************************
* Description	 : Little GUI Framework
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "GUI.h"
#include "util.h"
#include "DSO_Main.h"
#include "DSO_SFR.h"
#include "DSO_Misc.h"
#include "symbols.h"

#include "timer.h"


sSubMenuList *openSubMenuList = NULL;
sMenu *activeMenu;
volatile uint32_t closingTime = 0;

#define CENTER(width, textlen)		((width-textlen)/2)

void resetClosingTime(void);

void onCheckBox(sCheckBox *box);
void drawCheckBox(sCheckBox *box);

void onValueField(sValueField *valueField);
void drawValueField(sValueField *valueField);

void onSubMenuList(sSubMenuList *subMenuList);
void drawSubMenuList(sSubMenuList *subMenuList);

void onButton(sButton *button);
void drawButton(sButton *button);

/* Following Submenu items are currently implemented:
 * 		* Submenulist
 * 		* Checkbox
 * 		* Valuefield (currently not yet implemented at all)
 *
 * The implemented elements are shown in the enum MENU_TYPE in GUI.h.
 * If you are adding a new submenu element you have add the type to this enum.
 * This enum is the base to recognize which element should be drawn.
 *
 * Every submenu element must implement following functions
 *
 * /SubMenuElement/ is standing for the corresponding Element
 *
 * void draw/SubMenuElement/(/subMenuElement/ *element);
 * 		This function draws the Element on the screen if there is a menu update.
 *
 * void on/SubMenuElement/(/subMenuElement/ *element);
 * 		This function will be called when the button to the dedicated element is
 * 		pressed. This function also calls the user function.
 *
 */


/*
 * This function will be called when a submenu button is pressed.
 * The method calls the corresponding function of the submenu.
 */

void onSubMenu(void *subMenu_context)
{
	sSubMenu *subMenu = activeMenu->subMenu[(uint32_t) subMenu_context];
	
	if(subMenu == NULL)
	{
		return;
	}

	switch(subMenu->type)
	{
		case SUBMENU_LIST:
			onSubMenuList((sSubMenuList*)subMenu->menuItem);
		break;

		case CHECKBOX:
			onCheckBox((sCheckBox*)subMenu->menuItem);
		break;

		case VALUE_FIELD:
			onValueField((sValueField*)subMenu->menuItem);
		break;
		
		case BUTTON:
			onButton((sButton*)subMenu->menuItem);
		break;

		default:
		break;
	}
}

/* Draws a closed submenu */

void initSubMenu(sSubMenu *subMenu)
{
	if(subMenu == NULL)
	{
		return;
	}
	switch(subMenu->type)
	{
		case SUBMENU_LIST:
			drawSubMenuList((sSubMenuList*)subMenu->menuItem);
		break;

		case CHECKBOX:
			drawCheckBox((sCheckBox*)subMenu->menuItem);
		break;

		case VALUE_FIELD:
			drawValueField((sValueField*)subMenu->menuItem);
		break;
		
		case BUTTON:
			drawButton((sButton*)subMenu->menuItem);
		break;

		default:
		break;
	}
}






/*   CHECKBOX
 *
 * A checkbox contains a title, bounds where the checkbox is drawn, a selection
 * attribute and a function pointer.
 * Every time when the dedicated button is pressed, the function pointer will be called.
 *
 */
 


void drawCheckBox(sCheckBox *box)
{
	DrawRect32(MENU_COLOR_FG, box->bounds.x+45, box->bounds.y+19, 14, 13, false);
	DrawRect32(MENU_COLOR_FG, box->bounds.x+46, box->bounds.y+20, 12, 11, false);
	DrawRect32(box->selected?MENU_COLOR_FG:MENU_COLOR_BG, box->bounds.x+49, box->bounds.y+23, 6, 6, true);
	printStr_lcd(&FONT_MENU, box->bounds.x+CENTER(104, getTextWidth(&FONT_MENU, box->title)), box->bounds.y, MENU_COLOR_FG, MENU_COLOR_BG, box->title);
}

void onCheckBox(sCheckBox *box)
{
	if(box->selected)
	{
		box->selected = 0;
	}
	else
	{
		box->selected = 1;
	}

	DrawRect32(box->selected?MENU_COLOR_FG:MENU_COLOR_BG, box->bounds.x+49, box->bounds.y+23, 6, 6, true);
	printStr_lcd(&FONT_MENU, box->bounds.x+CENTER(104, getTextWidth(&FONT_MENU, box->title)), box->bounds.y, MENU_COLOR_FG, MENU_COLOR_BG, box->title);

	if(box->cbFunct != NULL)
	{
		box->cbFunct(box->selected);
	}
}

/*
 * SUBMENU LIST
 *
 * A submenulist is a submenu with several items. The first press on the according
 * submenu opens the menu. The next press changes the selection of the list and
 * calls the stored user function with the selected index.
 */

void drawSubMenuList(sSubMenuList *subMenuList)
{
	DrawRect32(MENU_COLOR_BG, subMenuList->bounds.x, subMenuList->bounds.y, subMenuList->bounds.width, subMenuList->bounds.height, true);
	printStr_lcd(&FONT_MENU, subMenuList->bounds.x+CENTER(104, getTextWidth(&FONT_MENU, subMenuList->title)), subMenuList->bounds.y, MENU_COLOR_FG, MENU_COLOR_BG, subMenuList->title);
	printStr_lcd(&FONT_MENU, subMenuList->bounds.x+CENTER(104, getTextWidth(&FONT_MENU, subMenuList->entrys[subMenuList->selectedIndex])), subMenuList->bounds.y+17, MENU_COLOR_FG, MENU_COLOR_BG, subMenuList->entrys[subMenuList->selectedIndex]);
	LoadBitmap(&sym_up, subMenuList->bounds.x+subMenuList->bounds.width-sym_up.width-5, subMenuList->bounds.y+5, MENU_COLOR_FG);
}

#define SML_SEL_WIDTH		5
#define SML_SEL_HEIGHT		5

void onSubMenuList(sSubMenuList *subMenuList)
{
	if(openSubMenuList == subMenuList)	//Menu already open
	{
		resetClosingTime();
		DrawRect32(MENU_COLOR_BG, subMenuList->popup.x+5, subMenuList->popup.y+40+subMenuList->selectedIndex*25, SML_SEL_WIDTH, SML_SEL_HEIGHT, true);

		if(++subMenuList->selectedIndex >= subMenuList->size)
		{
			subMenuList->selectedIndex = 0;
		}

		DrawRect32(MENU_COLOR_FG, subMenuList->popup.x+5, subMenuList->popup.y+40+subMenuList->selectedIndex*25, SML_SEL_WIDTH, SML_SEL_HEIGHT, true);
		drawSubMenuList(subMenuList);

		if(subMenuList->smlFunct != NULL)
		{
			subMenuList->smlFunct(subMenuList->selectedIndex);
		}
	}
	else
	{
		resetClosingTime();
		sRect *clipping = getClippingRect();

		if(clipping != NULL) //Close another Submenu if open
		{
			DrawRect32(BG_COLOR, clipping->x, clipping->y, clipping->width, clipping->height, true);
			drawGrid();
			status_bar_init();
		}

		openSubMenuList = subMenuList;
		clipping = &subMenuList->popup;
		setClippingRect(clipping);

		DrawRect32(MENU_COLOR_BG, clipping->x, clipping->y, clipping->width, clipping->height, true);

		printStr_lcd(&FONT_MENU, subMenuList->popup.x+CENTER(104,getTextWidth(&FONT_MENU, subMenuList->title)), subMenuList->popup.y+2, MENU_COLOR_FG, MENU_COLOR_BG, subMenuList->title);
		DrawRect32(MENU_COLOR_FG, subMenuList->popup.x+5, subMenuList->popup.y+FONT_MENU.height+5,subMenuList->popup.width-10, 3, true);

		for(uint32_t i=0, y=30; i<subMenuList->size; i++, y+=25)
		{
			if(i == subMenuList->selectedIndex)
			{
				DrawRect32(MENU_COLOR_FG, subMenuList->popup.x+5, subMenuList->popup.y+40+subMenuList->selectedIndex*25, SML_SEL_WIDTH, SML_SEL_HEIGHT, true);
			}
			printStr_lcd(&FONT_MENU, subMenuList->popup.x+20, subMenuList->popup.y+y, MENU_COLOR_FG, MENU_COLOR_BG, subMenuList->entrys[i]);
		}
	}
}

/* This function closes an open submenu. Should be done in an timer
 * interrupt routine */

void closeSubMenu(void)
{
	sRect *clipping = getClippingRect();
	if(clipping != NULL)
	{
		DrawRect32(BG_COLOR, clipping->x, clipping->y, clipping->width, clipping->height, true);
		drawGrid();
		status_bar_init();
		setClippingRect(NULL);
		openSubMenuList = NULL;
	}
}

/* This function simulates a timer interrupt routine. The main loop calls this
 * routine.
 */

void closeSubMenuTime(void)
{
	sRect *clipping = getClippingRect();

	if(clipping != NULL)
	{
		if(++closingTime > SUB_MENU_CLOSETIME)
		{
			closingTime = 0;
			closeSubMenu();
		}
	}
	else
	{
		closingTime=0;
	}
}

/* If there is an open submenu and there is another press on the according key
 * the closing time will be reseted.
 */

void resetClosingTime(void)
{
	closingTime = 0;
}

/*
 * VALUE FIELD
 *
 * A valuefield contains a title and a value. The value can be changed using
 * the "user"-encoder (under timbase encoder). Before changing the value,
 * the valuefield must be selected. The value is limited by a minimal and
 * a maximum value.
 */

sValueField *selectedValueField = NULL;

/*
 * This function draws a single valuefield.
 */

void drawValueField(sValueField *valueField)
{
	int str[20];
	DrawRect32(MENU_COLOR_BG, valueField->bounds.x, valueField->bounds.y, valueField->bounds.width, valueField->bounds.height, true);

	printStr_lcd(&FONT_MENU, valueField->bounds.x+CENTER(104, getTextWidth(&FONT_MENU, valueField->title)), valueField->bounds.y, MENU_COLOR_FG, MENU_COLOR_BG, valueField->title);
	itoa(valueField->value, str);
	printStr_lcdi(&FONT_MENU, valueField->bounds.x+CENTER(104, getTextWidthi(&FONT_MENU, str)), valueField->bounds.y+17, MENU_COLOR_FG, MENU_COLOR_BG, str);

	if (selectedValueField == valueField)
	{
		DrawRect32(MENU_COLOR_FG, valueField->bounds.x+5, valueField->bounds.y+5, valueField->bounds.width-10, valueField->bounds.height-10, false);
	}
}

/*
 * This function changes the value of a valuefield. If no valuefield is
 * selected nothing happens.
 */

void vfValueChanged(int32_t diff)
{
	if(selectedValueField == NULL)
	{
		return;
	}

	selectedValueField->value += diff;

	if(selectedValueField->value > selectedValueField->maxValue)
	{
		selectedValueField->value = selectedValueField->maxValue;
	}
	else if(selectedValueField->value < selectedValueField->minValue)
	{
		selectedValueField->value = selectedValueField->minValue;
	}

	drawValueField(selectedValueField);
}

/*
 * This function selects the valuefield in order to change the value
 * with the encoder.
 */

void onValueField(sValueField *valueField)
{
	if(selectedValueField == valueField) //valueField already selected
	{
		return;
	}

	if(selectedValueField != NULL)
	{
		//Deselect the current valuefield
		DrawRect32(MENU_COLOR_BG, selectedValueField->bounds.x+2, selectedValueField->bounds.y+2, selectedValueField->bounds.width-4, selectedValueField->bounds.height-4, false);
	}

	//Select the new valuefield
	selectedValueField = valueField;
	DrawRect32(MENU_COLOR_FG, valueField->bounds.x+2, valueField->bounds.y+2, valueField->bounds.width-4, valueField->bounds.height-4, false);

	//Turn on the led for the encoder
	WRITE_INT(LEDADDR, READ_INT(LEDADDR) | 1<<LED_WHEEL);
}

/*
 * BUTTON
 *
 * A valuefield contains a title and a function. If the button is pressed
 * the user function will be called.
 */

/*
 * This functin calls the user function of a button
 */
void onButton(sButton *button)
{
	button->btFunct();
}

/*
 * This function draws a single buttn 
 */
void drawButton(sButton *button)
{
	printStr_lcd(&FONT_MENU, button->bounds.x+CENTER(104, getTextWidth(&FONT_MENU, button->title)), button->bounds.y+8, MENU_COLOR_FG, MENU_COLOR_BG, button->title);
}


/* Draws a new Menu
 * Must be called in the DSO GUI to update the screen
 */

void updateMenu(void *menu_context)
{
	sMenu *menu = (sMenu*) menu_context;
	
	closeSubMenu();
	resetClosingTime();

	openSubMenuList = NULL;

	if(activeMenu != menu)
	{
		activeMenu = menu;

		//Draw background of menus
		DrawRect32(MENU_COLOR_BG, MENU_START_X, MENU_START_Y, MENU_WIDTH, MENU_HEIGHT, true);

		DrawRect32(MENU_COLOR_FG, MENU_START_MEN_F2-MENU_LINE_WIDTH, MENU_START_Y, MENU_LINE_WIDTH, MENU_HEIGHT, true);
		DrawRect32(MENU_COLOR_FG, MENU_START_MEN_F3-MENU_LINE_WIDTH, MENU_START_Y, MENU_LINE_WIDTH, MENU_HEIGHT, true);
		DrawRect32(MENU_COLOR_FG, MENU_START_MEN_F4-MENU_LINE_WIDTH, MENU_START_Y, MENU_LINE_WIDTH, MENU_HEIGHT, true);
		DrawRect32(MENU_COLOR_FG, MENU_START_MEN_F5-MENU_LINE_WIDTH, MENU_START_Y, MENU_LINE_WIDTH, MENU_HEIGHT, true);
		DrawRect32(MENU_COLOR_FG, MENU_START_MEN_F6-MENU_LINE_WIDTH, MENU_START_Y, MENU_LINE_WIDTH, MENU_HEIGHT, true);

		//Draw all Submenus
		for(uint32_t i=0; i<6; i++)
		{
			initSubMenu(menu->subMenu[i]);
		}
	}

	//Run menu function if available
	if(menu->enter_funct != NULL)
	{
		menu->enter_funct();
	}
}


/*
 * Draws the naked Titlebar. This function doesn't draw
 * any values like the actual timbase or voltage per div.
 */

void titleBarInit(void)
{
	DrawBox(TITLE_BAR_COLOR_BG, TITLE_BAR_START_X, TITLE_BAR_START_Y, TITLE_BAR_END_X, TITLE_BAR_END_Y);

	printStr_lcd(&FONT_TITLEBAR, VOLTAGE_CH0-35, 2, TITLE_BAR_COLOR_FG, TITLE_BAR_COLOR_BG, "CH1:");
	printStr_lcd(&FONT_TITLEBAR, VOLTAGE_CH1-35, 2, TITLE_BAR_COLOR_FG, TITLE_BAR_COLOR_BG, "CH2:");
	printStr_lcd(&FONT_TITLEBAR, TIMEBASE-23, 2, TITLE_BAR_COLOR_FG, TITLE_BAR_COLOR_BG, "TB:");
	printStr_lcd(&FONT_TITLEBAR, TRIGGERLEVEL-27, 2, TITLE_BAR_COLOR_FG, TITLE_BAR_COLOR_BG, "TR:");
}

/*
 * This function writes a string to the titlebar. The horizontal positions
 * are stored in the enum TITLEMENU declared in GUI.h
 */

void updateTitleBar(enum TITLEMENU type, const char *text)
{
	DrawBox(TITLE_BAR_COLOR_BG, type, TITLE_BAR_START_Y, type+50, TITLE_BAR_END_Y);
	printStr_lcd(&FONT_TITLEBAR, type, 2 , TITLE_BAR_COLOR_FG, TITLE_BAR_COLOR_BG, text);
}

/*
 * Draws the naked Statusbar. This function doesn't draw
 * any values like the actual timbase or voltage per div.
 */

void status_bar_init(void)
{
	int str1[12];
	int str2[12];
	int str3[12];
	int str4[12];

	DrawBox(STATUS_BAR_COLOR_BG, STATUS_BAR_START_X, STATUS_BAR_START_Y, STATUS_BAR_END_X, STATUS_BAR_END_Y);

	itoa(debug1(), str1);
	itoa(debug2(), str2);
	itoa(debug3(), str3);
	itoa(debug4(), str4);

	printStr_lcdi(&FONT_STATUS_BAR, 0, STATUS_BAR_START_Y, STATUS_BAR_COLOR_FG, STATUS_BAR_COLOR_BG, str1);
	printStr_lcdi(&FONT_STATUS_BAR, 120, STATUS_BAR_START_Y, STATUS_BAR_COLOR_FG, STATUS_BAR_COLOR_BG, str2);
	printStr_lcdi(&FONT_STATUS_BAR, 240, STATUS_BAR_START_Y, STATUS_BAR_COLOR_FG, STATUS_BAR_COLOR_BG, str3);
	printStr_lcdi(&FONT_STATUS_BAR, 360, STATUS_BAR_START_Y, STATUS_BAR_COLOR_FG, STATUS_BAR_COLOR_BG, str4);
}

uint32_t gridbuffer[VLEN][HLEN/32];

/*
 * This function draws a horizontal line in the gridbuffer.
 */
void generateHLine(uint32_t startX, uint32_t endX, uint32_t startY)
{
    uint32_t x;
    uint32_t offsetFirst = 0;

    if((startX%32) != 0)
    {
        offsetFirst=1;
        for(x=0; x<32-(startX%32); x++)
        {
        	gridbuffer[startY][startX/32] |= (1<<x);
        }
    }

    for(x=(startX/32)+offsetFirst; x<endX/32; x++)
    {
    	gridbuffer[startY][x] = 0xFFFFFFFF;
    }

    if((endX % 32) != 0)
    {
        for(x=31; x>=32-(endX % 32); x--)
        {
        	gridbuffer[startY][(endX/32)] |= (1<<x);
        }
    }

}
/*
 * This function draws a vertical line in the gridbuffer.
 */
void generateVLine(uint32_t x, uint32_t startY, uint32_t endY)
{
    uint32_t y;
    uint32_t mask = 1<<(31-(x%32));

    for(y=startY; y<endY; y++)
    {
    	gridbuffer[y][x/32] |= mask;
    }
}

/*
 * This function generates the grid. Currently it is a simple 50x50 box
 * grid.
 */
void generategrid(void)
{
	uint32_t x,y;
	memset(gridbuffer, 0, sizeof(gridbuffer));

	 for(x=GRID_RECT_START_X; x<=GRID_RECT_END_X; x+=50)
	{
		generateVLine(x, GRID_RECT_START_Y, GRID_RECT_END_Y);
	}

	for(y=GRID_RECT_START_Y; y<=GRID_RECT_END_Y; y+=50)
	{
		   generateHLine(GRID_RECT_START_X, GRID_RECT_END_X, y);
	}
}

/*
 * This functions draws the grid on the display. Only if there is a pixel to set
 * a pixel is drawn.
 *
 * The gridbuffer is a 32 Bit 2D Array with a size of WIDTH/32xHEIGHT.
 * So every bit signals a pixel.
 */

void drawGrid(void)
{
	for(uint32_t y=0; y<480; y++)
	{
		for(uint32_t x=0; x<640/32; x++)
		{
			if(gridbuffer[y][x])
			{
				uint32_t tmp = gridbuffer[y][x];
				uint32_t xt = x*32;
				uint32_t xe = xt+32;

				for(uint32_t mask=0x80000000; xt<xe; xt++, mask>>=1)
				{
					if(tmp & mask)
						DrawPixel32(GRIDCOLOR, xt, y);
				}
			}
		}
	}
}




