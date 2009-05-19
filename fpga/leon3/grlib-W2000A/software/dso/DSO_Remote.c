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
	printf(" NAK sent\n");
}

void SendACK(uart_regs * uart) {
	SendHeader(uart);
	SendStringBlock(uart,DSO_ACK_RESP);
	printf(" ACK sent\n");
}
void SendCRCError(uart_regs * uart) {
	SendHeader(uart);
	SendStringBlock(uart,DSO_CRC_ERROR);
	printf(" CRC Error sent\n");
}

typedef union {
	unsigned int i;
	unsigned char c[4];
} uEndian;

void ChangeEndian(unsigned int message[], int nBytes){
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

unsigned int GetInt(uart_regs * uart) {
 	uEndian data;
	int i = 0;
	for (i = 0; i < 4; ++i){
#ifdef LITTLE_ENDIAN
		data.c[3-i] = ReceiveCharBlock(uart);
#else
		data.c[i] = ReceiveCharBlock(uart);
#endif
	}
	return data.i;
}

void SendInt(uart_regs * uart, unsigned int data) {
	int i = 0;
	uEndian d;
	d.i=data;
/*	printf("\nSendInt %d ",data);*/
	for (i = 0; i < 4; ++i){
#ifdef LITTLE_ENDIAN
		SendCharBlock(uart,d.c[3-i]);
#else
		SendCharBlock(uart,d.c[i]);
#endif
	}
}

bool CheckCRC(crc crcSent, unsigned int message[], int nBytes){
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

bool ReceiveHeader(uart_regs * uart,
		const char * RefHeader, 
		unsigned int Timeout) {
/*	const char RefHeader[] = DSO_REC_HEADER;*/
	int size = strlen(RefHeader);
	int i = 0;
	int errors = 0;
	int terr = 0;
	char rec = 0;
	while (i < size){
		if (Timeout == 0){
			rec = ReceiveCharBlock(uart);
		} else {
			rec = ReceiveChar(uart,Timeout,&terr);
			if (terr != 0) {
				printf("Timeout!\n");
				return false;
			}
		}
		if (RefHeader[i] != rec) {
			errors++;
			printf(" error no %d: %c \n",errors,rec);
			if (errors == MAX_RX_ERRORS){
				return false;
			}
			i = 0;
		} else {
			i++;
			
		}
	}
	return true;
}

bool SendData(uart_regs * uart, unsigned int FastMode, int datasize, unsigned int * data) {
	char DataH[] = DSO_DATA_RESP;
	int i = 0;
	SendHeader(uart);
	SendStringBlock(uart,DataH);
	SendInt(uart, FastMode);
	SendInt(uart, datasize);
	for (i = 0; i < datasize; ++i) {
		SendInt(uart, data[i]);
	}
	return true;
}

int ReceiveData(uart_regs * uart, int buffersize, int * FastMode, int * data) {
	int size = 0;
	int i = 0;
	int dummy = 0;
	char DataH[] = DSO_DATA_RESP;

	if (!ReceiveHeader(uart, DSO_REC_HEADER,1000)){
        	printf("Receive Header error\n");
		return 0;
	}
	size = strlen(DataH);
	for (i = 0; i < size; ++i){
		if (DataH[i] != ReceiveCharBlock(uart)){
			printf("Receive Data Responce error\n");
			return 0;
		}
	}
	*FastMode = GetInt(uart);
	size = GetInt(uart);
	if (size > buffersize) {
		*FastMode = 0;
	}
	printf("Receiving %d DWORDS FastMode=%d\n",size,*FastMode);
	for (i = 0; i < size; ++i){
		if (i < buffersize){
			data[i] = GetInt(uart);
		} else {
			dummy = GetInt(uart);
		}
	}
	return size;
}

bool ReceiveACK(uart_regs * uart){
	int size = 0;
	int i = 0;
	char DataH[] = DSO_ACK_RESP;
	size = strlen(DataH);
	if (!ReceiveHeader(uart, DSO_REC_HEADER, 300)){
		printf("Receive Header error\n");
		return false;
	}
	for (i = 0; i < size; ++i){
		if (DataH[i] != ReceiveCharBlock(uart)){
			printf("Receive ACK error\n");
			return false;
		}
	}
	return true;
}





