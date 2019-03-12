//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module dxm_mux_clk (
    in_low,
    in_high,
    control,
    out
    );
   parameter mux_width = 1;
`include "cc_params.inc"    
   input                   control;
   input  [mux_width-1:0]  in_low;
   input  [mux_width-1:0]  in_high;
   output [mux_width-1:0]  out;
   assign        out = control ? in_high : in_low;
endmodule
