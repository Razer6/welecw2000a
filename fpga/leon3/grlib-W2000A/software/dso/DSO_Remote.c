/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_Remote.c
* Author	 : Alexander Lindert <alexander_lindert at gmx.at>
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

#include "DSO_Remote.h"
#include "string.h"
#include "stdio.h"



void SendNAK(uart_regs * uart) {
	SendHeader(uart);
	SendStringBlock(uart,DSO_NAK_RESP);
	printf("\nNAK sent\n");
}

void SendACK(uart_regs * uart) {
	SendHeader(uart);
	SendStringBlock(uart,DSO_ACK_RESP);
	printf("\nACK sent\n");
}
void SendCRCError(uart_regs * uart) {
	SendHeader(uart);
	SendStringBlock(uart,DSO_CRC_ERROR);
	printf("\nCRC Error sent\n");
}

typedef union {
	uint32_t i;
	unsigned char c[4];
} uEndian;

void ChangeEndian(uint32_t message[], int nBytes){
#ifdef LITTLE_ENDIAN
	uEndian temp;
	uEndian change;
	int i = 0;
	int j = 0;
	for (i = 0; i < nBytes/4;++i){
		temp.i = message[i];
		for (j = 0; j < 4; ++j){
			change.c[j] = temp.c[3-j];
		}
		message[i] = change.i;
	}
#endif
}

#ifndef LEON3
uint32_t GetInt(uart_regs * uart, uint32_t *error) {
 	uEndian data;
	int i = 0;
	for (i = 0; i < 4; ++i){
		data.c[3-i] = ReceiveChar(uart,error);
		if (*error != 0){
			return data.i;
		}
	}
	return data.i;
}
#else
uint32_t GetInt(uart_regs * uart) {
 	uEndian data;
	int i = 0;
	for (i = 0; i < 4; ++i){
		data.c[i] = ReceiveCharBlock(uart);
	}
	return data.i;
}
#endif

void SendInt(uart_regs * uart, uint32_t data) {
	int i = 0;
	uEndian d;
	d.i=data;
/*	printf("\nSendInt %d ",data); */
	for (i = 0; i < 4; ++i){
#ifdef LITTLE_ENDIAN
		SendCharBlock(uart,d.c[3-i]);
#else
		SendCharBlock(uart,d.c[i]);
#endif
	}
}

bool CheckCRC(crc crcSent, uint32_t message[], int nBytes){
	crc crcRec = 0;
	ChangeEndian(message,nBytes);
	crcInit();	
	crcRec = crcFast((unsigned char*)message,nBytes);
/*	printf("CRC Check with %d bytes: crcSent=%d crcRec=%d!\n",nBytes,crcSent,crcRec);*/
	if (crcSent == crcRec){
		return true;
	} else {
		return false;
	}
}

void SendHeader(uart_regs * uart) {
	SendStringBlock(uart,DSO_SEND_HEADER);
}

bool ReceiveHeader(
		uart_regs * uart,
		const char * RefHeader) {
/*	const char RefHeader[] = DSO_REC_HEADER;*/
	int size = strlen(RefHeader);
	int i = 0;
	int errors = 0;
	uint32_t terr = 0;
	char rec = 0;
	while (i < size){

#ifdef LEON3
			rec = ReceiveCharBlock(uart);
#else
			rec = ReceiveChar(uart,&terr);
			if (terr != 0) {
				return false;
			}
#endif
		if (RefHeader[i] != rec) {
			i = 0;
			if (rec != 0){
				errors++;
				printf("\nerror no %d: %c \n",errors,rec);
			}
#ifndef LEON3
			if (errors == MAX_RX_ERRORS){
				return false;
			}
#endif
		} else {
			i++;
			
		}
	}
	return true;
}

bool SendCaptureData(uart_regs * uart, uint32_t FastMode, int datasize, uint32_t * data) {
	char DataH[] = DSO_DATA_RESP;
	int i = 0;
	SendHeader(uart);
	printf(DSO_SEND_HEADER);
	SendStringBlock(uart,DataH);
	SendInt(uart, FastMode);
	SendInt(uart, datasize);
	for (i = 0; i < datasize; ++i) {
		SendInt(uart, data[i]);
	}
	return true;
}

bool SendData(uart_regs * uart,  int datasize, uint32_t * data) {
	int i = 0;
	SendHeader(uart);
	SendStringBlock(uart,DSO_DATA_RESP);
	SendInt(uart, datasize);
	for (i = 0; i < datasize; ++i) {
		SendInt(uart, data[i]);
	}
	return true;
}

#ifndef LEON3
int ReceiveCaptureData(uart_regs * uart, uint32_t buffersize, uint32_t * FastMode, uint32_t * data) {
	uint32_t size = 0;
	uint32_t i = 0;
	uint32_t error = 0;
	uint32_t dummy = 0;
	if (!ReceiveHeader(uart, DSO_REC_HEADER)){
        printf("Receive Header error\n");
		return 0;
	}
	if (!ReceiveHeader(uart, DSO_DATA_RESP)){
        printf("Receive Data Responce error\n");
		return 0;
	}

	*FastMode = GetInt(uart,&error);
	if (error != 0){
		return 0;
	}
	size = GetInt(uart,&error);
	if (error != 0){
		return 0;
	}
	if (size > buffersize) {
		*FastMode = 1;
	}
	printf("Receiving %d DWORDS FastMode=%d\n",size,*FastMode);
	for (i = 0; i < size; ++i){
		if (i < buffersize){
			data[i] = GetInt(uart,&error);
			if (error != 0){
				return i-1;
			}
		} else {
			dummy = GetInt(uart,&error);
			if (error != 0){
				return buffersize;
			}
		}
	}
	return size;
}
#endif

int ReceiveData(uart_regs * uart, uint32_t buffersize, uint32_t * data) {
	uint32_t size = 0;
	uint32_t i = 0;
	uint32_t error = 0;
	uint32_t dummy = 0;
	if (!ReceiveHeader(uart, DSO_REC_HEADER)){
        	printf("Receive Header error\n");
		return 0;
	}
	if (!ReceiveHeader(uart, DSO_DATA_RESP)){
        	printf("Receive Header error\n");
		return 0;
	}
#ifdef LEON3
	size = GetInt(uart);
#else
	size = GetInt(uart,&error);
	if (error != 0){
		return 0;
	}
#endif
	printf("Receiving %d DWORDS \n",size);
	for (i = 0; i < size; ++i){
		if (i < buffersize){
#ifdef LEON3
			data[i] = GetInt(uart);
#else
			data[i] = GetInt(uart,&error);
			if (error != 0){
				return i-1;
			}
#endif
		} else {
#ifdef LEON3
			dummy = GetInt(uart);
#else
			dummy = GetInt(uart,&error);
			if (error != 0){
				return buffersize;
			}
#endif		
		}

	}
	return size;
}

bool ReceiveACK(uart_regs * uart){
	uint32_t i = 0;
	const char Ack[] = DSO_ACK_RESP;
	const char Nak[] = DSO_NAK_RESP;
	const char Crc[] = DSO_CRC_ERROR;
	const char Msg[] = DSO_MESSAGE_RESP;
	const char * Current = Ack;
	uint32_t size = 0;
	uint32_t error = 0;
	char c = '\0';

	do {
		if (!ReceiveHeader(uart, DSO_REC_HEADER)){
			return false;
		}
#ifdef LEON3
		c = ReceiveCharBlock(uart);
#else
		c = ReceiveChar(uart,&error);
		if (error != 0){
			return false;
		}
#endif
		switch (c) {
			case 'A': break;
			case 'N': Current = Nak; break;
			case 'C': Current = Crc; break;
			case 'M': Current = Msg; break;
			default: break;
		}
		size = strlen(Current);
		for (i = 1; i < size; ++i){
#ifdef LEON3
			c = ReceiveCharBlock(uart);
#else
			c = ReceiveChar(uart,&error);
			if (error != 0){
				return false;
			}
#endif
			if (Current[i] != c){
				printf("Received unexpected data\n");
				return false;
			}
		}
		if (Current == Msg){
			do {
#ifdef LEON3
			c = ReceiveCharBlock(uart);
#else
			c = ReceiveChar(uart,&error);
			if (error != 0){
				return false;
			}
#endif
			if (c != '\0'){
				putc(c,stdout);
			}
			} while (c != '\0');
		}
	} while (Current == Msg);
	if (Current != Ack) {
		printf("Received %s!",Current);
	}
	return true;
}





