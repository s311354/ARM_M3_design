//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2013,2017 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2013-04-05 11:54:17 +0100 (Fri, 05 Apr 2013) $
//
//      Revision            : $Revision: 365823 $
//
//      Release Information : CM3DesignStart-r0p0-02rel0
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : FPGA design options
//-----------------------------------------------------------------------------
`define REVC

`define INCLUDE_PSRAM

`define INCLUDE_VGA

`define INCLUDE_BLOCKRAM

// Include true random number generator
`define INCLUDE_TRNG
// Use FPGA structure for TRNG generator
`define DX_FPGA

//---------------------------------------------------------------
// CPU selection is done in cmsdk_mcu_defs.v as a single location
//---------------------------------------------------------------


// Note: PLL option is defined in synthesis project.
//       We don't want to use PLL in simulation.
// `define INCLUDE_PLL

// Appnote information
`define IDENT        12'h511
`define BUILD         8'h01
// Processor revision
// M3 is listed as r2p1.
`define VARIANT       4'h2
`define REV           4'h1

// Generate correct BOARD_TARGET code
`ifndef REVC
`ifndef REVB
//-----------
//   rev A
//-----------
// Target board Rev 0=A, 1=B, etc.
`define BOARD_TARGET  4'h0
`else
//-----------
//  rev B
//-----------
// Target board Rev 0=A, 1=B, etc.
`define BOARD_TARGET  4'h1
//-----------------------------------------------------------------------------

`endif
`else
//-----------
//  rev C
//-----------
// Target board Rev 0=A, 1=B, etc.
`define BOARD_TARGET  4'h2
//-----------------------------------------------------------------------------

`endif

