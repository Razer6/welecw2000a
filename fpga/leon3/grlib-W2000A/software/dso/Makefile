DSOPATH=$(GRLIB)/software/dso
BOOTOPT= -msoft-float -mv8 -qsvt 
#BOOTOPT= -msoft-float
XCC=sparc-elf-gcc -I$(GRLIB)/software/leon3 -I$(DSOPATH) -DLEON3 -D$(DSO_TARGET) -D$(DSO_BOARD) --std=c99
XAS=sparc-elf-gcc -c -I. -I$(GRLIB)/software/leon3 -I$(DSOPATH) -DLEON3
MKPROMOPT= -v -freq=63  -stack 0x4001B500 -ramsize 2048 -ramcs 1 -rmw -romws 1 -romsize 8192

TINYFLAGS= -msoft-float -nostdlib  -nostartfiles
TX= -Tlinkprom -N -L./ -Ttext=0

DSOSRC= $(DSOPATH)/DSO_Misc $(DSOPATH)/Leon3Uart $(DSOPATH)/DSO_ADC_Control $(DSOPATH)/DSO_SignalCapture $(DSOPATH)/rprintf $(DSOPATH)/convert $(DSOPATH)/crc $(DSOPATH)/DSO_Remote $(DSOPATH)/DSO_Remote_Slave
W2000SRC= $(DSOPATH)/DSO_Screen $(DSOSRC) $(DSOPATH)/DSO_SignalCTest $(DSOPATH)/DSO_GUI $(DSOPATH)/Filter_I8 
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
	$(XCC) $(WCFILES) $(BOOTOPT) -O2 -Wall -o W2000ROM.exe
	sparc-elf-objdump -S W2000ROM.exe > W.S
	sparc-elf-objcopy -O srec   W2000ROM.exe sram.srec
	sparc-elf-objcopy -O binary W2000ROM.exe sram.bin

W2U:
	$(DSOPATH)/WaveRecorder/WaveRecorder -u  $(UART) -b 115200 -n 2 -p Debugger -c LoadRun --Ffile=sram.bin

W2M:
	$(DSOPATH)/WaveRecorder/WaveRecorder -u  $(UART) -b 115200 -n 2 -p CPU -c Message

$(WOFILES): $(WCFILES) 
	$(XCC) $(WCFILES) $(BOOTOPT) -o W2000ROM.exe

W2000ROM.vhd: BootRomGen
	sparc-elf-mkprom $(XCFLAGS) $(BOOTOPT) $(MKPROMOPT) W2000ROM.exe -o W2000ROM.prom
	sparc-elf-objcopy -O binary W2000ROM.prom W2000ROM.bin
	./BootRomGen W2000ROM.bin W2000ROM.vhd

