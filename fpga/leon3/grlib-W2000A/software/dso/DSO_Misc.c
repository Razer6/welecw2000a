
#include "DSO_Misc.h"
#include "DSO_Main.h"

static int snoopen;

void WaitMs(const unsigned int ms){
	const unsigned int x   = FIXED_CPU_FREQUENCY/4000;/* 1;*/
	volatile unsigned int i = 0;
	volatile unsigned int j = 0;
	for(i;i< ms; ++i){
		for(j = 0; j < x; ++j);
	}
}

/* This functions are written as a work around for volatile compiler bugs.
 * TODO: They must be prooven for each compiler version to work! */
volatile int WaitUntilMaskedAndZero(volatile int * volatile addr, int mask){
	volatile int temp;
	volatile int i = 0;	
	while(1) {
		temp = loadmem((int)addr);
		if ((temp & mask) == 0){
			return ++i;
		}
		i++;
	}
	return i;
}

volatile int WaitUntilMaskedAndNotZero(volatile int * volatile addr, int mask){
	volatile int temp;
	volatile int i = 0;	
	while(1) {
		temp = loadmem((int)addr);
		if ((temp & mask) != 0){
			return ++i;
		}
		i++;
	}
	return i;
}

volatile bool WaitTimeoutAndZero(volatile int * volatile addr, int mask, int timeout){
	volatile int temp;
	volatile int i = 0;	
	for(i = 0; i < timeout; ++i) {
		temp = loadmem((int)addr);
		if ((temp & mask) == 0){
			return true;
		}
		i++;
	}
	return false;
}

volatile bool WaitTimeoutAndNotZero(volatile int * volatile addr, int mask, int timeout){
	volatile int temp;
	volatile int i = 0;	
	for(i = 0; i < timeout; ++i) {
		temp = loadmem((int)addr);
		if ((temp & mask) != 0){
			return true;
		}
		i++;
	}
	return false;
}



inline int loadmem(volatile int addr)
{
  volatile int tmp;        
  if (snoopen) {
    asm volatile (" ld [%1], %0 "
      : "=r"(tmp)
      : "r"(addr)
    );
  } else {
    asm volatile (" lda [%1]1, %0 "
      : "=r"(tmp)
      : "r"(addr)
    );
  }
  return tmp;
}

inline char loadb(volatile int addr)
{
  volatile char tmp;        
  if (snoopen) {
    asm volatile (" ldub [%1], %0 "
      : "=r"(tmp)
      : "r"(addr)
    );
  } else {
    asm volatile (" lduba [%1]1, %0 "
      : "=r"(tmp)
      : "r"(addr)
    );
  }
  return tmp;
}	

