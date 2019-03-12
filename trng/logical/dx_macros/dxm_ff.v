//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module dxm_ff(clk, rst_n, d, q);
`include "cc_params.inc"    
`ifdef DX_INTERNAL_ENV
    `define SIM_CDC
    `define DXM_DFF_HOLD 0.5
    `define DXM_DFF_SETUP 1 
`endif
input  clk, rst_n;
input  d;
output  q;
reg q;
always @(posedge clk or negedge rst_n)
   if (~rst_n) q <= 1'b0;
   else q <=#1 d;
endmodule
