
#include "DSO_Main.h"
#include "DSO_Misc.h"
#include "DSO_SignalCapture.h"
#include "Leon3Uart.h"
#include "DSO_Remote.h"
#include "DSO_Remote_Slave.h"

#include "stdio.h"

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
	printf("Starting with the remote control\n");
	while(ReceiveHeader(uart)){
		GetTask();		
	}
}

bool GetTask() {
	unsigned int i = 0;
	SetAnalog Analog[4];
	unsigned int s = GetInt(uart);
	static unsigned int SamplingFrequency = 10000;
	int * addr;
/*	int data; */
	unsigned int size;
	printf("\nGetTask: ");
	switch (s) {
		case SET_TRIGGER_INPUT:
			printf("SET_TRIGGER_INPUT ");
			{
				unsigned int noCh = GetInt(uart);
				printf("%d ",noCh);
				unsigned int SamplingSize = GetInt(uart);
				printf("%d ",SamplingSize);
				SamplingFrequency = GetInt(uart);
				printf("%d ",SamplingFrequency);
				unsigned int AACFilterStart = GetInt(uart);
				printf("%d ",AACFilterStart);
			 	unsigned int AACFilterStop = GetInt(uart);
				printf("%d ",AACFilterStop);
				unsigned int Ch0 = GetInt(uart);
				printf("%d ",Ch0);
				unsigned int Ch1 = GetInt(uart);
				printf("%d ",Ch1);
				unsigned int Ch2 = GetInt(uart);
				printf("%d ",Ch2);
				unsigned int Ch3 = GetInt(uart);
				printf("%d ",Ch3);		
				if(SetTriggerInput(	noCh, SamplingSize, SamplingFrequency,
							FIXED_CPU_FREQUENCY,AACFilterStart,
							AACFilterStop,Ch0,Ch1,Ch2,Ch3)
						== true ){
					printf("SET_TRIGGER_INPUT succ\n");
					SendACK(uart);
					printf("SET_TRIGGER_INPUT succ\n");
					return true;
				} else {
					SendNAK(uart);
					printf("SET_TRIGGER_INPUT failed\n");
					return false;
				}
			}
			break;

		case  SET_ANALOG_INPUT:
			printf("SET_ANALOG_INPUT ");
			s = GetInt(uart);
			if (s > 4) {
				SendNAK(uart);
				return false;
			}
			printf("%d Channels:\n",s);
			for (i = 0; i < s; ++i){
				Analog[i].myVperDiv  = GetInt(uart);
				Analog[i].AC         = GetInt(uart);
				Analog[i].DA_Offset  = GetInt(uart);
				Analog[i].PWM_Offset = GetInt(uart);
				Analog[i].Mode       = GetInt(uart);
			/*	printf("Ch %d: %d myV/Div ACMode=%d DA_Offset=%d PWM_Offset=%d\n",
					i, Analog[i].myVperDiv, Analog[i].AC, 
					Analog[i].DA_Offset, Analog[i].PWM_Offset);*/
			}
			if(SetAnalogInputRange(s, Analog)){
				SendACK(uart);
				return true;
			} else {
				SendNAK(uart);
				return false;
			}
			break;

		case SET_TRIGGER:
			printf("SET_TRIGGER\n");

			if (SetTrigger(	GetInt(uart), GetInt(uart), GetInt(uart), GetInt(uart), 
					GetInt(uart), GetInt(uart), GetInt(uart))) {
				SendACK(uart);
				return true;
			} else {
				SendNAK(uart);
				return false;
			}
			break;

		case CAPTURE_DATA:
			printf("CAPTURE_DATA ");
			{
				unsigned int WaitTime = GetInt(uart);
				unsigned int Start = GetInt(uart);
				unsigned int Csize = GetInt(uart);
				if (Csize > buffer_size){
					Csize = buffer_size;
				}
				printf("WaitTime=%d Start=%d size=%d\n",WaitTime, Start, Csize);
				if(s = CaptureData(WaitTime,Start,Csize,buffer,
						512,FIXED_CPU_FREQUENCY, SamplingFrequency)){
					return SendData(uart, s, buffer);
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
			return true;
			break;

		case LOAD_DWORDS:
			addr = (int *)GetInt(uart);
			size = GetInt(uart);
			if (size > buffer_size){
				SendNAK(uart);
				return false;
			}
			for (i = 0; i < size; ++i){
				buffer[i] = addr[i];
			}
			SendData(uart, size, buffer);
			return true;
			break;
				
		default:
			printf("Unknown task %d", s);
			SendNAK(uart);
			return false;
			break;
	}
	return true;
}

