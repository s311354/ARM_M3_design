//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2007-2008 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//  ----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : RCSfile: SspRevAnd.v.rca $S
// File Revision          : 20352
//
//  Release Information    : r1p3-00rel1
//
// ---------------------------------------------------------------------
// Purpose :
//           Revision Designator Module
//
// --=================================================================--

// ---------------------------------------------------------------------

module SspRevAnd (
// Inputs
                 TieOff1,
                 TieOff2,
// Outputs
                 Revision
                 );

// Inputs
input        TieOff1;  // AND gate input 1
input        TieOff2;  // AND gate input 2
// Outputs
output       Revision; // AND gate output

// ---------------------------------------------------------------------
//
//                              SspRevAnd
//                              =========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module contains a single AND gate to be used as a
// place-holder cell to mark the Revision of the Ssp.
// The 2 input pins will be tied-off at the top level of the
// hierarchy. These "TieOffs" can be identified during layout
// and re-wired to "VDD" or "VSS" if needed.
//
// ---------------------------------------------------------------------


// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------


// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------



assign Revision = TieOff1 & TieOff2;

endmodule

// --============================== End ==============================--
