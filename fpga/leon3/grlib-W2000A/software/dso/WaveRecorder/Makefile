CC = gcc
AR = ar
CFLAGS = -I/usr/local/include -I.. -I. -Wall -ansi -g
LDFLAGS = -L/usr/local/lib --enable-auto-import
LDLIBS = libargtable2.a
#LDLIBS = x.a
PCSRC= PCUart WaveFilePackage ../DSO_Remote DSO_Remote_Master WaveRecorder
PCCFILES=$(PCSRC:%=%.c)
PCOFILES=$(PCSRC:%=%.o)

$(PCOFILES) : $(PCCFILES)
	$(CC) $(CFLAGS) $(PCCFILES) -c

all: $(PCOFILES) 
	$(CC) $(LDFLAGS) $(PCOFILES) -o WaveRecorder $(LDLIBS)

clean: 
	rm *.o *~


