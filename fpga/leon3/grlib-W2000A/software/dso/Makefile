DSOPATH=$(GRLIB)/software/dso
BOOTOPT= -msoft-float -lsmall -Os 
#BOOTOPT= -msoft-float
XCC=sparc-elf-gcc -I$(GRLIB)/software/leon3 -I$(DSOPATH) 
XAS=sparc-elf-gcc -c -I. -I$(GRLIB)/software/leon3 -I$(DSOPATH)
MKPROMOPT= -v -freq=63  -stack 0x401C7C00 -ramsize 2048 -ramcs 1 -rmw -romws 1 -romsize 8192 -bdinit

TINYFLAGS= -msoft-float -nostdlib  -nostartfiles
TX= -Tlinkprom -N -L./ -Ttext=0

DSOSRC= $(DSOPATH)/DSO_Misc $(DSOPATH)/Leon3Uart $(DSOPATH)/DSO_Debugprint  $(DSOPATH)/DSO_SignalCapture $(DSOPATH)/DSO_FrontPanel
W2000SRC=$(DSOPATH)/DSO_SignalCTest  $(DSOPATH)/DSO_Screen $(DSOSRC)
SBXSRC=$(DSOPATH)/SandboxXBootloader $(DSOSRC)

WCFILES=$(W2000SRC:%=%.c)
WHFILES=$(W2000SRC:%=%.h)
SOFILES=$(SBXSRC:%=%.c)


bdInit: $(DSOPATH)/bdinit.c
	$(XCC) $(XCFLAGS) $(DSOPATH)/bdinit.c $(BOOTOPT) -O2 -c 

Standalone: 
	$(XCC) $(TINYFLAGS) $(WCFILES) $(DSOPATH)/Startup.S $(BOOTOPT) -O2 -c
	$(XCC) $(TINYFLAGS) Startup.o DSO_W2000Bootloader.o DSO_Debugprint.o DSO_SignalCapture.o -o Standalone.exe
	sparc-elf-objcopy -O srec   Standalone.exe sram.srec
#	sparc-elf-objcopy -O binary Standalone.exe sram.bin
#	./BootRomGen Standalone.exe W2000ROM.vhd

BootRom:  $(DSOPATH)/BootRomGen.c
	$(CC) $(DSOPATH)/BootRomGen.c -o BootRomGen

TBBootRom: prom.exe
	sparc-elf-objcopy -O binary prom.exe prom.bin
	./BootRomGen prom.bin W2000ROM.vhd

TBRom:  $(DSOPATH)/Startup.S
	$(XCC) $(TINYFLAGS)  $(DSOPATH)/Startup.S -o Startup.exe
	sparc-elf-objcopy -O binary Startup.exe Startup.bin
	./BootRomGen Startup.bin W2000ROM.vhd


W2000: $(WCFILES) 
	$(XCC) $(XCFLAGS) $(WCFILES) $(BOOTOPT) -Wall -o W2000ROM.exe
	sparc-elf-objdump -S W2000ROM.exe > W.S

$(WOFILES): $(WCFILES) 
	$(XCC) $(XCFLAGS) $(WCFILES) $(BOOTOPT) -o W2000ROM.exe

W2000SREC:
	sparc-elf-objcopy -O srec   W2000ROM.exe sram.srec
	sparc-elf-objcopy -O binary W2000ROM.exe sram.bin
	cp sram.srec sdram.srec
	cp sram.srec ../../../Scope/simSandboxX/sram.srec 
	cp sram.srec ../../../Scope/simSandboxX/sdram.srec 
	cp sram.srec ../../../Scope/simW2000A/sram.srec 
	cp sram.srec ../../../Scope/simW2000A/sdram.srec 

W2000ROM.vhd: BootRomGen $(WOFILES)
	sparc-elf-mkprom $(XCFLAGS) $(BOOTOPT) $(MKPROMOPT) W2000ROM.exe -o W2000ROM.prom
	sparc-elf-objcopy -O binary W2000ROM.prom W2000ROM.bin
	./BootRomGen W2000ROM.bin W2000ROM.vhd


sbxrom.vhd: BootRom $(SOFILES)
	$(XCC) $(XCFLAGS) $(BOOTOPT) $(SOFILES) -o SBXROM.exe
	sparc-elf-mkprom  $(XCFLAGS) $(BOOTOPT) $(MKPROMOPT) SBXROM.exe -o SBXROM.prom
	sparc-elf-objcopy -O binary SBXROM.prom SBXROM.bin
	./BootRomGen SBXROM.bin SBXROM.vhd
