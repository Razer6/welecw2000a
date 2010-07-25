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
#include "DSO_Remote.h"
#include "DSO_FrontPanel.h"

#include "GUI.h"
#include "symbols.h"

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
		uint32_t srcSamples,
		sHWFilterGain AnalogGain,
		sHWFilterGain FilterGain)
{

	register uint32_t i = 0;
	register int32_t data = 0;
	sHWFilterGain Gain;
	Gain.num = -AnalogGain.num * FilterGain.num;
	Gain.den =  AnalogGain.den * FilterGain.den;
	switch (size)
	{
		case 8:
		for (; i < srcSamples; ++i)
		{
			data = (int32_t)src[i].c[ch];
			dst[i].i = (data*Gain.num)/Gain.den;
		}
		break;
		case 16:
		Gain.den *= 256;
		for (; i < srcSamples; ++i)
		{	                  
			data =  src[i].c[ch+2] & 0xff; // must be unsigned!!!
			data |= (int32_t)((src[i].c[ch] << 8));
			dst[i].i = (data*Gain.num)/Gain.den;
		}
		break;
		default:
		for (; i < srcSamples; ++i)
		{
			dst[i].i = src[i].i;
		}
		break;
	}
}

extern uSample Data[CAPTURESIZE];

static DispOffset Offset[2];

typedef struct {
	uint32_t analog;
	sHWFilterGain Gain;
	const char str[12];
} sVoltagePerDiv;

/*
 * All settings which are associated to a channel
 */
typedef struct ChannelSettings
{
	uint32_t state; 				//On=1, Off=0
	uint32_t BitMode;
	int32_t selectedVoltagePerDiv; 			//Index for Table voltagePerDiv
	SetAnalog analog;				//Analog Settings
}
sChannelSettings;

/*
 * Channel Settings for all channels
 */
sChannelSettings channel[2];



/**
 * Default Trigger Settings
 */

sTriggerSettings triggerSettings =
{
	.type = EXTERNAL_TRIGGER,
	.edge = 0,
	.channel = 0,
	.level = 0,
	.prefetch = 64,
	.schmitt = 2,
	.pulse = 1
};

void clearTriggerMark(void);

void changeTriggerEdge(int32_t selection);
void changeTriggerType(int32_t selection);
void changeTriggerChannel(int32_t selection);
void changeTriggerLevel(int32_t diff);
void setFramePosition(int32_t diff);
void changeCouplingCh0(int32_t selection);
void changeCouplingCh1(int32_t selection);
void toggleBWLimitCh0(int32_t selection);
void toggleBWLimitCh1(int32_t selection);
void changeHWFilters(int32_t x);
void onChannel0(void);
void onChannel1(void);
void change_uart(int32_t selection);
void screenshot_color_bmp(void);
void screenshot_sw_bmp(void);
void screenshot_color_ppm(void);
void screenshot_sw_pbm(void);


/*
 * Submenu items for menu for channel 0 and channel 1
 */
sCheckBox cbBwLimitCh0 = {"BW Limit", DEFAULT_BOUNDS_F2, 0, toggleBWLimitCh0};
sCheckBox cbBwLimitCh1 = {"BW Limit", DEFAULT_BOUNDS_F2, 0, toggleBWLimitCh1};
/*sCheckBox cbInvertCh0 = {"Invert", DEFAULT_BOUNDS_F3, 0, NULL};
sCheckBox cbInvertCh1 = {"Invert", DEFAULT_BOUNDS_F3, 0, NULL};*/
sSubMenuList smlHWFilter = {"HW-Filters", DEFAULT_BOUNDS_F3, {213, SML_START_POS_Y(4), 103, SML_HEIGHT(5)}, 5, 0, changeHWFilters, 
{"None", "1G>100M", "1G>10MS", "1G>1MS", "1G>100k"}};

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
 * Buttons for Quick Print menu 
 */

sButton btScrShotColorBMP = {"Color BMP", DEFAULT_BOUNDS_F1, screenshot_color_bmp};
sButton btScrShotSwBMP= {"S/W BMP", DEFAULT_BOUNDS_F2, screenshot_sw_bmp};
sButton btScrShotColorPPM = {"Color PPM", DEFAULT_BOUNDS_F3, screenshot_color_ppm};
sButton btScrShotSwPBM= {"S/W PBM", DEFAULT_BOUNDS_F4, screenshot_sw_pbm};

sSubMenu smScrShotColorBMP = {BUTTON, &btScrShotColorBMP}; 
sSubMenu smScrShotSwBMP= {BUTTON, &btScrShotSwBMP}; 
sSubMenu smScrShotColorPPM = {BUTTON, &btScrShotColorPPM}; 
sSubMenu smScrShotSwPBM = {BUTTON, &btScrShotSwPBM}; 
/*
 * Quck Print menu 
 */
sMenu menQuickPrint = {{&smScrShotColorBMP, &smScrShotSwBMP, &smScrShotColorPPM, &smScrShotSwPBM , NULL, NULL}, NULL};

/* 
 * Menu Items for utility menu 
 */
sSubMenuList smlUartSelection = {"UART", DEFAULT_BOUNDS_F1, {0, SML_START_POS_Y(2), 103, SML_HEIGHT(2)}, 2, 0, change_uart, {"LEON", "FPGA"}};
sSubMenu smUartSelection = {SUBMENU_LIST, &smlUartSelection};
/*
 * Uitilty menu 
 */
sMenu menUtility = {{&smUartSelection, NULL, NULL, NULL, NULL, NULL}, NULL};

/** Changes Coupling of Channel 0
 *
 * @param selection  Trigger Type
 *
 * selection = 0: AC Coupling
 * selection = 1: DC Coupling
 */
void changeCouplingCh0(int32_t selection)
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

void changeCouplingCh1(int32_t selection)
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

void toggleBWLimitCh0(int32_t selection)
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

void toggleBWLimitCh1(int32_t selection)
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

void changeTriggerEdge(int32_t selection)
{
	switch(selection)
	{
		case 0: 
			triggerSettings.edge = 0; 		//Rising Edge
			LoadBitmap(&sym_fallingEdge, TRIGGERLEVEL, TITLE_BAR_START_Y+2, TITLE_BAR_COLOR_BG);	//Clear other symbol
			LoadBitmap(&sym_risingEdge, TRIGGERLEVEL, TITLE_BAR_START_Y+2, TITLE_BAR_COLOR_FG);
		break; 
		case 1: 
			triggerSettings.edge = 1; 		//Falling Edge
			LoadBitmap(&sym_risingEdge, TRIGGERLEVEL, TITLE_BAR_START_Y+2, TITLE_BAR_COLOR_BG);		//Clear other symbol
			LoadBitmap(&sym_fallingEdge, TRIGGERLEVEL, TITLE_BAR_START_Y+2, TITLE_BAR_COLOR_FG);
		break; 
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

void changeTriggerType(int32_t selection)
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

void changeTriggerChannel(int32_t selection)
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

	LoadBitmap(&sym_triggerMark, 1 , -triggerSettings.level+Offset[triggerSettings.channel].V, signalcolors[triggerSettings.channel]);
}

/*
 * Clears the symbol for the actual trigger level.
 */
void clearTriggerMark(void)
{
	LoadBitmap(&sym_triggerMark, 1 , -triggerSettings.level+Offset[triggerSettings.channel].V, BG_COLOR);
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

	LoadBitmap(&sym_triggerMark, 1 , -triggerSettings.level+Offset[triggerSettings.channel].V, signalcolors[triggerSettings.channel]);
	
	SetTrigger(triggerSettings.type+triggerSettings.edge,0,triggerSettings.channel,
			triggerSettings.prefetch ,triggerSettings.level - triggerSettings.schmitt, triggerSettings.pulse,
			triggerSettings.level + triggerSettings.schmitt, triggerSettings.pulse);

}

typedef struct 
{
	uint32_t Timebase;
	uint32_t AllowedByFilter;
	char const str[12];
} sTimebase;

sTimebase Timebase[] ={
{	     10000,  TRUE, {"   10 kS/s"}},
{	     12500, FALSE, {" 12.5 kS/s"}},
{	     25000,  TRUE, {"   25 kS/s"}}, 
{	     31250, FALSE, {"31.25 kS/s"}},
{	     50000,  TRUE, {"   50 kS/s"}}, 
{	     62500, FALSE, {" 62.5 kS/s"}},
{	    100000,  TRUE, {"  100 kS/s"}},
{	    125000, FALSE, {"  125 kS/s"}},
{	    250000,  TRUE, {"  250 kS/s"}}, 
{	    312500, FALSE, {"312.5 kS/s"}}, 
{	    500000,  TRUE, {"  500 kS/s"}}, 
{	    625000, FALSE, {"  625 kS/s"}}, 
{	   1000000,  TRUE, {"    1 MS/s"}}, 
{	   1250000, FALSE, {" 1.25 MS/s"}},
{	   2500000,  TRUE, {"  2.5 MS/s"}}, 
{	   3125000, FALSE, {"3.125 MS/s"}},
{	   5000000,  TRUE, {"    5 MS/s"}}, 
{	   6250000, FALSE, {" 6.25 MS/s"}},
{	  10000000,  TRUE, {"   10 MS/s"}},
{	  12500000, FALSE, {" 12.5 MS/s"}},
{	  25000000,  TRUE, {"   25 MS/s"}}, 
{	  31250000, FALSE, {"31.25 MS/s"}},
{	  50000000,  TRUE, {"   50 MS/s"}}, 
{	  62500000, FALSE, {" 62.5 MS/s"}},
{	 100000000,  TRUE, {"  100 MS/s"}}, 
{	 125000000,  TRUE, {"  125 MS/s"}}, 
{	 250000000,  TRUE, {"  250 MS/s"}}, 
{	 500000000,  TRUE, {"  500 MS/s"}}, 
{	1000000000,  TRUE, {"    1 GS/s"}}};


static int32_t selectedTimebase = 0;

// TODO Correct this after the hw filter change for 10 MS/s -> 1 MS/s and lower 
#define NUMF 2
#define DENF 1
const sHWFilterGain HWFilterGain[] = {
{  1,  1}, {  1,  1}, {  1,  1},   {1,  1}, // 1GS    -> 100 MS
{  1,  1}, {  1,  1}, {  1,  1},   {1,  1}, // 100 MS ->  10 MS
{  1,  1}, {  1,  1}, {NUMF,DENF}, {NUMF,DENF}};// 10 MS  ->   1 MS


typedef struct {
	uint32_t      Stop;
	sHWFilterGain Gain;
} sHWFilters;

static sHWFilters HWFilters = {0,{1,1}};

/*
 * This function changes the timebase. It also updates the titlebar and the filter regain.
 */

void setTimebase(int32_t diff)
{
	uint32_t decimation_stages = 0; // hw filter regain

	selectedTimebase += diff;
	if ((HWFilters.Stop > 1) || (Timebase[selectedTimebase].AllowedByFilter == FALSE))
	{
		selectedTimebase += diff;
	}

	if(selectedTimebase < 0)
	{
		selectedTimebase = 0;
	}
	else if((uint32_t)selectedTimebase >= sizeof(Timebase)/sizeof(Timebase[0]))
	{
		selectedTimebase = sizeof(Timebase)/sizeof(Timebase[0])-1;
	}
	HWFilters.Gain = HWFilterGain[0];

	decimation_stages = 0;
   	if (Timebase[selectedTimebase].Timebase < 10000000) 
	{
		decimation_stages = 2;			
	}
	else if (Timebase[selectedTimebase].Timebase < 100000000) 
	{
		decimation_stages = 1;			
	}
	HWFilters.Gain = HWFilterGain[(decimation_stages*4)+HWFilters.Stop];

	updateTitleBar(TIMEBASE, &Timebase[selectedTimebase].str[0]);
	SetTriggerInput(2,channel[0].BitMode,Timebase[selectedTimebase].Timebase,FIXED_CPU_FREQUENCY,0,HWFilters.Stop,0,1,2,3);
}

void changeHWFilters(int32_t x)
{
	HWFilters.Stop = x;
	if (HWFilters.Stop > 3) 
	{
		HWFilters.Stop = 3;
	}
	setTimebase(0);
}


void setAnalogOffset(uint32_t ch, int32_t diff)
{
	channel[ch].analog.DA_Offset += diff;
	//SetDACOffset(ch, Analog[ch].DA_Offset); //Doesn't work yet
}

/*
 * Selectable Voltage per div for Analog settings
 * TODO: correct num and den voltage range scaler
 */

const sVoltagePerDiv VoltagePerDiv[] = {
{5000000,{   1,1},"   5V/div"},
{2000000,{   1,1},"   2V/div"},
{1000000,{   1,1},"   1V/div"},
{ 500000,{   1,1},"500mV/div"},
{ 200000,{   1,1},"200mV/div"},
{ 100000,{   1,1},"100mV/div"},
{  50000,{   1,1}," 50mV/div"},
{  20000,{   1,1}," 20mV/div"},
{  10000,{   1,1}," 10mV/div"},
{  10000,{   2,1},"  5mV/div"},
{  10000,{   4,1},"  2mV/div"},
{  10000,{  10,1},"  1mV/div"},
{  10000,{  20,1},"500uV/div"},
{  10000,{  40,1},"200uV/div"},
{  10000,{ 100,1},"100uV/div"},
{  10000,{ 200,1}," 50uV/div"},
{  10000,{ 400,1}," 20uV/div"},
{  10000,{1000,1}," 10uV/div"}};

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
	else if((uint32_t)channel[ch].selectedVoltagePerDiv >= (sizeof(VoltagePerDiv)/sizeof(VoltagePerDiv[0])))
	{
		channel[ch].selectedVoltagePerDiv = sizeof(VoltagePerDiv)/sizeof(VoltagePerDiv[0])-1;
	}

	updateTitleBar(ch==0?VOLTAGE_CH0:VOLTAGE_CH1, 
		&VoltagePerDiv[(uint8_t)channel[ch].selectedVoltagePerDiv].str[0]);
	channel[ch].analog.myVperDiv = VoltagePerDiv[(uint32_t)channel[ch].selectedVoltagePerDiv].analog;
	SetAnalogInputRange(ch, &channel[ch].analog);
}

/* Wrapper functions for encoder handlers */

void set_vdiv_ch0 (int32_t diff)
{
	setVoltagePerDiv(CH0, diff);
}
void set_vdiv_ch1 (int32_t diff)
{
	setVoltagePerDiv(CH1, diff);
}

#define FRAMESIZE 600
#define FRAMEPOS_HEIGHT 8
#define FRAMEPOS_RES    518
#define FRAMEPOS_VSTART 32
#define FRAMEPOS_HSTART 64
int32_t Zoom = 1; 
uint32_t Captured = 32786;

void DrawFramePos(uint16_t Color, uint32_t ViewedStart, uint32_t ViewedStop)
{
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
 
void setFramePosition(int32_t diff)
{
/* Zoom = 0 ... error
 * Zoom > 1 ... Timerange multiplied by Zoom
 * Zoom < 1 ... Timerange divided   by -Zoom
*/
	int32_t ViewedOffset = 0;
	int32_t ViewedStart = 0; 
	int32_t ViewedStop  = 0; 
	if (((1 << BTN_MAINDEL) & READ_INT(KEYADDR1)) != 0)
	{
		Zoom = 1; // Zoom is now only used for a faster navigation
	} 
	else 
	{
		Zoom = 40;
	} 
	triggerSettings.prefetch += diff*Zoom;
	if (triggerSettings.prefetch < (8+(FRAMESIZE/2))) 
	{
		triggerSettings.prefetch = (8+(FRAMESIZE/2));
	}
	if ((uint32_t)triggerSettings.prefetch > (Captured - (FRAMESIZE/2))) 
	{
		triggerSettings.prefetch = Captured - (FRAMESIZE/2);	
	}

	Offset[0].H = triggerSettings.prefetch - (FRAMESIZE/2); 
	Offset[1].H = Offset[0].H;

	ViewedOffset = Captured/(FRAMESIZE/2);
	ViewedStart = ((FRAMEPOS_RES)*Offset[0].H)/Captured;
	ViewedStop  = ((FRAMEPOS_RES)*Offset[0].H)/Captured + ViewedOffset;
	DrawFramePos(COLOR_R3G3B3(3,2,2), ViewedStart, ViewedStop);

	/* The hardware trigger does only support the non roll mode prefetch size */
	if (triggerSettings.prefetch > (CAPTURESIZE - (FRAMESIZE/2))) 
	{
		triggerSettings.prefetch = CAPTURESIZE - (FRAMESIZE/2);	
	}
}

void writeword(unsigned pix,char llength)		//3 Byte auf UART schreiben
{
	SendCharBlock((uart_regs *)GENERIC_UART_BASE_ADDR,  pix>>8);    	//Farbe MSB
	SendCharBlock((uart_regs *)GENERIC_UART_BASE_ADDR, pix);       	//Farbe LSB
	SendCharBlock((uart_regs *)GENERIC_UART_BASE_ADDR, llength);	//Laufl�nge
}

void rle_enc(uint16_t pixel, uint32_t init) //44922 Byte = 4,6s
{
	static uint32_t llength;				//Anzahl gleicher Pixel hintereinander
	static uint32_t lastpixel;			//Das zuletzt gepr�fte Pixel
	const uint32_t maxlen = 254;		//Maximale Anzahl gleicher Pixel hintereinander

	if (init == 1)					//Bei neuem Screenshot
	{
		llength=0;
		lastpixel=1;					//Laufl�nge auf 0,
		return;					//lastbyte=1 -> Farbe mit dem Wert 1 existiert nicht
	}

	if ((pixel==lastpixel) && (init != 2))	//Wenn Pixel die selbe Farbe wie vorher hat
	{
		llength++;							//L�ufl�nge erh�hen
		if (llength>=maxlen)				//Wenn maximall�nge erreicht ist
		{
			writeword(pixel,llength);		//Pixel und Anzahl ausgeben
			llength=0;						//Laufl�nge wieder auf 0
			lastpixel=1;					//Letztes Pixel auf ung�ltigen Wert setzen
		}
	}

	else	//pixel!=lastpixel
	{
		if (llength > 0)					//Wenn noch Laufl�nge von altem Pixel vorhanden
		{
			writeword(lastpixel,llength);	//Altes Pixel und Laufl�nge ausgeben
		}
		lastpixel=pixel;					//Letzes Pixel = aktuelles Pixel
		llength=1;							//Mindestens 1 Pixel
	}
}

void make_shot(unsigned char type)
{
	SendCharBlock((uart_regs *)GENERIC_UART_BASE_ADDR, 'S');			//"Jetzt kommt
	SendCharBlock((uart_regs *)GENERIC_UART_BASE_ADDR, 0xFF);			//ein Screenshot"
	SendCharBlock((uart_regs *)GENERIC_UART_BASE_ADDR, type);			//Dumptype (PPM, BMP, PBM, CSV...)

	rle_enc(0,1);			//RLE initialisieren
	for(uint32_t i=0; i<HLEN*VLEN; i++)			//F�r jeden Pixel:
	{
		rle_enc(Framebuffer[i], 0);						//Pixel in RLE schicken
	}
	
	rle_enc(0,2);					//RLE beenden
	SendCharBlock((uart_regs *)GENERIC_UART_BASE_ADDR, 0x73);			//Stopp Kennung
	SendCharBlock((uart_regs *)GENERIC_UART_BASE_ADDR, 0xaa);			//Muss evtl ge�ndert werden

}

void screenshot_color_bmp(void)
{
	make_shot(1);
}

void screenshot_sw_bmp(void)
{
	make_shot(2);
}

void screenshot_color_ppm(void)
{
	make_shot(0);
}

void screenshot_sw_pbm(void)
{
	make_shot(3);
}


/** Changes Uart Selection
 *
 * @param selection  UART Channel
 *
 * selection = 0: UART going to LEON
 * selection = 1: UART going to  FPGA
 */

void change_uart(int32_t selection)
{
	switch(selection)
	{
		case 0: WRITE_INT(CONFIGADCENABLE,0);  break; // Set to generic uart
		case 1: WRITE_INT(CONFIGADCENABLE,1);  break; // Set to debug uart
		default: break;
	}
}

void add_dac0_offset(int32_t diff){
	AddDACOffset(0,diff);
}
void add_dac1_offset(int32_t diff){
	AddDACOffset(1,diff);
}

/*
  * Init buttons. Add for every button a button handler
  */
void init_buttons(void)
{
	/* Button handlers for submenus, Argument is index of array for submenu */
	init_bt_handler(&bt_handler_f1, onSubMenu, (void*)0);	
	init_bt_handler(&bt_handler_f2, onSubMenu, (void*)1);
	init_bt_handler(&bt_handler_f3, onSubMenu, (void*)2);
	init_bt_handler(&bt_handler_f4, onSubMenu, (void*)3);
	init_bt_handler(&bt_handler_f5, onSubMenu, (void*)4);
	init_bt_handler(&bt_handler_f6, onSubMenu, (void*)5);
	
	/* Button handlers for channels */
	init_bt_handler(&bt_handler_ch0, updateMenu, &men_ch[0]);
	init_bt_handler(&bt_handler_ch1, updateMenu, &men_ch[1]);
	
	/* Button handlers for other menus */
	init_bt_handler(&bt_handler_modecoupling, updateMenu, &menTriggerTypes);
	init_bt_handler(&bt_handler_utility, updateMenu, &menUtility);
	init_bt_handler(&bt_handler_quickprint, updateMenu, &menQuickPrint);
}


/*
  * Init encoders. Add for every encoder an encoder handler
  */
void init_encoders(void)
{
	//Call this before encoder_handler()
	init_default_enc_handlers();
	
	/* Voltage encoders */
	init_enc_handler(&enc[0], KEYADDR0, EN_CH0_VDIV, set_vdiv_ch0);
	init_enc_handler(&enc[1], KEYADDR0, EN_CH1_VDIV, set_vdiv_ch1);
	
	/* Position encoders */
	init_enc_handler(&enc[6], KEYADDR0, EN_CH0_UPDN, add_dac0_offset);
	init_enc_handler(&enc[7], KEYADDR0, EN_CH1_UPDN, add_dac1_offset);

	/* other encoders */
	init_enc_handler(&enc[2],  LEDADDR, EN_LEVEL, changeTriggerLevel);
	init_enc_handler(&enc[3],  LEDADDR, EN_TIME_DIV, setTimebase);
	init_enc_handler(&enc[4],  LEDADDR, EN_LEFT_RIGHT, setFramePosition);
	init_enc_handler(&enc[5],  LEDADDR, EN_F, vfValueChanged);
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
	channel[0].BitMode = 16;

	channel[1].analog.myVperDiv = 5000000;
	channel[1].analog.AC = 0;
	channel[1].analog.Mode = normal;
	//	Analog[1].DA_Offset = 16384;
	channel[1].analog.DA_Offset = 0;
	channel[1].analog.BW_Limit = 0;
	channel[1].BitMode = 8;

	WRITE_INT(CONFIGADCENABLE,1); 
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

	DrawBox(BG_COLOR,0,0,HLEN-1,VLEN-1); //Draw black background
	drawGrid();					
	
	/* Init frontpanel */
	init_buttons();
	init_encoders();

	WRITE_INT(LEDADDR,(1 << RUN_RED));

	titleBarInit();
	status_bar_init();
	
	/* Set timbase, trigger and voltage per div
	 * Also updates titlebar.
	 */
	setTimebase(0);
	changeTriggerEdge(0);
	setVoltagePerDiv(CH0,0);
	setVoltagePerDiv(CH1,0);
	WRITE_INT(LEDADDR,(1 << LED_CH2));
	updateMenu(&men_ch[0]); //Activate menu for channel 0
	WRITE_INT(LEDADDR,(1 << LED_CH3));
	WRITE_INT(ANALOGSETTINGSADDR,(1 << ENABLEKEYCLOCK));

	Run = TRUE;
	/*
	 * Main loop
	 */
	while(1)
	{
		readkeys();
		button_handler();
		encoder_handler();

	//	closeSubMenuTime();

		if ((READ_INT(KEYADDR1) & (1 << BTN_RUNSTOP)) != 0)
		{
			Run^= TRUE; // Toogle Run Stop	for TRUE = 1 or TRUE = -1
			Single = FALSE;
			CLR_LED(SINGLE_GREEN);
			CLR_LED(SINGLE_RED);
		
			if (Run == TRUE)
			{
				SET_LED(RUN_GREEN);
				CLR_LED(RUN_RED);
			} 
			else 
			{
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

		if (((int32_t)ReadData >= (FRAMESIZE+triggerSettings.prefetch)) || (Run == FALSE) )
		{
			if (Single == TRUE) 
			{
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
				GetCh(0,channel[0].BitMode, &Ch1[CurrBuffer][0],&Data[Offset[0].H], HLEN+100, 
						VoltagePerDiv[channel[0].selectedVoltagePerDiv].Gain,
						HWFilters.Gain);
				DrawSignal(Offset[0].V,&Ch1[PrevBuffer][0], &Ch1[CurrBuffer][0],COLOR_R3G3B3(0,0,0), signalcolors[0]);
			}

			if(channel[1].state == CHANNEL_ON)
			{
				GetCh(1,channel[0/*no bug*/].BitMode, &Ch2[CurrBuffer][0],&Data[Offset[1].H], HLEN+100,	
						VoltagePerDiv[channel[1].selectedVoltagePerDiv].Gain,
						HWFilters.Gain);
				DrawSignal(Offset[1].V,&Ch2[PrevBuffer][0], &Ch2[CurrBuffer][0],COLOR_R3G3B3(0,0,0), signalcolors[1]);

			}
		}
	}
}


#endif

