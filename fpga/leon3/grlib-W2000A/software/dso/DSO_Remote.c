

#include "DSO_Main.h"
#include "DSO_Misc.h"
#include "DSO_SignalCapture.h"
#include "Leon3Uart.h"
#include "DSO_Remote.h"

int * buffer;
unsigned int buffer_size;
uart_regs * uart;

bool GetTask();
void SendNAK();
void SendACK();
void SendHeader();
bool SendData(int datasize);
bool GetHeader();
int  GetInt();
void SendInt();


void RemoteSlave(	uart_regs * comm_uart,
			const unsigned int DataSize,
			int *Data) {
	buffer = Data;
	buffer_size = DataSize;
	uart = comm_uart;
	while(GetHeader()){
		GetTask();		
	}
}

bool GetTask() {
	unsigned int i = 0;
	SetAnalog Analog[4];
	unsigned int s = GetInt();
	static unsigned int SamplingFrequency = 10000;
	int * addr;
	int data;
	unsigned int size;

	switch (s) {
		case SET_TRIGGER_INPUT:
			{
				unsigned int noCh = GetInt();
				unsigned int SamplingSize = GetInt();
				SamplingFrequency = GetInt();			
				if(SetTriggerInput(	noCh, SamplingSize, SamplingFrequency,
							GetInt(),GetInt(),GetInt(),
							GetInt(),GetInt(),GetInt(),
							GetInt())){
					SendACK();
				} else {
					SendNAK();
					return false;
				}
			}
			break;

		case  SET_ANALOG_INPUT:
			s = GetInt();
			if (s > 3) {
				SendNAK();
				return false;
			}
			for (i = 0; i < s; ++i){
				Analog[i].myVperDiv  = GetInt();
				Analog[i].AC         = GetInt();
				Analog[i].DA_Offset  = GetInt();
				Analog[i].PWM_Offset = GetInt();
			}
			if(SetAnalogInputRange(s, Analog)){
				SendACK();
			} else {
				SendNAK();
				return false;
			}
			break;

		case SET_TRIGGER:
			if (SetTrigger(	GetInt(), GetInt(), GetInt(), GetInt(), GetInt(),
					GetInt(), GetInt())) {
				SendACK();
			} else {
				SendNAK();
				return false;
			}
			break;
		case CAPTURE_DATA:
			{
				unsigned int WaitTime = GetInt();
				unsigned int Start = GetInt();
				unsigned int Csize = GetInt();
				if (Csize > buffer_size){
					Csize = buffer_size;
				}
				if(s = CaptureData(WaitTime,Start,Csize,buffer,
						512,FIXED_CPU_FREQUENCY, SamplingFrequency)){
					return SendData(s, buffer);
				} else {
					SendNAK();
					return false;
				}
			}
			break;

		case STORE_DWORDS:
			addr = (int *)GetInt();
			size = GetInt();
			if (size > buffer_size){
				SendNAK();
				return false;
			}
			for  (i = 0; i < size; ++i){
				addr[i] = GetInt();
			}
			SendACK();
			break;

		case LOAD_DWORDS:
			addr = (int *)GetInt();
			size = (int *)GetInt();
			if (size > buffer_size){
				SendNAK();
				return false;
			}
			for (i = 0; i < size; ++i){
				buffer[i] = addr[i];
			}
			SendData(size, buffer);
			break;
				
		default:
			SendNAK();
			return false;
			break;
	}
	return true;
}

void SendNAK() {
	char Res[] = DSO_NAK_RESP;
	SendHeader();
	int size = strlen(Res);
	SendStringBlock(uart, Res, &size);
}

void SendACK() {
	char Res[] = DSO_ACK_RESP;
	SendHeader();
	int size = strlen(Res);
	SendStringBlock(uart, Res, &size);
}

void SendHeader() {
	int size = 0;
	char Header[] = DSO_SLAVE_HEADER;
	size = strlen(Header);
	SendStringBlock(uart,Header,&size);
}

bool SendData(int datasize, int * data) {
	int size = 0;
	char DataH[] = "Data ";
	int i = 0;
	size = strlen(DataH);
	SendStringBlock(uart,DataH,&size);
	SendInt(datasize);
	for (i = 0; i < datasize; ++i) {
		SendInt(data[i]);
	}
}

bool GetHeader() {
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

int GetInt() {
 	int data = 0;
	char byte = 0;
	int i = 0;
	for (i = 0; i < 4; ++i){
		data |= (ReceiveCharBlock(uart) << (i*8));
	}
	return data;
}

void SendInt(int data) {
	int i = 0;
	for (i = 0; i < 4; ++i){
		SendCharBlock(uart,(char)data);
		data = data >> 8;
	}
}

