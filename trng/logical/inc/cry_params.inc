//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
parameter SAMPLE_CNT_LOCAL_SIZE = 16;
parameter BYPASS_CTL                   = 5'd0;
parameter AES_CTL                      = 5'd1;
parameter AES_TO_HASH_CTL              = 5'd2;
parameter AES_AND_HASH_CTL             = 5'd3;
parameter DES_CTL                      = 5'd4;
parameter DES_TO_HASH_CTL              = 5'd5;
parameter DES_AND_HASH_CTL             = 5'd6;
parameter HASH_CTL                     = 5'd7;
parameter HASH_AND_DOUT_CTL            = 5'd8;
parameter AES_AND_BYPASS_CTL           = 5'd9;
parameter AES_TO_HASH_AND_DOUT_CTL     = 5'd10;
parameter RC4_CTL                      = 5'd11;
parameter DES_TO_HASH_AND_DOUT_CTL     = 5'd12;
parameter AES_TO_AES_TO_HASH_AND_DOUT_CTL   = 5'd13;
parameter AES_TO_AES_TO_HASH           = 5'd14;
parameter AES_TO_HASH_AND_AES          = 5'd15;
parameter C2_CTL                    = 5'd16;
