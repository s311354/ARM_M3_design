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
 * File:     aptsc.c
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 */

/*
 * Code implementation file for the Touch Screen Controller interface.
 */

// Screen size
#define LCD_WIDTH           320         // Screen Width (in pixels)
#define LCD_HEIGHT          240         // Screen Height (in pixels)


#include <stdio.h>
#include <stdlib.h>

#include "GLCD_SPI_MPS2.h"
#include "TSC_I2C_MPS2.h"

#include "aptsc.h"

extern const unsigned short introData[];

// Initialise TSC
int apTSC_INIT(void)
{
	unsigned int din, err;

	err = FALSE;

	// Clear the TSC I2C interface as there is no RESET control
    TSC_I2C_clear();

    // Read and check the I2C chip ID
    din = TSC_I2C_read(TSC_I2C_CRID, TSC_I2C_ADDR, 2);
    if (din != TSC_I2C_CID)
    {
        printf("ERROR: TSC ID:0x%04X\n", din);
        err = TRUE;
    }
    else
    {
        printf("TSC ID:0x%04X\n", din);

		// Initialise the TSC I2C interface
		TSC_I2C_write(0x40, 0x03, TSC_I2C_ADDR);

		// Reset Touch-screen controller
		TSC_I2C_write(0x03, 0x03, TSC_I2C_ADDR);
		apSleepus(10000);

		// Enable TSC and ADC
		TSC_I2C_write(0x04, 0x0C, TSC_I2C_ADDR);

		// Enable Touch detect, FIFO
		TSC_I2C_write(0x0A, 0x07, TSC_I2C_ADDR);

		// Set sample time , 12-bit mode
		TSC_I2C_write(0x20, 0x39, TSC_I2C_ADDR);
		apSleepus(2000);

		// ADC frequency 3.25 MHz
		TSC_I2C_write(0x21, 0x01, TSC_I2C_ADDR);

		// Set TSC_CFG register
		TSC_I2C_write(0x41, 0xF5, TSC_I2C_ADDR);

		// Threshold for FIFO
		TSC_I2C_write(0x4A, 0x02, TSC_I2C_ADDR);

		// FIFO reset
		TSC_I2C_write(0x4B, 0x01, TSC_I2C_ADDR);
		apSleepus(1000);
		TSC_I2C_write(0x4B, 0x00, TSC_I2C_ADDR);

		// Fraction Z
		TSC_I2C_write(0x56, 0x07, TSC_I2C_ADDR);

		// Drive 50 mA typical
		TSC_I2C_write(0x58, 0x01, TSC_I2C_ADDR);

		// Enable TSC
		TSC_I2C_write(0x40, 0x01, TSC_I2C_ADDR);

		// Clear interrupt status
		TSC_I2C_write(0x0B, 0xFF, TSC_I2C_ADDR);

		// Enable global interrupt
		TSC_I2C_write(0x09, 0x01, TSC_I2C_ADDR);

		// Clear status register
		TSC_I2C_write(0x0B, 0xFF, TSC_I2C_ADDR);
    }

    return err;
}

// Initialise LCD display image
void apTSC_LCDINIT(void)
{
    unsigned int X, Y;

    // Fill screen
    GLCD_Clear(Black);

    GLCD_SetTextColor (White);
    
    // Set the screen border
    GLCD_Boarder ();

    // Set blue box
    GLCD_Box (1, 200, 79, 39, Blue);
    
    // Set red box
    GLCD_Box (240, 200, 79, 39, Red);

	// Box borders
    for (Y = 200; Y < 240; Y++)
    {
    	GLCD_PutPixel ( 80, Y);
    	GLCD_PutPixel (239, Y);
    }
    for (X = 0; X < 80; X++)
    {
    	GLCD_PutPixel (X +   1, 200);
    	GLCD_PutPixel (X + 239, 200);
    }
}

// TSC test
apError apTSC_TEST(void)
{
    unsigned int failtest, loop, din, isr, done;
    unsigned int X, Y, XPXL, YPXL, XPXLN, YPXLN, pendown;
    //unsigned int Z;

    failtest = FALSE;
    done     = FALSE;
	pendown  = FALSE;

    // Some instructions
    printf("\nThe touchscreen test will allow drawing on the CLCD screen.\n");
    printf("Please use the BLUE box: Clear Screen, RED box: Exit.\n");
	Wait_For_Enter(FALSE);

    // TSC register setup
    failtest = apTSC_INIT();

    // CLCD screen register setup
    GLCD_Initialize();

    // CLCD image setup
    apTSC_LCDINIT();

	do
    {
    	// Read interrupt status
    	isr = TSC_I2C_read(0x0B, TSC_I2C_ADDR, 1);

    	// Clear pen down if state changes
    	if (isr & 0x01)
    		pendown = FALSE;

    	// Test for FIFO_TH interrupt
    	if (isr & 0x02)
    	{
			// Empty the FIFO
			loop = TSC_I2C_read(0x4C, TSC_I2C_ADDR, 1);
			while (loop > 1)
			{
				din = TSC_I2C_read(0xD7, TSC_I2C_ADDR, 4);
				loop--;
			}

			// Clear the interrupt (must be immediately after FIFO empty)
			TSC_I2C_write(0x0B, isr, TSC_I2C_ADDR);

			// Read coordinates
			din = TSC_I2C_read(0xD7, TSC_I2C_ADDR, 4);
			X = (din >> 20) & 0x00000FFF;
			Y = (din >>  8) & 0x00000FFF;
			//Z = (din >>  0) & 0x0000000F;

			//printf("X:0x%04X, Y:0x%04X\n", X, Y);

			// Calculate the pixel position (X/Y are swapped)
			XPXL = LCD_WIDTH - ((Y * 10) / (TSC_MAXVAL / LCD_WIDTH)) + TSC_XOFF;
			YPXL = ((X * 10) / (TSC_MAXVAL / LCD_HEIGHT)) - TSC_YOFF;
			XPXL = (XPXL & 0x80000000) ? 0 : XPXL;
			YPXL = (YPXL & 0x80000000) ? 0 : YPXL;
			XPXL = (XPXL >= LCD_WIDTH ) ? LCD_WIDTH  - 1 : XPXL;
			YPXL = (YPXL >= LCD_HEIGHT) ? LCD_HEIGHT - 1 : YPXL;

			// Move to new position if pen lifted
			if (!pendown)
			{
				XPXLN = XPXL;
				YPXLN = YPXL;
			}

			// Display line to new pixel position
			do
			{
				// Update X and Y
				XPXLN = (XPXL > XPXLN) ? XPXLN + 1 : XPXLN;
				XPXLN = (XPXL < XPXLN) ? XPXLN - 1 : XPXLN;
				YPXLN = (YPXL > YPXLN) ? YPXLN + 1 : YPXLN;
				YPXLN = (YPXL < YPXLN) ? YPXLN - 1 : YPXLN;

				// Display pixel
				GLCD_PutPixel (XPXLN, YPXLN);
			} while ((XPXLN != XPXL) || (YPXLN != YPXL));

			// Clear display
			if ((XPXL < 80) && (YPXL > 200))
			{
			    GLCD_Clear(Black);
			    apTSC_LCDINIT();
			}

			// Done
			if ((XPXL > 238) && (YPXL > 200))
			    done = TRUE;

			// Save pen state
    		pendown = TRUE;
    	}
    	else

    	// Clear status register
    	if (isr)
    		TSC_I2C_write(0x0B, isr, TSC_I2C_ADDR);

    } while (!done);

    // Fill screen
    GLCD_Clear(Black);

    // Draw intro screen image
    GLCD_Bitmap (0, 0, 320, 240, (unsigned short *)introData);

    if (failtest)
        return apERR_TSCI_START;
    else
    	return apERR_NONE;
}
