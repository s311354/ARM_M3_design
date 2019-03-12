//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module trng_balancefilter (
                  rng_clk                  ,
                  rst_n                    ,
                  rnd_src_en              ,
            vnc_bypass        ,
                  cntr_balance_valid       ,
                  sync_valid        ,
                  sync_data         ,
      rst_trng_logic    ,
                  balance_filter_valid     ,
                  balance_filter_data     ,
            vn_err   
       );
`include "cc_params.inc"    
input           rng_clk                 ;
input           rst_n                   ;
input           rnd_src_en             ;
input           cntr_balance_valid      ;
input            vnc_bypass         ;
input           sync_valid           ;  
input           sync_data            ;  
input           rst_trng_logic    ;  
output          balance_filter_valid     ;  
output          balance_filter_data      ;  
output    vn_err      ;
parameter     IDLE = 3'b000          ;
parameter     S0   = 3'b010          ;
parameter     S1   = 3'b011          ;
parameter     OUT0 = 3'b100          ;
parameter     OUT1 = 3'b101          ;
reg [2:0]       curr_state             ;
reg [2:0]       next_state             ;
reg [4:0]  cnt_consecutive_identical_bits;
reg    prev_input_bit    ;
wire [2:0]   ns_from_IDLE      ;
wire [2:0]   ns_from_S0        ;
wire [2:0]   ns_from_S1        ;
wire [2:0]   ns_from_OUT0      ;
wire [2:0]   ns_from_OUT1      ;
wire           balance_filter_valid_t  ;  
wire           balance_filter_data_t   ;  
wire            balance_filter_data0   ;
wire            balance_filter_data1   ;
wire    prev_and_cur_bits_eq  ;
wire    vn_err      ;
always @ (posedge rng_clk or negedge rst_n) 
  if(!rst_n) prev_input_bit <= 1'b0;
  else if(rst_trng_logic) prev_input_bit <= #1 1'b0;
  else if(cntr_balance_valid) prev_input_bit <= #1 sync_data;
assign prev_and_cur_bits_eq = (prev_input_bit == sync_data);
always @ (posedge rng_clk or negedge rst_n) 
  if(!rst_n) cnt_consecutive_identical_bits <= 5'd0;
  else if(rst_trng_logic || vnc_bypass) cnt_consecutive_identical_bits <= #1 5'd0;
  else if(cntr_balance_valid && prev_and_cur_bits_eq) cnt_consecutive_identical_bits <= #1 cnt_consecutive_identical_bits + 1'b1;
  else if(cntr_balance_valid) cnt_consecutive_identical_bits <= #1 5'd0;
assign vn_err = rnd_src_en & (cnt_consecutive_identical_bits == 5'h1F) & (cntr_balance_valid && prev_and_cur_bits_eq);
assign     balance_filter_data0 = cntr_balance_valid && 
                           (sync_data == 1'b0) ;
assign     balance_filter_data1 = cntr_balance_valid && 
                           (sync_data == 1'b1) ;
assign     ns_from_IDLE         = balance_filter_data1 ? S1  : 
                                  balance_filter_data0 ? S0  : IDLE ; 
assign     ns_from_S0           = balance_filter_data1 ? OUT0:    
                                  balance_filter_data0 ? IDLE: S0   ;
assign     ns_from_S1           = balance_filter_data1 ? IDLE:    
                                  balance_filter_data0 ? OUT1: S1   ;
assign     ns_from_OUT0         = balance_filter_data1 ? S1  :
                                  balance_filter_data0 ? S0  : IDLE ; 
assign     ns_from_OUT1         = balance_filter_data1 ? S1  :
                                  balance_filter_data0 ? S0  : IDLE ;
always @ (curr_state or rnd_src_en or ns_from_IDLE or ns_from_S0 or ns_from_S1 or 
          ns_from_OUT0 or  ns_from_OUT1 )
begin
    next_state = curr_state                 ;
    if (!rnd_src_en) 
        next_state = IDLE                   ;
    else case (curr_state) 
        IDLE: next_state = ns_from_IDLE     ; 
        S0  : next_state = ns_from_S0       ;
        S1  : next_state = ns_from_S1       ;
        OUT0: next_state = ns_from_OUT0     ; 
        OUT1: next_state = ns_from_OUT1     ; 
        default: next_state = IDLE          ;
    endcase
end
always @ (posedge rng_clk or negedge rst_n) begin
    if (!rst_n) curr_state <= IDLE  ;
    else if(rst_trng_logic) curr_state <= #1 IDLE;
    else curr_state <= #1 next_state;
end
assign balance_filter_valid_t = (curr_state == OUT0) || (curr_state == OUT1) ;
assign balance_filter_data_t  = (curr_state == OUT1)                         ;                
assign balance_filter_valid   = (vnc_bypass) ? (sync_valid & cntr_balance_valid) : balance_filter_valid_t ;
assign balance_filter_data    = (vnc_bypass) ? sync_data                         : balance_filter_data_t  ;
`ifdef ASSERT_ON
`ifdef RNG_EXISTS
 `include "trng_asrt_3_15.sva"
`endif
`endif
endmodule
