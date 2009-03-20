
#include "DSO_Main.h"
#include "DSO_Misc.h"
#include "DSO_SignalCapture.h"
#include "Leon3Uart.h"
#include "DSO_Remote.h"
#include "DSO_Remote_Slave.h"


int * buffer;
unsigned int buffer_size;
uart_regs * uart;
bool GetTask();

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
	unsigned int s = GetInt(uart);
	static unsigned int SamplingFrequency = 10000;
	int * addr;
	int data;
	unsigned int size;

	switch (s) {
		case SET_TRIGGER_INPUT:
			{
				unsigned int noCh = GetInt(uart);
				unsigned int SamplingSize = GetInt(uart);
				SamplingFrequency = GetInt(uart);			
				if(SetTriggerInput(	noCh, SamplingSize, SamplingFrequency,
							GetInt(uart),GetInt(uart),GetInt(uart),
							GetInt(uart),GetInt(uart),GetInt(uart),
							GetInt(uart))){
					SendACK(uart);
				} else {
					SendNAK(uart);
					return false;
				}
			}
			break;

		case  SET_ANALOG_INPUT:
			s = GetInt(uart);
			if (s > 4) {
				SendNAK(uart);
				return false;
			}
			for (i = 0; i < s; ++i){
				Analog[i].myVperDiv  = GetInt(uart);
				Analog[i].AC         = GetInt(uart);
				Analog[i].DA_Offset  = GetInt(uart);
				Analog[i].PWM_Offset = GetInt(uart);
			}
			if(SetAnalogInputRange(s, Analog)){
				SendACK(uart);
			} else {
				SendNAK(uart);
				return false;
			}
			break;

		case SET_TRIGGER:
			if (SetTrigger(	GetInt(uart), GetInt(uart), GetInt(uart), GetInt(uart), GetInt(uart),
					GetInt(uart), GetInt(uart))) {
				SendACK(uart);
			} else {
				SendNAK(uart);
				return false;
			}
			break;
		case CAPTURE_DATA:
			{
				unsigned int WaitTime = GetInt(uart);
				unsigned int Start = GetInt(uart);
				unsigned int Csize = GetInt(uart);
				if (Csize > buffer_size){
					Csize = buffer_size;
				}
				if(s = CaptureData(WaitTime,Start,Csize,buffer,
						512,FIXED_CPU_FREQUENCY, SamplingFrequency)){
					return SendData(s, buffer);
				} else {
					SendNAK(uart);
					return false;
				}
			}
			break;

		case STORE_DWORDS:
			addr = (int *)GetInt(uart);
			size = GetInt(uart);
			if (size > buffer_size){
				SendNAK(uart);
				return false;
			}
			for  (i = 0; i < size; ++i){
				addr[i] = GetInt(uart);
			}
			SendACK(uart);
			break;

		case LOAD_DWORDS:
			addr = (int *)GetInt(uart);
			size = (int *)GetInt(uart);
			if (size > buffer_size){
				SendNAK(uart);
				return false;
			}
			for (i = 0; i < size; ++i){
				buffer[i] = addr[i];
			}
			SendData(uart, size, buffer);
			break;
				
		default:
			SendNAK(uart);
			return false;
			break;
	}
	return true;
}

