//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module rng_top_wrap_unconnected( 
                               sop_data   ,
                               sop_valid  ,
                                 divided_rnd_src,
                                 rng_busy,
                                 rng_debug_enable,
                               rd_sop    
                               );
`include "cc_params.inc"    
   input [127:0] sop_data;
   input       sop_valid;
   input         divided_rnd_src;
   input         rng_busy ;
   output     rd_sop;
   output        rng_debug_enable    ;
   wire rd_sop;
   wire rng_debug_enable ;
   assign rd_sop           = 1'b0;
   assign rng_debug_enable = 1'b0;
endmodule
