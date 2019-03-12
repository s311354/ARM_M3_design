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
//  Filename            : RtcControl.v.rca
//
//  File Revision       : 1.9
//
//  Release Information : PrimeCell(TM)-PL031-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose               : This block contains the control logic for the Rtc
//
// --=========================================================================--

`timescale 1ns/1ps


module RtcControl(
                // Inputs
                  PCLK,
                  PRESETn,
                  RTCIntClr,
                  RawIntSync,
                // Outputs
                  IntClear
                  );


input       PCLK;            // APB clock
input       PRESETn;         // APB Bus Reset
input       RTCIntClr;       // RTC Interrupt Clear signal
input       RawIntSync;      // Synchronised raw interrupt

output      IntClear;        // Interrupt clear signal gated to RTCRIS


//------------------------------------------------------------------------------
//
//                            RtcControl
//                            ==========
//
//------------------------------------------------------------------------------
//
// Overview
// =======
//
// This block performs the following functions
//
// Generation of the interrupt clear signal which is gated to the Synchronised
// raw interrupt status
//
//==============================================================================
//

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Register Declarations
//-----------------------------------------------------------------------------
reg IntClear;       // Gated interrupt clear
reg NextIntClear;   // D-input for IntClear

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------


//==============================================================================
// Main Verilog code
// -----------------
//==============================================================================


// -----------------------------------------------------------------------------
// Implementation of interrupt clear signal (IntClear) - Combinational
//
// IntClear is asserted when there is a write to the RTC Interrupt Clear
// register while there is an interrupt.
// -----------------------------------------------------------------------------
always @(RawIntSync or RTCIntClr or IntClear)
  begin : p_combIntClear
    if(RawIntSync == 1'b0)
      NextIntClear = 1'b0;
    else
      NextIntClear = RTCIntClr || IntClear;
  end //  p_combIntClear

// -----------------------------------------------------------------------------
// Implementation of interrupt clear signal (IntClear) - Sequential
// -----------------------------------------------------------------------------
always @ (posedge PCLK or negedge PRESETn)
  begin : p_seqIntClear
    if(PRESETn == 1'b0)
      IntClear <= 1'b0;
    else
      IntClear <= NextIntClear;
    end //  p_seqIntClear



endmodule

//====================End of RtcControl=========================================
