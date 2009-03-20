#ifndef DSO_MAIN_H 
#define DSO_MAIN_H

#include "types.h"

/* as long as we are not officiell supported on the leon3 grlib*/
/* these defines belong to here an not in grcommon.h*/
/* The DSO is set under the vendor FH Hagenberg, because I made*/
/* the VHDL part as master thesis there*/
#define VENDOR_FHH 	      0x18
/* important devices from VENDOR_FHH*/
#define FHH_DSO_SFR           0x02
#define FHH_DSO_SIGNALACCESS  0x16

/* the internal ROM will be replaced some times, when the */
/* new implementation is better than the old one*/
#define ROM_BASE_ADDR 0x00000000
#define ROM_SIZE      0x00800000

#define RAM_BASE_ADDR_UNCACHED_MIRROR  0x20000000
#define RAM_BASE_ADDR                  0x40000000
#define RAM_SIZE                       0x00200000

#define VGA_FRAMEBUFFER_BASE_ADDR      (0x20200000-(640*480))

#define TRIGGER_MEM_BASE_ADDR          0xa0000000
#define TRIGGER_MEM_SIZE               0x00008000

#define DSO_SFR_BASE_ADDR              0x80000500

/* The CPU frequency must be set correctly or the function CaptureData gets sometimes crasy!*/
#define FIXED_CPU_FREQUENCY  31250000
/*int return SamplingFrequency/(CPUFrequency*FASTMODEFACTOR);*/
#define FASTMODEFACTOR       10
#define COIL_SWITCH_TIME     100

/* base addresses of the grip components*/
#define DSU_BASE_ADDR            0x90000000
#define DSU_MEM_SIZE             0x10000000

#define AHB_APB_BRIDE_BASE_ADDR  0x80000000
#define APB_MEM_SIZE             0x00100000

#define MEM_CONTROL_BASE_ADDR    0x80000000
#define GENERIC_UART_BASE_ADDR   0x80000100
#define INTERRUPT_CTL_BASE_ADDR  0x80000200
#define TIMER_BASE_ADDR          0x80000300
#define DEBUG_UART_BASE_ADDR     0x80000700 

#endif
