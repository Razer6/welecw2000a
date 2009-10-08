/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : PCUart.c
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 20.04.2009
*****************************************************************************
* Description	 : 
*****************************************************************************

*  Copyright (c) 2009, Alexander Lindert

*  This program is free software; you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation; either version 2 of the License, or
*  (at your option) any later version.

*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.

*  You should have received a copy of the GNU General Public License
*  along with this program; if not, write to the Free Software
*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*  For commercial applications where source-code distribution is not
*  desirable or possible, I offer low-cost commercial IP licenses.
*  Please contact me per mail.

*****************************************************************************
* Remarks		: -
* Revision		: 0
****************************************************************************/

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
       close(*uart);
#endif
}

static uint32_t TimeoutMs = 0;

void SetTimeoutMs(uint32_t Timeout){
	TimeoutMs = Timeout;
}

bool UartInit(	
		char * UartAddr,
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
    m_dcb.fAbortOnError = FALSE;
    m_dcb.fRtsControl = RTS_CONTROL_DISABLE;
	m_dcb.fOutxCtsFlow = FALSE;
    m_dcb.fOutxDsrFlow = false;
    m_dcb.fDtrControl = DTR_CONTROL_DISABLE;
    m_dcb.fDsrSensitivity = false;

    
    m_bPortReady = SetCommState(*uart, &m_dcb);
    if (GetLastError() != ERROR_SUCCESS) {
       printf("SetCommState(): %lu\n", GetLastError());              
       return false;
    }
    m_bPortReady = GetCommTimeouts (*uart, &m_CommTimeouts);
    
    m_CommTimeouts.ReadIntervalTimeout = 1;
    m_CommTimeouts.ReadTotalTimeoutConstant = 10;
    m_CommTimeouts.ReadTotalTimeoutMultiplier = 1;
    m_CommTimeouts.WriteTotalTimeoutConstant = 10;
    m_CommTimeouts.WriteTotalTimeoutMultiplier = 1;
    m_bPortReady = SetCommTimeouts (*uart, &m_CommTimeouts);
    if (GetLastError() != ERROR_SUCCESS) {
       printf("SetCommTimeouts(): %lu\n", GetLastError());              
       return false;
    }
    ClearCommError(*uart, NULL, NULL);
    /*ClearCommError(*uart, CE_FRAME | CE_BREAK | CE_OVERRUN | CE_RXOVER | CE_RXPARITY, NULL);*/

#else
	static int fd = 0;
  	long baud = 0;

  switch (BaudRate) {
    case 1200:	 baud = B1200; break;
    case 2400:	 baud = B2400; break;
    case 9600:	 baud = B9600; break;
    case 19200:	 baud = B19200;break;
    case 38400:  baud = B38400;break;
    case 57600:  baud = B57600;break;
    case 115200: baud = B115200;break;
#ifdef B128000
    case 128000: baud = B128000;break;
#endif
    case 230400: baud = B230400;break;
#ifdef	B256000
    case 256000: baud = B256000;break;
#endif
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
  if ((fd = open(UartAddr,O_RDWR | O_NOCTTY)) < 0)
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

  tio.c_cc[VTIME] = 1;   /* 100ms time delay */
  tio.c_cc[VMIN]  = 0;   /* no char delay */
  cfsetospeed(&tio,baud);
  cfsetispeed(&tio,baud);
  tcflush(fd, TCIFLUSH); /* flush the buffer */
  tcsetattr(fd, TCSADRAIN, &tio);  /* set the attributes */
/* Set up for no delay, ie nonblocking reads will occur.
   When we read, we'll get what's in the input buffer or nothing */
/*  fcntl(fd, F_SETFL, FNDELAY); */

	*uart=fd;
#endif 

  return true;
}


char ReceiveCharBlock(uart_regs * uart){
	char ch;

#ifdef WINNT
	LPDWORD ret = 0;
	int32_t x = 0;

   do {
      ReadFile(*uart, &ch, 1, (LPDWORD)&ret, NULL);
	  if (ret == 0){
		  Sleep(1);
	  }
   } while (ret == 0);
   x = (int32_t)(unsigned char)ch;
 /*  printf("%02x ",x);*/
#else
	uint32_t ret = 0;
	while(read(*uart,&ch,1) == 0) {
		usleep(10000);
	}
#endif
	return ch;
}

char ReceiveChar(uart_regs * uart, uint32_t *error){
	uint32_t ch = 0;
	uint32_t ret = 0;
	uint32_t cnt = 0;
	*error = 0;
#ifdef WINNT
	do {
		ReadFile(*uart,&ch,1,(LPDWORD)&ret,NULL);
		cnt++;
		if (ret == 0){
			Sleep(1);
		}
		if (cnt == TimeoutMs){
			*error = 1;
			printf("\nTimeout!\n");
			return 0;
		}
   } while (ret == 0);
#else
	while(read(*uart,&ch,1) == 0) {
		usleep(10000);
	}
#endif
//	printf("%c",ch);
	return (unsigned char)ch;
}

void SendCharBlock(uart_regs * uart, char c){
#ifdef WINNT
	uint32_t ret = 0;
	int32_t x = (int32_t)(unsigned char)c;
	printf("%02x ",x);
	do {
		WriteFile(*uart,&c,1,(LPDWORD)&ret,NULL);
		if (ret == 0){
			Sleep(1);
		}
	} while (ret == 0);
#else
	write(*uart,&c,1);
	usleep(10000);
#endif
}


void ReceiveStringBlock (uart_regs * uart, char * c, uint32_t *size){
#ifdef WINNT
	DWORD ret = 0;
	LPDWORD lpret = &ret;
	DWORD  r = 0;
#else
	uint32_t ret = 0;
	uint32_t r = 0;
#endif
	while (r != *size) {
#ifdef WINNT
		ReadFile(*uart,&c[r],*size-r,lpret,NULL);
		if (ret == 0){
			Sleep(1);
		}
#else     
        ret = read(*uart,&c[r], *size-r);
#endif  
        r = r + ret;
	}    
}

void SendStringBlock (uart_regs * uart, char * c){
#ifdef WINNT
	DWORD ret = 0;
	LPDWORD lpret = &ret;
	DWORD written = 0;
#else
	uint32_t ret = 0;
	uint32_t written = 0;
#endif
	uint32_t size = strlen(c);
	while (written != size) {
#ifdef WINNT
		WriteFile(*uart,&c[written],size-written,lpret,NULL);
		if (ret == 0){
			Sleep(1);
		}
#else 
		ret = write(*uart, &c[written], size-written);	
	usleep(10000);
#endif 	
		written = written + ret;
	} 
}

void SendBytes (uart_regs * uart, uint8_t * c, uint32_t size){
#ifdef WINNT
	DWORD ret = 0;
	LPDWORD lpret = &ret;
	DWORD written = 0;
#else
	int32_t ret = 0;
	int32_t written = 0;
#endif
	while (written < size) {
#ifdef WINNT
		WriteFile(*uart,&c[written],size-written,lpret,NULL);
		if (ret == 0){
			Sleep(1);
		}
#else 
		ret = write(*uart,&c[written], size-written);	
	usleep(10000);
#endif 	
		written = written + ret;

	} 
	for (ret = 0; ret < written; ++ret){
		printf("%02x ",c[ret] & 0xff);
	}
	printf("\n");
}

/* return error */
uint32_t ReceiveBytes(
				  uart_regs * uart, 
				  uint8_t * data, 
				  uint32_t length){
	uint32_t ret = 0;
	uint32_t cnt = 0;
	uint32_t written = 0;
#ifdef WINNT
	do {
		ReadFile(*uart,&data[written],length-written,(LPDWORD)&ret,NULL);
		cnt++;
		if (ret == 0){
			Sleep(1);
		}
		if (cnt == TimeoutMs){

			printf("\nTimeout!\n");
			return written;
		}
		written += ret;
   } while (written < length);
#else
	written=read(*uart,data,length);
#endif
	for (ret = 0; ret < written; ++ret){
		printf("%02x ",data[ret] & 0xff);
	}
	printf("\n");
	return written;
}

uint32_t UART_Flush(uart_regs * uart) {
#ifdef WINNT
	return PurgeComm(*uart,PURGE_RXABORT | PURGE_RXCLEAR | PURGE_TXCLEAR | PURGE_TXABORT);
#else
	char c;
	while (read(*uart,&c,1));
#endif
}

uint32_t UART_Resync(uart_regs * uart) {
#ifdef WINNT
	return ClearCommError(*uart,NULL,NULL);
#endif
}
