//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2013-2015 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2013-04-05 11:54:17 +0100 (Fri, 05 Apr 2013) $
//
//      Revision            : $Revision: 242973 $
//
//      Release Information : CM3DesignStart-r0p0-01rel0
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : SPI to AHB interface for V2M-MPS2 FPGA
//-----------------------------------------------------------------------------

module fpga_spi_ahb (
  input  wire        HCLK,
  input  wire        nPOR,
  input  wire        CONFIG_SPICLK,
  input  wire        CONFIG_SPIDI,
  output wire        CONFIG_SPIDO,

  // AHB connection to FPGA system
  output wire        HSELM,        // System select
  output wire [31:0] HADDRM,       // System address
  output wire  [1:0] HTRANSM,      // System transfer type
  output wire  [3:0] HMASTERM,     // System master
  output wire        HWRITEM,      // System write not read
  output wire  [2:0] HSIZEM,       // System transfer size
  output wire        HMASTLOCKM,   // System lock
  output wire [31:0] HWDATAM,      // System write data
  output wire  [2:0] HBURSTM,      // System burst length
  output wire  [3:0] HPROTM,       // System protection
  output wire  [1:0] MEMATTRM,     // System memory attributes
  output wire        EXREQM,       // System exclusive request
  input  wire        HREADYM,      // System ready
  input  wire [31:0] HRDATAM,      // System read data
  input  wire        HRESPM,       // System transfer response
  input  wire        EXRESPM       // System exclusive response
  );

  // SPI to APB bridge bus - allows MCU on board to access memories
  //                         via an APB interface, which also convert
  //                         to AHB for accessing ethernet, PSRAM, etc
  //    APB section
  wire    [31:0]  spi2mem_paddr;
  wire    [31:0]  spi2mem_pwdata;
  wire            spi2mem_psel;
  wire            spi2mem_penable;
  wire            spi2mem_pwrite;
  wire     [3:0]  spi2mem_pstrb;

  wire    [31:0]  spi2mem_prdata;
  wire            spi2mem_pready;

  // --------------------------------------------------------------------
  // SPI to APB, but no error response support
  // --------------------------------------------------------------------

   spi2apb3 u_spi2apb3(
    .SPICLK      (CONFIG_SPICLK),
    .SPIDI       (CONFIG_SPIDI),
    .SPIDO       (CONFIG_SPIDO),
  //APB
    .PRESETn     (nPOR),     // CB_nPOR with delay
    .PCLK        (HCLK),
    .PADDR       (spi2mem_paddr),
    .PSEL        (spi2mem_psel),
    .PENABLE     (spi2mem_penable),
    .PWRITE      (spi2mem_pwrite),
    .PSTRB       (spi2mem_pstrb),
    .PWDATA      (spi2mem_pwdata),
    .PRDATA      (spi2mem_prdata),
    .PREADY      (spi2mem_pready),
    .SPI_CFGDATA ()
    );

// APB to AHB - support word size only
assign HSELM      = spi2mem_psel;         // System select - Not requred in all configurations
assign HADDRM     = spi2mem_paddr;        // System address
assign HTRANSM    = (spi2mem_psel & ~spi2mem_penable) ? 2'b10: 2'b00; // System transfer type
assign HMASTERM   = 4'b0000;              // System master
assign HWRITEM    = spi2mem_pwrite;       // System write not read
assign HSIZEM     = 3'b010;               // System transfer size - Word size only
assign HMASTLOCKM = 1'b0;                 // System lock
assign HWDATAM    = spi2mem_pwdata;       // System write data
assign HBURSTM    = 3'b000;               // System burst length
assign HPROTM     = 4'hF;                 // System protection
assign MEMATTRM   = 2'b00;                // System memory attributes
assign EXREQM     = 1'b0;                 // System exclusive request

assign spi2mem_prdata = HRDATAM;  // System read data
assign spi2mem_pready = HREADYM;  // System ready
// HRESPM is ignored by the SPI master.

endmodule
