#ifndef DSO_DEBUGPRINT_H
#define DSO_DEBUGPRINT_H

#include "DSO_Main.h"

typedef struct {
	void (*Target)();
	void (*ChannelsNotSupported)();
	void (*NotAvialbe)();
	void (*ToMuchPrefetchSamples)();
	void (*AnalogInputGainNotSupported)();
	void (*TriggerSettingsOutofRange)();
} Debugprint;

typedef enum {
	English,
	German
} Language;

typedef enum {
	Silent,
	PrintF
} Target;

bool InitDebugprint(Debugprint * Init, Target T, Language L);



#endif
