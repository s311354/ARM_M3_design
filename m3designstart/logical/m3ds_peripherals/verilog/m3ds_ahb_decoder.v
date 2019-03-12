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
// Purpose : M3 DesignStart FPGA peripherals subsystem AHB decoder and splitter
//
// -----------------------------------------------------------------------------

module m3ds_ahb_decoder (
  input  wire         HSEL_i,
  input  wire [21:0]  decode_address_i, //PERIPHHADDR[31:10]; lower 10 bits are not compared
  input  wire         PERIPHHPROT_i,
  input  wire [5:0]   periph_sysprot_i,

  output wire         HSEL0_o,          //default_slave
  output wire         HSEL2_o,          //GPIO0
  output wire         HSEL3_o,          //GPIO1
  output wire         HSEL4_o,          //GPIO2
  output wire         HSEL5_o,          //GPIO3
  output wire         HSEL6_o           //SysCtrl
);

  reg  defslave_sel;
  reg  GPIO0_sel;
  reg  GPIO1_sel;
  reg  GPIO2_sel;
  reg  GPIO3_sel;
  reg  SYSCTRL_sel;
  wire unused = periph_sysprot_i[0]; // Help linting tools

  assign HSEL0_o = defslave_sel;
  assign HSEL2_o = (!periph_sysprot_i[1] || PERIPHHPROT_i)? GPIO0_sel   : 1'b0;
  assign HSEL3_o = (!periph_sysprot_i[2] || PERIPHHPROT_i)? GPIO1_sel   : 1'b0;
  assign HSEL4_o = (!periph_sysprot_i[3] || PERIPHHPROT_i)? GPIO2_sel   : 1'b0;
  assign HSEL5_o = (!periph_sysprot_i[4] || PERIPHHPROT_i)? GPIO3_sel   : 1'b0;
  assign HSEL6_o = (!periph_sysprot_i[5] || PERIPHHPROT_i)? SYSCTRL_sel : 1'b0;

  //------------------------------------
  //AHB decoder
  //------------------------------------
  /*------------------------------------
  localparam DEFSLV0_AHB_ADDR_LOW = 32'h0004_0000;
  localparam DEFSLV0_AHB_ADDR_HIGH= 32'h3fff_ffff;
  localparam GPIO0_AHB_ADDR_LOW = 32'h4001_0000;
  localparam GPIO0_AHB_ADDR_HIGH= 32'h4001_0fff;
  localparam GPIO1_AHB_ADDR_LOW = 32'h4001_1000;
  localparam GPIO1_AHB_ADDR_HIGH= 32'h4001_1fff;
  localparam GPIO2_AHB_ADDR_LOW = 32'h4001_2000;
  localparam GPIO2_AHB_ADDR_HIGH= 32'h4001_2fff;
  localparam GPIO3_AHB_ADDR_LOW = 32'h4001_3000;
  localparam GPIO3_AHB_ADDR_HIGH= 32'h4001_3fff;
  localparam DEFSLV1_AHB_ADDR_LOW = 32'h4001_4000;
  localparam DEFSLV1_AHB_ADDR_HIGH= 32'h4001_efff;
  localparam SYSCTRL_AHB_ADDR_LOW = 32'h4001_f000;
  localparam SYSCTRL_AHB_ADDR_HIGH= 32'h4001_ffff;
  localparam DEFSLV2_AHB_ADDR_LOW = 32'h4002_0000;
  localparam DEFSLV2_AHB_ADDR_HIGH= 32'hffff_ffff;
  --------------------------------------*/
  always @(HSEL_i or decode_address_i)
  begin : HSEL_decoder
    if (HSEL_i == 1'b0) begin //HSEL_i = 0: dont select anything
      defslave_sel = 1'b0;
      GPIO0_sel    = 1'b0;
      GPIO1_sel    = 1'b0;
      GPIO2_sel    = 1'b0;
      GPIO3_sel    = 1'b0;
      SYSCTRL_sel  = 1'b0;
    end
    else begin
      // default slave: Address region 0x00000000-0x0003ffff
      if ((decode_address_i >= 22'h000000) & (decode_address_i <= 22'h0000ff))
        begin
          defslave_sel  = 1'b1;
          GPIO0_sel     = 1'b0;
          GPIO1_sel     = 1'b0;
          GPIO2_sel     = 1'b0;
          GPIO3_sel     = 1'b0;
          SYSCTRL_sel   = 1'b0;
        end

      // default slave: Address region 0x00040000-0x4000FFFF
      else if ((decode_address_i >= 22'h000100) & (decode_address_i <= 22'h10003f))
        begin
          defslave_sel  = 1'b1;
          GPIO0_sel     = 1'b0;
          GPIO1_sel     = 1'b0;
          GPIO2_sel     = 1'b0;
          GPIO3_sel     = 1'b0;
          SYSCTRL_sel   = 1'b0;
        end

      // GPIO0: Address region 0x40010000-0x40010FFF
      else if ((decode_address_i >= 22'h100040) & (decode_address_i <= 22'h100043))
        begin
          defslave_sel  = 1'b0;
          GPIO0_sel     = 1'b1;
          GPIO1_sel     = 1'b0;
          GPIO2_sel     = 1'b0;
          GPIO3_sel     = 1'b0;
          SYSCTRL_sel   = 1'b0;
        end

      // GPIO1: Address region 0x40011000-0x40011FFF
      else if ((decode_address_i >= 22'h100044) & (decode_address_i <= 22'h100047))
        begin
          defslave_sel  = 1'b0;
          GPIO0_sel     = 1'b0;
          GPIO1_sel     = 1'b1;
          GPIO2_sel     = 1'b0;
          GPIO3_sel     = 1'b0;
          SYSCTRL_sel   = 1'b0;
        end

      // GPIO2: Address region 0x40012000-0x40012FFF
      else if ((decode_address_i >= 22'h100048) & (decode_address_i <= 22'h10004b))
        begin
          defslave_sel  = 1'b0;
          GPIO0_sel     = 1'b0;
          GPIO1_sel     = 1'b0;
          GPIO2_sel     = 1'b1;
          GPIO3_sel     = 1'b0;
          SYSCTRL_sel   = 1'b0;
        end

      // GPIO3: Address region 0x40013000-0x40013FFF
      else if ((decode_address_i >= 22'h10004c) & (decode_address_i <= 22'h10004f))
        begin
          defslave_sel  = 1'b0;
          GPIO0_sel     = 1'b0;
          GPIO1_sel     = 1'b0;
          GPIO2_sel     = 1'b0;
          GPIO3_sel     = 1'b1;
          SYSCTRL_sel   = 1'b0;
        end

      // default slave: Address region 0x40014000-0x4001EFFF
      else if ((decode_address_i >= 22'h100050) & (decode_address_i <= 22'h10007b))
        begin
          defslave_sel  = 1'b1;
          GPIO0_sel     = 1'b0;
          GPIO1_sel     = 1'b0;
          GPIO2_sel     = 1'b0;
          GPIO3_sel     = 1'b0;
          SYSCTRL_sel   = 1'b0;
        end

      // SysCtrl: Address region 0x4001F000-0x4001FFFF
      else if ((decode_address_i >= 22'h10007c) & (decode_address_i <= 22'h10007f))
        begin
          defslave_sel  = 1'b0;
          GPIO0_sel     = 1'b0;
          GPIO1_sel     = 1'b0;
          GPIO2_sel     = 1'b0;
          GPIO3_sel     = 1'b0;
          SYSCTRL_sel   = 1'b1;
        end

      // default slave: Address region 0x40020000-0xFFFFFFFF
      else if ((decode_address_i >= 22'h100080) & (decode_address_i <= 22'h3fffff))
        begin
          defslave_sel  = 1'b1;
          GPIO0_sel     = 1'b0;
          GPIO1_sel     = 1'b0;
          GPIO2_sel     = 1'b0;
          GPIO3_sel     = 1'b0;
          SYSCTRL_sel   = 1'b0;
        end
      //
      else
        begin
          defslave_sel  = 1'bx;
          GPIO0_sel     = 1'bx;
          GPIO1_sel     = 1'bx;
          GPIO2_sel     = 1'bx;
          GPIO3_sel     = 1'bx;
          SYSCTRL_sel   = 1'bx;
        end
    end
  end // block: HSEL_decoder

endmodule
