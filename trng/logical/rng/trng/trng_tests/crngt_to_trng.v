//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module crngt_to_trng (
      rst_n    ,
      rng_clk    ,
      rnd_src_en    ,
      collector_crngt_data,
      collector_valid  ,
      trng_valid    ,
      trng_crngt_bypass  ,
      rst_trng_logic  ,
      crngt_collector_rd  ,
      crngt_dout    ,
      crngt_valid     ,
      crngt_err  
      );
`include "cc_params.inc"
input     rst_n    ;
input     rng_clk    ;
input    rnd_src_en      ;
input   [15:0]  collector_crngt_data;
input     collector_valid  ;
input     trng_valid  ;
input     trng_crngt_bypass;
input     rst_trng_logic  ;
output     crngt_collector_rd;
output     crngt_valid  ;
output  [15:0]   crngt_dout  ;
output    crngt_err  ;
`ifdef CRNGT_EXISTS
reg   [15:0]  prev_din  ;
reg    first_16_bits  ;
wire    prev_and_curr_eq;
wire    crngt_collector_rd;
wire     crngt_valid  ;
wire     oen_local  ;
wire    loc_enable  ;
wire    crngt_err  ;
assign   loc_enable = rnd_src_en & !trng_crngt_bypass; 
assign crngt_collector_rd = collector_valid & !trng_valid & loc_enable;
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) first_16_bits <= 1'b1;
  else if(rst_trng_logic) first_16_bits <= #1 1'b1;
  else if(loc_enable && first_16_bits && collector_valid) first_16_bits <= #1 1'b0;
always @ (posedge rng_clk or negedge rst_n) 
  if(!rst_n) prev_din[15:0] <= 16'd0;
  else if(rst_trng_logic) prev_din[15:0] <= #1 16'd0;
  else if(loc_enable && first_16_bits && collector_valid)
             prev_din[15:0] <= #1 collector_crngt_data[15:0];
  else if(oen_local)
             prev_din[15:0] <= #1 collector_crngt_data[15:0];
assign prev_and_curr_eq = (collector_crngt_data[15:0] == prev_din[15:0]);
assign oen_local = !prev_and_curr_eq & collector_valid & !trng_valid & loc_enable;
assign crngt_valid =  oen_local & !first_16_bits ; 
assign crngt_dout= collector_crngt_data;
assign crngt_err = prev_and_curr_eq & collector_valid & !trng_valid & loc_enable;
`else
wire     crngt_collector_rd;
wire     crngt_valid    ;
wire  [15:0]   crngt_dout    ;
wire    crngt_err    ;
wire    first_16_bits    ;
assign crngt_collector_rd    = collector_valid & !trng_valid;
assign crngt_valid  = collector_valid & !trng_valid;
assign crngt_dout = collector_crngt_data[15:0];
assign crngt_err  = 1'b0;
assign first_16_bits  = 1'b0;
`endif
endmodule
