

#ifndef DSO_REMOTE_H
#define DSO_REMOTE_H

#define DSO_MASTER_HEADER "Digital Storage Scope Master "
#define DSO_SLAVE_HEADER  "Digital Storage Scope Slave  "
#define DSO_NAK_RESP      "NAK"
#define DSO_ACK_RESP      "ACK"
#define DSO_DATA_RESP     "Data "

#ifdef LEON3
#define DSO_REC_HEADER     DSO_MASTER_HEADER
#define DSO_SEND_HEADER    DSO_SLAVE_HEADER
#else
#define DSO_REC_HEADER     DSO_SLAVE_HEADER
#define DSO_SEND_HEADER    DSO_MASTER_HEADER
#endif

#define SET_TRIGGER_INPUT 1000
#define SET_ANALOG_INPUT  1010
#define SET_TRIGGER       1020
#define CAPTURE_DATA      1030
#define STORE_DWORDS      1040
#define LOAD_DWORDS       1050
#define MAX_RX_ERRORS     100000

#ifdef LEON3
#include "Leon3Uart.h"
#else 
#include "PCUart.h"
#endif


void SendNAK(uart_regs * uart);
void SendACK(uart_regs * uart);
void SendHeader(uart_regs * uart);
bool SendData(uart_regs * uart, int datasize, int * data);
int ReceiveData(uart_regs * uart, int buffersize, int * FastMode, int * data);
bool ReceiveACK(uart_regs * uart);
bool GetHeader(uart_regs * uart);
int  GetInt(uart_regs * uart);
void SendInt(uart_regs * uart, int data);

#endif
