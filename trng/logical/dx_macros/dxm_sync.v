//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module dxm_sync(clk, rst_n, in, out);
parameter width=1;
parameter show_warn=1;
`include "cc_params.inc"    
input    clk, rst_n;
input  [width-1:0]  in;
output  [width-1:0]  out;
wire  [width-1:0]   out;
wire  [width-1:0]  internal;
   // synopsys translate_off
initial 
   if ((width != 1) && (show_warn == 1)) 
      begin
          $display ("\n\n %m Error! Bus should not be synchronized!!! width= %h \n\n", width);
          $finish;
       end
   // synopsys translate_on
dxm_ff dxm_ff_0(.clk(clk), .rst_n(rst_n), .d(in), .q(internal));
dxm_ff dxm_ff_1(.clk(clk), .rst_n(rst_n), .d(internal), .q(out));
endmodule
