//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module trng_sync (
                  rng_clk         ,
                  rst_n           ,
                  rnd_src         ,
                  rnd_src_en      ,
      rnd_src_div     ,
      scan_mode       ,
                  rng_debug_enable,
                  sync_valid      ,
                  sync_data       ,
      rosc_cntr_val0  ,
      rosc_cntr_val1  ,
      rosc_cntr_val2  ,
      divided_rnd_src 
);
`include "cc_params.inc" 
input            rng_clk            ;
input            rst_n              ; 
input            rnd_src            ;  
input            rnd_src_en         ;  
input            rnd_src_div        ;   
input            scan_mode          ;
input            rng_debug_enable   ;
output           sync_valid         ;  
output           sync_data          ;  
output           divided_rnd_src    ;  
output [21:0]    rosc_cntr_val0;
output [21:0]    rosc_cntr_val1;
output [21:0]    rosc_cntr_val2;
reg             sync_stage1        ;
reg             sync_stage2        ;
reg             sync_stage3        ;
reg      [13:0] rnd_cntr           ;
reg      [1:0]  sync_counter       ;   
wire     [1:0]  sync_counter_d     ;   
wire            rnd_src_clk        ;
wire            muxed_in_2_sync    ;
reg [21:0]   rosc_cntr_val0;
reg [21:0]   rosc_cntr_val1;
reg [21:0]   rosc_cntr_val2;
`ifdef RNG_BIST_EXISTS
wire     rnd_src_div_2_clk;
wire     rnd_src_div_4_clk;
wire     rnd_src_div_8_clk;
wire     bist_b4_rose_sync;
wire     bist_b16_rose_sync;
wire     bist_b17_rose_sync;
wire     bist_b4_rose_der; 
wire     bist_b16_rose_der;
wire     bist_b17_rose_der;
reg     rnd_src_div_2;
reg     rnd_src_div_4;
reg     rnd_src_div_8;
reg [21:0]   rosc_cntr;
reg [17:0]   bist_cntr;
reg     bist_b4_rose; 
reg     bist_b16_rose;
reg     bist_b17_rose;
reg     bist_b4_rose_sync_s; 
reg     bist_b16_rose_sync_s;
reg     bist_b17_rose_sync_s;
dxm_mux_clk bist_rnd_src_mux_i (.in_low(rnd_src), .in_high(rng_clk), .control(scan_mode), .out(rnd_src_clk));
always @ (posedge rnd_src_clk or negedge rst_n)
   if (!rst_n) rnd_src_div_2 <= 1'b0;
   else  rnd_src_div_2 <=#1 !rnd_src_div_2;
dxm_mux_clk bist_rnd_src_div_2_mux_i (.in_low(rnd_src_div_2), .in_high(rng_clk), .control(scan_mode), .out(rnd_src_div_2_clk));
always @ (posedge rnd_src_div_2_clk or negedge rst_n)
   if (!rst_n) rnd_src_div_4 <= 1'b0;
   else  rnd_src_div_4 <=#1 !rnd_src_div_4;
dxm_mux_clk bist_rnd_src_div_4_mux_i (.in_low(rnd_src_div_4), .in_high(rng_clk), .control(scan_mode), .out(rnd_src_div_4_clk));
always @ (posedge rnd_src_div_4_clk or negedge rst_n)
   if (!rst_n) rnd_src_div_8 <= 1'b0;
   else  rnd_src_div_8 <=#1 !rnd_src_div_8;
dxm_mux_clk bist_rnd_src_div_8_mux_i (.in_low(rnd_src_div_8), .in_high(rng_clk), .control(scan_mode), .out(rnd_src_div_8_clk));
always @ (posedge rnd_src_div_8_clk or negedge rst_n)
   if (!rst_n) rosc_cntr <= {22{1'b0}};
   else rosc_cntr <=#1 rosc_cntr + 1'b1;
always @ (posedge rng_clk or negedge rst_n)
   if (!rst_n) bist_cntr <= {18{1'b0}};
   else bist_cntr <=#1 bist_cntr + 1'b1;
always @ (posedge rng_clk or negedge rst_n)
   if (!rst_n) begin
     bist_b4_rose   <= 1'b0;
     bist_b16_rose   <= 1'b0;
     bist_b17_rose   <= 1'b0;
         end
   else begin
     bist_b4_rose   <= bist_cntr[4] || bist_b4_rose;
     bist_b16_rose   <= bist_cntr[16]|| bist_b16_rose;
     bist_b17_rose   <= bist_cntr[17]|| bist_b17_rose;
        end
dxm_sync i_dxm_sync_bist_b4  (.clk(rnd_src_div_8_clk),.rst_n(rst_n),.in(bist_b4_rose) ,.out(bist_b4_rose_sync));
dxm_sync i_dxm_sync_bist_b16 (.clk(rnd_src_div_8_clk),.rst_n(rst_n),.in(bist_b16_rose),.out(bist_b16_rose_sync));
dxm_sync i_dxm_sync_bist_b17 (.clk(rnd_src_div_8_clk),.rst_n(rst_n),.in(bist_b17_rose),.out(bist_b17_rose_sync));
always @ (posedge rnd_src_div_8_clk or negedge rst_n)
   if (!rst_n) begin
  bist_b4_rose_sync_s  <= 1'b0;
  bist_b16_rose_sync_s <= 1'b0;
  bist_b17_rose_sync_s <= 1'b0;  
         end
   else begin
  bist_b4_rose_sync_s  <=#1 bist_b4_rose_sync;     
  bist_b16_rose_sync_s <=#1 bist_b16_rose_sync;
  bist_b17_rose_sync_s <=#1 bist_b17_rose_sync;
        end
assign bist_b4_rose_der  = bist_b4_rose_sync  && ! bist_b4_rose_sync_s;
assign bist_b16_rose_der = bist_b16_rose_sync && ! bist_b16_rose_sync_s;
assign bist_b17_rose_der = bist_b17_rose_sync && ! bist_b17_rose_sync_s;
always @ (posedge rnd_src_div_8_clk or negedge rst_n)
   if (!rst_n) begin
  rosc_cntr_val0 <= {22{1'b0}};
  rosc_cntr_val1 <= {22{1'b0}};
  rosc_cntr_val2 <= {22{1'b0}};
               end
   else if (bist_b4_rose_der)  rosc_cntr_val0 <=#1 rosc_cntr;
   else if (bist_b16_rose_der) rosc_cntr_val1 <=#1 rosc_cntr;
   else if (bist_b17_rose_der) rosc_cntr_val2 <=#1 rosc_cntr;
`else
always @ *
begin
  rosc_cntr_val0 = {22{1'b0}};
  rosc_cntr_val1 = {22{1'b0}};
  rosc_cntr_val2 = {22{1'b0}};
end
dxm_mux rnd_src_mux_i (.in_low(rnd_src), .in_high(rng_clk), .control(scan_mode), .out(rnd_src_clk));
`endif 
always @ (posedge rnd_src_clk or negedge rst_n)
   if (!rst_n) rnd_cntr <= {14{1'b0}};
   else if (~rnd_src_en) rnd_cntr <=#1 {14{1'b0}};
   else rnd_cntr <=#1 rnd_cntr + 1'b1;
assign divided_rnd_src = rnd_cntr[13] & rng_debug_enable;
assign muxed_in_2_sync = (rnd_src_div || scan_mode) ? divided_rnd_src : rnd_src;
assign         sync_counter_d  = (!rnd_src_en          )? 2'd0          : 
                                 ( sync_counter == 2'd3 )? sync_counter  : sync_counter + 2'b1 ;
always @ (posedge rng_clk or negedge rst_n)
begin
    if (!rst_n) begin
        sync_stage1   <=    1'b0               ;
        sync_stage2   <=    1'b0               ;
        sync_stage3   <=    1'b0               ;
        sync_counter  <=    2'b0               ;
    end
    else begin  
        sync_stage1   <=    muxed_in_2_sync    ;
        sync_stage2   <=    sync_stage1        ;
        sync_stage3   <=    sync_stage2        ;
        sync_counter  <=    sync_counter_d     ;
    end
end
assign          sync_valid = (sync_counter == 2'd3) ;
assign          sync_data  =  sync_stage3           ;
`ifdef ASSERT_ON
  `ifdef SEP_EXISTS
     `include "trng_asrt_2_4.sva"
  `endif
`endif
endmodule
