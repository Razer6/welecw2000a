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

#include "irq.h"
#include "DSO_SFR.h"
#include "irqmp.h"

static volatile uint32_t irq_mask;

/*
 * IRQ Routine for DSO Interrupt which is End of Signalcapturing, Encoder IRQ, Key IRQ 
 */
void isr_dso(int irq);

void init_irq(void)
{
	struct irqmp *lr =(struct irqmp*) INTERRUPT_CTL_BASE_ADDR;
	
	/* This is a basic function test of the SignalCapture part */
	/* turning all DSO interrupts off (RESET) */
	WRITE_INT(INTERRUPTADDR,0);
	/* switching all DSO interrupts on */
	WRITE_INT(INTERRUPTMASKADDR,0xf);
	
	/* Enable the interrupt the interrupt controller */
	WRITE_INT(DSO_SFR_BASE_ADDR,15);
	lr->irqlevel = (/*(1 << INT_GENERIC_UART) | (1 << INT_DEBUG_UART) |*/ (1 << INT_DSO));	/* clear level reg */
	lr->irqclear = -1;	/* clear all pending interrupts */
	lr->irqmask  = (/*(1 << INT_GENERIC_UART) | (1 << INT_DEBUG_UART) |*/ (1 << INT_TIMER) | (1 << INT_DSO));	/* mask all interrupts */
	irq_mask = lr->irqmask;
	//lr->irqforce = (/*(1 << INT_GENERIC_UART) | (1 << INT_DEBUG_UART) |*/ (1 << INT_DSO));
	
	/* Enable DSO Interrupt which is End of Signalcapturing, Encoder IRQ, Key IRQ */
	catch_interrupt((uint32_t)isr_dso, INT_DSO);

//	timer_init();
}

/*
 * Disables all interrupts
 */
void disable_irq(void)
{
	struct irqmp *lr =(struct irqmp*) INTERRUPT_CTL_BASE_ADDR;
	irq_mask = lr->irqmask;
	lr->irqmask = 0;
}

/*
 * Enables all interrupts
 */
void release_irq(void)
{
	struct irqmp *lr =(struct irqmp*) INTERRUPT_CTL_BASE_ADDR;
	lr->irqmask = irq_mask;
}

/*
 * IRQ Routine for DSO Interrupt which is End of Signalcapturing, Encoder IRQ, Key IRQ 
 */
void isr_dso(int irq)
{
	switch (irq)
	{
		case 5:
			WRITE_INT(INTERRUPTADDR,0);
		break;
		default:
			WRITE_INT(DSO_SFR_BASE_ADDR,16);
		break;
	}
}
