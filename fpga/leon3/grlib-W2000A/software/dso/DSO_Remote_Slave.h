#ifndef DSO_REMOTE_SLAVE_H
#define DSO_REMOTE_SLAVE_H

#ifdef LEON3
#include "Leon3Uart.h"
#else 
#include "PCUart.h"
#endif

/* main loop for the remote controlled DSO*/
void RemoteSlave(	uart_regs * comm_uart,
			const unsigned int DataSize,
			int *Data);


#endif

