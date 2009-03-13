#ifndef DSO_MISC_H
#define DSO_MISC_H

#include "DSO_Main.h"

struct spwregs 
{
   volatile int ctrl;
   volatile int status;
   volatile int nodeaddr;
   volatile int clkdiv;
   volatile int destkey;
   volatile int time;
   volatile int unused[2];
   volatile int dmactrl;
   volatile int rxmaxlen;
   volatile int txdesc;
   volatile int rxdesc;
};

void WaitMs(const unsigned int ms);
inline int loadmem(int addr);
inline char loadb(int addr);

#endif
