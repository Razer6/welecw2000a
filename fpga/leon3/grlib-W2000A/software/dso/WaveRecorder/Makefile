CC = g++
AR = ar
CFLAGS = -I/usr/local/include -I.. -I. -Wall -ansi -g
LDFLAGS = -L/usr/local/lib --enable-auto-import
LDLIBS = -l argtable2
LIBDIR = ./objs-linux/

all:	WaveRecorder

clean: 
	rm WaveRecorder ./objs-linux/*.o *~

$(LIBDIR)/%.o : %.c $(CINCLUDES)
	$(CC) -c $(CFLAGS) -o $@ $<

$(LIBDIR)/%.o : ../%.c $(CINCLUDES)
	$(CC) -c $(CFLAGS) -o $@ $<

$(LIBDIR)/%.o : %.cpp $(CINCLUDES)
	$(CC) -c $(CFLAGS) -o $@ $<

OBJECTS= \
	$(LIBDIR)/PCUart.o \
	$(LIBDIR)/WaveFilePackage.o \
	$(LIBDIR)/WaveRecorder.o \
	$(LIBDIR)/DSO_Remote.o \
	$(LIBDIR)/DebugUart.o \
	$(LIBDIR)/NormalUART.o \
	$(LIBDIR)/RemoteSignalCapture.o \
	$(LIBDIR)/Request.o \
	$(LIBDIR)/DSO_Remote_Master.o \
	$(LIBDIR)/DSO_SignalCapture.o \
	$(LIBDIR)/Protocoll.o \
	$(LIBDIR)/DSO_Misc.o \
	$(LIBDIR)/crc.o


WaveRecorder:	$(OBJECTS)
	$(CC) $(LDFLAGS) $(PCOFILES) -o WaveRecorder $(LDLIBS) $(LIBDIR)/*.o

