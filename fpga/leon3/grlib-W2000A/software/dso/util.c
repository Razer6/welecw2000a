/*
 * util.c
 *
 *  Created on: 11.03.2010
 *      Author: Robert
 */

int strleni(int *str)
{
	int count=0;
	while(str[count] != '\0')
		count++;
	return count;
}


/* reverse:  reverse string s in place */
void reverse(int s[])
{
    register int i, j;
    register int c;

    for (i = 0, j = strleni(s)-1; i<j; i++, j--)
    {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}


void itoa(int n, int s[])
{
    register int i, sign;

    if ((sign = n) < 0)  /* record sign */
        n = -n;          /* make n positive */
    i = 0;
    do {       /* generate digits in reverse order */
        s[i++] = n % 10 + '0';   /* get next digit */
    } while ((n /= 10) > 0);     /* delete it */
    if (sign < 0)
        s[i++] = '-';
    s[i] = '\0';
    reverse(s);
}

