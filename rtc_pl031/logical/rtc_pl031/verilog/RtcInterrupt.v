//  ----------------------------------------------------------------------------
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
//  Filename            : RtcInterrupt.v.rca
//
//  File Revision       : 1.9
//
//  Release Information : PrimeCell(TM)-PL031-REL1v0
//
//  ----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Purpose : This block generates an interrupt when the match value is equal to
//           the count value.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps


module RtcInterrupt (
                   // Inputs
                     PCLK,
                     PRESETn,
                     MatchData,
                     Count,
                     IntClear,
                     RTCIMSC,
                     RTCIntClr,
                     RawIntEdge,
                   // Outputs
                     RawInt,
                     MaskInt,
                     RawIntStatus
                     );


input          PCLK;         // APB clock
input          PRESETn;      // AMBA reset
input  [31:0]  MatchData;    // Equivalent match value
input  [31:0]  Count;        // Counter
input          IntClear;     //
input          RTCIMSC;      // RTC Interrupt Mask Set/Clear register
input          RTCIntClr;    // Write enable for RTCICR
input          RawIntEdge;   // Asserted on low-high transition of synchronised
                             // raw interrupt.
output         RawInt;       // Raw interrupt
output         MaskInt;      // RTC interrupt
output         RawIntStatus; // Synchronised raw interrupt status



//------------------------------------------------------------------------------
//
//                             RtcInterrupt
//                             ============
//
//------------------------------------------------------------------------------
//
//==============================================================================

// -----------------------------------------------------------------------------
// Wire Declarations
// -----------------------------------------------------------------------------
wire     RawIntData;  // Raw interrupt signal gated to IntClear
wire     IntData;     // Combination interrupt signal
wire     RawIntEdge;  // Asserted on a low-high transition of synchronised raw
                      // interrupt
wire     RTCIntClr;   // Write enable for RTCICR

//------------------------------------------------------------------------------
// Register Declarations
//------------------------------------------------------------------------------
reg     RawInt;           // Raw interrupt
reg     RawIntStatus;     // synchronised raw interrupt status
reg     NextRawIntStatus; // D-input of RawIntStatus


//------------------------------------------------------------------------------
//
// Main Verilog code
// =================
//
//------------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// The Raw Interrupt is generated when the Count value and the MatchData value
// are equal.
// -----------------------------------------------------------------------------
always @(MatchData or Count)
  begin : p_CombRawInt
    if(MatchData == Count)
      RawInt = 1'b1;
    else
      RawInt = 1'b0;
  end // p_CombRawInt

//------------------------------------------------------------------------------
// Generate synchronised Raw Interrupt Status signal - Combinational
//------------------------------------------------------------------------------
always @(RTCIntClr or RawIntEdge or RawIntStatus)
  begin : p_CombRawIntStatus
    if (RTCIntClr == 1'b1)
      NextRawIntStatus = 1'b0;
    else if (RawIntEdge == 1'b1)
      NextRawIntStatus = 1'b1;
    else
      NextRawIntStatus = RawIntStatus;
  end  // p_CombRawIntStatus

//------------------------------------------------------------------------------
// Generate synchronised Raw Interrupt Status signal - Sequential
//------------------------------------------------------------------------------
always @ (posedge PCLK or negedge PRESETn)
  begin : p_SeqRawIntStatus
    if(PRESETn == 1'b0)
      RawIntStatus <= 1'b0;
    else
      RawIntStatus <= NextRawIntStatus;
  end // p_SeqRawIntStatus

// The raw interrupt is gated with the interrupt clear signal
assign RawIntData = RawInt && (!IntClear);

assign IntData = RawIntData || RawIntStatus;

assign MaskInt = IntData && RTCIMSC;


endmodule

//==========================End of RtcInterrupt=================================







