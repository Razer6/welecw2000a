
#include <stdio.h>
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

#ifdef WINNT 
#include "windows.h"
#define uart_regs HANDLE
#else
#define HANDLE int
#define uart_regs int
#endif

#include "types.h"

void UartClose (uart_regs * uart);

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


