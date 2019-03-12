//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module slave_bus_ifc (
                      rst_n                             ,
                  cc_psel                              ,
                  cc_penable                           ,
                  cc_pwrite                            ,
                  cc_paddr                             ,
                  cc_pwdata                            ,
                  cc_prdata                            ,
                  rng_cpu_prdata                    ,
                  cpu_rng_psel                      ,    
                  cpu_rng_pwrite                    ,
                  cpu_rng_paddr                     ,
                  cpu_rng_pwdata                     
                  );
   parameter           CRY_ENGINE_UPPER_IDX = 4'ha;
`include "cc_params.inc"
   parameter        CLK_STATUS_ADDR = 12'h824;
   input            rst_n                             ; 
   input           cc_psel                              ;
   input           cc_penable                           ;
   input           cc_pwrite                            ;
   input [11:0]     cc_paddr                             ;
   input [31:0]     cc_pwdata                            ;
   input [31:0]     rng_cpu_prdata                    ;   
   output [31:0]    cc_prdata                   ;
   output           cpu_rng_psel          ;
   output           cpu_rng_pwrite        ;
   output [11:0]    cpu_rng_paddr         ;
   output [31:0]    cpu_rng_pwdata        ;
   wire [31:0]       prdata                   ;
   wire            cpu_cry_ctl_sel          ;
   wire           cpu_cry_ctl_write        ;  
   wire [11:0]       cpu_cry_ctl_addr         ;
   wire [31:0]       cpu_cry_ctl_wdata        ;
   assign       cpu_cry_ctl_sel    = cc_psel & (cc_paddr[11:8] == 4'h8);
   assign       cpu_rng_psel       = cc_psel & (cc_paddr[11:8] == 4'h1);
   assign       cpu_cry_ctl_write  = cc_pwrite & cc_penable;
   assign       cpu_rng_pwrite     = cc_pwrite & cc_penable;
   assign       cpu_cry_ctl_addr   = cpu_cry_ctl_sel ? cc_paddr[11:0] : 12'b0;
   assign       cpu_rng_paddr      = cpu_rng_psel    ? cc_paddr[11:0] : 12'b0;
   assign       cpu_cry_ctl_wdata  = cc_pwdata & {32{cpu_cry_ctl_sel}};
   assign       cpu_rng_pwdata     = cc_pwdata & {32{cpu_rng_psel}};
   assign       cc_prdata          =  cpu_rng_psel     ? rng_cpu_prdata :  {32{1'b0}} ;
endmodule
