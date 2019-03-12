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
 * File:     apssp.h
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 */

/*
 *            SSP interface Support
 *            =====================
 */

#ifndef _APSSP_H_
#define _APSSP_H_

#include "common.h"

// SSP defaults
#define SSPMAXTIME          1000        // Maximum time to wait for SSP (10*10uS)

// EEPROM instruction set
#define EEWRSR              0x0001      // Write status
#define EEWRITE             0x0002      // Write data
#define EEREAD              0x0003      // Read data
#define EEWDI               0x0004      // Write disable
#define EEWREN              0x0006      // Write enable
#define EERDSR              0x0005      // Read status

// EEPROM status register flags
#define EERDSR_WIP          0x0001      // Write in process
#define EERDSR_WEL          0x0002      // Write enable latch
#define EERDSR_BP0          0x0004      // Block protect 0
#define EERDSR_BP1          0x0008      // Block protect 1
#define EERDSR_WPEN         0x0080      // Write protect enable


// External function types

/* Main entry function to SSP test
 * Returns apERR_NONE if test passes
 */
apError apSSP_TEST(void);
apError apSSP_TEST_S(void);
apError apSSP_TEST_M(void);

#endif
