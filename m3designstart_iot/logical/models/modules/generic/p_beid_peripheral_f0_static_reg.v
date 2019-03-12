//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//        (C) COPYRIGHT 2015 ARM Limited or its affiliates.
//            ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
//      SVN Information
//
//      Checked In          :  2015-09-17 13:43:40 +0100 (Thu, 17 Sep 2015)
//
//      Revision            :  2354
//
//      Release Information : CM3DesignStart-r0p0-02rel0
//
//-----------------------------------------------------------------------------
// Purpose : Generic Static Register: used to make the compiler preserve tie-offs
// as a register to facilitate altering revision numbers as an ECO
//-----------------------------------------------------------------------------

module p_beid_peripheral_f0_static_reg (clk, reset_n, static_i, static_o);

  parameter WIDTH=1;

  input                          clk;
  input                          reset_n;
  input  [WIDTH-1:0]             static_i;
  output [WIDTH-1:0]             static_o;

  wire                           clk;
  wire                           reset_n;
  wire   [WIDTH-1:0]             static_i;
  wire   [WIDTH-1:0]             static_o;

  static_reg #(WIDTH) u_static_reg(
    .clk                        (clk),
    .reset_n                    (reset_n),
    .static_i                   (static_i),
    .static_o                   (static_o)
  );

endmodule
