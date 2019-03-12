//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module rng_top ( 
    rst_n               ,
    rng_clk             ,
    cpu_rng_psel        ,
    penable             ,
    cpu_rng_pwrite      ,
    cpu_rng_paddr       ,
    cpu_rng_pwdata      ,
    rng_debug_enable    ,
    rnd_src_en          ,
    rd_sop              ,
    scan_mode           ,
    rng_cpu_prdata      ,
    rng_int             ,
    rng_busy            ,
    rng_sw_reset        ,
    sop_data            ,
    sop_valid           ,
    rnd_src             ,
    divided_rnd_src     ,
    rnd_src_sel         
    );
`include "cc_params.inc" 
`include "rng_params.inc" 
`ifdef ASSERT_ON
`include "trng_asrt_2_1.sva" 
`include "trng_asrt_2_3.sva" 
`endif
input  [11:0]       cpu_rng_paddr       ;
input               cpu_rng_psel        ;
input  [31:0]       cpu_rng_pwdata      ;
input               cpu_rng_pwrite      ;
input               penable             ;
input               rd_sop              ;
input               rnd_src             ;
input               rng_clk             ;
input               rng_debug_enable    ;
input               rst_n               ;
input               scan_mode           ;
output              divided_rnd_src     ;
output              rnd_src_en          ;
output [1:0]        rnd_src_sel         ;
output              rng_busy            ;
output [31:0]       rng_cpu_prdata      ;
output              rng_int             ;
output              rng_sw_reset        ;
output [127:0]      sop_data            ;
output              sop_valid           ;
wire                ehr_valid           ;
wire   [2:0]        trng_config         ;
wire                trng_valid          ;
wire   [`SAMPLE_CNT_LOCAL_SIZE-1:0] sample_cnt1         ;
wire   [3:0]        trng_debug_control  ;
wire   [`EHR_WIDTH-1:0] ehr_data            ;
wire                autocorr_4_consecutive_errors;
wire   [13:0]       autocorr_trys_cnt   ;
wire   [7:0]        autocorr_fails_cnt  ;
wire                trng_busy           ;
wire                crngt_err           ;
wire                vn_err              ;
wire                sop_sel             ;
wire                prng_debug_control  ;
wire   [2:0]        prng_control        ;
wire   [127:0]      rng_readout         ;
wire   [255:0]      additional_input_entropy;
wire                rng_readout_valid   ;
wire   [11:0]       req_size_cntr       ;
wire   [47:0]       reseed_cntr         ;
wire   [127:0]      v_reg               ;
wire   [127:0]      k_reg               ;
wire                real_instantiation_done;
wire                reseed_cntr_overflow_1p;
wire                reseed_cntr_top_40_1p;
wire                req_size_overflow_1p;
wire                prng_crngt_err      ;
wire                reseed_done_1p      ;
wire                final_update_done_1p;
wire                kat_err             ;
wire   [1:0]        which_kat_err       ;
wire                prng_busy           ;
wire                prng_trng_ehr_rd    ;
wire   [`EHR_WIDTH-1:0] trng_prng_ehr_data  ;
wire                trng_prng_ehr_valid ;
wire   [21:0]    rosc_cntr_val0;
wire   [21:0]    rosc_cntr_val1;
wire   [21:0]    rosc_cntr_val2;
rng_misc  rng_misc_i (
  .rst_n                 ( rst_n                 ),
  .rng_clk               ( rng_clk               ),
  .cpu_rng_psel          ( cpu_rng_psel          ),
  .penable               ( penable               ),
  .cpu_rng_pwrite        ( cpu_rng_pwrite        ),
  .cpu_rng_paddr         ( cpu_rng_paddr         ),
  .cpu_rng_pwdata        ( cpu_rng_pwdata        ),
  .rng_debug_enable      ( rng_debug_enable      ),
  .ehr_valid             ( ehr_valid             ),
  .trng_config           ( trng_config           ),
  .trng_valid            ( trng_valid            ),
  .rnd_src_en            ( rnd_src_en            ),
  .sample_cnt1           ( sample_cnt1           ),
  .trng_debug_control    ( trng_debug_control    ),
  .ehr_data              ( ehr_data              ),
  .autocorr_4_consecutive_errors ( autocorr_4_consecutive_errors ),
  .autocorr_trys_cnt     ( autocorr_trys_cnt     ),
  .autocorr_fails_cnt    ( autocorr_fails_cnt    ),
  .trng_busy             ( trng_busy             ),
  .crngt_err             ( crngt_err             ),
  .vn_err                ( vn_err                ),
  .sop_sel               ( sop_sel               ),
  .prng_debug_control    ( prng_debug_control    ),
  .prng_control          ( prng_control          ),
  .rng_readout           ( rng_readout           ),
  .additional_input_entropy ( additional_input_entropy ),
  .rng_readout_valid     ( rng_readout_valid     ),
  .req_size_cntr         ( req_size_cntr         ),
  .reseed_cntr           ( reseed_cntr           ),
  .v_reg                 ( v_reg                 ),
  .k_reg                 ( k_reg                 ),
  .real_instantiation_done ( real_instantiation_done ),
  .reseed_cntr_overflow_1p ( reseed_cntr_overflow_1p ),
  .reseed_cntr_top_40_1p ( reseed_cntr_top_40_1p ),
  .req_size_overflow_1p  ( req_size_overflow_1p  ),
  .prng_crngt_err        ( prng_crngt_err        ),
  .reseed_done_1p        ( reseed_done_1p        ),
  .final_update_done_1p  ( final_update_done_1p  ),
  .kat_err               ( kat_err               ),
  .which_kat_err         ( which_kat_err         ),
  .prng_busy             ( prng_busy             ),
  .rng_cpu_prdata        ( rng_cpu_prdata        ),
  .rng_int               ( rng_int               ),
  .rng_busy              ( rng_busy              ),
  .rng_sw_reset          ( rng_sw_reset          ),
  .sop_data              ( sop_data              ),
    .rosc_cntr_val0        (rosc_cntr_val0),
  .rosc_cntr_val1        (rosc_cntr_val1),
  .rosc_cntr_val2        (rosc_cntr_val2),
  .sop_valid             ( sop_valid             )
);
trng_top  trng_top_i (
  .cpu_rng_paddr         ( cpu_rng_paddr         ),
  .cpu_rng_psel          ( cpu_rng_psel          ),
  .cpu_rng_pwdata        ( cpu_rng_pwdata        ),
  .cpu_rng_pwrite        ( cpu_rng_pwrite        ),
  .penable               ( penable               ),
  .prng_busy             ( prng_busy             ),
  .prng_trng_ehr_rd      ( prng_trng_ehr_rd      ),
  .rd_sop                ( rd_sop                ),
  .rnd_src               ( rnd_src               ),
  .rng_clk               ( rng_clk               ),
  .rng_debug_enable      ( rng_debug_enable      ),
  .rst_n                 ( rst_n                 ),
  .scan_mode             ( scan_mode             ),
  .autocorr_4_consecutive_errors ( autocorr_4_consecutive_errors ),
  .autocorr_fails_cnt    ( autocorr_fails_cnt    ),
  .autocorr_trys_cnt     ( autocorr_trys_cnt     ),
  .crngt_err             ( crngt_err             ),
  .divided_rnd_src       ( divided_rnd_src       ),
  .ehr_data              ( ehr_data              ),
  .ehr_valid             ( ehr_valid             ),
  .rnd_src_en            ( rnd_src_en            ),
  .rnd_src_sel           ( rnd_src_sel           ),
  .sample_cnt1           ( sample_cnt1           ),
  .sop_sel               ( sop_sel               ),
  .trng_busy             ( trng_busy             ),
  .trng_config           ( trng_config           ),
  .trng_debug_control    ( trng_debug_control    ),
  .trng_prng_ehr_data    ( trng_prng_ehr_data    ),
  .trng_prng_ehr_valid   ( trng_prng_ehr_valid   ),
  .trng_valid            ( trng_valid            ),
    .rosc_cntr_val0    (rosc_cntr_val0),
  .rosc_cntr_val1    (rosc_cntr_val1),
  .rosc_cntr_val2    (rosc_cntr_val2),
  .vn_err                ( vn_err                )
);
prng_top_wrap  prng_top_wrap_i (
  .cpu_rng_paddr         ( cpu_rng_paddr         ),
  .penable               ( penable               ),
  .cpu_rng_psel          ( cpu_rng_psel          ),
  .cpu_rng_pwdata        ( cpu_rng_pwdata        ),
  .cpu_rng_pwrite        ( cpu_rng_pwrite        ),
  .rng_clk               ( rng_clk               ),
  .rd_sop                ( rd_sop                ),
  .sop_sel               ( sop_sel               ),
  .scan_mode             ( scan_mode             ),
  .rst_n                 ( rst_n                 ),
  .trng_prng_ehr_data    ( trng_prng_ehr_data    ),
  .trng_prng_ehr_valid   ( trng_prng_ehr_valid   ),
  .rng_debug_enable      ( rng_debug_enable      ),
  .prng_crngt_err        ( prng_crngt_err        ),
  .reseed_done_1p        ( reseed_done_1p        ),
  .final_update_done_1p  ( final_update_done_1p  ),
  .additional_input_entropy ( additional_input_entropy ),
  .real_instantiation_done ( real_instantiation_done ),
  .k_reg                 ( k_reg                 ),
  .kat_err               ( kat_err               ),
  .which_kat_err         ( which_kat_err         ),
  .prng_busy             ( prng_busy             ),
  .prng_control          ( prng_control          ),
  .prng_debug_control    ( prng_debug_control    ),
  .req_size_cntr         ( req_size_cntr         ),
  .req_size_overflow_1p  ( req_size_overflow_1p  ),
  .reseed_cntr           ( reseed_cntr           ),
  .reseed_cntr_overflow_1p ( reseed_cntr_overflow_1p ),
  .reseed_cntr_top_40_1p ( reseed_cntr_top_40_1p ),
  .rng_readout           ( rng_readout           ),
  .rng_readout_valid     ( rng_readout_valid     ),
  .v_reg                 ( v_reg                 ),
  .prng_trng_ehr_rd      ( prng_trng_ehr_rd      )
);
endmodule
