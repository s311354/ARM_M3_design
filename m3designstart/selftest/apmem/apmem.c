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
 * File:     apmem.c
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 *
 */


#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#include "CMSDK_driver.h"           //CMSDK Device Driver Header File

#include "apmem.h"

// Addresses for memory test
#define ZBT1_BASE       0x00400000
#define ZBT2_BASE       0x20400000
#define SRAM_0_BASE     0x20000000
#define SRAM_1_BASE     0x20008000
#define SRAM_2_BASE     0x20010000
#define SRAM_3_BASE     0x20018000
#define PSRAM_BASE      0x21000000
#define ZBT_SIZE        0x400000
#define SRAM_SIZE       0x8000
#define PSRAM_SIZE      0x1000000

extern unsigned int get_stack_ptr(unsigned int *);
extern unsigned int memcpy_LDM_STM(unsigned int *to,
                                    unsigned int*from,
                                     unsigned int size);

int test_memory(const unsigned int base,
                const unsigned int max,
                unsigned int initial_offset_tobase);

int stm_ldm_test(void);
int check_selftest_used_memory(void);
int can_corrupt_usedmem(const unsigned int base, const unsigned int max);

// Make sure the code, stack heap of selftest
// are outside the area that will be checked.
int check_selftest_used_memory(void)
{
    unsigned int current_stack;
    unsigned int current_heap;
    void * heap_memory;
    int error;

    current_stack   = 0;
    current_heap    = 0;
    heap_memory     = 0;
    error           = 0;

    // Get stack pointer
    get_stack_ptr(&current_stack);

    // Get current heap level
    heap_memory = malloc(sizeof(int));
    current_heap = (unsigned int) heap_memory;

    if(current_stack > DEFAULT_STACK_BASE) {
        printf_err("Error: The stack seems to overlap with test memory.\n");
        error = TRUE;
    }
    if(current_heap > DEFAULT_STACK_BASE) {
        printf_err("Error: The heap seems to overlap with test memory\n");
        error = TRUE;
    }

    free(heap_memory);

    if(error)
        return TRUE;
    else
        return FALSE;
}

// Memory Tests

// Calls generic memory test functions once for SRAM.
int stm_ldm_test(void)
{
    int error[4];

    error[0] = 0;
    error[1] = 0;
    error[2] = 0;
    error[3] = 0;

    CMSDK_SYSCON->REMAP = 0;

    // ZBT RAM TEST:
//    printf("\nZBT 1 TEST:"
//           "\n===========\n");
//    error[0] = test_memory(ZBT1_BASE, ZBT1_BASE + ZBT_SIZE, 0x20);
//    if(error[0])
//        printf("ZBT 1 Test failed.\n\n");

    // ZBT RAM TEST:
    printf("\nZBT 2 TEST:"
           "\n===========\n");
    error[1] = test_memory(ZBT2_BASE, ZBT2_BASE + ZBT_SIZE, 0x20);
    if(error[1])
        printf("ZBT 2 Test failed.\n\n");

    // PSRAM TEST:
    printf("\nPSRAM TEST:"
           "\n===========\n");

    error[2] = test_memory(PSRAM_BASE, PSRAM_BASE + PSRAM_SIZE, 0x20);

    if(error[2])
    printf("PSRAM Test failed.\n\n");

    // Block RAM TEST:
    printf("\nBlock RAM TEST:"
           "\n===========\n");

    error[3] = test_memory(SRAM_0_BASE, SRAM_0_BASE + SRAM_SIZE, 0x20);
    error[3] |= test_memory(SRAM_1_BASE, SRAM_1_BASE + SRAM_SIZE, 0x20);
    error[3] |= test_memory(SRAM_2_BASE, SRAM_2_BASE + SRAM_SIZE, 0x20);
    error[3] |= test_memory(SRAM_3_BASE, SRAM_3_BASE + SRAM_SIZE, 0x20);
    if(error[3])
        printf("Block RAM Test failed.\n\n");

    // Error checking
    if(error[0] || error[1] || error[2] || error[3])
        return TRUE;
    else
        return FALSE;
}

// Checks whether memory to be tested lies in used memory
int can_corrupt_usedmem(const unsigned int base, const unsigned int max)
{
    int error[2];
    error[0] = 0;
    error[1] = 0;

//    if( (base < 0x80000) ||
//        ((base > SDRAM_BASE) && (base < SDRAM_BASE + 0x80000)) ) {
//        printf_err("Error: The test base address: %#08x overlaps with used memory.\n",base);
//        error[0] = 1;
//    }
//    if( (max < 0x80000) ||
//        ((max > SDRAM_BASE) && (base < SDRAM_BASE + 0x80000)) ) {
//        printf_err("Error: The test maximum address %#08x overlaps with used memory.\n",max);
//        error[1] = 1;
//    }

    if (error[0] || error[1])
        return TRUE;
    else
        return FALSE;
}

// Tests a memory region with STM/LDM instructions, using as many address lines as possible.
int test_memory(const unsigned int base, const unsigned int max, unsigned int offset_tobase_init)
{
    // Miscellaneous locals
    int failtest;
    unsigned int testvalues[ADDRESS_MAX][LOADSTORES_MAX];    // Store for randomly written memory values
    unsigned int fetched_randoms[LOADSTORES_MAX];
    int random;
    int loopaddr;                               // Keeps track of index of random values per calculated address
    int nldmstm;                                // Keeps track of index of random values in an LDM/STM operation

    // Memory calculation locals
    unsigned int *memory;                       // Memory accessor
    unsigned int bit_two;                       // Bit [2] of an address word.
    unsigned int address;                       // Final calculated address
    unsigned int offset_tobase;                 // Keeps current offset to base of RAM region

    failtest    = FALSE;
    random      = 0;
    loopaddr    = 0;
    nldmstm     = 0;
    memory      = 0;
    bit_two     = 0;
    address     = 0;

//    if(can_corrupt_usedmem(base,max)) {
//        printf_err( "Error: Memory region between %#08x - %#08x may be used.\n"
//                    "Continuing the test would corrupt used memory.\n", base, max);
//        printf_err( "Make sure you are running this test from SDRAM, you have compiled\n"
//                    "and loaded the selftest image at 0x8000 and your @top_of_memory\n"
//                    "variable in rvd is set to 0x80000. Then run this test again.\n");
//        failtest = TRUE;
//        return TRUE;
//    }

    // Initialisation
    for(loopaddr = 0; loopaddr < ADDRESS_MAX; loopaddr++) {
        for(nldmstm = 0; nldmstm < LOADSTORES_MAX; nldmstm++) {
            testvalues[loopaddr][nldmstm] = 0;
        }
    }

    for(nldmstm = 0; nldmstm < LOADSTORES_MAX; nldmstm++) {
        fetched_randoms[nldmstm] = 0;
    }

    if(offset_tobase_init & 0x3) {
        printf( "Warning: Given memory test offset is not word-aligned.\n"
                "Rounding to nearest word aligned address.\n");
        offset_tobase_init &= ~0x3;
    }

    // Write values
    printf("%-30s%#08x - %#08x\n","Writing between region:", base + offset_tobase_init, max);

    // INIT
    address         = offset_tobase_init + base;    // Current_address = initial offset to base (addr_start) + memory base
    loopaddr        = 0;
    offset_tobase   = offset_tobase_init;           // Initialise offset to base

    // CONDITION
    while(address < max)  // If calculated current address > max its the end condition
    {

        srand(time(0));   // Time as random seed

        //printf("%-20s%#08x\n","Writing address:", address);
        memory = (unsigned int *) address;

        // Generate randoms and store for later use
        for(nldmstm = 0; nldmstm < LOADSTORES_MAX; nldmstm++) {
            random = rand();                        // Get random value
            testvalues[loopaddr][nldmstm] = random; // Make a copy of what to write
        }
        memcpy_LDM_STM( memory,                     // To memory
                        &testvalues[loopaddr][0],   // From array of randoms
                        LOADSTORES_MAX);            // Copy size
    // POST UPDATE
        bit_two         = offset_tobase & 0x4;          // if bit[2] is 1 or 0, take note of that.
        offset_tobase <<= 1;                            // Update address by shifting the offset by 1 bit.
        offset_tobase  |= (!bit_two ? (1 << 2) : 0);    // Add a 1 for bit[2] depending on whether it was 0 or 1 before.
        address         = base + offset_tobase;         // Form final address
        loopaddr++;                                     // Update address index, it keeps track of random entries per address.
    }

    // Compare
    printf("%-30s%#08x - %#08x\n\n","Comparing between region:", base + offset_tobase_init, max);

    // INIT
    address         = offset_tobase_init + base;
    loopaddr        = 0;
    offset_tobase   = offset_tobase_init;

    // CONDITION
    while(address < max) {
        apDebug("%-20s%#08x\n","Comparing address:", address);
        memory = (unsigned int *) address;

        memcpy_LDM_STM( &fetched_randoms[0],// To array of randoms for `this' address
                        memory,             // From memory
                        LOADSTORES_MAX);    // Copy size

        // Compare with previously stored randoms
        for(nldmstm = 0; nldmstm < LOADSTORES_MAX; nldmstm++) {
            if(testvalues[loopaddr][nldmstm] != fetched_randoms[nldmstm]) {
                printf_err( "Error: Memory read/write failed at address: %#08x, "
                        "read: %#08x, expected %#08x\n",
                         (unsigned int) (memory + nldmstm),      /* Memory plus array offset(x word alignment of 4)
                                                                  * should give the corresponding address for the unmatched values
                                                                  */
                         fetched_randoms[nldmstm], testvalues[loopaddr][nldmstm]);

            failtest = TRUE;
            }
        }

        // POST UPDATE
        bit_two         = offset_tobase & 0x4;
        offset_tobase <<= 1;
        offset_tobase  |= (!bit_two ? (1 << 2) : 0);
        address         = base + offset_tobase;
        loopaddr++;
    }

    if(failtest)
        return TRUE;
    else
        return FALSE;
}

apError apMEM_TEST(void)
{
    int failtest;

    failtest = FALSE;

    printf("SRAM memory test.\n");
    printf("The test reads/writes random values to \n");
    printf("SRAM using all address lines. \n");
    Wait_For_Enter(FALSE);

    // SRAM/SDRAM TEST:
    // Memory is checked from the stack base to near 256MB region
    // using an address pattern that uses all the possible address bits.

//    check_sram_chipselect();    // Check SRAM chipselect status and correct it.

/*    if(check_selftest_used_memory()) {
        printf("Warning: Selftest seems to be running from a non-default address.\n");
        printf("Continuing the test may result in corruption of the test itself.\n");
        printf("Do you wish to continue?\n");

        if(!Get_OK())
            failtest = TRUE;
        else if(stm_ldm_test())
            failtest = TRUE;

    }
    else */if(stm_ldm_test()) 
    {
            failtest = TRUE;
    }

    if (failtest)
        return apERR_MEM_START;
    else
        return apERR_NONE;
}
