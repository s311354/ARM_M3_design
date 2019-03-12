//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2013 ARM Limited.
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
//      Revision            : $Revision: 365823 $
//
//      Release Information : CM3DesignStart-r0p0-02rel0
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : V2M-MPS2 FPGA APB subsystem
//-----------------------------------------------------------------------------

`include "fpga_options_defs.v"

module fpga_apb_subsystem #(
  // If peripherals are generated with asynchronous clock domain to HCLK of the processor
  // You might need to add synchroniser to the IRQ signal.
  // In this example APB subsystem, the IRQ synchroniser is used to all peripherals
  // when the INCLUDE_IRQ_SYNCHRONIZER parameter is set to 1. In practice you may have
  // some IRQ signals need to be synchronised and some do not.
  parameter  INCLUDE_IRQ_SYNCHRONIZER=0,
  parameter  INCLUDE_APB_UART2      = 1,  // Include simple UART #0
  parameter  INCLUDE_APB_UART3      = 1,  // Include simple UART #1
  parameter  INCLUDE_APB_UART4      = 1)  // Include simple UART #2.
 (
  input  wire          HCLK,
  input  wire          PCLKG,
`ifdef CLOCK_BRIDGES
  input wire           SCLK,                  // Peripheral clock
  input wire           SCLKG,                 // Gated PCLK for bus
`endif
  input  wire          HRESETN,               // NOTE: Can be reset by SYSRESETREQ, watchdog
  input  wire          FPGA_NPOR,
  input  wire          CLK_100HZ,

  input  wire          HSEL,
  input  wire  [15:0]  HADDR,
  input  wire   [1:0]  HTRANS,
  input  wire   [2:0]  HSIZE,
  input  wire   [3:0]  HPROT,
  input  wire          HWRITE,
  input  wire          HREADY,
  input  wire  [31:0]  HWDATA,
  output wire  [31:0]  HRDATA,
  output wire          HRESP,
  output wire          HREADYOUT,

  input  wire   [1:0]  BUTTONS,
  output wire   [1:0]  LEDS,
  output wire   [9:0]  FPGA_MISC,

  input  wire          SBCON_SDA_I0,
  output wire          SBCON_SCL0,
  output wire          SBCON_SDAOUTEN0_N,

  input  wire          SBCON_SDA_I1,
  output wire          SBCON_SCL1,
  output wire          SBCON_SDAOUTEN1_N,

  input  wire          SBCON_SDA_I2,
  output wire          SBCON_SCL2,
  output wire          SBCON_SDAOUTEN2_N,

  input  wire          SBCON_SDA_I3,
  output wire          SBCON_SCL3,
  output wire          SBCON_SDAOUTEN3_N,

  input  wire          SSP0_DIN,
  output wire          SSP0_DOUT,
  output wire          SSP0_DOUT_EN_n,
  input  wire          SSP0_CLK_IN,
  output wire          SSP0_CLK_OUT,
  output wire          SSP0_CLK_OUT_EN_n,
  input  wire          SSP0_FSS_IN,
  output wire          SSP0_FSS_OUT,

  input  wire          SSP1_DIN,
  output wire          SSP1_DOUT,
  output wire          SSP1_DOUT_EN_n,
  input  wire          SSP1_CLK_IN,
  output wire          SSP1_CLK_OUT,
  output wire          SSP1_CLK_OUT_EN_n,
  input  wire          SSP1_FSS_IN,
  output wire          SSP1_FSS_OUT,

  input  wire          SSP2_DIN,
  output wire          SSP2_DOUT,
  output wire          SSP2_DOUT_EN_n,
  input  wire          SSP2_CLK_IN,
  output wire          SSP2_CLK_OUT,
  output wire          SSP2_CLK_OUT_EN_n,
  input  wire          SSP2_FSS_IN,
  output wire          SSP2_FSS_OUT,

  input  wire          SSP3_DIN,
  output wire          SSP3_DOUT,
  output wire          SSP3_DOUT_EN_n,
  input  wire          SSP3_CLK_IN,
  output wire          SSP3_CLK_OUT,
  output wire          SSP3_CLK_OUT_EN_n,
  input  wire          SSP3_FSS_IN,
  output wire          SSP3_FSS_OUT,

  input  wire          SSP4_DIN,
  output wire          SSP4_DOUT,
  output wire          SSP4_DOUT_EN_n,
  input  wire          SSP4_CLK_IN,
  output wire          SSP4_CLK_OUT,
  output wire          SSP4_CLK_OUT_EN_n,
  input  wire          SSP4_FSS_IN,
  output wire          SSP4_FSS_OUT,

  input  wire          AUDIO_MCLK,            // Audio codec master clock (12.288MHz)
  input  wire          AUDIO_SCLK,            // Audio interface bit clock
  output wire          AUDIO_LRCK,            // Audio Left/Right clock
  output wire          AUDIO_SDOUT,           // Audio DAC data
  input  wire          AUDIO_SDIN,            // Audio ADC data
  output wire          AUDIO_NRST,            // Audio reset

  input  wire          UART2_RXD,
  output wire          UART2_TXD,
  output wire          UART2_TXEN,

  input  wire          UART3_RXD,
  output wire          UART3_TXD,
  output wire          UART3_TXEN,

  input  wire          UART4_RXD,
  output wire          UART4_TXD,
  output wire          UART4_TXEN,

  output wire          spi_interrupt_o,
  output wire          spi0_interrupt_o,
  output wire          spi1_interrupt_o,
  output wire          spi2_interrupt_o,
  output wire          spi3_interrupt_o,
  output wire          spi4_interrupt_o,
  output wire  [11:0]  UART_INTERRUPTS,
  output wire          I2S_INTERRUPT,
  output wire          CFGINT,

  input  wire          CFGCLK,
  input  wire          nCFGRST,
  input  wire          CFGLOAD,
  input  wire          CFGWnR,
  input  wire          CFGDATAIN,
  output wire          CFGDATAOUT,
  input  wire   [7:0]  DLL_LOCKED,
  output wire  [31:0]  EFUSES,
  output wire   [2:0]  TEST_CTRL
  );


  // --------------------------------------------------------------------------
  // Internal wires
  // --------------------------------------------------------------------------

  wire     [15:0]  i_paddr;
  wire             i_psel;
  wire             i_penable;
  wire             i_pwrite;
  wire     [2:0]   i_pprot;
  wire     [3:0]   i_pstrb;
  wire     [31:0]  i_pwdata;

  // wire from APB slave mux to APB bridge
  wire             i_pready_mux;
  wire     [31:0]  i_prdata_mux;
  wire             i_pslverr_mux;
  wire             PCLKEN;
  wire             APBACTIVE;

  wire             i_psel_fpga_io_regs;
  wire             i_pready_fpga_io_regs;
  wire     [31:0]  i_prdata_fpga_io_regs;
  wire             i_pslverr_fpga_io_regs;

  wire             i_psel_sbcon0;
  wire             i_pready_sbcon0;
  wire     [31:0]  i_prdata_sbcon0;
  wire             i_pslverr_sbcon0;

  wire             i_psel_sbcon1;
  wire             i_pready_sbcon1;
  wire     [31:0]  i_prdata_sbcon1;
  wire             i_pslverr_sbcon1;

  wire             i_psel_sbcon2;
  wire             i_pready_sbcon2;
  wire     [31:0]  i_prdata_sbcon2;
  wire             i_pslverr_sbcon2;

  wire             i_psel_sbcon3;
  wire             i_pready_sbcon3;
  wire     [31:0]  i_prdata_sbcon3;
  wire             i_pslverr_sbcon3;

  wire             i_psel_ssp0;
  wire             i_pready_ssp0;
  wire     [31:0]  i_prdata_ssp0;
  wire             i_pslverr_ssp0;

  wire             i_psel_ssp1;
  wire             i_pready_ssp1;
  wire     [31:0]  i_prdata_ssp1;
  wire             i_pslverr_ssp1;

  wire             i_psel_ssp2;
  wire             i_pready_ssp2;
  wire     [31:0]  i_prdata_ssp2;
  wire             i_pslverr_ssp2;

  wire             i_psel_ssp3;
  wire             i_pready_ssp3;
  wire     [31:0]  i_prdata_ssp3;
  wire             i_pslverr_ssp3;

  wire             i_psel_ssp4;
  wire             i_pready_ssp4;
  wire     [31:0]  i_prdata_ssp4;
  wire             i_pslverr_ssp4;


  wire             i_psel_i2s0;
  wire             i_pready_i2s0;
  wire     [31:0]  i_prdata_i2s0;
  wire             i_pslverr_i2s0;

  wire             uart2_psel;
  wire     [31:0]  uart2_prdata;
  wire             uart2_pready;
  wire             uart2_pslverr;

  wire             uart3_psel;
  wire     [31:0]  uart3_prdata;
  wire             uart3_pready;
  wire             uart3_pslverr;

  wire             uart4_psel;
  wire     [31:0]  uart4_prdata;
  wire             uart4_pready;
  wire             uart4_pslverr;

  wire [31:0]      i_prdata_scc;
  wire             i_pel_scc;


  wire             i2s_rstn;   // reset for I2S interface in MCLK domain

  wire [255:0]     cfgreg_out;

  assign   PCLKEN = 1'b1;
  wire             spi0_interrupt;
  wire             spi1_interrupt;
  wire             spi2_interrupt;
  wire             spi3_interrupt;
  wire             spi4_interrupt;

  // Synchronized interrupt signals
  wire             uart2_txint;
  wire             uart2_rxint;
  wire             uart2_txovrint;
  wire             uart2_rxovrint;
  wire             uart2_combined_int;

  wire             uart3_txint;
  wire             uart3_rxint;
  wire             uart3_txovrint;
  wire             uart3_rxovrint;
  wire             uart3_combined_int;

  wire             uart4_txint;
  wire             uart4_rxint;
  wire             uart4_txovrint;
  wire             uart4_rxovrint;
  wire             uart4_combined_int;

  wire             uart2_overflow_int;
  wire             uart3_overflow_int;
  wire             uart4_overflow_int;

  wire             i_uart2_txint;
  wire             i_uart2_rxint;
  wire             i_uart2_txovrint;
  wire             i_uart2_rxovrint;
  wire             i_uart2_overflow_int;
  wire             i_uart3_txint;
  wire             i_uart3_rxint;
  wire             i_uart3_txovrint;
  wire             i_uart3_rxovrint;
  wire             i_uart3_overflow_int;
  wire             i_uart4_txint;
  wire             i_uart4_rxint;
  wire             i_uart4_txovrint;
  wire             i_uart4_rxovrint;
  wire             i_uart4_overflow_int;


  //--------------------------------------------------------------------
  // AHB to APB bus bridge
  cmsdk_ahb_to_apb
  #(.ADDRWIDTH (16))
  u_ahb_to_apb(
    // AHB side
    .HCLK     (HCLK),
    .HRESETn  (HRESETN),
    .HSEL     (HSEL),
    .HADDR    (HADDR[15:0]),
    .HTRANS   (HTRANS),
    .HSIZE    (HSIZE[2:0]),
    .HPROT    (HPROT),
    .HWRITE   (HWRITE),
    .HREADY   (HREADY),
    .HWDATA   (HWDATA),

    .HREADYOUT(HREADYOUT), // AHB Outputs
    .HRDATA   (HRDATA),
    .HRESP    (HRESP),

    .PADDR    (i_paddr[15:0]),
    .PSEL     (i_psel),
    .PENABLE  (i_penable),
    .PSTRB    (i_pstrb),
    .PPROT    (i_pprot),
    .PWRITE   (i_pwrite),
    .PWDATA   (i_pwdata),

    .APBACTIVE(APBACTIVE),
    .PCLKEN   (PCLKEN),     // APB clock enable signal

    .PRDATA   (i_prdata_mux),
    .PREADY   (i_pready_mux),
    .PSLVERR  (i_pslverr_mux)
    );

  //--------------------------------------------------------------------
  // APB slave multiplexer
  cmsdk_apb_slave_mux
    #( // Parameter to determine which ports are used
    .PORT0_ENABLE  (1), // SPI
    .PORT1_ENABLE  (1), // SPI
    .PORT2_ENABLE  (1), // SBCon
    .PORT3_ENABLE  (1), // SBCon
    .PORT4_ENABLE  (1), // Audio I2S
    .PORT5_ENABLE  (1), // SPI ADC
    .PORT6_ENABLE  (1), // SPI Shield 0
    .PORT7_ENABLE  (1), // SPI Shield 1
    .PORT8_ENABLE  (1), // FPGA I/O regs
    .PORT9_ENABLE  (1), // SBCon Shield 0
    .PORT10_ENABLE (1), // SBCon Shield 1
    .PORT11_ENABLE (0), //
    .PORT12_ENABLE (1), // uart 2
    .PORT13_ENABLE (1), // uart 3
    .PORT14_ENABLE (1), // uart 4
    .PORT15_ENABLE (1)  //SCC
    )
    u_apb_slave_mux (
    // Inputs
    .DECODE4BIT        (i_paddr[15:12]),
    .PSEL              (i_psel),
    // PSEL (output) and return status & data (inputs) for each port
    .PSEL0             (i_psel_ssp0),
    .PREADY0           (i_pready_ssp0),
    .PRDATA0           (i_prdata_ssp0),
    .PSLVERR0          (i_pslverr_ssp0),

    .PSEL1             (i_psel_ssp1),
    .PREADY1           (i_pready_ssp1),
    .PRDATA1           (i_prdata_ssp1),
    .PSLVERR1          (i_pslverr_ssp1),

    .PSEL2             (i_psel_sbcon0),
    .PREADY2           (i_pready_sbcon0),
    .PRDATA2           (i_prdata_sbcon0),
    .PSLVERR2          (i_pslverr_sbcon0),

    .PSEL3             (i_psel_sbcon1),
    .PREADY3           (i_pready_sbcon1),
    .PRDATA3           (i_prdata_sbcon1),
    .PSLVERR3          (i_pslverr_sbcon1),

    .PSEL4             (i_psel_i2s0),
    .PREADY4           (i_pready_i2s0),
    .PRDATA4           (i_prdata_i2s0),
    .PSLVERR4          (i_pslverr_i2s0),

    .PSEL5             (i_psel_ssp2),
    .PREADY5           (i_pready_ssp2),
    .PRDATA5           (i_prdata_ssp2),
    .PSLVERR5          (i_pslverr_ssp2),

    .PSEL6             (i_psel_ssp3),
    .PREADY6           (i_pready_ssp3),
    .PRDATA6           (i_prdata_ssp3),
    .PSLVERR6          (i_pslverr_ssp3),

    .PSEL7             (i_psel_ssp4),
    .PREADY7           (i_pready_ssp4),
    .PRDATA7           (i_prdata_ssp4),
    .PSLVERR7          (i_pslverr_ssp4),

    .PSEL8             (i_psel_fpga_io_regs),
    .PREADY8           (i_pready_fpga_io_regs),
    .PRDATA8           (i_prdata_fpga_io_regs),
    .PSLVERR8          (i_pslverr_fpga_io_regs),

    .PSEL9             (i_psel_sbcon2),
    .PREADY9           (i_pready_sbcon2),
    .PRDATA9           (i_prdata_sbcon2),
    .PSLVERR9          (i_pslverr_sbcon2),

    .PSEL10            (i_psel_sbcon3),
    .PREADY10          (i_pready_sbcon3),
    .PRDATA10          (i_prdata_sbcon3),
    .PSLVERR10         (i_pslverr_sbcon3),

    .PSEL11            (),
    .PREADY11          (1'b1),
    .PRDATA11          (32'h00000000),
    .PSLVERR11         (1'b0),

    .PSEL12            (uart2_psel),
    .PREADY12          (uart2_pready),
    .PRDATA12          (uart2_prdata),
    .PSLVERR12         (uart2_pslverr),

    .PSEL13            (uart3_psel),
    .PREADY13          (uart3_pready),
    .PRDATA13          (uart3_prdata),
    .PSLVERR13         (uart3_pslverr),

    .PSEL14            (uart4_psel),
    .PREADY14          (uart4_pready),
    .PRDATA14          (uart4_prdata),
    .PSLVERR14         (uart4_pslverr),

    .PSEL15            (i_pel_scc),
    .PREADY15          (1'b1),
    .PRDATA15          (i_prdata_scc),
    .PSLVERR15         (1'b0),

    // Output
    .PREADY            (i_pready_mux),
    .PRDATA            (i_prdata_mux),
    .PSLVERR           (i_pslverr_mux)
    );




  //--------------------------------------------------------------------
  //
  fpga_io_regs_shield u_fpga_io_regs (
    .PORESETn          (FPGA_NPOR),
    .PCLK              (HCLK),
    .PRESETn           (HRESETN),
    .PSEL              (i_psel_fpga_io_regs),
    .PADDR             (i_paddr[11:2]),
    .PENABLE           (i_penable),
    .PWRITE            (i_pwrite),
    .PWDATA            (i_pwdata[31:0]),
    .PRDATA            (i_prdata_fpga_io_regs[31:0]),
    .PREADY            (i_pready_fpga_io_regs),
    .PSLVERR           (i_pslverr_fpga_io_regs),

    .clk_100hz         (CLK_100HZ),
    .buttons           (BUTTONS),
    .leds              (LEDS),

    .fpga_misc         (FPGA_MISC)
  );


  // ----------------------------------------
  // SPI Header
  Ssp u_ssp_0 (
            // Inputs
            .PCLK           (HCLK),
            .SSPCLK         (HCLK),

            .PRESETn        (HRESETN),
            .nSSPRST        (HRESETN),

            .PSEL           (i_psel_ssp0),
            .PENABLE        (i_penable),
            .PWRITE         (i_pwrite),

            // - Frame clock. This is acting as master so Clock in not used
            .SSPCLKIN       (SSP0_CLK_IN),
            // - Frame Select Signal(s).  This is the Master so FSSIN is tied low.
            .SSPFSSIN       (SSP0_FSS_IN),
            // - Frame data in
            .SSPRXD         (SSP0_DIN),

            .SCANENABLE     (1'b0),
            .SCANINPCLK     (1'b0),
            .SCANINSSPCLK   (1'b0),

            .PADDR          (i_paddr[11:2]),

            .PWDATA         (i_pwdata[15:0]),

            .SSPTXDMACLR    (1'b0),
            .SSPRXDMACLR    (1'b0),
            // Outputs
            .SSPINTR        (spi0_interrupt),
            .SSPRXINTR      (),
            .SSPTXINTR      (),
            .SSPRORINTR     (),
            .SSPRTINTR      (),

            .SSPFSSOUT      (SSP0_FSS_OUT),
            .SSPCLKOUT      (SSP0_CLK_OUT),
            .nSSPCTLOE      (SSP0_CLK_OUT_EN_n),

            .SCANOUTPCLK    (),
            .SCANOUTSSPCLK  (),

            .SSPTXD         (SSP0_DOUT),
            .nSSPOE         (SSP0_DOUT_EN_n),


            .PRDATA         (i_prdata_ssp0[15:0]),

            .SSPTXDMASREQ   (),
            .SSPTXDMABREQ   (),
            .SSPRXDMASREQ   (),
            .SSPRXDMABREQ   ()
           );

  assign i_pready_ssp0  = 1'b1;
  assign i_pslverr_ssp0 = 1'b0;
  assign i_prdata_ssp0[31:16] = {16{1'b0}};

  // ----------------------------------------
  // SPI LCD
    Ssp u_ssp_1 (
            // Inputs
            .PCLK           (HCLK),
            .SSPCLK         (HCLK),

            .PRESETn        (HRESETN),
            .nSSPRST        (HRESETN),

            .PSEL           (i_psel_ssp1),
            .PENABLE        (i_penable),
            .PWRITE         (i_pwrite),

            // - Frame clock. This is acting as master so Clock in not used
            .SSPCLKIN       (SSP1_CLK_IN),
            // - Frame Select Signal(s).  This is the Master so FSSIN is tied low.
            .SSPFSSIN       (SSP1_FSS_IN),
            // - Frame data in
            .SSPRXD         (SSP1_DIN),

            .SCANENABLE     (1'b0),
            .SCANINPCLK     (1'b0),
            .SCANINSSPCLK   (1'b0),

            .PADDR          (i_paddr[11:2]),

            .PWDATA         (i_pwdata[15:0]),

            .SSPTXDMACLR    (1'b0),
            .SSPRXDMACLR    (1'b0),
            // Outputs
            .SSPINTR        (spi1_interrupt),
            .SSPRXINTR      (),
            .SSPTXINTR      (),
            .SSPRORINTR     (),
            .SSPRTINTR      (),

            .SSPFSSOUT      (SSP1_FSS_OUT),
            .SSPCLKOUT      (SSP1_CLK_OUT),
            .nSSPCTLOE      (SSP1_CLK_OUT_EN_n),

            .SCANOUTPCLK    (),
            .SCANOUTSSPCLK  (),

            .SSPTXD         (SSP1_DOUT),
            .nSSPOE         (SSP1_DOUT_EN_n),


            .PRDATA         (i_prdata_ssp1[15:0]),

            .SSPTXDMASREQ   (),
            .SSPTXDMABREQ   (),
            .SSPRXDMASREQ   (),
            .SSPRXDMABREQ   ()
           );

  assign i_pready_ssp1  = 1'b1;
  assign i_pslverr_ssp1 = 1'b0;
  assign i_prdata_ssp1[31:16] = {16{1'b0}};

  assign spi_interrupt_o = spi0_interrupt || spi1_interrupt || spi2_interrupt || spi3_interrupt || spi4_interrupt;
  assign spi0_interrupt_o = spi0_interrupt;
  assign spi1_interrupt_o = spi1_interrupt;
  assign spi2_interrupt_o = spi2_interrupt;
  assign spi3_interrupt_o = spi3_interrupt;
  assign spi4_interrupt_o = spi4_interrupt;


  // ----------------------------------------
  // Adapter Board ADC SPI
    Ssp u_ssp_2 (
            // Inputs
            .PCLK           (HCLK),
            .SSPCLK         (HCLK),

            .PRESETn        (HRESETN),
            .nSSPRST        (HRESETN),

            .PSEL           (i_psel_ssp2),
            .PENABLE        (i_penable),
            .PWRITE         (i_pwrite),

            // - Frame clock. This is acting as master so Clock in not used
            .SSPCLKIN       (SSP2_CLK_IN),
            // - Frame Select Signal(s).  This is the Master so FSSIN is tied low.
            .SSPFSSIN       (SSP2_FSS_IN),
            // - Frame data in
            .SSPRXD         (SSP2_DIN),

            .SCANENABLE     (1'b0),
            .SCANINPCLK     (1'b0),
            .SCANINSSPCLK   (1'b0),

            .PADDR          (i_paddr[11:2]),

            .PWDATA         (i_pwdata[15:0]),

            .SSPTXDMACLR    (1'b0),
            .SSPRXDMACLR    (1'b0),
            // Outputs
            .SSPINTR        (spi2_interrupt),
            .SSPRXINTR      (),
            .SSPTXINTR      (),
            .SSPRORINTR     (),
            .SSPRTINTR      (),

            .SSPFSSOUT      (SSP2_FSS_OUT),
            .SSPCLKOUT      (SSP2_CLK_OUT),
            .nSSPCTLOE      (SSP2_CLK_OUT_EN_n),

            .SCANOUTPCLK    (),
            .SCANOUTSSPCLK  (),

            .SSPTXD         (SSP2_DOUT),
            .nSSPOE         (SSP2_DOUT_EN_n),

            .PRDATA         (i_prdata_ssp2[15:0]),

            .SSPTXDMASREQ   (),
            .SSPTXDMABREQ   (),
            .SSPRXDMASREQ   (),
            .SSPRXDMABREQ   ()
           );

  assign i_pready_ssp2  = 1'b1;
  assign i_pslverr_ssp2 = 1'b0;
  assign i_prdata_ssp2[31:16] = {16{1'b0}};


    // ----------------------------------------
    // Adapter Board SHIELD_0 SPI
      Ssp u_ssp_3 (
              // Inputs
              .PCLK           (HCLK),
              .SSPCLK         (HCLK),

              .PRESETn        (HRESETN),
              .nSSPRST        (HRESETN),

              .PSEL           (i_psel_ssp3),
              .PENABLE        (i_penable),
              .PWRITE         (i_pwrite),

              // - Frame clock. This is acting as master so Clock in not used
              .SSPCLKIN       (SSP3_CLK_IN),
              // - Frame Select Signal(s).  This is the Master so FSSIN is tied low.
              .SSPFSSIN       (SSP3_FSS_IN),
              // - Frame data in
              .SSPRXD         (SSP3_DIN),

              .SCANENABLE     (1'b0),
              .SCANINPCLK     (1'b0),
              .SCANINSSPCLK   (1'b0),

              .PADDR          (i_paddr[11:2]),

              .PWDATA         (i_pwdata[15:0]),

              .SSPTXDMACLR    (1'b0),
              .SSPRXDMACLR    (1'b0),
              // Outputs
              .SSPINTR        (spi3_interrupt),
              .SSPRXINTR      (),
              .SSPTXINTR      (),
              .SSPRORINTR     (),
              .SSPRTINTR      (),

              .SSPFSSOUT      (SSP3_FSS_OUT),
              .SSPCLKOUT      (SSP3_CLK_OUT),
              .nSSPCTLOE      (SSP3_CLK_OUT_EN_n),

              .SCANOUTPCLK    (),
              .SCANOUTSSPCLK  (),

              .SSPTXD         (SSP3_DOUT),
              .nSSPOE         (SSP3_DOUT_EN_n),

              .PRDATA         (i_prdata_ssp3[15:0]),

              .SSPTXDMASREQ   (),
              .SSPTXDMABREQ   (),
              .SSPRXDMASREQ   (),
              .SSPRXDMABREQ   ()
             );

  assign i_pready_ssp3  = 1'b1;
  assign i_pslverr_ssp3 = 1'b0;
  assign i_prdata_ssp3[31:16] = {16{1'b0}};


    // ----------------------------------------
    // Adapter Board SHIELD_1 SPI
      Ssp u_ssp_4 (
              // Inputs
              .PCLK           (HCLK),
              .SSPCLK         (HCLK),

              .PRESETn        (HRESETN),
              .nSSPRST        (HRESETN),

              .PSEL           (i_psel_ssp4),
              .PENABLE        (i_penable),
              .PWRITE         (i_pwrite),

              // - Frame clock. This is acting as master so Clock in not used
              .SSPCLKIN       (SSP4_CLK_IN),
              // - Frame Select Signal(s).  This is the Master so FSSIN is tied low.
              .SSPFSSIN       (SSP4_FSS_IN),
              // - Frame data in
              .SSPRXD         (SSP4_DIN),

              .SCANENABLE     (1'b0),
              .SCANINPCLK     (1'b0),
              .SCANINSSPCLK   (1'b0),

              .PADDR          (i_paddr[11:2]),

              .PWDATA         (i_pwdata[15:0]),

              .SSPTXDMACLR    (1'b0),
              .SSPRXDMACLR    (1'b0),
              // Outputs
              .SSPINTR        (spi4_interrupt),
              .SSPRXINTR      (),
              .SSPTXINTR      (),
              .SSPRORINTR     (),
              .SSPRTINTR      (),

              .SSPFSSOUT      (SSP4_FSS_OUT),
              .SSPCLKOUT      (SSP4_CLK_OUT),
              .nSSPCTLOE      (SSP4_CLK_OUT_EN_n),

              .SCANOUTPCLK    (),
              .SCANOUTSSPCLK  (),

              .SSPTXD         (SSP4_DOUT),
              .nSSPOE         (SSP4_DOUT_EN_n),

              .PRDATA         (i_prdata_ssp4[15:0]),

              .SSPTXDMASREQ   (),
              .SSPTXDMABREQ   (),
              .SSPRXDMASREQ   (),
              .SSPRXDMABREQ   ()
             );

    assign i_pready_ssp4  = 1'b1;
    assign i_pslverr_ssp4 = 1'b0;
    assign i_prdata_ssp4[31:16] = {16{1'b0}};

  // ----------------------------------------
  // I2C LCD
  SBCon u_sbcon0
  (
  // Inputs
    .PCLK     (HCLK),           //-- APB bus clock
    .PRESETn  (HRESETN),        //-- APB bus reset
    .PSEL     (i_psel_sbcon0),  //-- APB device select
    .PENABLE  (i_penable),      //-- identifies APB active cycle
    .PWRITE   (i_pwrite),       //-- APB address
    .PADDR    (i_paddr[7:2]),   //-- APB transfer direction
    .PWDATA   (i_pwdata[31:0]), //-- APB write data
    .SDA      (SBCON_SDA_I0),
  // Outputs
    .PRDATA   (i_prdata_sbcon0),
    .SCL      (SBCON_SCL0),
    .SDAOUTEN_n(SBCON_SDAOUTEN0_N)
    );

  assign i_pslverr_sbcon0 = 1'b0;
  assign i_pready_sbcon0  = 1'b1;

  // ----------------------------------------
  // I2C Audio
  SBCon u_sbcon1
  (
  // Inputs
    .PCLK     (HCLK),           //-- APB bus clock
    .PRESETn  (HRESETN),        //-- APB bus reset
    .PSEL     (i_psel_sbcon1),  //-- APB device select
    .PENABLE  (i_penable),      //-- identifies APB active cycle
    .PWRITE   (i_pwrite),       //-- APB address
    .PADDR    (i_paddr[7:2]),   //-- APB transfer direction
    .PWDATA   (i_pwdata[31:0]), //-- APB write data
    .SDA      (SBCON_SDA_I1),
  // Outputs
    .PRDATA   (i_prdata_sbcon1),
    .SCL      (SBCON_SCL1),
    .SDAOUTEN_n(SBCON_SDAOUTEN1_N)
    );

  assign i_pslverr_sbcon1 = 1'b0;
  assign i_pready_sbcon1  = 1'b1;

    // ----------------------------------------
    // I2C Shield0
    SBCon u_sbcon2
    (
    // Inputs
      .PCLK     (HCLK),           //-- APB bus clock
      .PRESETn  (HRESETN),        //-- APB bus reset
      .PSEL     (i_psel_sbcon2),  //-- APB device select
      .PENABLE  (i_penable),      //-- identifies APB active cycle
      .PWRITE   (i_pwrite),       //-- APB address
      .PADDR    (i_paddr[7:2]),   //-- APB transfer direction
      .PWDATA   (i_pwdata[31:0]), //-- APB write data
      .SDA      (SBCON_SDA_I2),
    // Outputs
      .PRDATA   (i_prdata_sbcon2),
      .SCL      (SBCON_SCL2),
      .SDAOUTEN_n(SBCON_SDAOUTEN2_N)
      );

    assign i_pslverr_sbcon2 = 1'b0;
    assign i_pready_sbcon2  = 1'b1;


// ----------------------------------------
    // I2C Shield1
    SBCon u_sbcon3
    (
    // Inputs
      .PCLK     (HCLK),           //-- APB bus clock
      .PRESETn  (HRESETN),        //-- APB bus reset
      .PSEL     (i_psel_sbcon3),  //-- APB device select
      .PENABLE  (i_penable),      //-- identifies APB active cycle
      .PWRITE   (i_pwrite),       //-- APB address
      .PADDR    (i_paddr[7:2]),   //-- APB transfer direction
      .PWDATA   (i_pwdata[31:0]), //-- APB write data
      .SDA      (SBCON_SDA_I3),
    // Outputs
      .PRDATA   (i_prdata_sbcon3),
      .SCL      (SBCON_SCL3),
      .SDAOUTEN_n(SBCON_SDAOUTEN3_N)
      );

    assign i_pslverr_sbcon3 = 1'b0;
    assign i_pready_sbcon3  = 1'b1;

  // Reset synchroniser
  fpga_rst_sync u_fpga_rst_sync  (
    .clk          (AUDIO_SCLK),
    .rst_n_in     (HRESETN),
    .rst_request  (1'b0),
    .rst_n_out    (i2s_rstn)
    );

  apb_i2s_top u_apb_i2s_top (
    .MCLK         (AUDIO_MCLK),   // Audio interface master clock (e.g. 12.88MHz)
    .MRSTn        (i2s_rstn),     // Audio interface reset
    .LRCK         (AUDIO_LRCK),   // Left Right Clock
    .SDOUT        (AUDIO_SDOUT),  // Audio Data Out
    .SDIN         (AUDIO_SDIN),   // Audio Data In
    .SCLK         (AUDIO_SCLK),   // Audio Serial Clock
    .AUD_nRESET   (AUDIO_NRST),   // Audio codec reset

    .PCLK         (HCLK),
    .PRESETn      (HRESETN),
    .PADDR        (i_paddr[11:2]),
    .PSEL         (i_psel_i2s0),
    .PENABLE      (i_penable),
    .PWRITE       (i_pwrite),
    .PWDATA       (i_pwdata[31:0]),
    .PRDATA       (i_prdata_i2s0),

    .IRQOUT       (I2S_INTERRUPT)
  );

  assign i_pready_i2s0  = 1'b1;
  assign i_pslverr_i2s0 = 1'b0;


  generate if (INCLUDE_APB_UART2 == 1) begin : gen_apb_uart_2
  wire [31:0]   i_2_paddr_ext;
  wire [31:0]   i_2_paddr_ext_25;
  wire [31:0]   i_2_pwdata_25;
  wire          i_2_pwrite_25;
  wire          i_2_penable_25;
  wire          uart2_psel_25;
  wire [31:0]   uart2_prdata_25;
  wire          uart2_pslverr_25;
  wire          uart2_pready_25;


  assign i_2_paddr_ext[31:12] = 20'b0;
  assign i_2_paddr_ext[11:2] = i_paddr[11:2];
  assign i_2_paddr_ext[1:0] = 2'b0;
`ifdef CLOCK_BRIDGES
  cxapbasyncbridge u_apb_bridge_async_2 (
    // Slave Interface
    //Clock and reset signals
    .pclkens    (1'b1),
    .pclks      (HCLK),
    .presetsn   (HRESETN),
    // APB3 Bus
    .paddrs     (i_2_paddr_ext),
    .pwdatas    (i_pwdata),
    .pwrites    (i_pwrite),
    .penables   (i_penable),
    .psels      (uart2_psel),
    .prdatas    (uart2_prdata),
    .pslverrs   (uart2_pslverr),
    .preadys    (uart2_pready),
    // Master Interface
    // Clock and reset signals
    .pclkenm    (1'b1),
    .pclkm      (SCLK),
    .presetmn   (HRESETN),
    // APB3 Bus
    .paddrm     (i_2_paddr_ext_25),
    .pwdatam    (i_2_pwdata_25),
    .pwritem    (i_2_pwrite_25),
    .penablem   (i_2_penable_25),
    .pselm      (uart2_psel_25),
    .prdatam    (uart2_prdata_25),
    .pslverrm   (uart2_pslverr_25),
    .preadym    (uart2_pready_25)
    );
`else
assign i_2_paddr_ext_25 = i_2_paddr_ext;
assign i_2_pwdata_25 = i_pwdata;
assign i_2_pwrite_25 = i_pwrite;
assign i_2_penable_25 = i_penable;
assign uart2_psel_25 = uart2_psel;

assign uart2_prdata = uart2_prdata_25;
assign uart2_pslverr = uart2_pslverr_25;
assign uart2_pready = uart2_pready_25;
`endif

  cmsdk_apb_uart u_apb_uart_2 (
`ifdef CLOCK_BRIDGES
    .PCLK              (SCLK),     // Peripheral clock
    .PCLKG             (SCLKG),    // Gated PCLK for bus
`else
    .PCLK              (HCLK),     // Peripheral clock
    .PCLKG             (PCLKG),    // Gated PCLK for bus
`endif
    .PRESETn           (HRESETN),  // Reset

    .PSEL              (uart2_psel_25),     // APB interface inputs
    .PADDR             (i_2_paddr_ext_25[11:2]),
    .PENABLE           (i_2_penable_25),
    .PWRITE            (i_2_pwrite_25),
    .PWDATA            (i_2_pwdata_25),

    .PRDATA            (uart2_prdata_25),   // APB interface outputs
    .PREADY            (uart2_pready_25),
    .PSLVERR           (uart2_pslverr_25),

    .ECOREVNUM         (4'h0),// Engineering-change-order revision bits

    .RXD               (UART2_RXD),      // Receive data

    .TXD               (UART2_TXD),      // Transmit data
    .TXEN              (UART2_TXEN),     // Transmit Enabled

    .BAUDTICK          (),   // Baud rate x16 tick output (for testing)

    .TXINT             (uart2_txint),       // Transmit Interrupt
    .RXINT             (uart2_rxint),       // Receive  Interrupt
    .TXOVRINT          (uart2_txovrint),    // Transmit Overrun Interrupt
    .RXOVRINT          (uart2_rxovrint),    // Receive  Overrun Interrupt
    .UARTINT           (uart2_combined_int) // Combined Interrupt
  );
  end else
  begin : gen_no_apb_uart_2
    assign uart2_prdata  = {32{1'b0}};
    assign uart2_pready  = 1'b1;
    assign uart2_pslverr = 1'b0;
    assign UART2_TXD     = 1'b1;
    assign UART2_TXEN    = 1'b0;
    assign uart2_txint   = 1'b0;
    assign uart2_rxint   = 1'b0;
    assign uart2_txovrint = 1'b0;
    assign uart2_rxovrint = 1'b0;
    assign uart2_combined_int = 1'b0;
  end endgenerate


generate if (INCLUDE_APB_UART3 == 1) begin : gen_apb_uart_3
  wire [31:0]   i_3_paddr_ext;
  wire [31:0]   i_3_paddr_ext_25;
  wire [31:0]   i_3_pwdata_25;
  wire          i_3_pwrite_25;
  wire          i_3_penable_25;
  wire          uart3_psel_25;
  wire [31:0]   uart3_prdata_25;
  wire          uart3_pslverr_25;
  wire          uart3_pready_25;


  assign i_3_paddr_ext[31:12] = 20'b0;
  assign i_3_paddr_ext[11:2] = i_paddr[11:2];
  assign i_3_paddr_ext[1:0] = 2'b0;

`ifdef CLOCK_BRIDGES
  cxapbasyncbridge u_apb_bridge_async_3 (
    // Slave Interface
    //Clock and reset signals
    .pclkens    (1'b1),
    .pclks      (HCLK),
    .presetsn   (HRESETN),
    //APB3 Bus
    .paddrs     (i_3_paddr_ext),
    .pwdatas    (i_pwdata),
    .pwrites    (i_pwrite),
    .penables   (i_penable),
    .psels      (uart3_psel),
    .prdatas    (uart3_prdata),
    .pslverrs   (uart3_pslverr),
    .preadys    (uart3_pready),
    // Master Interface
    //Clock and reset signals
    .pclkenm    (1'b1),
    .pclkm      (SCLK),
    .presetmn   (HRESETN),
    //APB3 Bus
    .paddrm     (i_3_paddr_ext_25),
    .pwdatam    (i_3_pwdata_25),
    .pwritem    (i_3_pwrite_25),
    .penablem   (i_3_penable_25),
    .pselm      (uart3_psel_25),
    .prdatam    (uart3_prdata_25),
    .pslverrm   (uart3_pslverr_25),
    .preadym    (uart3_pready_25)
    );
`else
assign i_3_paddr_ext_25 = i_3_paddr_ext;
assign i_3_pwdata_25 = i_pwdata;
assign i_3_pwrite_25 = i_pwrite;
assign i_3_penable_25 = i_penable;
assign uart3_psel_25 = uart3_psel;

assign uart3_prdata = uart3_prdata_25;
assign uart3_pslverr = uart3_pslverr_25;
assign uart3_pready = uart3_pready_25;
`endif

  cmsdk_apb_uart u_apb_uart_3 (
`ifdef CLOCK_BRIDGES
    .PCLK              (SCLK),     // Peripheral clock
    .PCLKG             (SCLKG),    // Gated PCLK for bus
`else
    .PCLK              (HCLK),     // Peripheral clock
    .PCLKG             (PCLKG),    // Gated PCLK for bus
`endif
    .PRESETn           (HRESETN),  // Reset

    .PSEL              (uart3_psel_25),     // APB interface inputs
    .PADDR             (i_3_paddr_ext_25[11:2]),
    .PENABLE           (i_3_penable_25),
    .PWRITE            (i_3_pwrite_25),
    .PWDATA            (i_3_pwdata_25),

    .PRDATA            (uart3_prdata_25),   // APB interface outputs
    .PREADY            (uart3_pready_25),
    .PSLVERR           (uart3_pslverr_25),

    .ECOREVNUM         (4'h0),// Engineering-change-order revision bits

    .RXD               (UART3_RXD),      // Receive data

    .TXD               (UART3_TXD),      // Transmit data
    .TXEN              (UART3_TXEN),     // Transmit Enabled

    .BAUDTICK          (),   // Baud rate x16 tick output (for testing)

    .TXINT             (uart3_txint),       // Transmit Interrupt
    .RXINT             (uart3_rxint),       // Receive  Interrupt
    .TXOVRINT          (uart3_txovrint),    // Transmit Overrun Interrupt
    .RXOVRINT          (uart3_rxovrint),    // Receive  Overrun Interrupt
    .UARTINT           (uart3_combined_int) // Combined Interrupt
  );
  end else
  begin : gen_no_apb_uart_3
    assign uart3_prdata  = {32{1'b0}};
    assign uart3_pready  = 1'b1;
    assign uart3_pslverr = 1'b0;
    assign UART3_TXD     = 1'b1;
    assign UART3_TXEN    = 1'b0;
    assign uart3_txint   = 1'b0;
    assign uart3_rxint   = 1'b0;
    assign uart3_txovrint = 1'b0;
    assign uart3_rxovrint = 1'b0;
    assign uart3_combined_int = 1'b0;
  end endgenerate


  generate if (INCLUDE_APB_UART4 == 1) begin : gen_apb_uart_4
    wire [31:0]   i_4_paddr_ext;
    wire [31:0]   i_4_paddr_ext_25;
    wire [31:0]   i_4_pwdata_25;
    wire          i_4_pwrite_25;
    wire          i_4_penable_25;
    wire          uart4_psel_25;
    wire [31:0]   uart4_prdata_25;
    wire          uart4_pslverr_25;
    wire          uart4_pready_25;


    assign i_4_paddr_ext[31:12] = 20'b0;
    assign i_4_paddr_ext[11:2] = i_paddr[11:2];
    assign i_4_paddr_ext[1:0] = 2'b0;

`ifdef CLOCK_BRIDGES
  cxapbasyncbridge u_apb_bridge_async_4 (
    // Slave Interface
    //Clock and reset signals
    .pclkens    (1'b1),
    .pclks      (HCLK),
    .presetsn   (HRESETN),
    // APB3 Bus
    .paddrs     (i_4_paddr_ext),
    .pwdatas    (i_pwdata),
    .pwrites    (i_pwrite),
    .penables   (i_penable),
    .psels      (uart4_psel),
    .prdatas    (uart4_prdata),
    .pslverrs   (uart4_pslverr),
    .preadys    (uart4_pready),
    // Master Interface
    // Clock and reset signals
    .pclkenm    (1'b1),
    .pclkm      (SCLK),
    .presetmn   (HRESETN),
    // APB3 Bus
    .paddrm     (i_4_paddr_ext_25),
    .pwdatam    (i_4_pwdata_25),
    .pwritem    (i_4_pwrite_25),
    .penablem   (i_4_penable_25),
    .pselm      (uart4_psel_25),
    .prdatam    (uart4_prdata_25),
    .pslverrm   (uart4_pslverr_25),
    .preadym    (uart4_pready_25)
    );
`else
assign i_4_paddr_ext_25 = i_4_paddr_ext;
assign i_4_pwdata_25 = i_pwdata;
assign i_4_pwrite_25 = i_pwrite;
assign i_4_penable_25 = i_penable;
assign uart4_psel_25 = uart4_psel;

assign uart4_prdata = uart4_prdata_25;
assign uart4_pslverr = uart4_pslverr_25;
assign uart4_pready = uart4_pready_25;
`endif

  cmsdk_apb_uart u_apb_uart_4 (
`ifdef CLOCK_BRIDGES
    .PCLK              (SCLK),     // Peripheral clock
    .PCLKG             (SCLKG),    // Gated PCLK for bus
`else
    .PCLK              (HCLK),     // Peripheral clock
    .PCLKG             (PCLKG),    // Gated PCLK for bus
`endif
    .PRESETn           (HRESETN),  // Reset

    .PSEL              (uart4_psel_25),     // APB interface inputs
    .PADDR             (i_4_paddr_ext_25[11:2]),
    .PENABLE           (i_4_penable_25),
    .PWRITE            (i_4_pwrite_25),
    .PWDATA            (i_4_pwdata_25),

    .PRDATA            (uart4_prdata_25),   // APB interface outputs
    .PREADY            (uart4_pready_25),
    .PSLVERR           (uart4_pslverr_25),

    .ECOREVNUM         (4'h0),// Engineering-change-order revision bits

    .RXD               (UART4_RXD),      // Receive data

    .TXD               (UART4_TXD),      // Transmit data
    .TXEN              (UART4_TXEN),     // Transmit Enabled

    .BAUDTICK          (),   // Baud rate x16 tick output (for testing)

    .TXINT             (uart4_txint),       // Transmit Interrupt
    .RXINT             (uart4_rxint),       // Receive  Interrupt
    .TXOVRINT          (uart4_txovrint),    // Transmit Overrun Interrupt
    .RXOVRINT          (uart4_rxovrint),    // Receive  Overrun Interrupt
    .UARTINT           (uart4_combined_int) // Combined Interrupt
  );
  end else
  begin : gen_no_apb_uart_4
    assign uart4_prdata  = {32{1'b0}};
    assign uart4_pready  = 1'b1;
    assign uart4_pslverr = 1'b0;
    assign UART4_TXD     = 1'b1;
    assign UART4_TXEN    = 1'b0;
    assign uart4_txint   = 1'b0;
    assign uart4_rxint   = 1'b0;
    assign uart4_txovrint = 1'b0;
    assign uart4_rxovrint = 1'b0;
    assign uart4_combined_int = 1'b0;
  end endgenerate

    // -----------------------------------------------------------------

  //assign uart2_overflow_int = uart2_txovrint|uart2_rxovrint;
  //assign uart3_overflow_int = uart3_txovrint|uart3_rxovrint;
  //assign uart4_overflow_int = uart4_txovrint|uart4_rxovrint;

  generate if (INCLUDE_IRQ_SYNCHRONIZER == 0) begin : gen_fpga_irq_synchroniser
    // If PCLK is syncrhonous to HCLK, no need to have synchronizers
    assign i_uart2_txint = uart2_txint;
    assign i_uart2_rxint = uart2_rxint;
    assign i_uart3_txint = uart3_txint;
    assign i_uart3_rxint = uart3_rxint;
    assign i_uart4_txint = uart4_txint;
    assign i_uart4_rxint = uart4_rxint;
    assign i_uart2_txovrint = uart2_txovrint;
    assign i_uart2_rxovrint = uart2_rxovrint;
    assign i_uart3_txovrint = uart3_txovrint;
    assign i_uart3_rxovrint = uart3_rxovrint;
    assign i_uart4_txovrint = uart4_txovrint;
    assign i_uart4_rxovrint = uart4_rxovrint;
  end else
  begin : gen_no_fpga_irq_synchroniser
    // If IRQ source are asyncrhonous to HCLK, then we
    // need to add synchronizers to prevent metastability
    // on interrupt signals.
  cmsdk_irq_sync u_fpga_irq_sync_0 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart2_txint),
    .IRQOUT(i_uart2_txint)
    );

  cmsdk_irq_sync u_fpga_irq_sync_1 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart2_rxint),
    .IRQOUT(i_uart2_rxint)
    );

  cmsdk_irq_sync u_fpga_irq_sync_2 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart3_txint),
    .IRQOUT(i_uart3_txint)
    );

  cmsdk_irq_sync u_fpga_irq_sync_3 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart3_rxint),
    .IRQOUT(i_uart3_rxint)
      );

  cmsdk_irq_sync u_fpga_irq_sync_4 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart4_txint),
    .IRQOUT(i_uart4_txint)
    );

  cmsdk_irq_sync u_fpga_irq_sync_5 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart4_rxint),
    .IRQOUT(i_uart4_rxint)
      );

  cmsdk_irq_sync u_fpga_irq_sync_6 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart2_txovrint),
    .IRQOUT(i_uart2_txovrint)
    );

  cmsdk_irq_sync u_fpga_irq_sync_7 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart2_rxovrint),
    .IRQOUT(i_uart2_rxovrint)
    );

  cmsdk_irq_sync u_fpga_irq_sync_8 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart3_txovrint),
    .IRQOUT(i_uart3_txovrint)
    );

  cmsdk_irq_sync u_fpga_irq_sync_9 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart3_rxovrint),
    .IRQOUT(i_uart3_rxovrint)
    );

  cmsdk_irq_sync u_fpga_irq_sync_10 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart4_txovrint),
    .IRQOUT(i_uart4_txovrint)
    );

  cmsdk_irq_sync u_fpga_irq_sync_11 (
    .RSTn  (HRESETN),
    .CLK   (HCLK),
    .IRQIN (uart4_rxovrint),
    .IRQOUT(i_uart4_rxovrint)
    );

  end endgenerate

  assign UART_INTERRUPTS[11:0] = {
                   i_uart4_rxovrint,
                   i_uart4_txovrint,
                   i_uart3_rxovrint,
                   i_uart3_txovrint,
                   i_uart2_rxovrint,
                   i_uart2_txovrint,
                   i_uart4_rxint,
                   i_uart4_txint,
                   i_uart3_rxint,
                   i_uart3_txint,
                   i_uart2_rxint,
                   i_uart2_txint};

  // ----------------------------------------
  // Serial Communication Controller (SCC)
  // Allow on board micro-controller to communicate
  // with the FPGA design using a simple serial interface.
  //
  scc u_scc(
  .PCLK           (HCLK),
  .PRESETn        (FPGA_NPOR),
  .PSEL           (i_pel_scc),
  .PENABLE        (i_penable),
  .PWRITE         (i_pwrite),
  .PADDR          (i_paddr[11:0]),
  .PWDATA         (i_pwdata[31:0]),
  .PRDATA         (i_prdata_scc),

  .CFGCLK         (CFGCLK),
  .nCFGRST        (nCFGRST),
  .CFGLOAD        (CFGLOAD),
  .CFGWnR         (CFGWnR),
  .CFGDATAIN      (CFGDATAIN),
  .CFGDATAOUT     (CFGDATAOUT),
  .DLL_LOCKED     (DLL_LOCKED),

  .SWITCH_OUTPUT  (),       // output: switch status in CFGCLK domain
  .ALT_LED_SOURCE (8'h00),  // input : mcu_leds synchronized to CFGCLK

  .CFGREG_IN      ({256{1'b0}}),
  .CFGREG_OUT     (cfgreg_out),
  .CFGINT         (CFGINT)
  );

  assign EFUSES    = cfgreg_out[95:64];
  assign TEST_CTRL = cfgreg_out[98:96];
  //assign zbt_boot_ctrl = cfgreg_out[0];

endmodule
