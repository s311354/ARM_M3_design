//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
`include "cc_params.inc"
`define SAMPLE_CNT_LOCAL_SIZE 32
`define SAMPLE_CNTR_RST_VAL 32'hFFFF 
`ifdef AUTOCORR_192_BITS
  `define PMF_IN_WIDTH  7
`else
  `define PMF_IN_WIDTH  6
`endif
`define RNG_USE_REGS_WO_RST
`define RNG_WIDE_INPUT
`define RNG_ONLY_ENCRYPT
`define RNG_RKEK_WIDTH 128
`ifdef RNG_USE_5_SBOXES
`define RNG_KSCH_RANDOM_WIDTH 18
`define RNG_ROUND_RANDOM_WIDTH 72
`else
`define RNG_KSCH_RANDOM_WIDTH 72
`define RNG_ROUND_RANDOM_WIDTH 288
`endif
`define RNG_DIN_AES_DATA_WIDTH 128
`define RNG_KEY_WIDTH 128
`define RNG_RANDOM_KEY_WIDTH 128
