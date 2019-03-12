//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module dx_trng_top ( 
    cc_penable          ,
    rng_clk             ,
    scanmode            ,
    cc_psel             ,
    cc_pwrite           ,
    cc_paddr            ,
    cc_pwdata           ,
    cc_prdata           ,
    sys_rst_n           ,
    cc_host_int_req     
    );
`include "cc_params.inc" 
`include "rng_params.inc" 
input  [11:0]       cc_paddr            ;
input               cc_penable          ;
input               cc_psel             ;
input  [31:0]       cc_pwdata           ;
input               cc_pwrite           ;
input               rng_clk             ;
input               scanmode            ;
input               sys_rst_n           ;
output              cc_host_int_req     ;
output [31:0]       cc_prdata           ;
wire                rst_n               ;
wire   [31:0]       rng_cpu_prdata      ;
wire                cpu_rng_psel        ;
wire                cpu_rng_pwrite      ;
wire   [11:0]       cpu_rng_paddr       ;
wire   [31:0]       cpu_rng_pwdata      ;
wire                rng_sw_reset        ;
wire                rnd_src_en       ;
wire   [1:0]        rnd_src_sel      ;
wire                rnd_src             ;
slave_bus_ifc  slave_bus_ifc_i (
  .rst_n                 ( rst_n                 ),
  .cc_psel               ( cc_psel               ),
  .cc_penable            ( cc_penable            ),
  .cc_pwrite             ( cc_pwrite             ),
  .cc_paddr              ( cc_paddr              ),
  .cc_pwdata             ( cc_pwdata             ),
  .rng_cpu_prdata        ( rng_cpu_prdata        ),
  .cc_prdata             ( cc_prdata             ),
  .cpu_rng_psel          ( cpu_rng_psel          ),
  .cpu_rng_pwrite        ( cpu_rng_pwrite        ),
  .cpu_rng_paddr         ( cpu_rng_paddr         ),
  .cpu_rng_pwdata        ( cpu_rng_pwdata        )
);
rst_logic  rst_logic_i (
  .clk                   ( rng_clk               ),
  .sys_rst_n             ( sys_rst_n             ),
  .rng_sw_reset          ( rng_sw_reset          ),
  .scan_mode             ( scanmode              ),
  .rst_n                 ( rst_n                 )
);
`ifdef DX_FPGA
rosc rosc_i (
  .rosc_en               ( rnd_src_en            ),
  .rosc_sel              ( rnd_src_sel           ),
  .scanmode              ( scanmode              ),
  .clk                   ( rng_clk               ),
  .rst_n                 ( sys_rst_n             ),
  .rosc_out              ( rnd_src               )
);
`else
dx_inv_chain  dx_inv_chain_i (
  .rnd_src_en            ( rnd_src_en            ),
  .rnd_src_sel           ( rnd_src_sel           ),
  .scanmode              ( scanmode              ),
  .rng_clk               ( rng_clk               ),
  .rnd_src               ( rnd_src               )
);
`endif
rng_engine  rng_engine_i (
  .cpu_rng_paddr         ( cpu_rng_paddr         ),
  .cpu_rng_psel          ( cpu_rng_psel          ),
  .cpu_rng_pwdata        ( cpu_rng_pwdata        ),
  .cpu_rng_pwrite        ( cpu_rng_pwrite        ),
  .penable               ( cc_penable            ),
  .rnd_src               ( rnd_src               ),
  .rng_clk               ( rng_clk               ),
  .rst_n                 ( rst_n                 ),
  .scan_mode             ( scanmode              ),
  .rnd_src_en            ( rnd_src_en         ),
  .rnd_src_sel           ( rnd_src_sel        ),
  .rng_cpu_prdata        ( rng_cpu_prdata        ),
  .rng_int               ( cc_host_int_req       ),
  .rng_sw_reset          ( rng_sw_reset          )
);
endmodule
