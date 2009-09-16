/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_ADC_Control.c
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 23.04.2009
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


#include "types.h"
#include "DSO_ADC_Control.h"
#include "DSO_Remote.h"
#include "stdio.h"

/*uint8_t SendADCConfig(int Request,*/ 

bool SendADCSerial(uart_regs * adc_uart, uint8_t addr, uint8_t data) {
	uint8_t temp = 0;
	SendStringBlock(adc_uart, ADC_PCB_REQUEST);
	SendCharBlock(adc_uart, ADC_CMD_WRITE);
	SendCharBlock(adc_uart, addr);
	SendCharBlock(adc_uart, data);
	ReceiveHeader(adc_uart,ADC_PCB_REPLAY);
	/* A xor A is always 0*/
	temp =  ADC_CMD_WRITE ^ ReceiveCharBlock(adc_uart);
	addr ^= ReceiveCharBlock(adc_uart);
	data ^= ReceiveCharBlock(adc_uart);
	temp = temp + addr + data;
	if (temp == 0) {
		return true;
	} else {
		return false;
	}
}

bool SendADCSerialConfig(uart_regs * adc_uart, ADCSerial cmd[], unsigned int size){
	unsigned int i = 0;
	uint8_t missmatches = 0;
	for (i = 0; i < size; ++i) {
		if (SendADCSerial(adc_uart, cmd[i].addr, cmd[i].data) != cmd[i].data){
			printf("Possible ADC configuration error at addr %d!\n",cmd[i].addr);
			missmatches++;
		}
	}
	if (missmatches != 0){
		return false;
	} 
	return true;
}


