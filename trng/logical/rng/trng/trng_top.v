//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module trng_top ( 
    rng_clk             ,
    rst_n               ,
    rnd_src_en          ,
    rng_debug_enable    ,
    sample_cnt1         ,
    trng_valid          ,
    cpu_rng_pwdata      ,
    cpu_rng_paddr       ,
    ehr_valid           ,
    autocorr_4_consecutive_errors,
    prng_trng_ehr_rd    ,
    sop_sel             ,
    rnd_src             ,
    scan_mode           ,
    divided_rnd_src     ,
    vn_err              ,
    crngt_err           ,
    ehr_data            ,
    trng_prng_ehr_data  ,
    autocorr_trys_cnt   ,
    autocorr_fails_cnt  ,
    rd_sop              ,
    trng_prng_ehr_valid ,
    cpu_rng_psel        ,
    penable             ,
    cpu_rng_pwrite      ,
    prng_busy           ,
    rnd_src_sel         ,
    trng_config         ,
    trng_debug_control  ,
         rosc_cntr_val0,
         rosc_cntr_val1,
         rosc_cntr_val2,
    trng_busy           
    );
`include "cc_params.inc" 
`include "rng_params.inc" 
`ifdef ASSERT_ON
`ifdef RNG_EXISTS
`include "trng_asrt_2_2_1.sva" 
`include "trng_asrt_3_5.sva" 
`include "trng_asrt_3_5_1.sva" 
`include "trng_asrt_3_6.sva" 
`include "trng_asrt_3_11.sva" 
`include "trng_asrt_3_12.sva" 
`include "trng_asrt_3_14.sva" 
`include "trng_asrt_3_16.sva" 
`endif
`endif
input  [11:0]       cpu_rng_paddr       ;
input               cpu_rng_psel        ;
input  [31:0]       cpu_rng_pwdata      ;
input               cpu_rng_pwrite      ;
input               penable             ;
input               prng_busy           ;
input               prng_trng_ehr_rd    ;
input               rd_sop              ;
input               rnd_src             ;
input               rng_clk             ;
input               rng_debug_enable    ;
input               rst_n               ;
input               scan_mode           ;
output              autocorr_4_consecutive_errors;
output [7:0]        autocorr_fails_cnt  ;
output [13:0]       autocorr_trys_cnt   ;
output              crngt_err           ;
output              divided_rnd_src     ;
output [`EHR_WIDTH-1:0] ehr_data            ;
output              ehr_valid           ;
output              rnd_src_en          ;
output [1:0]        rnd_src_sel         ;
output [`SAMPLE_CNT_LOCAL_SIZE - 1:0] sample_cnt1         ;
output              sop_sel             ;
output              trng_busy           ;
output [2:0]        trng_config         ;
output [3:0]        trng_debug_control  ;
output [`EHR_WIDTH-1:0] trng_prng_ehr_data  ;
output              trng_prng_ehr_valid ;
output              trng_valid          ;
output              vn_err              ;
output   [21:0]     rosc_cntr_val0;
output   [21:0]     rosc_cntr_val1;
output   [21:0]     rosc_cntr_val2;
wire                rnd_src_div         ;
wire                sync_valid          ;
wire                sync_data           ;
wire                rst_trng_logic      ;
wire                cntr_balance_valid  ;
wire                vnc_bypass          ;
wire                balance_filter_valid;
wire                balance_filter_data ;
wire                crngt_collector_rd  ;
wire                ehr_rd_collector    ;
wire                collector_valid     ;
wire   [15:0]       collector_crngt_data;
wire                trng_crngt_bypass   ;
wire                crngt_valid         ;
wire   [15:0]       crngt_dout          ;
wire                cpu_ehr_wr          ;
wire                curr_test_err       ;
wire   [7:0]        bits_counter        ;
wire                accum_enough_bits   ;
wire   [13:0]       pmf_data_out        ;
wire                cpu_wr_autocorr_statistic;
wire                auto_correlate_bypass;
wire   [`PMF_IN_WIDTH:0] pmf_addr_in         ;
wire                autocorr_finish_curr;
wire                cpu_ehr_rd          ;
wire                cpu_in_mid_rd_of_ehr_not_in_debug_mode;
trng_sync  trng_sync_i (
  .rng_clk               ( rng_clk               ),
  .rst_n                 ( rst_n                 ),
  .rnd_src               ( rnd_src               ),
  .rnd_src_en            ( rnd_src_en            ),
  .rnd_src_div           ( rnd_src_div           ),
  .scan_mode             ( scan_mode             ),
  .rng_debug_enable      ( rng_debug_enable      ),
  .sync_valid            ( sync_valid            ),
  .sync_data             ( sync_data             ),
    .rosc_cntr_val0    (rosc_cntr_val0),
  .rosc_cntr_val1    (rosc_cntr_val1),
  .rosc_cntr_val2    (rosc_cntr_val2),
  .divided_rnd_src       ( divided_rnd_src       )
);
trng_sample_cntr  trng_sample_cntr_i (
  .rst_n                 ( rst_n                 ),
  .rng_clk               ( rng_clk               ),
  .sample_cnt1           ( sample_cnt1           ),
  .rst_trng_logic        ( rst_trng_logic        ),
  .sync_valid            ( sync_valid            ),
  .cntr_balance_valid    ( cntr_balance_valid    )
);
trng_balancefilter  trng_balancefilter_i (
  .rng_clk               ( rng_clk               ),
  .rst_n                 ( rst_n                 ),
  .rnd_src_en            ( rnd_src_en            ),
  .cntr_balance_valid    ( cntr_balance_valid    ),
  .vnc_bypass            ( vnc_bypass            ),
  .sync_valid            ( sync_valid            ),
  .sync_data             ( sync_data             ),
  .rst_trng_logic        ( rst_trng_logic        ),
  .balance_filter_valid  ( balance_filter_valid  ),
  .balance_filter_data   ( balance_filter_data   ),
  .vn_err                ( vn_err                )
);
trng_collector  trng_collector_i (
  .rng_clk               ( rng_clk               ),
  .rst_n                 ( rst_n                 ),
  .balance_filter_valid  ( balance_filter_valid  ),
  .balance_filter_data   ( balance_filter_data   ),
  .crngt_collector_rd    ( crngt_collector_rd    ),
  .ehr_rd_collector      ( ehr_rd_collector      ),
  .rst_trng_logic        ( rst_trng_logic        ),
  .collector_valid       ( collector_valid       ),
  .collector_crngt_data  ( collector_crngt_data  )
);
crngt_to_trng  crngt_to_trng_i (
  .rst_n                 ( rst_n                 ),
  .rng_clk               ( rng_clk               ),
  .rnd_src_en            ( rnd_src_en            ),
  .collector_crngt_data  ( collector_crngt_data  ),
  .collector_valid       ( collector_valid       ),
  .trng_valid            ( trng_valid            ),
  .trng_crngt_bypass     ( trng_crngt_bypass     ),
  .rst_trng_logic        ( rst_trng_logic        ),
  .crngt_collector_rd    ( crngt_collector_rd    ),
  .crngt_valid           ( crngt_valid           ),
  .crngt_dout            ( crngt_dout            ),
  .crngt_err             ( crngt_err             )
);
ehr  ehr_i (
  .rst_n                 ( rst_n                 ),
  .rng_clk               ( rng_clk               ),
  .cpu_rng_pwdata        ( cpu_rng_pwdata        ),
  .cpu_rng_paddr         ( cpu_rng_paddr         ),
  .cpu_ehr_wr            ( cpu_ehr_wr            ),
  .crngt_dout            ( crngt_dout            ),
  .crngt_valid           ( crngt_valid           ),
  .trng_valid            ( trng_valid            ),
  .curr_test_err         ( curr_test_err         ),
  .bits_counter          ( bits_counter          ),
  .collector_valid       ( collector_valid       ),
  .trng_crngt_bypass     ( trng_crngt_bypass     ),
  .rst_trng_logic        ( rst_trng_logic        ),
  .ehr_valid             ( ehr_valid             ),
  .ehr_data              ( ehr_data              ),
  .trng_prng_ehr_data    ( trng_prng_ehr_data    ),
  .ehr_rd_collector      ( ehr_rd_collector      )
);
autocorrelation  autocorrelation_i (
  .rst_n                 ( rst_n                 ),
  .rng_clk               ( rng_clk               ),
  .data_in16bit          ( crngt_dout            ),
  .valid_16bit           ( crngt_valid           ),
  .accum_enough_bits     ( accum_enough_bits     ),
  .pmf_data_out          ( pmf_data_out          ),
  .cpu_wr_autocorr_statistic ( cpu_wr_autocorr_statistic ),
  .trng_valid            ( trng_valid            ),
  .ehr_valid             ( ehr_valid             ),
  .collector_valid       ( collector_valid       ),
  .trng_crngt_bypass     ( trng_crngt_bypass     ),
  .auto_correlate_bypass ( auto_correlate_bypass ),
  .rst_trng_logic        ( rst_trng_logic        ),
  .rnd_src_en            ( rnd_src_en            ),
  .autocorr_4_consecutive_errors ( autocorr_4_consecutive_errors ),
  .pmf_addr_in           ( pmf_addr_in           ),
  .curr_test_err         ( curr_test_err         ),
  .autocorr_finish_curr  ( autocorr_finish_curr  ),
  .autocorr_trys_cnt     ( autocorr_trys_cnt     ),
  .autocorr_fails_cnt    ( autocorr_fails_cnt    )
);
pmf_table  pmf_table_i (
  .pmf_data_out          ( pmf_data_out          ),
  .pmf_addr_in           ( pmf_addr_in           )
);
trng_tests_misc  trng_tests_misc_i (
  .rng_clk               ( rng_clk               ),
  .rst_n                 ( rst_n                 ),
  .crngt_valid           ( crngt_valid           ),
  .cpu_ehr_rd            ( cpu_ehr_rd            ),
  .cpu_ehr_wr            ( cpu_ehr_wr            ),
  .curr_test_err         ( curr_test_err         ),
  .autocorr_finish_curr  ( autocorr_finish_curr  ),
  .collector_valid       ( collector_valid       ),
  .trng_crngt_bypass     ( trng_crngt_bypass     ),
  .auto_correlate_bypass ( auto_correlate_bypass ),
  .trng_valid            ( trng_valid            ),
  .cpu_in_mid_rd_of_ehr_not_in_debug_mode ( cpu_in_mid_rd_of_ehr_not_in_debug_mode ),
  .prng_trng_ehr_rd      ( prng_trng_ehr_rd      ),
  .rst_trng_logic        ( rst_trng_logic        ),
  .rd_sop                ( rd_sop                ),
  .sop_sel               ( sop_sel               ),
  .accum_enough_bits     ( accum_enough_bits     ),
  .ehr_valid             ( ehr_valid             ),
  .bits_counter          ( bits_counter          ),
  .trng_prng_ehr_valid   ( trng_prng_ehr_valid   )
);
trng_reg_file  trng_reg_file_i (
  .rst_n                 ( rst_n                 ),
  .rng_clk               ( rng_clk               ),
  .cpu_rng_psel          ( cpu_rng_psel          ),
  .penable               ( penable               ),
  .cpu_rng_pwrite        ( cpu_rng_pwrite        ),
  .cpu_rng_paddr         ( cpu_rng_paddr         ),
  .cpu_rng_pwdata        ( cpu_rng_pwdata        ),
  .rng_debug_enable      ( rng_debug_enable      ),
  .autocorr_4_consecutive_errors ( autocorr_4_consecutive_errors ),
  .ehr_valid             ( ehr_valid             ),
  .prng_trng_ehr_rd      ( prng_trng_ehr_rd      ),
  .prng_busy             ( prng_busy             ),
  .rnd_src_sel           ( rnd_src_sel           ),
  .rnd_src_en            ( rnd_src_en            ),
  .sample_cnt1           ( sample_cnt1           ),
  .vnc_bypass            ( vnc_bypass            ),
  .rnd_src_div           ( rnd_src_div           ),
  .trng_valid            ( trng_valid            ),
  .cpu_ehr_rd            ( cpu_ehr_rd            ),
  .cpu_ehr_wr            ( cpu_ehr_wr            ),
  .cpu_wr_autocorr_statistic ( cpu_wr_autocorr_statistic ),
  .trng_crngt_bypass     ( trng_crngt_bypass     ),
  .auto_correlate_bypass ( auto_correlate_bypass ),
  .rst_trng_logic        ( rst_trng_logic        ),
  .trng_config           ( trng_config           ),
  .trng_debug_control    ( trng_debug_control    ),
  .trng_busy             ( trng_busy             ),
  .cpu_in_mid_rd_of_ehr_not_in_debug_mode ( cpu_in_mid_rd_of_ehr_not_in_debug_mode ),
  .sop_sel               ( sop_sel               )
);
endmodule
