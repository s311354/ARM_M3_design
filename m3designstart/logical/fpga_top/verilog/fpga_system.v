//------------------------------------------------------------------------------
//  The confidential and proprietary information contained in this file may
//  only be used by a person authorised under and to the extent permitted
//  by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//         (C) COPYRIGHT 2017 ARM Limited or its affiliates.
//             ALL RIGHTS RESERVED
//
//  This entire notice must be reproduced on all copies of this file
//  and copies of this file may only be made by a person if such person is
//  permitted to do so under the terms of a subsisting license agreement
//  from ARM Limited or its affiliates.
//
//  Release Information : CM3DesignStart-r0p0-02rel0
//------------------------------------------------------------------------------
// Verilog-2001 (IEEE Std 1364-2001)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : V2M-MPS2 FPGA System Level for Cortex-M3 DesignStart
//            When using the partial reconfiguration flow, this level
//            must not be modified. Any user-changable features
//            have to be driven in the user partition (including user I/O)
//------------------------------------------------------------------------------

`include "cmsdk_mcu_defs.v"

module fpga_system #(parameter INCLUDE_JTAG = 1) // Include JTAG feature
    (
    input  wire          fclk,           // Free running clock
    input  wire          fpga_npor,      // delayed CB_nPOR reset
    input  wire          fpga_reset_n,   // CB_nRST system reset
    input  wire          cs_nsrst_sync,  // debug connector system reset
    input  wire          clk_100hz,      // 100Hz clock
    // --------------------------------------------------------------------
    // I/Os
    // --------------------------------------------------------------------
    output wire [1:0]    leds,           // LEDs
    input  wire [1:0]    buttons,        // Push buttons
    input  wire [7:0]    dll_locked,     // DLL/PLL locked information

    // User expansion ports
    input  wire [51:0]   io_exp_port_i,  // I/O port inputs
    output wire [51:0]   io_exp_port_o,  // I/O port outputs
    output wire [51:0]   io_exp_port_oen,// I/O port output enables

    output wire [15:0]   gpio0_altfunc_o,// Alternate function control
    output wire [15:0]   gpio1_altfunc_o,// Alternate function control
    output wire [15:0]   gpio2_altfunc_o,// Alternate function control
    output wire [15:0]   gpio3_altfunc_o,// Alternate function control

    output wire [9:0]    fpga_misc,
    input  wire          ts_interrupt,

    // --------------------------------------------------------------------
    // Debug and Trace
    // --------------------------------------------------------------------
    input   wire          dbg_ntrst,
    input   wire          dbg_swdi_tms,
    input   wire          dbg_swclk_tck,
    input   wire          dbg_tdi,

    output  wire          dbg_tdo,
    output  wire          dbg_tdo_nen,
    output  wire          dbg_swdo,
    output  wire          dbg_swdo_en,
    output  wire          dbg_jtag_nsw,
    output  wire          dbg_swo,
    output  wire          dbg_traceclk,
    output  wire [3:0]    dbg_tracedata,

    // --------------------------------------------------------------------
    // ZBT Synchronous SRAM
    // --------------------------------------------------------------------

    // 64-bit ZBT Synchronous SRAM1 connections
    //output wire [1:0]    zbt_sram1_CLK,  // Clock
    output wire [19:0]   zbt_sram1_a,      // Address
    input  wire [63:0]   zbt_sram1_dq_i,   // Data input
    output wire [63:0]   zbt_sram1_dq_o,   // Data Output
    output wire          zbt_sram1_dq_oen, // 3-state Buffer Enable
    output wire [7:0]    zbt_sram1_bwn,    // Byte lane writes (active low)
    output wire          zbt_sram1_cen,    // Chip Select (active low)
    output wire          zbt_sram1_wen,    // Write enable
    output wire          zbt_sram1_oen,    // Output enable (active low)
    output wire          zbt_sram1_lbon,   // Not used (tied to 0)
    output wire          zbt_sram1_adv,    // Not used (tied to 0)
    output wire          zbt_sram1_zz,     // Not used (tied to 0)
    output wire          zbt_sram1_cken,   // Not used (tied to 0)

    // 32-bit ZBT Synchronous SRAM2 connections
    //output wire          zbt_sram2_CLK,  // Clock
    output wire [19:0]   zbt_sram2_a,      // Address
    input  wire [31:0]   zbt_sram2_dq_i,   // Data input
    output wire [31:0]   zbt_sram2_dq_o,   // Data Output
    output wire          zbt_sram2_dq_oen, // 3-state Buffer Enable
    output wire  [3:0]   zbt_sram2_bwn,    // Byte lane writes (active low)
    output wire          zbt_sram2_cen,    // Chip Select (active low)
    output wire          zbt_sram2_wen,    // Write enable
    output wire          zbt_sram2_oen,    // Output enable (active low)
    output wire          zbt_sram2_lbon,   // Not used (tied to 0)
    output wire          zbt_sram2_adv,    // Not used (tied to 0)
    output wire          zbt_sram2_zz,     // Not used (tied to 0)
    output wire          zbt_sram2_cken,   // Not used (tied to 0)

    // 32-bit ZBT Synchronous SRAM3 connections
    //output wire          zbt_sram3_CLK,  // Clock
    output wire [19:0]   zbt_sram3_a,      // Address
    input  wire [31:0]   zbt_sram3_dq_i,   // Data input
    output wire [31:0]   zbt_sram3_dq_o,   // Data Output
    output wire          zbt_sram3_dq_oen, // 3-state Buffer Enable
    output wire  [3:0]   zbt_sram3_bwn,    // Byte lane writes (active low)
    output wire          zbt_sram3_cen,    // Chip Select (active low)
    output wire          zbt_sram3_wen,    // Write enable
    output wire          zbt_sram3_oen,    // Output enable (active low)
    output wire          zbt_sram3_lbon,   // Not used (tied to 0)
    output wire          zbt_sram3_adv,    // Not used (tied to 0)
    output wire          zbt_sram3_zz,     // Not used (tied to 0)
    output wire          zbt_sram3_cken,   // Not used (tied to 0)

    // 16-bit smb connections
    output wire [25:0]   smb_addr,         // Address
    input  wire [15:0]   smb_data_i,       // Read Data
    output wire [15:0]   smb_data_o,       // Write Data
    output wire          smb_data_o_nen,   // Write Data 3-state ctrl
    output wire          smb_cen,          // Active low chip enable
    output wire          smb_oen,          // Active low output enable (read)
    output wire          smb_wen,          // Active low write enable
    output wire          smb_ubn,          // Active low Upper Byte Enable
    output wire          smb_lbn,          // Active low Upper Byte Enable
    output wire          smb_nrd,          // Active low read enable
    output wire          smb_nreset,       // Active low reset

    // --------------------------------------------------------------------
    // UART
    // --------------------------------------------------------------------
    input  wire          uart_rxd,          // UART receive data
    output wire          uart_txd,          // UART transmit data

    input  wire          uart_rxd_mcu,      // Microcontroller UART receive data
    output wire          uart_txd_mcu,      // Microcontroller UART transmit data
    output wire          uart_txd_mcu_en,   // TX enable (enable 3-state buffer)

    // --------------------------------------------------------------------
    // SPI
    // --------------------------------------------------------------------
    output wire          spi0_clk_out,      // SPI clock
    output wire          spi0_clk_out_en_n, // SPI clock output enable (active low)
    output wire          spi0_data_out,     // SPI data out
    output wire          spi0_data_out_en_n,// SPI data output enable (active low)
    input  wire          spi0_data_in,      // SPI data in
    output wire          spi0_sel,          // SPI device select

    input  wire          config_spiclk,
    input  wire          config_spidi,
    output wire          config_spido,

    // --------------------------------------------------------------------
    // VGA
    // --------------------------------------------------------------------
    output wire          vga_hsync,        // VGA H-Sync
    output wire          vga_vsync,        // VGA V-Sync
    output wire [3:0]    vga_r,            // VGA red data
    output wire [3:0]    vga_g,            // VGA green data
    output wire [3:0]    vga_b,            // VGA blue data

    // --------------------------------------------------------------------
    // Ethernet
    // --------------------------------------------------------------------
    input  wire          SMB_ETH_IRQ_n,
    // --------------------------------------------------------------------
    // Audio
    // --------------------------------------------------------------------
    input  wire          audio_mclk,     // Audio codec master clock (12.288MHz)
    input  wire          audio_sclk,     // Audio interface bit clock
    output wire          audio_lrck,     // Audio Left/Right clock
    output wire          audio_sdout,    // Audio DAC data
    input  wire          audio_sdin,     // Audio ADC data
    output wire          audio_nrst,     // Audio reset

    output wire          audio_scl,
    input  wire          audio_sda_i,
    output wire          audio_sda_o_en_n,
    // When audio_sda_o_en_n=0, pull SDA low

    // --------------------------------------------------------------------
    // CLCD
    // --------------------------------------------------------------------
    output wire          clcd_scl,
    input  wire          clcd_sda_i,
    output wire          clcd_sda_o_en_n,

    output wire          spi1_clk_out,              // CLCD SPI clock
    output wire          spi1_clk_out_en_n,         // CLCD SPI clock output enable (active low)
    output wire          spi1_data_out,             // CLCD SPI data out
    output wire          spi1_data_out_en_n,        // CLCD SPI data output enable (active low)
    input  wire          spi1_data_in,              // CLCD SPI data in
    output wire          spi1_sel,                  // CLCD SPI device select

    // --------------------------------------------------------------------
    // Bluetooth UART
    // --------------------------------------------------------------------
    input  wire          uart4_rxd,                 // Bluetooth UART receive data
    output wire          uart4_txd,                 // Bluetooth UART transmit data
    output wire          uart4_txden,               // TX enable (enable 3-state buffer)

    // --------------------------------------------------------------------
    // ADC SPI
    // --------------------------------------------------------------------
    output wire          adc_spi2_clk_out,          // ADC SPI clock
    output wire          adc_spi2_clk_out_en_n,     // ADC SPI clock output enable (active low)
    output wire          adc_spi2_data_out,         // ADC SPI data out
    output wire          adc_spi2_data_out_en_n,    // ADC SPI data output enable (active low)
    input  wire          adc_spi2_data_in,          // ADC SPI data in
    output wire          adc_spi2_sel,              // ADC SPI device select

    // --------------------------------------------------------------------
    // Shield 0 I2C, SPI & UART
    // --------------------------------------------------------------------
    output wire          shield0_scl,
    input  wire          shield0_sda_i,
    output wire          shield0_sda_o_en_n,

    output wire          shield0_spi3_clk_out,      // Shield0 SPI clock
    output wire          shield0_spi3_clk_out_en_n, // Shield0 SPI clock output enable (active low)
    output wire          shield0_spi3_data_out,     // Shield0 SPI data out
    output wire          shield0_spi3_data_out_en_n,// Shield0 SPI data output enable (active low)
    input  wire          shield0_spi3_data_in,      // Shield0 SPI data in
    output wire          shield0_spi3_sel,          // Shield0 SPI device select

    input  wire          uart2_rxd,                 // Shield0 UART receive data
    output wire          uart2_txd,                 // Shield0 UART transmit data
    output wire          uart2_txden,               // TX enable (enable 3-state buffer)

    // --------------------------------------------------------------------
    // Shield 1 I2C, SPI & UART
    // --------------------------------------------------------------------
    output wire          shield1_scl,
    input  wire          shield1_sda_i,
    output wire          shield1_sda_o_en_n,

    output wire          shield1_spi4_clk_out,      // Shield1 SPI clock
    output wire          shield1_spi4_clk_out_en_n, // Shield1 SPI clock output enable (active low)
    output wire          shield1_spi4_data_out,     // Shield1 SPI data out
    output wire          shield1_spi4_data_out_en_n,// Shield1 SPI data output enable (active low)
    input  wire          shield1_spi4_data_in,      // Shield1 SPI data in
    output wire          shield1_spi4_sel,          // Shield1 SPI device select

    input  wire          uart3_rxd,                 // Shield1 UART receive data
    output wire          uart3_txd,                 // Shield1 UART transmit data
    output wire          uart3_txden,               // TX enable (enable 3-state buffer)

    // --------------------------------------------------------------------
    // Serial Communication Controller interface
    // --------------------------------------------------------------------
    input  wire          CFGCLK,
    input  wire          nCFGRST,

    input  wire          CFGLOAD,
    input  wire          CFGWnR,
    input  wire          CFGDATAIN,
    output wire          CFGDATAOUT,

    output wire          cfgint

    ); // end of top level pin list

  //---------------------------------------------------
  // Internal wires
  //---------------------------------------------------
  wire            hclk_cpu;        // CPU system clock
  wire            hclk_sys_cmsdk;  // CMSDK system HCLK
  wire            hclk_sys;        // AHB system clock
  wire            pclk;            // PCLK (continuous)
  wire            pclk_gated;      // Gated PCLK (bus clock, runs when APB is active)
  wire            presetn;         // Peripheral system reset
  wire            sys_reset_req;   // System reset request (from NVIC)
  wire            wdog_reset_req;  // Watchdog reset request

  // Common AHB signals
  wire    [31:0]  flash_haddr;      // AHB to flash blocks - address
  wire     [1:0]  flash_htrans;     // AHB to flash blocks - transfer ctrl
  wire     [2:0]  flash_hsize;      // AHB to flash blocks - transfer size
  wire            flash_hwrite;     // AHB to flash blocks - write ctrl
  wire    [31:0]  flash_hwdata;     // AHB to flash blocks - write data
  wire            flash_hready;     // AHB to flash blocks - AHB ready

  // Flash memory AHB signals - goto SSRAM1
  wire            flash_hsel;
  wire            flash_hreadyout;
  wire    [31:0]  flash_hrdata;
  wire            flash_hresp;
  wire    [63:0]  flash_hrdata_64;

  // Static Memory Interface (SMI) for PSRAM and Ethernet
  wire            smi_hsel;
  wire    [25:0]  smi_haddr;  // remapped HADDR to include chip select info
  wire            smi_hresp;
  wire            smi_hreadyout;
  wire    [31:0]  smi_hrdata;

  // CMSDK system AHB signals
  //  (AHB Lite bus signals from Cortex-M system bus.
  //   Covers SRAM region memory and FPGA level peripherals,
  //   exclude CMSDK level peripherals)
  wire            cpusys_hsel;        // select
  wire            cpusys_hreadyout;   // ready
  wire    [31:0]  cpusys_hrdata;      // read data output from SRAM
  wire            cpusys_hresp;       // response

  // FPGA system AHB signals
  //  (AHB Lite bus from CPU/CMSDK / from SPI to AHB)
  wire    [31:0]  fpgasys_haddr;       // address
  wire     [1:0]  fpgasys_htrans;      // transfer control
  wire     [2:0]  fpgasys_hsize;       // size
  wire            fpgasys_hwrite;      // write control
  wire    [31:0]  fpgasys_hwdata;      // write data
  wire            fpgasys_hready;      // ready

  wire            fpgasys_hsel;        // select
  wire            fpgasys_hreadyout;   // ready
  wire    [31:0]  fpgasys_hrdata;      // read data output from SRAM
  wire            fpgasys_hresp;       // response

  // Boot loader/firmware AHB signals (FPGA block RAM)
  wire            boot_hsel;
  wire            boot_hreadyout;
  wire    [31:0]  boot_hrdata;
  wire            boot_hresp;

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

  //    APB section - slave 0 - 64-bit ZBTRAM
  wire            spi2mem_s0_psel;
  wire    [31:0]  spi2mem_s0_prdata;
  wire            spi2mem_s0_pready;
  wire            spi2mem_s0_pslverr;

  //    APB section - slave 1 - to converter which convert bus transfers to AHB
  wire            spi2mem_s1_psel;
  wire    [31:0]  spi2mem_s1_prdata;
  wire            spi2mem_s1_pready;
  wire            spi2mem_s1_pslverr;

  //    AHB Lite driven by SPI (from MCU on board)
  wire            spi2mem_s1_hsel;
  wire    [31:0]  spi2mem_s1_haddr;
  wire            spi2mem_s1_hwrite;
  wire    [31:0]  spi2mem_s1_hwdata;
  wire     [1:0]  spi2mem_s1_hsize;
  wire     [1:0]  spi2mem_s1_htrans;
  wire    [31:0]  spi2mem_s1_hrdata;
  wire            spi2mem_s1_hready;
  wire            spi2mem_s1_hresp;

  // User expansion I/O interface
  wire    [15:0]  gpio2_in;
  wire    [15:0]  gpio2_out;
  wire    [15:0]  gpio2_outen;
  wire    [15:0]  gpio2_altfunc;
  wire            gpio2_interrupt;

  wire    [15:0]  gpio3_in;
  wire    [15:0]  gpio3_out;
  wire    [15:0]  gpio3_outen;
  wire    [15:0]  gpio3_altfunc;
  wire            gpio3_interrupt;

  wire            spi_interrupt;   // Interrupt from FPGA APB subsystem to processor
  wire            i2s_interrupt;   // Interrupt from FPGA APB subsystem to processor


    // --------------------------------------------------------------------
    // User partition, (in the clear)
    // --------------------------------------------------------------------

    m3ds_user_partition u_user_partition (
        .fclk                       (fclk),
        .fpga_npor                  (fpga_npor),
        .fpga_reset_n               (fpga_reset_n),
        .cs_nsrst_sync              (cs_nsrst_sync),
        .clk_100hz                  (clk_100hz),
        .leds                       (leds),
        .buttons                    (buttons),
        .dll_locked                 (dll_locked),
        .io_exp_port_i              (io_exp_port_i),
        .io_exp_port_o              (io_exp_port_o),
        .io_exp_port_oen            (io_exp_port_oen),
        .gpio0_altfunc_o            (gpio0_altfunc_o),
        .gpio1_altfunc_o            (gpio1_altfunc_o),
        .gpio2_altfunc_o            (gpio2_altfunc_o),
        .gpio3_altfunc_o            (gpio3_altfunc_o),
        .fpga_misc                  (fpga_misc),

        // 64-bit ZBT Synchronous SRAM2 connections
        .zbt_sram1_a                (zbt_sram1_a),       // Address
        .zbt_sram1_dq_i             (zbt_sram1_dq_i),    // Data         (byte lane #A)
        .zbt_sram1_dq_o             (zbt_sram1_dq_o),    // Data Output
        .zbt_sram1_dq_oen           (zbt_sram1_dq_oen),  // Tristate Buffer Enable
        .zbt_sram1_bwn              (zbt_sram1_bwn),     // Byte lane writes (active low)
        .zbt_sram1_cen              (zbt_sram1_cen),     // Chip Select      (active low)
        .zbt_sram1_wen              (zbt_sram1_wen),     // Write enable
        .zbt_sram1_oen              (zbt_sram1_oen),     // Output enable    (active low)
        .zbt_sram1_lbon             (zbt_sram1_lbon),    // Not used         (tied to 0)
        .zbt_sram1_adv              (zbt_sram1_adv),     // Not used         (tied to 0)
        .zbt_sram1_zz               (zbt_sram1_zz),      // Not used         (tied to 0)
        .zbt_sram1_cken             (zbt_sram1_cken),    // Not used         (tied to 0)

        // 32-bit ZBT Synchronous SRAM2 connections
        .zbt_sram2_a                (zbt_sram2_a),       // Address
        .zbt_sram2_dq_i             (zbt_sram2_dq_i),    // Data         (byte lane #A)
        .zbt_sram2_dq_o             (zbt_sram2_dq_o),    // Data Output
        .zbt_sram2_dq_oen           (zbt_sram2_dq_oen),  // Tristate Buffer Enable
        .zbt_sram2_bwn              (zbt_sram2_bwn),     // Byte lane writes (active low)
        .zbt_sram2_cen              (zbt_sram2_cen),     // Chip Select      (active low)
        .zbt_sram2_wen              (zbt_sram2_wen),     // Write enable
        .zbt_sram2_oen              (zbt_sram2_oen),     // Output enable    (active low)
        .zbt_sram2_lbon             (zbt_sram2_lbon),    // Not used         (tied to 0)
        .zbt_sram2_adv              (zbt_sram2_adv),     // Not used         (tied to 0)
        .zbt_sram2_zz               (zbt_sram2_zz),      // Not used         (tied to 0)
        .zbt_sram2_cken             (zbt_sram2_cken),    // Not used         (tied to 0)

        // 32-bit ZBT Synchronous SRAM3 connections
        .zbt_sram3_a                (zbt_sram3_a),       // Address
        .zbt_sram3_dq_i             (zbt_sram3_dq_i),    // Data         (byte lane #A)
        .zbt_sram3_dq_o             (zbt_sram3_dq_o),    // Data Output
        .zbt_sram3_dq_oen           (zbt_sram3_dq_oen),  // Tristate Buffer Enable
        .zbt_sram3_bwn              (zbt_sram3_bwn),     // Byte lane writes (active low)
        .zbt_sram3_cen              (zbt_sram3_cen),     // Chip Select      (active low)
        .zbt_sram3_wen              (zbt_sram3_wen),     // Write enable
        .zbt_sram3_oen              (zbt_sram3_oen),     // Output enable    (active low)
        .zbt_sram3_lbon             (zbt_sram3_lbon),    // Not used         (tied to 0)
        .zbt_sram3_adv              (zbt_sram3_adv),     // Not used         (tied to 0)
        .zbt_sram3_zz               (zbt_sram3_zz),      // Not used         (tied to 0)
        .zbt_sram3_cken             (zbt_sram3_cken),    // Not used         (tied to 0)

        // SMB
        .smb_addr                   (smb_addr),          // Address
        .smb_data_i                 (smb_data_i),        // Data read
        .smb_data_o                 (smb_data_o),        // Data write
        .smb_data_o_nen             (smb_data_o_nen),    // Write data tristate control
        .smb_cen                    (smb_cen),           // Active low chip enable
        .smb_oen                    (smb_oen),           // Active low output enable (read)
        .smb_wen                    (smb_wen),           // Active low write enable
        .smb_ubn                    (smb_ubn),           // Active low Upper Byte Enable
        .smb_lbn                    (smb_lbn),           // Active low Upper Byte Enable
        .smb_nrd                    (smb_nrd),           // Active low read enable
        .smb_nreset                 (smb_nreset),        // Active low reset

        // UART
        .uart_rxd                   (uart_rxd),
        .uart_txd                   (uart_txd),
        .uart_rxd_mcu               (uart_rxd_mcu),
        .uart_txd_mcu               (uart_txd_mcu),
        .uart_txd_mcu_en            (uart_txd_mcu_en),

        // SPI
        .spi0_clk_out               (spi0_clk_out),
        .spi0_clk_out_en_n          (spi0_clk_out_en_n),
        .spi0_data_out              (spi0_data_out),
        .spi0_data_out_en_n         (spi0_data_out_en_n),
        .spi0_data_in               (spi0_data_in),
        .spi0_sel                   (spi0_sel),          // Controlled by fpga_misc register

        .config_spiclk              (config_spiclk),
        .config_spidi               (config_spidi),
        .config_spido               (config_spido),

        // VGA
        .vga_hsync                  (vga_hsync),
        .vga_vsync                  (vga_vsync),
        .vga_r                      (vga_r),
        .vga_g                      (vga_g),
        .vga_b                      (vga_b),

        // Ethernet
        .SMB_ETH_IRQ_n              (SMB_ETH_IRQ_n),     // Active low

        // Audio
        .audio_mclk                 (audio_mclk),
        .audio_sclk                 (audio_sclk),
        .audio_lrck                 (audio_lrck),
        .audio_sdout                (audio_sdout),       //ldill swapped in & out
        .audio_sdin                 (audio_sdin),
        .audio_nrst                 (audio_nrst),
        .audio_scl                  (audio_scl),
        .audio_sda_i                (audio_sda_i),
        .audio_sda_o_en_n           (audio_sda_o_en_n),

        //CLCD
        .clcd_scl                   (clcd_scl),
        .clcd_sda_i                 (clcd_sda_i),
        .clcd_sda_o_en_n            (clcd_sda_o_en_n),

        .spi1_clk_out               (spi1_clk_out),
        .spi1_clk_out_en_n          (spi1_clk_out_en_n),
        .spi1_data_out              (spi1_data_out),
        .spi1_data_out_en_n         (spi1_data_out_en_n),
        .spi1_data_in               (spi1_data_in),
        .spi1_sel                   (spi1_sel),          // Set from fpga_misc register

        // Bluetooth UART
        .uart4_rxd                  (uart4_rxd),
        .uart4_txd                  (uart4_txd),
        .uart4_txden                (uart4_txden),
        // ADC SPI
        .adc_spi2_clk_out           (adc_spi2_clk_out),
        .adc_spi2_clk_out_en_n      (adc_spi2_clk_out_en_n),
        .adc_spi2_data_out          (adc_spi2_data_out),
        .adc_spi2_data_out_en_n     (adc_spi2_data_out_en_n),
        .adc_spi2_data_in           (adc_spi2_data_in),
        .adc_spi2_sel               (adc_spi2_sel),
        // Shield 0 I2C
        .shield0_scl                (shield0_scl),
        .shield0_sda_i              (shield0_sda_i),
        .shield0_sda_o_en_n         (shield0_sda_o_en_n),
        // Shield 0 SPI
        .shield0_spi3_clk_out       (shield0_spi3_clk_out),
        .shield0_spi3_clk_out_en_n  (shield0_spi3_clk_out_en_n),
        .shield0_spi3_data_out      (shield0_spi3_data_out),
        .shield0_spi3_data_out_en_n (shield0_spi3_data_out_en_n),
        .shield0_spi3_data_in       (shield0_spi3_data_in),
        .shield0_spi3_sel           (shield0_spi3_sel),
        // Shield 0 UART
        .uart2_rxd                  (uart2_rxd),
        .uart2_txd                  (uart2_txd),
        .uart2_txden                (uart2_txden),
        // Shield 1 I2C
        .shield1_scl                (shield1_scl),
        .shield1_sda_i              (shield1_sda_i),
        .shield1_sda_o_en_n         (shield1_sda_o_en_n),
        // Shield 1 SPI
        .shield1_spi4_clk_out       (shield1_spi4_clk_out),
        .shield1_spi4_clk_out_en_n  (shield1_spi4_clk_out_en_n),
        .shield1_spi4_data_out      (shield1_spi4_data_out),
        .shield1_spi4_data_out_en_n (shield1_spi4_data_out_en_n),
        .shield1_spi4_data_in       (shield1_spi4_data_in),
        .shield1_spi4_sel           (shield1_spi4_sel),
        // Shield 1 UART
        .uart3_rxd                  (uart3_rxd),
        .uart3_txd                  (uart3_txd),
        .uart3_txden                (uart3_txden),

        .ts_interrupt               (ts_interrupt),

        // SCC Serial Communication Controller interface
        .CFGCLK                     (CFGCLK),
        .nCFGRST                    (nCFGRST),
        .CFGLOAD                    (CFGLOAD),
        .CFGWnR                     (CFGWnR),
        .CFGDATAIN                  (CFGDATAIN),
        .CFGDATAOUT                 (CFGDATAOUT),
        // Interrupt from FPGA to MCU
        .cfgint                     (cfgint),

        //SWJDAP signal for single processor mode
        .nTRST                      (dbg_ntrst),        // JTAG TAP Reset
        .SWCLKTCK                   (dbg_swclk_tck),    // SW/JTAG Clock
        .SWDITMS                    (dbg_swdi_tms),     // SW Debug Data In / JTAG Test Mode Select
        .TDI                        (dbg_tdi),          // JTAG TAP Data In / Alternative input function

        //SWJDAP signal for single processor mode
        .TDO                        (dbg_tdo),          // JTAG TAP Data Out
        .nTDOEN                     (dbg_tdo_nen),      // TDO enable
        .SWDO                       (dbg_swdo),         // SW Data Out
        .SWDOEN                     (dbg_swdo_en),      // SW Data Out Enable
        .JTAGNSW                    (dbg_jtag_nsw),     // JTAG/not Serial Wire Mode

        // Single Wire Viewer
        .SWV                        (dbg_swo),          // SingleWire Viewer Data

        //TPIU signals for trace
        .TRACECLK                   (dbg_traceclk),     // TRACECLK output
        .TRACEDATA                  (dbg_tracedata)    // Trace Data

    );

endmodule
