/*
 *-----------------------------------------------------------------------------
 * The confidential and proprietary information contained in this file may
 * only be used by a person authorised under and to the extent permitted
 * by a subsisting licensing agreement from ARM Limited.
 *
 *            (C) COPYRIGHT 2010-2015  ARM Limited or its affiliates.
 *                ALL RIGHTS RESERVED
 *
 * This entire notice must be reproduced on all copies of this file
 * and copies of this file may only be made by a person if such person is
 * permitted to do so under the terms of a subsisting license agreement
 * from ARM Limited.
 *
 *      SVN Information
 *
 *      Checked In          : $Date: 2013-03-27 23:58:01 +0000 (Wed, 27 Mar 2013) $
 *
 *      Revision            : $Revision: 242484 $
 *
 *      Release Information : CM3DesignStart-r0p0-02rel0
 *-----------------------------------------------------------------------------
 */

#define TEST_PASS 0
#define TEST_FAIL 1
//==============================================================================
// Cortex-M3 IDs header File
//==============================================================================

// Component Part Numbers
#define ARM_JEP_ID              0x3B
#define ARM_JEP_CONT            0x4

// Values used by generic tests, such as debug_tests, romtable_tests
#define MCU_CPU_NAME "Cortex-M3"
#define MCU_CPU_ID_VALUE  0x412FC231

////////////////////////////////////////////////////////////////////////////////
//
//  Processor configuration options.
//  These must match the expected hardware configuration of the processor.
//
//  - EXPECTED_BIG_ENDIAN      : Expected Endianness (0-1)
//  - EXPECTED_DEBUG           : Expected Debug config (0-1)
//  - EXPECTED_SIMPLE_CHECK    : Expected simple check (1,0)
//  - EXPECTED_TRACE_LVL       : Expected Trace Config (0,1,2,3)
//  - EXPECTED_NUM_WATCHPOINTS : Expected number of Watchpoint Comparators (0,1,4)
//
////////////////////////////////////////////////////////////////////////////////
//
//  DAP configuration options.
//  These must match the expected hardware configuration of the DAP.
//
//  - EXPECTED_JTAGnSW       : Expected Cortex M3 DAP Protocol (0,1)
//
////////////////////////////////////////////////////////////////////////////////
//
//  System ROM Table options.
//  These must match the values in the System ROM Table.
//
//  - EXPECTED_CUST_JEP_ID   : Expected JEDEC JEP-106 identity code (0-0x7F)
//  - EXPECTED_CUST_JEP_CONT : Expected JEDEC JEP-106 continuation code (0-0xF)
//
////////////////////////////////////////////////////////////////////////////////

// <h> Processor configuration options
// <o> EXPECTED_BIG_ENDIAN: Expected Endianness <0=> Little Endian <1=> Big Endian
#define EXPECTED_BIG_ENDIAN      0

// <o> EXPECTED_DEBUG: Expected Debug config <0=> Absent <1=> Present
#define EXPECTED_DEBUG           1

// <o> EXPECTED_SIMPLE_CHECK:  <1=> only run the simple CPUID check
//                             <0=> more complex check included
//                             like Lockup, Sleep, other ID check etc
#define EXPECTED_SIMPLE_CHECK    0

// <o> EXPECTED_TRACE_LVL: Expected Trace level  <0=> No Trace    (0)
//                                               <1=> ITM Trace   (1)
//                                               <2=> ETM,ITM     (2)
//                                               <3=> ETM,ITM,HTM (3)
#define EXPECTED_TRACE_LVL       1

// <o> EXPECTED_NUM_WATCHPOINTS: Expected number of Watchpoint Comparators
//                   <0=> No DWT <1=> DWT_COMP0 <4=> DWT_COMP0,1,2,3
#define EXPECTED_NUM_WATCHPOINTS 4

// <o> EXPECTED_JTAGnSW: Expected Cortex M3 DAP Protocol <0=> Serial Wire <1=> JTAG
#define EXPECTED_JTAGnSW         0


// </h>

// <h> System ROM Table ID values
// <o> EXPECTED_CUST_JEP_ID: Expected JEDEC JEP-106 identity code (0-0x7F)
#define EXPECTED_CUST_JEP_ID    1

// <o> EXPECTED_CUST_JEP_CONT: Expected JEDEC JEP-106 continuation code (0-0xF)
#define EXPECTED_CUST_JEP_CONT  2

// </h>

//==============================================================================
//
// Cortex-M3 ID values
#if EXPECTED_JTAGnSW==1
#define MCU_DP_IDR_VALUE  0x00000000
#else
#define MCU_DP_IDR_VALUE  0x2BA01477
#endif

#define MCU_AP_IDR_VALUE  0x24770011
#define MCU_AP_BASE_VALUE 0xE00FF003
