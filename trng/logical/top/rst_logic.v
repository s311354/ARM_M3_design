//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module rst_logic (
      clk          ,
      sys_rst_n       ,
      rng_sw_reset ,
      scan_mode    ,
      rst_n 
      );
`include "cc_params.inc" 
   input      clk          ;
   input      sys_rst_n       ;
   input      rng_sw_reset ;
   input      scan_mode    ;
   output     rst_n        ;
   wire       rst_n        ;
   wire       resetn_d1    ;
   wire       resetn_d2    ;
   wire       resetn_d3    ;
   wire       resetn_d4    ;
   wire       rst_n_temp   ;
   reg         resetn_q1    ;
   reg         resetn_q2    ;
   reg         resetn_q3    ;
   reg         resetn_q4    ;
   assign     resetn_d1   =  rng_sw_reset                          ;
   assign     resetn_d2   =  resetn_q1                             ;
   assign     resetn_d3   =  resetn_q2                             ; 
   assign     resetn_d4   =  resetn_q3                             ;
   assign     rst_n_temp  =  !resetn_q4 & sys_rst_n                ;
dxm_mux i_rst_n_gen (.in_low(rst_n_temp), .in_high(sys_rst_n), .control(scan_mode), .out(rst_n));
     always @(posedge clk or negedge sys_rst_n)
      begin
            if (!sys_rst_n)
               resetn_q1   <=  #1 1'b0 ;
          else
               resetn_q1   <=  #1 resetn_d1 ;
      end 
     always @(posedge clk or negedge sys_rst_n)
      begin
            if (!sys_rst_n)
               resetn_q2   <=  #1 1'b0 ;
          else
               resetn_q2   <=  #1 resetn_d2 ;
      end 
     always @(posedge clk or negedge sys_rst_n)
      begin
            if (!sys_rst_n)
               resetn_q3   <=  #1 1'b0 ;
          else
               resetn_q3   <=  #1 resetn_d3 ;
      end 
     always @(posedge clk or negedge sys_rst_n)
      begin
            if (!sys_rst_n)
               resetn_q4   <=  #1 1'b0 ;
          else
               resetn_q4   <=  #1 resetn_d4 ;
      end 
endmodule
