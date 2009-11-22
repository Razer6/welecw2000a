/* Copyright Andreas Kaiser 2008 */

#include "rprintf.h"
#include "convert.h"
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <alloca.h>
#include <limits.h>

#if UINT_MAX == 0xFFFF
  #define I_BITS	16
#elif UINT_MAX == 0xFFFFFFFF
  #define I_BITS	32
#else
  #define I_BITS	64
#endif

#if ULONG_MAX == 0xFFFFFFFF
  #define L_BITS	32
#else
  #define L_BITS	64
#endif

#if ULLONG_MAX == 0xFFFFFFFF
  #define LL_BITS	32
#else
  #define LL_BITS	64
#endif

#define DIGITS(t,d) (t+d-1)/d

// max no of digits, [int,long,longlong]
static char rad2[]  = { DIGITS(I_BITS,1), DIGITS(L_BITS,1), DIGITS(LL_BITS,1) };
static char rad8[]  = { DIGITS(I_BITS,3), DIGITS(L_BITS,3), DIGITS(LL_BITS,3) };
static char rad16[] = { DIGITS(I_BITS,4), DIGITS(L_BITS,4), DIGITS(LL_BITS,4) };

void
rprintf(const char *fmt, ...)
{
    int	     c, i;
    unsigned width, size, ltype, radix;
    char *   p;

    va_list ap;
    va_start(ap, fmt);

    for (;;) {
	c = *fmt++;
	switch (c) {

	case '%':
	    width = 0;
	    ltype = 0;

	    c = *fmt++;

	    while (c >= '0' && c <= '9') {
		width = width * 10 + (c - '0');
		c = *fmt++;
	    }

	    while (c == 'l') {
		if (ltype < 2)
		    ++ltype;
		c = *fmt++;
	    }

	    switch (c) {

	    case 's':
		p = va_arg(ap, char *);
		if (width == 0)
		    width = UINT_MAX;
		for (i = 0; i < width && *p; )
		    rprintc(*p++ & 0xFF);
		break;

	    case 'b':
		radix = 2;
		size = rad2[ltype];
		goto unum;
	    case 'o':
		radix = 8;
		size = rad8[ltype];
		goto unum;
	    case 'x':
	    case 'X':
	    case 'p':
		radix = 16;
		size = rad16[ltype];
		goto unum;
	    case 'u':
		radix = 10;
		size = rad8[ltype];
	    unum:
		if (width > size)
		    width = size;
		{
		    unsigned long long val;
		    if (ltype == 0)
			val = va_arg(ap, unsigned);
		    else if (ltype == 1)
			val = va_arg(ap, unsigned long);
		    else
			val = va_arg(ap, unsigned long long);
		    p = ucvt(alloca(size+1), val, width, radix);
		    while (*p)
			rprintc(*p++);
		}
		break;

	    case 'd':
	    case 'i':
		size = rad8[ltype];
		if (width > size)
		    width = size;
		{
		    long long val;
		    if (ltype == 0)
			val = va_arg(ap, int);
		    else if (ltype == 1)
			val = va_arg(ap, long);
		    else
			val = va_arg(ap, long long);
		    p = icvt(alloca(size+2), val, width);
		    while (*p)
			rprintc(*p++);
		}
		break;

	    case 'c':
		rprintc(va_arg(ap, int) & 0xFF);
		break;

	    default:
		rprintc(c & 0xFF);
	    }
	    break;

	case '\0':
	    va_end(ap);
	    return;

	default:
	    rprintc(c & 0xFF);
	}
    }
}
