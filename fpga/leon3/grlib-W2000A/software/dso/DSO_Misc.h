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

/* This functions are written as a work around for volatile compiler bugs.
 * TODO: They must be prooven for each compiler version to work! */
volatile int WaitUntilMaskedAndZero   (volatile int * volatile addr, int mask);
volatile int WaitUntilMaskedAndNotZero(volatile int * volatile addr, int mask);

/* timeout is just an integer, these are not ms! 
 * exits with false on timeout */
volatile bool WaitTimeoutAndZero   (volatile int * volatile addr, int mask, int timeout);
volatile bool WaitTimeoutAndNotZero(volatile int * volatile addr, int mask, int timeout);

inline int loadmem(volatile int addr);
inline char loadb(volatile int addr);

#endif
