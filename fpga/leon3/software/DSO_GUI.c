/*****************************************************************************
 * File           : DSO_GUI.c
 * Author         : Alexander Lindert <alexander_lindert at gmx.at>
 * Date           : 07.09.2009
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "types.h"
#include "DSO_Main.h"
#include "DSO_GUI.h"
#include "DSO_Screen.h"
#include "Filter_I8.h"
#include "DSO_SFR.h"
#include "DSO_SignalCapture.h"
#include "Leon3Uart.h"
#include "rprintf.h"
#include "DSO_Misc.h"

#include "DSO_FrontPanel.h"

#include "GUI.h"

#define SIGNAL_HSTART 20
#define SIGNAL_HSTOP  HLEN-20
#define BG_COLOR COLOR_R3G3B3(0,0,0)
#define PREFETCH_OFFSET 32

#define SETLED(data, BTN_Bit, LED_Bit) \
	if ((READ_INT(KEYADDR1) & (1 << BTN_Bit)) != 0)\
		data = data | (1 << LED_Bit);\
	else	data = data & ~(1 << LED_Bit)

#ifdef BOARD_COMPILATION

typedef struct
{
	int32_t V;
	int32_t H;
}DispOffset;

void SetAnalogOffset ();
void SetTriggerLevel();
void SetKeyFs();
void SetVoltagePerDivision();

void setTimebase(int32_t diff);
void setAnalogOffset(uint32_t ch, int32_t diff);
void setVoltagePerDiv(uint32_t ch, int32_t diff);

/* Picture for Trigger Level */

#define TRIGGERARROW_GLCD_HEIGHT 12
#define TRIGGERARROW_GLCD_WIDTH  18
static uint8_t triggerarrow_glcd_bmp[]= {
					0x00, 0x08, 0x00,
					0x00, 0x0c, 0x00,
					0x00, 0x0e, 0x00,
					0x00, 0x0f, 0x00,
					0x00, 0x0f, 0x80,
					0xff, 0xff, 0xc0,
					0xff, 0xff, 0xc0,
					0x00, 0x0f, 0x80,
					0x00, 0x0f, 0x00,
					0x00, 0x0e, 0x00,
					0x00, 0x0c, 0x00,
					0x00, 0x08, 0x00
};

/* Colors for Signaldrawing
 * signalcolors[0] = Channel 0
 * signalcolors[1] = Channel 1
 */

color_t signalcolors[2] = {COLOR_R3G3B3(7,7,0), COLOR_R3G3B3(0,7,0)};

typedef struct
{
	int32_t P;
	int32_t C;
}SampleRet;

void DrawSample(
		uint16_t ColorBack,
		uint16_t ColorSignal,
		uint32_t v,
		SampleRet hp,
		SampleRet hc);

void DrawSignal(
		uint32_t Voffset,
		uSample * PrevData,
		uSample * CurrData,
		uint16_t PrevColor,
		uint16_t CurrColor)
{

	register uint32_t i = SIGNAL_HSTART+1;
	register SampleRet Prev;
	register SampleRet Curr;

	Prev.C = CurrData[SIGNAL_HSTART].i + Voffset;

	if (Prev.C <= GRID_RECT_START_Y) Prev.C = GRID_RECT_START_Y+1;
	if (Prev.C >= GRID_RECT_END_Y) Prev.C = GRID_RECT_END_Y-1;

	Prev.P = PrevData[SIGNAL_HSTART].i + Voffset;

	if (Prev.P <= GRID_RECT_START_Y) Prev.P = GRID_RECT_START_Y+1;
	if (Prev.P >= GRID_RECT_END_Y) Prev.P = GRID_RECT_END_Y-1;

	for (; i < SIGNAL_HSTOP; ++i)
	{
		/*		Prev = PrevData[i].i + Voffset;
		 lastPrev = DrawSample(PrevColor,i,Prev,lastPrev);
		 Curr = CurrData[i].i + Voffset;
		 lastCurr = DrawSample(CurrColor,i,Curr,lastCurr);*/
		Curr.P = PrevData[i].i + Voffset;
		Curr.C = CurrData[i].i + Voffset;
		/* avoid drawing out of grid only once per sample (return value)*/
		if (Curr.P <= GRID_RECT_START_Y) Curr.P = GRID_RECT_START_Y+1;
		if (Curr.P >= GRID_RECT_END_Y) Curr.P = GRID_RECT_END_Y-1;

		if (Curr.C <= GRID_RECT_START_Y) Curr.C = GRID_RECT_START_Y+1;
		if (Curr.C >= GRID_RECT_END_Y) Curr.C = GRID_RECT_END_Y-1;

		DrawSample(PrevColor, CurrColor, i, Prev, Curr);
		Prev = Curr;

	}

}

/* drawing uninterrupted lines in a race condition framebuffer */
void DrawSample(uint16_t ColorBack, uint16_t ColorSignal, uint32_t v, SampleRet hp, SampleRet hc)
{
	register uint32_t pl = 0;
	register uint32_t ph = 0;
	register uint32_t cl = 0;
	register uint32_t ch = 0;

	if (hp.P < hc.P)
	{
		pl = hp.P;
		ph = hc.P;
	}
	else
	{
		pl = hc.P;
		ph = hp.P;
	}

	if (hp.C < hc.C)
	{
		cl = hp.C;
		ch = hc.C;
	}
	else
	{
		cl = hc.C;
		ch = hp.C;
	}

	ClearVLineClipped(ColorBack,v,pl,ph);
	DrawVLineClipped(ColorSignal,v,cl,ch);
}

void ConvSample (
		int32_t * dst,
		int32_t * src,
		int32_t const * const fir)
{

	register int fir_idx = 0;
	register int32_t result = 0;

	for(fir_idx = 0; fir_idx < POLYPHASE_COEFFS; fir_idx+= 1)
	{
		result += src[fir_idx] * fir[POLYPHASE_COEFFS-1-fir_idx];
	}
	*dst = result/(32768);
}

void Interpolate (
		uint32_t dstSamples,
		uSample *Dst,
		uSample *Src,
		uint32_t type)
{

	register uint32_t i = 0;
	register uint32_t j = 0;
	register uint32_t dst_idx = 0;
	register int32_t * fir;

	register uint32_t srcSamples = dstSamples/POLYPHASES;

	for (i = 0; i < srcSamples; ++i)
	{
		for (j = 0; j < POLYPHASES; ++j)
		{
			fir = (int32_t*)&Filter_I8[j][0];
			ConvSample(&Dst[dst_idx].i,&Src[i].i,fir);
			/*	Dst[dst_idx] = Src[i];*/
			dst_idx++;
		}
	}
}

void GetCh(
		uint32_t ch,
		uint32_t size,
		uSample * dst,
		uSample * src,
		uint32_t srcSamples)
{

	register uint32_t i = 0;
	register int32_t data = 0;
	switch (size)
	{
		case 8:
		for (; i < srcSamples; ++i)
		{
			data = (int32_t)src[i].c[ch];
			dst[i].i = -data;
		}
		break;
		case 16:
		for (; i < srcSamples; ++i)
		{
			data = (int32_t)src[i].s[ch];
			dst[i].i = -data;
		}
		break;
		default:
		for (; i < srcSamples; ++i)
		{
			dst[i].i = -src[i].i;
		}
		break;
	}
}

extern uSample Data[CAPTURESIZE];

static DispOffset Offset[2];

/*
 * All settings which are associated to a channel
 */
typedef struct ChannelSettings
{
	uint32_t state; 				//On=1, Off=0
	int32_t selectedVoltagePerDiv; //Index for Table voltagePerDiv
	SetAnalog analog;				//Analog Settings
}
sChannelSettings;

/*
 * Channel Settings for all channels
 */
sChannelSettings channel[2];

/*
 * Selectable Voltage per div for Analog settings
 */
const uint32_t voltagePerDiv[] =
{
 	5000000, 2000000, 1000000, //5V - 1V
	500000, 200000, 100000, //500mV - 100mV
	50000, 20000, 10000}; //50mV - 10mV

/*
 * Display Strings for voltage per div.
 * Must match voltagePerDiv[]
 */
const char *voltagePerDiv_str[] =
{	"5V/div", "2V/div","1V/div",
	"500mV/div", "200mV/div","100mV/div",
	"50mV/div", "20mV/div","10mV/div"};



/**
 * Default Trigger Settings
 */

sTriggerSettings triggerSettings =
{
	.type = NORMAL_TRIGGER,
	.edge = 0,
	.channel = 0,
	.level = 0,
	.prefetch = 64,
	.schmitt = 2,
	.pulse = 1
};

void clearTriggerMark(void);

void changeTriggerEdge(uint32_t selection);
void changeTriggerType(uint32_t selection);
void changeTriggerChannel(uint32_t selection);
void changeTriggerLevel(int32_t diff);
void setFramePosition(uint32_t diff);
void changeCouplingCh0(uint32_t selection);
void changeCouplingCh1(uint32_t selection);
void toggleBWLimitCh0(uint32_t selection);
void toggleBWLimitCh1(uint32_t selection);
void changeHWFilters(int32_t x);
void onChannel0(void);
void onChannel1(void);

/*
 * Submenu items for menu for channel 0 and channel 1
 */
sCheckBox cbBwLimitCh0 = {"BW Limit", DEFAULT_BOUNDS_F2, 0, toggleBWLimitCh0};
sCheckBox cbBwLimitCh1 = {"BW Limit", DEFAULT_BOUNDS_F2, 0, toggleBWLimitCh1};
/*sCheckBox cbInvertCh0 = {"Invert", DEFAULT_BOUNDS_F3, 0, NULL};
sCheckBox cbInvertCh1 = {"Invert", DEFAULT_BOUNDS_F3, 0, NULL};*/
sSubMenuList smlHWFilter = {"HW-Filters", DEFAULT_BOUNDS_F3, {213, SML_START_POS_Y(4), 103, SML_HEIGHT(4)}, 4, 0, changeHWFilters, 
{"None", "1G>100M", "1G>10MS", "1G>1MS"}};

sSubMenuList smlCoublingCh0 = {"Coupling", DEFAULT_BOUNDS_F1, {0, SML_START_POS_Y(2), 103, SML_HEIGHT(2)}, 2, 0, changeCouplingCh0, {"AC", "DC"}};
sSubMenuList smlCoublingCh1 = {"Coupling", DEFAULT_BOUNDS_F1, {0, SML_START_POS_Y(2), 103, SML_HEIGHT(2)}, 2, 0, changeCouplingCh1,	{"AC", "DC"}};

/*
 * This extra definition of the wrapper submenu item is not needed.
 * It can be declared in the menu directly.
 */
sSubMenu smBwLimitCh0 = {CHECKBOX, &cbBwLimitCh0};
sSubMenu smBwLimitCh1 = {CHECKBOX, &cbBwLimitCh1};
/*sSubMenu smInvertCh0 = {CHECKBOX, &cbInvertCh0};
sSubMenu smInvertCh1 = {CHECKBOX, &cbInvertCh1};*/

sSubMenu smCoublingCh0 = {SUBMENU_LIST, &smlCoublingCh0};
sSubMenu smCoublingCh1 = {SUBMENU_LIST, &smlCoublingCh1};
sSubMenu smHWFilter = {SUBMENU_LIST, &smlHWFilter};

/* Value Field Test */
sValueField vfTest0 = {"vfTest0", DEFAULT_BOUNDS_F5, 0, 0, 10, NULL};
sValueField vfTest1 = {"vfTest1", DEFAULT_BOUNDS_F6, 0, 0, 10, NULL};
sSubMenu smVfTest0 = {VALUE_FIELD, &vfTest0};
sSubMenu smVfTest1 = {VALUE_FIELD, &vfTest1};

/*
 * Menus for all channels
 */
sMenu men_ch[] = {{{&smCoublingCh0, &smBwLimitCh0, /*&smInvertCh0,*/ &smHWFilter, NULL, &smVfTest0, &smVfTest1}, onChannel0},
                  {{&smCoublingCh1, &smBwLimitCh1, /*&smInvertCh1,*/ &smHWFilter, NULL, NULL, NULL}, onChannel1}};

/*
 * Submenu items for trigger menu
 */
sSubMenuList smlTriggerTypes = {"Trigger", DEFAULT_BOUNDS_F1, {0, SML_START_POS_Y(3), 103, SML_HEIGHT(3)}, 3, 0, changeTriggerType,	{"Normal", "Glitch", "Extern"}};
sSubMenuList smlTriggerEdge = {"Edge", DEFAULT_BOUNDS_F2, {106, SML_START_POS_Y(2), 104, SML_HEIGHT(2)}, 2, 0, changeTriggerEdge, {"Rising", "Falling"}};
sSubMenuList smlTriggerChannel = {"Channel", DEFAULT_BOUNDS_F3, {213, SML_START_POS_Y(2), 104, SML_HEIGHT(2)}, 2, 0, changeTriggerChannel, {"CH1", "CH2"}};
sValueField vfTrigger = {"Level", DEFAULT_BOUNDS_F4, 0, 100, -100, NULL};

/*
 * This extra definition of the wrapper submenu item is not needed.
 * It can be declared in the menu directly.
 */
sSubMenu smTriggerTypes = {SUBMENU_LIST, &smlTriggerTypes};
sSubMenu smTriggerEdge = {SUBMENU_LIST, &smlTriggerEdge};
sSubMenu smTriggerChannel = {SUBMENU_LIST, &smlTriggerChannel};
sSubMenu smTrigger = {VALUE_FIELD, &vfTrigger};

/*
 * Trigger menu
 */
sMenu menTriggerTypes = {{&smTriggerTypes, &smTriggerEdge, &smTriggerChannel, NULL, NULL, NULL}, NULL};

/*
 * The encoder handler  must be called in the main loop.
 * This function handles the action encoders. The reading
 * of the encoders happens in a timer interrupt routine (in future).
 */

void encoder_handler(void)
{
	int32_t diff = 0;
	static uint32_t old0 = 0, old1 = 0;

	switch(get_encoder_diff(&encoder_changed0, &encoder_state0, &old0, &diff))
	{
		case 0x07<<EN_TIME_DIV:
		setTimebase(diff);
		break;
		case 0x07<<EN_LEFT_RIGHT:
		setFramePosition(diff);
		break;
		case 0x07<<EN_LEVEL:
		changeTriggerLevel(diff);
		break;
		case 0x07<<EN_F:
		vfValueChanged(diff);
		break;
		default:
		break;
	}

	diff = 0;

	switch(get_encoder_diff(&encoder_changed1, &encoder_state1, &old1, &diff))
	{
		case 0x07<<EN_CH0_UPDN:
		break;
		case 0x07<<EN_CH1_UPDN:
		break;
		case 0x07<<EN_CH2_UPDN:
		break;
		case 0x07<<EN_CH3_UPDN:
		break;
		case 0x07<<EN_CH0_VDIV:
			setVoltagePerDiv(CH0, diff);
		break;
		case 0x07<<EN_CH1_VDIV:
			setVoltagePerDiv(CH1, diff);
		break;
		case 0x07<<EN_CH2_VDIV:
		break;
		case 0x07<<EN_CH3_VDIV:
		break;
		default:
		break;
	}
}

/*
 * The button handler  must be called in the main loop.
 * This function handles the action of all keys. The key debouncing happens
 * in a seperate function called in the timer interrupt routine (in future).
 */

void buttonHandler(void)
{
	uint32_t keys = getKeyPressed(KEYMASK);

	if(!keys)
	{
		return;
	}

	switch(keys)
	{
		case 1<<BTN_F1:
		onSubMenu(activeMenu->subMenu[0]);
		break;
		case 1<<BTN_F2:
		onSubMenu(activeMenu->subMenu[1]);
		break;
		case 1<<BTN_F3:
		onSubMenu(activeMenu->subMenu[2]);
		break;
		case 1<<BTN_F4:
		onSubMenu(activeMenu->subMenu[3]);
		break;
		case 1<<BTN_F5:
		onSubMenu(activeMenu->subMenu[4]);
		break;
		case 1<<BTN_F6:
		onSubMenu(activeMenu->subMenu[5]);
		break;
		case 1<<BTN_MATH:
		break;
		case 1<<BTN_CH0:
			updateMenu(&men_ch[0]);
		break;
		case 1<<BTN_CH1:
			updateMenu(&men_ch[1]);
		break;
		case 1<<BTN_CH2:
		break;
		case 1<<BTN_CH3:

		break;
		case 1<<BTN_MAINDEL:
		break;
		case 1<<BTN_RUNSTOP:
		//	CaptureData(1000, true, true, 32768, (uint32_t*)Data);
		break;
		case 1<<BTN_SINGLE:
		break;
		case 1<<BTN_CURSORS:
		break;
		case 1<<BTN_QUICKMEAS:
		break;
		case 1<<BTN_ACQUIRE:
		break;
		case 1<<BTN_DISPLAY:
		break;
		case 1<<BTN_EDGE:
		break;
		case 1<<BTN_MODECOUPLING:
			updateMenu(&menTriggerTypes);
		break;
		case 1<<BTN_AUTOSCALE:
		break;
		case 1<<BTN_SAVERECALL:
		break;
		case 1<<BTN_QUICKPRINT:
		break;
		case 1<<BTN_UTILITY:
		break;
		case 1<<BTN_PULSEWIDTH:
		break;

		default:
		break;
	}
}


/** Changes Coupling of Channel 0
 *
 * @param selection  Trigger Type
 *
 * selection = 0: AC Coupling
 * selection = 1: DC Coupling
 */
void changeCouplingCh0(uint32_t selection)
{
	switch(selection)
	{
		case 0: channel[0].analog.AC = 1; break;
		case 1: channel[0].analog.AC = 0; break;
		default: break;
	}
	SetAnalogInputRange(0, &channel[0].analog);
}

/** Changes Coupling of Channel 1
 *
 * @param selection  Trigger Type
 *
 * selection = 0: AC Coupling
 * selection = 1: DC Coupling
 */

void changeCouplingCh1(uint32_t selection)
{
	switch(selection)
	{
		case 0: channel[1].analog.AC = 1; break;
		case 1: channel[1].analog.AC = 0; break;
		default: break;
	}
	SetAnalogInputRange(1, &channel[1].analog);
}

/** Toggles BW-Limit of Channel 0
 *
 * @param selection  Trigger Type
 *
 * selection = 0: Disables BW-Limit
 * selection = 1: Enables BW-Limit
 */

void toggleBWLimitCh0(uint32_t selection)
{
	if(selection)
	{
		channel[0].analog.BW_Limit = 1;
	}
	else
	{
		channel[0].analog.BW_Limit = 0;
	}
	SetAnalogInputRange(0, &channel[0].analog);
}

/** Toggles BW-Limit of Channel 1
 *
 * @param selection  Trigger Type
 *
 * selection = 0: Disables BW-Limit
 * selection = 1: Enables BW-Limit
 */

void toggleBWLimitCh1(uint32_t selection)
{
	if(selection)
	{
		channel[1].analog.BW_Limit = 1;
	}
	else
	{
		channel[1].analog.BW_Limit = 0;
	}
	SetAnalogInputRange(1, &channel[1].analog);
}

/*
 * Enter function of menu for Channel 0.
 */

void onChannel0(void)
{
	uint32_t leds = READ_INT(LEDADDR);

	if(channel[0].state == CHANNEL_OFF)
	{
		channel[0].state = CHANNEL_ON;
		leds |= (1 << (LED_CH0));
		changeTriggerLevel(0);
	}
	else
	{
		channel[0].state = CHANNEL_OFF;
		leds &= ~(1 << (LED_CH0));
		if(triggerSettings.channel == CH0)
		clearTriggerMark();
	}

	WRITE_INT(LEDADDR,leds);
}

/*
 * Enter function of menu for Channel 1.
 */

void onChannel1(void)
{
	uint32_t leds = READ_INT(LEDADDR);

	if(channel[1].state == CHANNEL_OFF)
	{
		channel[1].state = CHANNEL_ON;
		leds |= (1 << (LED_CH1));
		changeTriggerLevel(0);
	}
	else
	{
		channel[1].state = CHANNEL_OFF;
		leds &= ~(1 << (LED_CH1));
		if(triggerSettings.channel == CH1)
		clearTriggerMark();
	}

	WRITE_INT(LEDADDR,leds);
}

/** Changes Trigger Edge
 *
 * @param selection  Trigger Edge
 *
 * selection = 0: Rising Edge
 * selection = 1: Falling Edge
 */

void changeTriggerEdge(uint32_t selection)
{
	switch(selection)
	{
		case 0: triggerSettings.edge = 0; break; //Rising Edge
		case 1: triggerSettings.edge = 1; break; //Falling Edge
		default: break;
	}

	SetTrigger(triggerSettings.type+triggerSettings.edge,0,triggerSettings.channel,
			triggerSettings.prefetch ,triggerSettings.level - triggerSettings.schmitt, triggerSettings.pulse,
			triggerSettings.level + triggerSettings.schmitt, triggerSettings.pulse);
}

/** Changes Trigger Type
 *
 * @param selection  Trigger Type
 *
 * selection = 0: Normal Trigger
 * selection = 1: Glitch Trigger
 * selection = 2: External Trigger
 */

void changeTriggerType(uint32_t selection)
{
	switch(selection)
	{
		case 0: triggerSettings.type = NORMAL_TRIGGER; break;
		case 1: triggerSettings.type = GLITCH_TRIGGER; break;
		case 2: triggerSettings.type = EXTERNAL_TRIGGER; break;
		default: break;
	}

	SetTrigger(triggerSettings.type+triggerSettings.edge,0,triggerSettings.channel,
			triggerSettings.prefetch ,triggerSettings.level - triggerSettings.schmitt, triggerSettings.pulse,
			triggerSettings.level + triggerSettings.schmitt, triggerSettings.pulse);
}

/** Changes Trigger Channel
 *
 * @param selection  Trigger Channel
 *
 * selection = 0: CH0
 * selection = 1: CH1
 */

void changeTriggerChannel(uint32_t selection)
{
	clearTriggerMark();
	switch(selection)
	{
		case CH0: triggerSettings.channel = CH0; break;
		case CH1: triggerSettings.channel = CH1; break;
		default: break;
	}

	SetTrigger(triggerSettings.type+triggerSettings.edge,0,triggerSettings.channel,
			triggerSettings.prefetch ,triggerSettings.level - triggerSettings.schmitt, triggerSettings.pulse,
			triggerSettings.level + triggerSettings.schmitt, triggerSettings.pulse);

	LoadBitmap(triggerarrow_glcd_bmp, 1 , -triggerSettings.level+Offset[triggerSettings.channel].V, TRIGGERARROW_GLCD_WIDTH, TRIGGERARROW_GLCD_HEIGHT, BG_COLOR, signalcolors[triggerSettings.channel]);


}

/*
 * Clears the symbol for the actual trigger level.
 */
void clearTriggerMark(void)
{
	LoadBitmap(triggerarrow_glcd_bmp, 1 , -triggerSettings.level+Offset[triggerSettings.channel].V, TRIGGERARROW_GLCD_WIDTH, TRIGGERARROW_GLCD_HEIGHT, BG_COLOR, BG_COLOR);
}

/*
 * This function changes the trigger level of the selected channel.
 * It also draws the arrow signaling the trigger level.
 */
void changeTriggerLevel(int32_t diff)
{
	if(channel[triggerSettings.channel].state == CHANNEL_OFF)
		return;

	clearTriggerMark();

	triggerSettings.level += diff;
	if (triggerSettings.level > 127) triggerSettings.level = 127;
	if (triggerSettings.level < -127) triggerSettings.level = -127;

	LoadBitmap(triggerarrow_glcd_bmp, 1 , -triggerSettings.level+Offset[triggerSettings.channel].V, TRIGGERARROW_GLCD_WIDTH, TRIGGERARROW_GLCD_HEIGHT, BG_COLOR, signalcolors[triggerSettings.channel]);

	SetTrigger(triggerSettings.type+triggerSettings.edge,0,triggerSettings.channel,
			triggerSettings.prefetch ,triggerSettings.level - triggerSettings.schmitt, triggerSettings.pulse,
			triggerSettings.level + triggerSettings.schmitt, triggerSettings.pulse);

}

	/* Some timebases are disabled, they might not work with all filter settings
         * AACFilterStart <= 1 and AACFilterStop >= 1! (not a bug) */ 
	const uint32_t timebase[] = {
		10000, /*12500,*/ 25000, /*31250,*/ 50000, /*62500,*/
		100000, /*125000,*/ 250000, /*312500,*/ 500000, /*625000,*/ // 100ks/s - 500ks/s
		1000000, /*1250000,*/ 2500000, /*3125000,*/ 5000000, /*6250000,*/ // 1Ms/s - 5Ms/s
		10000000, /*15000000,*/ 25000000, /*31250000,*/ 50000000, /*62500000,*/ // 10Ms/s - 50Ms/s
		100000000, 125000000, 250000000, 500000000, // 100Ms/s - 500Ms/s
		1000000000}; // 1Gs/s

	char *timebase_str[] = {
		"10 kS/s", /*"12.5 kS/s",*/ "25 kS/s", /*"31.25 kS/s",*/ "50 kS/s", /*"62.5 kS/s",*/
		"100 kS/s", /*"125 kS/s",*/ "250 kS/s", /*"312.5 kS/s",*/ "500 kS/s", /*"625 kS/s",*/
		"1 MS/s", /*"1.25 MS/s",*/ "2.5 MS/s", /*"3.125 MS/s",*/ "5 MS/s", /*"6.25 MS/s",*/
		"10 MS/s", /*"12.5 MS/s",*/ "25 MS/s", /*"31.25 MS/s",*/ "50 MS/s", /*"62.5 MS/s",*/
		"100 MS/s", "125 MS/s", "250 MS/s", "500 MS/s",
		"1 GS/s"};

	static int32_t selectedTimebase = 0;


/*
 * This function changes the timebase. It also updates the titlebar.
 */

static int AACFilterStop = 0;

void setTimebase(int32_t diff)
{
	/* Some timebases are disabled, they might not work with all filter settings
         * AACFilterStart <= 1 and AACFilterStop >= 1! (not a bug) */ 
	const uint32_t timebase[] = {
		10000, /*12500,*/ 25000, /*31250,*/ 50000, /*62500,*/
		100000, /*125000,*/ 250000, /*312500,*/ 500000, /*625000,*/ // 100ks/s - 500ks/s
		1000000, /*1250000,*/ 2500000, /*3125000,*/ 5000000, /*6250000,*/ // 1Ms/s - 5Ms/s
		10000000, /*15000000,*/ 25000000, /*31250000,*/ 50000000, /*62500000,*/ // 10Ms/s - 50Ms/s
		100000000, 125000000, 250000000, 500000000, // 100Ms/s - 500Ms/s
		1000000000}; // 1Gs/s

	char *timebase_str[] = {
		"10 kS/s", /*"12.5 kS/s",*/ "25 kS/s", /*"31.25 kS/s",*/ "50 kS/s", /*"62.5 kS/s",*/
		"100 kS/s", /*"125 kS/s",*/ "250 kS/s", /*"312.5 kS/s",*/ "500 kS/s", /*"625 kS/s",*/
		"1 MS/s", /*"1.25 MS/s",*/ "2.5 MS/s", /*"3.125 MS/s",*/ "5 MS/s", /*"6.25 MS/s",*/
		"10 MS/s", /*"12.5 MS/s",*/ "25 MS/s", /*"31.25 MS/s",*/ "50 MS/s", /*"62.5 MS/s",*/
		"100 MS/s", "125 MS/s", "250 MS/s", "500 MS/s",
		"1 GS/s"};

	static int32_t selectedTimebase = 0;

	selectedTimebase += diff;

	if(selectedTimebase < 0)
	{
		selectedTimebase = 0;
	}
	else if(selectedTimebase >= sizeof(timebase)/sizeof(timebase[0]))
	{
		selectedTimebase = sizeof(timebase)/sizeof(timebase[0])-1;
	}

	updateTitleBar(TIMEBASE, timebase_str[selectedTimebase]);
	SetTriggerInput(4,8,timebase[(uint32_t)selectedTimebase],FIXED_CPU_FREQUENCY,0,AACFilterStop,0,1,2,3);
}

void changeHWFilters(int32_t x){
	AACFilterStop = x;
	setTimebase(0);
}


void setAnalogOffset(uint32_t ch, int32_t diff)
{
	channel[ch].analog.DA_Offset += diff;
	//SetDACOffset(ch, Analog[ch].DA_Offset); //Doesn't work yet
}

/*
 * This function changes the voltage per div of the selected channel.
 * The titlebar will also be changed.
 */
void setVoltagePerDiv(uint32_t ch, int32_t diff)
{
	channel[ch].selectedVoltagePerDiv += diff;

	if(channel[ch].selectedVoltagePerDiv < 0)
	{
		channel[ch].selectedVoltagePerDiv = 0;
	}
	else if(channel[ch].selectedVoltagePerDiv >= (sizeof(voltagePerDiv)/sizeof(voltagePerDiv[0])))
	{
		channel[ch].selectedVoltagePerDiv = sizeof(voltagePerDiv)/sizeof(voltagePerDiv[0])-1;
	}

	updateTitleBar(ch==0?VOLTAGE_CH0:VOLTAGE_CH1, voltagePerDiv_str[(uint8_t)channel[ch].selectedVoltagePerDiv]);
	channel[ch].analog.myVperDiv = voltagePerDiv[(uint32_t)channel[ch].selectedVoltagePerDiv];
	SetAnalogInputRange(ch, &channel[ch].analog);
}

#define FRAMESIZE 600
#define FRAMEPOS_HEIGHT 8
#define FRAMEPOS_RES    518
#define FRAMEPOS_VSTART 32
#define FRAMEPOS_HSTART 64
int32_t Zoom = 1; 
uint32_t Captured = 32786;

void DrawFramePos(uint16_t Color, uint32_t ViewedStart, uint32_t ViewedStop){
	static int32_t Start = 320 + (FRAMESIZE/2); 
	static int32_t Stop  = 320 - (FRAMESIZE/2);
	DrawVLineClipped(BG_COLOR,Start+FRAMEPOS_HSTART,FRAMEPOS_VSTART, FRAMEPOS_VSTART + FRAMEPOS_HEIGHT);
	DrawVLineClipped(BG_COLOR,Stop+FRAMEPOS_HSTART, FRAMEPOS_VSTART, FRAMEPOS_VSTART + FRAMEPOS_HEIGHT);
	Start = ViewedStart;
	Stop = ViewedStop;
	DrawVLineClipped(Color,Start+FRAMEPOS_HSTART,FRAMEPOS_VSTART, FRAMEPOS_VSTART + FRAMEPOS_HEIGHT);
	DrawVLineClipped(Color,Stop+FRAMEPOS_HSTART, FRAMEPOS_VSTART, FRAMEPOS_VSTART + FRAMEPOS_HEIGHT);
	DrawVLineClipped(Color, FRAMEPOS_HSTART, FRAMEPOS_VSTART, FRAMEPOS_VSTART + FRAMEPOS_HEIGHT);
	DrawVLineClipped(Color, FRAMEPOS_HSTART + FRAMEPOS_RES, FRAMEPOS_VSTART, FRAMEPOS_VSTART + FRAMEPOS_HEIGHT);
	DrawHLine(Color, FRAMEPOS_VSTART                  , FRAMEPOS_HSTART, FRAMEPOS_HSTART + FRAMEPOS_RES);
	DrawHLine(Color, FRAMEPOS_VSTART + FRAMEPOS_HEIGHT, FRAMEPOS_HSTART, FRAMEPOS_HSTART + FRAMEPOS_RES);

}
 
void setFramePosition(uint32_t diff){
/* Zoom = 0 ... error
 * Zoom > 1 ... Timerange multiplied by Zoom
 * Zoom < 1 ... Timerange divided   by -Zoom
*/
	int32_t ViewedOffset = 0;
	int32_t ViewedStart = 0; 
	int32_t ViewedStop  = 0; 
	if (((1 << BTN_MAINDEL) & READ_INT(KEYADDR1)) != 0){
		Zoom = 1; // Zoom is now only used for a faster navigation
	} else {
		Zoom = 40;
	} 
	triggerSettings.prefetch += diff*Zoom;
	if (triggerSettings.prefetch < (8+(FRAMESIZE/2))) {
		triggerSettings.prefetch = (8+(FRAMESIZE/2));
	}
	if (triggerSettings.prefetch > (Captured - (FRAMESIZE/2))) {
		triggerSettings.prefetch = Captured - (FRAMESIZE/2);	
	}

	Offset[0].H = triggerSettings.prefetch - (FRAMESIZE/2); 
	Offset[1].H = Offset[0].H;

	ViewedOffset = Captured/(FRAMESIZE/2);
	ViewedStart = ((FRAMEPOS_RES)*Offset[0].H)/Captured;
	ViewedStop  = ((FRAMEPOS_RES)*Offset[0].H)/Captured + ViewedOffset;
	DrawFramePos(COLOR_R3G3B3(3,2,2), ViewedStart, ViewedStop);

	/* The hardware trigger does only support the non roll mode prefetch size */
	if (triggerSettings.prefetch > (CAPTURESIZE - (FRAMESIZE/2))) {
		triggerSettings.prefetch = CAPTURESIZE - (FRAMESIZE/2);	
	}

}

void GUI_Main(void)
{
	generategrid();

	uSample Ch1[2][HLEN+100];
	uSample Ch2[2][HLEN+100];
	uint32_t PrevBuffer = 0;
	uint32_t CurrBuffer = 1;
	uint32_t ReadData = 0;
	uint32_t Run = TRUE;
	uint32_t Single = FALSE;
	int16_t x = 0;

	channel[0].analog.myVperDiv = 5000000;
	channel[0].analog.AC = 0;
	channel[0].analog.Mode = normal;
	//	Analog[0].DA_Offset = 16384;
	channel[0].analog.DA_Offset = 0;
	channel[0].analog.BW_Limit = 0;

	channel[1].analog.myVperDiv = 5000000;
	channel[1].analog.AC = 0;
	channel[1].analog.Mode = normal;
	//	Analog[1].DA_Offset = 16384;
	channel[1].analog.DA_Offset = 0;
	channel[1].analog.BW_Limit = 0;

	Offset[0].V = 128;
	Offset[1].V = VLEN-128;
	for (x = 0; x < 2; ++x)
	{
		Offset[x].H = 8;
	}

	channel[0].state = CHANNEL_OFF;
	channel[0].selectedVoltagePerDiv = 0;

	channel[1].state = CHANNEL_OFF;
	channel[1].selectedVoltagePerDiv = 0;

	memset(&Ch1[0],0,HLEN*sizeof(uSample));
	memset(&Ch2[0],0,HLEN*sizeof(uSample));
	memset(&Ch1[1],0,HLEN*sizeof(uSample));
	memset(&Ch2[1],0,HLEN*sizeof(uSample));

	DrawBox(BG_COLOR,0,0,HLEN-1,VLEN-1); //Draw ba	lck background
	drawGrid();						     //Draws
	/*
	 * Init Encoder
	 * Doesn't work right for now
	 */
	int32_t tmp = 0;
	int32_t tmp2 = 0;

	read_encoders();

/*	for(uint8_t i=0; i<100; i++)
	{*/
	/*
	* The hardware encoder counters do not have an initial value,
        * so the first access of the get_encoder_diff does return a wrong result!
        * (This is not at all a bug!) 
	*/
		get_encoder_diff(&encoder_changed0, &encoder_state0, &tmp2, &tmp);
/*	}
	for(uint8_t i=0; i<100; i++)
	{*/
		get_encoder_diff(&encoder_changed1, &encoder_state1, &tmp2, &tmp);
/*	}*/

	WRITE_INT(LEDADDR,0); //Clear leds

	titleBarInit();

	/* Set timbase and voltage per div
	 * Also updates titlebar.
	 */
	setTimebase(0);
	setVoltagePerDiv(CH0,0);
	setVoltagePerDiv(CH1,0);

	updateMenu(&men_ch[0]); //Activate menu for channel 0
	SET_LED(RUN_GREEN);
	/*
	 * Main loop
	 */
	while(1)
	{
		readkeys();
		buttonHandler();

		read_encoders();
		encoder_handler();

		closeSubMenuTime();

		if ((READ_INT(KEYADDR1) & (1 << BTN_F1)) != 0)
		{
			WRITE_INT(CONFIGADCENABLE,1); // Set back to debug uart
		}
		if ((READ_INT(KEYADDR1) & (1 << BTN_F2)) != 0)
		{
			//		WRITE_INT(CONFIGADCENABLE,0); // Set back to generic uart
		}
		
		if ((READ_INT(KEYADDR1) & (1 << BTN_RUNSTOP)) != 0)
		{
			Run^= TRUE; // Toogle Run Stop	for TRUE = 1 or TRUE = -1
			CLR_LED(SINGLE_GREEN);
			CLR_LED(SINGLE_RED);

			if (Run == TRUE){
				SET_LED(RUN_GREEN);
				CLR_LED(RUN_RED);
			} else {
				SET_LED(RUN_RED);
				CLR_LED(RUN_GREEN);
			}
			WaitMs(100);
		}
		if ((READ_INT(KEYADDR1) & (1 << BTN_SINGLE)) != 0)
		{
			Run    = TRUE; 
			Single = TRUE;	
			SET_LED(SINGLE_GREEN);
			CLR_LED(SINGLE_RED);
			CLR_LED(RUN_GREEN);
			CLR_LED(RUN_RED);

		}

		if (Run == TRUE)
		{
			ReadData = CaptureData(1000, true, true, 32768, (uint32_t*)Data);
		}
/*		else
		{
			ReadData = 0;
		}*/

		if ((ReadData >= (FRAMESIZE+triggerSettings.prefetch)) || (Run == FALSE) )
		{
			if (Single == TRUE) {
				Run = FALSE;
				Single = FALSE;
				SET_LED(SINGLE_RED);
				CLR_LED(SINGLE_GREEN);

			}

			Captured = ReadData;
			if (CurrBuffer != 0)
			{
				CurrBuffer = 0;
				PrevBuffer = 1;
				//	DrawBox(x,0,470,9,479);
			}
			else
			{
				CurrBuffer = 1;
				PrevBuffer = 0;
				//	DrawBox(x,30,470,39,479);
			}

			if(channel[0].state == CHANNEL_ON)
			{
				GetCh(0,8, &Ch1[CurrBuffer][0],&Data[Offset[0].H], HLEN+100);
				DrawSignal(Offset[0].V,&Ch1[PrevBuffer][0], &Ch1[CurrBuffer][0],COLOR_R3G3B3(0,0,0), signalcolors[0]);
			}

			if(channel[1].state == CHANNEL_ON)
			{
				GetCh(1,8, &Ch2[CurrBuffer][0],&Data[Offset[1].H], HLEN+100);
				DrawSignal(Offset[1].V,&Ch2[PrevBuffer][0], &Ch2[CurrBuffer][0],COLOR_R3G3B3(0,0,0), signalcolors[1]);

			}
		}
	}
}


#endif

