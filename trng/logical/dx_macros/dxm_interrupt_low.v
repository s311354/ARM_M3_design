//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module dxm_interrupt_low(
        rst_n,
        clk,
        r_din,
        clr_status_1p,
        events_1p,
        mask,
        status,
        int_req
        );
   parameter VEC_W = 8;
   parameter DO_PRINT = 1;
`include "cc_params.inc"    
   input             rst_n;
   input             clk;
   input [VEC_W-1:0] r_din;
   input        clr_status_1p; 
   input [VEC_W-1:0] events_1p;    
   input [VEC_W-1:0] mask;
   output [VEC_W-1:0] status;
   output         int_req;
   reg [VEC_W-1:0]    status;
   reg           int_req;
   wire [VEC_W-1:0]   clr_vec;
   assign clr_vec = {~{{VEC_W{clr_status_1p}} & r_din}};
   always @(posedge clk or negedge rst_n)
     if (!rst_n) status <= {VEC_W{1'b0}};
     else        status <= #1 (status & clr_vec) | events_1p;
   always @(posedge clk or negedge rst_n)
     if (!rst_n) int_req   <= 1'b0;
     else        int_req   <= #1 |{status & (~mask)};
endmodule 
