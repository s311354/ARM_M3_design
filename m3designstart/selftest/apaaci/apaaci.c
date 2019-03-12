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
 * File:     apaaci.c
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 */

/*
 * Code implementation file for the AACI (Advanced Audio CODEC) interface.
 */

#include <stdio.h>
#include <stdlib.h>

#include "AAIC_I2S_MPS2.h"
#include "AAIC_I2C_MPS2.h"

#include "apaaci.h"


// A 48 point, 16 bit sine table
static const int sinewave[] = { 0x0000, 0x10B5, 0x2120, 0x30FB, 0x3FFF, 0x4DEB, 0x5A82, 0x658C, 0x6ED9, 0x7641,
                                0x7BA3, 0x7EE7, 0x7FFF, 0x7EE7, 0x7BA3, 0x7641, 0x6ED9, 0x658C, 0x5A82, 0x4DEB,
                                0x3FFF, 0x30FB, 0x2120, 0x10B5, 0x0000, 0xEF4A, 0xDEDF, 0xCF04, 0xC000, 0xB214,
                                0xA57D, 0x9A73, 0x9126, 0x89BE, 0x845C, 0x8118, 0x8000, 0x8118, 0x845C, 0x89BE,
                                0x9126, 0x9A73, 0xA57D, 0xB214, 0xC000, 0xCF04, 0xDEDF, 0xEF4A };

/* The AACI has I2C and I2S interfaces from the FPGA
 * The IC2 interface is a simple GPIO interface and the AAIC_I2C_
 * software functions generate the correct I2C protocol.
 * The I2S is a simple FIFO buffer in the FPGA with a FIFO full
 * flag to indicate the FIFO status, the FIFO is shifted out
 * serially to the CODEC.
 */
static unsigned char AACI_INIT(void)
{
    I2S_config config;

    // See power-up sequence (see DS680F2 page 37)

    // set resets
    i2s_codec_set_reset(MPS2_AAIC_I2S);
    i2s_fifo_set_reset(MPS2_AAIC_I2S);

    // Configure AACI I2S Interface
    config.tx_enable = 1;
    config.tx_int_enable = 1;
    config.tx_waterlevel = 2;
    config.rx_enable = 1;
    config.rx_int_enable = 1;
    config.rx_waterlevel = 2;
    
    i2s_config(MPS2_AAIC_I2S, &config);

    apSleep(10);
    
    // Release AACI nRESET
    i2s_codec_clear_reset(MPS2_AAIC_I2S);
    apSleep(100);

    /* AACI clocks MCLK = 12.288MHz, SCLK = 3.072MHz, LRCLK = 48KHz
     * LRCLK divide ratio [9:0], 3.072MHz (SCLK) / 48KHz / 2 (L+R) = 32
     */
    i2s_speed_config(MPS2_AAIC_I2S, 32);

    // Initialise the AACI I2C interface (see DS680F2 page 38)
    AAIC_I2C_write(0x00, 0x99, AAIC_I2C_ADDR);
    AAIC_I2C_write(0x3E, 0xBA, AAIC_I2C_ADDR);
    AAIC_I2C_write(0x47, 0x80, AAIC_I2C_ADDR);
    AAIC_I2C_write(0x32, 0xBB, AAIC_I2C_ADDR);
    AAIC_I2C_write(0x32, 0x3B, AAIC_I2C_ADDR);
    AAIC_I2C_write(0x00, 0x00, AAIC_I2C_ADDR);
    apSleep(100);

    // Enable MCLK and set frequency (LRCK=48KHz, MCLK=12.288MHz, /256)
    AAIC_I2C_write(AAIC_I2C_CLKCRTL, 0xA0, AAIC_I2C_ADDR);

    // Power control 1 Codec powered up
    AAIC_I2C_write(AAIC_I2C_CRPWRC1, 0x00, AAIC_I2C_ADDR);
    // Power control 2 MIC powered up
    AAIC_I2C_write(AAIC_I2C_CRPWRC2, 0x00, AAIC_I2C_ADDR);
    // Power control 3 Headphone channel always on, Speaker channel always on
    AAIC_I2C_write(AAIC_I2C_CRPWRC3, 0xAA, AAIC_I2C_ADDR);

    // Input select AIN1A and AIN1B
    AAIC_I2C_write(AAIC_I2C_INPUTASEL, 0x00, AAIC_I2C_ADDR);
    AAIC_I2C_write(AAIC_I2C_INPUTBSEL, 0x00, AAIC_I2C_ADDR);

    // Audio setup complete
    apSleep(10);

    // Release I2S FIFO reset
    i2s_fifo_clear_reset(MPS2_AAIC_I2S);

    // Read the I2C chip ID and revision
    return AAIC_I2C_read(AAIC_I2C_CRID, AAIC_I2C_ADDR);
}
                                
/* The loopback applies a minimum/maximum level sinewave to alternate Left and
 * Right outputs and measures the peak noise/signal level on the Line In inputs.
 * The measurements are compared against defined limits.
 */
static int AACI_Loopback(void)
{
    int loop, count, time, stage, timer;
    int lmin, rmin, lmax, rmax, failtest;
    int llevel, rlevel, lold, rold, din;
    int leftbuf[48 * 4], rightbuf[48 * 4];

    failtest  = FALSE;

    // Clear Left/Right outputs
	MPS2_AAIC_I2S->TXBUF = 0x00000000;

    // Give the analogue circuit time to settle
    if (!RunAllTests)
        apSleep(1000);

	// Generate a 500Hz tone and measure the loopback levels
    for (stage = 0; stage < 2; stage++)
    {
        count = 0;
        for (time = 0; time < TONETIME; time++)
        {
            for (loop = 0; loop < 48; loop++)
            {
                // Wait for TX FIFO not to be full then write left and right channels
                timer = AACI_TIMEOUT;
                while (i2s_tx_fifo_full(MPS2_AAIC_I2S) && timer)
                    timer--;

                // Left then right audio out
                if (stage == 0)
                	MPS2_AAIC_I2S->TXBUF = (sinewave[loop] ^ 0x8000) << 16;
                else
                	MPS2_AAIC_I2S->TXBUF = sinewave[loop] ^ 0x8000;

                // Read left and right audio in
            	din = MPS2_AAIC_I2S->RXBUF ^ 0x80008000;

                // Save the last 4 cycles only
                leftbuf[count]  = (din >> 16) & 0xFFFF;
                rightbuf[count] = din & 0xFFFF;
                if (time > (TONETIME - 5))
                    count++;
            }
        }

        // Peak detect the last 4 cycles (averaged)
        lmin  = 0xFFFF;
        rmin  = 0xFFFF;
        lmax  = 0;
        rmax  = 0;
        lold  = leftbuf[0];
        rold  = rightbuf[0];
        for (loop = 0; loop < (48 * 4); loop++)
        {
            lmin = (leftbuf[loop]  < lmin) ? (leftbuf[loop]  + lold) / 2 : lmin;
            rmin = (rightbuf[loop] < rmin) ? (rightbuf[loop] + rold) / 2 : rmin;
            lmax = (leftbuf[loop]  > lmax) ? (leftbuf[loop]  + lold) / 2 : lmax;
            rmax = (rightbuf[loop] > rmax) ? (rightbuf[loop] + rold) / 2 : rmax;

            // Save the current values for averaging
            lold = leftbuf[loop];
            rold = rightbuf[loop];
        }

        // Get the peak to peak levels
        llevel = lmax - lmin;
        rlevel = rmax - rmin;

        // Check for calibration errors
        if (stage == 0)
        {
        	if (llevel < MINSIGNAL)
                printf_err("Error: Left  Line In outside calibration, measured %d : expected > %d\n", llevel, MINSIGNAL);
            if (rlevel > MAXSIGNAL)
                printf_err("Error: Right Line In outside calibration, measured %d : expected < %d\n", rlevel, MAXSIGNAL);
            if ((llevel < MINSIGNAL) || (rlevel > MAXSIGNAL))
                failtest = TRUE;
        }
        else
        {
        	if (llevel > MAXSIGNAL)
        		printf_err("Error: Left  Line In outside calibration, measured %d : expected < %d\n", llevel, MAXSIGNAL);
        	if (rlevel < MINSIGNAL)
        		printf_err("Error: Right Line In outside calibration, measured %d : expected > %d\n", rlevel, MINSIGNAL);
        	if ((llevel > MAXSIGNAL) || (rlevel < MINSIGNAL))
        		failtest = TRUE;
        }
    }

    // Clear Left/Right outputs
	MPS2_AAIC_I2S->TXBUF = 0x00000000;

    if (failtest)
        return TRUE;
    else
        return FALSE;
}

apError apAACI_TEST()
{
    unsigned char din;
    int failtest = FALSE;

     // AACI loopback test mode
    printf("\nAACI Loopback test: This will test the signal path between\n");
    printf("Line Out and Line In. A stereo lead must be connected from\n");
    printf("Line Out (J33) to Line In (J32).\n");
    Wait_For_Enter(FALSE);

    din = AACI_INIT();
    
    if ((din & 0xF8) != 0xE0)
    {
        printf("ERROR: AACI ID:0x%02X\n", din);
        failtest = TRUE;
    }
    else
    {
        printf("AACI ID:0x%02X\n", din);

        // Loopback test
        failtest = AACI_Loopback();
    }

    if (failtest)
        return apERR_AACI_START;
    else
        return apERR_NONE;
}
