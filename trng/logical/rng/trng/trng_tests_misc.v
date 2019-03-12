//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module trng_tests_misc (
        rng_clk        ,
        rst_n        ,
        crngt_valid    ,
        cpu_ehr_rd    ,
        cpu_ehr_wr    ,
        curr_test_err  ,
        autocorr_finish_curr,
        collector_valid  ,
        trng_crngt_bypass,
        auto_correlate_bypass,
        trng_valid    ,
        cpu_in_mid_rd_of_ehr_not_in_debug_mode,
        prng_trng_ehr_rd,
        rst_trng_logic  ,
        rd_sop          ,
        sop_sel         ,
        accum_enough_bits,
        ehr_valid    ,  
        bits_counter  ,
        trng_prng_ehr_valid      
        );
`include "cc_params.inc" 
input           rng_clk          ;
input           rst_n          ;
input         crngt_valid        ;
input         cpu_ehr_rd        ;
input         cpu_ehr_wr        ;
input         curr_test_err      ;
input         autocorr_finish_curr;
input         collector_valid    ;
input         trng_crngt_bypass  ;
input         auto_correlate_bypass;
input         trng_valid        ;
input         cpu_in_mid_rd_of_ehr_not_in_debug_mode;
input         prng_trng_ehr_rd    ;
input         rst_trng_logic      ;
input         rd_sop             ;
input         sop_sel           ;
output         accum_enough_bits   ;
output         ehr_valid        ;
output  [7:0]  bits_counter      ;  
output         trng_prng_ehr_valid  ;
reg      [7:0]  bits_counter    ;
wire        rst_bits_counter  ;
wire  [7:0]  next_bits_counter  ;
wire        accum_enough_bits  ;
wire        ehr_valid        ;
wire        trng_prng_ehr_valid  ;
assign  rst_bits_counter  = rst_trng_logic | curr_test_err | prng_trng_ehr_rd | (rd_sop & trng_valid & sop_sel); 
assign   next_bits_counter = cpu_ehr_rd  ? (bits_counter - 8'd32) : 
                      cpu_ehr_wr  ? (bits_counter + 8'd32) : 
                            crngt_valid ? (bits_counter + 8'd16) : 
                      (trng_crngt_bypass & collector_valid & !(ehr_valid || trng_valid)) ? (bits_counter + 8'd16) : 
                      bits_counter;
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) bits_counter[7:0] <= 8'd0;
  else if(rst_bits_counter) bits_counter[7:0] <= #1 8'd0;
  else bits_counter <= #1 next_bits_counter;
assign  accum_enough_bits = (bits_counter == `EHR_WIDTH);
`ifdef AUTOCORR_EXISTS 
assign  ehr_valid = accum_enough_bits & !curr_test_err & (autocorr_finish_curr | auto_correlate_bypass) & !trng_valid;
`else
assign  ehr_valid = accum_enough_bits & !trng_valid;
`endif
assign  trng_prng_ehr_valid = (ehr_valid | trng_valid) & !cpu_in_mid_rd_of_ehr_not_in_debug_mode ;
`ifdef ASSERT_ON
`ifdef RNG_EXISTS
 `ifdef PRNG_EXISTS
   `include "trng_asrt_2_2.sva"
 `endif
 `include "trng_asrt_2_2_2.sva"
`endif
`endif
endmodule
