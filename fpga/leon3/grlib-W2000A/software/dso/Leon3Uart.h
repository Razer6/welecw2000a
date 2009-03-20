
#ifndef LEON3UART_H 
#define LEON3UART_H

/* UART control bits */
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


typedef struct  
{
   volatile int data;
   volatile int status;
   volatile int control;
   volatile int scaler;
} uart_regs;

bool UartInit(	const unsigned int CPUFreq,
		const unsigned int BaudRate,
		const unsigned int Control,
		uart_regs * uart);

char ReceiveCharBlock(uart_regs * uart);

void SendCharBlock(uart_regs * uart, char c);

/* interrupts if the rx buffer is empty!*/
void ReceiveString (uart_regs * uart, char * c, unsigned int * size);

void ReceiveStringBlock (uart_regs * uart, char * c, unsigned int * size);

/* interrupts if the tx buffer is full!*/
void SendString (uart_regs * uart, char * c, unsigned int * size);

void SendStringBlock (uart_regs * uart, char * c, unsigned int * size);

#endif
