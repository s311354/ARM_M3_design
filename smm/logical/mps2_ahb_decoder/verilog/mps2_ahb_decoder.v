// -----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//               (C) COPYRIGHT 2015 ARM Limited.
//                   ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
// SVN Information
//
// Checked In : $Date: 2015-06-17 14:56:32 +0100 (Wed, 17 Jun 2015) $
// Revision : $Revision: 458 $
//
// Release Information : CM3DesignStart-r0p0-01rel0
//
// -----------------------------------------------------------------------------
// Verilog-2001 (IEEE Std 1364-2001)
// -----------------------------------------------------------------------------
// Purpose : beetle pheripherals subsystem AHB decoder and splitter
//
// -----------------------------------------------------------------------------

module mps2_ahb_decoder (
  input  wire         HSEL_i,
  input  wire [15:0]  decode_address_i,     //PERIPHHADDR[31:15]; lower 16 bits are not compared
  output wire         BEETLE_HSEL_o,        //beetle_peripheral
  output wire         DEFSLAVE_HSEL_o,      //default slave
  output wire         FPGA_HSEL_o,          //fpga_apb_subsystem
  output wire         MPS2_HSEL_o,          //mps2_external_subsystem
  input  wire         CFG_BOOT
);

  reg beetle_sel;
  reg defslave_sel;
  reg fpga_sel;
  reg mps2_sel;

  assign BEETLE_HSEL_o   = beetle_sel;
  assign DEFSLAVE_HSEL_o = defslave_sel;
  assign FPGA_HSEL_o     = fpga_sel;
  assign MPS2_HSEL_o     = mps2_sel;

  //------------------------------------
  //AHB decoder
  //------------------------------------
  /*------------------------------------
  localparam QSPI_AHB_ADDR_LOW  = 32'h0000_0000;
  localparam QSPI_AHB_ADDR_HIGH = 32'h0003_ffff;
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
  always @(HSEL_i or decode_address_i or CFG_BOOT)
  begin : HSEL_decoder
    if (HSEL_i == 1'b0) begin //HSEL_i = 0: dont select anything
      beetle_sel   = 1'b0;
      defslave_sel = 1'b0;
      fpga_sel     = 1'b0;
      mps2_sel     = 1'b0;
    end else begin
      if (
         // QSPI: Address region 0x00000000-0x0003ffff
        ((decode_address_i >= 16'h0000) & (decode_address_i < 16'h0004)) ||
         // QSPI: Address region 0x10000000-0x1003ffff
        (((decode_address_i >= 16'h1000) & (decode_address_i < 16'h1004)) & !CFG_BOOT) ||
        // Beetle Peripherals: Address region 0x40010000-0x4001FFFF
        ((decode_address_i >= 16'h4001) & (decode_address_i < 16'h4002))
        )
        begin
          beetle_sel   = 1'b1;
          defslave_sel = 1'b0;
          fpga_sel     = 1'b0;
          mps2_sel     = 1'b0;
        end
      // fpga_apb_subsystem: Address region 0x40020000-0x4002FFFF
      else if ((decode_address_i >= 16'h4002) & (decode_address_i < 16'h4003))
        begin
          beetle_sel   = 1'b0;
          defslave_sel = 1'b0;
          fpga_sel     = 1'b1;
          mps2_sel     = 1'b0;
        end
      else if (
        // MPS2 external peripherals: Address region 0x00400000-0x007FFFFF
        ((decode_address_i >= 16'h0040) & (decode_address_i < 16'h0080)) ||
        // MPS2 external peripherals: Address region 0x20020000-0x2041FFFF
        ((decode_address_i >= 16'h2040) & (decode_address_i < 16'h2080)) ||
        // MPS2 external peripherals: Address region 0x21000000-0x21FFFFFF
        ((decode_address_i >= 16'h2100) & (decode_address_i < 16'h2200)) ||
        // MPS2 external peripherals: Address region 0x40200000-0x402FFFFF
        ((decode_address_i >= 16'h4020) & (decode_address_i < 16'h4030)) ||
        // MPS2 external peripherals: Address region 0x41000000-0x4100FFFF
        ((decode_address_i >= 16'h4100) & (decode_address_i < 16'h4101)) ||
        // MPS2 external peripherals: Address region 0x41100000-0x4110FFFF
        ((decode_address_i >= 16'h4110) & (decode_address_i < 16'h4114)) ||
        // MPS2 external peripherals: Address region 0x40030000-0x4003FFFF
        ((decode_address_i >= 16'h4003) & (decode_address_i < 16'h4004))
        )
        begin
          beetle_sel   = 1'b0;
          defslave_sel = 1'b0;
          fpga_sel     = 1'b0;
          mps2_sel     = 1'b1;
        end
      else
        begin
          beetle_sel   = 1'b0;
          defslave_sel = 1'b1;
          fpga_sel     = 1'b0;
          mps2_sel     = 1'b0;
        end
    end
  end // block: HSEL_decoder

endmodule
