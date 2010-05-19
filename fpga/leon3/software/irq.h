/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : irq.c
* Author       : Robert Schilling <robert.schilling at gmx.at
* Date          : 17.05.2010
*****************************************************************************
* Description	 : Interrupt control of leon3
*****************************************************************************

*  Copyright (c) 2010, Schilling Robert

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

#ifndef __IRQ_H__
#define __IRQ_H__

/*
 * Registrates a function to an interrupt vector
 */
extern int catch_interrupt (int func, int irq);

void init_irq(void);

/*
 * Disables all interrupts
 */
void disable_irq(void);

/*
 * Enables all interrupts
 */
void release_irq(void);

#endif