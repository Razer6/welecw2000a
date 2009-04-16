
#include "DSO_SFR.h"
#include "DSO_Misc.h"
#include "Leon3Uart.h"
#include "stdio.h"
#include "string.h"

void TestKeys(uart_regs * uart, int value , int change, char * M[20], int size);

void FrontPanelTest(uart_regs * uart) {
	char Ml[][20] = {
		" LED_BTN_CH3",
		" LED_Beam1On",
		" LED_BTN_MATH",
		" LED_Beam2On",
		" LED_BTN_QUICKMEAS",
		" LED_CURSORS",
		" LED_BTN_F",
		" LED_BTN_CH2",
		" LED_BTN_PULSEWIDTH",
		" LED_EDGE",
		" LED_RUNSTOP",
		" LED_BTN_F2",
		" LED_BTN_F3",
		" LED_SINGLE"};
	char Mk0[][20] = {
		" ENX_LEFT_RIGHT",
		" ENY_LEFT_RIGHT",
		" ENX_LEVEL",
		" ENY_LEVEL",
		" ENX_CH0_UPDN",
		" ENY_CH0_UPDN",
		" ENX_CH1_UPDN",
		" ENY_CH1_UPDN",
		" ENX_CH2_UPDN",
		" ENY_CH2_UPDN",
		" ENX_CH3_UPDN",
		" ENY_CH3_UPDN",
		" ENX_CH0_VDIV",
		" ENY_CH0_VDIV",
		" ENX_CH1_VDIV",
		" ENY_CH1_VDIV",
		" ENX_CH2_VDIV",
		" ENY_CH2_VDIV",
		" ENX_CH3_VDIV",
		" ENY_CH3_VDIV"};
char Mk1[][20] = {
		" BTN_F1",
		" BTN_F2",
		" BTN_F3",
		" BTN_F4",
		" BTN_F5",
		" BTN_F6",
		" BTN_MATH",
		" BTN_CH0",
		" BTN_CH1",
		" BTN_CH2",
		" BTN_CH3",
		" BTN_MAINDEL",
		" BTN_RUNSTOP",
		" BTN_SINGLE",
		" BTN_CURSORS",
		" BTN_QUICKMEAS",
		" BTN_ACQUIRE",
		" BTN_DISPLAY",
		" BTN_EDGE",
		" BTN_MODECOUPLING",
		" BTN_AUTOSCALE",
		" BTN_SAVERECALL",
		" BTN_QUICKPRint",
		" BTN_UTILITY",
		" BTN_PULSEWIDTH",
		" BTN_X1",
		" BTN_X2",
		" ENX_TIME_DIV",
		" ENY_TIME_DIV",
		" ENX_F",
		" ENY_F"};

	int * addr = (int *)LEDADDR;
	char Message[80] = ""; 
	int size = 0;
	int i = 0;
	int c0 = -1;
	int c1 = -1;
	int value = 0;
	
	/* led test */
	
	for (i = 0; i < 14; ++i){
		sprintf(Message,"Switching leds %s on!\n",Ml[i]);
		size = strlen(Message);
		SendStringBlock(uart,Message,&size);
		WaitMs(5000);
		*addr |= (1 << i);
	}

	for (i = 0; i < 14; ++i){
		sprintf(Message,"Switching leds %s off!\n",Ml[i]);
		size = strlen(Message);
		SendStringBlock(uart,Message,&size);
		WaitMs(5000);
		*addr &= ~(1 << i);
	}

	
	sprintf(Message,"Reporting key changes!\n");
	while(1) {
		addr = (int *)KEYADDR0;
		value = *addr;
		TestKeys(uart, value, c0, Mk0, sizeof(Mk0)/(sizeof(Mk0[0])));
		c0 = c0 ^ value;
		addr = (int *)KEYADDR1;
		value = *addr;
		TestKeys(uart, value, c0, Mk1, sizeof(Mk1)/(sizeof(Mk1[0])));
		c1 = c1 ^ value;
		
	}
}	

void TestKeys(uart_regs * uart, int value, int change, char * M[20], int size) {
	int i = 0;
	char Message[80] = ""; 
	for (i = 0; i < size; ++i){
		if ((change & (1 << i)) != 0) {
			if ((value & (1 << i)) != 0){
				sprintf(Message,"Key %s is on!\n",M[i]);
			} else {
				sprintf(Message,"Key %s is off!\n",M[i]);
			}
			size = strlen(Message);
			SendStringBlock(uart,Message,&size);
		}
	}
}
