
#include "DSO_Remote.h"
#include "string.h"
#include "stdio.h"

void SendNAK(uart_regs * uart) {
	char Res[] = DSO_NAK_RESP;
	int size = strlen(Res);
	SendHeader(uart);
	SendStringBlock(uart, Res, &size);
	printf(" NAK sent\n");
}

void SendACK(uart_regs * uart) {
	char Res[] = DSO_ACK_RESP;
	int size = strlen(Res);
	SendHeader(uart);
	SendStringBlock(uart, Res, &size);
	printf(" ACK sent\n");
}

void SendHeader(uart_regs * uart) {
	int size = 0;
	char Header[] = DSO_SEND_HEADER;
	size = strlen(Header);
	SendStringBlock(uart,Header,&size);
}

bool ReceiveHeader(uart_regs * uart) {
	const char RefHeader[] = DSO_REC_HEADER;
	int size = strlen(RefHeader);
	int i = 0;
	int errors = 0;
	char rec = 0;
	printf("Receiving Header \n");	
	while (i < size){
		rec = ReceiveCharBlock(uart);
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

bool SendData(uart_regs * uart, int datasize, int * data) {
	int size = 0;
	char DataH[] = DSO_DATA_RESP;
	int i = 0;
	size = strlen(DataH);
	SendHeader(uart);
	SendStringBlock(uart,DataH,&size);
	SendInt(uart, 0); /* FastMode */
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
	size = strlen(DataH);
	if (!ReceiveHeader(uart)){
        	printf("Receive Header error\n");
		return 0;
	}
	for (i = 0; i < size; ++i){
		if (DataH[i] != ReceiveCharBlock(uart)){
           		printf("Receive Data Responce error\n");
		       return 0;
		}
	/*	printf("%c",ReceiveCharBlock(uart));*/
	}
	*FastMode = GetInt(uart);
	size = GetInt(uart);
/*	if (size > buffersize) {
		size = buffersize;
	}*/
	printf("Got %d DWORDS FastMode=%d\n",size,*FastMode);
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
	if (!ReceiveHeader(uart)){
        printf("Receive Header error\n");
		return false;
	}
	for (i = 0; i < size; ++i){
		if (DataH[i] != ReceiveCharBlock(uart)){
			printf("Receive ACK error\n");
			return false;
		}
	/*	printf("%c",ReceiveCharBlock(uart));*/
	}
	return true;
}



unsigned int GetInt(uart_regs * uart) {
 	unsigned int data = 0;
 	unsigned char c[4];
	int i = 0;
	for (i = 0; i < 4; ++i){
        c[i] = ReceiveCharBlock(uart);
	}
	for (i = 0; i < 4; ++i){
		data |= (c[i] << (8*i));
	}
	return data;
}

void SendInt(uart_regs * uart, unsigned int data) {
	int i = 0;
	unsigned int ch = 0;
/*	printf("\nSendInt %d ",data);*/
	for (i = 0; i < 4; ++i){
        ch = (unsigned char)data;
		SendCharBlock(uart,ch);
		data = data >> 8;
	}
}

