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
 * File:     apleds.c
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 * 
 */
  
/*
 * Code implementation file for the LEDs interface.
 */

#include <stdio.h>
#include <stdlib.h>

#include "SMM_MPS2.h"                   // MPS2 common header

#include "apleds.h"

apError apLEDS_TEST()
{
    int             timer, failtest, loop;
    unsigned char   swok, oldswok;
    
    failtest = FALSE;
    
    /* The USER LEDS/SW are connected to the MCC but the user W/R the
     * FPGA registers which are continuously R/W by the MCC and copied
     * to the LEDS/SW.
     */

    // Some instructions for the user
    printf("The test will mirror the 8-way switch (S3) setting on the\n");
    printf("USER LED lights (0-7). Enable one switch at a time and check\n");
    printf("the corresponding LED lights up.\n");
    Wait_For_Enter(FALSE);

    // As each switch is set that bit is stored until all switches have been tested
    swok  = 0x00;
    timer = 500;
    do {
        // Mirror the Switch to the LEDs
        MPS2_SCC->LEDS = MPS2_SCC->SWITCHES & 0xFF;

        // Save each switch enabled
        if ((MPS2_SCC->SWITCHES & 0x01) == 0x01)
            swok |= 0x01;
        if ((MPS2_SCC->SWITCHES & 0x02) == 0x02)
            swok |= 0x02;
        if ((MPS2_SCC->SWITCHES & 0x04) == 0x04)
            swok |= 0x04;
        if ((MPS2_SCC->SWITCHES & 0x08) == 0x08)
            swok |= 0x08;
        if ((MPS2_SCC->SWITCHES & 0x10) == 0x10)
            swok |= 0x10;
        if ((MPS2_SCC->SWITCHES & 0x20) == 0x20)
            swok |= 0x20;
        if ((MPS2_SCC->SWITCHES & 0x40) == 0x40)
            swok |= 0x40;
        if ((MPS2_SCC->SWITCHES & 0x80) == 0x80)
            swok |= 0x80;

        // Display detected switches
        if (swok != oldswok) {
            printf("Switches detected:");
            for (loop = 0; loop < 8; loop++) {
                printf("%c", (swok & (1 << loop)) ? 0x31 : 0x30);
            }
            printf("\n");
            oldswok = swok;
        }

        // Define time interval
        apSleep(100);
        timer--;
    } while ((swok != 0xFF) && timer);

    if (!timer) {
        printf("Error: Timeout detecting switches\n");
        failtest = TRUE;
    }
    
    // Set all the switches back to OFF
    printf("Please turn all S3 switches OFF...\n");
    timer = 100;
    while (((MPS2_SCC->SWITCHES & 0xFF) != 0x00) && timer) {
        apSleep(100);
        timer--;
    }
    if (!timer) {
        printf("Error: Timeout all the switches were not OFF\n");
        failtest = TRUE;
    }

    // Set all the LEDs to OFF
    MPS2_SCC->LEDS = 0x00;
    printf("\nDid all the LEDs light (Y/N): ");
    if (!Get_OK())
        failtest = TRUE;

    // The two USER buttons that are connected directly to the FPGA

    // Some instructions for the user
    printf("USER push button test...\n");
    Wait_For_Enter(FALSE);

    // Test the buttons are released
    if ((MPS2_FPGAIO->BUTTON & 0x03) != 0x00)
    {
        printf("Error: USER buttons are pressed (0x%02X)\n", MPS2_FPGAIO->BUTTON & 0x03);
        failtest = TRUE;
    }

    // Test push buttons 0
    printf("Please press USER push button 0 (S4)\n");
    timer = 100;
    while (((MPS2_FPGAIO->BUTTON & 0x03) != 0x01) && timer) {
        apSleep(100);
        timer--;
    }
    if (!timer) {
        printf("Error: Timeout waiting for USER push button 0\n");
        failtest = TRUE;
    }

    // Test push buttons 1
    printf("Please press USER push button 1 (S5)\n");
    timer = 100;
    while (((MPS2_FPGAIO->BUTTON & 0x03) != 0x02) && timer) {
        apSleep(100);
        timer--;
    }
    if (!timer) {
        printf("Error: Timeout waiting for USER push button 1\n");
        failtest = TRUE;
    }

    if (failtest)        
        return apERR_LEDS_START;
    else
        return apERR_NONE;
}
