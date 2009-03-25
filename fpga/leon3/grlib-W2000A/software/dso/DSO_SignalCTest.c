#include <stdlib.h>
#include <stdio.h>
#include "grcommon.h"
#include "DSO_SignalCapture.h"
#include "DSO_Debugprint.h"

#define CAPTURESIZE (32786*2)
#define FASTFS 500000000
#define SLOWFS    500000
int main () {
	int ReadData = 0;
	int Data[CAPTURESIZE];
	SetAnalog Analog[2];
	Analog[0].myVperDiv = 100000;
	Analog[0].AC = 0;
	Analog[0].Mode = normal;
	Analog[0].DA_Offset = 0xaa;
	Analog[0].PWM_Offset = 0xf1;
	Analog[1].myVperDiv = 100000;
	Analog[1].AC = 1;
	Analog[1].Mode = normal;
	Analog[1].DA_Offset = 0xf1;
	Analog[1].PWM_Offset = 0xf1;
	Debugprint * Debug;
/*	printf("Starting SFR Test\n");*/
	InitSignalCapture(Debug,PrintF,English);

	SetTriggerInput(2,8,FASTFS,FIXED_CPU_FREQUENCY,0,2,0,1,2,3);
	SetTrigger(2,0,64,-16,3,16,3);
	SetAnalogInputRange(2,Analog);
	ReadData = CaptureData(1000000, true, CAPTURESIZE, Data, 512, FASTFS, FIXED_CPU_FREQUENCY);

	SetTriggerInput(2,16,SLOWFS,FIXED_CPU_FREQUENCY,0,2,0,1,2,3);
	ReadData = CaptureData(1000000, true, CAPTURESIZE, Data, 512,    1000000, FIXED_CPU_FREQUENCY);
/*	printf("End SFR Test\n");*/
	return 0;
}
