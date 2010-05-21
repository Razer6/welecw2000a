/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File            : DSO_FrontPanel.c
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 20.04.2009
*****************************************************************************
* Description	 : 
*****************************************************************************

*  Copyright (c) 2009, Alexander Lindert
*  		  2010,  Robert Schilling

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

#ifdef BOARD_COMPILATION

#include "DSO_FrontPanel.h"
#include "DSO_SFR.h"
#include "DSO_Misc.h"
#include "Leon3Uart.h"


#define CLEN 40
void TestKeys(uart_regs * uart, int value , int change, char ** M, int size);

#if 0

void FrontPanelTest(uart_regs * uart) {
	char Ml[][CLEN] = {
	{" LED_CH"},
	{" LED_CH1"},
	{" LED_CH2"},
	{" LED_CH3"},
	{" LED_MATH"},
	{" LED_QUICKMEAS"},
	{" LED_CURSORS"},
	{" LED_WHEEL"},
	{" LED_PULSEWIDTH"},
	{" LED_EDGE"},
	{" RUN_GREEN"},
	{" RUN_RED"},
	{" SINGLE_GREEN"},
	{" SINGE_RED"}};
	char k0[] =  {" ENX_LEFT_RIGHT"};
	char k1[] =  {" ENY_LEFT_RIGHT"};
	char k2[] =  {" ENX_LEVEL"};
	char k3[] =  {" ENY_LEVEL"};
	char k4[] =  {" ENX_CH_UPDN"};
	char k5[] =  {" ENY_CH_UPDN"};
	char k6[] =  {" ENX_CH1_UPDN"};
	char k7[] =  {" ENY_CH1_UPDN"};
	char k8[] =  {" ENX_CH2_UPDN"};
	char k9[] =  {" ENY_CH2_UPDN"};
	char k10[] = {" ENX_CH3_UPDN"};
	char k11[] = {" ENY_CH3_UPDN"};
	char k12[] = {" ENX_CH_VDIV"};
	char k13[] = {" ENY_CH_VDIV"};
	char k14[] = {" ENX_CH1_VDIV"};
	char k15[] = {" ENY_CH1_VDIV"};
	char k16[] = {" ENX_CH2_VDIV"};
	char k17[] = {" ENY_CH2_VDIV"};
	char k18[] = {" ENX_CH3_VDIV"};
	char k19[] = {" ENY_CH3_VDIV"};
	char * Mk[] = {
		k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, 
		k10, k11, k12, k13, k14, k15, k16, k17, k18, k19};

	char k20[] = {" BTN_F1"};
	char k21[] = {" BTN_F2"};
	char k22[] = {" BTN_F3"};
	char k23[] = {" BTN_F4"};
	char k24[] = {" BTN_F5"};
	char k25[] = {" BTN_F6"};
	char k26[] = {" BTN_MATH"};
	char k27[] = {" BTN_CH"};
	char k28[] = {" BTN_CH1"};
	char k29[] = {" BTN_CH2"};
	char k30[] = {" BTN_CH3"};
	char k31[] = {" BTN_MAINDEL"};
	char k32[] = {" BTN_RUNSTOP"};
	char k33[] = {" BTN_SINGLE"};
	char k34[] = {" BTN_CURSORS"};
	char k35[] = {" BTN_QUICKMEAS"};
	char k36[] = {" BTN_ACQUIRE"};
	char k37[] = {" BTN_DISPLAY"};
	char k38[] = {" BTN_EDGE"};
	char k39[] = {" BTN_MODECOUPLING"};
	char k40[] = {" BTN_AUTOSCALE"};
	char k41[] = {" BTN_SAVERECALL"};
	char k42[] = {" BTN_QUICKPRint"};
	char k43[] = {" BTN_UTILITY"};
	char k44[] = {" BTN_PULSEWIDTH"};
	char k45[] = {" BTN_X1"};
	char k46[] = {" BTN_X2"};
	char k47[] = {" ENX_TIME_DIV"};
	char k48[] = {" ENY_TIME_DIV"};
	char k49[] = {" ENX_F"};
	char k50[] = {" ENY_F"};
	char * Mk1[] = {
		k20, k21, k22, k23, k24, k25, k26, k27, k28, k29, 
		k30, k31, k32, k33, k34, k35, k36, k37, k38, k39,
		k40, k41, k42, k43, k44, k45, k46, k47, k48, k49, k50};
		

	volatile uint32_t * addr = (uint32_t *)LEDADDR;
	int i = 0;
	int c = -1;
	int c1 = -1;
	int value = 0;
	char M[80];
	
	/* led test */
	
	for (i = 0; i < 14; ++i){
//		sprintf(M,"Switching leds %s on!\n",&Ml[i*CLEN]);
//		SendStringBlock(GENERIC_UART_BASE_ADDR,M);
		WaitMs(20);
		*addr |= (1 << i);
	}

	for (i = 0; i < 14; ++i){
//		sprintf(M,"Switching leds %s off!\n",&Ml[i*CLEN]);
//		SendStringBlock(GENERIC_UART_BASE_ADDR,M);
		WaitMs(20);
		*addr &= ~(1 << i);
	}

	for (i = 0; i < 14; ++i){
//		sprintf(M,"Switching leds %s on!\n",&Ml[i*CLEN]);
//		SendStringBlock(GENERIC_UART_BASE_ADDR,M);
		WaitMs(20);
		*addr |= (1 << i);
	}

//	printf("Reporting key changes!\n");
/*	while(1) {
		addr = (int *)KEYADDR0;
		value = *addr;
		TestKeys(uart, value, c, (char*)Mk, sizeof(Mk)/CLEN);
		c = c ^ value;
		addr = (int *)KEYADDR1;
		value = *addr;
		TestKeys(uart, value, c, (char*)Mk1, sizeof(Mk1)/CLEN);
		c1 = c1 ^ value;
		
	}*/
}	

void TestKeys(uart_regs * uart, int value, int change, char ** M, int size) {
	int i = 0;
//	char Um[255];
	for (i = 0; i < size; ++i){
		if ((change & (1 << i)) != 0) {
			if ((value & (1 << i)) != 0){
//				sprintf(Um,"Key %s is on!\n",M[i]);
				printf("Key %d is on!\n", i);
//				SendStringBlock(GENERIC_UART_BASE_ADDR,"Key is on!\n");
			} else {
//				sprintf(Um,"Key %s is off!\n",M[i]);
				printf("Key %d is off!\n", i);
//				SendStringBlock(GENERIC_UART_BASE_ADDR, "Key is off!\n");
			}
		}
	}
}

#endif

static uint32_t keystate = 0;
static uint32_t keypress = 0;

/* 
 * Debounces all keys. Keys must be 4 calls (2-bit vertical counter) at same state for a 
 * changing recognition. Should be called in a timer interrupt routine.
 */
void readkeys(void)
{
	static uint32_t ct0 = 0, ct1 = 0;

	register uint32_t i = keystate^READ_INT(KEYADDR1);

	/* 2 Bit vertical counter */
	ct0 = ~(ct0 & i);
	ct1 = ct0 ^ (ct1 & i);
	i &= ct0 & ct1;

	keystate ^= i;
	keypress |= keystate & i;
}

/* 
 * Reads out the pressed keys. Every pressed button is signaled by a '1'-bit
 * in return value
 */
uint32_t get_key_pressed(uint32_t keymask)
{
//	disable_irq();			//Must be atomic
	keymask &= keypress;
	keypress ^= keymask;
//	release_irq();
	return keymask;
}

void default_button_handler(void *args)
{
	/* Do nothing */
}


/*
 * A button handler for every button. Default button handler does nothing.
 */
bt_handler bt_handler_f1 = {default_button_handler, 0};
bt_handler bt_handler_f2 = {default_button_handler, 0};
bt_handler bt_handler_f3 = {default_button_handler, 0};
bt_handler bt_handler_f4 = {default_button_handler, 0};
bt_handler bt_handler_f5 = {default_button_handler, 0};
bt_handler bt_handler_f6 = {default_button_handler, 0};
bt_handler bt_handler_math = {default_button_handler, 0};
bt_handler bt_handler_ch0 = {default_button_handler, 0};
bt_handler bt_handler_ch1 = {default_button_handler, 0};
bt_handler bt_handler_ch2 = {default_button_handler, 0};
bt_handler bt_handler_ch3 = {default_button_handler, 0};
bt_handler bt_handler_maindel = {default_button_handler, 0};
bt_handler bt_handler_runstop = {default_button_handler, 0};
bt_handler bt_handler_single = {default_button_handler, 0};
bt_handler bt_handler_cursors= {default_button_handler, 0};
bt_handler bt_handler_quickmeas = {default_button_handler, 0};
bt_handler bt_handler_acquire = {default_button_handler, 0};
bt_handler bt_handler_display = {default_button_handler, 0};
bt_handler bt_handler_edge = {default_button_handler, 0};
bt_handler bt_handler_modecoupling = {default_button_handler, 0};
bt_handler bt_handler_autoscale = {default_button_handler, 0};
bt_handler bt_handler_saverecall = {default_button_handler, 0};
bt_handler bt_handler_quickprint = {default_button_handler, 0};
bt_handler bt_handler_utility = {default_button_handler, 0};
bt_handler bt_handler_pulsewidth = {default_button_handler, 0};


/*
 * Adds a button handler for a button.
 */
void init_bt_handler(bt_handler *handler, void (*callback)(void *args), void *args)
{
	handler->callback = callback;
	handler->args = args;
}

/*
 * The button handler  must be called in the main loop.
 * This function handles the action of all keys. The key debouncing happens
 * in a seperate function called in the timer interrupt routine (in future).
 */
void button_handler(void)
{
	uint32_t keys = get_key_pressed(KEYMASK);

	if(!keys)
	{
		return;
	}

	switch(keys)
	{
		case 1<<BTN_F1:
			bt_handler_f1.callback(bt_handler_f1.args);
		break;
		case 1<<BTN_F2:
			bt_handler_f2.callback(bt_handler_f2.args);
		break;
		case 1<<BTN_F3:
			bt_handler_f3.callback(bt_handler_f3.args);
		break;
		case 1<<BTN_F4:
			bt_handler_f4.callback(bt_handler_f4.args);
		break;
		case 1<<BTN_F5:
			bt_handler_f5.callback(bt_handler_f5.args);
		break;
		case 1<<BTN_F6:
			bt_handler_f6.callback(bt_handler_f6.args);
		break;
		case 1<<BTN_MATH:
			bt_handler_f1.callback(bt_handler_f1.args);
		break;
		case 1<<BTN_CH0:
			bt_handler_ch0.callback(bt_handler_ch0.args);
		break;
		case 1<<BTN_CH1:
			bt_handler_ch1.callback(bt_handler_ch1.args);
		break;
		case 1<<BTN_CH2:
			bt_handler_ch2.callback(bt_handler_ch2.args);
		break;
		case 1<<BTN_CH3:
			bt_handler_ch3.callback(bt_handler_ch3.args);
		break;
		case 1<<BTN_MAINDEL:
			bt_handler_maindel.callback(bt_handler_maindel.args);
		break;
		case 1<<BTN_RUNSTOP:
			bt_handler_runstop.callback(bt_handler_runstop.args);
		break;
		case 1<<BTN_SINGLE:
			bt_handler_single.callback(bt_handler_single.args);
		break;
		case 1<<BTN_CURSORS:
			bt_handler_cursors.callback(bt_handler_cursors.args);
		break;
		case 1<<BTN_QUICKMEAS:
			bt_handler_quickmeas.callback(bt_handler_quickmeas.args);
		break;
		case 1<<BTN_ACQUIRE:
			bt_handler_acquire.callback(bt_handler_acquire.args);
		break;
		case 1<<BTN_DISPLAY:
			bt_handler_display.callback(bt_handler_display.args);
		break;
		case 1<<BTN_EDGE:
			bt_handler_edge.callback(bt_handler_edge.args);
		break;
		case 1<<BTN_MODECOUPLING:
			bt_handler_modecoupling.callback(bt_handler_modecoupling.args);
		break;
		case 1<<BTN_AUTOSCALE:
			bt_handler_autoscale.callback(bt_handler_autoscale.args);
		break;
		case 1<<BTN_SAVERECALL:
			bt_handler_saverecall.callback(bt_handler_saverecall.args);
		break;
		case 1<<BTN_QUICKPRINT:
			bt_handler_quickprint.callback(bt_handler_quickprint.args);
		break;
		case 1<<BTN_UTILITY:
			bt_handler_utility.callback(bt_handler_utility.args);
		break;
		case 1<<BTN_PULSEWIDTH:
			bt_handler_pulsewidth.callback(bt_handler_pulsewidth.args);
		break;

		default:
		break;
	}
}

/*
 * An encoder handler for every button. Default encoder handler does nothing.
 */
enc_handler enc[ENCODERMAX] ;

void init_enc_handler(enc_handler *handler, uint32_t address, uint32_t offset, void (*callback)(int32_t diff))
{
	handler->address = address;
	handler->offset = offset;
	handler->callback = callback;
	
	/*
	* The hardware encoder counters do not have an initial value,
          * so the first access of the get_encoder_diff does return a wrong result!
          * (This is not at all a bug!) 
	*/
	handler->diff = 0;
	handler->new_value = (READ_INT(handler->address) >> handler->offset) & 7;
	handler->old_value = handler->new_value;
}

void default_encoder_handler (int32_t diff)
{
	/* Do nothing */
}


/* 
 * Set default encoder handler for every encoder
 */
void init_default_enc_handlers(void)
{
	for(uint32_t i=0; i<ENCODERMAX; i++)
	{
		/* EN_CH0_UPDN is default handler */
		enc[i].address  = KEYADDR0;
		enc[i].offset   = EN_CH0_UPDN;
		enc[i].callback = default_encoder_handler;
		
		enc[i].diff = 0;
		enc[i].new_value = (READ_INT(enc[i].address) >> enc[i].offset) & 7;
		enc[i].old_value = enc[i].new_value;
	}
}

/*
  * Reads out the encoders. Do not call this in an interrupt because it's calling the user encoder handler.
  * This can last a long time and will block other routines.
  */
void encoder_handler(void)
{
	for(uint32_t i=0; i<ENCODERMAX; ++i)
	{
		enc[i].new_value = (READ_INT(enc[i].address) >> enc[i].offset) & 7;
		ROTARYMOVE(enc[i].diff, enc[i].new_value, enc[i].old_value);
		
		if (enc[i].diff != 0)
		{
			enc[i].callback(enc[i].diff);
		}
	}
}



#if 0
uint32_t encoder_changed0;
uint32_t encoder_changed1;
uint32_t encoder_state0;
uint32_t encoder_state1;

/*
 * The encoder handler  must be called in the main loop.
 * This function handles the action encoders. The reading
 * of the encoders happens in a timer interrupt routine (in future).
 */

void read_encoders(void)
{
	static uint32_t old_encoder_state0 = 0, old_encoder_state1;

	encoder_state0 = READ_INT(LEDADDR) & 0xFFFF0000;
	encoder_state1 = READ_INT(KEYADDR0);

	encoder_changed0 = old_encoder_state0 ^ encoder_state0;
	encoder_changed1 = old_encoder_state1^encoder_state1;

	old_encoder_state0 = encoder_state0;
	old_encoder_state1 = encoder_state1;
}

uint32_t get_encoder_diff(uint32_t *reg, uint32_t *change_t, uint32_t *old, int32_t *diff)
{
/* The 3 bit encoder counters do exsist in hardware, so this code should be replaced by the previous define */ 
	register uint32_t enc = *reg;
	register uint32_t change = *change_t;
	register uint32_t mask = 0x07;
	register uint32_t i = 0;
	register uint32_t old_t = *old;

	while(enc)
	{
		if(enc & 0x07) //Encoder changed?
		{
			*diff = (change & 0x07) - (old_t & 0x07);

			if(*diff == -7)
				*diff = 1;
			else if(*diff == 7)
				*diff = -1;

			*reg &= ~mask; //Clear change
			*old = (*old & ~mask) | ((change & 0x07)<<i); //save current state
			return mask;
		}
		//Next Encoder
		old_t >>= 4;
		i += 4;
		mask <<= 4;
		enc >>= 4;
		change >>= 4;
	}
	return 0;
}
#endif

#endif
