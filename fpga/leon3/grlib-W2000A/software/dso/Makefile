DSOPATH=$(GRLIB)/software/dso
BOOTOPT= -msoft-float -qsvt -mv8
#BOOTOPT= -msoft-float

BASIC_PATH=/opt/sparc-elf-4.4.2/lib/gcc/sparc-elf/4.4.2/v8
BASIC=crtbegin.o crtend.o crtfastmath.o crti.o crtn.o 
LBASIC_PATH=/opt/sparc-elf-4.4.2/sparc-elf/lib/v8
NEWLIB_PATH=/opt/newlib/sparc-elf/lib

XCC=sparc-elf-gcc -I$(GRLIB)/software/leon3 -I$(DSOPATH) -DLEON3 -D$(DSO_TARGET) -D$(DSO_BOARD) --std=c99
XLD=sparc-elf-ld  -Tlinker.ld -Ttext=0x20000000 -L/opt/newlib/sparc-elf/lib -lc -L$(BASIC_PATH) -lgcc -lgcov

MKPROMOPT= -v -freq=63  -stack 0x4001B500 -ramsize 2048 -ramcs 1 -rmw -romws 1 -romsize 8192

TINYFLAGS= -msoft-float -nostdlib  -nostartfiles
TX= -Tlinkprom -N -L./ -Ttext=0

DSOSRC= $(DSOPATH)/DSO_Misc $(DSOPATH)/Leon3Uart $(DSOPATH)/DSO_ADC_Control $(DSOPATH)/DSO_SignalCapture $(DSOPATH)/rprintf $(DSOPATH)/convert $(DSOPATH)/crc $(DSOPATH)/DSO_Remote $(DSOPATH)/DSO_Remote_Slave
W2000SRC= $(DSOPATH)/DSO_Screen $(DSOPATH)/DSO_SignalCTest $(DSOPATH)/DSO_GUI $(DSOPATH)/Filter_I8  $(DSOPATH)/font_Arial_Bold_14 $(DSOPATH)/font_Arial_18 $(DSOPATH)/DSO_Font $(DSOPATH)/DSO_FrontPanel $(DSOPATH)/GUI $(DSOPATH)/util $(DSOSRC)
SBXSRC=$(DSOPATH)/SandboxXBootloader $(DSOSRC)

WCFILES=$(W2000SRC:%=%.c)
WOFILES=$(W2000SRC:%=%.o)
WHFILES=$(W2000SRC:%=%.h)
SOFILES=$(SBXSRC:%=%.c)
BASIC_FILES=$(BASIC:%=$(BASIC_PATH)/%)


#W2000: WObjects
#	$(XCC) $(WOFILES) $(BOOTOPT) -O2 -Wall -o W2000ROM.exe
#	#$(XLD) $(WOFILES) $(BASIC_FILES) $(NEWLIB_PATH)/libc.a $(LBASIC_PATH)/libleonbare.a $(LBASIC_PATH)/locore_svt.o -o  W2000ROM.exe

BootRomGen:  $(DSOPATH)/BootRomGen.c
	$(CC) $(DSOPATH)/BootRomGen.c -o BootRomGen

SbxTBRom: prom.exe BootRomGen
	sparc-elf-objcopy -O binary prom.exe prom.bin
	./BootRomGen prom.bin W2000ROM.vhd

WTBRom:  $(DSOPATH)/Startup.S BootROM
	$(XCC) $(TINYFLAGS)  $(DSOPATH)/Startup.S -o Startup.exe
	sparc-elf-objcopy -O binary Startup.exe Startup.bin
	./BootRomGen Startup.bin W2000ROM.vhd


W2000: $(WCFILES) 
	$(XCC) $(WCFILES) $(BOOTOPT) -O2 -Wall -o W2000ROM.exe
	sparc-elf-objdump -S W2000ROM.exe > W.S
	sparc-elf-objcopy -O srec   W2000ROM.exe sram.srec
	sparc-elf-objcopy -O binary W2000ROM.exe sram.bin

WObjects: $(WCFILES) 
	$(XCC) $(WCFILES) $(BOOTOPT) -c 

W2U:
	$(DSOPATH)/WaveRecorder/WaveRecorder -p Debugger -u $(UART) -b 115200 -n 2 -c LoadRun --Ffile=sram.bin

W2D:
	$(DSOPATH)/WaveRecorder/WaveRecorder -u  $(UART) -b 115200 -n 2 -p Debugger -c Debug

W2M:
	$(DSOPATH)/WaveRecorder/WaveRecorder -u  $(UART) -b 115200 -n 2 -p CPU -c Message

#$(WOFILES): $(WCFILES) 
#	$(XCC) $(WCFILES) $(BOOTOPT) -o W2000ROM.exe

W2SRAM: BootRomGen
	$(XCC) $(TINYFLAGS)  $(DSOPATH)/SRAMtest.S -o SRAMtest.exe
	sparc-elf-objcopy -O binary SRAMtest.exe SRAMtest.bin
	sparc-elf-objdump -S SRAMtest.exe > WSRAM.S
	./BootRomGen SRAMtest.bin W2000ROM.vhd

