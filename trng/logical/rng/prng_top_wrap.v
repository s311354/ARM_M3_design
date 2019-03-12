//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module prng_top_wrap ( 
    rst_n               ,
    rng_clk             ,
    scan_mode         ,
    rng_debug_enable    ,
    cpu_rng_psel        ,
    penable     ,
    cpu_rng_pwrite      ,
    cpu_rng_paddr       ,
    cpu_rng_pwdata      ,
    rd_sop              ,
                sop_sel             ,
    trng_prng_ehr_data  ,
    trng_prng_ehr_valid ,
    prng_control      ,
    prng_crngt_err      ,
    reseed_done_1p      ,
    final_update_done_1p,
    additional_input_entropy,
    real_instantiation_done,
    k_reg             ,
    kat_err           ,
    which_kat_err        ,
    prng_busy         ,
    prng_debug_control  ,
    req_size_cntr      ,
    req_size_overflow_1p,
    reseed_cntr       ,
    reseed_cntr_overflow_1p,
    reseed_cntr_top_40_1p,
    rng_readout          ,
    rng_readout_valid   ,
    v_reg                ,
    prng_trng_ehr_rd    
    );
`include "cc_params.inc" 
input  [11:0]       cpu_rng_paddr       ;
input               penable     ;
input               cpu_rng_psel        ;
input  [31:0]       cpu_rng_pwdata      ;
input               cpu_rng_pwrite      ;
input               rng_clk             ;
input               rd_sop              ;
input               sop_sel             ;
input               scan_mode           ;
input               rst_n               ;
input  [`EHR_WIDTH-1:0] trng_prng_ehr_data;
input               trng_prng_ehr_valid ;
input            rng_debug_enable  ;
output              prng_crngt_err  ;
output            reseed_done_1p  ;
output            final_update_done_1p;
output [255:0]      additional_input_entropy;
output              real_instantiation_done;
output [127:0]      k_reg          ;
output              kat_err        ;
output [1:0]        which_kat_err  ;
output              prng_busy      ;
output [2:0]        prng_control  ;
output              prng_debug_control;
output [11:0]       req_size_cntr  ;
output              req_size_overflow_1p;
output [47:0]       reseed_cntr    ;
output              reseed_cntr_overflow_1p;
output              reseed_cntr_top_40_1p;
output [127:0]      rng_readout    ;
output              rng_readout_valid;
output [127:0]      v_reg          ;
output              prng_trng_ehr_rd;
`ifdef PRNG_EXISTS
          `ifndef PRNG_LIGHT_EXISTS 
                 prng_800_90_top prng_800_90_top_i ( 
                   .rng_clk                  (rng_clk                 ),
                   .rst_n                    (rst_n                   ),
                   .scan_mode                  (scan_mode                ),
                   .rd_sop                  (rd_sop                ),
                   .sop_sel                  (sop_sel                  ),
                   .cpu_rng_pwdata           (cpu_rng_pwdata          ),
                   .cpu_rng_paddr            (cpu_rng_paddr           ),
                   .prng_trng_ehr_rd         (prng_trng_ehr_rd        ),
                   .rng_readout           (rng_readout          ),
                   .additional_input_entropy  (additional_input_entropy  ),
                   .req_size_cntr            (req_size_cntr          ),
                   .reseed_cntr           (reseed_cntr          ),
                   .v_reg                 (v_reg                ),
                   .k_reg                 (k_reg                ),
                   .reseed_cntr_overflow_1p    (reseed_cntr_overflow_1p  ),
                   .reseed_cntr_top_40_1p     (reseed_cntr_top_40_1p    ),
                   .req_size_overflow_1p     (req_size_overflow_1p    ),
                   .prng_crngt_err          (prng_crngt_err          ),
                   .reseed_done_1p          (reseed_done_1p          ),
                   .final_update_done_1p      (final_update_done_1p    ),
                   .rng_readout_valid         (rng_readout_valid        ),
                   .prng_busy             (prng_busy            ),
                   .trng_prng_ehr_valid     (trng_prng_ehr_valid     ),
                   .trng_prng_ehr_data       (trng_prng_ehr_data       ),
                   .kat_err               (kat_err              ),
                   .which_kat_err            (which_kat_err           ),
                   .cpu_rng_psel            (cpu_rng_psel            ),
                   .penable         (penable         ),
                   .cpu_rng_pwrite          (cpu_rng_pwrite          ),
                   .rng_debug_enable        (rng_debug_enable        ),
                   .real_instantiation_done  (real_instantiation_done  ),
                   .prng_debug_control         (prng_debug_control        ),
                   .prng_control              (prng_control            )
                 );
          `else
                prng_light_top  prng_light_top_i (
                  .rst_n                     ( rst_n                   ),
                  .rng_clk                   ( rng_clk                 ),
                  .rd_sop                 ( rd_sop                   ),
                   .sop_sel                  ( sop_sel                  ),
                  .rng_debug_enable        ( rng_debug_enable        ),
                  .cpu_rng_psel              ( cpu_rng_psel            ),
                  .penable           ( penable         ),
                  .cpu_rng_pwrite            ( cpu_rng_pwrite          ),
                  .cpu_rng_paddr             ( cpu_rng_paddr           ),
                  .cpu_rng_pwdata            ( cpu_rng_pwdata          ),
                  .trng_prng_ehr_data       ( trng_prng_ehr_data       ),
                  .trng_prng_ehr_valid       ( trng_prng_ehr_valid     ),
                  .prng_control           ( prng_control           ),
                  .prng_crngt_err           ( prng_crngt_err        ),
                   .reseed_done_1p          (reseed_done_1p          ),
                   .final_update_done_1p      (final_update_done_1p    ),
                  .additional_input_entropy   ( additional_input_entropy   ),
                  .real_instantiation_done   ( real_instantiation_done   ),
                  .k_reg                  ( k_reg                  ),
                  .kat_err                ( kat_err                ),
                  .which_kat_err           ( which_kat_err          ),
                  .prng_busy              ( prng_busy              ),
                  .prng_debug_control     ( prng_debug_control     ),
                  .req_size_cntr           ( req_size_cntr         ),
                  .req_size_overflow_1p     ( req_size_overflow_1p     ),
                  .reseed_cntr           ( reseed_cntr           ),
                  .reseed_cntr_overflow_1p   ( reseed_cntr_overflow_1p   ),
                  .reseed_cntr_top_40_1p     ( reseed_cntr_top_40_1p   ),
                  .rng_readout            ( rng_readout            ),
                  .rng_readout_valid         ( rng_readout_valid     ),
                  .v_reg                  ( v_reg                  ),
                  .prng_trng_ehr_rd          ( prng_trng_ehr_rd        )
                );
          `endif
`else 
      wire              prng_crngt_err          ;
      wire              reseed_done_1p          ;
      wire              final_update_done_1p      ;
      wire [255:0]      additional_input_entropy  ;
      wire              real_instantiation_done    ;
      wire [127:0]      k_reg                  ;
      wire              kat_err                ;
      wire [1:0]        which_kat_err          ;
      wire              prng_busy               ;
      wire [2:0]        prng_control          ;
      wire              prng_debug_control      ;
      wire [11:0]       req_size_cntr          ;
      wire              req_size_overflow_1p    ;
      wire [47:0]       reseed_cntr            ;
      wire              reseed_cntr_overflow_1p    ;
      wire              reseed_cntr_top_40_1p    ;
      wire [127:0]      rng_readout            ;
      wire              rng_readout_valid      ;
      wire [127:0]      v_reg                  ;
      wire              prng_trng_ehr_rd        ;
    assign  prng_crngt_err            =  1'b0    ;      
    assign  reseed_done_1p          =  1'b0    ;      
    assign  final_update_done_1p      =  1'b0    ;      
    assign  additional_input_entropy  =  256'b0  ;     
    assign  real_instantiation_done   =  1'b0    ;             
    assign  k_reg                  =  128'b0  ;       
    assign  kat_err                =  1'b0    ;             
    assign  which_kat_err            =  2'b0    ;             
    assign  prng_busy             =  1'b0    ;             
    assign  prng_control              =  3'b0    ;       
    assign  prng_debug_control      =  1'b0    ;             
    assign  req_size_cntr              =  12'b0  ;      
    assign  req_size_overflow_1p      =  1'b0    ;             
    assign  reseed_cntr          =  48'b0  ;      
    assign  reseed_cntr_overflow_1p  =  1'b0    ;             
    assign  reseed_cntr_top_40_1p      =  1'b0    ;             
    assign  rng_readout           =  128'b0  ;     
    assign  rng_readout_valid         =  1'b0    ;             
    assign  v_reg                 =  128'b0  ;     
    assign  prng_trng_ehr_rd        =  1'b0    ;             
`endif
endmodule
