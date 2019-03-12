//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module lfsr_new (
  clk       ,   
  rst       ,   
  enb       ,   
  out           
  );
    parameter WIDTH = 20;
    parameter TAPS = 20'b10001001000010110000;
    input clk;
    input rst;
    input enb; 
    output [WIDTH-1 : 0] out;
    wire [WIDTH-1 : 0] out;
    reg  [WIDTH-1 : 0] value;
    wire [WIDTH-1 : 0] next;
    wire        [39:0] taps;
    assign taps = {20'h0,TAPS};
    assign next = {1'b0,value[WIDTH-1:1]} ^ (value[0] ? taps[WIDTH-1:0] : {WIDTH{1'b0}});
    assign out = value;
    always @(posedge clk)
  if (rst) 
      value <= {{(WIDTH-1){1'b0}},1'd1};
  else if (enb) begin
      value <= next;
  end
endmodule
