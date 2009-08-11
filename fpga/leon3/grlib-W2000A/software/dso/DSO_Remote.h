/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Remote.h
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
#ifndef DSO_REMOTE_H
#define DSO_REMOTE_H

#include "types.h"

#ifdef W2000A
#define DSO_REMOTE_UART_BAUDRATE 9600
#define REMOTE_UART (uart_regs*)GENERIC_UART_BASE_ADDR
#elif SBX
#define DSO_REMOTE_UART_BAUDRATE 28800
#define REMOTE_UART (uart_regs*)DEBUG_UART_BASE_ADDR
#else
#define DSO_REMOTE_UART_BAUDRATE 9600
#define REMOTE_UART (uart_regs*)DEBUG_UART_BASE_ADDR
#endif

#define DSO_MASTER_HEADER "Digital Storage Scope Master "
#define DSO_SLAVE_HEADER  "Digital Storage Scope Slave  "
#define DSO_NAK_RESP      "NAK"
#define DSO_ACK_RESP      "ACK"
#define DSO_DATA_RESP     "Data "
#define DSO_MESSAGE_RESP  "Message "
#define DSO_CRC_ERROR     "CRC ERROR"

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
#include "crc.h"

#ifdef __cplusplus
extern "C" {
#endif


void SendNAK(uart_regs * uart);
void SendACK(uart_regs * uart);
void SendCRCError(uart_regs * uart);
void ChangeEndian(uint32_t message[], int nBytes);
bool CheckCRC(crc crcSent, uint32_t message[], int nBytes);
void SendHeader(uart_regs * uart);
bool SendCaptureData(uart_regs * uart, uint32_t FastMode, int datasize, uint32_t * data);
bool SendData(uart_regs * uart,  int datasize, uint32_t * data);
int ReceiveCaptureData(uart_regs * uart, uint32_t buffersize, uint32_t * FastMode, uint32_t * data);
int ReceiveData(uart_regs * uart, uint32_t buffersize, uint32_t * data);
bool ReceiveACK(uart_regs * uart);
bool ReceiveHeader(uart_regs * uart, const char * RefHeader);
#ifdef LITTLE_ENDIAN
uint32_t GetInt(uart_regs * uart, uint32_t *error);
#else
uint32_t GetInt(uart_regs * uart);
#endif
void SendInt(uart_regs * uart, uint32_t data);

#ifdef __cplusplus
}
#endif


#endif
