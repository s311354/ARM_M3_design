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
 * File:     aplani.h
 * Release:  Version 1.0
 * ----------------------------------------------------------------
 */

#ifndef _APLANI_H_
#define _APLANI_H_

#include "common.h"

// External function types

/*  Function: apLANI_TEST(void)
 *   Purpose: Main entry for LANI test
 *
 * Arguments: None
 *   Returns:
 *        OK: apERR_NONE
 *     Error: apERR_LANI_START;
 */
apError apLANI_TEST(void);

#endif
