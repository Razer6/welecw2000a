# Programs to use
DIRNAME    = dirname
WHICH      = which
ECHO       = @echo

CC         = $(ECHO) " [COMPILE] $<"; sparc-elf-gcc
LD         = $(ECHO) " [LINK   ] $<"; sparc-elf-gcc
OBJCOPY    = $(ECHO) " [OBJCOPY] $<"; sparc-elf-objcopy
SIZE       = $(ECHO) " [SIZE   ] $<"; sparc-elf-size
MAKEDEPEND = $(ECHO) " [DEPEND ]"; makedepend
WAVEREC    = $(ECHO) " [WAVEREC] "; WaveRecorder

# WaveRecorder settings
UART = /dev/ttyS0
BAUD = 115200
CHANNELS = 2
PROTOCOL = Debugger
COMMAND  = LoadRun

# Defines for conditional compilation
DSO_TARGET = W2000A
DSO_BOARD  = BOARD_COMPILATION
DEFINES    = -DLEON3 -D$(DSO_TARGET) -D$(DSO_BOARD)

# Flags
CFLAGS  = $(DEFINES) --std=c99 -msoft-float -qsvt -mv8 -O2 -Wall

# Target variables
SOURCE_DIRS   = . thirdparty fonts
VPATH	     := $(SOURCE_DIRS)
INCLUDE_DIRS := $(patsubst %,-I%,$(subst :, ,$(VPATH)))
INCLUDE_DIRS += -I../grlib-W2000A/software/leon3
CFLAGS       += $(INCLUDE_DIRS)

SOURCES := $(wildcard $(patsubst %,%/*.c,$(subst :, ,$(VPATH))))
HEADERS := $(wildcard *.h thirdparty/*.h)
#OBJS    := $(patsubst %.c, %.o, $(SOURCES))
OBJS	:= $(SOURCES:.c=.o)
#ASMS    := $(patsubst %.c, %.s, $(SOURCES))
ASMS	:= $(SOURCES:.c=.s)

# Files to be cleaned
CLEAN = $(OBJS) $(ASMS)

# Rules
.PHONY: all
all: w2000a.bin

upload: w2000a.bin
	$(WAVEREC) -p $(PROTOCOL) -u $(UART) -b $(BAUD) -n $(CHANNELS) -c $(COMMAND) --Ffile=$<

%.bin: %.elf
	$(OBJCOPY) -O binary $^ $@

$(OBJS): Makefile

%.elf: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@
	@$(SIZE) $@

.PHONY: clean
clean:
	$(ECHO) " [CLEAN  ]"
	@$(RM) $(CLEAN)

# Generate dependencies when any source or header file changes
#$(SOURCES) $(HEADERS): depend

# Automatic dependency rule generation by makedepend
.PHONY: depend
MAKEDEPEND_DELIMITER = "\# Do not edit below this line, run make depend to update!"
depend:
	$(MAKEDEPEND) -w 1024 -Y -m -s $(MAKEDEPEND_DELIMITER) -- $(CFLAGS) $(LDFLAGS) -- $(SOURCES) >/dev/null 2>&1

# Do not edit below this line, run make depend to update!

./DSO_ADC_Control.o: types.h DSO_ADC_Control.h Leon3Uart.h DSO_Remote.h thirdparty/crc.h
./DSO_Font.o: types.h DSO_Font.h fonts/font_Arial_Bold_14.h fonts/font_Arial_18.h DSO_Screen.h util.h
./DSO_FrontPanel.o: DSO_SFR.h DSO_Main.h types.h DSO_Misc.h Leon3Uart.h
./DSO_GUI.o: types.h DSO_Main.h DSO_GUI.h DSO_Screen.h util.h Filter_I8.h DSO_SFR.h DSO_SignalCapture.h thirdparty/crc.h Leon3Uart.h thirdparty/rprintf.h DSO_Misc.h DSO_FrontPanel.h GUI.h DSO_Font.h fonts/font_Arial_Bold_14.h fonts/font_Arial_18.h
./DSO_Misc.o: DSO_Misc.h DSO_Main.h types.h ../grlib-W2000A/software/leon3/grcommon.h
./DSO_Remote.o: DSO_Remote.h types.h Leon3Uart.h thirdparty/crc.h
./DSO_Remote_Slave.o: DSO_Main.h types.h DSO_Misc.h DSO_SignalCapture.h DSO_SFR.h thirdparty/crc.h Leon3Uart.h DSO_Remote.h DSO_Remote_Slave.h
./DSO_Screen.o: types.h DSO_SFR.h DSO_Main.h DSO_Screen.h util.h DSO_Misc.h GUI.h DSO_Font.h fonts/font_Arial_Bold_14.h fonts/font_Arial_18.h DSO_FrontPanel.h
./DSO_SignalCapture.o: ../grlib-W2000A/software/leon3/grcommon.h DSO_SFR.h DSO_Main.h types.h DSO_SignalCapture.h thirdparty/crc.h DSO_Misc.h DSO_ADC_Control.h Leon3Uart.h DSO_Remote.h thirdparty/rprintf.h
./DSO_SignalCTest.o: ../grlib-W2000A/software/leon3/grcommon.h DSO_SignalCapture.h DSO_Main.h types.h DSO_SFR.h thirdparty/crc.h Leon3Uart.h DSO_Remote_Slave.h DSO_Remote.h DSO_Screen.h util.h DSO_FrontPanel.h Filter_I8.h ../grlib-W2000A/software/leon3/irqmp.h DSO_Misc.h DSO_GUI.h thirdparty/rprintf.h
./Filter_I8.o: types.h
./GUI.o: GUI.h DSO_Font.h types.h fonts/font_Arial_Bold_14.h fonts/font_Arial_18.h DSO_Screen.h util.h DSO_SFR.h DSO_Main.h DSO_FrontPanel.h DSO_Misc.h
./Leon3Uart.o: DSO_Main.h types.h Leon3Uart.h DSO_Misc.h
./util.o: util.h
thirdparty/convert.o: thirdparty/convert.h
thirdparty/crc.o: thirdparty/crc.h
thirdparty/rprintf.o: thirdparty/rprintf.h thirdparty/convert.h
fonts/font_Arial_18.o: fonts/font_Arial_18.h DSO_Font.h types.h fonts/font_Arial_Bold_14.h
fonts/font_Arial_Bold_14.o: fonts/font_Arial_Bold_14.h DSO_Font.h types.h fonts/font_Arial_18.h
