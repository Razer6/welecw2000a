/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : arg_costums.c
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 10.04.2010
*****************************************************************************
* Description	 : This file is for all argtable2 expansions! 
*****************************************************************************

*  Copyright (c) 2010, Alexander Lindert, Stewart Heitmann


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
#include "argtable2.h"
#include "arg_costums.h"
#include "stdlib.h"
#include "string.h"
#include "limits.h"
#include "ctype.h"

enum {EMINCOUNT=1,EMAXCOUNT,EBADINT,EOVERFLOW};


static long int strtol0X(const char* str, const char **endptr, char X, int base)
    {
    long int val;               /* stores result */
    int s=1;                    /* sign is +1 or -1 */
    const char *ptr=str;        /* ptr to current position in str */

    /* skip leading whitespace */
    while (isspace(*ptr))
        ptr++;
    /* printf("1) %s\n",ptr); */

    /* scan optional sign character */
    switch (*ptr)
        {
        case '+':
            ptr++;
            s=1;
            break;
        case '-':
            ptr++;
            s=-1;
            break;
        default:
            s=1;
            break;    
        }
    /* printf("2) %s\n",ptr); */

    /* '0X' prefix */
    if ((*ptr++)!='0')
        { 
        /* printf("failed to detect '0'\n"); */
        *endptr=str;
        return 0;
        }
   /* printf("3) %s\n",ptr); */
   if (toupper(*ptr++)!=toupper(X))
        {
        /* printf("failed to detect '%c'\n",X); */
        *endptr=str;
        return 0;
        }
    /* printf("4) %s\n",ptr); */

    /* attempt conversion on remainder of string using strtol() */
    val = strtol(ptr,(char**)endptr,base);
    if (*endptr==ptr)
        {
        /* conversion failed */
        *endptr=str;
        return 0;
        }

    /* success */
    return s*val;
 }

/* Str may contain trailing whitespace, but nothing else. */
static int detectsuffix(const char *str, const char *suffix)
    {
    /* scan pairwise through strings until mismatch detected */
    while( toupper(*str) == toupper(*suffix) )
        {
        /* printf("'%c' '%c'\n", *str, *suffix); */

        /* return 1 (success) if match persists until the string terminator */
        if (*str=='\0')
           return 1; 

        /* next chars */
        str++;
        suffix++;
        }
    /* printf("'%c' '%c' mismatch\n", *str, *suffix); */

    /* return 0 (fail) if the matching did not consume the entire suffix */
    if (*suffix!=0)
        return 0;   /* failed to consume entire suffix */

    /* skip any remaining whitespace in str */
    while (isspace(*str))
        str++;

    /* return 1 (success) if we have reached end of str else return 0 (fail) */
    return (*str=='\0') ? 1 : 0;
    }

int  arg_exp_scanfn(struct arg_int * parent, const char *argval)
{
    int errorcode = 0;

    if (parent->count == parent->hdr.maxcount)
        {
        /* maximum number of arguments exceeded */
        errorcode = EMAXCOUNT;
        }
    else if (!argval)
        {
        /* a valid argument with no argument value was given. */
        /* This happens when an optional argument value was invoked. */
        /* leave parent arguiment value unaltered but still count the argument. */
        parent->count++;
        }
    else
        {
        long int val;
	long int base;
        const char *end;

        /* attempt to extract hex integer (eg: +0x123) from argval into val conversion */
	base = 16;
        val = strtol0X(argval, &end, 'X', base);
        if (end==argval)
            {
            /* hex failed, attempt octal conversion (eg +0o123) */
	    base = 8;
            val = strtol0X(argval, &end, 'O', base);
            if (end==argval)
                {
                /* octal failed, attempt binary conversion (eg +0B101) */
		base = 2;
                val = strtol0X(argval, &end, 'B', base);
                if (end==argval)
                    {
                    /* binary failed, attempt decimal conversion with no prefix (eg 1234) */
		    base = 10;
                    val = strtol(argval, (char**)&end, base);
                    if (end==argval)
                        {
                        /* all supported number formats failed */
                        return EBADINT;
                        }
                    }
                }
            }
	/* Safety check for integer overflow. WARNING: this check    */
        /* achieves nothing on machines where size(int)==size(long). */
        if ( val>INT_MAX || val<INT_MIN )
            errorcode = EOVERFLOW;

        /* Detect any suffixes (KB,MB,GB) and multiply argument value appropriately. */
        /* We need to be mindful of integer overflows when using such big numbers.   */
        if (detectsuffix(end,"KB"))             /* kilobytes */
            {
            if ( val>(INT_MAX/1024) || val<(INT_MIN/1024) )
                errorcode = EOVERFLOW;          /* Overflow would occur if we proceed */
            else
                val*=1024;                      /* 1KB = 1024 */
            }
        else if (detectsuffix(end,"MB"))        /* megabytes */
            {
            if ( val>(INT_MAX/1048576) || val<(INT_MIN/1048576) )
                errorcode = EOVERFLOW;          /* Overflow would occur if we proceed */
            else
                val*=1048576;                   /* 1MB = 1024*1024 */
            }
        else if (detectsuffix(end,"GB"))        /* gigabytes */
            {
            if ( val>(INT_MAX/1073741824) || val<(INT_MIN/1073741824) )
                errorcode = EOVERFLOW;          /* Overflow would occur if we proceed */
            else
                val*=1073741824;                /* 1GB = 1024*1024*1024 */
            }
        else if (toupper(*end) == 'E') /* || ((base == 16) && toupper(*end) =='P')) */
	    {
		long int mult = 1;
		int s = 1;
		char * exp = (char *)&end[1];
		long int exponent = strtol(exp, (char**)&end, 10);
/*		printf("end = %s\n",end);
		printf("base = %ld exponent = %ld ",base, exponent);*/
		if ((*end != '\0') || (exp == end)) 
		/* exponents are only supported for non storage integer types */
                    {
                    /* all supported number formats failed */
                    return EBADINT;
                    }
		if (exponent < 0)
                    {
		    s = -1;
		    exponent = -exponent;
		    }
		while (exponent > 0) 
                    {
		    exponent--;
		    if ( mult>(INT_MAX/base) )
                         errorcode = EOVERFLOW;          /* Overflow would occur if we proceed */
		    mult *= base;					
		    } 
		if ((s == -1) && (mult != 0) )
                    	val/=mult; /* return EBADINT; or we do not support base^(-exponent) */	 
		else 
		    {
               	    if (mult == 0 || val>(INT_MAX/mult))
                         errorcode = EOVERFLOW;          /* Overflow would occur if we proceed */
                    else		
                    	 val*=mult;                                     
                    }		
       /*      	printf("mult = %ld\n", mult);*/
	    } 
	else if (!detectsuffix(end,""))  
            errorcode = EBADINT;                /* invalid suffix detected */

        /* if success then store result in parent->ival[] array */
        if (errorcode==0) 
            parent->ival[parent->count++] = val;
        }

    /* printf("%s:scanfn(%p,%p) returns %d\n",__FILE__,parent,argval,errorcode); */
    return errorcode;
}	

