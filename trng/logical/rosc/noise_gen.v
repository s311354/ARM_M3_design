//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module noise_gen (
  clk       ,   
  rst       ,   
  enb       ,   
  out           
  );
    input clk;
    input rst;
    input enb; 
    output [3 : 0] out;
    reg [3:0] out;
    wire lfsr1_out, lfsr2_out, lfsr3_out, lfsr4_out, lfsr5_out;
    wire lfsr6_out, lfsr7_out, lfsr8_out, lfsr9_out, lfsr10_out;
    wire lfsr11_out, lfsr12_out, lfsr13_out, lfsr14_out, lfsr15_out;
    lfsr_w #(.WIDTH(7), .TAPS(7'b1100000))
      u_lfsr1(.clk(clk), .rst(rst), .enb(enb), .out(lfsr1_out));
    lfsr_w #(.WIDTH(10), .TAPS(10'b1010011000))
      u_lfsr2(.clk(clk), .rst(rst), .enb(enb), .out(lfsr2_out));
    lfsr_w #(.WIDTH(11), .TAPS(11'b10100100100))
      u_lfsr3(.clk(clk), .rst(rst), .enb(enb), .out(lfsr3_out));
    lfsr_w #(.WIDTH(13), .TAPS(13'b1010010001000))
      u_lfsr4(.clk(clk), .rst(rst), .enb(enb), .out(lfsr4_out));
    lfsr_w #(.WIDTH(14), .TAPS(14'b10010101100100))
      u_lfsr5(.clk(clk), .rst(rst), .enb(enb), .out(lfsr5_out));
    lfsr_w #(.WIDTH(9), .TAPS(9'b101010010))
      u_lfsr6(.clk(clk), .rst(rst), .enb(enb), .out(lfsr6_out));
    lfsr_w #(.WIDTH(17), .TAPS(17'b10010010100100100))
      u_lfsr7(.clk(clk), .rst(rst), .enb(enb), .out(lfsr7_out));
    lfsr_w #(.WIDTH(19), .TAPS(19'b1000101010100010000))
      u_lfsr8(.clk(clk), .rst(rst), .enb(enb), .out(lfsr8_out));
    lfsr_w #(.WIDTH(7), .TAPS(7'b1001000))
      u_lfsr9(.clk(clk), .rst(rst), .enb(enb), .out(lfsr9_out));
    lfsr_w #(.WIDTH(9), .TAPS(9'b101101000))
      u_lfsr10(.clk(clk), .rst(rst), .enb(enb), .out(lfsr10_out));
    lfsr_w #(.WIDTH(10), .TAPS(10'b1011010000))
      u_lfsr11(.clk(clk), .rst(rst), .enb(enb), .out(lfsr11_out));
    lfsr_w #(.WIDTH(11), .TAPS(11'b10100010100))
      u_lfsr12(.clk(clk), .rst(rst), .enb(enb), .out(lfsr12_out));
    lfsr_w #(.WIDTH(13), .TAPS(13'b1010010100000))
      u_lfsr13(.clk(clk), .rst(rst), .enb(enb), .out(lfsr13_out));
    lfsr_w #(.WIDTH(14), .TAPS(14'b10100101101000))
      u_lfsr14(.clk(clk), .rst(rst), .enb(enb), .out(lfsr14_out));
    lfsr_w #(.WIDTH(17), .TAPS(17'b10001001001110000))
      u_lfsr15(.clk(clk), .rst(rst), .enb(enb), .out(lfsr15_out));
    wire [3 : 0] noise;
    assign noise = lfsr1_out + lfsr2_out + lfsr3_out + lfsr4_out + lfsr5_out +
        lfsr6_out + lfsr7_out + lfsr8_out + lfsr9_out + lfsr10_out +
  lfsr11_out + lfsr12_out + lfsr13_out + lfsr14_out + lfsr15_out;
    always @(posedge clk)
  if (rst) 
      out <= 0;
  else if (enb) begin
      out <= noise;
  end
endmodule
module lfsr_w (clk, rst, enb, out);
    parameter WIDTH = 2;
    parameter TAPS = 2'b10;
    input clk;
    input rst;
    input enb;
    output out;
    wire [WIDTH-1:0] lfsr_out;
    lfsr_new  #(.WIDTH(WIDTH), .TAPS(TAPS)) u_lfsr(clk, rst, enb, lfsr_out);
    assign out = lfsr_out[0];
endmodule
