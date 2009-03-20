
#include "DSO_Remote.h"


void SendNAK(uart_regs * uart) {
	char Res[] = DSO_NAK_RESP;
	int size = strlen(Res);
	SendHeader(uart);
	SendStringBlock(uart, Res, &size);
}

void SendACK(uart_regs * uart) {
	char Res[] = DSO_ACK_RESP;
	int size = strlen(Res);
	SendHeader(uart);
	SendStringBlock(uart, Res, &size);
}

void SendHeader(uart_regs * uart) {
	int size = 0;
	char Header[] = DSO_SEND_HEADER;
	size = strlen(Header);
	SendStringBlock(uart,Header,&size);
}

bool ReceiveHeader(uart_regs * uart){
	char Header[] = DSO_REC_HEADER;
	int size = strlen(Header);
	int i = 0;
	for (i = 0; i < size; ++i){
		if (Header[i] != ReceiveCharBlock(uart)){
		       return false;
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
	char DataH[] = DSO_DATA_RESP;
	size = strlen(DataH);
	if (!ReceiveHeader(uart)){
		return 0;
	}
	for (i = 0; i < size; ++i){
		if (DataH[i] /= ReceiveCharBlock(uart)){
		       return 0;
		}
	}
	*FastMode = GetInt(uart);
	size = GetInt(uart);
	if (size > buffersize) {
		size = buffersize;
	}
	for (i = 0; i < size; ++i){
		data[i] = GetInt(uart);
	}
	return size;
}

bool ReceiveACK(uart_regs * uart){
	int size = 0;
	int i = 0;
	char DataH[] = DSO_ACK_RESP;
	size = strlen(DataH);
	if (!ReceiveHeader(uart)){
		return false;
	}
	for (i = 0; i < size; ++i){
		if (DataH[i] /= ReceiveCharBlock(uart)){
		       return false;
		}
	}
	return true;
}

bool GetHeader(uart_regs * uart) {
	const char RefHeader[] = DSO_MASTER_HEADER;
	int size = strlen(RefHeader);
	int i = 0;
	int errors = 0;
		
	while (i < size){
		if (RefHeader[i] != ReceiveCharBlock(uart)) {
			errors++;
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

int GetInt(uart_regs * uart) {
 	int data = 0;
	int i = 0;
	for (i = 0; i < 4; ++i){
		data |= (ReceiveCharBlock(uart) << (i*8));
	}
	return data;
}

void SendInt(uart_regs * uart, int data) {
	int i = 0;
	for (i = 0; i < 4; ++i){
		SendCharBlock(uart,(char)data);
		data = data >> 8;
	}
}

