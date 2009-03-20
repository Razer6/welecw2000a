

#include "stdio.h"
#include "string.h"
#include "WaveFilePackage.h"
#include "DSO_Remote_Master.h"
#include "argtable2.h"

#define DSO_NAK_MESSAGE "At least one argument was not accepted from the target!\n"

int CheckArgCount (	const struct arg_lit * 	IsX[], 
			const int		count,
			const int		size){ 
	int i = 0;
	int nerrors = 0;
	for(i = 0; i < size; ++i){
		if (IsX[i]->count != count){
			printf("With Command=TriggerInput also %d %s argument is/are needed!\n", count, IsX[i]->hdr.longopts);
			nerrors++;		
		}
	}
	if (nerrors != 0){
		return false;
	}
	return true;
}	

int main(int argc, char * argv[]) {
	struct arg_str * UartAddr	= arg_str1("u", "UART", NULL, "Path of serial device");
	struct arg_str * Command	= arg_str1("c", "Command",
			"TriggerInput,Trigger,AnalogSettings,Capture,ForceRegs,ReadRegs", 
			"DSO call type");
	struct arg_str * Trigger	= arg_str0(NULL,"TrType","ExtLH,ExtHL,SchmittLH,SchmittHL","Trigger type");
	struct arg_str * AnSrc2Ch0		= arg_str0(NULL,"AnSrc2Ch1","none,pwm,gnd,lowpass", 
					"none, PWM offset, GND, lowpass");
	struct arg_str * AnSrc2Ch1		= arg_str0(NULL,"AnSrc2Ch2","none,pwm,gnd,lowpass", 
					"none, PWM offset, GND, lowpass");
	struct arg_str * AnSrc2Ch2		= arg_str0(NULL,"AnSrc2Ch3","none,pwm,gnd,lowpass", 
					"none, PWM offset, GND, lowpass");
	struct arg_str * AnSrc2Ch3		= arg_str0(NULL,"AnSrc2Ch4","none,pwm,gnd,lowpass", 
					"none, PWM offset, GND, lowpass");
	struct arg_int * Channels	= arg_int1("n","Channels",	"<n>",	"Number of channels");
	struct arg_int * SampleSize	= arg_int0(NULL,"SampleSize",	"<n>",	"Bits per sample"); 
	struct arg_int * SampleFS	= arg_int0(NULL,"Fs",		"<n>",	"Sampling frequency"); 
	struct arg_int * AACFilterStart	= arg_int0(NULL,"AACStart",	"<n>",	"Polyphase decimator start"); 
	struct arg_int * AACFilterEnd	= arg_int0(NULL,"AACEnd",	"<n>",	"Polyphase decimator end"); 
	struct arg_int * Ch0Src		= arg_int0(NULL,"CH1",		"<n>",	"Channel 1 source"); 
	struct arg_int * Ch1Src		= arg_int0(NULL,"CH2",		"<n>",	"Channel 2 source"); 
	struct arg_int * Ch2Src		= arg_int0(NULL,"CH3",		"<n>",	"Channel 3 source"); 
	struct arg_int * Ch3Src		= arg_int0(NULL,"CH4",		"<n>",	"Channel 4 source"); 
	struct arg_int * TriggerChannel = arg_int0(NULL,"TrCh",		"<n>",	"Trigger Channel"); 
	struct arg_int * TrPrefetch	= arg_int0(NULL,"TrPrSamples",	"<n>",	"Trigger prefetch samples/8");
	struct arg_int * TriggerLowRef	= arg_int0(NULL,"TrLowRef",	"<n>",	"Trigger low level  (integer!)"); 
	struct arg_int * TriggerHighRef	= arg_int0(NULL,"TrHighRef",	"<n>",	"Trigger high level (integer!)"); 
	struct arg_int * TriggerLowTime	= arg_int0(NULL,"TrLowSt",	"<n>",	"Trigger low stable (samples/8)"); 
	struct arg_int * TriggerHighTime= arg_int0(NULL,"TrHighSt",	"<n>",	"Trigger high stable (samples/8)"); 
	struct arg_int * AnGainCh0	= arg_int0(NULL,"AnGainCh1",	"<n>",	"Analog input gain"); 
	struct arg_int * AnGainCh1	= arg_int0(NULL,"AnGainCh2",	"<n>",	"Analog input gain"); 
	struct arg_int * AnGainCh2	= arg_int0(NULL,"AnGainCh3",	"<n>",	"Analog input gain"); 
	struct arg_int * AnGainCh3	= arg_int0(NULL,"AnGainCh4",	"<n>",	"Analog input gain"); 
	struct arg_int * AnDA_OffsetCh0	= arg_int0(NULL,"An_OffCh1", 	"<n>",	"Analog offset Ch1 (integer!)"); 
	struct arg_int * AnDA_OffsetCh1	= arg_int0(NULL,"An_OffCh2", 	"<n>",	"Analog offset Ch2 (integer!)"); 
	struct arg_int * AnDA_OffsetCh2	= arg_int0(NULL,"An_OffCh3", 	"<n>",	"Analog offset Ch3 (integer!)"); 
	struct arg_int * AnDA_OffsetCh3	= arg_int0(NULL,"An_OffCh4", 	"<n>",	"Analog offset Ch4 (integer!)"); 
	struct arg_int * AnPWM 		= arg_int0(NULL,"An_Offset2",	"<n>",	"Analog offset from PWM"); 
	struct arg_int * ForceAddr	= arg_int0(NULL,"Faddr",	"<n>",	"DSO CPU address of data"); 
	struct arg_int * ForceSize	= arg_int0(NULL,"Fsize",	"<n>",	"Size of direct CPU address data"); 
	struct arg_int * CapWTime	= arg_int0(NULL,"CapWaitTime",	"<n>",	"Abourt time, before recording"); 
	struct arg_int * CapSize	= arg_int0(NULL,"CapSize",	"<n>",	"Capture data size in Dwords"); 
	struct arg_int * WavForceFS	= arg_int0(NULL,"WavForcefs",	"<n>",	"Set sampling fs to x istead of Fs");
	struct arg_lit * AnAC_Ch0	= arg_lit0(NULL,"ACModeCh1",		"AC Mode, if not set AC=off"); 
	struct arg_lit * AnAC_Ch1	= arg_lit0(NULL,"ACModeCh2",		"AC Mode, if not set AC=off"); 
	struct arg_lit * AnAC_Ch2	= arg_lit0(NULL,"ACModeCh3",		"AC Mode, if not set AC=off"); 
	struct arg_lit * AnAC_Ch3	= arg_lit0(NULL,"ACModeCh4",		"AC Mode, if not set AC=off");
	struct arg_file * ForceFile	= arg_file0(NULL,"Ffile","<file>",	"Binary file for the direct DSO CPU access");
	struct arg_file * WaveFile	= arg_file0("o","WFile","<file>",	"Record data to this file");
	struct arg_int * BaudRate	= arg_int1("b", "BAUD",		"<n>",	"serial device baudrate");
	struct arg_lit * help		= arg_lit0("hH","help",			"Displays this help information");
	struct arg_end * end = arg_end(20);
	void * argtable[] = {
	Command,Channels,SampleSize,SampleFS,AACFilterStart,
	AACFilterEnd,Ch0Src,Ch1Src,Ch2Src,Ch3Src,
	Trigger,TrPrefetch,TriggerChannel,TriggerLowRef,TriggerHighRef,
	TriggerLowTime,TriggerHighTime,AnGainCh0,AnGainCh1,AnGainCh2,
	AnGainCh3,AnAC_Ch0,AnAC_Ch1,AnAC_Ch2,AnAC_Ch3,
	AnDA_OffsetCh0,AnDA_OffsetCh1,AnDA_OffsetCh2,AnDA_OffsetCh3,
	AnPWM,AnSrc2Ch0,AnSrc2Ch1,AnSrc2Ch2,AnSrc2Ch3,ForceAddr,
	ForceSize,ForceFile,CapWTime,CapSize,WavForceFS,
	WaveFile,UartAddr,BaudRate,help,end};

	uart_regs * huart = 0; /* uart handle */
	int nerrors = arg_parse(argc,argv,argtable);
       	if (nerrors != 0) {
		arg_print_errors(stdout,end,argv[0]);
		arg_print_syntax(stdout,argtable,"");
		arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
		return 1;
	}	
	if (help->count != 0){
		arg_print_syntax(stdout,argtable,"");
	}
	if (!UartInit(UartAddr->sval[0],BaudRate->ival[0],huart)){
		return 5;
	}
	if (strcmp("TriggerInput",Command->sval[0]) == 0){
		struct arg_int * IsOnce[] = {
			Channels,SampleSize,SampleFS,AACFilterStart,AACFilterEnd,
			Ch0Src,Ch1Src,Ch2Src,Ch3Src};
		
		bool Ret = CheckArgCount(IsOnce,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		if (Ret == false) {
			arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
			return 2;
		}	
		Ret = SendTriggerInput(huart,
				Channels->ival[0],
				SampleSize->ival[0],
				SampleFS->ival[0],
				AACFilterStart->ival[0],
				AACFilterEnd->ival[0],
				Ch0Src->ival[0],
				Ch1Src->ival[0],
				Ch2Src->ival[0],
				Ch3Src->ival[0]);
		arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
		if (Ret == true){
			return 0;
		 } else {
			printf(DSO_NAK_MESSAGE); 
			return 3;
		 }			
	}

	if (strcmp("Trigger",Command->sval[0]) == 0){
		struct arg_int * IsOnce[] = {
			Trigger,TrPrefetch,TriggerChannel,TriggerLowRef,TriggerHighRef,
			TriggerLowTime,TriggerHighTime};
		int TriggerNo = 2;
		bool Ret = CheckArgCount(IsOnce,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		if (Ret == false) {
			arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
			return 2;
		}	
		if (strcmp("ExtLH",Trigger->sval[0]) == 0){
			TriggerNo = 0;
		}
		if (strcmp("ExtHL",Trigger->sval[0]) == 0){
			TriggerNo = 1;
		}
		if (strcmp("SchmittLH",Trigger->sval[0]) == 0){
			TriggerNo = 2;
		}
		if (strcmp("SchmittHL",Trigger->sval[0]) == 0){
			TriggerNo = 3;
		}
		Ret = SendTrigger(huart,
				TriggerNo,
				TrPrefetch->ival[0],
				TriggerChannel->ival[0],
				TriggerLowRef->ival[0],
				TriggerHighRef->ival[0],
				TriggerLowTime->ival[0],
				TriggerHighTime->ival[0]);
		arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
		if (Ret == true){
			return 0;
		} else {
			printf(DSO_NAK_MESSAGE); 
			return 3;
		}			
	}
	if (strcmp("AnalogSettings",Command->sval[0]) == 0){
		struct arg_int * IsOnce[] = {
			AnGainCh0,AnGainCh1,AnGainCh2,AnGainCh3,AnDA_OffsetCh0,
			AnDA_OffsetCh1,AnDA_OffsetCh2,AnDA_OffsetCh3,AnPWM,AnSrc2Ch0,
			AnSrc2Ch1,AnSrc2Ch2,AnSrc2Ch3};
		int Trigger = 2;
		int i = 0;
		SetAnalog Settings[4];
		struct arg_int * Gain[4] = {AnGainCh0,AnGainCh1,AnGainCh2,AnGainCh3};
		struct arg_lit * AC[4]   = {AnAC_Ch0,AnAC_Ch1,AnAC_Ch2,AnAC_Ch3};
		struct arg_int * DAoff[4]= {AnDA_OffsetCh0,AnDA_OffsetCh1,AnDA_OffsetCh2,AnDA_OffsetCh3};	
		struct arg_str * Src2[4] = {AnSrc2Ch0,AnSrc2Ch1,AnSrc2Ch2,AnSrc2Ch3}; 
		bool Ret = CheckArgCount(IsOnce,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		if (Ret == false) {
			arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
			return 2;
		}
		for (i = 0; i < Channels->ival[0]; ++i) {
			Settings[i].myVperDiv 	= Gain[i]->ival[0];
			Settings[i].AC 		= AC[i]->count;
			Settings[i].DA_Offset	= DAoff[i]->ival[0];
			Settings[i].PWM_Offset	= AnPWM->ival[0];
			Settings[i].Mode = 0;
			if (strcmp("pwm",Src2[i]->sval[0]) == 0){
					Settings[i].Mode = 1;
			}
			if (strcmp("gnd",Src2[i]->sval[0]) == 0){
					Settings[i].Mode = 2;
			}
			if (strcmp("lowpass",Src2[i]->sval[0]) == 0){
					Settings[i].Mode = 3;
			}
		}	
		Ret = SendAnalogInput(huart,Channels->ival[0], Settings);
		arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
		if (Ret == true){
			return 0;
		} else {
			printf(DSO_NAK_MESSAGE); 
			return 3;
		}			
	}
	if (strcmp("Capture",Command->sval[0]) == 0){
		struct arg_int * IsOnce[] = {
			Channels,SampleSize,SampleFS,CapWTime,CapSize,
			WavForceFS,WaveFile};
		
		bool Ret = CheckArgCount(IsOnce,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		int * buffer = (int*)malloc(CapSize->ival[0]*sizeof(int));
		int FastMode = 0;
		if (buffer == 0){
			printf("Not enough memory aviable!\n");
			arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
		}
		if (Ret == false) {
			arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
			return 2;
		}	
		Ret = ReceiveSamples(huart, 
				CapWTime->ival[0],
				1,
				CapSize->ival[0],
				&FastMode,
				buffer);
		
		if (Ret == true){
			FILE * Handle;
			aWaveFileInfo FileInfo = {
				(short)SampleSize->ival[0],
				Channels->ival[0],
				CapSize->ival[0],
				SampleFS->ival[0]};

			Ret = OpenWaveFileWrite(WaveFile->filename[0],Handle,FileInfo);
			if (Ret == false){
				arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
				free(buffer);
				return 4;
			}
			/* one Dword = 32 bit 
			 * 4Ch: one sample = 8 bit 
			 * 2Ch: one sample may be 8 or 16 bit, if they are 8 bit,
			 * take care about the capture mode (normal of fast)
			 * 1Ch: one sample may be 8,16 or 32 bit, if they are not 32 bit 
			 * also take care about the capture mode (normal of fast)*/
			if (FastMode != 0){
				switch (Channels->ival[0]) {
					case 1:
						switch (SampleSize->ival[0]){
							case 8:  FastRecord1Ch8Bit(Handle,FileInfo,buffer);
								break;
							case 16: FastRecord1Ch16Bit(Handle,FileInfo,buffer);
								break;
							case 32: RecordNormal(Handle,FileInfo,buffer);
								break;
						}
						break;
					case 2:
						switch (SampleSize->ival[0]){
							case 8:  FastRecord2Ch8Bit(Handle,FileInfo,buffer); 
								break;
							case 16: RecordNormal(Handle,FileInfo,buffer);
								break;
						}
						break;
					case 4: RecordNormal(Handle,FileInfo,buffer);
						break;
				}
			} else {
				RecordNormal(Handle,FileInfo,buffer);
			}
			fclose(Handle);
			free(buffer);
			buffer = 0;
			arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
			return 0;
		 } else {
			printf(DSO_NAK_MESSAGE); 
			arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
			return 3;
		 }			
	}

	arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
	return 0;
}
