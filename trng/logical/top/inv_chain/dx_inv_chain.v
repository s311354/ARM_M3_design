//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module dx_inv_chain(
                rnd_src_en,
                rnd_src_sel,
                scanmode,
                rng_clk,
                rnd_src
                );
parameter INV_GROUP_A = 51;
parameter INV_GROUP_B = 59;
parameter INV_GROUP_C = 67;
parameter INV_GROUP_T = 71;
parameter FIRST_INV_CHAIN_LENGTH  = INV_GROUP_A;
parameter SECOND_INV_CHAIN_LENGTH = INV_GROUP_B - INV_GROUP_A ;
parameter THIRD_INV_CHAIN_LENGTH  = INV_GROUP_C - INV_GROUP_B ;
parameter FOURTH_INV_CHAIN_LENGTH = INV_GROUP_T - INV_GROUP_C ;
input          rnd_src_en;
input    [1:0]      rnd_src_sel;
input        scanmode;
input        rng_clk;
output         rnd_src;
wire    [FIRST_INV_CHAIN_LENGTH:0]  #0.01   first_inv_chain;
wire    [SECOND_INV_CHAIN_LENGTH:0]  #0.01   second_inv_chain;
wire    [THIRD_INV_CHAIN_LENGTH:0]  #0.01   third_inv_chain;
wire    [FOURTH_INV_CHAIN_LENGTH:0]  #0.01   fourth_inv_chain;
wire  [3:0]    testpoint;
wire        testpoint_out;
wire                rosc_dft_p0_ff_in;
wire                rosc_dft_p1_ff_in;
wire                rosc_dft_p2_ff_in;
wire                rosc_dft_p3_ff_in;
    DX_GTECH_AND2 rosc_AND_gate (
  .A  (rnd_src_en  ),
  .B  (testpoint_out  ),
  .Z  (first_inv_chain[0])
    );
 genvar i;
    generate
      for (i = 0; i < FIRST_INV_CHAIN_LENGTH; i=i+1) begin : rosc_first_INV_chain
          DX_GTECH_NOT rosc_INV_gate (
        .A  (first_inv_chain[i+0]  ),
        .Z  (first_inv_chain[i+1]  )
          );
      end
    endgenerate
genvar j;
    generate
      for (j = 0; j < SECOND_INV_CHAIN_LENGTH; j=j+1) begin : rosc_second_INV_chain
          DX_GTECH_NOT rosc_INV_gate (
        .A  (second_inv_chain[j+0]  ),
        .Z  (second_inv_chain[j+1]  )
          );
      end
    endgenerate
genvar k ;
    generate
      for (k = 0; k < THIRD_INV_CHAIN_LENGTH; k=k+1) begin : rosc_third_INV_chain
          DX_GTECH_NOT rosc_INV_gate (
        .A  (third_inv_chain[k+0]  ),
        .Z  (third_inv_chain[k+1]  )
          );
      end
    endgenerate
genvar l ;
    generate
      for (l = 0; l < FOURTH_INV_CHAIN_LENGTH ; l=l+1) begin : rosc_fourth_INV_chain
          DX_GTECH_NOT rosc_INV_gate (
        .A  (fourth_inv_chain[l+0]  ),
        .Z  (fourth_inv_chain[l+1]  )
          );
      end
    endgenerate
    DX_GTECH_MUX4 rosc_MUX_gate (
  .D0  (first_inv_chain[FIRST_INV_CHAIN_LENGTH] ),
  .D1  (second_inv_chain[SECOND_INV_CHAIN_LENGTH] ),
  .D2  (third_inv_chain[THIRD_INV_CHAIN_LENGTH] ),
  .D3  (fourth_inv_chain[FOURTH_INV_CHAIN_LENGTH] ),
  .A  (rnd_src_sel[0]       ),
  .B  (rnd_src_sel[1]       ),
  .Z  (rnd_src       )
    );
    DX_GTECH_SEDF rosc_dft_p0_ff (  .E(scanmode),
              .D(first_inv_chain[FIRST_INV_CHAIN_LENGTH]),
          .SI(),
          .SE(1'b0),
          .CP(rng_clk),
          .Q(testpoint[0]),
          .QN()); 
    DX_GTECH_MUX2 rosc_dft_p0_mux(  .A(first_inv_chain[FIRST_INV_CHAIN_LENGTH]),
          .B(testpoint[0]),
          .S(scanmode),
          .Z(second_inv_chain[0]));
    DX_GTECH_SEDF rosc_dft_p1_ff (  .E(scanmode),
              .D(second_inv_chain[SECOND_INV_CHAIN_LENGTH]),
          .SI(),
          .SE(1'b0),
          .CP(rng_clk),
          .Q(testpoint[1]),
          .QN());
    DX_GTECH_MUX2 rosc_dft_p1_mux(  .A(second_inv_chain[SECOND_INV_CHAIN_LENGTH]),
          .B(testpoint[1]),
          .S(scanmode),
          .Z(third_inv_chain[0]));
   DX_GTECH_SEDF  rosc_dft_p2_ff (  .E(scanmode),
             .D(third_inv_chain[THIRD_INV_CHAIN_LENGTH]),
          .SI(),
          .SE(1'b0),
          .CP(rng_clk),
          .Q(testpoint[2]),
          .QN()); 
    DX_GTECH_MUX2 rosc_dft_p2_mux(  .A(third_inv_chain[THIRD_INV_CHAIN_LENGTH]),
          .B(testpoint[2]),
          .S(scanmode),
          .Z(fourth_inv_chain[0]));
    DX_GTECH_SEDF  rosc_dft_p3_ff (  .E(scanmode),
               .D(rnd_src),
          .SI(),
          .SE(1'b0),
          .CP(rng_clk),
          .Q(testpoint[3]),
          .QN());
    DX_GTECH_MUX2 rosc_dft_p3_mux(  .A(rnd_src),
          .B(testpoint[3]),
          .S(scanmode),
          .Z(testpoint_out));
endmodule
