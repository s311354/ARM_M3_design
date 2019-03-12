//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module entropy_gen (
  clk          ,   
  rst          ,   
  enb          ,   
  osc_deltax   ,   
  osc_deltay   ,   
  out              
  );
    input clk;
    input rst;
    input enb; 
    input [31 : 0] osc_deltax;
    input [31 : 0] osc_deltay;
    output out;
    reg out;
    wire [3 : 0] noise_out;
    wire line_out;
    noise_gen u_noise(.clk(clk),
                      .rst(rst),
          .enb(enb),
          .out(noise_out));
    line u_line(.clk(clk),
                .rst(rst),
    .enb(enb),
    .deltax(osc_deltax),
    .deltay(osc_deltay),
    .noise(noise_out),
    .out(line_out));
    always @(posedge clk)
  if (rst) 
      out <= 1'b0;
  else if (enb) begin
      out <= line_out;
  end
endmodule
