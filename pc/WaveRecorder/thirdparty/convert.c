/* Copyright Andreas Kaiser 2008 */

#include <string.h>
#include "convert.h"

//-------------------------------------------------------------

char *
strrev(char *buf)
{
    for (char *p = buf, *q = buf+strlen(buf)-1; p < q; ) {
	char temp = *p;
	*p++ = *q;
	*q-- = temp;
    }
    return buf;
}

//-------------------------------------------------------------

unsigned long long
cvtu(const char *buf)
{
    unsigned long long val = 0;
    while (*buf)
	val = val * 10 + (*buf++ - '0');
    return val;
}

long long
cvti(const char *buf)
{
    if (*buf == '-')
	return -cvtu(buf+1);
    if (*buf == '+')
	++buf;
    return cvtu(buf);
}

//-------------------------------------------------------------

char *
ucvt(char *buf, unsigned long long value, int ndigits, int radix)
{
    int i = 0;
    do {
    	unsigned long long quo = value / radix;
    	unsigned long long rem = value - quo * radix;
    	buf[i++] = rem + ((rem < 10) ? '0' : 'A'-10);
    	value = quo;
    } while (value && i < 64);
    while (i < ndigits && i < 64)
	buf[i++] = '0';
    buf[i] = '\0';
    return strrev(buf);
}

char *
icvt(char *buf, long long int value, int ndigits)
{
    if (value < 0) {
	buf[0] = '-';
	ucvt(buf+1, -value, ndigits, 10);
    } else
	ucvt(buf, value, ndigits, 10);
    return buf;
}
