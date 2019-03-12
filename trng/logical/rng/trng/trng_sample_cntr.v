//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module trng_sample_cntr (
       rst_n                ,
       rng_clk                ,
       rst_trng_logic    ,
       sample_cnt1       ,
       sync_valid           ,
       cntr_balance_valid 
       );
`include "rng_params.inc"
`include "cc_params.inc"    
   input   rst_n                               ; 
   input   rng_clk                                           ; 
   input [`SAMPLE_CNT_LOCAL_SIZE - 1:0] sample_cnt1 ; 
   input   rst_trng_logic              ;
   input   sync_valid                          ; 
   output   cntr_balance_valid                   ; 
   wire [`SAMPLE_CNT_LOCAL_SIZE - 1:0] cur_cnt_d     ;
   wire       cur_eq_sample        ;
   wire       cntr_balance_valid   ;
   reg [`SAMPLE_CNT_LOCAL_SIZE - 1:0]   cur_cnt      ;
   assign cur_eq_sample  = (cur_cnt == sample_cnt1)  ;
   assign cur_cnt_d = !sync_valid   ?  cur_cnt                      :
                cur_eq_sample ? {`SAMPLE_CNT_LOCAL_SIZE{1'b0}} : cur_cnt + 1'b1;
   assign cntr_balance_valid = cur_eq_sample & sync_valid;
   always@(posedge rng_clk or negedge rst_n) begin
      if (~rst_n) begin
   cur_cnt <= #1 {`SAMPLE_CNT_LOCAL_SIZE{1'b0}};
      end
      else if(rst_trng_logic)
        cur_cnt <= #1 {`SAMPLE_CNT_LOCAL_SIZE{1'b0}};
      else begin
   cur_cnt  <= #1 cur_cnt_d;
      end
   end
endmodule 
