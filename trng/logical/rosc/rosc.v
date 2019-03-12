//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module rosc(
    rosc_en,
    rosc_sel,
    scanmode,
    clk, 
    rst_n,
    rosc_out
    );
    input    rosc_en;
    input [1:0] rosc_sel;
    input       scanmode;
    input       clk;
    input       rst_n;
    output    rosc_out;
    wire [31:0]  p_rdata;
    wire [7:0]  p_ad;
    wire     p_sel;
    wire        p_rd;
    wire        p_wr;
    wire [31:0]  p_wdata;
    reg [31:0]  deltax0, deltay0;
    reg [31:0]  deltax1, deltay1;
    reg [31:0]  deltax2, deltay2;
    reg [31:0]  deltax3, deltay3;
    reg      entropy_reset;
    wire [31:0]  deltax;
    wire [31:0]  deltay;
    wire        entropy_reset_evnt ;
    reg      p_wr_deltax0, p_wr_deltay0;
    reg      p_rd_deltax0, p_rd_deltay0;
    reg      p_wr_deltax1, p_wr_deltay1;
    reg      p_rd_deltax1, p_rd_deltay1;
    reg      p_wr_deltax2, p_wr_deltay2;
    reg      p_rd_deltax2, p_rd_deltay2;
    reg      p_wr_deltax3, p_wr_deltay3;
    reg      p_rd_deltax3, p_rd_deltay3;
    reg                 rosc_en_s  ;
    reg [1:0]           rosc_sel_s ;
    assign deltax = (rosc_sel == 0) ? deltax0 :
                    (rosc_sel == 1) ? deltax1 :
              (rosc_sel == 2) ? deltax2 :
                                deltax3;
    assign deltay = (rosc_sel == 0) ? deltay0 :
                    (rosc_sel == 1) ? deltay1 :
              (rosc_sel == 2) ? deltay2 :
                                deltay3;
    entropy_gen u_entropy(  .clk(clk),
            .rst(entropy_reset),
        .enb(rosc_en),
        .osc_deltax(deltax),
        .osc_deltay(deltay),
        .out(rosc_out));
    always @(*) begin
        p_wr_deltax0 = p_sel & p_wr & p_ad[4:2] == 0;
        p_rd_deltax0 = p_sel & p_rd & p_ad[4:2] == 0;
        p_wr_deltay0 = p_sel & p_wr & p_ad[4:2] == 1;
        p_rd_deltay0 = p_sel & p_rd & p_ad[4:2] == 1;
        p_wr_deltax1 = p_sel & p_wr & p_ad[4:2] == 2;
        p_rd_deltax1 = p_sel & p_rd & p_ad[4:2] == 2;
        p_wr_deltay1 = p_sel & p_wr & p_ad[4:2] == 3;
        p_rd_deltay1 = p_sel & p_rd & p_ad[4:2] == 3;
        p_wr_deltax2 = p_sel & p_wr & p_ad[4:2] == 4;
        p_rd_deltax2 = p_sel & p_rd & p_ad[4:2] == 4;
        p_wr_deltay2 = p_sel & p_wr & p_ad[4:2] == 5;
        p_rd_deltay2 = p_sel & p_rd & p_ad[4:2] == 5;
        p_wr_deltax3 = p_sel & p_wr & p_ad[4:2] == 6;
        p_rd_deltax3 = p_sel & p_rd & p_ad[4:2] == 6;
        p_wr_deltay3 = p_sel & p_wr & p_ad[4:2] == 7;
        p_rd_deltay3 = p_sel & p_rd & p_ad[4:2] == 7;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
      deltax0 <= 40;
      deltay0 <= 32;
      deltax1 <= 60;
      deltay1 <= 50;
      deltax2 <= 46;
      deltay2 <= 40;
      deltax3 <= 44;
      deltay3 <= 40;
  end else begin
      if (p_wr_deltax0) deltax0 <= p_wdata;
      else if (p_wr_deltay0) deltay0 <= p_wdata;
      else if (p_wr_deltax1) deltax1 <= p_wdata;
      else if (p_wr_deltay1) deltay1 <= p_wdata;
      else if (p_wr_deltax2) deltax2 <= p_wdata;
      else if (p_wr_deltay2) deltay2 <= p_wdata;
      else if (p_wr_deltax3) deltax3 <= p_wdata;
      else if (p_wr_deltay3) deltay3 <= p_wdata;
      end
  end
    always@(posedge clk or negedge rst_n)
    if (!rst_n)
        entropy_reset <= 1'b1 ;
    else if (entropy_reset_evnt)
        entropy_reset <= 1'b1 ;
    else entropy_reset <= #1 1'b0 ;
   assign entropy_reset_evnt = (p_wr_deltax0 || p_wr_deltay0 || 
                                p_wr_deltax1 || p_wr_deltay1 ||
        p_wr_deltax2 || p_wr_deltay2 ||
        p_wr_deltax3 || p_wr_deltay3 ||
              (rosc_sel_s[1:0] != rosc_sel[1:0]));
    always@(posedge clk or negedge rst_n)
    if (!rst_n)
        rosc_sel_s[1:0] <= 2'b0 ;
    else rosc_sel_s[1:0] <= #1  rosc_sel[1:0];
    always@(posedge clk or negedge rst_n)
    if (!rst_n)
        rosc_en_s <= 2'b0 ;
    else rosc_en_s <= #1  rosc_en;
    assign p_rdata = (p_rd_deltax0 )? deltax0 :
               (p_rd_deltay0 )? deltay0 :
                     (p_rd_deltax1 )? deltax1 :
                     (p_rd_deltay1 )? deltay1 :
                     (p_rd_deltax2 )? deltax2 :
                     (p_rd_deltay2 )? deltay2 :
                     (p_rd_deltax3 )? deltax3 :
                     deltay3 ;
endmodule
