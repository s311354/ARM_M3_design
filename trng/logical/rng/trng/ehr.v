//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module ehr (
   rst_n        ,
   rng_clk      ,
   cpu_rng_pwdata      ,
   cpu_rng_paddr      ,
   cpu_ehr_wr      ,
   crngt_dout      ,
   crngt_valid      ,
   trng_valid      ,
   curr_test_err      ,
   bits_counter      ,
   collector_valid    ,
   trng_crngt_bypass    ,
         rst_trng_logic      ,
   ehr_valid                      ,
   ehr_data      ,
   trng_prng_ehr_data    ,
   ehr_rd_collector
      );
`include "cc_params.inc"
`include "rng_addr_params.inc"
input     rst_n      ;
input     rng_clk      ;
input   [31:0]  cpu_rng_pwdata    ;
input   [11:0]  cpu_rng_paddr    ;
input     cpu_ehr_wr    ;
input   [15:0]  crngt_dout    ;
input     crngt_valid    ;
input     trng_valid    ;
input     curr_test_err    ;
input   [7:0]  bits_counter    ;
input     collector_valid    ;
input     trng_crngt_bypass  ;
input     rst_trng_logic    ;
input     ehr_valid               ;
output   [`EHR_WIDTH-1:0] ehr_data  ;
output   [`EHR_WIDTH-1:0] trng_prng_ehr_data;
output     ehr_rd_collector  ;
integer   i      ;
reg   [`EHR_WIDTH-1:0] ehr_data  ;
wire   [`EHR_WIDTH-1:0] trng_prng_ehr_data;
wire     ehr_rd_collector  ;
wire    ehr_wr      ;
assign  ehr_rd_collector = trng_crngt_bypass & collector_valid & !trng_valid;
assign  ehr_wr = (crngt_valid ) | (collector_valid & trng_crngt_bypass & !trng_valid);
always @(posedge rng_clk or negedge rst_n) 
  if(!rst_n) ehr_data <= {`EHR_WIDTH{1'b0}};
  else if(curr_test_err || rst_trng_logic) ehr_data <= #1 {`EHR_WIDTH{1'b0}};
  else if(cpu_ehr_wr) begin 
    case(cpu_rng_paddr)
      EHR_DATA0:ehr_data[31:0]   <= #1 cpu_rng_pwdata;
      EHR_DATA1:ehr_data[63:32]  <= #1 cpu_rng_pwdata;
      EHR_DATA2:ehr_data[95:64]  <= #1 cpu_rng_pwdata;
      EHR_DATA3:ehr_data[127:96] <= #1 cpu_rng_pwdata;
   `ifdef AUTOCORR_192_BITS
      EHR_DATA4:ehr_data[159:128] <= #1 cpu_rng_pwdata;
      EHR_DATA5:ehr_data[191:160] <= #1 cpu_rng_pwdata;
   `endif
    endcase
  end
  else if(ehr_wr) begin
    case(bits_counter[7:4])
   `ifdef AUTOCORR_192_BITS
      4'h0    : ehr_data[15:0]   <= #1 crngt_dout[15:0];
      4'h1    : ehr_data[31:16]   <= #1 crngt_dout[15:0];
      4'h2    : ehr_data[47:32]   <= #1 crngt_dout[15:0];
      4'h3    : ehr_data[63:48]   <= #1 crngt_dout[15:0];
      4'h4    : ehr_data[79:64]   <= #1 crngt_dout[15:0];
      4'h5    : ehr_data[95:80]   <= #1 crngt_dout[15:0];
      4'h6    : ehr_data[111:96] <= #1 crngt_dout[15:0];
      4'h7    : ehr_data[127:112]<= #1 crngt_dout[15:0];
      4'h8    : ehr_data[143:128]<= #1 crngt_dout[15:0];
      4'h9    : ehr_data[159:144]<= #1 crngt_dout[15:0];
      4'hA    : ehr_data[175:160]<= #1 crngt_dout[15:0];
      default : ehr_data[191:176]<= #1 crngt_dout[15:0]; 
   `else
      4'h0    : ehr_data[15:0]   <= #1 crngt_dout[15:0];
      4'h1    : ehr_data[31:16]   <= #1 crngt_dout[15:0];
      4'h2    : ehr_data[47:32]   <= #1 crngt_dout[15:0];
      4'h3    : ehr_data[63:48]   <= #1 crngt_dout[15:0];
      4'h4    : ehr_data[79:64]   <= #1 crngt_dout[15:0];
      4'h5    : ehr_data[95:80]   <= #1 crngt_dout[15:0];
      4'h6    : ehr_data[111:96] <= #1 crngt_dout[15:0];
      default : ehr_data[127:112]<= #1 crngt_dout[15:0]; 
   `endif
    endcase
  end
assign  trng_prng_ehr_data = ehr_data;
`ifdef ASSERT_ON
`ifdef RNG_EXISTS
 `include "trng_asrt_3.sva"
 `include "trng_asrt_3_9.sva"
`endif
`endif
endmodule
