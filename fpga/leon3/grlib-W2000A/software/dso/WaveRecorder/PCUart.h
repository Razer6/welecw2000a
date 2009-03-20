/*
 * querySerial v0.1 9/17/01
 * www.embeddedlinuxinterfacing.com
 *
 * The original  location of this source is
 * http://www.embeddedlinuxinterfacing.com/chapters/06/querySerial.c
 *
 *
 * Copyright (C) 2001 by Craig Hollabaugh
 *
 * Changes for the welec DSO project are from Alexander Lindert
 * Copyright (C) 2009 by Alexander Lindert
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

/* querySerial
 * querySerial provides bash scripts with serial communications. This
 * program sends a query out a serial port and waits a specific amount
 * of time then returns all the characters received. The command line
 * parameters allow the user to select the serial port, select the
 * baud rate, select the timeout and the serial command to send.
 * A simple hash function converts the baud rate
 * command line parameter into an integer.  */

/*
gcc -o querySerial querySerial.c
*/


#include <stdio.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <termios.h>
#include <stdlib.h>
#include "string.h"

/* These are the hash definitions */
#define USERBAUD1200 '1'+'2'
#define USERBAUD2400 '2'+'4'
#define USERBAUD9600 '9'+'6'
#define USERBAUD1920 '1'+'9'
#define USERBAUD3840 '3'+'8'



/* This is a wrapper from posix uart the leon3uart!
 * It does only support the used settings for DSO_Remote.c */

/* UART control bits for the leon3uart */
/* example: Control = ENABLE_RX | ENABLE_TX;*/
#define DISABLE 0x0
#define ENABLE_RX 0x1
#define ENABLE_TX 0x2
#define RX_INT 0x4
#define TX_INT 0x8
#define EVEN_PARITY 0x20
#define ODD_PARITY 0x30
#define LOOP_BACK 0x80
#define FLOW_CONTROL 0x40
#define FIFO_TX_INT 0x200
#define FIFO_RX_INT 0x400


#define uart_regs int

#include "types.h"

bool UartInit(	char * UartAddr,
		const int BaudRate,
		uart_regs * uart);

char ReceiveCharBlock(uart_regs * uart);

void SendCharBlock(uart_regs * uart, char c);

/* interrupts if the rx buffer is empty!*/
void ReceiveString (uart_regs * uart, char * c, unsigned int * size);

void ReceiveStringBlock (uart_regs * uart, char * c, unsigned int * size);

/* interrupts if the tx buffer is full!*/
void SendString (uart_regs * uart, char * c, unsigned int * size);

void SendStringBlock (uart_regs * uart, char * c, unsigned int * size);


