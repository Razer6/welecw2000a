/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : GUI.h
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

#ifndef GUI_H_
#define GUI_H_

#include <stdio.h>
#include <stdlib.h>

#include "DSO_Font.h"
#include "DSO_Screen.h"
#include "DSO_SFR.h"
#include "DSO_FrontPanel.h"


#define FONT_TITLEBAR	font_liberation_sans_bold_14
#define FONT_MENU		font_liberation_sans_bold_14

#define SUB_MENU_CLOSETIME	300000

#define MENU_START_X	0
#define MENU_WIDTH		(HLEN)

#define MENU_HEIGHT		(35)
#define MENU_START_Y	(VLEN-MENU_HEIGHT)

#define MENU_LINE_WIDTH		3
#define SUB_MENU_WIDTH

/*
 * Horizontal starting position for a submenu
 */
#define MENU_START_MEN_F1	0
#define MENU_START_MEN_F2	106
#define MENU_START_MEN_F3	213
#define MENU_START_MEN_F4	320
#define MENU_START_MEN_F5	426
#define MENU_START_MEN_F6	533

/*
 * Default bounds for a submenu
 */
#define DEFAULT_BOUNDS_F1	{MENU_START_MEN_F1, MENU_START_Y, 103, MENU_HEIGHT}
#define DEFAULT_BOUNDS_F2	{MENU_START_MEN_F2, MENU_START_Y, 103, MENU_HEIGHT}
#define DEFAULT_BOUNDS_F3	{MENU_START_MEN_F3, MENU_START_Y, 103, MENU_HEIGHT}
#define DEFAULT_BOUNDS_F4	{MENU_START_MEN_F4, MENU_START_Y, 103, MENU_HEIGHT}
#define DEFAULT_BOUNDS_F5	{MENU_START_MEN_F5, MENU_START_Y, 103, MENU_HEIGHT}
#define DEFAULT_BOUNDS_F6	{MENU_START_MEN_F6, MENU_START_Y, 103, MENU_HEIGHT}

#define MENU_COLOR_BG	COLOR_R3G3B3(3,3,3)
#define MENU_COLOR_FG	COLOR_R3G3B3(0,0,0)
#define BG_COLOR 		COLOR_R3G3B3(0,0,0)

#define TITLE_BAR_START_X			0
#define TITLE_BAR_END_X				(HLEN)
#define TITLE_BAR_START_Y			0
#define TITLE_BAR_END_Y				18

#define TITLE_BAR_COLOR_BG		COLOR_R3G3B3(3,3,3)
#define TITLE_BAR_COLOR_FG		COLOR_R3G3B3(0,0,0)

#define FONT_STATUS_BAR		font_liberation_sans_bold_14

#define STATUS_BAR_START_X			0
#define STATUS_BAR_END_X				(HLEN)
#define STATUS_BAR_START_Y			423
#define STATUS_BAR_END_Y			441

#define STATUS_BAR_COLOR_BG		COLOR_R3G3B3(2,2,2)
#define STATUS_BAR_COLOR_FG		COLOR_R3G3B3(0,0,0)

/* Grid defines */
#define GRIDCOLOR COLOR_R3G3B3(3,3,3)

extern uint32_t gridbuffer[VLEN][HLEN/32];

#define GRID_RECT_START_Y	(TITLE_BAR_END_Y+2)
#define GRID_RECT_START_X	(20)
//#define GRID_RECT_END_Y		(MENU_START_Y-2)
#define GRID_RECT_END_Y		(GRID_RECT_START_Y+400)
#define GRID_RECT_END_X		(HLEN-20)

/*
 * Horizontal Positions for items in the titlemenu
 */
enum TITLEMENU
{
	VOLTAGE_CH0 = 80,
	VOLTAGE_CH1 = 170,
	VOLTAGE_CH2 = 260,
	VOLTAGE_CH3 = 350,
	TIMEBASE = 480,
	TRIGGERLEVEL = 580
};

#define SML_TITLE_HEIGHT	25
#define SML_ENTRY_HEIGHT	30
#define	SML_HEIGHT(y)		(SML_TITLE_HEIGHT + (y*SML_ENTRY_HEIGHT))
#define SML_START_POS_Y(x)	(VLEN - MENU_HEIGHT - (SML_HEIGHT((x))))

typedef struct SubMenuList
{
	char *title;
	sRect bounds;

	sRect popup;
	uint32_t size;
	uint32_t selectedIndex;

	void (*smlFunct)(int32_t selection);
	char *entrys[];
}
sSubMenuList;


typedef struct CheckBox
{
	char *title;
	sRect bounds;

	uint32_t selected;
	void (*cbFunct)(int32_t selection);
}
sCheckBox;

typedef struct ValueField
{
	char *title;
	sRect bounds;

	int32_t value;
	int32_t minValue;
	int32_t maxValue;

	void (*vfFunct)(int32_t value);
}
sValueField;

typedef struct Button
{
	char *title;
	sRect bounds;
	void (*btFunct)(void);
}
sButton;

/*
 * Enum to identify a submenu.
 */
enum MENU_TYPE
{
	SUBMENU_LIST,
	CHECKBOX,
	VALUE_FIELD,
	BUTTON
};

/*
 * Wrapper for all submenu items.
 * So it is possible to add any submenu item to a submenu.
 */
typedef struct SubMenu
{
	enum MENU_TYPE type;
	void *menuItem;
}
sSubMenu;


/*
 * A submenu contains 6 submenu items and a functions wich will be called
 * when a menu gets activated.
 */
typedef struct Menu
{
	sSubMenu *subMenu[6];
	void (*enter_funct)(void);
}
sMenu;

extern sMenu *activeMenu;

void updateMenu(void *menu_context);

void titleBarInit(void);

void updateTitleBar(enum TITLEMENU type, const char *text);

void status_bar_init(void);

void onSubMenu(void *subMenu_context);

void actionhandler(void);

void closeSubMenuTime(void);

void vfValueChanged(int32_t diff);



#endif /* GUI_H_ */
