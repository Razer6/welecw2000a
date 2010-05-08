CC = g++
CFLAGS = -Os -Wall

all: bmp2framebuffer

bmp2framebuffer: bmp2framebuffer.o EasyBMP.o
	$(CC) $(CFLAGS) -o bmp2framebuffer bmp2framebuffer.o EasyBMP.o

bmp2framebuffer.o: bmp2framebuffer.cpp
	$(CC) $(CFLAGS) -c bmp2framebuffer.cpp

EasyBMP.o: EasyBMP.cpp
	$(CC) $(CFLAGS) -c EasyBMP.cpp

clean:
	rm -f *.o bmp2framebuffer bmp2framebuffer.exe