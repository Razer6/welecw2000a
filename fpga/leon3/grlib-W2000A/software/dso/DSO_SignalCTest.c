#include <stdlib.h>
#include <stdio.h>
#include "grcommon.h"
#include "DSO_SignalCapture.h"
#include "DSO_Debugprint.h"

#define CAPTURESIZE 32786
int main () {
	int ReadData = 0;
	int Data[CAPTURESIZE];
	Debugprint * Debug;
/*	printf("Starting SFR Test\n");*/
	InitSignalCapture(Debug,PrintF,English);
/*	SetTriggerInput(4,8,100000000,FIXED_CPU_FREQUENCY,0,1,2,3);*/
	SetTrigger(2,0,64,-16,3,16,3);
/*	SetAnalogInputRange(10000,10000,10000,10000);*/
	ReadData = CaptureData(1000000, true, CAPTURESIZE, Data, 512, 1000000000, FIXED_CPU_FREQUENCY);
/*	printf("End SFR Test\n");*/
	return 0;
}
