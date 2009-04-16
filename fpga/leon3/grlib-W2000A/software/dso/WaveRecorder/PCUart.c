


#include "PCUart.h"


#ifdef WINNT 
#include "windows.h"
#include "conio.h"
#else
#include "unistd.h"
#include <fcntl.h>
#include "termios.h"
struct termios tio;
#endif

void UartClose (uart_regs * uart){
#ifdef WINNT 
       CloseHandle(*uart);
#else 
       close(huart);
#endif
}


bool UartInit(	char * UartAddr,
		const int BaudRate,
		uart_regs * uart){
#ifdef WINNT
    BOOL     m_bPortReady;
    DCB      m_dcb;
    COMMTIMEOUTS m_CommTimeouts;
    *uart = CreateFile(UartAddr, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);
    if (GetLastError() != ERROR_SUCCESS) {
       printf("CreateFile(): %lu\n", GetLastError());              
       return false;
    }
    
   /* m_bPortReady = SetupComm(*uart, 128, 128); 
    if (GetLastError() != ERROR_SUCCESS) {
       printf("SetupComm(): %lu\n", GetLastError());              
       return false;
    }*/
    m_bPortReady = GetCommState(*uart, &m_dcb);
    if (GetLastError() != ERROR_SUCCESS) {
       printf("GetCommState(): %lu\n", GetLastError());              
       return false;
    }
    m_dcb.BaudRate = BaudRate;
    m_dcb.ByteSize = 8;
    m_dcb.Parity = NOPARITY;
    m_dcb.StopBits = ONESTOPBIT;
    m_dcb.fAbortOnError = TRUE;
    m_dcb.fRtsControl = RTS_CONTROL_DISABLE;
    
    m_bPortReady = SetCommState(*uart, &m_dcb);
    if (GetLastError() != ERROR_SUCCESS) {
       printf("SetCommState(): %lu\n", GetLastError());              
       return false;
    }
    m_bPortReady = GetCommTimeouts (*uart, &m_CommTimeouts);
    
    m_CommTimeouts.ReadIntervalTimeout = 500;
    m_CommTimeouts.ReadTotalTimeoutConstant = 500;
    m_CommTimeouts.ReadTotalTimeoutMultiplier = 100;
    m_CommTimeouts.WriteTotalTimeoutConstant = 500;
    m_CommTimeouts.WriteTotalTimeoutMultiplier = 100;
    m_bPortReady = SetCommTimeouts (*uart, &m_CommTimeouts);
    if (GetLastError() != ERROR_SUCCESS) {
       printf("SetCommTimeouts(): %lu\n", GetLastError());              
       return false;
    }
    ClearCommError(*uart, NULL, NULL);
    /*ClearCommError(*uart, CE_FRAME | CE_BREAK | CE_OVERRUN | CE_RXOVER | CE_RXPARITY, NULL);*/

#else
	int fd = 0;
  	long baud = 0;

  switch (BaudRate) {
    case 1200:	 baud = B1200; break;
    case 2400:	 baud = B2400; break;
    case 9600:	 baud = B9600; break;
    case 19200:	 baud = B19200;break;
    case 38400:  baud = B38400;break;
    case 57600:  baud = B57600;break;
    case 115200: baud = B115200;break;
    case 128000: baud = B128000;break;
    case 230400: baud = B230400;break;
    case 256000: baud = B256000;break;
    case 460800: baud = B460800;break;
    case 500000: baud = B500000;break;
    case 576000: baud = B576000;break;
    case 921600: baud = B921600;break;
    case 1000000:baud = B1000000;break;
    default:
      printf("Baud rate %d is not supported, ", BaudRate);
      printf("use 1200, 2400, 9600, ... 1000000!\n");
      return false;
      break;
  }
/* open the serial port device file
 * O_NDELAY - tells port to operate and ignore the DCD line
 * O_NOCTTY - this process is not to become the controlling
 *            process for the port. The driver will not send
 *            this process signals due to keyboard aborts, etc.
 */
  if ((fd = open(UartAddr,O_RDWR | O_NDELAY | O_NOCTTY)) < 0)
  {
    printf("Couldn't open %s\n",UartAddr);
    return false;
  }

/* we are not concerned about preserving the old serial port configuration
 * CS8, 8 data bits
 * CREAD, receiver enabled
 * CLOCAL, don't change the port's owner
 */
  tio.c_cflag = baud | CS8 | CREAD | CLOCAL;

  tio.c_cflag &= ~HUPCL; /* clear the HUPCL bit, close doesn't change DTR */

  tio.c_lflag = 0;       /* set input flag noncanonical, no processing */

  tio.c_iflag = IGNPAR;  /* ignore parity errors */

  tio.c_oflag = 0;       /* set output flag noncanonical, no processing */

  tio.c_cc[VTIME] = 0;   /* no time delay */
  tio.c_cc[VMIN]  = 0;   /* no char delay */
  cfsetospeed(&tio,baud);
  cfsetispeed(&tio,baud);
  tcflush(fd, TCIFLUSH); /* flush the buffer */
  tcsetattr(fd, TCSADRAIN, &tio);  /* set the attributes */
/* Set up for no delay, ie nonblocking reads will occur.
   When we read, we'll get what's in the input buffer or nothing */
/*  fcntl(fd, F_SETFL, FNDELAY); */

#endif 

  return true;
}


char ReceiveCharBlock(uart_regs * uart){
	char ch;
	unsigned int ret = 0;
#ifdef WINNT
   do {
      ReadFile(*uart,&ch,1,&ret,NULL);
   } while (ret == 0);
#else
	while(read(uart,&ch,1));
#endif
	return ch;
}	

void SendCharBlock(uart_regs * uart, char c){
#ifdef WINNT
   unsigned int ret = 0;
   do {
     WriteFile(*uart,&c,1,&ret,NULL);
   } while (ret == 0);
#else
	write(uart,c,1);
#endif
}


void ReceiveStringBlock (uart_regs * uart, char * c, unsigned int * size){
#ifdef WINNT
     DWORD ret = 0;
     LPDWORD lpret = &ret;
     DWORD  r = 0;
#else
     unsigned int ret = 0;
     unsigned int r = 0;
#endif
/*     printf("Receive %d chars with HANDLE %d \n", *size, *uart);*/
      while (r != *size) {
#ifdef WINNT
        ReadFile(*uart,&c[r],*size-r,lpret,NULL);
#else     
        ret = read(uart,&c[r], *size-r);
#endif  
        r = r + ret;
      }    
}

void SendStringBlock (uart_regs * uart, char * c, unsigned int * size){
#ifdef WINNT
     DWORD ret = 0;
     LPDWORD lpret = &ret;
     DWORD written = 0;
#else
     unsigned int ret = 0;
     unsigned int written = 0;
#endif
     while (written != *size) {
#ifdef WINNT
       WriteFile(*uart,&c[written],*size-written,lpret,NULL);
#else 
	   ret = write(uart,&c[written], *size-written);	
#endif 	
        written = written + ret;
     } 
}
