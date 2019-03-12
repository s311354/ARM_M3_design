//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
`define HOST_NUM_OF_INTERRUPTS 16
`ifdef LARGE_RKEK
`define RKEK_WIDTH 256
`else
`define RKEK_WIDTH 128
`endif
`define DIN_AES_DATA_WIDTH 128
`define HASH_AES_DIN_AES_DATA_WIDTH 128
`define HASH_AES_RKEK_WIDTH 128
`define HASH_AES_XEX_DATA_UNIT_SIZE_LOG 5
`define HASH_AES_AES_DIN_BYTE_RESOLUTION
`define HASH_AES_AES_XCBC_MAC_EXISTS
`define SEP_MUL_EXISTS
`define ALWAYS_ON_DCU_EN
`define DCACHE_MEM_SIZE         8192
`define DCACHE_BLOCK_SIZE       64
`define DCACHE_MEM_WIDTH        10
`define DCACHE_TAG_WIDTH        6
`define CACHE_TAG_DATA          42
`define DCACHE_AES_EXISTS
`define DCACHE_AES_LARGE_RKEK
`define DCACHE_AES_SUPPORT_256_192_KEY
`define DCACHE_AES_XEX_EXISTS
`define ICACHE_MEM_SIZE         8192
`define ICACHE_BLOCK_SIZE       64
`define ICACHE_MEM_WIDTH        10
`define ICACHE_TAG_WIDTH        6
`define SRAM_DATA_W   32
`define SRAM_LAST_ADDR  15'h1FFC
`define ROM_DATA_W   32
`define AIB_DATA_W   32
`define AIB_ADDR_W   8
`define AHB_WRITE_16_BURST
`define AHB_READ_16_BURST
`define DIN_FIFO_DATA_W 32
`define DIN_FIFO_DEPTH 4
`define DIN_FIFO_DEPTH_LOG 3
 `define DOUT_EXISTS
`define DOUT_DATA_W 32
`define PAD_PRSNT    
    `define TRNG_TESTS_BYPASS_EN  
  `define CRNGT_EXISTS     
  `define AUTOCORR_EXISTS    
    `define EHR_WIDTH 192
    `define AUTOCORR_192_BITS
`ifdef HASH_EXISTS
  `define HASH_AES_MAC_TOP_EXISTS
`else
  `ifdef AES_MAC_MODULE_EXISTS
     `define HASH_AES_MAC_TOP_EXISTS
  `endif
`endif
