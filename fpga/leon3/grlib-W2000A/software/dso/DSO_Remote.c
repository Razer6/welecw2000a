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
#ifndef W2000A
	printf("\nNAK sent\n");
#endif
}

void SendACK(uart_regs * uart) {
	SendHeader(uart);
	SendStringBlock(uart,DSO_ACK_RESP);
#ifndef W2000A
	printf("\nACK sent\n");
#endif
}
void SendCRCError(uart_regs * uart) {
	SendHeader(uart);
	SendStringBlock(uart,DSO_CRC_ERROR);
#ifndef W2000A
	printf("\nCRC Error sent\n");
#endif
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

uint32_t GetIntX(uart_regs * uart, uint32_t *error) {
	uint32_t i = 0;
	uint32_t data = 0;
	i = ReceiveBytes(uart,(unsigned char*)&data,sizeof(uint32_t));
	ChangeEndian(&data, sizeof(uint32_t));

	if (i == sizeof(uint32_t)){
		*error = 0;
	} else {
		*error = 1;
	}
	/*
	for (i = 0; i < 4; ++i){
		data.c[3-i] = ReceiveChar(uart,error);
		if (*error != 0){
			return data.i;
		}
	}*/
	return data;
}

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
#ifndef LEON3
	ChangeEndian(&d.i,sizeof(uint32_t));
	SendBytes(uart,(uint8_t *)&d.i,sizeof(uint32_t));
#else
	for (i = 0; i < 4; ++i){
#ifdef LITTLE_ENDIAN
		SendCharBlock(uart,d.c[3-i]);
#else
		SendCharBlock(uart,d.c[i]);
#endif
	}
#endif
}

bool CheckCRC(crc crcSent, uint32_t message[], int nBytes){
	crc crcRec = 0;
	ChangeEndian(message,nBytes);
	crcInit();	
	crcRec = crcFast((unsigned char*)message,nBytes);
	printf("CRC Check with %d bytes: crcSent=%d crcRec=%d!\n",nBytes,crcSent,crcRec);
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
#ifndef W2000A
				printf("\nerror no %d: %c ",errors,rec);
#endif
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
	char DataH[] = DSO_SAMPLE_RESP;
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
/*	if (!ReceiveHeader(uart, DSO_REC_HEADER)){
#ifndef W2000A
        printf("Receive Header error\n");
#endif
		return 0;
	}
	if (!ReceiveHeader(uart, DSO_DATA_RESP)){
#ifndef W2000A
        printf("Receive Data Responce error\n");
#endif
		return 0;
	}*/

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
#ifndef W2000A
	printf("Receiving %d DWORDS FastMode=%d\n",size,*FastMode);
#endif
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
/*	if (!ReceiveHeader(uart, DSO_REC_HEADER)){
#ifndef W2000A
        	printf("Receive Header error\n");
#endif
		return 0;
	}
	if (!ReceiveHeader(uart, DSO_DATA_RESP)){
#ifndef W2000A
        	printf("Receive Header error\n");
#endif
		return 0;
	}*/
#ifdef LEON3
	size = GetInt(uart);
#else
	size = GetInt(uart,&error);
	if (error != 0){
		return 0;
	}
#endif
#ifndef W2000A
	printf("Receiving %d DWORDS \n",size);
#endif
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

int ReceiveAll(uart_regs * uart, uint32_t buffersize, uint32_t * data, uint32_t * FastMode){
	uint32_t i = 0;
	const char Ack[]     = DSO_ACK_RESP;
	const char Nak[]     = DSO_NAK_RESP;
	const char Data[]    = DSO_DATA_RESP;
	const char Sample[]  = DSO_SAMPLE_RESP;
	const char Crc[]     = DSO_CRC_ERROR;
	const char Msg[]     = DSO_MESSAGE_RESP;
	const char * Current = Ack;
	uint32_t size = 0;
	uint32_t error = 0;
	char c = '\0';

	do {
		if (!ReceiveHeader(uart, DSO_REC_HEADER)){
			return 0;
		}
#ifdef LEON3
		c = ReceiveCharBlock(uart);
#else
		c = ReceiveChar(uart,&error);
		if (error != 0){
			return 0;
		}
#endif
		switch (c) {
			case 'A': Current = Ack;     break;
			case 'N': Current = Nak;     break;
			case 'D': Current = Data;    break;
			case 'S': Current = Sample;  break;
			case 'C': Current = Crc;     break;
			case 'M': Current = Msg;     break;
			default: break;
		}
		size = strlen(Current);
		for (i = 1; i < size; ++i){
#ifdef LEON3
			c = ReceiveCharBlock(uart);
#else
			c = ReceiveChar(uart,&error);
			if (error != 0){
				return 0;
			}
#endif
			if (Current[i] != c){
#ifndef LEON3
				printf("Received unexpected data\n");
#endif
				return 0;
			}
		}
		if (Current == Msg){
			do {
#ifdef LEON3
				c = ReceiveCharBlock(uart);
#else
				c = ReceiveChar(uart,&error);
				if (error != 0){
					return 0;
				}
#endif
				if (c != '\0'){
					putc(c,stdout);
				}
			} while (c != '\0');
#ifdef WINNT
			Sleep(1);
#endif
		} else if (Current == Data) {
			return ReceiveData(uart, buffersize, data);
		}
#ifndef LEON3
		else if (Current == Sample) {
			return ReceiveCaptureData(uart, buffersize, data, FastMode);
		}
#endif
	} while (Current == Msg);
	if (Current == Ack) {
		return 1;
	} 
#ifndef W2000A
	printf("\nReceived %s!\n",Current);
#endif
	return 0;
}





