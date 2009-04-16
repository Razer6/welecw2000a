#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "grcommon.h"
#include "DSO_SignalCapture.h"
#include "DSO_Debugprint.h"
#include "Leon3Uart.h"

#define CAPTURESIZE (32786*2)
#define FASTFS 500000000
#define SLOWFS    500000
int main () {
	int ReadData = 0;
	uart_regs * uart = (uart_regs *)GENERIC_UART_BASE_ADDR;
	uart_regs * uart2 = (uart_regs *)DEBUG_UART_BASE_ADDR;
	int Data[CAPTURESIZE];
	SetAnalog Analog[2];
/*	bool succ = false;*/
	char M1[] = "DSO Test programm:\nstart testing SetTriggerInput\n";
	char M2[] = "testing SetTrigger\n";
	char M3[] = "testing SetAnalogInputRange\n";
	char M4[] = "testing FastCapture\n";
	char M5[] = "testing NormalCapture\n";
	char M6[] = "loopback test send 3 characters back ";
	char ack[] = "success!\n";
	char nak[] = "failed!\n";
	int strsize = 0;
	Analog[0].myVperDiv = 100000;
	Analog[0].AC = 0;
	Analog[0].Mode = normal;
	Analog[0].DA_Offset = 0xaa;
	Analog[0].PWM_Offset = 0xf1;
	Analog[1].myVperDiv = 100000;
	Analog[1].AC = 1;
	Analog[1].Mode = normal;
	Analog[1].DA_Offset = 0xf1;
	Analog[1].PWM_Offset = 0xf1;
	Debugprint * Debug;
/*	printf("Starting SFR Test\n");*/
	InitSignalCapture(Debug,PrintF,English);
	UartInit(FIXED_CPU_FREQUENCY,115200, ENABLE_RX | ENABLE_TX, uart);
/*	SendCharBlock(uart,255);*/

	strsize = strlen(M1);
	SendStringBlock(uart,M1,&strsize);
	if (SetTriggerInput(2,8,FASTFS,FIXED_CPU_FREQUENCY,0,2,0,1,2,3) == true){
		strsize = strlen(ack);
		SendStringBlock(uart,ack,&strsize);
	} else {
		strsize = strlen(nak);
		SendStringBlock(uart,nak,&strsize);
	}
	strsize = strlen(M2);
	SendStringBlock(uart,M2,&strsize);
	strsize = strlen(ack);
	if (SetTrigger(0,0,64,-16,3,16,3) == true){
		strsize = strlen(ack);
		SendStringBlock(uart,ack,&strsize);
	} else {
		strsize = strlen(nak);
		SendStringBlock(uart,nak,&strsize);
	}
	strsize = strlen(M3);
	SendStringBlock(uart,M3,&strsize);
	strsize = strlen(ack);
	if (SetAnalogInputRange(2,Analog) == true){
		strsize = strlen(ack);
		SendStringBlock(uart,ack,&strsize);
	} else {
		strsize = strlen(nak);
		SendStringBlock(uart,nak,&strsize);
	}
	strsize = strlen(M4);
	SendStringBlock(uart,M4,&strsize);
	ReadData = CaptureData(1000000, true, CAPTURESIZE, Data, 512, FASTFS, FIXED_CPU_FREQUENCY);
	SetTriggerInput(2,16,SLOWFS,FIXED_CPU_FREQUENCY,0,2,0,1,2,3);
	strsize = strlen(M5);
	SendStringBlock(uart,M5,&strsize);
	ReadData = CaptureData(1000000, true, CAPTURESIZE, Data, 512, 1000000, FIXED_CPU_FREQUENCY);

/*	ReadData = 3;
	strsize = strlen(M6);
	SendStringBlock(uart,M6,&strsize);
	ReceiveStringBlock(uart, M6, &ReadData);
	SendStringBlock(uart,M6, &ReadData);*/
	SendCharBlock(uart,'\n');
	
	UartInit(FIXED_CPU_FREQUENCY,115200, ENABLE_RX | ENABLE_TX, uart2);
	SendCharBlock(uart2,M6);
	RemoteSlave(uart2,CAPTURESIZE,Data);	
/*	printf("End SFR Test\n");*/
	return 0;
}
