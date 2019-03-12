//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
// synopsys translate_off
module DX_GTECH_AND2(A,B,Z);
input  A,B;
output  Z;
and    U(Z,A,B);
endmodule
module DX_GTECH_UDP_MUX4 (Z, D0, D1, D2, D3, A, B);
    output Z;
    input D0, D1, D2, D3, A, B;
wire abar, bbar, z1, z2, z3, z4;
not i6 (abar, A);
not i7 (bbar, B);
nand i1 (z1, bbar, abar, D0);
nand i2 (z2, bbar, A, D1);
nand i3 (z3, B, abar, D2);
nand i4 (z4, B, A, D3);
nand i5 (Z, z1, z2, z3, z4);
endmodule
module DX_GTECH_MUX4(D0,D1,D2,D3,A,B,Z);
input  D0,D1,D2,D3,A,B;
output  Z;
wire Z_int;
        DX_GTECH_UDP_MUX4 U1 (Z_int, D0, D1, D2, D3, A, B);
        assign Z = Z_int;
endmodule
module DX_GTECH_NOT(A,Z);
input  A;
output  Z;
reg Z;
integer rand_delay_in_ps;
real rand_delay_in_ns;
parameter MIN_INV_DELAY = 12; 
parameter MAX_INV_DELAY = 18; 
always @ *
begin
   rand_delay_in_ps = ({$random($time)}%(MAX_INV_DELAY-MIN_INV_DELAY))+MIN_INV_DELAY; 
   rand_delay_in_ns = 0.001 * rand_delay_in_ps;   
    #rand_delay_in_ns Z =~A;
end
endmodule
module \**SEQGEN** (clear, preset, next_state, clocked_on, data_in, 
                    enable, Q, synch_clear,synch_preset,synch_toggle,
                    synch_enable);
input clear, preset, next_state,clocked_on, data_in, enable, synch_clear,
      synch_preset, synch_toggle,synch_enable;
output reg Q;
always@(posedge clocked_on or posedge preset or  posedge clear)
  begin
      if(clear)
        begin
          Q <= 0;
        end
      else if(preset)
        begin
          Q <= 1;
        end
      else 
        begin
          if(enable)
          begin
            if(synch_clear)
              Q <= 0;
            else if(synch_preset)
              Q <= 1;
            else if(synch_toggle)
              Q <= ~Q;
            else if(data_in)
              Q <= data_in;
            else
              Q <= next_state;
          end
        end
  end
endmodule
module DX_GTECH_UDP_MUX2 (Z, A, B, S);
    output Z;
    input A, B, S;
wire Sbar, z1, z2;
not i4 (Sbar, S);
nand i1 (z1, Sbar, A);
nand i2 (z2, S, B);
nand i3 (Z, z1, z2);
endmodule
module DX_GTECH_UDP_FD1 ( Q, D, CP );
input  D, CP;
output Q;
    \**SEQGEN**  Q_reg ( .clear(1'b0), .preset(1'b0), .next_state(D), 
        .clocked_on(CP), .data_in(1'b0), .enable(1'b0), .Q(Q), .synch_clear(
        1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1)
         );
endmodule
module DX_GTECH_SEDF(D,E,SI,SE,CP,Q,QN);
input  D,E,SI,SE,CP;
output  Q,QN;
wire DT,DT2;
wire Q_int;
        DX_GTECH_UDP_MUX2 A2 (DT2, Q_int, D, E);
        DX_GTECH_UDP_MUX2 A (DT, DT2, SI, SE);
        DX_GTECH_UDP_FD1 B (Q_int, DT, CP);
        assign Q = Q_int;
        not  (QN, Q_int);
endmodule
module DX_GTECH_MUX2(A,B,S,Z);
input  A,B,S;
output  Z;
wire Z_int;
        DX_GTECH_UDP_MUX2 U1 (Z_int, A, B, S);
        assign Z = Z_int;
endmodule
// synopsys translate_on
