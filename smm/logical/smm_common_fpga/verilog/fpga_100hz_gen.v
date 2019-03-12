//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//        (C) COPYRIGHT 2013 ARM Limited or its affiliates.
//            ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
// -----------------------------------------------------------------------------
//
//      SVN Information
//
//      Checked In          : $Date: 2013-04-05 11:54:17 +0100 (Fri, 05 Apr 2013) $
//
//      Revision            : $Revision: 242973 $
//
//      Release Information : CM3DesignStart-r0p0-01rel0
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : Generate 100Hz clock from 25MHz for V2M-MPS2
//-----------------------------------------------------------------------------
// This can be used for typical benchmarking or timing reference

module fpga_100hz_gen (
  input  wire  clk25mhz,
  input  wire  reset_n,
  output wire  clk100hz
  );

  reg [17:0]  reg_cntr;

  reg         reg_clk100hz;

  // Counter overflow at 200Hz
  always @(posedge clk25mhz or negedge reset_n)
  begin
    if (~reset_n)
      reg_cntr <= {18{1'b0}};
    else
      if (reg_cntr[16:0]==17'h1E847) //top bit of reg_cntr discarded due to this check
        reg_cntr <= {18{1'b0}};
      else
        reg_cntr <= reg_cntr[16:0] + 17'h00001;
  end

  // Toggle at 200Hz -> 100Hz clock
  always @(posedge clk25mhz or negedge reset_n)
  begin
    if (~reset_n)
      reg_clk100hz <= 1'b0;
    else
      if (reg_cntr[16:0]==17'h1E847)
        reg_clk100hz <= ~reg_clk100hz;
  end

  assign clk100hz = reg_clk100hz;

endmodule

