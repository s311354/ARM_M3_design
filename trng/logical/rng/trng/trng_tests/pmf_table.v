//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module pmf_table(
        pmf_addr_in,
        pmf_data_out
        );
`include "rng_params.inc"
`include "cc_params.inc"    
output  [13:0]      pmf_data_out;
input  [`PMF_IN_WIDTH:0] pmf_addr_in;
`ifdef AUTOCORR_EXISTS
reg  [13:0]      pmf_data_out;
wire   [`PMF_IN_WIDTH:0] addr;
`ifdef AUTOCORR_192_BITS
assign addr = (pmf_addr_in > 8'd92) ? (8'd184 - pmf_addr_in) : pmf_addr_in; 
always @(*) begin
  case (addr)
    8'd62  : pmf_data_out = 14'd10146; 
    8'd63  : pmf_data_out = 14'd9469 ; 
    8'd64  : pmf_data_out = 14'd8817 ; 
    8'd65  : pmf_data_out = 14'd8189 ; 
    8'd66  : pmf_data_out = 14'd7585 ; 
    8'd67  : pmf_data_out = 14'd7006 ; 
    8'd68  : pmf_data_out = 14'd6450 ; 
    8'd69  : pmf_data_out = 14'd5918 ; 
    8'd70  : pmf_data_out = 14'd5410 ; 
    8'd71  : pmf_data_out = 14'd4925 ; 
    8'd72  : pmf_data_out = 14'd4463 ; 
    8'd73  : pmf_data_out = 14'd4025 ; 
    8'd74  : pmf_data_out = 14'd3610 ; 
    8'd75  : pmf_data_out = 14'd3218 ; 
    8'd76  : pmf_data_out = 14'd2848 ; 
    8'd77  : pmf_data_out = 14'd2502 ; 
    8'd78  : pmf_data_out = 14'd2178 ; 
    8'd79  : pmf_data_out = 14'd1877 ; 
    8'd80  : pmf_data_out = 14'd1599 ; 
    8'd81  : pmf_data_out = 14'd1343 ; 
    8'd82  : pmf_data_out = 14'd1109 ; 
    8'd83  : pmf_data_out = 14'd898  ; 
    8'd84  : pmf_data_out = 14'd709  ; 
    8'd85  : pmf_data_out = 14'd543  ; 
    8'd86  : pmf_data_out = 14'd399  ; 
    8'd87  : pmf_data_out = 14'd277  ; 
    8'd88  : pmf_data_out = 14'd177  ; 
    8'd89  : pmf_data_out = 14'd100  ; 
    8'd90  : pmf_data_out = 14'd44   ; 
    8'd91  : pmf_data_out = 14'd11   ; 
    8'd92  : pmf_data_out = 14'd0    ; 
    default: pmf_data_out = 14'd10793; 
  endcase
end
`else 
assign addr = (pmf_addr_in > 7'd60) ? (7'd120 - pmf_addr_in) : pmf_addr_in; 
always @(*) begin
  case (addr)
    7'd35 : pmf_data_out = 14'd10902; 
    7'd36 : pmf_data_out = 14'd10022; 
    7'd37 : pmf_data_out = 14'd9183; 
    7'd38 : pmf_data_out = 14'd8383; 
    7'd39 : pmf_data_out = 14'd7622; 
    7'd40 : pmf_data_out = 14'd6899; 
    7'd41 : pmf_data_out = 14'd6215; 
    7'd42 : pmf_data_out = 14'd5568; 
    7'd43 : pmf_data_out = 14'd4958;
    7'd44 : pmf_data_out = 14'd4385; 
    7'd45 : pmf_data_out = 14'd3848; 
    7'd46 : pmf_data_out = 14'd3348; 
    7'd47 : pmf_data_out = 14'd2883; 
    7'd48 : pmf_data_out = 14'd2453; 
    7'd49 : pmf_data_out = 14'd2059; 
    7'd50 : pmf_data_out = 14'd1700; 
    7'd51 : pmf_data_out = 14'd1376; 
    7'd52 : pmf_data_out = 14'd1086; 
    7'd53 : pmf_data_out = 14'd831; 
    7'd54 : pmf_data_out = 14'd610; 
    7'd55 : pmf_data_out = 14'd424; 
    7'd56 : pmf_data_out = 14'd271; 
    7'd57 : pmf_data_out = 14'd152;
    7'd58 : pmf_data_out = 14'd68; 
    7'd59 : pmf_data_out = 14'd17; 
    7'd60 : pmf_data_out = 14'd0; 
    default:pmf_data_out = 14'd10979; 
  endcase
end
`endif
`else 
wire  [13:0]  pmf_data_out;
assign pmf_data_out = 14'b0;
`endif
endmodule
