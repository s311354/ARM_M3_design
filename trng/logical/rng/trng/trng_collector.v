//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module trng_collector (
                  rng_clk                ,
                  rst_n                  ,
                  balance_filter_valid   ,
                  balance_filter_data    ,
                  crngt_collector_rd     ,
      ehr_rd_collector   ,
      rst_trng_logic   ,
                  collector_valid        ,
                  collector_crngt_data 
                 );
`include "cc_params.inc"    
input           rng_clk                ;
input           rst_n                  ;
input           balance_filter_valid   ;
input           balance_filter_data    ;
input           crngt_collector_rd     ;
input           ehr_rd_collector       ;
input           rst_trng_logic    ;
output          collector_valid        ;
output  [15:0]   collector_crngt_data   ;
reg    [4:0]   counter                ;
reg    [15:0]  data_q                 ;
wire   [4:0]   counter_d              ;
wire   [15:0]  data_d                 ;
assign       counter_d       = ((crngt_collector_rd | ehr_rd_collector)   && collector_valid  )? 5'b0           :
                               (balance_filter_valid  && collector_valid  )? counter        :       
                               (balance_filter_valid                      )? counter + 5'b1 : counter                  ;
assign       data_d          = (balance_filter_valid & !collector_valid     )? {balance_filter_data,data_q[15:1]}: data_q[15:0] ;
assign       collector_valid = (counter == 5'd16)                                                                 ;
assign       collector_crngt_data       =  data_q                                                                            ;
always @ (posedge rng_clk or negedge rst_n)
begin
    if (!rst_n) begin
        counter    <= 5'b0;
        data_q     <= 16'b0; 
    end
    else if (rst_trng_logic) begin
        counter    <= 5'b0;
        data_q     <= 16'b0; 
    end
    else begin
        counter    <= #1 counter_d;
        data_q     <= #1 data_d   ;   
    end
end
`ifdef ASSERT_ON
 `include "trng_asrt_3_8.sva"
`endif
endmodule
