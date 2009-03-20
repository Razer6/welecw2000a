#include "PCUart.h"
#include "unistd.h"

struct termios tio;


bool UartInit(	char * UartAddr,
		const int BaudRate,
		uart_regs * uart){

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

  tcflush(fd, TCIFLUSH); /* flush the buffer */
  tcsetattr(fd, TCSANOW, &tio); /* set the attributes */

/* Set up for no delay, ie nonblocking reads will occur.
   When we read, we'll get what's in the input buffer or nothing */
  fcntl(fd, F_SETFL, FNDELAY);
  return true;
}
#if 0
/* write the users command out the serial port */
  result = write(fd, argv[4], strlen(argv[4]));
  if (result < 0)
  {
    fputs("write failed\n", stderr);
    close(fd);
    return 5;
  }

/* wait for awhile, based on the user's timeout value in mS*/
  usleep(atoi(argv[3]) * 1000);

/* read the input buffer and print it */
  result = read(fd,buffer,255);
  buffer[result] = 0; // zero terminate so printf works
  printf("%s\n",buffer);

/* close the device file */
  close(fd);
}
#endif

char ReceiveCharBlock(uart_regs * uart){
	char ch;
	read(*uart,&ch,1);
	return ch;
}	

void SendCharBlock(uart_regs * uart, char c){
	write(*uart,&c,1);
}


void ReceiveStringBlock (uart_regs * uart, char * c, unsigned int * size){
	*size = read(*uart,c,*size);
}

void SendStringBlock (uart_regs * uart, char * c, unsigned int * size){
	*size = write(*uart,c,*size);
}

