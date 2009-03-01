
// Access Test of the DSO specific registers!
#include <stdlib.h>
#include <stdio.h>
#include "grcommon.h"
#include "DSO_SignalCapture.h"
#include "DSO_Debugprint.h"

Debugprint Print;

int main () {
	int CurrDevice;
	InitDebugprint(&Print,PrintF,English);
	//printf("Access Test of the DSO specific registers!\n");
	Print.Target();

	
	return 0;
}


