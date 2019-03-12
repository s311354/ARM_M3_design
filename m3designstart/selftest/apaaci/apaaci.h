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
 * File:     apaaci.h
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 */

/*
 * Header file for the AACI (Advanced Audio CODEC) test.
 */
#ifndef _APAACI_H_
#define _APAACI_H_

#include "common.h"

// Loopback test limits
#define MINSIGNAL          0xC000                                  // Allow for gain errors
#define MAXSIGNAL          0x0200                                  // Wideband noise level
#define RECLENGTH          48000                                   // 1 Second recording (48kHz), see note in AACI_Recording()
#define AACI_TIMEOUT       1000                                    // Timeout for reading FIFOs (10mS)
#define TONETIME           500                                     // Loop back test tone time

// External function types

/*  Function: apAACI_TEST(void)
 *   Purpose: Main entry for AACI test
 *
 * Arguments: None
 *   Returns:
 *        OK: apERR_NONE
 *     Error: apERR_AACI_START;
 */
apError apAACI_TEST(void);

#endif
