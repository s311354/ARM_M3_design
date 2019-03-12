//  --========================================================================--
//  This confidential and proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 2001 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  and copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information :
//
//
//  Filename            : RtcCounter.v.rca
//
//  File Revision       : 1.9
//
//  Release Information : PrimeCell(TM)-PL031-REL1v0
//
//  ----------------------------------------------------------------------------
// Purpose               : This block implements the free-running 32bit counter
//                         which counts up on each rising edge of CLK1HZ.
//
//  --========================================================================--


`timescale 1ns/1ps


module RtcCounter (
                 // Inputs
                   CLK1HZ,
                   nRTCRST,
                   RTCTCOUNT,
                   TESTCOUNT,
                 // Outputs
                   Count
                   );

input         CLK1HZ;         // RTC Clock
input         nRTCRST;        // RTC reset
input  [31:0] RTCTCOUNT;      // RTC Test Count register
input         TESTCOUNT;      // Test count enable

output [31:0] Count;          // 32bit Counter


//------------------------------------------------------------------------------
//
//                             RtcCounter
//                             ==========
//
//------------------------------------------------------------------------------
//
// Overview
// ========
// This block performs the following functions
//
// Generation of a free-running 32-bit counter whose initial value is zero on
// reset. It counts up from the initial  value upto 0xFFFFFFFF and then rolls
// over to 0x00000000, incrementing by 1 each time a CLK1HZ tick is seen.
//
// Allows a direct write to the Count register via the test count register
// (RTCTCOUNT) for test visibility.
//==============================================================================
//
//------------------------------------------------------------------------------
// Register Declarations
//------------------------------------------------------------------------------
reg [31:0] Count;      // 32bit counter
reg [31:0] NextCount;  // D-input for counter

//------------------------------------------------------------------------------
// Wire Declarations
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//
// Main Verilog code
// =================
//
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// The free_running counter is 00000000 on reset and counts up to FFFFFFFF.
// At this maximum value it wraps around to 00000000 and continues incrementing.
// Also allows a direct write to the counter via the test control register for
// test visibility
//------------------------------------------------------------------------------
always @(TESTCOUNT or RTCTCOUNT or Count)
  begin : p_CombCounter
    if(TESTCOUNT == 1'b1)
        NextCount = RTCTCOUNT;
      else
        NextCount = Count + 32'h00000001;
  end // p_CombCounter

// -----------------------------------------------------------------------------
// Implementation of RTC counter - Sequential
// -----------------------------------------------------------------------------
always @ (posedge CLK1HZ or negedge nRTCRST)
  begin : p_SeqCounter
    if(nRTCRST == 1'b0)
      Count <= 32'h00000001;
    else
      Count <= NextCount;
  end  // p_SeqCounter


endmodule

//==========================End of RtcCounter===================================
