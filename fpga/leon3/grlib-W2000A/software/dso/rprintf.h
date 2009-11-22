#ifndef _PRINTF_H
#define _PRINTF_H

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Reduced functionality printf.
 *
 * %<size>[l|ll][bdiouxX]
 * size = string: max length, otherwise: minimum digits
 */

void rprintc(unsigned); // to be supplied by caller
void rprintf(const char *, ...);

#ifdef __cplusplus
}
#endif

#endif //_PRINTF_H
