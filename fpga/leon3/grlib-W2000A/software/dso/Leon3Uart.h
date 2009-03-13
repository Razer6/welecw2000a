
#ifndef LEON3UART_H 
#define LEON3UART_H

bool UartInit(	const unsigned int CPUFreq,
		const unsigned int BaudRate,
		const unsigned int Control,
		uart_regs * uart);

char ReceiveCharBlock(uart_regs * uart);

void SendCharBlock(uart_regs * uart, char c);

// interrupts if the rx buffer is empty!
void ReceiveString (uart_regs * uart, char * c, unsigned int * size);

void ReceiveStringBlock (uart_regs * uart, char * c, unsigned int * size);

// interrupts if the tx buffer is full!
void SendString (uart_regs * uart, char * c, unsigned int * size);

void SendStringBlock (uart_regs * uart, char * c, unsigned int * size);

#endif
