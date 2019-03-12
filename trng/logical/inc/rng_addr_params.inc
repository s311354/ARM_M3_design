//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
parameter   RNG_IMR                     =   12'h100;
parameter   RNG_ISR                     =   12'h104;
parameter   RNG_ICR                     =   12'h108;
parameter   TRNG_CONFIG                 =   12'h10C;
parameter   TRNG_VALID                  =   12'h110;
parameter   EHR_DATA0                   =   12'h114;
parameter   EHR_DATA1                   =   12'h118;
parameter   EHR_DATA2                   =   12'h11C;
parameter   EHR_DATA3                   =   12'h120;
parameter   EHR_DATA4                   =   12'h124;
parameter   EHR_DATA5                   =   12'h128;
parameter   RND_SOURCE_ENABLE           =   12'h12C;
parameter   SAMPLE_CNT1                 =   12'h130;
parameter   AUTOCORR_STATISTIC          =   12'h134;
parameter   TRNG_DEBUG_CONTROL          =   12'h138;
parameter   TRNG_SW_RESET               =   12'h140;
parameter   PRNG_CONTROL                =   12'h144;
parameter   RNG_READOUT0                =   12'h148;
parameter   RNG_READOUT1                =   12'h14C;
parameter   RNG_READOUT2                =   12'h150;
parameter   RNG_READOUT3                =   12'h154;
parameter   ADDITIONAL_INPUT_ENTROPY0   =   12'h160;
parameter   ADDITIONAL_INPUT_ENTROPY1   =   12'h164;
parameter   ADDITIONAL_INPUT_ENTROPY2   =   12'h168;
parameter   ADDITIONAL_INPUT_ENTROPY3   =   12'h16C;
parameter   ADDITIONAL_INPUT_ENTROPY4   =   12'h170;
parameter   ADDITIONAL_INPUT_ENTROPY5   =   12'h174;
parameter   ADDITIONAL_INPUT_ENTROPY6   =   12'h178;
parameter   ADDITIONAL_INPUT_ENTROPY7   =   12'h17C;
parameter   PRNG_DEBUG_CONTROL          =   12'h180;
parameter   V_REGISTER0                 =   12'h184;
parameter   V_REGISTER1                 =   12'h188;
parameter   V_REGISTER2                 =   12'h18C;
parameter   V_REGISTER3                 =   12'h190;
parameter   K_REGISTER0                 =   12'h194;
parameter   K_REGISTER1                 =   12'h198;
parameter   K_REGISTER2                 =   12'h19C;
parameter   K_REGISTER3                 =   12'h1A0;
parameter   REQ_SIZE_CNTR0              =   12'h1A4;
parameter   RESEED_CNTR0                =   12'h1A8;
parameter   RESEED_CNTR1                =   12'h1AC;
parameter   PRNG_VALID                  =   12'h1B0;
parameter   RNG_DEBUG_EN_INPUT          =   12'h1B4;
parameter   RNG_BUSY                    =   12'h1B8;
parameter   RST_BITS_COUNTER            =   12'h1BC;
parameter   RNG_VERSION                 =   12'h1C0;
parameter   RNG_BIST_CNTR0              =   12'h1E0;
parameter   RNG_BIST_CNTR1              =   12'h1E4;
parameter   RNG_BIST_CNTR2              =   12'h1E8;
