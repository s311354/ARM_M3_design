/*
 * Copyright:
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2014 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     aptimer.c
 * Release:  Version 3.0.1
 * ----------------------------------------------------------------
 *
 *            Timer test
 *            ==========
 */

#include <stdio.h>

#include "CMSDK_driver.h"           //CMSDK Device Driver Header File

#include "aptimer.h"

/* Routine to test timer interrupt */
static unsigned int test_timer_int(CMSDK_TIMER_TypeDef *CMSDK_TIMER, IRQn_Type int_id)
{
    unsigned int failtest = 0;

    if(ap_check_peripheral_interrupt("Timer", int_id, 0))
    {
        printf("Timer irq asserted unexpectedly.\n");
        failtest = TRUE;
    }

    CMSDK_timer_SetValue(CMSDK_TIMER, 1000);

    CMSDK_timer_EnableIRQ(CMSDK_TIMER);

    CMSDK_timer_StartTimer(CMSDK_TIMER);

    apSleep(100);

    CMSDK_timer_StopTimer(CMSDK_TIMER);

    if(ap_check_peripheral_interrupt("Timer", int_id, 1))
    {
        printf("Timer irq did not assert.\n");
        failtest = TRUE;
    }
    else
    {
    	printf("Timer irq asserted.\n");
    }

    CMSDK_timer_DisableIRQ(CMSDK_TIMER);

    CMSDK_timer_ClearIRQ(CMSDK_TIMER);

    NVIC_ClearPendingIRQ(int_id);

	return failtest;
}

/* Routine to test timer frequency */
static void test_timer_freq(CMSDK_TIMER_TypeDef *CMSDK_TIMER)
{
    unsigned int count;

    CMSDK_timer_SetValue(CMSDK_TIMER, 100000000);
    CMSDK_timer_StartTimer(CMSDK_TIMER);

    apSleep (1000);

    CMSDK_timer_StopTimer(CMSDK_TIMER);

    count = CMSDK_timer_GetValue(CMSDK_TIMER);

    printf("\nTimer clock frequency = %d\n",100000000 - count);
}

/* Routine to test dual timer interrupt */
static unsigned int test_dual_timer_int(CMSDK_DUALTIMER_SINGLE_TypeDef *DualTimer, IRQn_Type int_id)
{
    unsigned int failtest = 0;

    if(ap_check_peripheral_interrupt("Dual Timer", int_id, 0))
    {
        printf("Dual Timer irq asserted unexpectedly.\n");
        failtest = TRUE;
    }

    DualTimer->TimerLoad = 1000;
    DualTimer->TimerControl |= (CMSDK_DUALTIMER1_CTRL_EN_Msk | CMSDK_DUALTIMER1_CTRL_SIZE_Msk | CMSDK_DUALTIMER1_CTRL_INTEN_Msk);

    apSleep(100);

    if(ap_check_peripheral_interrupt("Dual Timer", int_id, 1))
    {
        printf("Dual Timer irq did not assert.\n");
        failtest = TRUE;
    }
    else
    {
    	printf("Dual Timer irq asserted.\n");
    }

    DualTimer->TimerControl = 0;

    NVIC_ClearPendingIRQ(int_id);

    return failtest;
}

/* Routine to test dual timer frequency */
static void test_dual_timer_freq(CMSDK_DUALTIMER_SINGLE_TypeDef *DualTimer)
{
	unsigned int count;

    DualTimer->TimerLoad = 100000000;
    DualTimer->TimerControl |= (CMSDK_DUALTIMER1_CTRL_EN_Msk | CMSDK_DUALTIMER1_CTRL_SIZE_Msk);

    apSleep(1000);

    DualTimer->TimerControl = 0;
    count = DualTimer->TimerValue;

    printf("\nTimer clock frequency = %d\n",100000000 - count);
}

/* Test routine for timers */
apError apTIMER_TEST(void)
{
    unsigned int failtest = 0;

    /* Test Timer 0 */
    printf("\nTest CMSDK Timer 0\n");
    failtest = test_timer_int(CMSDK_TIMER0, TIMER0_IRQn);

    test_timer_freq(CMSDK_TIMER0);

    /* Test Timer 1 */
    printf("\nTest CMSDK Timer 1\n");
    failtest = test_timer_int(CMSDK_TIMER1, TIMER1_IRQn);

    test_timer_freq(CMSDK_TIMER1);

    /* Test Dual Timer 1 */
    printf("\nTest Dual Timer 1\n");
    failtest = test_dual_timer_int(CMSDK_DUALTIMER1, DUALTIMER_IRQn);

    test_dual_timer_freq(CMSDK_DUALTIMER1);

    /* Test Dual Timer 2 */
    printf("\nTest Dual Timer 2\n");
    failtest = test_dual_timer_int(CMSDK_DUALTIMER2, DUALTIMER_IRQn);

    test_dual_timer_freq(CMSDK_DUALTIMER2);

    if(failtest)
        return apERR_TIMER_START;
    else
        return apERR_NONE;
}
