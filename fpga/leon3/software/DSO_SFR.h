/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : DSO_SFR.h
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 20.04.2009
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
#ifndef DSO_SFR_H
#define DSO_SFR_H

#include "DSO_Main.h"
/* TODO make this doxygen conform*/

#define DEVICEADDR               (DSO_SFR_BASE_ADDR+ 4*0)
#define INTERRUPTADDR            (DSO_SFR_BASE_ADDR+ 4*1)
#define INTERRUPTMASKADDR        (DSO_SFR_BASE_ADDR+ 4*2)
#define SAMPLINGFREQADDR         (DSO_SFR_BASE_ADDR+ 4*4)
#define FILTERENABLEADDR         (DSO_SFR_BASE_ADDR+ 4*5)
#define EXTTRIGGERSRCADDR        (DSO_SFR_BASE_ADDR+ 4*6)
#define EXTTRIGGERPWMADDR        (DSO_SFR_BASE_ADDR+ 4*7)
#define INPUTCH0ADDR             (DSO_SFR_BASE_ADDR+ 4*8)
#define INPUTCH1ADDR             (DSO_SFR_BASE_ADDR+ 4*9)
#define INPUTCH2ADDR             (DSO_SFR_BASE_ADDR+ 4*10)
#define INPUTCH3ADDR             (DSO_SFR_BASE_ADDR+ 4*11)
#define TRIGGERONCHADDR          (DSO_SFR_BASE_ADDR+ 4*12)
#define TRIGGERONCEADDR          (DSO_SFR_BASE_ADDR+ 4*13)
#define TRIGGERPREFETCHADDR      (DSO_SFR_BASE_ADDR+ 4*14)
#define TRIGGERSTORAGEMODEADDR   (DSO_SFR_BASE_ADDR+ 4*15)
#define TRIGGERREADOFFSETADDR    (DSO_SFR_BASE_ADDR+ 4*16)
#define TRIGGERTYPEADDR          (DSO_SFR_BASE_ADDR+ 4*17)
#define TRIGGERLOWVALUEADDR      (DSO_SFR_BASE_ADDR+ 4*18)
#define TRIGGERLOWTIMEADDR       (DSO_SFR_BASE_ADDR+ 4*19)
#define TRIGGERHIGHVALUEADDR     (DSO_SFR_BASE_ADDR+ 4*20)
#define TRIGGERHIGHTIMEADDR      (DSO_SFR_BASE_ADDR+ 4*21)
#define TRIGGERSTATUSREGISTER    (DSO_SFR_BASE_ADDR+ 4*22)
#define TRIGGERCURRENTADDR       (DSO_SFR_BASE_ADDR+ 4*23)
#define CONFIGADCENABLE          (DSO_SFR_BASE_ADDR+ 4*24)
#define LEDADDR                  (DSO_SFR_BASE_ADDR+ 4*25)
#define KEYADDR                 (DSO_SFR_BASE_ADDR+ 4*26)
#define ENC_TIMBASE_ADDR  	(DSO_SFR_BASE_ADDR+ 4*27)
#define ENC_LEFTRIGHT_ADDR  	(DSO_SFR_BASE_ADDR+ 4*28)
#define ENC_LEVEL_ADDR  	(DSO_SFR_BASE_ADDR+ 4*29)
#define ENC_F_ADDR  	(DSO_SFR_BASE_ADDR+ 4*30)
#define ENC_VDIV_CH0_ADDR  	(DSO_SFR_BASE_ADDR+ 4*31)
#define ENC_VDIV_CH1_ADDR  	(DSO_SFR_BASE_ADDR+ 4*32)
#define ENC_VDIV_CH2_ADDR  	(DSO_SFR_BASE_ADDR+ 4*33)
#define ENC_VDIV_CH3_ADDR  	(DSO_SFR_BASE_ADDR+ 4*34)
#define ENC_UPDN_CH0_ADDR  	(DSO_SFR_BASE_ADDR+ 4*35)
#define ENC_UPDN_CH1_ADDR  	(DSO_SFR_BASE_ADDR+ 4*36)
#define ENC_UPDN_CH2_ADDR  	(DSO_SFR_BASE_ADDR+ 4*37)
#define ENC_UPDN_CH3_ADDR  	(DSO_SFR_BASE_ADDR+ 4*38)
#define ANALOGSETTINGSADDR       (DSO_SFR_BASE_ADDR+ 4*39)
#define LASTADDR                 (DSO_SFR_BASE_ADDR+ 4*40)

#define DSO_REG_SIZE             (4*40)

/* DEVICEADDR*/
#define WELEC2012   (2012)
#define WELEC2014   (2014)
#define WELEC2022   (2022)
#define WELEC2024   (2024)
#define SANDBOXX    (1014)
#define CURRENTDEVICE   (WELEC2022)

#define WELECMAXFS	1000000000
/* The first decimator is for the parallel input data (eg. 1Gs @ 125 MHz)*/
/* If this is not used the max fs must be set 10 times higher! */
#define SANDBOXXFS   (100000000*10)


/*INTERRUPTADDR*/
#define CAPTUREDATA_FINISHED     0
#define CAPTUREDATA_TRIGGERED    1
#define ANALOGSETTINGS_FINISHED  2
#define KEYCHANGE                3 


/* SAMPLINGFREQADDR*/
/* write the sampling frequence as decimal number in Hz*/
/* unsupported sampling frequencys are set to 1 GS!*/

/* FILTERENABLEADDR*/
/* Digital Anti Aliasing Filter Enable*/
/* For now on the W2000A*/
#define D1GHZTO100MHZ  0
#define D100MHZTO10MHZ 1
#define D10MHZTO1MHZ   2
#define D1MHZTO100KHZ  3

/* EXTTRIGGERSRCADDR*/
#define FORCETOGGE  0
#define EXTTRIGGER1 1
/* Note that most devices have none only one Exttrigger input!*/
/* Welec W20xx devices have 1*/
/* SandboxX has also only 1*/
#define MAX_EXT_TRIGGER 1
#define EXTTRIGGER2 2
#define EXTTRIGGER3 3
#define EXTTRIGGER4 4

/* ...*/

/* EXTTRIGGERPWMADDR*/
#define EXTTRIGGERPWM0_STARTBIT 0 
#define EXTTRIGGERPWM1_STARTBIT 8
#define EXTTRIGGERPWM2_STARTBIT 16
#define EXTTRIGGERPWM3_STARTBIT 24


/* INPUTCH0ADDR INPUTCH1ADDR INPUTCH2ADDR INPUTC3ADDR*/
/* Signal Selector: The trigger does always have on each device 4 channels with each 8 bits*/
/* For the lower 8 bits from a 16 bit signal use CHxLOWER */
#define CH0UPPER 0
#define CH1UPPER 1
#define CH2UPPER 2
#define CH3UPPER 3
#define CH0LOWER 4
#define CH1LOWER 5
#define CH2LOWER 6
#define CH3LOWER 7

/* TRIGGERONCHADDR*/
/* Trigger on Channel out of the SignalSelector*/
#define INCH0ADDR 0
#define INCH1ADDR 1
#define INCH2ADDR 2
#define INCH3ADDR 3

/* TRIGGERONCEADDR*/
/* start trigger one time, no continious triggering on the hardware (because it's stupid)*/
/* write 1 to start and 0 to stop the trigger*/

/* TRIGGERPREFETCHADDR*/
/* Here you can set the frame start address for the triggered buffer.*/
/* When the trigger is started, it first writes  TRIGGERPREFETCHADDR */
/* samplesint o the trigger data RAM before the trigger starts triggering.*/
/* It is simply the data offset of the triggered sample, so post triggering is possible!*/

/* TRIGGERSTORAGEMODEADDR*/
/* Data of the TRIGGER_MEM address range */
/* Data(i)(j) data bits from ((i+1)*8)+j-1 (i*8)+j*/
/* chx(k) is the sample offset */
/* TODO: Correct it + 4*This may change, too!*/
#define TRIGGERSTORAGEMODE4CH 0
/* "00" :     4 CH each  8 KB*/
/* Data(0)(0) = ch0(0), Data(1)(0) = ch1(0), Data(2)(0) = ch2(0), Data(3)(0) = ch3(0)*/
#define TRIGGERSTORAGEMODE2CH 1
/* "01" :     2 CH each 16 KB*/
/*#define 0)(0) = ch0(0), Data(1)(0) = ch1(0), Data(2)(0) = ch0(8192), Data(3)(0) = ch1(8192)*/
#define TRIGGERSTORAGEMODE1CH 3
/* "11" :     1 CH with 32 KB*/
/* Data(0)(0) = ch0(0),#define (1)(0) = ch0(8192),#define (2)(0) = ch0(16384),#define (3)(0) = ch0(24576)*/

/* TRIGGERREADOFFSETADDR*/
/* start and stop address for the trigger */
/* write on it and the trigger sample capture size can be extended easily by software*/
/* but take care about the TRIGGERCURRENTADDR and the sampling speed to avoid race conditions*/
/* TRIGGERTYPEADDR*/
/* Choose the trigger type here */
#define EXTTRIGGER_LH    0
#define EXTTRIGGER_HL    1
#define NORMALTRIGGER_LH 2 
#define NORMALTRIGGER_HL 3 
#define GLITCHTRIGGER_LH 4 
#define GLITCHTRIGGER_HL 5 
#define DIGITALTRIGGER_ARRIVE 6 
#define DIGITALTRIGGER_LEAVE 7 
#define MAX_TRIGGER_TYPES 8
/* TODO add more trigger types*/

typedef enum TriggerTypes
{
	NORMAL_TRIGGER = 2,
	GLITCH_TRIGGER = 4,
	EXTERNAL_TRIGGER = 0
}
eTriggerTypes;


/* NORMALTRIGGER is an 8 bit trigger*/
/* The NORMALTRIGGER is a schmitt trigger with an stable counter.*/
/* TRIGGERLOWVALUEADDR  is the low reference level.*/
/* TRIGGERLOWTIMEADDR   is the minimum stable time for the low level in samples.*/
/* TRIGGERHIGHVALUEADDR is the high reference level.*/
/* TRIGGERHIGHTIMEADDR  is the minimum stable time for the high level in samples.*/

/* TRIGGERSTATUSREGISTER   */
#define TRIGGERBUSYBIT      0
#define TRIGGERRECORDINGBIT 1

/* TRIGGERCURRENTADDR  */
/* read only */

/* CONFIGADCENABLE */
/* for SandboxX and possible other boards which using a seperate microprocessor to 
 * make the analog settings now this is a wake up legacy interrupt to enable the uart
 * communication */
#define ADC0 0
#define ADC1 1
/* ... */

/* LEDADDR*/
/* switch on the led by setting the corresponding bit to 1*/
/* TODO interrupt */
#define LED_CH0        0
#define LED_CH1        1
#define LED_CH2        2
#define LED_CH3        3
#define LED_MATH       4
#define LED_QUICKMEAS  5
#define LED_CURSORS    6
#define LED_WHEEL      7
#define LED_PULSEWIDTH 8
#define LED_EDGE       9
#define RUN_RED       10
#define RUN_GREEN     11
#define SINGLE_RED    12
#define SINGLE_GREEN  13

#define SET_LED(Led) WRITE_INT(LEDADDR, (READ_INT(LEDADDR) |  (1 << Led)))
#define CLR_LED(Led) WRITE_INT(LEDADDR, (READ_INT(LEDADDR) & ~(1 << Led)))

/*  (read only) */
/* rotary nob counter (3 bit) base adresses */
#define EN_TIME_DIV    16
#define EN_LEFT_RIGHT  20
#define EN_LEVEL       24
#define EN_F           28


/* KEYADDR0 */
/* (read only)*/
#define EN_CH0_UPDN    0
#define EN_CH1_UPDN    4
#define EN_CH2_UPDN    8
#define EN_CH3_UPDN   12
#define EN_CH0_VDIV   16
#define EN_CH1_VDIV   20
#define EN_CH2_VDIV   24
#define EN_CH3_VDIV   28


/* KEYADDR1 */
/* (read only)*/
#define BTN_F1           0
#define BTN_F2           1
#define BTN_F3           2
#define BTN_F4           3
#define BTN_F5           4
#define BTN_F6           5
#define BTN_MATH         6
#define BTN_CH0          7
#define BTN_CH1          8
#define BTN_CH2          9
#define BTN_CH3         10
#define BTN_MAINDEL     11
#define BTN_RUNSTOP     12
#define BTN_SINGLE      13
#define BTN_CURSORS     14
#define BTN_QUICKMEAS   15
#define BTN_ACQUIRE   	16
#define BTN_DISPLAY     17
#define BTN_EDGE        18
#define BTN_MODECOUPLING 19
#define BTN_AUTOSCALE   20
#define BTN_SAVERECALL  21
#define BTN_QUICKPRINT  22
#define BTN_UTILITY     23
#define BTN_PULSEWIDTH  24 
#define BTN_X1          25
#define BTN_X2          26

#define ROTARYMOVE(m,k,p) \
	m = k - p; \
	switch (m){\
		case 4: m = 0; break;\
		case 5: m = -3; break;\
		case 6: m = -2; break;\
		case 7: m = -1; break;\
		case -4: m = 0; break;\
		case -5: m = 3; break;\
		case -6: m = 2; break;\
		case -7: m = 1; break;\
	}\
        p = k




/* ANALOGSETTINGSADDR */
#define SET_PWM_OFFSET     31
#define PWM_OFFSET_SIZE     8
#define ANALOGDATA_START    0
#define ENABLEKEYCLOCK     30 
#define ENABLEPROBECLOCK   29 
#define ENABLEPROBESTROBE  28


#define	ANALOGSETTINGSBUSY 27
#define ANC_ADDR_OFFSET    24 
#define	SET_ANALOG(addr)   ((1 << ENABLEKEYCLOCK) | (1 << ENABLEPROBECLOCK) | (1 << 27) | ((addr & 0x7) << ANC_ADDR_OFFSET))

#define ANC_CH0       7 
/* subset of ANC_CH0 */
#define CH0_K1_10     0
#define CH0_K1_1      1
#define CH0_K2_10     2
#define CH0_K2_1      3
#define CH0_OPA656    4
#define CH0_BW_Limit  5
#define CH0_U14       6
#define CH0_U13       7
#define CH0_DC        8
#define CH1_DC        9
#define CH2_DC       10
#define CH3_DC       11




#define ANC_DAC0       6 
/* subset of ANC_DAC0 */
#define DAC_OFFSET 0
#define DAC_CH_OFFSET 16
#define DAC_SETT_OFFSET 17
#define SET_OFFSET_CH0(offset) (SET_ANALOG(ANC_DAC0) | (0x30 << DAC_CH_OFFSET) | (1 << DAC_CH_OFFSET) | (offset & 0xffff))
#define SET_OFFSET_CH1(offset) (SET_ANALOG(ANC_DAC0) | (0x30 << DAC_CH_OFFSET) | (offset & 0xffff))


#define ANC_CH1       5 
/* subset of ANC_CH1 */
#define CH1_K1_10      0
#define CH1_K1_1       1
#define CH1_K2_10      2
#define CH1_K2_1       3
#define CH1_OPA656     4
#define CH1_BW_Limit   5
#define CH1_U14        6
#define CH1_U13        7
#define CH0_SRC2_ADDR  8
#define CH1_SRC2_ADDR 10
#define CH2_SRC2_ADDR 12
#define CH3_SRC2_ADDR 14


/* CHX_SRC2_ADDR*/
#define SRC2_NONE    0
#define SRC2_PWM     1
#define SRC2_GND     2
#define SRC2_LOWPASS 3


/*int Uart16550Addr          40;*/
/*int Uart16550Data          41;*/


#define CH0		0
#define CH1		1
#define CH2		2
#define	CH3		3

#endif

 	  	 
