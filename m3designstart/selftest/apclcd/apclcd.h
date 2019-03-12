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
 * File:     apclcd.h
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 */

/*
 *            Color LCD Support
 *            =================
 */

#ifndef _APCLCD_H_
#define _APCLCD_H_

#include "common.h"

// External Variables from flyer.c
extern const unsigned short flyerData[];
// External Variables from intro.c
extern const unsigned short introData[];

// External function types

/* Main entry function to LSSP test
 * Returns apERR_NONE if test passes
 */
apError apCLCD_TEST(void);

#endif
