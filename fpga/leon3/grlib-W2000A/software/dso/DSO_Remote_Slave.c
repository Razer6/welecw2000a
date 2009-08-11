
#include "DSO_Main.h"
#include "DSO_Misc.h"
#include "DSO_SignalCapture.h"
#include "Leon3Uart.h"
#include "DSO_Remote.h"
#include "DSO_Remote_Slave.h"
#include "crc.h"

#include "stdio.h"

int * buffer;
uint32_t buffer_size;
uart_regs * uart;
bool GetTask();

void RemoteSlave(	uart_regs * comm_uart,
			const uint32_t DataSize,
			int *Data) {
	buffer = Data;
	buffer_size = DataSize;
	uart = comm_uart;
	printf("Starting with the remote control\n");
	while(1){
		ReceiveHeader(uart,DSO_REC_HEADER),
		GetTask();		
	}
}

typedef struct {
	uint32_t cmd;
	uint32_t NoCh;
	SetAnalog data[4];
} xAnalog;

bool GetTask() {
	uint32_t i = 0;
	uint32_t s = GetInt(uart);
	uint32_t * addr;
	uint32_t size;
	switch (s) {
		case SET_TRIGGER_INPUT:
		/*	printf("SET_TRIGGER_INPUT ");*/
			{
				uint32_t noCh = 		GetInt(uart);
				uint32_t SamplingSize = 	GetInt(uart);
				uint32_t SamplingFrequency= GetInt(uart);
				uint32_t AACFilterStart = 	GetInt(uart);
			 	uint32_t AACFilterStop = 	GetInt(uart);
				uint32_t Ch0 = GetInt(uart);
				uint32_t Ch1 = GetInt(uart);
				uint32_t Ch2 = GetInt(uart);
				uint32_t Ch3 = GetInt(uart);
				uint32_t CrC = GetInt(uart);
				printf("Channels = %d \n",noCh);
				printf("%d\n %d\n %d\n %d\n %d\n %d\n %d\n %d\n", SamplingSize, SamplingFrequency, AACFilterStart, AACFilterStop, Ch0, Ch1, Ch2, Ch3);
				uint32_t data[] ={
					s, noCh, SamplingSize, SamplingFrequency,
					AACFilterStart,AACFilterStop,Ch0,Ch1,Ch2,Ch3};
			        if (CheckCRC(CrC, data, sizeof(data))!= true){
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
					2*sizeof(int)+((Analog.NoCh)*sizeof(SetAnalog)))!= true){
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
				const uint32_t Trigger 		= GetInt(uart);
				const uint32_t ExtTrigger	= GetInt(uart);
				const uint32_t TriggerChannel 	= GetInt(uart);
				const uint32_t TriggerPrefetchSamples=GetInt(uart);
				const int  LowReference 		= GetInt(uart);
				const uint32_t  LowReferenceTime 	= GetInt(uart);
				const int HighReference 		= GetInt(uart);
				const uint32_t HighReferenceTime 	= GetInt(uart);
				uint32_t data[] = {
					s,Trigger, ExtTrigger, TriggerChannel, TriggerPrefetchSamples,
					LowReference, LowReferenceTime, HighReference, HighReferenceTime};
				if (CheckCRC(GetInt(uart), data, sizeof(data)) != true){
					SendCRCError(uart);
					return false;
				}
				if (SetTrigger(	Trigger, ExtTrigger, TriggerChannel, TriggerPrefetchSamples,
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
				uint32_t WaitTime =		GetInt(uart);
				uint32_t Start = 		GetInt(uart);
				uint32_t ForceFastMode = 	GetInt(uart);
				uint32_t Csize = 		GetInt(uart);
				uint32_t crc = 		GetInt(uart);
				uint32_t data[] = {s,WaitTime,Start,ForceFastMode,Csize};
				if (CheckCRC(crc, data, sizeof(data)) != true){
					SendCRCError(uart);
					return false;
				}
				if (Csize > buffer_size){
					Csize = buffer_size;
				}
				printf("WaitTime=%d Start=%d size=%d\n",WaitTime, Start, Csize);
				s = CaptureData(WaitTime,Start,ForceFastMode,Csize,buffer);
				printf("Captured %d DWORDs with FastMode = %d",s,ForceFastMode);
				if (s != 0) {
					if (IsFastMode() != 0){
						ForceFastMode = 1;
					}
					return SendCaptureData(uart, ForceFastMode, s, buffer);
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
			buffer[0] = LOAD_DWORDS;
			buffer[1] = (int)addr;
			buffer[2] = size;
			if (CheckCRC(GetInt(uart), buffer, 3*sizeof(int)) != true){
				SendCRCError(uart);
				return false;
			}
			if (size+2 > buffer_size){
				SendNAK(uart);
				return false;
			}
			buffer[0] = size;
			printf("load %d words\n", size);
			addr--;
			for (i = 1; i <= size; ++i){
				buffer[i] = addr[i];
			}
			crcInit();
			s = crcFast((unsigned char*)buffer,(size+1)*sizeof(int));
			buffer[size+1] = s;
			SendData(uart, size+2, buffer);
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

