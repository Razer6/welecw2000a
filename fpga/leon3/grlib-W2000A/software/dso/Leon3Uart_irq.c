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
#include "asm-leon/leon.h"

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
/*#define TX_INT       (1 << 9)
#define RX_INT       (1 << 10)*/

/* only 2^n values allowed! */
#define UART_TX_BUFFER_SIZE 256
#define UART_RX_BUFFER_SIZE 256

typedef struct {
volatile char RxBuf[UART_RX_BUFFER_SIZE];
volatile char TxBuf[UART_TX_BUFFER_SIZE];
volatile uint32_t RxIdxHead;
volatile uint32_t RxIdxTail;
volatile uint32_t TxIdxHead;
volatile uint32_t TxIdxTail;
} aUartData;

static aUartData UartData[2];

static volatile uart_regs * uart;

void IsrUart(int irq){
	register uint32_t tempHead;
	register uint32_t tempData;
	register uint32_t tempTail;
	volatile uint32_t temp;
	WRITE_INT(DSO_SFR_BASE_ADDR,16);
	
	switch(irq){
		case 2: irq = 0; 
			uart = (uart_regs*)GENERIC_UART_BASE_ADDR;
			break;
		case 7: irq = 1;
		        uart = (uart_regs*)DEBUG_UART_BASE_ADDR;
			break;
		default: return;
	}
	READ_INT(&uart->status, temp);
	WRITE_INT(DSO_SFR_BASE_ADDR, temp);
/*	WRITE_INT(DSO_SFR_BASE_ADDR+4*3, (temp & RX_DATAREADY));
	WRITE_INT(DSO_SFR_BASE_ADDR+4*22, (temp & TX_EMPTY));*/
	if ((temp & RX_DATAREADY) != 0) {
		WRITE_INT(DSO_SFR_BASE_ADDR,17);
		/* read uart status*/
		tempData = uart->data;
		/* calculate new buffer index */
		tempHead = ((UartData[irq].RxIdxHead + 1) & (UART_RX_BUFFER_SIZE - 1));
		if(tempHead != UartData[irq].RxIdxTail){
			WRITE_INT(DSO_SFR_BASE_ADDR,18);
			UartData[irq].RxIdxHead = tempHead;
			UartData[irq].RxBuf[tempHead] = tempData;
		}
	} 
       	if ((temp & TX_EMPTY) != 0) {
		WRITE_INT(DSO_SFR_BASE_ADDR,19);
		if (UartData[irq].TxIdxTail != UartData[irq].TxIdxHead){
			WRITE_INT(DSO_SFR_BASE_ADDR,20);
			/* calculate new buffer index */
			tempTail = ((UartData[irq].TxIdxTail + 1) & (UART_TX_BUFFER_SIZE - 1));
			UartData[irq].TxIdxTail = tempTail;
			/* send new character */
			uart->data = UartData[irq].TxBuf[tempTail];
		} else {
			WRITE_INT(DSO_SFR_BASE_ADDR,21);
			/* no more data to send */
			uart->control = (uart->control) & (~TX_FIFO_INT);
		}
	}
}

uint32_t GetUartIdx(uart_regs * uart){
	switch ((uint32_t)uart) {
		case GENERIC_UART_BASE_ADDR: return 0;
		case DEBUG_UART_BASE_ADDR: return 1;
	}
	return -1;
}

bool UartInit(
		const uint32_t CPUFreq,
		const uint32_t BaudRate,
		const uint32_t Control,
		uart_regs * uart_isr) {
	int scaler = CPUFreq/(8*BaudRate);
	int irq = 0;
	uart = uart_isr;
	/* most times the baudrate cannot be reached exactly!
	 * For this the PCs set the baudrate slightly higher
	 * and here this is done, too */
	if (scaler*8*BaudRate != CPUFreq){
		scaler--;
	}
/*	if you do this outside, more uarts can be used with this file*/
/*	uart = (uart_regs *)GENERIC_UART_BASE_ADDR;*/
	if ((BaudRate < 10) || (CPUFreq < 1000000) || (BaudRate > CPUFreq/8)) {
		return false;
	}
	uart->scaler = scaler;

	switch((uint32_t)uart){
		case GENERIC_UART_BASE_ADDR: 	irq = 2; break;
		case DEBUG_UART_BASE_ADDR: 	irq = 7; break;
		default : return false;
	}
	catch_interrupt(IsrUart, irq);
	uart->control = Control;
	uart->status = 0;
//	printf("Scaler = %d  Control = %d\n",scaler,Control);
	irq = GetUartIdx(uart);
	UartData[irq].RxIdxHead = 0;
	UartData[irq].RxIdxTail = 0;
	UartData[irq].TxIdxHead = 0;
	UartData[irq].TxIdxTail = 0;
	return true;
}



char ReceiveCharBlock(uart_regs * uart) {
	uint32_t tempTail;
	uint32_t Idx = GetUartIdx(uart);
		
	while (UartData[Idx].RxIdxHead == UartData[Idx].RxIdxTail)
		/* no data */;

	/* calculate new buffer index */
	tempTail = ((UartData[Idx].RxIdxTail + 1) & (UART_RX_BUFFER_SIZE - 1));
	UartData[Idx].RxIdxTail = tempTail;

	/* read item */
	return UartData[Idx].RxBuf[tempTail];
}

char ReceiveChar(uart_regs * uart, uint32_t TimeoutMs, uint32_t *error){
	uint32_t i = 0;
	uint32_t tempTail;
	uint32_t Idx = GetUartIdx(uart);
		
	while (UartData[Idx].RxIdxHead == UartData[Idx].RxIdxTail){
		if (i == TimeoutMs){
			*error = 1; 
			return 0;
		}
		i++;
		WaitMs(1);
	}

	/* calculate new buffer index */
	tempTail = ((UartData[Idx].RxIdxTail + 1) & (UART_RX_BUFFER_SIZE - 1));
	UartData[Idx].RxIdxTail = tempTail;

	/* read item */
	return UartData[Idx].RxBuf[tempTail];
}

void SendCharBlock(uart_regs * uart, char c) {
	uint32_t tempHead;
	uint32_t Idx = GetUartIdx(uart);

	tempHead = UartData[Idx].TxIdxHead;
	
	/* calculate new buffer index */
	tempHead = ((tempHead + 1) & (UART_TX_BUFFER_SIZE - 1));
	while (tempHead == UartData[Idx].TxIdxTail);
	
	
	/* add new item to buffer */
	UartData[Idx].TxBuf[tempHead] = c;
	UartData[Idx].TxIdxHead = tempHead;
	/* activate isr to transmit data */
	uart->control = (uart->control) | TX_FIFO_INT;
}

/* interrupts if the rx buffer is empty!*/
void ReceiveString (uart_regs * uart, char * c, uint32_t * size) {
/*	uint32_t rsize = 0;
	volatile int temp = 0;
	while (rsize < (*size)) {
		temp = loadmem((int)&uart->status);
	        if ((temp & RX_DATAREADY) != 0){
		       break;
		}
		c[rsize] = loadmem((int)&uart->data);
		rsize++;
	}
	*size = rsize;*/
	*size = 0;
}

void ReceiveStringBlock (uart_regs * uart, char * c, uint32_t * size) {
	uint32_t rsize = 0;
	while  (rsize < (*size)){
		c[rsize] = ReceiveCharBlock(uart);
		rsize++;
	}
}


void SendStringBlock (uart_regs * uart, char * c) {
	uint32_t i = 0;
	uint32_t size = strlen(c);
	while (i < size){
		SendCharBlock(uart,c[i]);
	/*	printf("Sending %c %d\n",c[i],i);*/
		i++;
	}
}

/* interrupts if the tx buffer is full!*/
void SendString (uart_regs * uart, char * c, uint32_t *size) {
/*	uint32_t i = 0;
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
	*size = i;*/
	*size = 0;
}

