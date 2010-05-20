/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_FrontPanel.h
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 20.04.2009
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
#ifndef DSO_FRONTPANEL_H
#define DSO_FRONTPANEL_H

#include "types.h"

//void FrontPanelTest(uart_regs * uart);

#define KEYMASK	0x1FFFFFF

void readkeys(void);

void button_handler(void);

typedef struct 
{
	void (*callback)(void *args);
	void *args;
} bt_handler;

extern bt_handler bt_handler_f1;
extern bt_handler bt_handler_f2;
extern bt_handler bt_handler_f3;
extern bt_handler bt_handler_f4;
extern bt_handler bt_handler_f5;
extern bt_handler bt_handler_f6;
extern bt_handler bt_handler_math;
extern bt_handler bt_handler_ch0;
extern bt_handler bt_handler_ch1;
extern bt_handler bt_handler_ch2;
extern bt_handler bt_handler_ch3;
extern bt_handler bt_handler_maindel;
extern bt_handler bt_handler_runstop;
extern bt_handler bt_handler_single;
extern bt_handler bt_handler_cursors;
extern bt_handler bt_handler_quickmeas;
extern bt_handler bt_handler_acquire;
extern bt_handler bt_handler_display;
extern bt_handler bt_handler_edge;
extern bt_handler bt_handler_modecoupling;
extern bt_handler bt_handler_autoscale;
extern bt_handler bt_handler_saverecall;
extern bt_handler bt_handler_quickprint;
extern bt_handler bt_handler_utility;
extern bt_handler bt_handler_pulsewidth;

void init_bt_handler(bt_handler *handler, void (*callback)(void *args), void *args);

void encoder_handler(void);

#define ENCODERMAX 12

typedef struct  
{
	int32_t diff;
	int32_t old_value;
        int32_t new_value;
	uint32_t address;
	uint32_t offset;
        void (*callback)(int32_t diff);

} enc_handler;

extern enc_handler enc[ENCODERMAX] ;

void init_default_enc_handlers(void);

void init_enc_handler(enc_handler *handler, uint32_t address, uint32_t offset, void (*callback)(int32_t diff));

void encoder_handler(void);

#if 0
extern uint32_t encoder_changed0;
extern uint32_t encoder_changed1;
extern uint32_t encoder_state0;
extern uint32_t encoder_state1;

uint32_t get_encoder_diff(uint32_t *reg, uint32_t *change_t, uint32_t *old, int32_t *diff);

void read_encoders(void);

#endif



#endif

