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
 * File:     apleds.h
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 */

/*
 *            LEDS Interface
 *            ==============
 */

#ifndef _APLEDS_H_
#define _APLEDS_H_

#include "common.h"

// External function types

/*  Function: apLEDS_TEST(void)
 *   Purpose: Main entry for LEDs test
 *
 * Arguments: None
 *   Returns:
 *        OK: apERR_NONE
 *     Error: apERR_LEDS_START;
 */
apError apLEDS_TEST(void);

#endif
