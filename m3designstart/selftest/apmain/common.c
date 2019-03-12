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
 * File:     common.c
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 *
 */

/*
 * Code implementation file for the common functions.
 */

#include <stdio.h>

#include "SMM_MPS2.h"                   // MPS2 common header

#include "common.h"

// Declaration of the global used to indicate AutoRun mode
unsigned int RunAllTests;

/* Sleep function to delay n*mS
 * Uses FPGA counter. Prescale is set to divide 25MHZ
 * to 1MHz
 */
void apSleep(unsigned int msec)
{
	unsigned int end;
	unsigned int start;

    start = MPS2_FPGAIO->COUNTER;
    end   = start + (25 * msec * 1000);

    if(end >= start)
    {
        while (MPS2_FPGAIO->COUNTER >= start && MPS2_FPGAIO->COUNTER < end);
    }
    else
    {
        while (MPS2_FPGAIO->COUNTER >= start);
        while (MPS2_FPGAIO->COUNTER < end);
    }
}

/* Sleep function to delay n*uS
 */
void apSleepus(unsigned int usec)
{
	unsigned int end;
	unsigned int start;

    start = MPS2_FPGAIO->COUNTER;
    end   = start + (25 * usec);

    if(end >= start)
    {
        while (MPS2_FPGAIO->COUNTER >= start && MPS2_FPGAIO->COUNTER < end);
    }
    else
    {
        while (MPS2_FPGAIO->COUNTER >= start);
        while (MPS2_FPGAIO->COUNTER < end);
    }
}

// Checks whether interrupt for this peripheral is pending. 
int ap_check_peripheral_interrupt(char * const periphName, unsigned int_id, const int asserted)
{
    printf("");
    if(!periphName) {
        apDebug("Error: Null peripheral name.\n");
        return TRUE;
    }
    
    // Checking whether asserted
    if(asserted) 
    {
        if(!(NVIC_GetPendingIRQ((IRQn_Type)int_id))) 
        {
            printf_err("Error: NVIC Pending Status for %s is incorrect. "
                "Read: %#08x, Expected: %#08x\n",periphName, 
                NVIC->ICPR[((uint32_t)(int_id) >> 5)] & (1 << (int_id & 0x1F)), (1 << (int_id & 0x1F)));
            return TRUE;
        }
        else 
        {
            // its correct
            return FALSE;
        }
    }
    else if(!asserted) 
    {
        if(NVIC_GetPendingIRQ((IRQn_Type)int_id)) 
        {
            printf_err("Error: NVIC Pending Status for %s is incorrect. "
                "Read: %#08x, Expected: %#08x\n",periphName,
                NVIC->ICPR[((uint32_t)(int_id) >> 5)] & (1 << (int_id & 0x1F)), (1 << (int_id & 0x1F)));
            return TRUE;
        }
        else 
        {
            // its correct
            return FALSE;
        }
    }
    // Should never come here.
    return TRUE;
}

/* Register bit(s) test */
unsigned int register_test(volatile unsigned int *addr,int firstbit, int lastbit)
{
    int n;
    unsigned int origval;

    origval = *addr;

    for (n=0;n<32;n++) {
        if (n >= firstbit && n <= lastbit) {
            *addr=1 << n;
            apSleepus(10);
            if (!(*addr & (1 << n)))
                return ((1 << 5) | n);
        }
    }

    for (n=0;n<32;n++) {
        if (n >= firstbit && n <= lastbit) {
            *addr = 0xffffffff ^ (1 <<n);
            apSleepus(10);
            if (*addr & (1 <<n))
                return ((2<<5)|n);
        }
    }
    *addr = origval;
    return 0;
}

void Wait_For_Enter(int always)
{
    int c=0;

    if (!RunAllTests || always) {
        printf ("Press Enter to continue...");

        do
        {
        	fflush(stdin);
            c = getchar ();
        }
        while ((c != '\n') && (c != EOF));
    }
    printf ("Running...\n");
}

// Ask user for the result of the test
int Get_OK(void)
{
	int c, response;

    do
    {
        fflush(stdin);
        c = getchar ();
        
        if ((c == 'y') || (c == 'Y'))
        {
            response = TRUE;
            getchar();
        }
        else if ((c == 'n') || (c == 'N'))
        {
            response = FALSE;
            getchar();
        }
        else
            c = EOF;
    }
    while (c == EOF);

    return response;
}

#include <string.h>

int GetChars(char *str)
{
    int c = 0;
    int i = 0;
    int found = 0;
    int len = strlen(str);
    
    do
    {
        fflush(stdin);
        c = getchar ();
        for(i = 0; i < len; i++) {
            if (str[i] == c) {
                found = 1;
                break;
            }
        }
        if (found == 1)
            break;
    } while (1);

    return c;
}

