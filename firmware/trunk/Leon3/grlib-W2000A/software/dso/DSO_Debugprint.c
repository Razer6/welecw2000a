

#include <stdlib.h>
#include <stdio.h>
#include "DSO_Debugprint.h"
#include "DSO_SFR.h"

#define printf printfdummy

void printfdummy(char * str){}

void TargetSilent() {}

void En_PrintfTarget() {
	int * CurrDevice = (int*)DEVICEADDR;
	printf("The current target board is ");
	switch (*CurrDevice) {
		case WELEC2012 : printf("WELEC2012A "); break;
		case WELEC2014 : printf("WELEC2014A "); break;
		case WELEC2022 : printf("WELEC2022A "); break;
		case WELEC2024 : printf("WELEC2022A "); break;
		case SANDBOXX  : printf("SandboxX ");   break;
		default        : printf("Unknown TODO: add it to DSO_SFR.h! "); break;
	}
	printf("\n");
}

void En_PrintfChannelsNotSupported(){
	printf("At least one channel is not supported!\n");
}

void En_PrintfNotAvialbe(){
	printf("Configuration not available!\n");
}

void En_PrintfToMuchPrefetchSamples(){
	printf("The prefetch size must be shorter than the signal capture buffer size!\n");
}

void En_PrintfAnalogInputGainNotSupported(){
	printf("The AnalogInputGain is not supported at the moment!\n");
}

void En_PrintfTriggerSettingsOutofRange(){
	printf("Trigger settings out of range!\n");
}

bool InitDebugprint (Debugprint * Init, Target T, Language L){
	//TODO: switch(T), switch(L) ...
	(*Init).Target                      = &En_PrintfTarget;
	(*Init).ChannelsNotSupported        = &En_PrintfChannelsNotSupported;
	(*Init).NotAvialbe                  = &En_PrintfNotAvialbe;
	(*Init).ToMuchPrefetchSamples       = &En_PrintfToMuchPrefetchSamples;
	(*Init).AnalogInputGainNotSupported = &En_PrintfAnalogInputGainNotSupported;
	(*Init).TriggerSettingsOutofRange   = &En_PrintfTriggerSettingsOutofRange;
}
