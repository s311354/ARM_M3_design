//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2017 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//  Version and Release Control Information:
//
//  Checked In          : $Date: 2015-07-29 14:21:55 +0100 (Wed, 29 Jul 2015) $
//
//  File Revision       : $Revision: 365823 $
//
//  Release Information : CM3DesignStart-r0p0-02rel0
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Abstract : Cortex-M3 ETM Timestamp source
//-----------------------------------------------------------------------------
//
// 48 bit uo counter with enables
//-----------------------------------------------------------------------------
module m3ds_tscnt_48 (

  // Clock and Reset
  input wire         clk,
  input wire         resetn,

  // Enable normal count operation
  input wire        enablecnt_i,


  // Time Stamp Encoder
  output wire [47:0] tsvalueb_o

  );

//----------------------------------------------------------------------------
// Signals
//----------------------------------------------------------------------------
  wire [48:0] tsvalueb_nxt;
  reg  [47:0] tsvalueb;

//============================================================================
//
// Main body of code
//
//============================================================================

//----------------------------------------------------------------------------
// TSVALUEB 48 bits. When enablecnt is asserted then the counter will
// perform a normal up-count otherwise the counter will retain its value.
//----------------------------------------------------------------------------
  assign tsvalueb_nxt = tsvalueb + {{47{1'b0}}, 1'b1};

//----------------------------------------------------------------------------
// enable the counter to be update only when enabled
//----------------------------------------------------------------------------
  always @(posedge clk or negedge resetn)
    if (!resetn) begin
      tsvalueb <= {48{1'b0}};
    end else if (enablecnt_i) begin
      tsvalueb <= tsvalueb_nxt[47:0];
    end

  // Output connections
  assign tsvalueb_o = tsvalueb;

endmodule
