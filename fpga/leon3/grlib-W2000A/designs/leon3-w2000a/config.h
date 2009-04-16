/*
 * Automatically generated C config: don't edit
 */
#define AUTOCONF_INCLUDED
/*
 * Synthesis      
 */
#undef  CONFIG_SYN_INFERRED
#undef  CONFIG_SYN_STRATIX
#undef  CONFIG_SYN_STRATIXII
#undef  CONFIG_SYN_STRATIXIII
#undef  CONFIG_SYN_CYCLONEIII
#define CONFIG_SYN_ALTERA 1
#undef  CONFIG_SYN_AXCEL
#undef  CONFIG_SYN_PROASIC
#undef  CONFIG_SYN_PROASICPLUS
#undef  CONFIG_SYN_PROASIC3
#undef  CONFIG_SYN_UT025CRH
#undef  CONFIG_SYN_ATC18
#undef  CONFIG_SYN_ATC18RHA
#undef  CONFIG_SYN_CUSTOM1
#undef  CONFIG_SYN_EASIC90
#undef  CONFIG_SYN_IHP25
#undef  CONFIG_SYN_IHP25RH
#undef  CONFIG_SYN_LATTICE
#undef  CONFIG_SYN_ECLIPSE
#undef  CONFIG_SYN_PEREGRINE
#undef  CONFIG_SYN_RH_LIB18T
#undef  CONFIG_SYN_RHUMC
#undef  CONFIG_SYN_SPARTAN2
#undef  CONFIG_SYN_SPARTAN3
#undef  CONFIG_SYN_SPARTAN3E
#undef  CONFIG_SYN_VIRTEX
#undef  CONFIG_SYN_VIRTEXE
#undef  CONFIG_SYN_VIRTEX2
#undef  CONFIG_SYN_VIRTEX4
#undef  CONFIG_SYN_VIRTEX5
#undef  CONFIG_SYN_UMC
#undef  CONFIG_SYN_TSMC90
#undef  CONFIG_SYN_INFER_RAM
#define CONFIG_SYN_INFER_PADS 1
#undef  CONFIG_SYN_NO_ASYNC
#undef  CONFIG_SYN_SCAN
/*
 * Clock generation
 */
#undef  CONFIG_CLK_INFERRED
#undef  CONFIG_CLK_HCLKBUF
#define CONFIG_CLK_ALTDLL 1
#undef  CONFIG_CLK_LATDLL
#undef  CONFIG_CLK_PRO3PLL
#undef  CONFIG_CLK_LIB18T
#undef  CONFIG_CLK_RHUMC
#undef  CONFIG_CLK_CLKDLL
#undef  CONFIG_CLK_DCM
#define CONFIG_CLK_MUL (1)
#define CONFIG_CLK_DIV (2)
#undef  CONFIG_PCI_SYSCLK
#define CONFIG_LEON3 1
#define CONFIG_PROC_NUM (1)
/*
 * Processor            
 */
/*
 * Integer unit                                           
 */
#define CONFIG_IU_NWINDOWS (8)
#define CONFIG_IU_V8MULDIV 1
#undef  CONFIG_IU_MUL_LATENCY_2
#undef  CONFIG_IU_MUL_LATENCY_4
#define CONFIG_IU_MUL_LATENCY_5 1
#undef  CONFIG_IU_MUL_MAC
#undef  CONFIG_IU_SVT
#define CONFIG_IU_LDELAY (1)
#define CONFIG_IU_WATCHPOINTS (0)
#undef  CONFIG_PWD
#define CONFIG_IU_RSTADDR 00000
/*
 * Floating-point unit
 */
#undef  CONFIG_FPU_ENABLE
/*
 * Cache system
 */
#define CONFIG_ICACHE_ENABLE 1
#define CONFIG_ICACHE_ASSO1 1
#undef  CONFIG_ICACHE_ASSO2
#undef  CONFIG_ICACHE_ASSO3
#undef  CONFIG_ICACHE_ASSO4
#undef  CONFIG_ICACHE_SZ1
#define CONFIG_ICACHE_SZ2 1
#undef  CONFIG_ICACHE_SZ4
#undef  CONFIG_ICACHE_SZ8
#undef  CONFIG_ICACHE_SZ16
#undef  CONFIG_ICACHE_SZ32
#undef  CONFIG_ICACHE_SZ64
#undef  CONFIG_ICACHE_SZ128
#undef  CONFIG_ICACHE_SZ256
#undef  CONFIG_ICACHE_LZ16
#define CONFIG_ICACHE_LZ32 1
#undef  CONFIG_ICACHE_LRAM
#define CONFIG_DCACHE_ENABLE 1
#define CONFIG_DCACHE_ASSO1 1
#undef  CONFIG_DCACHE_ASSO2
#undef  CONFIG_DCACHE_ASSO3
#undef  CONFIG_DCACHE_ASSO4
#undef  CONFIG_DCACHE_SZ1
#define CONFIG_DCACHE_SZ2 1
#undef  CONFIG_DCACHE_SZ4
#undef  CONFIG_DCACHE_SZ8
#undef  CONFIG_DCACHE_SZ16
#undef  CONFIG_DCACHE_SZ32
#undef  CONFIG_DCACHE_SZ64
#undef  CONFIG_DCACHE_SZ128
#undef  CONFIG_DCACHE_SZ256
#undef  CONFIG_DCACHE_LZ16
#define CONFIG_DCACHE_LZ32 1
#undef  CONFIG_DCACHE_SNOOP
#define CONFIG_CACHE_FIXED 0
#undef  CONFIG_DCACHE_LRAM
/*
 * MMU
 */
#undef  CONFIG_MMU_ENABLE
/*
 * Debug Support Unit        
 */
#define CONFIG_DSU_ENABLE 1
#define CONFIG_DSU_ITRACE 1
#define CONFIG_DSU_ITRACESZ1 1
#undef  CONFIG_DSU_ITRACESZ2
#undef  CONFIG_DSU_ITRACESZ4
#undef  CONFIG_DSU_ITRACESZ8
#undef  CONFIG_DSU_ITRACESZ16
#undef  CONFIG_DSU_ATRACE
/*
 * Fault-tolerance  
 */
/*
 * VHDL debug settings       
 */
#undef  CONFIG_IU_DISAS
#undef  CONFIG_DEBUG_PC32
/*
 * AMBA configuration
 */
#define CONFIG_AHB_DEFMST (0)
#undef  CONFIG_AHB_RROBIN
#undef  CONFIG_AHB_SPLIT
#define CONFIG_AHB_IOADDR FFF
#define CONFIG_APB_HADDR 800
#define CONFIG_AHB_MON 1
#define CONFIG_AHB_MONERR 1
#define CONFIG_AHB_MONWAR 1
/*
 * Debug Link           
 */
#define CONFIG_DSU_UART 1
#undef  CONFIG_DSU_JTAG
/*
 * Peripherals             
 */
/*
 * Memory controllers             
 */
/*
 * 8/32-bit PROM/SRAM controller 
 */
#define CONFIG_SRCTRL 1
#undef  CONFIG_SRCTRL_8BIT
#define CONFIG_SRCTRL_PROMWS (3)
#define CONFIG_SRCTRL_RAMWS (2)
#define CONFIG_SRCTRL_IOWS (2)
#undef  CONFIG_SRCTRL_RMW
#define CONFIG_SRCTRL_SRBANKS1 1
#undef  CONFIG_SRCTRL_SRBANKS2
#undef  CONFIG_SRCTRL_SRBANKS3
#undef  CONFIG_SRCTRL_SRBANKS4
#undef  CONFIG_SRCTRL_SRBANKS5
#undef  CONFIG_SRCTRL_BANKSZ0
#undef  CONFIG_SRCTRL_BANKSZ1
#undef  CONFIG_SRCTRL_BANKSZ2
#undef  CONFIG_SRCTRL_BANKSZ3
#undef  CONFIG_SRCTRL_BANKSZ4
#undef  CONFIG_SRCTRL_BANKSZ5
#undef  CONFIG_SRCTRL_BANKSZ6
#undef  CONFIG_SRCTRL_BANKSZ7
#define CONFIG_SRCTRL_BANKSZ8 1
#undef  CONFIG_SRCTRL_BANKSZ9
#undef  CONFIG_SRCTRL_BANKSZ10
#undef  CONFIG_SRCTRL_BANKSZ11
#undef  CONFIG_SRCTRL_BANKSZ12
#undef  CONFIG_SRCTRL_BANKSZ13
#define CONFIG_SRCTRL_ROMASEL (19)
/*
 * Leon2 memory controller        
 */
#undef  CONFIG_MCTRL_LEON2
/*
 * On-chip RAM/ROM                 
 */
#undef  CONFIG_AHBROM_ENABLE
#undef  CONFIG_AHBRAM_ENABLE
/*
 * Ethernet             
 */
#undef  CONFIG_GRETH_ENABLE
/*
 * UARTs, timers and irq control         
 */
#define CONFIG_UART1_ENABLE 1
#define CONFIG_UA1_FIFO1 1
#undef  CONFIG_UA1_FIFO2
#undef  CONFIG_UA1_FIFO4
#undef  CONFIG_UA1_FIFO8
#undef  CONFIG_UA1_FIFO16
#undef  CONFIG_UA1_FIFO32
#define CONFIG_IRQ3_ENABLE 1
#undef  CONFIG_IRQ3_SEC
#define CONFIG_GPT_ENABLE 1
#define CONFIG_GPT_NTIM (2)
#define CONFIG_GPT_SW (8)
#define CONFIG_GPT_TW (32)
#define CONFIG_GPT_IRQ (8)
#undef  CONFIG_GPT_SEPIRQ
#undef  CONFIG_GPT_WDOGEN
/*
 * ATA Controller
 */
#undef  CONFIG_ATA_ENABLE
/*
 * Keybord and VGA interface
 */
#undef  CONFIG_KBD_ENABLE
#undef  CONFIG_VGA_ENABLE
#define CONFIG_SVGA_ENABLE 1
/*
 * Gleichmann Options        
 */
#undef  CONFIG_AHB2HPI_ENABLE
#undef  CONFIG_DAC_AHB_ENABLE
/*
 * DSO W2000 Special Function Register
 */
#define CONFIG_DSO_ENABLE 1
#define CONFIG_DSO_PLATTFORM (2022)
#define CONFIG_DSO_CHANNELS (2)
#define CONFIG_DSO_SAMPLING_FREQUENCY (1000000000)
#define CONFIG_DSO_INPUT_BIT_WIDTH (8)
#define CONFIG_DSO_TRIGGER_DATA_SIZE (16)
/*
 * VHDL Debugging        
 */
#define CONFIG_DEBUG_UART 1
