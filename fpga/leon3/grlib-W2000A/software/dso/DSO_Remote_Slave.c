
#include "DSO_Main.h"
#include "DSO_Misc.h"
#include "DSO_SignalCapture.h"
#include "Leon3Uart.h"
#include "DSO_Remote.h"
#include "DSO_Remote_Slave.h"
#include "crc.h"

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
	while(1){
		ReceiveHeader(uart,DSO_REC_HEADER,0),
		GetTask();		
	}
}

typedef struct {
	unsigned int cmd;
	unsigned int NoCh;
	SetAnalog data[4];
} xAnalog;

bool GetTask() {
	unsigned int i = 0;
	unsigned int s = GetInt(uart);
	unsigned int * addr;
	unsigned int size;
	switch (s) {
		case SET_TRIGGER_INPUT:
			printf("SET_TRIGGER_INPUT ");
			{
				unsigned int noCh = 		GetInt(uart);
				unsigned int SamplingSize = 	GetInt(uart);
				unsigned int SamplingFrequency= GetInt(uart);
				unsigned int AACFilterStart = 	GetInt(uart);
			 	unsigned int AACFilterStop = 	GetInt(uart);
				unsigned int Ch0 = GetInt(uart);
				unsigned int Ch1 = GetInt(uart);
				unsigned int Ch2 = GetInt(uart);
				unsigned int Ch3 = GetInt(uart);
				printf("Channels = %d \n",noCh);
				unsigned int data[] ={
					s, noCh, SamplingSize, SamplingFrequency,
					AACFilterStart,AACFilterStop,Ch0,Ch1,Ch2,Ch3};
			        if (CheckCRC(GetInt(uart), data, sizeof(data))!= true){
					SendCRCError(uart);
					return false;
				}


				if(SetTriggerInput(	noCh, SamplingSize, SamplingFrequency,
							FIXED_CPU_FREQUENCY,AACFilterStart,
							AACFilterStop,Ch0,Ch1,Ch2,Ch3)
						== true ){
					SendACK(uart);
					return true;
				} else {
					SendNAK(uart);
					return false;
				}
			}
			break;

		case  SET_ANALOG_INPUT:
			printf("SET_ANALOG_INPUT ");
			{
				xAnalog Analog;
				Analog.cmd = s;
				Analog.NoCh = GetInt(uart);
				if (Analog.NoCh > 4) {
					SendNAK(uart);
					return false;
				}
				printf("%d Channels:\n",Analog.NoCh);
				for (i = 0; i < Analog.NoCh; ++i){
					Analog.data[i].myVperDiv  = GetInt(uart);
					Analog.data[i].AC         = GetInt(uart);
					Analog.data[i].DA_Offset  = GetInt(uart);
					Analog.data[i].Specific   = GetInt(uart);
					Analog.data[i].Mode       = GetInt(uart);
				}
				if (CheckCRC(GetInt(uart),(unsigned int*)&Analog,
					sizeof(int)+((Analog.NoCh)*sizeof(SetAnalog)))!= true){
					SendCRCError(uart);
					return false;
				}
				if(SetAnalogInputRange(s, Analog.data)){
					SendACK(uart);
					return true;
				} else {
					SendNAK(uart);
					return false;
				}
			}
			break;

		case SET_TRIGGER:
			printf("SET_TRIGGER\n");
			{
				const unsigned int Trigger 		= GetInt(uart);
				const unsigned int TriggerChannel 	= GetInt(uart);
				const unsigned int TriggerPrefetchSamples=GetInt(uart);
				const int  LowReference 		= GetInt(uart);
				const unsigned int  LowReferenceTime 	= GetInt(uart);
				const int HighReference 		= GetInt(uart);
				const unsigned int HighReferenceTime 	= GetInt(uart);
				unsigned int data[] = {
					s,Trigger, TriggerChannel, TriggerPrefetchSamples,
					LowReference, LowReferenceTime, HighReference, HighReferenceTime};
				if (CheckCRC(GetInt(uart), data, sizeof(data)) != true){
					SendCRCError(uart);
					return false;
				}
				if (SetTrigger(	Trigger, TriggerChannel, TriggerPrefetchSamples,
					LowReference, LowReferenceTime, HighReference, HighReferenceTime)) {
					SendACK(uart);
					return true;
				} else {
					SendNAK(uart);
					return false;
				}
			}
			break;

		case CAPTURE_DATA:
			printf("CAPTURE_DATA ");
			{
				unsigned int WaitTime =		GetInt(uart);
				unsigned int Start = 		GetInt(uart);
				unsigned int ForceFastMode = 	GetInt(uart);
				unsigned int Csize = 		GetInt(uart);
				unsigned int crc = 		GetInt(uart);
				unsigned int data[] = {s,WaitTime,Start,ForceFastMode,Csize};
				if (CheckCRC(crc, data, sizeof(data)) != true){
					SendCRCError(uart);
					return false;
				}
				if (Csize > buffer_size){
					Csize = buffer_size;
				}
				printf("WaitTime=%d Start=%d size=%d\n",WaitTime, Start, Csize);
				s = CaptureData(WaitTime,Start,ForceFastMode,Csize,buffer);
				if (s != 0) {
					if (IsFastMode() != 0){
						ForceFastMode = 1;
					}
					return SendData(uart, ForceFastMode, s, buffer);
				} else {
					SendNAK(uart);
					return false;
				}
			}
			break;

		case STORE_DWORDS:
			addr = (int*)GetInt(uart);
			size = GetInt(uart);
			buffer[0] = (int)addr;
			buffer[1] = size;
			if (size+2 > buffer_size){
				SendNAK(uart);
				return false;
			}
			for  (i = 2; i < size+2; ++i){
				buffer[i] = GetInt(uart);
			}
			if (CheckCRC(GetInt(uart),buffer, (size+2)*sizeof(int)) != true){
				SendCRCError(uart);
				return false;
			}
			for  (i = 0; i < size; ++i){
				addr[i] = buffer[i+2];
			}
			SendACK(uart);
			return true;
			break;

		case LOAD_DWORDS:
			addr = (int *)GetInt(uart);
			size = GetInt(uart);
			buffer[0] = (int)addr;
			buffer[1] = size;
			if (CheckCRC(GetInt(uart), buffer, 2*sizeof(int)) != true){
				SendCRCError(uart);
				return false;
			}
			if (size+1 > buffer_size){
				SendNAK(uart);
				return false;
			}
			for (i = 0; i < size; ++i){
				buffer[i] = addr[i];
			}
			crcInit();
			s = crcFast((unsigned char*)buffer,size*sizeof(int));
			SendData(uart, 0, size+1, buffer);
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

