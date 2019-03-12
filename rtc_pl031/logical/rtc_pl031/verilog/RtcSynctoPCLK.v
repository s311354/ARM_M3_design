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
//  Filename            : RtcSynctoPCLK.v.rca
//
//  File Revision       : 1.10
//
//  Release Information : PrimeCell(TM)-PL031-REL1v0
//
//------------------------------------------------------------------------------
//
// Purpose              : This block contains synchronisation logic to the
//                        PCLK domain for the RTC.
//------------------------------------------------------------------------------


`timescale 1ns/1ps


module RtcSynctoPCLK (
                    // Inputs
                      PCLK,
                      PRESETn,
                      nPOR,
                      RawInt,
                      MaskInt,
                      Count,
                    // Outputs
                      RawIntSync,
                      RawIntEdge,
                      MaskIntStatus,
                      CountEdge,
                      CountSync
                      );


input         PCLK;           // APB clock
input         PRESETn;        // AMBA reset
input         nPOR;           // Power on reset
input         RawInt;         // Raw interrupt
input         MaskInt;        // Mask interrupt
input  [31:0] Count;          // Count register

output        RawIntSync;     // Synchronised raw interrupt
output        RawIntEdge;     // asserted on a low-high transition of RawIntSync
output        MaskIntStatus;  // Synchronised Mask Interrupt Status
output        CountEdge;      // Counter incrementer signal
output [31:0] CountSync;      // Synchronised count


//------------------------------------------------------------------------------
//
//                             RtcSynctoPCLK
//                             =============
//------------------------------------------------------------------------------
//
// Overview - This block performs the following functions.
// ========
//
// Synchronisation of the Counter value to PCLK.
//
// Synchronisation of the raw and masked interrupt to PCLK.
//
// Generation of the Masked Interrupt Status.
//
// Generation of the Raw Interrupt Status.
//
//==============================================================================


// ----------------------------------------------------------------------------
// Wire declarations
// ----------------------------------------------------------------------------
wire CountEdge;   // asserted after a  rising edge of CLK1HZ
wire RawIntEdge;  // asserted on a low to high transition of RawIntSync

//------------------------------------------------------------------------------
// Register Declarations
//------------------------------------------------------------------------------
reg [31:0] CountSync;     // Synchronised Count
reg [31:0] NextCountSync; // D-input of CountSync
reg RawIntSync1;          // D-input of RawIntSync2, synchronised RawInt
reg RawIntSync;           // D-input of RawIntSync3
reg RawIntSync3;          //
reg MaskIntSync1;         // D-input of MaskIntSync2
reg MaskIntSync2;         // synchronised RawInt
reg Count0Sync1;          // D-input of Count0Sync2
reg Count0Sync2;          // D-input of Count0Sync3, synchronised Count[0]
reg Count0Sync3;          //
//------------------------------------------------------------------------------
//
// Main Verilog code
// =================
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Generate delayed version of Count[0].
//------------------------------------------------------------------------------

always @ (posedge PCLK or negedge nPOR)
  begin : p_SeqCount0Sync
    if(nPOR == 1'b0)
      begin
        Count0Sync1 <= 1'b0;
        Count0Sync2 <= 1'b0;
        Count0Sync3 <= 1'b0;
      end
    else
      begin
        Count0Sync1 <= Count[0];
        Count0Sync2 <= Count0Sync1;
        Count0Sync3 <= Count0Sync2;
      end
  end // p_SeqCount0Sync

//------------------------------------------------------------------------------
// Detect low to high transition of LSB of counter value
//------------------------------------------------------------------------------

assign CountEdge = (Count0Sync2 ^ Count0Sync3);

// -----------------------------------------------------------------------------
// Synchronise Counter to PCLK - Combinational
// -----------------------------------------------------------------------------

always @(Count or CountEdge or CountSync)
  begin : p_CombCountSync
    if(CountEdge == 1'b1)
      NextCountSync = Count;
    else
      NextCountSync = CountSync;
  end  // p_CombCountSync

// -----------------------------------------------------------------------------
// Synchronise Counter to PCLK - Sequential
// -----------------------------------------------------------------------------
always @ (posedge PCLK or negedge nPOR)
  begin : p_SeqCountSync
    if(nPOR == 1'b0)
      CountSync <= 32'h00000000;
    else
      CountSync <= NextCountSync;
  end  // p_SeqCountSync


//------------------------------------------------------------------------------
// Synchronise Raw Interrupt to PCLK
//------------------------------------------------------------------------------

always @ (posedge PCLK or negedge PRESETn)
  begin : p_SeqRawIntSync
    if(PRESETn == 1'b0)
      begin
        RawIntSync1 <= 1'b0;
        RawIntSync  <= 1'b0;
      end
    else
      begin
        RawIntSync1 <= RawInt;
        RawIntSync  <= RawIntSync1;
      end
  end // p_SeqRawIntSync

//------------------------------------------------------------------------------
// Detect low to high transition of synchronised raw interrupt signal
// (RawIntSync)
//------------------------------------------------------------------------------
always @ (posedge PCLK or negedge PRESETn)
  begin : p_SeqEdgeDetect
    if(PRESETn == 1'b0)
      RawIntSync3 <= 1'b0;
    else
      RawIntSync3 <= RawIntSync;
  end // p_SeqEdgeDetect

assign RawIntEdge = (RawIntSync && (!RawIntSync3));

//------------------------------------------------------------------------------
// Generate synchronised Masked Interrupt Status
//------------------------------------------------------------------------------
always @ (posedge PCLK or negedge PRESETn)
  begin : p_SeqMIS
    if(PRESETn == 1'b0)
      begin
        MaskIntSync1 <= 1'b0;
        MaskIntSync2 <= 1'b0;
      end
    else
      begin
        MaskIntSync1 <= MaskInt;
        MaskIntSync2 <= MaskIntSync1;
      end
  end // p_SeqMIS

// assign the masked interrupt status
assign MaskIntStatus = MaskIntSync2;



endmodule

//====================End of RtcSynctoPCLK======================================









