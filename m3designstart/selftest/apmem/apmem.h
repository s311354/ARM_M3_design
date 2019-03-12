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
 * File:     apmem.h
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 */

/*
 *            Memory Interface Support
 *            ========================
 */

#ifndef _APMEM_H_
#define _APMEM_H_

#include "common.h"

// Memory region boundaries
#define DEFAULT_LOAD_ADDRESS    0x10200000                      // Possible load address of this program in memory
#define DEFAULT_STACK_BASE      0x10300000                      // Grows downwards.

//#define SRAM_SIZE               0x20000                         // 0x400000 - 0x100000 (selftest.axf)
//#define RAM_SIZE                0x10000

#define ADDRESS_MAX             30                              // Test memory array size
#define LOADSTORES_MAX          8

// External function types

/*  Function: apMEM_TEST(void)
 *   Purpose: Main entry for Memory test
 *
 * Arguments: None
 *   Returns:
 *        OK: apERR_NONE
 *     Error: apERR_MEM_START;
 */
apError apMEM_TEST(void);

#endif
