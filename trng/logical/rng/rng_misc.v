//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module rng_misc (
        rst_n            ,
        rng_clk              ,
        cpu_rng_psel      ,
        penable                ,
        cpu_rng_pwrite      ,
        cpu_rng_paddr      ,
        cpu_rng_pwdata      ,
        rng_debug_enable    ,
        rng_sw_reset      ,
        ehr_valid          ,
        trng_config          ,
        trng_valid          ,           
        rnd_src_en          ,           
        sample_cnt1          ,           
        trng_debug_control    ,           
        ehr_data          ,
        autocorr_4_consecutive_errors  ,
        autocorr_trys_cnt    ,
        autocorr_fails_cnt    ,
        trng_busy          ,
        crngt_err          ,
        vn_err            ,
        sop_sel                 ,
        prng_debug_control    ,
        prng_control      ,
        rng_readout          ,
        additional_input_entropy,
        rng_readout_valid    ,
        req_size_cntr      ,
        reseed_cntr          ,
        v_reg            ,
        k_reg            ,
        real_instantiation_done  ,
        reseed_cntr_overflow_1p  ,
        reseed_cntr_top_40_1p  ,
        req_size_overflow_1p  ,
        prng_crngt_err      ,
        reseed_done_1p      ,
        final_update_done_1p  ,
        kat_err              ,
        which_kat_err      ,
        prng_busy          ,
  rosc_cntr_val0  ,
  rosc_cntr_val1  ,
  rosc_cntr_val2  ,
        rng_int              ,
        rng_busy          ,
        rng_cpu_prdata        ,
        sop_data                ,
        sop_valid                      
        );
`include "cc_params.inc" 
`include "rng_addr_params.inc"
`include "rng_params.inc"
input           rst_n        ;
input           rng_clk        ;
input           cpu_rng_psel    ;
input           penable          ;
input           cpu_rng_pwrite    ;
input   [11:0]  cpu_rng_paddr    ;
input   [31:0]  cpu_rng_pwdata    ;
input         rng_debug_enable  ;  
input         ehr_valid      ;
input  [2:0]  trng_config      ;
input         trng_valid      ;
input         rnd_src_en      ;
input   [`SAMPLE_CNT_LOCAL_SIZE-1:0] sample_cnt1;
input   [3:0]  trng_debug_control  ;
input   [`EHR_WIDTH-1:0] ehr_data  ;
input         autocorr_4_consecutive_errors;
input   [13:0]  autocorr_trys_cnt  ;
input   [7:0]  autocorr_fails_cnt  ;
input        trng_busy      ;
input        crngt_err      ;
input        vn_err        ;
input        sop_sel          ;
input         prng_debug_control  ;
input   [2:0]  prng_control    ;
input  [127:0]  rng_readout      ;
input  [255:0]  additional_input_entropy;
input         rng_readout_valid  ;
input   [11:0]  req_size_cntr    ;
input   [47:0]  reseed_cntr      ;
input   [127:0]  v_reg        ;
input   [127:0]  k_reg        ;
input         real_instantiation_done;
input         reseed_cntr_overflow_1p;
input         reseed_cntr_top_40_1p;
input         req_size_overflow_1p;
input         prng_crngt_err    ;
input            reseed_done_1p    ;
input            final_update_done_1p;
input         kat_err        ;
input   [1:0]  which_kat_err    ;
input         prng_busy      ;
input  [21:0]    rosc_cntr_val0;
input  [21:0]    rosc_cntr_val1;
input  [21:0]    rosc_cntr_val2;
output   [31:0]  rng_cpu_prdata    ;
output         rng_int        ;
output        rng_busy      ;
output         rng_sw_reset    ;
output   [127:0]  sop_data      ;
output         sop_valid      ;
parameter  TRNG_INT_NUM = 4      ;
parameter  PRNG_INT_NUM = 11      ;
reg      [31:0]  rng_cpu_prdata    ;
reg            rng_sw_reset    ;
reg      [TRNG_INT_NUM-1:0] trng_imr  ;
`ifdef PRNG_EXISTS
reg            rng_readout_valid_s  ;
reg [PRNG_INT_NUM-1:0] prng_imr      ;
`else
wire [PRNG_INT_NUM-1:0] prng_imr    ;
`endif
wire         rng_busy        ;
wire        cpu_rng_wr        ;
wire        rng_int          ;
wire        cpu_rng_sel_and_en  ;
wire  [TRNG_INT_NUM-1:0] trng_isr  ;
wire        trng_int_req    ;
wire        trng_ic_1p        ;
wire  [TRNG_INT_NUM-1:0] trng_int_events;
wire    [PRNG_INT_NUM-1:0] prng_isr  ;
wire    [PRNG_INT_NUM-1:0] prng_int_events;
`ifdef PRNG_EXISTS
wire        rng_readout_valid_1p;
wire            prng_ic_1p          ;
`endif
wire        prng_int_req    ;
wire   [31:0]   prng_trng_isr    ;
wire         trng_prng_icr_addr  ;
wire   [127:0]  sop_data        ;
wire         sop_valid        ;
parameter RNG_FLAGS_NUM = 8;
wire [RNG_FLAGS_NUM-1:0] rng_flags;
`ifdef AUTOCORR_192_BITS
    parameter p_EHR_WIDTH_192 = 1'b1;
`else
    parameter p_EHR_WIDTH_192 = 1'b0;
`endif
`ifdef CRNGT_EXISTS
  parameter p_CRNGT_EXISTS = 1'b1;
`else
  parameter p_CRNGT_EXISTS = 1'b0;
`endif
`ifdef AUTOCORR_EXISTS
  parameter p_AUTOCORR_EXISTS = 1'b1;
`else
  parameter p_AUTOCORR_EXISTS = 1'b0;
`endif
`ifdef TRNG_TESTS_BYPASS_EN
    parameter p_TRNG_TESTS_BYPASS_EN = 1'b1;
`else
    parameter p_TRNG_TESTS_BYPASS_EN = 1'b0;
`endif
`ifdef PRNG_EXISTS
    parameter p_PRNG_EXISTS = 1'b1;
`else
    parameter p_PRNG_EXISTS = 1'b0;
`endif
`ifdef KAT_EXISTS
    parameter p_KAT_EXISTS = 1'b1;
`else
    parameter p_KAT_EXISTS = 1'b0;
`endif
`ifdef RESEEDING_EXISTS
  parameter p_RESEEDING_EXISTS = 1'b1;
`else
  parameter p_RESEEDING_EXISTS = 1'b0;
`endif
`ifdef RNG_USE_5_SBOXES
    parameter p_RNG_USE_5_SBOXES = 1'b1;
`else
    parameter p_RNG_USE_5_SBOXES = 1'b0;
`endif
assign rng_flags = {p_RNG_USE_5_SBOXES    , p_RESEEDING_EXISTS, p_KAT_EXISTS  , p_PRNG_EXISTS  , 
                    p_TRNG_TESTS_BYPASS_EN, p_AUTOCORR_EXISTS , p_CRNGT_EXISTS, p_EHR_WIDTH_192};
`ifdef RNG_MUXED_SOP              
  assign sop_data[127:0] = sop_sel ? (ehr_data[127:0] & {128{trng_valid}}) : (rng_readout[127:0] & {128{rng_readout_valid }}); 
`else
  assign sop_data = sop_sel ? ehr_data[127:0] : rng_readout[127:0];
`endif
assign sop_valid = sop_sel ? trng_valid      : rng_readout_valid ;
assign  rng_busy = trng_busy | prng_busy;
assign  cpu_rng_sel_and_en= cpu_rng_psel   & penable;
assign  cpu_rng_wr      = cpu_rng_sel_and_en   & cpu_rng_pwrite;
assign prng_trng_isr = {{16-PRNG_INT_NUM{1'b0}}, prng_isr[PRNG_INT_NUM-1:0], {16-TRNG_INT_NUM{1'b0}}, trng_isr[TRNG_INT_NUM-1:0]};
always @(*) begin
  rng_cpu_prdata[31:0] = 32'd0;
  if(cpu_rng_psel)
    case(cpu_rng_paddr)
      RNG_IMR              :rng_cpu_prdata[31:0] = {{16-PRNG_INT_NUM{1'b0}}, 1'b0, 1'b0, prng_imr[PRNG_INT_NUM-3:0], {16-TRNG_INT_NUM{1'b0}}, trng_imr[TRNG_INT_NUM-1:0]};   
      RNG_ISR                   :rng_cpu_prdata[31:0] =  prng_trng_isr                                    ;  
      TRNG_CONFIG           :rng_cpu_prdata[31:0] = {29'b0,trng_config[2:0]}                            ;  
      TRNG_VALID            :rng_cpu_prdata[31:0] = {31'b0,trng_valid}                                  ;  
      EHR_DATA0               :rng_cpu_prdata[31:0] = (trng_valid && ( !prng_busy)) ? ehr_data[31:0]   : 32'h0;
      EHR_DATA1               :rng_cpu_prdata[31:0] = (trng_valid && ( !prng_busy)) ? ehr_data[63:32]  : 32'h0;
      EHR_DATA2               :rng_cpu_prdata[31:0] = (trng_valid && ( !prng_busy)) ? ehr_data[95:64]  : 32'h0;
      EHR_DATA3               :rng_cpu_prdata[31:0] = (trng_valid && ( !prng_busy)) ? ehr_data[127:96] : 32'h0;
`ifdef AUTOCORR_192_BITS
      EHR_DATA4               :rng_cpu_prdata[31:0] = (trng_valid && ( !prng_busy)) ? ehr_data[159:128]: 32'h0;
      EHR_DATA5               :rng_cpu_prdata[31:0] = (trng_valid && ( !prng_busy)) ? ehr_data[191:160]: 32'h0;
`endif
      RND_SOURCE_ENABLE          :rng_cpu_prdata[31:0] = {31'b0,rnd_src_en}                                  ;     
      SAMPLE_CNT1              :rng_cpu_prdata[31:0] = sample_cnt1[`SAMPLE_CNT_LOCAL_SIZE-1:0]                        ;   
      AUTOCORR_STATISTIC      :rng_cpu_prdata[31:0] = {10'b0,autocorr_fails_cnt[7:0],autocorr_trys_cnt[13:0]}          ;     
      TRNG_DEBUG_CONTROL      :rng_cpu_prdata[31:0] = {28'b0,trng_debug_control[3:0]}                                 ;   
`ifdef PRNG_EXISTS
      PRNG_CONTROL           :rng_cpu_prdata[31:0] = {29'b0,prng_control[2:0]}                            ;   
      RNG_READOUT0           :rng_cpu_prdata[31:0] = rng_readout_valid  ? rng_readout[31:0]   :32'd0           ;
      RNG_READOUT1           :rng_cpu_prdata[31:0] = rng_readout_valid  ? rng_readout[63:32]  :32'd0           ;
      RNG_READOUT2           :rng_cpu_prdata[31:0] = rng_readout_valid  ? rng_readout[95:64]  :32'd0           ;
      RNG_READOUT3           :rng_cpu_prdata[31:0] = rng_readout_valid  ? rng_readout[127:96] :32'd0           ;
      ADDITIONAL_INPUT_ENTROPY0  :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & additional_input_entropy[31:0]        ;   
      ADDITIONAL_INPUT_ENTROPY1  :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & additional_input_entropy[63:32]       ;   
      ADDITIONAL_INPUT_ENTROPY2  :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & additional_input_entropy[95:64]       ;   
      ADDITIONAL_INPUT_ENTROPY3  :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & additional_input_entropy[127:96]      ;   
      ADDITIONAL_INPUT_ENTROPY4  :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & additional_input_entropy[159:128]     ;   
      ADDITIONAL_INPUT_ENTROPY5  :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & additional_input_entropy[191:160]     ;   
      ADDITIONAL_INPUT_ENTROPY6  :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & additional_input_entropy[223:192]     ;   
      ADDITIONAL_INPUT_ENTROPY7  :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & additional_input_entropy[255:224]     ;   
`ifdef CRNGT_EXISTS
      PRNG_DEBUG_CONTROL      :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & {31'b0,prng_debug_control}            ;
`endif
      V_REGISTER0          :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & v_reg[31:0]                    ;
      V_REGISTER1          :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & v_reg[63:32]                   ;
      V_REGISTER2          :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & v_reg[95:64]                   ;
      V_REGISTER3          :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & v_reg[127:96]                  ;
      K_REGISTER0          :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & k_reg[31:0]                    ;
      K_REGISTER1          :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & k_reg[63:32]                   ;
      K_REGISTER2          :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & k_reg[95:64]                   ;
      K_REGISTER3          :rng_cpu_prdata[31:0] = {32{rng_debug_enable}} & k_reg[127:96]                  ;
      REQ_SIZE_CNTR0            :rng_cpu_prdata[31:0] = {20'b0,req_size_cntr[11:0]}                            ;
`ifdef RESEEDING_EXISTS
      RESEED_CNTR0              :rng_cpu_prdata[31:0] = reseed_cntr[31:0]                                  ;
      RESEED_CNTR1              :rng_cpu_prdata[31:0] = {16'b0,reseed_cntr[47:32]}                            ;
`endif
      PRNG_VALID                :rng_cpu_prdata[31:0] = {31'b0,rng_readout_valid}                            ;
`endif
      RNG_DEBUG_EN_INPUT        :rng_cpu_prdata[31:0] = {31'b0,rng_debug_enable}                            ;
      RNG_BUSY                  :rng_cpu_prdata[31:0] = {29'b0,prng_busy, trng_busy, rng_busy}                  ;
      RNG_VERSION               :rng_cpu_prdata[31:0] = {{(32-RNG_FLAGS_NUM){1'b0}},rng_flags[RNG_FLAGS_NUM-1:0]}       ;
`ifdef RNG_BIST_EXISTS
      RNG_BIST_CNTR0            :rng_cpu_prdata[31:0] = {10'b0,rosc_cntr_val0}; 
      RNG_BIST_CNTR1            :rng_cpu_prdata[31:0] = {10'b0,rosc_cntr_val1}; 
      RNG_BIST_CNTR2            :rng_cpu_prdata[31:0] = {10'b0,rosc_cntr_val2}; 
`endif 
      default               :rng_cpu_prdata[31:0] = 32'd0                                    ;   
    endcase
end
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) rng_sw_reset <= 1'b0;
  else if(cpu_rng_wr && (cpu_rng_paddr == TRNG_SW_RESET)) rng_sw_reset <= #1 1'b1;
always @(posedge rng_clk or negedge rst_n)   begin
  if(!rst_n) begin
    trng_imr      <= {TRNG_INT_NUM{1'b1}};
 `ifdef PRNG_EXISTS
    prng_imr      <= {PRNG_INT_NUM{1'b1}};
 `endif
  end
  else begin
    if(cpu_rng_wr)
      case(cpu_rng_paddr)
      RNG_IMR : begin
               trng_imr[TRNG_INT_NUM-1:0]  <= #1 cpu_rng_pwdata[TRNG_INT_NUM-1:0];
            `ifdef PRNG_EXISTS
               prng_imr[PRNG_INT_NUM-1:0]  <= #1 {1'b1, 1'b1, cpu_rng_pwdata[16+PRNG_INT_NUM-3:16]};
        `endif
                 end
      endcase
  end
end
`ifndef PRNG_EXISTS
assign prng_imr = {PRNG_INT_NUM{1'b0}};
`endif
assign trng_prng_icr_addr = (cpu_rng_paddr == RNG_ICR);
assign trng_int_events   = {vn_err, crngt_err, autocorr_4_consecutive_errors, ehr_valid};
assign trng_ic_1p   = cpu_rng_wr & trng_prng_icr_addr;
dxm_interrupt_low #(TRNG_INT_NUM) i_trng_interrupt_controller0(
                  .rst_n(rst_n),
                  .clk(rng_clk),
                  .r_din({cpu_rng_pwdata[TRNG_INT_NUM-1:2], 1'b0, cpu_rng_pwdata[0]}), 
                  .clr_status_1p(trng_ic_1p),
                  .events_1p(trng_int_events[TRNG_INT_NUM-1:0]),
                  .mask(trng_imr[TRNG_INT_NUM-1:0]),
                  .status(trng_isr[TRNG_INT_NUM-1:0]),
                  .int_req(trng_int_req)
                  );
`ifdef PRNG_EXISTS
always @ (posedge rng_clk or negedge rst_n) 
  if(!rst_n) rng_readout_valid_s <= 1'b0;
  else rng_readout_valid_s <= #1 rng_readout_valid;
assign rng_readout_valid_1p = rng_readout_valid & !rng_readout_valid_s;
assign prng_int_events   = {
    `ifdef KAT_EXISTS
              which_kat_err[1], which_kat_err[0], kat_err, req_size_overflow_1p, prng_crngt_err, 
    `else 
              1'b0            , 1'b0          , 1'b0   , req_size_overflow_1p, prng_crngt_err, 
  `endif
    `ifdef RESEEDING_EXISTS
              reseed_cntr_top_40_1p, reseed_cntr_overflow_1p, 
    `else 
              1'b0                 , 1'b0                   , 
  `endif
         rng_readout_valid_1p, final_update_done_1p, real_instantiation_done,
         reseed_done_1p
        };
assign prng_ic_1p   = cpu_rng_wr & trng_prng_icr_addr;
dxm_interrupt_low #(PRNG_INT_NUM) i_prng_interrupt_controller0(
                  .rst_n(rst_n),
                  .clk(rng_clk),
                  .r_din({1'b0, 1'b0, 1'b0, cpu_rng_pwdata[16+PRNG_INT_NUM-4:16]}),
                  .clr_status_1p(prng_ic_1p),
                  .events_1p(prng_int_events[PRNG_INT_NUM-1:0]),
                  .mask(prng_imr[PRNG_INT_NUM-1:0]),
                  .status(prng_isr[PRNG_INT_NUM-1:0]),
                  .int_req(prng_int_req)
                  );
`else
assign prng_int_req  = 1'b0;
assign prng_isr[PRNG_INT_NUM-1:0] = {PRNG_INT_NUM{1'd0}};
`endif
assign  rng_int  = trng_int_req | prng_int_req;
`ifdef ASSERT_ON
`ifdef RNG_EXISTS
  `include "trng_asrt_3_0_2.sva"
  `include "trng_asrt_3_1_1.sva"
 `ifdef PRNG_EXISTS
    `include "trng_asrt_3_10.sva"
    `include "prng_asrt_4_4.sva"
    `include "prng_asrt_4_21.sva"
 `endif
`endif
`endif
endmodule
