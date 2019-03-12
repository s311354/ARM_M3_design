//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module rng_engine ( 
    cpu_rng_paddr       ,
    cpu_rng_psel        ,
    cpu_rng_pwdata      ,
    cpu_rng_pwrite      ,
    penable             ,
    rnd_src             ,
    rng_clk             ,
    rst_n               ,
    scan_mode           ,
    rnd_src_en          ,
    rnd_src_sel         ,
    rng_cpu_prdata      ,
    rng_int             ,
    rng_sw_reset        
    );
`include "cc_params.inc" 
`include "rng_params.inc" 
input  [11:0]       cpu_rng_paddr       ;
input               cpu_rng_psel        ;
input  [31:0]       cpu_rng_pwdata      ;
input               cpu_rng_pwrite      ;
input               penable             ;
input               rnd_src             ;
input               rng_clk             ;
input               rst_n               ;
input               scan_mode           ;
output              rnd_src_en          ;
output [1:0]        rnd_src_sel         ;
output [31:0]       rng_cpu_prdata      ;
output              rng_int             ;
output              rng_sw_reset        ;
wire                rd_sop              ;
wire                rng_debug_enable    ;
wire                divided_rnd_src     ;
wire                rng_busy            ;
wire   [127:0]      sop_data            ;
wire                sop_valid           ;
rng_top  rng_top_i (
  .cpu_rng_paddr         ( cpu_rng_paddr         ),
  .cpu_rng_psel          ( cpu_rng_psel          ),
  .cpu_rng_pwdata        ( cpu_rng_pwdata        ),
  .cpu_rng_pwrite        ( cpu_rng_pwrite        ),
  .penable               ( penable               ),
  .rd_sop                ( rd_sop                ),
  .rnd_src               ( rnd_src               ),
  .rng_clk               ( rng_clk               ),
  .rng_debug_enable      ( rng_debug_enable      ),
  .rst_n                 ( rst_n                 ),
  .scan_mode             ( scan_mode             ),
  .divided_rnd_src       ( divided_rnd_src       ),
  .rnd_src_en            ( rnd_src_en            ),
  .rnd_src_sel           ( rnd_src_sel           ),
  .rng_busy              ( rng_busy              ),
  .rng_cpu_prdata        ( rng_cpu_prdata        ),
  .rng_int               ( rng_int               ),
  .rng_sw_reset          ( rng_sw_reset          ),
  .sop_data              ( sop_data              ),
  .sop_valid             ( sop_valid             )
);
rng_top_wrap_unconnected  rng_top_wrap_unconnected_i (
  .sop_data              ( sop_data              ),
  .sop_valid             ( sop_valid             ),
  .divided_rnd_src       ( divided_rnd_src       ),
  .rng_busy              ( rng_busy              ),
  .rd_sop                ( rd_sop                ),
  .rng_debug_enable      ( rng_debug_enable      )
);
endmodule
