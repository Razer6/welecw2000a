/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : Leon3Uart.c
* Author		 : Alexander Lindert <alexander_lindert at gmx.at>
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


#include "DSO_Main.h"
#include "Leon3Uart.h"
#include "DSO_Misc.h"
#include "string.h"

/*
31: 26 Receiver FIFO count (RCNT) - shows the number of data frames in the receiver FIFO.
25: 20 Transmitter FIFO count (TCNT) - shows the number of data frames in the transmitter FIFO.
10 Receiver FIFO full (RF) - indicates that the Receiver FIFO is full.
9 Transmitter FIFO full (TF) - indicates that the Transmitter FIFO is full.
8 Receiver FIFO half-full (RH) -indicates that at least half of the FIFO is holding data.
7 Transmitter FIFO half-full (TH) - indicates that the FIFO is less than half-full.
6 Framing error (FE) - indicates that a framing error was detected.
5 Parity error (PE) - indicates that a parity error was detected.
4 Overrun (OV) - indicates that one or more character have been lost due to overrun.
3 Break received (BR) - indicates that a BREAK has been received.
2 Transmitter FIFO empty (TE) - indicates that the transmitter FIFO is empty.
1 Transmitter shift register empty (TS) - indicates that the transmitter shift register is empty.
0 Data ready (DR) - indicates that new data is available in the receiver holding register
*/

#define RX_DATAREADY 0x1
#define OVERRUN      0x10 
#define TX_FULL      (1 << 9)
#define TX_EMPTY     (1 << 2)

bool UartInit(	const unsigned int CPUFreq,
		const unsigned int BaudRate,
		const unsigned int Control,
		uart_regs * uart) {
	int scaler = CPUFreq/(8*BaudRate);
	/* most times the baudrate cannot be reached exactly!
	 * For this the PCs set the baudrate slightly higher
	 * and here this is done, too */
	if (scaler*8*BaudRate != CPUFreq){
/*		scaler--;*/
	}
/*	if you do this outside, more uarts can be used with this file*/
/*	uart = (uart_regs *)GENERIC_UART_BASE_ADDR;*/
	if ((BaudRate < 10) || (CPUFreq < 1000000) || (BaudRate > CPUFreq/8)) {
		return false;
	}
	uart->scaler = scaler;
	printf("Scaler = %d  Control = %d\n",scaler,Control);
	uart->control = Control;
	uart->status = 0;
	return true;
}

char ReceiveCharBlock(uart_regs * uart) {
	volatile int temp = 0;
	while (1){
		temp = loadmem((int)&uart->status);
		if ((temp & RX_DATAREADY) != 0){
			break;
     		}
	}
	return loadmem((int)&uart->data);
}
char ReceiveChar(uart_regs * uart, unsigned int TimeoutMs, unsigned int *error){
	return 0;
}

void SendCharBlock(uart_regs * uart, char c) {
	volatile int temp = 0;
	while (1) {
		temp = loadmem((int)&uart->status);
		if ((temp & TX_EMPTY) != 0){
			break;
		}
		if ((uint32_t)uart == DEBUG_UART_BASE_ADDR){
			printf("%d ",temp & TX_EMPTY);
		}
	}
	uart->data = c;
}

/* interrupts if the rx buffer is empty!*/
void ReceiveString (uart_regs * uart, char * c, unsigned int * size) {
	unsigned int rsize = 0;
	volatile int temp = 0;
	while (rsize < (*size)) {
		temp = loadmem((int)&uart->status);
	        if ((temp & RX_DATAREADY) != 0){
		       break;
		}
		c[rsize] = loadmem((int)&uart->data);
		rsize++;
	}
	*size = rsize;
}

void ReceiveStringBlock (uart_regs * uart, char * c, unsigned int * size) {
	unsigned int rsize = 0;
	while  (rsize < (*size)){
		c[rsize] = ReceiveCharBlock(uart);
		rsize++;
	}
}


void SendStringBlock (uart_regs * uart, char * c) {
	unsigned int i = 0;
	unsigned int size = strlen(c);
	while (i < size){
		SendCharBlock(uart,c[i]);
	/*	printf("Sending %c %d\n",c[i],i);*/
		i++;
	}
}

/* interrupts if the tx buffer is full!*/
void SendString (uart_regs * uart, char * c, unsigned int *size) {
	unsigned int i = 0;
	volatile int temp = 0;
	*size = strlen(c);
	while (i < (*size)){
		temp = loadmem((int)&uart->status);
		if ((temp & TX_EMPTY) == 0){
			break;
		}
		uart->data = c[i];
		i++;
	}
	*size = i;
}

