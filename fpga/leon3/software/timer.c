#include "timer.h"
#include "DSO_Main.h"
#include "DSO_Font.h"
#include "GUI.h"
#include "util.h"

#include "DSO_Misc.h"
#include "string.h"
#include "asm-leon/leon.h"

#define CONFIG_DF_BIT			9
#define CONFIG_SI_BIT			8
#define CONFIG_IRQ_BIT			3
#define CONFIG_NR_TIMERS_BIT	0

#define CONFIG_NR_TIMERS_MASK	0x7
#define CONFIG_IRQ_MASK			0xF8

#define TIMER_DEBUG_HALT_BIT	6
#define TIMER_CHAIN_BIT			5
#define TIMER_INT_PENDING_BIT	4
#define TIMER_INT_ENABLE_BIT	3
#define TIMER_LOAD_BIT			2
#define TIMER_RESTART_BIT		1
#define TIMER_ENABLE_BIT		0

extern int catch_interrupt (int func, int irq);

typedef struct
{
	uint32_t scaler;
	uint32_t scaler_reload;
	uint32_t config;
	uint32_t unused;
	uint32_t timer1_value;
	uint32_t timer1_reload;
	uint32_t timer1_control;
} timer_sfr_t;

void timer_setup(uint8_t timer, uint32_t reload);
void timer_clear_interrupt(uint8_t timer);

timer_sfr_t *timer_sfr = (timer_sfr_t *)TIMER_BASE_ADDR;

void timer_init()
{
	timer_setup(1, 0xFFFF);
}

void timer_interrupt(int irq)
{
	static uint32_t count = 0;
	int str[10];
	/*
	static uint32_t flag = 0;

	if (flag == 0)
	{
		WRITE_INT(LEDADDR, 0xFFFF);
		flag = 1;
	}
	else
	{
		WRITE_INT(LEDADDR, 0x0000);
		flag = 0;
	}
	*/

	itoa(count++, str);
	printStr_lcdi(&FONT_STATUS_BAR, 480, STATUS_BAR_START_Y, STATUS_BAR_COLOR_FG, STATUS_BAR_COLOR_BG, str);
	timer_clear_interrupt(1);
}

void timer_setup(uint8_t timer, uint32_t reload)
{
	timer_sfr->timer1_control &= ~(1 << TIMER_ENABLE_BIT);
	timer_sfr->timer1_reload = reload;
	timer_sfr->timer1_control |= (1 << TIMER_INT_ENABLE_BIT) | (1 << TIMER_LOAD_BIT) | (1 << TIMER_RESTART_BIT) | (1 << TIMER_ENABLE_BIT);
	catch_interrupt((uint32_t)timer_interrupt, 8);
}

void timer_clear_interrupt(uint8_t timer)
{
	timer_sfr->timer1_control &= ~(1 << TIMER_INT_PENDING_BIT);
}

uint32_t debug1()
{
	return 0;
}

uint32_t debug2()
{
	return timer_sfr->timer1_value;
}

uint32_t debug3()
{
	return timer_sfr->timer1_reload;
}

uint32_t debug4()
{
	return timer_sfr->timer1_control;
}
