#ifndef UTIL_H_
#define UTIL_H_

#ifdef __cplusplus
extern "C" {
#endif

char *		strrev (char *);

unsigned long long cvtu (const char *buf);
long long	cvti (const char *buf);
char *		ucvt (char *buf, unsigned long long value, int ndigits, int radix);
char *		icvt (char *buf, long long int value, int ndigits);

#ifdef __cplusplus
}
#endif

#endif /*UTIL_H_*/
