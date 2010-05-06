/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_ADC_Control.h
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
#ifndef DSO_ADC_CONTROL_H
#define DSO_ADC_CONTROL_H


#define DSO_CHCFG_BAUDRATE 28800
#define ADC_PCB_REQUEST "DSO ADC PCB master thesis v1.0 request "
#define ADC_PCB_REPLAY  "DSO ADC PCB master thesis v1.0 replay  "
#define ADC_MODE            22
#define ADC_CMD_WRITE       33
#define ADC_ANALOG_SETTINGS 44
#define ADC_RELEASE         55
#define ADC_ERROR           66

#define ADC_ADDR_RESET   0x00
#define ADC_PIN_RESET    7

#define ADC_ADDR_READ    0x00
#define ADC_PIN_READ     0

#define ADC_ADDR_SPEED   0x20
#define ADC_PIN_LSPEED   2

#define ADC_ADDR_POWER   0x3f
#define ADC_PIN_OBUFFER  0
#define ADC_PIN_STBY     1
#define ADC_PIN_PDN      2
#define ADC_PIN_MODE0    6
#define ADC_PIN_MODE1    7

#define ADC_ADDR_DFS     0x41
#define ADC_PIN_DFS0     6
#define ADC_PIN_DFS1     7

#define ADC_ADDR_CLK     0x44
#define ADC_PIN_FALL0    2
#define ADC_PIN_FALL1    3
#define ADC_PIN_FALL2    4
#define ADC_PIN_RISE0    5
#define ADC_PIN_RISE1    6
#define ADC_PIN_RISE2    7

#define ADC_ADDR_FORMAT  0x50
#define ADC_PIN_FORMAT0  2
#define ADC_PIN_FORMAT1  3

#define ADC_ADDR_CPAT0   0x51
#define ADC_ADDR_CPAT1   0x52

#define ADC_ADDR_OFFSETE 0x53
#define ADC_PIN_OFFSETE  6

#define ADC_ADDR_OFFSETD 0x55
#define ADC_PIN_OTIME0   0
#define ADC_PIN_OGAIN0   4

#define ADC_ADDR_DPAT    0x62
#define ADC_PIN_DPAT0    0
#define ADC_PIN_DPAT1    1
#define ADC_PIN_DPAT2    2

#define ADC_ADDR_PEDEST  0x63

#ifdef LEON3
typedef struct {
       uint8_t addr;
       uint8_t data;
} ADCSerial;	

#define ADC_SPEC_PGM_CLK   0
#define ADC_SPEC_PGM_OFS   1
#define ADC_SPEC_PGM_PAT   2
#define ADC_SPEC_OTIME     8
#define ADC_SPEC_OGAIN    12
#define ADC_SPEC_CLKF     16
#define ADC_SPEC_CLKR     20
#define ADC_SPEC_PATTERN  24

#include "Leon3Uart.h"
bool SendADCSerial(uart_regs * adc_uart, uint8_t addr, uint8_t data);
bool SendADCSerialConfig(uart_regs * adc_uart, ADCSerial cmd[], unsigned int size);
#endif

#endif

