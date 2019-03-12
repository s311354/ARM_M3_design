// -----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//               (C) COPYRIGHT 2014-2015 ARM Limited or its affiliates.
//                   ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
// SVN Information
//
// Checked In :  2015-01-07 18:46:45 +0000 (Wed, 07 Jan 2015)
// Revision :  9182
//
// Release Information : CM3DesignStart-r0p0-02rel0
//
// -----------------------------------------------------------------------------
// Verilog-2001 (IEEE Std 1364-2001)
// -----------------------------------------------------------------------------
// Purpose : Static Register: used to make the compiler preserve tie-offs as a
// register to facilitate altering revision numbers as an ECO
//
// -----------------------------------------------------------------------------

module static_reg
#(
  parameter WIDTH=1
)
(
  input wire              clk,
  input wire              reset_n,
  input wire [WIDTH-1:0]  static_i,

  output wire [WIDTH-1:0] static_o
);

//internal signals
  reg [WIDTH-1:0]   static_r;
  reg               static_up;
  wire              static_en;

//---------------------------
//Main Code
//---------------------------

  always@(posedge clk)
  begin
    if(static_en)
    begin
      static_r[WIDTH-1:0] <= static_i[WIDTH-1:0];
    end
  end

  always@(posedge clk or negedge reset_n)
  begin
    if(!reset_n)
    begin
      static_up <= 1'b1;
    end
    else if(static_en)
    begin
      static_up <= 1'b0;
    end
  end

  //Enable for registers
  assign static_en = static_up;

  //assign outputs
  assign static_o[WIDTH-1:0] = static_r[WIDTH-1:0];

endmodule



