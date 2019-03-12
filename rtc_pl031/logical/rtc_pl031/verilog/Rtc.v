//  -=========================================================================--
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
//  Filename            : Rtc.v.rca
//
//  File Revision       : 1.13
//
//  Release Information : PrimeCell(TM)-PL031-REL1v0
//
//  ----------------------------------------------------------------------------
//  Purpose               : This is the top level of the RTC
//
//  --========================================================================--

`timescale 1ns/1ps


module Rtc (
          // Inputs
            PCLK,
            PRESETn,
            PSEL,
            PENABLE,
            PWRITE,
            PADDR,
            PWDATA,
            CLK1HZ,
            nRTCRST,
            nPOR,
            SCANENABLE,
            SCANINPCLK,
            SCANINCLK1HZ,
          // Outputs
            PRDATA,
            RTCINTR,
            SCANOUTPCLK,
            SCANOUTCLK1HZ
            );

          // Scan test signals not connected until scan insertion


input         PCLK;            // APB clock
input         PRESETn;         // APB reset
input         PSEL;            // APB select
input         PENABLE;         // APB enable
input         PWRITE;          // APB write
input [11:2]  PADDR;           // APB Address
input [31:0]  PWDATA;          // APB write data
input         CLK1HZ;          // 1 HZ clock
input         nRTCRST;         // RTC reset signal
input         nPOR;            // RTC power on reset
input         SCANENABLE;      // Test mode enable
input         SCANINPCLK;      // PCLK Scan chain input
input         SCANINCLK1HZ;    // CLK1HZ Scan chain input

output        SCANOUTPCLK;     // PCLK Scan chain output
output        SCANOUTCLK1HZ;   // CLK1HZ Scan chain output
output [31:0] PRDATA;          // APB  read data
output        RTCINTR;         // RTC interrupt


// -----------------------------------------------------------------------------
//
//                            Rtc
//                            ===
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module is the top level of the Rtc. The following blocks
// are instantiated in this module .
//
// 1. RtcCounter      :  This block implements the 32-bit counter.
// 2. RtcControl      :  This block contains the control logic for the RTC.
// 3. RtcUpdate       :  This block contains the update logic for the RTC.
// 4. RtcSynctoPCLK   :  This block contains the RTC synchronisation logic.
// 5. RtcApbif        :  This block is the APB interface for the RTC.
// 6. RtcRegBlk       :  This block contains the RTC registers.
// 7. RtcInterrupt    :  This block generates the RTC interrupt.
// 8. RtcRevAnd       :  This block is the revision place holder for the Rtc.
//
// The module RtcRevAnd is used as a place-holder cell to mark the revision of
// the Rtc. It contains a 2 input AND gate. The input pins are tied off at the
// top level of the hierarchy. These "TieOffs" can be identified during layout
// and re-wired to "VDD" and "VSS" if needed.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declaration
// -----------------------------------------------------------------------------
wire        PCLK;             // APB Clock
wire        CLK1HZ;           // RTC Clock
wire        PRESETn;          // APB reset signal
wire        nRTCRST;          // RTC reset signal
wire        nPOR;             // RTC power on reset signal
wire        PSEL;             // APB select
wire        PENABLE;          // APB enable
wire        PWRITE;           // APB data bus
wire [11:2] PADDR;            // APB address bus
wire [31:0] PWDATA;           // APB Data Bus
wire        SCANENABLE;       // Scan enable signal
wire        SCANINPCLK;       // PCLK scan input signal
wire        SCANINCLK1HZ;     // CLK1HZ scan input signal
wire [31:0] RTCMR;            // RTC Match Register
wire [31:0] RTCLR;            // RTCLR Load Register
wire        RTCIMSC;          // RTC Interrupt Mask/Set Clear register
wire        RTCICR;           // RTC Interrupt Clear Register
wire        WrenRTCLR;        // Write enable for RTCLR
wire        WrenRTCMR;        // Write enable for RTCMR
wire        RawIntSync;       // Synchronised raw interrupt
wire        IntClear;         //
wire [31:0] MatchData;        // Equivalent match value
wire        RawInt;           // Raw interrupt
wire        RawIntEdge;       // Asserted on a low-high transition of the
                              // synchronised raw interrupt
wire [31:0] Count;            // Counter
wire [31:0] CountSync;        // Synchronised counter (to PCLK)
wire        RawIntStatus;     // Synchronised raw interrupt status
wire        MaskIntStatus;    // Synchronised masked interrupt status
wire [31:0] RtcValue;         // Value of the Real Time Clock (RTC)
wire [31:0] Offset;           // Calculated offset value
wire        MaskInt;          // Masked interrupt
wire        IntRTCINTR;       // Rtc interrupt for integration test
wire [31:0] RTCTOFFSET;       // RTC Test Offset register
wire [31:0] RTCTCOUNT;        // RTC Test Count register
wire        TESTOFFSET;       // Test offset enable
wire        TESTCOUNT;        // Test count enable
wire        RTCEn;            // RTC enable signal
wire        CountEdge;        // Counter incrementer signal
wire [3:0]  TieOff1;          // Revision number tieoff
wire [3:0]  TieOff2;          // Revision number tieoff
wire [3:0]  Revision;         // Revision number output

// -----------------------------------------------------------------------------
// Assign output from internal signals
// -----------------------------------------------------------------------------
  assign RTCINTR = IntRTCINTR;


// -----------------------------------------------------------------------------
// Assign the Revision number
// -----------------------------------------------------------------------------
assign TieOff1 = 4'b0000;
assign TieOff2 = 4'b0000;

// -----------------------------------------------------------------------------
// Instanstiation of RtcControl
// -----------------------------------------------------------------------------
// This block generates the control signals for various operations
// of calculating updated RTC values in the Update block.
// -----------------------------------------------------------------------------
  RtcControl uRtcControl        (
                       // Inputs
                         .PCLK            (PCLK),
                         .PRESETn         (PRESETn),
                         .RTCIntClr       (RTCICR),
                         .RawIntSync      (RawIntSync),
                       // Outputs
                         .IntClear        (IntClear)
                         );

// -----------------------------------------------------------------------------
// Instanstiation of RtcApbif
// -----------------------------------------------------------------------------
// This block is the APB interface and register block for the RTC.
//
// This block generates the address decodes for the registers during APB read
// and write transactions.
//
// It also contains the registers within the RTC.
// -----------------------------------------------------------------------------
 RtcApbif uRtcApbif (
                    // Inputs
                     .PCLK           (PCLK),
                     .PRESETn        (PRESETn),
                     .nPOR           (nPOR),
                     .PSEL           (PSEL),
                     .PENABLE        (PENABLE),
                     .PWRITE         (PWRITE),
                     .PWDATA         (PWDATA),
                     .PADDR          (PADDR),
                     .RTCDR          (RtcValue),
                     .RTCRIS         (RawIntStatus),
                     .RTCMIS         (MaskIntStatus),
                     .RawIntSync     (RawIntSync),
                     .MaskInt        (MaskInt),
                     .CountSync      (CountSync),
                     .Offset         (Offset),
                     .Revision       (Revision),
                    // Outputs
                     .WrenRTCLR      (WrenRTCLR),
                     .WrenRTCMR      (WrenRTCMR),
                     .RTCMR          (RTCMR),
                     .RTCLR          (RTCLR),
                     .RTCICR         (RTCICR),
                     .RTCIMSC        (RTCIMSC),
                     .RTCEn          (RTCEn),
                     .RTCTOFFSET     (RTCTOFFSET),
                     .RTCTCOUNT      (RTCTCOUNT),
                     .IntRTCINTR     (IntRTCINTR),
                     .TESTCOUNT      (TESTCOUNT),
                     .TESTOFFSET     (TESTOFFSET),
                     .PRDATA         (PRDATA)
                    );

// -----------------------------------------------------------------------------
// Instanstiation of RtcCounter
// -----------------------------------------------------------------------------
// This block has the 32bit counter clocked by the 1HZ clock.

 RtcCounter uRtcCounter (
                       // Inputs
                         .CLK1HZ        (CLK1HZ),
                         .nRTCRST       (nRTCRST),
                         .RTCTCOUNT     (RTCTCOUNT),
                         .TESTCOUNT     (TESTCOUNT),
                       // Outputs
                         .Count         (Count)
                         );
// -----------------------------------------------------------------------------
// Instanstiation of RtcInterrupt
// -----------------------------------------------------------------------------
// This block has the asynchronous interrupt generation logic.

  RtcInterrupt uRtcInterrupt   (
                              // Inputs
                                .PCLK         (PCLK),
                                .PRESETn      (PRESETn),
                                .MatchData    (MatchData),
                                .Count        (Count),
                                .IntClear     (IntClear),
                                .RTCIMSC      (RTCIMSC),
                                .RTCIntClr    (RTCICR),
                                .RawIntEdge   (RawIntEdge),
                              // Outputs
                                .MaskInt      (MaskInt),
                                .RawInt       (RawInt),
                                .RawIntStatus (RawIntStatus)
                                );
// -----------------------------------------------------------------------------
// Instanstiation of RtcUpdate
// -----------------------------------------------------------------------------
// This has the update logic for calculating updates to the RTc and the
// equivalent match value.

 RtcUpdate uRtcUpdate   (
                       // Inputs
                         .PCLK           (PCLK),
                         .PRESETn        (PRESETn),
                         .nPOR           (nPOR),
                         .CountSync      (CountSync),
                         .RTCMR          (RTCMR),
                         .RTCLR          (RTCLR),
                         .RTCTOFFSET     (RTCTOFFSET),
                         .TESTOFFSET     (TESTOFFSET),
                         .RTCEn          (RTCEn),
                         .WrenRTCLR      (WrenRTCLR),
                         .WrenRTCMR      (WrenRTCMR),
                         .CountEdge      (CountEdge),
                       // Outputs
                         .RtcValue       (RtcValue),
                         .Offset         (Offset),
                         .MatchData      (MatchData)
                         );

// -----------------------------------------------------------------------------
// Instanstiation of RtcSynctoPCLK
// -----------------------------------------------------------------------------
// This has synchronisation logic from the CLK1HZ domain to the PCLK domain

RtcSynctoPCLK uRtcSynctoPCLK (
                            // Inputs
                             .PCLK             (PCLK),
                             .PRESETn          (PRESETn),
                             .nPOR             (nPOR),
                             .RawInt           (RawInt),
                             .MaskInt          (MaskInt),
                             .Count            (Count),
                            // Outputs
                             .RawIntSync       (RawIntSync),
                             .RawIntEdge       (RawIntEdge),
                             .MaskIntStatus    (MaskIntStatus),
                             .CountEdge        (CountEdge),
                             .CountSync        (CountSync)
                             );

// -----------------------------------------------------------------------------
// 1st instantiation of RtcRevAnd
// -----------------------------------------------------------------------------
RtcRevAnd u0RtcRevAnd (
                         .TieOff1   (TieOff1[0]),
                         .TieOff2   (TieOff2[0]),
                        // Output
                         .Revision  (Revision[0])
                        );

// -----------------------------------------------------------------------------
// 2nd instantiation of RtcRevAnd
// -----------------------------------------------------------------------------
RtcRevAnd u1RtcRevAnd (
                         .TieOff1  (TieOff1[1]),
                         .TieOff2  (TieOff2[1]),
                        // Output
                         .Revision (Revision[1])
                        );

// -----------------------------------------------------------------------------
// 3rd instantiation of RtcRevAnd
// -----------------------------------------------------------------------------
RtcRevAnd u2RtcRevAnd (
                         .TieOff1  (TieOff1[2]),
                         .TieOff2  (TieOff2[2]),
                        // Output
                         .Revision (Revision[2])
                        );

// -----------------------------------------------------------------------------
// 4th instantiation of RtcRevAnd
// -----------------------------------------------------------------------------
RtcRevAnd u3RtcRevAnd (
                         .TieOff1  (TieOff1[3]),
                         .TieOff2  (TieOff2[3]),
                        // Output
                         .Revision (Revision[3])
                        );

endmodule // Rtc

// --==================================End of Rtc===============================
