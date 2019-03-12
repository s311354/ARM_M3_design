// -----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//            (C) COPYRIGHT 2015,2017 ARM Limited or its affiliates.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
//      SVN Information
//
//      Checked In          :  2015-10-13 14:03:28 +0100 (Tue, 13 Oct 2015)
//
//      Revision            :  1
//
//      Release Information : CM3DesignStart-r0p0-02rel0
//
// -----------------------------------------------------------------------------
// Verilog-2001 (IEEE Std 1364-2001)
// -----------------------------------------------------------------------------
// Purpose : example pheripherals subsystem APB decoder
//
// -----------------------------------------------------------------------------

module m3ds_apb_decoder #(
  parameter ADDR_WIDTH=12         //ADDR Width of the IP
//  parameter PAGE_ADDR_WIDTH=12    //ADDR Width of the page size (i.e. 16k -> 12bits)
)
(
  input  wire         psel_i,
  input  wire [31:0]  paddr_i,
  input  wire         penable_i,
  input  wire         pprot_i,
  input  wire         secure_i,
  input  wire         pready_i,

  output wire         psel_valid_o,     //decoded psel to slave
  output wire         penable_valid_o,  //decoded penable to slave
  output wire         pready_o
);

wire psel_secure_decoded;
wire [15:0] paddr_decoded;
wire psel_addr_decoded;
wire psel_valid_w;
wire penable_valid_w;
wire pready_w;
wire unused = (|paddr_i[31:12]);

assign psel_secure_decoded = (!secure_i || pprot_i)? psel_i : 1'b0;           //Secure match -> psel_i, 1'b0 else

assign paddr_decoded[15:12] = 4'b0000;
assign paddr_decoded[11:0] = paddr_i[11:0];

assign psel_addr_decoded = (paddr_decoded[15:ADDR_WIDTH] == {16-ADDR_WIDTH{1'b0}})? psel_i : 1'b0;

assign psel_valid_w = psel_secure_decoded && psel_addr_decoded; //Secure Match and Addr covered
assign penable_valid_w = (psel_valid_w)? penable_i : 1'b0;      //Valid access to covered ADDR
assign pready_w = (psel_valid_w)? pready_i : 1'b1;              //Valid acces -> from IP, default 1'b1 else

assign psel_valid_o = psel_valid_w;
assign penable_valid_o = penable_valid_w;
assign pready_o = pready_w;

endmodule
