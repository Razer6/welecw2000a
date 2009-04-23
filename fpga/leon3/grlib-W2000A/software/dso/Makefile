DSOPATH=$(GRLIB)/software/dso
BOOTOPT= -msoft-float -lsmall 
#BOOTOPT= -msoft-float
XCC=sparc-elf-gcc -I$(GRLIB)/software/leon3 -I$(DSOPATH) -DLEON3 -DSBX
XAS=sparc-elf-gcc -c -I. -I$(GRLIB)/software/leon3 -I$(DSOPATH) -DLEON3
MKPROMOPT= -v -freq=63  -stack 0x401C7C00 -ramsize 2048 -ramcs 1 -rmw -romws 1 -romsize 8192

TINYFLAGS= -msoft-float -nostdlib  -nostartfiles
TX= -Tlinkprom -N -L./ -Ttext=0

DSOSRC= $(DSOPATH)/DSO_Misc $(DSOPATH)/Leon3Uart $(DSOPATH)/DSO_Debugprint $(DSOPATH)/DSO_ADC_Control $(DSOPATH)/DSO_SignalCapture $(DSOPATH)/crc $(DSOPATH)/DSO_Remote $(DSOPATH)/DSO_Remote_Slave
W2000SRC= $(DSOPATH)/DSO_Screen $(DSOPATH)/DSO_FrontPanel $(DSOSRC) $(DSOPATH)/DSO_SignalCTest
SBXSRC=$(DSOPATH)/SandboxXBootloader $(DSOSRC)

WCFILES=$(W2000SRC:%=%.c)
WHFILES=$(W2000SRC:%=%.h)
SOFILES=$(SBXSRC:%=%.c)


bdInit: $(DSOPATH)/bdinit.c
	$(XCC) $(DSOPATH)/bdinit.c $(BOOTOPT) -O2 -c 

BootRom:  $(DSOPATH)/BootRomGen.c
	$(CC) $(DSOPATH)/BootRomGen.c -o BootRomGen

SbxTBRom: prom.exe
	sparc-elf-objcopy -O binary prom.exe prom.bin
	./BootRomGen prom.bin W2000ROM.vhd

WTBRom:  $(DSOPATH)/Startup.S
	$(XCC) $(TINYFLAGS)  $(DSOPATH)/Startup.S -o Startup.exe
	sparc-elf-objcopy -O binary Startup.exe Startup.bin
	./BootRomGen Startup.bin W2000ROM.vhd


W2000: $(WCFILES) 
	$(XCC) $(WCFILES) $(BOOTOPT) -Wall -o W2000ROM.exe
	sparc-elf-objdump -S W2000ROM.exe > W.S

$(WOFILES): $(WCFILES) 
	$(XCC) $(WCFILES) $(BOOTOPT) -o W2000ROM.exe

W2000SREC:
	sparc-elf-objcopy -O srec   W2000ROM.exe sram.srec
	sparc-elf-objcopy -O binary W2000ROM.exe sram.bin
	cp sram.srec sdram.srec
	cp sram.srec ../../../Scope/simSandboxX/sram.srec 
	cp sram.srec ../../../Scope/simSandboxX/sdram.srec 
	cp sram.srec ../../../Scope/simW2000A/sram.srec 
	cp sram.srec ../../../Scope/simW2000A/sdram.srec 

W2000ROM.vhd: BootRomGen
	sparc-elf-mkprom $(XCFLAGS) $(BOOTOPT) $(MKPROMOPT) W2000ROM.exe -o W2000ROM.prom
	sparc-elf-objcopy -O binary W2000ROM.prom W2000ROM.bin
	./BootRomGen W2000ROM.bin W2000ROM.vhd

