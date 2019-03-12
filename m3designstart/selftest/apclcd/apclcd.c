/*
 * Copyright:
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2013 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     apclcd.c
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 */

/*
 * Code implementation file for the Color LCD interface.
 */

#include <stdio.h>
#include <stdlib.h>

#include "GLCD_SPI_MPS2.h"

#include "apclcd.h"

// CLCD test
apError apCLCD_TEST(void)
{
    int failtest;

    failtest = FALSE;

    // Some instructions
    printf("The CLCD test will fill the LCD display with\n");
    printf("a test pattern image.\n");
	Wait_For_Enter(FALSE);

    // CLCD screen register setup
    GLCD_Initialize();

    // Fill CLCD screen
    GLCD_Clear(Black);

    // Draw intro screen image
    GLCD_Bitmap (0, 0, 320, 240, (unsigned short *)flyerData);

    printf("\nDid the test pattern display correctly  (Y/N): ");
    if (!Get_OK())
        failtest = TRUE;

    // Fill CLCD screen
    GLCD_Clear(Black);

    // Draw intro screen image
    GLCD_Bitmap (0, 0, 320, 240, (unsigned short *)introData);

    if (failtest)
        return apERR_CHARLCD_START;
    else
    	return apERR_NONE;
}
