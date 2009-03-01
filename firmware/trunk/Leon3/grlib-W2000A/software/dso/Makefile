DSOPATH=$(GRLIB)/software/dso
BOOTOPT= -msoft-float -lsmall 
#BOOTOPT= -msoft-float
XCC=sparc-elf-gcc -I$(GRLIB)/software/leon3 -I$(DSOPATH) 
XAS=sparc-elf-gcc -c -I. -I$(GRLIB)/software/leon3 -I$(DSOPATH)
MKPROMOPT= -v -freq=63  -stack 0x401C7C00 -ramsize 2048 -ramcs 1 -rmw -romws 1 -romsize 8192-bdinit

TINYFLAGS= -msoft-float -nostdlib -Tlinkprom -N -L./ -Ttext=0 -nostartfiles

DSOSRC=$(VPATH)/apbuart $(VPATH)/report_device $(VPATH)/mptest  $(DSOPATH)/DSO_Debugprint  $(DSOPATH)/DSO_SignalCapture  $(DSOPATH)/bdinit
W2000SRC= $(DSOPATH)/DSO_W2000Bootloader  $(DSOPATH)/DSO_Screen $(DSOSRC)
SBXSRC = $(DSOPATH)/SandboxXBootloader $(DSOSRC)

WCFILES = $(W2000SRC:%=%.c)
WHFILES = $(W2000SRC:%=%.h)
SOFILES = $(SBXSRC:%=%.c)

Touch: 
	touch $(DSOPATH)/*.c

Standalone: W2000
	$(XCC) $(XCFLAGS) $(WCFILES) $(BOOTOPT) -O2 -c
	$(XCC) $(TINYFLAGS)  DSO_W2000Bootloader.o DSO_Debugprint.o DSO_SignalCapture.o -o Standalone.exe
	./BootRomGen Standalone.exe W2000ROM.vhd

BootRom:  $(DSOPATH)/BootRomGen.c
	$(CC) $(DSOPATH)/BootRomGen.c -o BootRomGen

TBBootRom : prom.exe
	sparc-elf-objcopy -O binary prom.exe prom.bin
	./BootRomGen prom.bin W2000ROM.vhd

W2000: $(WCFILES) 
	$(XCC) $(XCFLAGS) $(WCFILES) $(BOOTOPT) -o W2000ROM.exe

$(WOFILES): $(WCFILES) 
	$(XCC) $(XCFLAGS) $(WCFILES) $(BOOTOPT) -o W2000ROM.exe

W2000SREC: W2000
	sparc-elf-objcopy -O srec   W2000ROM.exe sram.srec
	sparc-elf-objcopy -O binary W2000ROM.exe sram.bin

W2000ROM.vhd: BootRomGen $(WOFILES)
	sparc-elf-mkprom $(XCFLAGS) $(BOOTOPT) $(MKPROMOPT) W2000ROM.exe -o W2000ROM.prom
	sparc-elf-objcopy -O binary W2000ROM.prom W2000ROM.bin
	./BootRomGen W2000ROM.bin W2000ROM.vhd


sbxrom.vhd: BootRom $(SOFILES)
	$(XCC) $(XCFLAGS) $(BOOTOPT) $(SOFILES) -o SBXROM.exe
	sparc-elf-mkprom  $(XCFLAGS) $(BOOTOPT) $(MKPROMOPT) SBXROM.exe -o SBXROM.prom
	sparc-elf-objcopy -O binary SBXROM.prom SBXROM.bin
	./BootRomGen SBXROM.bin SBXROM.vhd
