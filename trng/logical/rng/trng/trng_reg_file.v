//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module trng_reg_file (
           rst_n        ,
           rng_clk      ,
           cpu_rng_psel      ,
           penable    ,
           cpu_rng_pwrite      ,
           cpu_rng_paddr      ,
           cpu_rng_pwdata      ,
     rng_debug_enable    ,
     autocorr_4_consecutive_errors  ,
     ehr_valid       ,
     prng_trng_ehr_rd    ,
     prng_busy        ,
     trng_valid      ,           
     trng_debug_control    ,           
     cpu_ehr_rd      ,                  
     cpu_ehr_wr      ,                      
     sample_cnt1      ,       
     vnc_bypass      ,       
     rnd_src_div      ,       
     cpu_wr_autocorr_statistic  ,   
     trng_crngt_bypass    ,       
                 auto_correlate_bypass     ,       
     rnd_src_sel        ,       
     rnd_src_en         ,       
                 rst_trng_logic      ,      
     trng_config      ,
     trng_busy      ,
     cpu_in_mid_rd_of_ehr_not_in_debug_mode,
     sop_sel                               
     );
`include "rng_params.inc"
`include "rng_addr_params.inc"
`include "cc_params.inc"    
input          rst_n        ;
input          rng_clk        ;
input          cpu_rng_psel      ;
input          penable      ;
input          cpu_rng_pwrite      ;
input  [11:0]  cpu_rng_paddr      ;
input  [31:0]  cpu_rng_pwdata      ;
input    rng_debug_enable    ;
input           autocorr_4_consecutive_errors  ;
input           ehr_valid       ;
input     prng_trng_ehr_rd    ;
input           prng_busy        ;
output   [1:0]  rnd_src_sel         ;
output     rnd_src_en      ;
output   [`SAMPLE_CNT_LOCAL_SIZE-1:0] sample_cnt1;
output     vnc_bypass      ;
output     rnd_src_div      ;
output     trng_valid      ;
output     cpu_ehr_rd      ;
output     cpu_ehr_wr      ;
output     cpu_wr_autocorr_statistic  ;
output     trng_crngt_bypass    ;
output     auto_correlate_bypass    ;
output     rst_trng_logic      ;
output  [2:0]  trng_config      ;
output  [3:0]   trng_debug_control    ;
output     trng_busy      ;
output    cpu_in_mid_rd_of_ehr_not_in_debug_mode;
output    sop_sel                         ;
`ifdef AUTOCORR_192_BITS
parameter MAX_EHR_ADDR = EHR_DATA5;
`else
parameter MAX_EHR_ADDR = EHR_DATA3;
`endif
reg  [2:0]  trng_config    ;          
reg    trng_valid    ;
reg    rnd_src_en    ;      
reg  [`SAMPLE_CNT_LOCAL_SIZE-1:0] sample_cnt1;  
reg  [3:0]  trng_debug_control  ;    
reg    rnd_src_en_s    ;
reg    cpu_in_mid_rd_of_ehr_not_in_debug_mode;
wire     cpu_finish_rd_ehr_not_in_debug_mode;
wire  [1:0]  rnd_src_sel    ;
wire    sop_sel      ;
wire    vnc_bypass    ;
wire    rnd_src_div    ;
wire    cpu_ehr_rd     ;
wire    cpu_ehr_wr    ;
wire    cpu_finish_wr_ehr  ;
wire    trng_crngt_bypass  ;
wire    auto_correlate_bypass  ;
wire    cpu_wr_autocorr_statistic;
wire    cpu_wr_sample_cnt1  ;
wire    cpu_ehr_sel      ;
wire    rnd_src_en_switched_on  ;
wire     cpu_rng_sel_and_en  ;
wire    cpu_rng_wr    ;
wire    cpu_rng_rd    ;
wire     cpu_ehr_sel_max_addr  ;
wire    rst_trng_valid    ;
wire    rst_bits_counter_and_trng_valid;
wire    rst_trng_logic    ;
assign  cpu_rng_sel_and_en= cpu_rng_psel   & penable;
assign  cpu_rng_wr      = cpu_rng_sel_and_en   & cpu_rng_pwrite;
assign  cpu_rng_rd     = cpu_rng_sel_and_en   & !cpu_rng_pwrite;
always @(posedge rng_clk or negedge rst_n)   begin
  if(!rst_n) begin
    trng_config          <=  3'd0  ;  
    sample_cnt1        <=  `SAMPLE_CNTR_RST_VAL; 
    trng_debug_control  <=  4'd0  ;   
  end
  else if(cpu_rng_wr)
         case(cpu_rng_paddr)
           TRNG_CONFIG       :trng_config[2:0]          <= #1 {1'b0,cpu_rng_pwdata[1:0]} ;  
           SAMPLE_CNT1       :sample_cnt1[`SAMPLE_CNT_LOCAL_SIZE-1:0]    <= #1 cpu_rng_pwdata[`SAMPLE_CNT_LOCAL_SIZE-1:0];   
      `ifdef TRNG_TESTS_BYPASS_EN 
           TRNG_DEBUG_CONTROL:trng_debug_control[3:0]  <= #1 {cpu_rng_pwdata[3:1], (rng_debug_enable & cpu_rng_pwdata[0])};
      `else
           TRNG_DEBUG_CONTROL:trng_debug_control[3:0]  <= #1 {4{rng_debug_enable}} & cpu_rng_pwdata[3:0];
      `endif
         endcase
end
always @(posedge rng_clk or negedge rst_n) begin
  if(!rst_n) 
    rnd_src_en  <=    1'b0;     
  else if(autocorr_4_consecutive_errors)  
    rnd_src_en  <= #1 1'b0;
  else if(cpu_rng_wr)
         case(cpu_rng_paddr)
           RND_SOURCE_ENABLE :rnd_src_en <= #1 cpu_rng_pwdata[0];     
   endcase
end
assign cpu_finish_rd_ehr_not_in_debug_mode = cpu_rng_rd & (cpu_rng_paddr == MAX_EHR_ADDR) & !rng_debug_enable & !prng_busy;
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) cpu_in_mid_rd_of_ehr_not_in_debug_mode <= 1'b0;
  else if(cpu_finish_rd_ehr_not_in_debug_mode) 
                      cpu_in_mid_rd_of_ehr_not_in_debug_mode <= #1 1'b0;
  else if(cpu_ehr_rd) cpu_in_mid_rd_of_ehr_not_in_debug_mode <= #1 1'b1;
assign rst_trng_valid = prng_trng_ehr_rd | rst_trng_logic | cpu_finish_rd_ehr_not_in_debug_mode; 
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) trng_valid <= 1'b0;
  else if(rst_trng_valid) trng_valid <= #1 1'b0;
  else if(ehr_valid | cpu_finish_wr_ehr)   trng_valid <= #1 1'b1;
assign  cpu_ehr_sel_max_addr = (cpu_rng_paddr == MAX_EHR_ADDR);
`ifdef AUTOCORR_192_BITS
assign  cpu_ehr_sel     = (cpu_rng_paddr == EHR_DATA0) | (cpu_rng_paddr == EHR_DATA1) | (cpu_rng_paddr == EHR_DATA2) | (cpu_rng_paddr == EHR_DATA3) | (cpu_rng_paddr == EHR_DATA4) | cpu_ehr_sel_max_addr;
`else
assign  cpu_ehr_sel     = (cpu_rng_paddr == EHR_DATA0) | (cpu_rng_paddr == EHR_DATA1) | (cpu_rng_paddr == EHR_DATA2) | cpu_ehr_sel_max_addr;
`endif
assign  cpu_ehr_rd       = cpu_rng_rd   & cpu_ehr_sel & trng_valid & !prng_busy & !rng_debug_enable;
assign   cpu_ehr_wr       = cpu_rng_wr   & cpu_ehr_sel & rng_debug_enable & !rnd_src_en & !trng_valid;
assign  cpu_finish_wr_ehr = cpu_ehr_sel_max_addr & cpu_ehr_wr; 
assign  cpu_wr_autocorr_statistic = cpu_rng_wr & (cpu_rng_paddr == AUTOCORR_STATISTIC);
assign  rnd_src_sel      =   trng_config[1:0];
assign  sop_sel      =   trng_config[2]  ;
assign  rnd_src_div      =   trng_debug_control[0];
assign   vnc_bypass      =   trng_debug_control[1];
assign   trng_crngt_bypass  =   trng_debug_control[2];
assign  auto_correlate_bypass= trng_debug_control[3];
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) rnd_src_en_s <= 1'b1;
  else rnd_src_en_s <= #1 rnd_src_en;
assign rnd_src_en_switched_on = rnd_src_en & !rnd_src_en_s;
assign cpu_wr_sample_cnt1 = cpu_rng_wr & (cpu_rng_paddr == SAMPLE_CNT1);
assign rst_bits_counter_and_trng_valid = !rnd_src_en & rng_debug_enable & cpu_rng_wr & (cpu_rng_paddr == RST_BITS_COUNTER);
assign rst_trng_logic = rnd_src_en_switched_on | cpu_wr_sample_cnt1 | rst_bits_counter_and_trng_valid;
assign   trng_busy = rnd_src_en & !(trng_valid || ehr_valid);
endmodule
