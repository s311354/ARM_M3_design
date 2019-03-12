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
 * File:     aptsc.h
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 */

/*
 *            Touch Screen Controller Support
 *            ===============================
 */

#ifndef _APTSC_H_
#define _APTSC_H_

#include "common.h"

/* Main entry function to TSC test
 * Returns apERR_NONE if test passes
 */
apError apTSC_TEST(void);

#endif

