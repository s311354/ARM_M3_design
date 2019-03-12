//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module autocorrelation (
        rst_n      ,
        rng_clk      ,
        data_in16bit    ,
        valid_16bit      ,
        accum_enough_bits    ,
        pmf_data_out    ,
        cpu_wr_autocorr_statistic,
        trng_valid      ,
        ehr_valid      ,
        collector_valid    ,
        trng_crngt_bypass    ,
        auto_correlate_bypass  ,
        rst_trng_logic    ,
        rnd_src_en      ,
        autocorr_4_consecutive_errors,
        pmf_addr_in      ,
        curr_test_err    ,
        autocorr_finish_curr  ,
        autocorr_trys_cnt    ,
                    autocorr_fails_cnt
           );
`include "rng_params.inc"
`include "cc_params.inc"    
input     rst_n      ;
input     rng_clk      ;
input  [15:0]  data_in16bit    ;
input     valid_16bit    ;
input     accum_enough_bits  ;
input   [13:0]  pmf_data_out    ;
input     cpu_wr_autocorr_statistic;
input     trng_valid    ;
input     ehr_valid    ;
input     collector_valid    ;
input     trng_crngt_bypass  ;
input     auto_correlate_bypass  ;
input     rst_trng_logic    ;
input     rnd_src_en    ;
output     autocorr_4_consecutive_errors;
output   [`PMF_IN_WIDTH:0] pmf_addr_in  ;
output     curr_test_err    ;   
output     autocorr_finish_curr  ;   
output   [13:0]  autocorr_trys_cnt  ;
output   [7:0]  autocorr_fails_cnt  ;
`ifdef AUTOCORR_EXISTS
`ifdef AUTOCORR_192_BITS
parameter   THRESHOLD = 14'h2A29; 
`else
parameter   THRESHOLD = 14'h2AE3; 
`endif
integer   i;
integer   k;
integer   l;
integer   m;
reg  [7:0]  prev8bits    ;
reg  [3:0]  ent_bits_cnt    ;
reg    do_count    ;
reg    bits_mux    ;
reg     [7:0]   counters_en    ;
reg     [`PMF_IN_WIDTH:0] counters0;
reg     [`PMF_IN_WIDTH:0] counters1;
reg     [`PMF_IN_WIDTH:0] counters2;
reg     [`PMF_IN_WIDTH:0] counters3;
reg     [`PMF_IN_WIDTH:0] counters4;
reg     [`PMF_IN_WIDTH:0] counters5;
reg     [`PMF_IN_WIDTH:0] counters6;
reg     [`PMF_IN_WIDTH:0] counters7;
reg    [2:0]   counter_sel    ;
wire   [`PMF_IN_WIDTH:0] counters_mux  ;
reg  [13:0]  s_param      ;
reg  [1:0]  consecutve_fails_cntr  ;
reg  [13:0]  autocorr_trys_cnt  ;
reg  [7:0]  autocorr_fails_cnt  ;
reg    counter_sel_is_7_s  ;
reg    first_8bits    ;
reg     autocorr_four_errors  ;
wire    rst_counters    ;
wire    counter_sel_is_7  ;
wire    counter_sel_inc    ;
wire  [`PMF_IN_WIDTH:0] pmf_addr_in  ;
wire  [14:0]  adder_pmf_s_param  ;
wire     start_count    ;
wire    ent_bits_cnt_is_7  ;
wire    ent_bits_cnt_is_15  ;
wire    new_round_of_collecting_bits;
wire     new_round_and_no_err_happened;
wire    stop_collect_stat  ;
wire    count_trys    ;     
wire    count_fails    ;    
wire    autocorr_finish_curr  ;
wire    rst_do_count    ;
wire     rst_ent_bits_cnt  ;
wire    rst_prev8bits    ;
wire    rst_first_8bits    ;
wire     autocorr_4_consecutive_errors;
wire    cnt_en1      ;
wire    cnt_en2      ;
wire    cnt_en3      ;
wire    cnt_en4      ;
wire    cnt_en5      ;
wire    cnt_en6      ;
wire    cnt_en7      ;
wire    cnt_en8      ;
wire  [`PMF_IN_WIDTH:0] counter1  ;
wire  [`PMF_IN_WIDTH:0] counter2  ;
wire  [`PMF_IN_WIDTH:0] counter3  ;
wire  [`PMF_IN_WIDTH:0] counter4  ;
wire  [`PMF_IN_WIDTH:0] counter5  ;
wire  [`PMF_IN_WIDTH:0] counter6  ;
wire  [`PMF_IN_WIDTH:0] counter7  ;
wire  [`PMF_IN_WIDTH:0] counter8  ;
assign cnt_en1  = counters_en[0]  ;
assign cnt_en2  = counters_en[1]  ;
assign cnt_en3  = counters_en[2]  ;
assign cnt_en4  = counters_en[3]  ;
assign cnt_en5  = counters_en[4]  ;
assign cnt_en6  = counters_en[5]  ;
assign cnt_en7  = counters_en[6]  ;
assign cnt_en8  = counters_en[7]  ;
assign counter1 = counters0    ;
assign counter2 = counters1    ;
assign counter3 = counters2    ;
assign counter4 = counters3    ;
assign counter5 = counters4    ;
assign counter6 = counters5    ;
assign counter7 = counters6    ;
assign counter8 = counters7    ;
assign   start_count = rnd_src_en &((valid_16bit & !auto_correlate_bypass) | (collector_valid & trng_crngt_bypass & !auto_correlate_bypass));
assign  ent_bits_cnt_is_15 = (ent_bits_cnt == 4'd15);
assign  ent_bits_cnt_is_7  = (ent_bits_cnt == 4'd7);
assign   rst_do_count = rst_trng_logic | curr_test_err | ent_bits_cnt_is_15;
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) do_count <= 1'b0;
  else if(rst_do_count) do_count <= #1 1'b0;
  else if(start_count)  do_count <= #1 1'b1;
assign   rst_ent_bits_cnt = rst_trng_logic | curr_test_err;
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) ent_bits_cnt[3:0] <= 4'd0;
  else if(rst_ent_bits_cnt) ent_bits_cnt <= #1 4'd0;
  else if(do_count)         ent_bits_cnt <= #1 ent_bits_cnt[3:0] + 1'b1;
assign   rst_prev8bits = rst_trng_logic | curr_test_err;
assign  rst_first_8bits = new_round_of_collecting_bits | rst_prev8bits;
always @ (posedge rng_clk or negedge rst_n) 
  if(!rst_n) first_8bits <= 1'b1;
  else if(rst_first_8bits)   first_8bits <= #1 1'b1;
  else if(ent_bits_cnt_is_7) first_8bits <= #1 1'b0; 
always @ (posedge rng_clk or negedge rst_n) begin
  if(!rst_n) prev8bits[7:0] <= 8'd0;
  else if(first_8bits && ent_bits_cnt_is_7) 
             prev8bits <= #1 data_in16bit[7:0];
  else if(do_count && !first_8bits) begin 
             prev8bits <= #1 {data_in16bit[ent_bits_cnt], prev8bits[7:1]};
  end
end
always @(*) begin
  bits_mux = 1'b0;
  for(i=0;i<16;i=i+1) begin
      if(i == ent_bits_cnt) 
          bits_mux = data_in16bit[i];
  end
end
always @(*) begin
  counters_en[7:0] = 8'd0;
  if(do_count && !first_8bits ) begin
    counters_en[0] = (bits_mux == prev8bits[7]); 
    counters_en[1] = (bits_mux == prev8bits[6]); 
    counters_en[2] = (bits_mux == prev8bits[5]); 
    counters_en[3] = (bits_mux == prev8bits[4]); 
    counters_en[4] = (bits_mux == prev8bits[3]); 
    counters_en[5] = (bits_mux == prev8bits[2]); 
    counters_en[6] = (bits_mux == prev8bits[1]); 
    counters_en[7] = (bits_mux == prev8bits[0]); 
  end
end
assign rst_counters = new_round_of_collecting_bits | curr_test_err | rst_trng_logic;
always @(posedge rng_clk or negedge rst_n)  
  if(!rst_n)
     begin
         counters0 <= {(`PMF_IN_WIDTH+1){1'b0}};
         counters1 <= {(`PMF_IN_WIDTH+1){1'b0}};
         counters2 <= {(`PMF_IN_WIDTH+1){1'b0}};
         counters3 <= {(`PMF_IN_WIDTH+1){1'b0}};
         counters4 <= {(`PMF_IN_WIDTH+1){1'b0}};
         counters5 <= {(`PMF_IN_WIDTH+1){1'b0}};
         counters6 <= {(`PMF_IN_WIDTH+1){1'b0}};
         counters7 <= {(`PMF_IN_WIDTH+1){1'b0}};
     end
  else if(rst_counters)
     begin
         counters0 <=#1 {(`PMF_IN_WIDTH+1){1'b0}};
         counters1 <=#1 {(`PMF_IN_WIDTH+1){1'b0}};
         counters2 <=#1 {(`PMF_IN_WIDTH+1){1'b0}};
         counters3 <=#1 {(`PMF_IN_WIDTH+1){1'b0}};
         counters4 <=#1 {(`PMF_IN_WIDTH+1){1'b0}};
         counters5 <=#1 {(`PMF_IN_WIDTH+1){1'b0}};
         counters6 <=#1 {(`PMF_IN_WIDTH+1){1'b0}};
         counters7 <=#1 {(`PMF_IN_WIDTH+1){1'b0}};
     end
  else 
     begin
         if(counters_en[0] ) begin
      counters0 <= #1 counters0 + 1'b1;
   end
         if(counters_en[1] ) begin
      counters1 <= #1 counters1 + 1'b1;
   end
         if(counters_en[2] ) begin
      counters2 <= #1 counters2 + 1'b1;
   end
         if(counters_en[3] ) begin
      counters3 <= #1 counters3 + 1'b1;
   end
         if(counters_en[4] ) begin
      counters4 <= #1 counters4 + 1'b1;
   end
         if(counters_en[5] ) begin
      counters5 <= #1 counters5 + 1'b1;
   end
         if(counters_en[6] ) begin
      counters6 <= #1 counters6 + 1'b1;
   end
         if(counters_en[7] ) begin
      counters7 <= #1 counters7 + 1'b1;
   end
     end
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) counter_sel_is_7_s <= 1'b0;
  else counter_sel_is_7_s <= #1 counter_sel_is_7 & !curr_test_err;
assign   counter_sel_is_7 = (counter_sel == 3'd7);
assign  new_round_of_collecting_bits = counter_sel_is_7_s & !counter_sel_is_7 | curr_test_err;
assign  new_round_and_no_err_happened = new_round_of_collecting_bits & !curr_test_err;
assign  counter_sel_inc = accum_enough_bits & !do_count & !ehr_valid & !trng_valid & !auto_correlate_bypass & rnd_src_en;
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) counter_sel[2:0] <= 3'd0;
  else if(curr_test_err || rst_trng_logic) counter_sel[2:0] <= #1 3'd0;
  else if(counter_sel_inc)
          counter_sel <= #1 counter_sel + 1'b1;
assign counters_mux = (counter_sel==3'h0) ? counters0:
                      (counter_sel==3'h1) ? counters1:
                      (counter_sel==3'h2) ? counters2:
                      (counter_sel==3'h3) ? counters3:
                      (counter_sel==3'h4) ? counters4:
                      (counter_sel==3'h5) ? counters5:
                      (counter_sel==3'h6) ? counters6:
                                            counters7;
assign pmf_addr_in = counters_mux;
assign adder_pmf_s_param[14:0] = {1'b0,pmf_data_out[13:0]} + {1'b0,s_param[13:0]};
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) s_param[13:0] <= 14'd0;
  else if(rst_trng_logic) s_param <= #1 14'd0;
  else if(new_round_of_collecting_bits) s_param <= #1 14'd0;
  else if(counter_sel_inc) s_param <= #1 {14{adder_pmf_s_param[14]}} | adder_pmf_s_param[13:0];
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) consecutve_fails_cntr[1:0] <= 2'd0; 
  else if(new_round_and_no_err_happened || rst_trng_logic) consecutve_fails_cntr[1:0] <=#1 2'd0;
  else if(curr_test_err) consecutve_fails_cntr <= #1 consecutve_fails_cntr + 1'b1;
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) autocorr_four_errors <= 1'b0;
  else if((consecutve_fails_cntr == 2'd3) & curr_test_err) autocorr_four_errors <= #1 1'b1;
assign curr_test_err = (s_param >= THRESHOLD);
assign autocorr_4_consecutive_errors = autocorr_four_errors | ((consecutve_fails_cntr == 2'd3) & curr_test_err);
assign autocorr_finish_curr = new_round_of_collecting_bits;
assign  stop_collect_stat = (&autocorr_trys_cnt) | (&autocorr_fails_cnt);
assign  count_trys      = autocorr_finish_curr   & !stop_collect_stat;
assign   count_fails     = curr_test_err & !stop_collect_stat;
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) autocorr_trys_cnt <= 14'd0;
  else if(cpu_wr_autocorr_statistic) autocorr_trys_cnt <=#1 14'd0;
  else if (count_trys) autocorr_trys_cnt <= #1 autocorr_trys_cnt  + 1'b1;
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) autocorr_fails_cnt <= 8'd0;
  else if(cpu_wr_autocorr_statistic) autocorr_fails_cnt <=#1 8'd0;
  else if (count_fails) autocorr_fails_cnt <= #1 autocorr_fails_cnt  + 1'b1;
`ifdef ASSERT_ON
`ifdef RNG_EXISTS
 `include "trng_asrt_3_1.sva"
 `include "trng_asrt_3_1_2.sva"
 `include "trng_asrt_3_2.sva"
 `include "trng_asrt_3_3.sva"
 `include "trng_asrt_3_3_1.sva"
`endif
`endif
`else 
wire     autocorr_4_consecutive_errors;
wire   [`PMF_IN_WIDTH:0] pmf_addr_in  ;
wire     curr_test_err    ;   
wire     autocorr_finish_curr  ;   
wire   [13:0]  autocorr_trys_cnt  ;
wire   [7:0]  autocorr_fails_cnt  ;
wire    new_round_of_collecting_bits  ;
wire  [13:0]  s_param      ;
wire    [`PMF_IN_WIDTH:0] counters0;
wire    [`PMF_IN_WIDTH:0] counters1;
wire    [`PMF_IN_WIDTH:0] counters2;
wire    [`PMF_IN_WIDTH:0] counters3;
wire    [`PMF_IN_WIDTH:0] counters4;
wire    [`PMF_IN_WIDTH:0] counters5;
wire    [`PMF_IN_WIDTH:0] counters6;
wire    [`PMF_IN_WIDTH:0] counters7;
wire    counter_sel_inc    ;
wire    [2:0] counter_sel;
assign autocorr_4_consecutive_errors  = 1'b0;
assign pmf_addr_in      = {(`PMF_IN_WIDTH+1){1'b0}};
assign curr_test_err      = 1'b0;   
assign autocorr_finish_curr    = 1'b0;   
assign autocorr_trys_cnt    = 14'b0;
assign autocorr_fails_cnt    = 8'b0;
assign new_round_of_collecting_bits      = 1'b0;   
assign s_param        = 14'b0;
assign counters0      = {(`PMF_IN_WIDTH+1){1'b0}};
assign counters1      = {(`PMF_IN_WIDTH+1){1'b0}};
assign counters2      = {(`PMF_IN_WIDTH+1){1'b0}};
assign counters3      = {(`PMF_IN_WIDTH+1){1'b0}};
assign counters4      = {(`PMF_IN_WIDTH+1){1'b0}};
assign counters5      = {(`PMF_IN_WIDTH+1){1'b0}};
assign counters6      = {(`PMF_IN_WIDTH+1){1'b0}};
assign counters7      = {(`PMF_IN_WIDTH+1){1'b0}};
assign counter_sel_inc      = 1'b0;
assign counter_sel      = 3'b0;
`endif
endmodule
