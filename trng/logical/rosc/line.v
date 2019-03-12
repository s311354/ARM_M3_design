//The confidential and proprietary information contained in this file may only be used by a person authorised under and to the extent permitted by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//  (C) Copyright 2001-2017 ARM Limited or its affiliates. All rights reserved.
//
//The entire notice above must be reproduced on all copies of this file and copies of this file may only be made by a person if such person is permitted to do so under the terms of a subsisting license agreementfrom ARM Limited or its affiliates.
module line (
  clk       ,   
  rst       ,   
  enb       ,   
  deltax    ,   
  deltay    ,   
  noise     ,   
  out           
  );
    input clk;
    input rst;
    input enb; 
    input [31 : 0] deltax;
    input [31 : 0] deltay;
    input [3 : 0] noise;
    output out;
    reg out;
    integer error;
    wire steep = (deltay > deltax);
    always @(posedge clk)
  if (rst) begin
      error <= 0;
      out <= 1'b0;
  end else if (enb) begin
      if (steep) begin
    if (error < deltax) begin
        error <= error + deltay - deltax + noise;
        out <= !out;
    end else begin
        error <= error + deltay - 2*deltax + noise;
    end
      end else begin
    if (error < deltay) begin
        error <= error + deltax - deltay + noise;
        out <= !out;
    end else begin
        error <= error - deltay + noise;
    end
      end
  end
endmodule
