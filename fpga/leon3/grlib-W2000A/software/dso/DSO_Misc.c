
#include "DSO_Misc.h"
#include "DSO_Main.h"

static int snoopen;

void WaitMs(const unsigned int ms){
	const unsigned int x   = FIXED_CPU_FREQUENCY/4000;
	volatile unsigned int i = 0;
	volatile unsigned int j = 0;
	for(i;i< ms; ++i){
		for(j = 0; j < x; ++j);
	}
}

inline int loadmem(int addr)
{
  int tmp;        
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

inline char loadb(int addr)
{
  char tmp;        
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

