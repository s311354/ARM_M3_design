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
//  Filename            : RtcRevAnd.v.rca
//
//  File Revision       : 1.3
//
//  Release Information : PrimeCell(TM)-PL031-REL1v0
//
//  ----------------------------------------------------------------------------
//  Purpose               : Revision Designator Module
//
//  --========================================================================--

`timescale 1ns/1ps


module RtcRevAnd (
                   TieOff1,
                   TieOff2,
                   Revision
                  );

input        TieOff1;      // AND gate input 1
input        TieOff2;      // AND gate input 2

output       Revision;     // AND gate output

// -----------------------------------------------------------------------------
//
//                              RtcRevAnd
//                              =========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This module contains a single AND gate to be used as a
// place-holder cell to mark the Revision of the Rtc.
// The 2 input pins will be tied-off at the top level of the
// hierarchy. These "TieOffs" can be identified during layout
// and re-wired to "VDD" or "VSS" if needed.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declaration
// -----------------------------------------------------------------------------
wire        TieOff1;
// AND gate input 1                                        (Module Input)

wire        TieOff2;
// AND gate input 2                                        (Module Input)

wire        Revision;
// AND gate output                                         (Module Output)

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

assign Revision         = TieOff1 & TieOff2;

endmodule

// --========================= End of RtcRevAnd =============================--
