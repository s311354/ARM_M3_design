//------------------------------------------------------------------------------
//  The confidential and proprietary information contained in this file may
//  only be used by a person authorised under and to the extent permitted
//  by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//         (C) COPYRIGHT 2013,2017 ARM Limited or its affiliates.
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

//-----------------------------------------------------------------------------
// Abstract : V2M-MPS2 FPGA User partition for DesignStart
//
// Instanitiates IoT compute subsystem, and peripherals
//-----------------------------------------------------------------------------

module m3ds_user_partition (
    input  wire          fclk,                      // Free running clock
    input  wire          fpga_npor,                 // delayed CB_nPOR reset
    input  wire          fpga_reset_n,              // CB_nRST system reset
    input  wire          cs_nsrst_sync,             // debug connector system reset
    input  wire          clk_100hz,                 // 100Hz clock

    // --------------------------------------------------------------------
    // I/Os
    // --------------------------------------------------------------------
    input  wire [1:0]    buttons,                   // Push buttons
    input  wire [7:0]    dll_locked,                // DLL/PLL locked information

    // User expansion ports
    input  wire [51:0]   io_exp_port_i,             // I/O port inputs

    input  wire          ts_interrupt,

    // --------------------------------------------------------------------
    // ZBT Synchronous SRAM
    // --------------------------------------------------------------------

    // 64-bit ZBT Synchronous SRAM1 connections
    input  wire [63:0]   zbt_sram1_dq_i,            // Data input

    // 32-bit ZBT Synchronous SRAM2 connections
    input  wire [31:0]   zbt_sram2_dq_i,            // Data input

    // 32-bit ZBT Synchronous SRAM3 connections
    input  wire [31:0]   zbt_sram3_dq_i,            // Data input

    // 16-bit smb connections
    input  wire [15:0]   smb_data_i,                // Read Data

    // --------------------------------------------------------------------
    // UART
    // --------------------------------------------------------------------
    input  wire          uart_rxd_mcu,              // Microcontroller UART receive data
    input  wire          uart_rxd,                  // UART receive data (uart1)

    // --------------------------------------------------------------------
    // SPI
    // --------------------------------------------------------------------
    input  wire          spi0_data_in,              // SPI data in
    input  wire          config_spiclk,
    input  wire          config_spidi,

    // --------------------------------------------------------------------
    // Ethernet
    // --------------------------------------------------------------------
    input  wire          SMB_ETH_IRQ_n,

    // --------------------------------------------------------------------
    // Audio
    // --------------------------------------------------------------------
    input  wire          audio_mclk,                // Audio codec master clock (12.288MHz)
    input  wire          audio_sclk,                // Audio interface bit clock
    input  wire          audio_sdin,                // Audio ADC data
    input  wire          audio_sda_i,

    // --------------------------------------------------------------------
    // CLCD
    // --------------------------------------------------------------------
    input  wire          clcd_sda_i,
    input  wire          spi1_data_in,              // CLCD SPI data in

    // --------------------------------------------------------------------
    // Serial Communication Controller interface
    // --------------------------------------------------------------------
    input  wire          CFGCLK,
    input  wire          nCFGRST,

    input  wire          CFGLOAD,
    input  wire          CFGWnR,
    input  wire          CFGDATAIN,

    // --------------------------------------------------------------------
    // I/Os
    // --------------------------------------------------------------------
    output wire [1:0]    leds,                      // LEDs

    // User expansion ports
    output wire [51:0]   io_exp_port_o,             // I/O port outputs
    output wire [51:0]   io_exp_port_oen,           // I/O port output enables

    output wire [15:0]   gpio0_altfunc_o,           // Alternate function control
    output wire [15:0]   gpio1_altfunc_o,           // Alternate function control
    output wire [15:0]   gpio2_altfunc_o,           // Alternate function control
    output wire [15:0]   gpio3_altfunc_o,           // Alternate function control

    output wire [9:0]    fpga_misc,
    // --------------------------------------------------------------------
    // ZBT Synchronous SRAM
    // --------------------------------------------------------------------

    // 64-bit ZBT Synchronous SRAM1 connections
    output wire [19:0]   zbt_sram1_a,               // Address
    output wire [63:0]   zbt_sram1_dq_o,            // Data Output
    output wire          zbt_sram1_dq_oen,          // 3-state Buffer Enable
    output wire [7:0]    zbt_sram1_bwn,             // Byte lane writes (active low)
    output wire          zbt_sram1_cen,             // Chip Select (active low)
    output wire          zbt_sram1_wen,             // Write enable
    output wire          zbt_sram1_oen,             // Output enable (active low)
    output wire          zbt_sram1_lbon,            // Not used (tied to 0)
    output wire          zbt_sram1_adv,             // Not used (tied to 0)
    output wire          zbt_sram1_zz,              // Not used (tied to 0)
    output wire          zbt_sram1_cken,            // Not used (tied to 0)

    // 32-bit ZBT Synchronous SRAM2 connections
    output wire [19:0]   zbt_sram2_a,               // Address
    output wire [31:0]   zbt_sram2_dq_o,            // Data Output
    output wire          zbt_sram2_dq_oen,          // 3-state Buffer Enable
    output wire [3:0]    zbt_sram2_bwn,             // Byte lane writes (active low)
    output wire          zbt_sram2_cen,             // Chip Select (active low)
    output wire          zbt_sram2_wen,             // Write enable
    output wire          zbt_sram2_oen,             // Output enable (active low)
    output wire          zbt_sram2_lbon,            // Not used (tied to 0)
    output wire          zbt_sram2_adv,             // Not used (tied to 0)
    output wire          zbt_sram2_zz,              // Not used (tied to 0)
    output wire          zbt_sram2_cken,            // Not used (tied to 0)

    // 32-bit ZBT Synchronous SRAM3 connections
    output wire [19:0]   zbt_sram3_a,               // Address
    output wire [31:0]   zbt_sram3_dq_o,            // Data Output
    output wire          zbt_sram3_dq_oen,          // 3-state Buffer Enable
    output wire [3:0]    zbt_sram3_bwn,             // Byte lane writes (active low)
    output wire          zbt_sram3_cen,             // Chip Select (active low)
    output wire          zbt_sram3_wen,             // Write enable
    output wire          zbt_sram3_oen,             // Output enable (active low)
    output wire          zbt_sram3_lbon,            // Not used (tied to 0)
    output wire          zbt_sram3_adv,             // Not used (tied to 0)
    output wire          zbt_sram3_zz,              // Not used (tied to 0)
    output wire          zbt_sram3_cken,            // Not used (tied to 0)

    // 16-bit smb connections
    output wire [25:0]   smb_addr,                  // Address
    output wire [15:0]   smb_data_o,                // Write Data
    output wire          smb_data_o_nen,            // Write Data 3-state ctrl
    output wire          smb_cen,                   // Active low chip enable
    output wire          smb_oen,                   // Active low output enable (read)
    output wire          smb_wen,                   // Active low write enable
    output wire          smb_ubn,                   // Active low Upper Byte Enable
    output wire          smb_lbn,                   // Active low Upper Byte Enable
    output wire          smb_nrd,                   // Active low read enable
    output wire          smb_nreset,                // Active low reset

    // --------------------------------------------------------------------
    // UART
    // --------------------------------------------------------------------
    output wire          uart_txd_mcu,              // Microcontroller UART transmit data
    output wire          uart_txd_mcu_en,           // TX enable (enable 3-state buffer)
    output wire          uart_txd,                  // UART transmit data (Uart1)

    // --------------------------------------------------------------------
    // SPI
    // --------------------------------------------------------------------
    output wire          spi0_clk_out,              // SPI clock
    output wire          spi0_clk_out_en_n,         // SPI clock output enable (active low)
    output wire          spi0_data_out,             // SPI data out
    output wire          spi0_data_out_en_n,        // SPI data output enable (active low)
    output wire          spi0_sel,                  // SPI device select

    output wire          config_spido,

    // --------------------------------------------------------------------
    // VGA
    // --------------------------------------------------------------------
    output wire          vga_hsync,                 // VGA H-Sync
    output wire          vga_vsync,                 // VGA V-Sync
    output wire [3:0]    vga_r,                     // VGA red data
    output wire [3:0]    vga_g,                     // VGA green data
    output wire [3:0]    vga_b,                     // VGA blue data

    // --------------------------------------------------------------------
    // Audio
    // --------------------------------------------------------------------
    output wire          audio_lrck,                // Audio Left/Right clock
    output wire          audio_sdout,               // Audio DAC data
    output wire          audio_nrst,                // Audio reset

    output wire          audio_scl,
    output wire          audio_sda_o_en_n,          // When audio_sda_o_en_n=0, pull SDA low

    // --------------------------------------------------------------------
    // CLCD
    // --------------------------------------------------------------------
    output wire          clcd_scl,
    output wire          clcd_sda_o_en_n,

    output wire          spi1_clk_out,              // CLCD SPI clock
    output wire          spi1_clk_out_en_n,         // CLCD SPI clock output enable (active low)
    output wire          spi1_data_out,             // CLCD SPI data out
    output wire          spi1_data_out_en_n,        // CLCD SPI data output enable (active low)
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
    output wire          CFGDATAOUT,

    output wire          cfgint,

    // ----------------------------------------------------------------------------
    // Debug and Trace
    // ----------------------------------------------------------------------------
    input  wire          nTRST,                     // Test reset
    input  wire          SWDITMS,                   // Test Mode Select/SWDIN
    input  wire          SWCLKTCK,                  // Test clock / SWCLK
    input  wire          TDI,                       // Test Data In

    // Debug
    output wire          TDO,                       // Test Data Out
    output wire          nTDOEN,                    // Test Data Out Enable

    // Single Wire
    output wire          SWDO,                      // SingleWire data out
    output wire          SWDOEN,                    // SingleWire output enable
    output wire          JTAGNSW,                   // JTAG mode(1) or SW mode(0)

    // Single Wire Viewer
    output wire          SWV,                       // SingleWire Viewer Data

    // TracePort Output
    output wire          TRACECLK,                  // TracePort clock reference
    output wire    [3:0] TRACEDATA                  // TracePort Data

   );

  // --------------------------------------------------------------------
  // Integration signals
  // --------------------------------------------------------------------
  // AHB MTX (<-> Flash replacement)
  wire          targflash0hsel;
  wire   [31:0] targflash0haddr;
  wire    [1:0] targflash0htrans;
  wire          targflash0hwrite;
  wire    [2:0] targflash0hsize;
  wire   [31:0] targflash0hwdata;
  wire    [2:0] targflash0hburst;
  wire    [3:0] targflash0hprot;
  wire    [1:0] targflash0memattr;
  wire          targflash0exreq;
  wire    [3:0] targflash0hmaster;
  wire          targflash0hmastlock;
  wire          targflash0hauser;
  wire    [3:0] targflash0hwuser;
  wire          targflash0hreadymux;
  wire          targflash0hreadyout;
  wire   [31:0] targflash0hrdata;
  wire          targflash0hresp;
  wire          targflash0exresp;

  wire    [2:0] targflash0hruser;

  // Wires for IoT subsystem memories
  wire  [31:0]  SRAMFRDATA;            // SRAM Read data bus
  wire [12:0]   SRAMFADDR;             // SRAM address
  wire [3:0]    SRAMFWREN;             // SRAM Byte write enable
  wire [31:0]   SRAMFWDATA;            // SRAM Write data
  wire          SRAMFCS;               // SRAM Chip select

  wire  [31:0]  SRAM0RDATA;            // SRAM Read data bus
  wire [12:0]   SRAM0ADDR;             // SRAM address
  wire [3:0]    SRAM0WREN;             // SRAM Byte write enable
  wire [31:0]   SRAM0WDATA;            // SRAM Write data
  wire          SRAM0CS;               // SRAM Chip select

  wire  [31:0]  SRAM1RDATA;            // SRAM Read data bus
  wire [12:0]   SRAM1ADDR;             // SRAM address
  wire [3:0]    SRAM1WREN;             // SRAM Byte write enable
  wire [31:0]   SRAM1WDATA;            // SRAM Write data
  wire          SRAM1CS;               // SRAM Chip select

  wire  [31:0]  SRAM2RDATA;            // SRAM Read data bus
  wire [12:0]   SRAM2ADDR;             // SRAM address
  wire [3:0]    SRAM2WREN;             // SRAM Byte write enable
  wire [31:0]   SRAM2WDATA;            // SRAM Write data
  wire          SRAM2CS;               // SRAM Chip select

  wire  [31:0]  SRAM3RDATA;            // SRAM Read data bus
  wire [12:0]   SRAM3ADDR;             // SRAM address
  wire [3:0]    SRAM3WREN;             // SRAM Byte write enable
  wire [31:0]   SRAM3WDATA;            // SRAM Write data
  wire          SRAM3CS;               // SRAM Chip select

  // Expansion AHB master
  wire          targexp0hsel;
  wire [31:0]   targexp0haddr;
  wire [1:0]    targexp0htrans;
  wire          targexp0hwrite;
  wire [2:0]    targexp0hsize;
  wire [2:0]    targexp0hburst;
  wire [3:0]    targexp0hprot;
  wire [1:0]    targexp0memattr;
  wire          targexp0exreq;
  wire [3:0]    targexp0hmaster;
  wire [31:0]   targexp0hwdata;
  wire          targexp0hmastlock;
  wire          targexp0hreadymux;
  wire          targexp0hauser;
  wire [3:0]    targexp0hwuser;
  wire [31:0]   targexp0hrdata;
  wire          targexp0hreadyout;
  wire          targexp0hresp;
  wire          targexp0exresp;
  wire [2:0]    targexp0hruser;

  wire          targexp1hsel;
  wire [31:0]   targexp1haddr;
  wire [1:0]    targexp1htrans;
  wire          targexp1hwrite;
  wire [2:0]    targexp1hsize;
  wire [2:0]    targexp1hburst;
  wire [3:0]    targexp1hprot;
  wire [1:0]    targexp1memattr;
  wire          targexp1exreq;
  wire [3:0]    targexp1hmaster;
  wire [31:0]   targexp1hwdata;
  wire          targexp1hmastlock;
  wire          targexp1hreadymux;
  wire          targexp1hauser;
  wire [3:0]    targexp1hwuser;
  wire [31:0]   targexp1hrdata;
  wire          targexp1hreadyout;
  wire          targexp1hresp;
  wire          targexp1exresp;
  wire [2:0]    targexp1hruser;

  // expansion AHB slave input (tied off by default)
  wire          initexp0hsel;
  wire  [31:0]  initexp0haddr;
  wire  [1:0]   initexp0htrans;
  wire          initexp0hwrite;
  wire  [2:0]   initexp0hsize;
  wire  [2:0]   initexp0hburst;
  wire  [31:0]  initexp0hwdata;
  wire  [3:0]   initexp0hprot;
  wire  [1:0]   initexp0memattr;
  wire          initexp0exreq;
  wire [3:0]    initexp0hmaster;
  wire          initexp0hauser;
  wire [3:0]    initexp0hwuser;
  wire          initexp0exresp;
  wire [2:0]    initexp0hruser;
  wire          initexp0hmastlock;
  wire [31:0]   initexp0hrdata;
  wire          initexp0hready;
  wire          initexp0hresp;

  // AHB slave input driven from spi through a bridge
  wire          initexp1hsel;
  wire  [31:0]  initexp1haddr;
  wire  [1:0]   initexp1htrans;
  wire          initexp1hwrite;
  wire  [2:0]   initexp1hsize;
  wire  [2:0]   initexp1hburst;
  wire  [31:0]  initexp1hwdata;
  wire  [3:0]   initexp1hprot;
  wire  [1:0]   initexp1memattr;
  wire          initexp1exreq;
  wire [3:0]    initexp1hmaster;
  wire          initexp1hauser;
  wire [3:0]    initexp1hwuser;
  wire          initexp1exresp;
  wire [2:0]    initexp1hruser;
  wire          initexp1hmastlock;
  wire [31:0]   initexp1hrdata;
  wire          initexp1hready;
  wire          initexp1hresp;

  wire          apbtargexp2psel;
  wire          apbtargexp2penable;
  wire [11:0]   apbtargexp2paddr;
  wire          apbtargexp2pwrite;
  wire [31:0]   apbtargexp2pwdata;
  wire  [31:0]  apbtargexp2prdata;
  wire          apbtargexp2pready;
  wire          apbtargexp2pslverr;
  wire [3:0]    apbtargexp2pstrb;
  wire [2:0]    apbtargexp2pprot;
  wire          apbtargexp3psel;
  wire          apbtargexp3penable;
  wire [11:0]   apbtargexp3paddr;
  wire          apbtargexp3pwrite;
  wire [31:0]   apbtargexp3pwdata;
  wire  [31:0]  apbtargexp3prdata;
  wire          apbtargexp3pready;
  wire          apbtargexp3pslverr;
  wire [3:0]    apbtargexp3pstrb;
  wire [2:0]    apbtargexp3pprot;
  wire          apbtargexp4psel;
  wire          apbtargexp4penable;
  wire [11:0]   apbtargexp4paddr;
  wire          apbtargexp4pwrite;
  wire [31:0]   apbtargexp4pwdata;
  wire  [31:0]  apbtargexp4prdata;
  wire          apbtargexp4pready;
  wire          apbtargexp4pslverr;
  wire [3:0]    apbtargexp4pstrb;
  wire [2:0]    apbtargexp4pprot;
  wire          apbtargexp5psel;
  wire          apbtargexp5penable;
  wire [11:0]   apbtargexp5paddr;
  wire          apbtargexp5pwrite;
  wire [31:0]   apbtargexp5pwdata;
  wire  [31:0]  apbtargexp5prdata;
  wire          apbtargexp5pready;
  wire          apbtargexp5pslverr;
  wire [3:0]    apbtargexp5pstrb;
  wire [2:0]    apbtargexp5pprot;
  wire          apbtargexp6psel;
  wire          apbtargexp6penable;
  wire [11:0]   apbtargexp6paddr;
  wire          apbtargexp6pwrite;
  wire [31:0]   apbtargexp6pwdata;
  wire  [31:0]  apbtargexp6prdata;
  wire          apbtargexp6pready;
  wire          apbtargexp6pslverr;
  wire [3:0]    apbtargexp6pstrb;
  wire [2:0]    apbtargexp6pprot;
  wire          apbtargexp7psel;
  wire          apbtargexp7penable;
  wire [11:0]   apbtargexp7paddr;
  wire          apbtargexp7pwrite;
  wire [31:0]   apbtargexp7pwdata;
  wire  [31:0]  apbtargexp7prdata;
  wire          apbtargexp7pready;
  wire          apbtargexp7pslverr;
  wire [3:0]    apbtargexp7pstrb;
  wire [2:0]    apbtargexp7pprot;
  wire          apbtargexp8psel;
  wire          apbtargexp8penable;
  wire [11:0]   apbtargexp8paddr;
  wire          apbtargexp8pwrite;
  wire [31:0]   apbtargexp8pwdata;
  wire  [31:0]  apbtargexp8prdata;
  wire          apbtargexp8pready;
  wire          apbtargexp8pslverr;
  wire [3:0]    apbtargexp8pstrb;
  wire [2:0]    apbtargexp8pprot;
  wire          apbtargexp9psel;
  wire          apbtargexp9penable;
  wire [11:0]   apbtargexp9paddr;
  wire          apbtargexp9pwrite;
  wire [31:0]   apbtargexp9pwdata;
  wire  [31:0]  apbtargexp9prdata;
  wire          apbtargexp9pready;
  wire          apbtargexp9pslverr;
  wire [3:0]    apbtargexp9pstrb;
  wire [2:0]    apbtargexp9pprot;
  wire          apbtargexp10psel;
  wire          apbtargexp10penable;
  wire [11:0]   apbtargexp10paddr;
  wire          apbtargexp10pwrite;
  wire [31:0]   apbtargexp10pwdata;
  wire  [31:0]  apbtargexp10prdata;
  wire          apbtargexp10pready;
  wire          apbtargexp10pslverr;
  wire [3:0]    apbtargexp10pstrb;
  wire [2:0]    apbtargexp10pprot;
  wire          apbtargexp11psel;
  wire          apbtargexp11penable;
  wire [11:0]   apbtargexp11paddr;
  wire          apbtargexp11pwrite;
  wire [31:0]   apbtargexp11pwdata;
  wire  [31:0]  apbtargexp11prdata;
  wire          apbtargexp11pready;
  wire          apbtargexp11pslverr;
  wire [3:0]    apbtargexp11pstrb;
  wire [2:0]    apbtargexp11pprot;
  wire          apbtargexp12psel;
  wire          apbtargexp12penable;
  wire [11:0]   apbtargexp12paddr;
  wire          apbtargexp12pwrite;
  wire [31:0]   apbtargexp12pwdata;
  wire  [31:0]  apbtargexp12prdata;
  wire          apbtargexp12pready;
  wire          apbtargexp12pslverr;
  wire [3:0]    apbtargexp12pstrb;
  wire [2:0]    apbtargexp12pprot;
  wire          apbtargexp13psel;
  wire          apbtargexp13penable;
  wire [11:0]   apbtargexp13paddr;
  wire          apbtargexp13pwrite;
  wire [31:0]   apbtargexp13pwdata;
  wire  [31:0]  apbtargexp13prdata;
  wire          apbtargexp13pready;
  wire          apbtargexp13pslverr;
  wire [3:0]    apbtargexp13pstrb;
  wire [2:0]    apbtargexp13pprot;
  wire          apbtargexp14psel;
  wire          apbtargexp14penable;
  wire [11:0]   apbtargexp14paddr;
  wire          apbtargexp14pwrite;
  wire [31:0]   apbtargexp14pwdata;
  wire  [31:0]  apbtargexp14prdata;
  wire          apbtargexp14pready;
  wire          apbtargexp14pslverr;
  wire [3:0]    apbtargexp14pstrb;
  wire [2:0]    apbtargexp14pprot;
  wire          apbtargexp15psel;
  wire          apbtargexp15penable;
  wire [11:0]   apbtargexp15paddr;
  wire          apbtargexp15pwrite;
  wire [31:0]   apbtargexp15pwdata;
  wire  [31:0]  apbtargexp15prdata;
  wire          apbtargexp15pready;
  wire          apbtargexp15pslverr;
  wire [3:0]    apbtargexp15pstrb;
  wire [2:0]    apbtargexp15pprot;

 // peripheral interconnections
  wire [239:0]  cpu0intisr;
  wire          cpu0intnmi;

  wire          w_uart0_rxint, w_uart0_rxovrint;
  wire          w_uart0_txint, w_uart0_txovrint;
  wire          w_uart1_rxint, w_uart1_rxovrint;
  wire          w_uart1_txint, w_uart1_txovrint;
  wire [15:0]   w_gpio0_portint, w_gpio1_portint;

  wire          DEBUG_ALLOWED;      // When 1, debug is allowed. Controlled by emulated e-fuse.
                                    // Can be override using TESTMODE
  wire          w_DEBUG_CONNECTED;
  wire          cpu0edbgrq;         // Debug request to CPU

  wire [47:0]   cpu0tsvalueb;       // Timestamp for debug
  wire          cpu0halted;         // CPU halted
  wire          trcena;             // Trace Enable


  wire [3:1]    mtx_remap;

  // External SPI access to beid
  wire          hsel_initexp1;
  wire   [31:0] haddrs_initexp1;
  wire    [1:0] htranss_initexp1;
  wire    [1:0] hmasters_initexp1;
  wire          hwrites_initexp1;
  wire    [2:0] hsizes_initexp1;
  wire          hmastlocks_initexp1;
  wire   [31:0] hwdatas_initexp1;
  wire    [2:0] hbursts_initexp1;
  wire    [3:0] hprots_initexp1;
  wire    [1:0] memattrs_initexp1;
  wire          exreqs_initexp1;

  wire          hreadys_initexp1;
  wire   [31:0] hrdatas_initexp1;
  wire          hresps_initexp1;
  wire          exresps_initexp1;

  wire          cpu0lockup;
  wire          lockupreset;
  wire          wdog_reset_req;

  wire          cpu0sysresetreq;
  wire          cpu0cdbgpwrupreq;          // Debug Power Domain up request
  wire          cpu0cdbgpwrupack;          // Debug Power Domain up acknowledge

  wire          cpu0_bigend;


  //---------------------------------------------------
  // Clock
  //---------------------------------------------------

  // There are no gated clocks.
  wire MTXHCLK       = fclk;
  wire SRAMFHCLK     = fclk;
  wire SRAM0HCLK     = fclk;
  wire SRAM1HCLK     = fclk;
  wire SRAM2HCLK     = fclk;
  wire SRAM3HCLK     = fclk;
  wire SYSCTRLHCLK   = fclk;
  wire TIMER0PCLK    = fclk;
  wire TIMER0PCLKG   = fclk;
  wire TIMER1PCLK    = fclk;
  wire TIMER1PCLKG   = fclk;
  wire PCLK          = fclk;
  wire PCLKG         = fclk;
  wire AHB2APBHCLK   = fclk;
  wire CPU0FCLK      = fclk;
  wire CPU0HCLK      = fclk;
  wire TPIUTRACECLKIN= fclk;
  wire DTIMER_CLK    = fclk;
  wire UART0_CLK     = fclk;
  wire UART1_CLK     = fclk;
  wire RTC_CLK       = fclk;
  wire I2C0_CLK      = fclk;
  wire I2C1_CLK      = fclk;
  wire WDOG_CLK      = fclk;
  wire SPI0_CLK      = fclk;
  wire SPI1_CLK      = fclk;
  wire TRNG_CLK      = fclk;
  wire GPIO0_FCLK    = fclk;
  wire GPIO1_FCLK    = fclk;
  wire GPIO2_FCLK    = fclk;
  wire GPIO3_FCLK    = fclk;
  wire GPIO0_HCLK    = fclk;
  wire GPIO1_HCLK    = fclk;
  wire GPIO2_HCLK    = fclk;
  wire GPIO3_HCLK    = fclk;
  wire SYSCTRL_FCLK  = fclk;

  // --------------------------------------------------------------------
  // Reset
  // --------------------------------------------------------------------

  //                    PLL locked
  //                       |
  //                       V
  //  CB_nPOR -> sync -> delay -> fpga_npor -> reg_sys_rst_n -> hresetn, presetn (this level)
  //                       |                       ^
  //                       |                       |
  //                       |         design generated reset
  //                       |                       |
  //                       V                       V
  //  CB_nRST -> sync -> fpga_reset_n -> reg_cpu0_rst_n -> SYSRESETn (CMSDK)
  //                       |
  //                       \-----------------------------> PORESETn (CMSDK)
  //
  reg    reg_sys_rst_n;  // System reset
  reg    reg_cpu0_rst_n; // CPU reset

  wire   sys_reset_req = cpu0sysresetreq;
  // FPGA system level reset
  // This is controlled by fpga_npor because we want to download code
  // to ZBTRAM via SPI after CB_nPOR released, and before CB_nRST is released.
  always @(posedge fclk or negedge fpga_npor)
    begin
    if (~fpga_npor)
      reg_sys_rst_n <= 1'b0;
    else
      if ( sys_reset_req | wdog_reset_req | (cpu0lockup & lockupreset))
        reg_sys_rst_n <= 1'b0;
      else
        reg_sys_rst_n <= 1'b1;
    end

  // RESETn for CPU #0 - This is released after CB_nRST deasserted.
  // You can also add addition reset control here.
  always @(posedge fclk or negedge fpga_reset_n)
    begin
    if (~fpga_reset_n)
      reg_cpu0_rst_n <= 1'b0;
    else
      if ( sys_reset_req | wdog_reset_req | (cpu0lockup & lockupreset) | ~cs_nsrst_sync)
        reg_cpu0_rst_n <= 1'b0;
      else
        reg_cpu0_rst_n <= 1'b1;
    end

  // Explicit reset connections for each peripheral
  wire CPU0SYSRESETn   = reg_cpu0_rst_n; // For CPU only - release after CB_nRST
  wire CPU0PORESETn    = fpga_reset_n;   // For CPU only - release after CB_nRST
  wire MTXHRESETn      = reg_sys_rst_n;
  wire SRAMHRESETn     = reg_sys_rst_n;
  wire TIMER0PRESETn   = reg_sys_rst_n;
  wire TIMER1PRESETn   = reg_sys_rst_n;

  wire DTIMERPRESETn   = reg_sys_rst_n;
  wire UART0PRESETn    = reg_sys_rst_n;
  wire UART1PRESETn    = reg_sys_rst_n;
  wire RTCPRESETn      = reg_sys_rst_n;
  wire RTCnPOR         = fpga_reset_n;
  wire MPS2nPOR        = fpga_reset_n;
  wire I2C0PRESETn     = reg_sys_rst_n;
  wire I2C1PRESETn     = reg_sys_rst_n;
  wire WDOGPRESETn     = reg_sys_rst_n;
  wire WDOGRESn        = reg_sys_rst_n;
  wire SPI0PRESETn     = reg_sys_rst_n;
  wire SPI1PRESETn     = reg_sys_rst_n;
  wire TRNGPRESETn     = reg_sys_rst_n;

  wire GPIO0PRESETn    = reg_sys_rst_n;
  wire GPIO1PRESETn    = reg_sys_rst_n;
  wire GPIO2PRESETn    = reg_sys_rst_n;
  wire GPIO3PRESETn    = reg_sys_rst_n;
  wire SYSCTRLRESETn   = reg_sys_rst_n;
  wire AHBPRESETn      = reg_sys_rst_n;

  // --------------------------------------------------------------------
  // 1Hz clock for RTC
  // --------------------------------------------------------------------
  // Slowest clock available is the audio_sclk, this is 3.072MHz exactly.
  // So needs dividing by 3072000.  Or 1 phase of the clock is (3072000/2).
  // The counter needs to be 21 bits.
  `define RTC_HALF_PERIOD 21'd1535999   // (3072000/2)-1
  reg  [20:0] rtc_clock_count;
  wire        rtc_clock_count_tc;
  reg         rtc_1hz_clk;
  reg         rtc_rst_n;

  assign rtc_clock_count_tc = (rtc_clock_count == `RTC_HALF_PERIOD) ? 1'b1 : 1'b0;

  // RTC clock is reset by nPOR.
  always @(posedge audio_sclk or negedge fpga_reset_n)
    if (~fpga_reset_n)
        rtc_clock_count <= {21{1'b0}};
    else if ( rtc_clock_count_tc )
        rtc_clock_count <= {21{1'b0}};
    else
        rtc_clock_count <= rtc_clock_count + 21'h000001;

  // Reset the clock so that it can be simulated.  Also assists scan chains
  always @(posedge audio_sclk or negedge fpga_reset_n)
    if (~fpga_reset_n)
        rtc_1hz_clk <= 1'b0;
    else if ( rtc_clock_count_tc )
        rtc_1hz_clk <= ~rtc_1hz_clk;

  // rtc_rst_n is reset by reg_sys_rst_n
  always @(posedge audio_sclk or negedge reg_sys_rst_n)
    if (~reg_sys_rst_n)
        rtc_rst_n <= 1'b0;
    else  // Deassert on rising edge of audio_sclk
        rtc_rst_n <= 1'b1;


// --------------------------------------------------------------------
// Tie-offs and configuration for Cortex-M3
// --------------------------------------------------------------------

// SysTick Calibration for 25 MHz FCLK (STCLK is an enable, must be synchronous to FCLK or tied)
  wire        CPU0STCLK    = 1'b1;        // No alternative clock source
  wire [25:0] CPU0STCALIB;
  assign CPU0STCALIB[25]   = 1'b1;        // No alternative clock source
  assign CPU0STCALIB[24]   = 1'b0;        // Exact multiple of 10ms from FCLK
  assign CPU0STCALIB[23:0] = 24'h03D08F; // calibration value for 25 MHz source

  wire        CPU0DBGRESTART = 1'b0;      // Not needed in a single CPU system.

  // AUXFAULT: Connect to fault status generating logic if required.
  //Result appears in the Auxiliary Fault Status
  //Register at address 0xE000ED3C. A one-cycle pulse of
  //information results in the information being stored
  //in the corresponding bit until a write-clear occurs.
  wire [31:0] CPU0AUXFAULT = {32{1'b0}};

  // Active HIGH signal to the PMU that indicates a wake-up event has occurred and the system
  // requires clocks and power
  wire        CPU0WAKEUP;
  // Active HIGH request for deep sleep to be WIC-based deep sleep. This should be driven from a PMU.
  wire        CPU0WICENREQ = 1'b0;

  // WIC status
  wire        CPU0WICENACK; // For observation only. WIC is within the sybsystem
  wire [66:0] CPU0WICSENSE; // For observation only. WIC is within the sybsystem


  // CoreSight requires a loopback from REQ to ACK for a minimal
  // debug power control implementation
  assign      cpu0cdbgpwrupack = cpu0cdbgpwrupreq;

  wire [2:0]  TEST_CTRL;
  wire [31:0] ahbper0_reg;
  wire [31:0] apbper0_reg;
  wire        timer0extin = io_exp_port_i[1];
  wire        timer0privmoden = apbper0_reg[0]; // Timer0 secure
  wire        timer1extin = io_exp_port_i[6];
  wire        timer1privmoden = apbper0_reg[1]; // Timer1 secure
  wire        wdog_interrupt;
  wire        i2s_interrupt;
  wire [11:0] uart_interrupts;
  wire        eth_interrupt;
  wire [15:0] GPIO0PORTIN_i;
  wire [15:0] GPIO0PORTOUT_o;
  wire [15:0] GPIO0PORTEN_o;
  wire [15:0] GPIO1PORTIN_i;
  wire [15:0] GPIO1PORTOUT_o;
  wire [15:0] GPIO1PORTEN_o;
  wire [15:0] GPIO2PORTIN_i;
  wire [15:0] GPIO2PORTOUT_o;
  wire [15:0] GPIO2PORTEN_o;
  wire [15:0] GPIO3PORTIN_i;
  wire [15:0] GPIO3PORTOUT_o;
  wire [15:0] GPIO3PORTEN_o;
  // GPIO4 & 5 are unused
  wire [15:0] GPIO4PORTIN_i = {16{1'b0}};
  wire [15:0] GPIO4PORTOUT_o;
  wire [15:0] GPIO4PORTEN_o;
  wire [15:0] GPIO4PORTFUNC_o;
  wire [15:0] GPIO5PORTIN_i = {16{1'b0}};
  wire [15:0] GPIO5PORTOUT_o;
  wire [15:0] GPIO5PORTEN_o;
  wire [15:0] GPIO5PORTFUNC_o;

  wire        UART2RXD_i;
  wire        UART2TXD_o;
  wire        UART2TXEN_o;

  wire        sysctrlhsel_o;
  wire        sysctrlhreadyout_i;
  wire [31:0] sysctrlhrdata_i;
  wire        sysctrlhresp_i;
  wire        I2C0SCLKI_i;
  wire        I2C0SCLKO_o;
  wire        I2C0SCLKOE_o;
  wire        I2C0SDI_i;
  wire        I2C0SDO_o;
  wire        I2C0SDOE_o;
  wire        I2C1SCLKI_i;
  wire        I2C1SCLKO_o;
  wire        I2C1SCLKOE_o;
  wire        I2C1SDI_i;
  wire        I2C1SDO_o;
  wire        I2C1SDOE_o;
  wire        SPI0SSI_i;
  wire        SPI0SSO_o;
  wire        SPI0S_SEL_i;
  wire        SPI0SSCLKI_i;
  wire        SPI0SSOEN_o;
  wire        SPI0MEXTCLKI_i;
  wire        SPI0MSCLKO_o;
  wire        SPI0MSCLKOEN_o;
  wire        SPI0MSI_i;
  wire        SPI0MSO_o;
  wire        SPI0MSOEN_o;
  wire        SPI0MSSEN_o;
  wire [3:0]  SPI0MSS_SEL_o;
  wire        SPI0INT_o;
  wire        SPI1SSI_i;
  wire        SPI1SSO_o;
  wire        SPI1S_SEL_i;
  wire        SPI1SSCLKI_i;
  wire        SPI1SSOEN_o;
  wire        SPI1MEXTCLKI_i;
  wire        SPI1MSCLKO_o;
  wire        SPI1MSCLKOEN_o;
  wire        SPI1MSI_i;
  wire        SPI1MSO_o;
  wire        SPI1MSOEN_o;
  wire        SPI1MSSEN_o;
  wire [3:0]  SPI1MSS_SEL_o;


  // Tie-off configuration inputs to IoT subsystem
  wire        cpu0mpudisable    = 1'b0; // Tie high to emulate processor with no MPU
  wire        cpu0fixmastertype = 1'b0;
  wire        cpu0isolaten      = 1'b1;
  wire        cpu0retainn       = 1'b1;
  assign      mtx_remap         = {3{1'b0}};

  // DFT is tied off in this example
  // Typically routed to top level in ASIC
  wire        DFTSCANMODE = 1'b0;
  wire        DFTCGEN     = 1'b0;
  wire        DFTSE       = 1'b0;
  // Power and sleep management
  wire        cpu0sleepholdreqn = 1'b1;
  wire        cpu0rxev          = 1'b0;
  assign      cpu0edbgrq        = 1'b0;
  // Debug Authentication
  wire        cpu0dbgen         = 1'b1; // Enable for Halting Debug
  wire        cpu0niden         = 1'b1; // Must be high to access non-invasive debug

  // --------------------------------------------------------------------
  // Map individual interrupts to processor interrupt inputs
  // --------------------------------------------------------------------
  assign      cpu0intisr[0]     = w_uart0_txint | w_uart0_rxint;
  assign      cpu0intisr[1]     = 1'b0;
  assign      cpu0intisr[2]     = w_uart1_txint | w_uart1_rxint;
  assign      cpu0intisr[3]     = 1'b0;                                     // unused
  assign      cpu0intisr[4]     = 1'b0;                                     // unused
  assign      cpu0intisr[11]    = 1'b0;                                     // unused
  assign      cpu0intisr[12]    = w_uart0_txovrint   | w_uart0_rxovrint   |
                                  w_uart1_txovrint   | w_uart1_rxovrint   |
                                  uart_interrupts[7] | uart_interrupts[6] |
                                  uart_interrupts[9] | uart_interrupts[8] |
                                  uart_interrupts[11] | uart_interrupts[10];// UART 0,1,2,3,4 overflow
  assign      cpu0intisr[13]    = 1'b0;                                     //Unused
  assign      cpu0intisr[14]    = 1'b0;                                     //Unused
  assign      cpu0intisr[15]    = ts_interrupt;                             // MPS2 Touch screen
  assign      cpu0intisr[31:16] = w_gpio0_portint;
  assign      cpu0intisr[41:34] = {8{1'b0}};                                //Reserved for CORDIO
  assign      cpu0intisr[45]    = uart_interrupts[0]  | uart_interrupts[1]; // UART2 TX and RX
  assign      cpu0intisr[46]    = uart_interrupts[2]  | uart_interrupts[3]; // UART3 TX and RX
  assign      cpu0intisr[47]    = eth_interrupt;                            // MPS2 Ethernet interrupt
  assign      cpu0intisr[48]    = i2s_interrupt;                            // MPS2 I2C interrupt
  assign      cpu0intisr[56]    = uart_interrupts[4]  | uart_interrupts[5]; // UART4 TX and RX
  assign      cpu0intisr[239:57] = {183{1'b0}};

  // --------------------------------------------------------------------
  // Tie-off the AHB Slave expansion reserved for communication interface/DMA
  // --------------------------------------------------------------------
  assign initexp0hsel      = 1'b0;
  assign initexp0htrans    = 2'b00;
  assign initexp0hwrite    = 1'b0;
  assign initexp0haddr     = {32{1'b0}};
  assign initexp0hsize     = {3{1'b0}};
  assign initexp0hburst    = {3{1'b0}};
  assign initexp0hprot     = {4{1'b0}};
  assign initexp0memattr   = {2{1'b0}};
  assign initexp0exreq     = 1'b0;
  assign initexp0hmaster   = {4{1'b0}};
  assign initexp0hwdata    = {32{1'b0}};
  assign initexp0hmastlock = 1'b0;
  assign initexp0hauser    = 1'b0;
  assign initexp0hwuser    = {4{1'b0}};

  assign initexp1hauser    = 1'b0;
  assign initexp1hwuser    = {4{1'b0}};

  // --------------------------------------------------------------------
  // Code Download from external MCU over SPI
  // This drives one of the AHB slave ports on the IoT subsystem
  // --------------------------------------------------------------------
  fpga_spi_ahb u_fpga_spi_ahb (

    .HCLK                 (fclk),
    .nPOR                 (reg_sys_rst_n),
    .CONFIG_SPICLK        (config_spiclk),
    .CONFIG_SPIDI         (config_spidi),
    .CONFIG_SPIDO         (config_spido),

    .HSELM                (initexp1hsel),
    .HADDRM               (initexp1haddr),
    .HTRANSM              (initexp1htrans),
    .HMASTERM             (initexp1hmaster),
    .HWRITEM              (initexp1hwrite),
    .HSIZEM               (initexp1hsize),
    .HMASTLOCKM           (initexp1hmastlock),
    .HWDATAM              (initexp1hwdata),
    .HBURSTM              (initexp1hburst),
    .HPROTM               (initexp1hprot),
    .MEMATTRM             (initexp1memattr),
    .EXREQM               (initexp1exreq),
    .HREADYM              (initexp1hready),
    .HRDATAM              (initexp1hrdata),
    .HRESPM               (initexp1hresp),
    .EXRESPM              (initexp1exresp)
  );

  // ETM timestamp counter
  wire enablecnt = trcena & ~cpu0halted;

  m3ds_tscnt_48 u_m3ds_tscnt_48 (

    .clk                  (CPU0FCLK),
    .resetn               (CPU0PORESETn),

    .enablecnt_i          (enablecnt),
    .tsvalueb_o           (cpu0tsvalueb)
  );

  // --------------------------------------------------------------------
  // Simplified SSE-050 subsystem
  //
  // An ASIC design can replace this module with SSE-050
  // --------------------------------------------------------------------

  m3ds_iot_top u_iot_top(
    .CPU0FCLK              (CPU0FCLK),
    .CPU0HCLK              (CPU0HCLK),
    .TPIUTRACECLKIN        (TPIUTRACECLKIN),
    .CPU0PORESETn          (CPU0PORESETn),
    .CPU0SYSRESETn         (CPU0SYSRESETn),
    .CPU0STCLK             (CPU0STCLK),
    .CPU0STCALIB           (CPU0STCALIB),
    .SRAM0HCLK             (SRAM0HCLK),
    .SRAM1HCLK             (SRAM1HCLK),
    .SRAM2HCLK             (SRAM2HCLK),
    .SRAM3HCLK             (SRAM3HCLK),
    .MTXHCLK               (MTXHCLK),
    .MTXHRESETn            (MTXHRESETn),
    .AHB2APBHCLK           (AHB2APBHCLK),
    .TIMER0PCLK            (TIMER0PCLK),
    .TIMER0PCLKG           (TIMER0PCLKG),
    .TIMER0PRESETn         (TIMER0PRESETn),
    .TIMER1PCLK            (TIMER1PCLK),
    .TIMER1PCLKG           (TIMER1PCLKG),
    .TIMER1PRESETn         (TIMER1PRESETn),
    .SRAM0RDATA            (SRAM0RDATA),
    .SRAM0ADDR             (SRAM0ADDR),
    .SRAM0WREN             (SRAM0WREN),
    .SRAM0WDATA            (SRAM0WDATA),
    .SRAM0CS               (SRAM0CS),
    .SRAM1RDATA            (SRAM1RDATA),
    .SRAM1ADDR             (SRAM1ADDR),
    .SRAM1WREN             (SRAM1WREN),
    .SRAM1WDATA            (SRAM1WDATA),
    .SRAM1CS               (SRAM1CS),
    .SRAM2RDATA            (SRAM2RDATA),
    .SRAM2ADDR             (SRAM2ADDR),
    .SRAM2WREN             (SRAM2WREN),
    .SRAM2WDATA            (SRAM2WDATA),
    .SRAM2CS               (SRAM2CS),
    .SRAM3RDATA            (SRAM3RDATA),
    .SRAM3ADDR             (SRAM3ADDR),
    .SRAM3WREN             (SRAM3WREN),
    .SRAM3WDATA            (SRAM3WDATA),
    .SRAM3CS               (SRAM3CS),
    .TIMER0EXTIN           (timer0extin),
    .TIMER0PRIVMODEN       (timer0privmoden),
    .TIMER1EXTIN           (timer1extin),
    .TIMER1PRIVMODEN       (timer1privmoden),
    .TIMER0TIMERINT        (cpu0intisr[8]),
    .TIMER1TIMERINT        (cpu0intisr[9]),
    .TARGFLASH0HSEL        (targflash0hsel),
    .TARGFLASH0HADDR       (targflash0haddr),
    .TARGFLASH0HTRANS      (targflash0htrans),
    .TARGFLASH0HWRITE      (targflash0hwrite),
    .TARGFLASH0HSIZE       (targflash0hsize),
    .TARGFLASH0HBURST      (targflash0hburst),
    .TARGFLASH0HPROT       (targflash0hprot),
    .TARGFLASH0MEMATTR     (targflash0memattr),
    .TARGFLASH0EXREQ       (targflash0exreq),
    .TARGFLASH0HMASTER     (targflash0hmaster),
    .TARGFLASH0HWDATA      (targflash0hwdata),
    .TARGFLASH0HMASTLOCK   (targflash0hmastlock),
    .TARGFLASH0HREADYMUX   (targflash0hreadymux),
    .TARGFLASH0HAUSER      (targflash0hauser),
    .TARGFLASH0HWUSER      (targflash0hwuser),
    .TARGFLASH0HRDATA      (targflash0hrdata),
    .TARGFLASH0HREADYOUT   (targflash0hreadyout),
    .TARGFLASH0HRESP       (targflash0hresp),
    .TARGFLASH0EXRESP      (targflash0exresp),
    .TARGFLASH0HRUSER      (targflash0hruser),
    .TARGEXP0HSEL          (targexp0hsel),
    .TARGEXP0HADDR         (targexp0haddr),
    .TARGEXP0HTRANS        (targexp0htrans),
    .TARGEXP0HWRITE        (targexp0hwrite),
    .TARGEXP0HSIZE         (targexp0hsize),
    .TARGEXP0HBURST        (targexp0hburst),
    .TARGEXP0HPROT         (targexp0hprot),
    .TARGEXP0MEMATTR       (targexp0memattr),
    .TARGEXP0EXREQ         (targexp0exreq),
    .TARGEXP0HMASTER       (targexp0hmaster),
    .TARGEXP0HWDATA        (targexp0hwdata),
    .TARGEXP0HMASTLOCK     (targexp0hmastlock),
    .TARGEXP0HREADYMUX     (targexp0hreadymux),
    .TARGEXP0HAUSER        (targexp0hauser),
    .TARGEXP0HWUSER        (targexp0hwuser),
    .TARGEXP0HRDATA        (targexp0hrdata),
    .TARGEXP0HREADYOUT     (targexp0hreadyout),
    .TARGEXP0HRESP         (targexp0hresp),
    .TARGEXP0EXRESP        (targexp0exresp),
    .TARGEXP0HRUSER        (targexp0hruser),
    .TARGEXP1HSEL          (targexp1hsel),
    .TARGEXP1HADDR         (targexp1haddr),
    .TARGEXP1HTRANS        (targexp1htrans),
    .TARGEXP1HWRITE        (targexp1hwrite),
    .TARGEXP1HSIZE         (targexp1hsize),
    .TARGEXP1HBURST        (targexp1hburst),
    .TARGEXP1HPROT         (targexp1hprot),
    .TARGEXP1MEMATTR       (targexp1memattr),
    .TARGEXP1EXREQ         (targexp1exreq),
    .TARGEXP1HMASTER       (targexp1hmaster),
    .TARGEXP1HWDATA        (targexp1hwdata),
    .TARGEXP1HMASTLOCK     (targexp1hmastlock),
    .TARGEXP1HREADYMUX     (targexp1hreadymux),
    .TARGEXP1HAUSER        (targexp1hauser),
    .TARGEXP1HWUSER        (targexp1hwuser),
    .TARGEXP1HRDATA        (targexp1hrdata),
    .TARGEXP1HREADYOUT     (targexp1hreadyout),
    .TARGEXP1HRESP         (targexp1hresp),
    .TARGEXP1EXRESP        (targexp1exresp),
    .TARGEXP1HRUSER        (targexp1hruser),
    .INITEXP0HSEL          (initexp0hsel),
    .INITEXP0HADDR         (initexp0haddr),
    .INITEXP0HTRANS        (initexp0htrans),
    .INITEXP0HWRITE        (initexp0hwrite),
    .INITEXP0HSIZE         (initexp0hsize),
    .INITEXP0HBURST        (initexp0hburst),
    .INITEXP0HPROT         (initexp0hprot),
    .INITEXP0MEMATTR       (initexp0memattr),
    .INITEXP0EXREQ         (initexp0exreq),
    .INITEXP0HMASTER       (initexp0hmaster),
    .INITEXP0HWDATA        (initexp0hwdata),
    .INITEXP0HMASTLOCK     (initexp0hmastlock),
    .INITEXP0HAUSER        (initexp0hauser),
    .INITEXP0HWUSER        (initexp0hwuser),
    .INITEXP0HRDATA        (initexp0hrdata),
    .INITEXP0HREADY        (initexp0hready),
    .INITEXP0HRESP         (initexp0hresp),
    .INITEXP0EXRESP        (initexp0exresp),
    .INITEXP0HRUSER        (initexp0hruser),
    .INITEXP1HSEL          (initexp1hsel),
    .INITEXP1HADDR         (initexp1haddr),
    .INITEXP1HTRANS        (initexp1htrans),
    .INITEXP1HWRITE        (initexp1hwrite),
    .INITEXP1HSIZE         (initexp1hsize),
    .INITEXP1HBURST        (initexp1hburst),
    .INITEXP1HPROT         (initexp1hprot),
    .INITEXP1MEMATTR       (initexp1memattr),
    .INITEXP1EXREQ         (initexp1exreq),
    .INITEXP1HMASTER       (initexp1hmaster),
    .INITEXP1HWDATA        (initexp1hwdata),
    .INITEXP1HMASTLOCK     (initexp1hmastlock),
    .INITEXP1HAUSER        (initexp1hauser),
    .INITEXP1HWUSER        (initexp1hwuser),
    .INITEXP1HRDATA        (initexp1hrdata),
    .INITEXP1HREADY        (initexp1hready),
    .INITEXP1HRESP         (initexp1hresp),
    .INITEXP1EXRESP        (initexp1exresp),
    .INITEXP1HRUSER        (initexp1hruser),
    .APBTARGEXP2PSEL       (apbtargexp2psel),
    .APBTARGEXP2PENABLE    (apbtargexp2penable),
    .APBTARGEXP2PADDR      (apbtargexp2paddr),
    .APBTARGEXP2PWRITE     (apbtargexp2pwrite),
    .APBTARGEXP2PWDATA     (apbtargexp2pwdata),
    .APBTARGEXP2PRDATA     (apbtargexp2prdata),
    .APBTARGEXP2PREADY     (apbtargexp2pready),
    .APBTARGEXP2PSLVERR    (apbtargexp2pslverr),
    .APBTARGEXP2PSTRB      (apbtargexp2pstrb),
    .APBTARGEXP2PPROT      (apbtargexp2pprot),
    .APBTARGEXP3PSEL       (apbtargexp3psel),
    .APBTARGEXP3PENABLE    (apbtargexp3penable),
    .APBTARGEXP3PADDR      (apbtargexp3paddr),
    .APBTARGEXP3PWRITE     (apbtargexp3pwrite),
    .APBTARGEXP3PWDATA     (apbtargexp3pwdata),
    .APBTARGEXP3PRDATA     (apbtargexp3prdata),
    .APBTARGEXP3PREADY     (apbtargexp3pready),
    .APBTARGEXP3PSLVERR    (apbtargexp3pslverr),
    .APBTARGEXP3PSTRB      (apbtargexp3pstrb),
    .APBTARGEXP3PPROT      (apbtargexp3pprot),
    .APBTARGEXP4PSEL       (apbtargexp4psel),
    .APBTARGEXP4PENABLE    (apbtargexp4penable),
    .APBTARGEXP4PADDR      (apbtargexp4paddr),
    .APBTARGEXP4PWRITE     (apbtargexp4pwrite),
    .APBTARGEXP4PWDATA     (apbtargexp4pwdata),
    .APBTARGEXP4PRDATA     (apbtargexp4prdata),
    .APBTARGEXP4PREADY     (apbtargexp4pready),
    .APBTARGEXP4PSLVERR    (apbtargexp4pslverr),
    .APBTARGEXP4PSTRB      (apbtargexp4pstrb),
    .APBTARGEXP4PPROT      (apbtargexp4pprot),
    .APBTARGEXP5PSEL       (apbtargexp5psel),
    .APBTARGEXP5PENABLE    (apbtargexp5penable),
    .APBTARGEXP5PADDR      (apbtargexp5paddr),
    .APBTARGEXP5PWRITE     (apbtargexp5pwrite),
    .APBTARGEXP5PWDATA     (apbtargexp5pwdata),
    .APBTARGEXP5PRDATA     (apbtargexp5prdata),
    .APBTARGEXP5PREADY     (apbtargexp5pready),
    .APBTARGEXP5PSLVERR    (apbtargexp5pslverr),
    .APBTARGEXP5PSTRB      (apbtargexp5pstrb),
    .APBTARGEXP5PPROT      (apbtargexp5pprot),
    .APBTARGEXP6PSEL       (apbtargexp6psel),
    .APBTARGEXP6PENABLE    (apbtargexp6penable),
    .APBTARGEXP6PADDR      (apbtargexp6paddr),
    .APBTARGEXP6PWRITE     (apbtargexp6pwrite),
    .APBTARGEXP6PWDATA     (apbtargexp6pwdata),
    .APBTARGEXP6PRDATA     (apbtargexp6prdata),
    .APBTARGEXP6PREADY     (apbtargexp6pready),
    .APBTARGEXP6PSLVERR    (apbtargexp6pslverr),
    .APBTARGEXP6PSTRB      (apbtargexp6pstrb),
    .APBTARGEXP6PPROT      (apbtargexp6pprot),
    .APBTARGEXP7PSEL       (apbtargexp7psel),
    .APBTARGEXP7PENABLE    (apbtargexp7penable),
    .APBTARGEXP7PADDR      (apbtargexp7paddr),
    .APBTARGEXP7PWRITE     (apbtargexp7pwrite),
    .APBTARGEXP7PWDATA     (apbtargexp7pwdata),
    .APBTARGEXP7PRDATA     (apbtargexp7prdata),
    .APBTARGEXP7PREADY     (apbtargexp7pready),
    .APBTARGEXP7PSLVERR    (apbtargexp7pslverr),
    .APBTARGEXP7PSTRB      (apbtargexp7pstrb),
    .APBTARGEXP7PPROT      (apbtargexp7pprot),
    .APBTARGEXP8PSEL       (apbtargexp8psel),
    .APBTARGEXP8PENABLE    (apbtargexp8penable),
    .APBTARGEXP8PADDR      (apbtargexp8paddr),
    .APBTARGEXP8PWRITE     (apbtargexp8pwrite),
    .APBTARGEXP8PWDATA     (apbtargexp8pwdata),
    .APBTARGEXP8PRDATA     (apbtargexp8prdata),
    .APBTARGEXP8PREADY     (apbtargexp8pready),
    .APBTARGEXP8PSLVERR    (apbtargexp8pslverr),
    .APBTARGEXP8PSTRB      (apbtargexp8pstrb),
    .APBTARGEXP8PPROT      (apbtargexp8pprot),
    .APBTARGEXP9PSEL       (apbtargexp9psel),
    .APBTARGEXP9PENABLE    (apbtargexp9penable),
    .APBTARGEXP9PADDR      (apbtargexp9paddr),
    .APBTARGEXP9PWRITE     (apbtargexp9pwrite),
    .APBTARGEXP9PWDATA     (apbtargexp9pwdata),
    .APBTARGEXP9PRDATA     (apbtargexp9prdata),
    .APBTARGEXP9PREADY     (apbtargexp9pready),
    .APBTARGEXP9PSLVERR    (apbtargexp9pslverr),
    .APBTARGEXP9PSTRB      (apbtargexp9pstrb),
    .APBTARGEXP9PPROT      (apbtargexp9pprot),
    .APBTARGEXP10PSEL      (apbtargexp10psel),
    .APBTARGEXP10PENABLE   (apbtargexp10penable),
    .APBTARGEXP10PADDR     (apbtargexp10paddr),
    .APBTARGEXP10PWRITE    (apbtargexp10pwrite),
    .APBTARGEXP10PWDATA    (apbtargexp10pwdata),
    .APBTARGEXP10PRDATA    (apbtargexp10prdata),
    .APBTARGEXP10PREADY    (apbtargexp10pready),
    .APBTARGEXP10PSLVERR   (apbtargexp10pslverr),
    .APBTARGEXP10PSTRB     (apbtargexp10pstrb),
    .APBTARGEXP10PPROT     (apbtargexp10pprot),
    .APBTARGEXP11PSEL      (apbtargexp11psel),
    .APBTARGEXP11PENABLE   (apbtargexp11penable),
    .APBTARGEXP11PADDR     (apbtargexp11paddr),
    .APBTARGEXP11PWRITE    (apbtargexp11pwrite),
    .APBTARGEXP11PWDATA    (apbtargexp11pwdata),
    .APBTARGEXP11PRDATA    (apbtargexp11prdata),
    .APBTARGEXP11PREADY    (apbtargexp11pready),
    .APBTARGEXP11PSLVERR   (apbtargexp11pslverr),
    .APBTARGEXP11PSTRB     (apbtargexp11pstrb),
    .APBTARGEXP11PPROT     (apbtargexp11pprot),
    .APBTARGEXP12PSEL      (apbtargexp12psel),
    .APBTARGEXP12PENABLE   (apbtargexp12penable),
    .APBTARGEXP12PADDR     (apbtargexp12paddr),
    .APBTARGEXP12PWRITE    (apbtargexp12pwrite),
    .APBTARGEXP12PWDATA    (apbtargexp12pwdata),
    .APBTARGEXP12PRDATA    (apbtargexp12prdata),
    .APBTARGEXP12PREADY    (apbtargexp12pready),
    .APBTARGEXP12PSLVERR   (apbtargexp12pslverr),
    .APBTARGEXP12PSTRB     (apbtargexp12pstrb),
    .APBTARGEXP12PPROT     (apbtargexp12pprot),
    .APBTARGEXP13PSEL      (apbtargexp13psel),
    .APBTARGEXP13PENABLE   (apbtargexp13penable),
    .APBTARGEXP13PADDR     (apbtargexp13paddr),
    .APBTARGEXP13PWRITE    (apbtargexp13pwrite),
    .APBTARGEXP13PWDATA    (apbtargexp13pwdata),
    .APBTARGEXP13PRDATA    (apbtargexp13prdata),
    .APBTARGEXP13PREADY    (apbtargexp13pready),
    .APBTARGEXP13PSLVERR   (apbtargexp13pslverr),
    .APBTARGEXP13PSTRB     (apbtargexp13pstrb),
    .APBTARGEXP13PPROT     (apbtargexp13pprot),
    .APBTARGEXP14PSEL      (apbtargexp14psel),
    .APBTARGEXP14PENABLE   (apbtargexp14penable),
    .APBTARGEXP14PADDR     (apbtargexp14paddr),
    .APBTARGEXP14PWRITE    (apbtargexp14pwrite),
    .APBTARGEXP14PWDATA    (apbtargexp14pwdata),
    .APBTARGEXP14PRDATA    (apbtargexp14prdata),
    .APBTARGEXP14PREADY    (apbtargexp14pready),
    .APBTARGEXP14PSLVERR   (apbtargexp14pslverr),
    .APBTARGEXP14PSTRB     (apbtargexp14pstrb),
    .APBTARGEXP14PPROT     (apbtargexp14pprot),
    .APBTARGEXP15PSEL      (apbtargexp15psel),
    .APBTARGEXP15PENABLE   (apbtargexp15penable),
    .APBTARGEXP15PADDR     (apbtargexp15paddr),
    .APBTARGEXP15PWRITE    (apbtargexp15pwrite),
    .APBTARGEXP15PWDATA    (apbtargexp15pwdata),
    .APBTARGEXP15PRDATA    (apbtargexp15prdata),
    .APBTARGEXP15PREADY    (apbtargexp15pready),
    .APBTARGEXP15PSLVERR   (apbtargexp15pslverr),
    .APBTARGEXP15PSTRB     (apbtargexp15pstrb),
    .APBTARGEXP15PPROT     (apbtargexp15pprot),      //
    .CPU0EDBGRQ            (cpu0edbgrq),
    .CPU0DBGRESTART        (CPU0DBGRESTART),
    .CPU0DBGRESTARTED      (/*unused*/), // Not used here in single core system
    .CPU0HTMDHADDR         (/*unused*/), // HTM not used in typical systems
    .CPU0HTMDHTRANS        (/*unused*/), // Sometimes used in FPGA for debug
    .CPU0HTMDHSIZE         (/*unused*/),
    .CPU0HTMDHBURST        (/*unused*/),
    .CPU0HTMDHPROT         (/*unused*/),
    .CPU0HTMDHWDATA        (/*unused*/),
    .CPU0HTMDHWRITE        (/*unused*/),
    .CPU0HTMDHRDATA        (/*unused*/),
    .CPU0HTMDHREADY        (/*unused*/),
    .CPU0HTMDHRESP         (/*unused*/),
    .CPU0TSVALUEB          (cpu0tsvalueb),
    .CPU0ETMINTNUM         (/*unused*/), // Exception state visibility
    .CPU0ETMINTSTAT        (/*unused*/), // Exception state visibility
    .CPU0HALTED            (cpu0halted),
    .CPU0MPUDISABLE        (cpu0mpudisable),
    .CPU0SLEEPING          (/*unused*/), // Not used without power management
    .CPU0SLEEPDEEP         (/*unused*/), // Not used without power management
    .CPU0SLEEPHOLDREQn     (cpu0sleepholdreqn),
    .CPU0SLEEPHOLDACKn     (/*unused*/), // Not used without power management
    .CPU0WAKEUP            (CPU0WAKEUP),
    .CPU0WICENACK          (CPU0WICENACK),
    .CPU0WICSENSE          (CPU0WICSENSE),
    .CPU0WICENREQ          (CPU0WICENREQ),
    .CPU0SYSRESETREQ       (cpu0sysresetreq),
    .CPU0LOCKUP            (cpu0lockup),
    .CPU0CDBGPWRUPREQ      (cpu0cdbgpwrupreq),  // Debug Power Domain up request
    .CPU0CDBGPWRUPACK      (cpu0cdbgpwrupack),  // Debug Power Domain up acknowledge
    .CPU0BRCHSTAT          (/*unused*/),        // CPU Pipeline visibility
    .MTXREMAP              (mtx_remap),
    .CPU0RXEV              (cpu0rxev),
    .CPU0TXEV              (/*unused*/),
    .CPU0INTISR            (cpu0intisr),
    .CPU0INTNMI            (cpu0intnmi),
    .CPU0CURRPRI           (/*unused*/),
    .CPU0AUXFAULT          (CPU0AUXFAULT),
    .APBQACTIVE            (/*unused*/),
    .TIMER0PCLKQACTIVE     (/*unused*/),
    .TIMER1PCLKQACTIVE     (/*unused*/),
    .CPU0DBGEN             (cpu0dbgen),
    .CPU0NIDEN             (cpu0niden),
    .CPU0FIXMASTERTYPE     (cpu0fixmastertype),
    .CPU0ISOLATEn          (cpu0isolaten),
    .CPU0RETAINn           (cpu0retainn),
    .DFTSCANMODE           (DFTSCANMODE),
    .DFTCGEN               (DFTCGEN),
    .DFTSE                 (DFTSE),
    .CPU0GATEHCLK          (/*unused*/),
    .nTRST                 (nTRST),            // JTAG TAP Reset
    .SWCLKTCK              (SWCLKTCK),         // SW/JTAG Clock
    .SWDITMS               (SWDITMS),          // SW Debug Data In / JTAG Test Mode Select
    .TDI                   (TDI),              // JTAG TAP Data In / Alternative input function
    .TDO                   (TDO),              // JTAG TAP Data Out
    .nTDOEN                (nTDOEN),           // TDO enable
    .SWDO                  (SWDO),             // SW Data Out
    .SWDOEN                (SWDOEN),           // SW Data Out Enable
    .JTAGNSW               (JTAGNSW),          // JTAG/not Serial Wire Mode
    .SWV                   (SWV),              // SingleWire Viewer Data
    .TRACECLK              (TRACECLK),         // TRACECLK output
    .TRACEDATA             (TRACEDATA),        // Trace Data
    .TRCENA                (trcena),           // Trace Enable

    .CPU0BIGEND            (cpu0_bigend)
    );

  // --------------------------------------------------------------------
  // SRAM to replace FLASH in FPGA
  // --------------------------------------------------------------------

    m3ds_simple_flash u_m3ds_simple_flash (
    .hclk                  (SRAMFHCLK),
    .hresetn               (MTXHRESETn),
    .hsel_i                (targflash0hsel),
    .haddr_i               (targflash0haddr),
    .htrans_i              (targflash0htrans),
    .hwrite_i              (targflash0hwrite),
    .hsize_i               (targflash0hsize),
    .hburst_i              (targflash0hburst),
    .hprot_i               (targflash0hprot),
    .memattr_i             (targflash0memattr),
    .exreq_i               (targflash0exreq),
    .hmaster_i             (targflash0hmaster),
    .hwdata_i              (targflash0hwdata),
    .hmastlock_i           (targflash0hmastlock),
    .hreadymux_i           (targflash0hreadymux),
    .hauser_i              (targflash0hauser),
    .hwuser_i              (targflash0hwuser),
    .hrdata_o              (targflash0hrdata),
    .hreadyout_o           (targflash0hreadyout),
    .hresp_o               (targflash0hresp),
    .exresp_o              (targflash0exresp),
    .hruser_o              (targflash0hruser),
    .flash_err_o           (cpu0intisr[32]),    // Flash memory/System error
    .flash_int_o           (cpu0intisr[33]),    // EFlash interrupt

    .pclk                  (PCLK),
    .pclkg                 (PCLKG),
    .apbtargexp3psel_i     (apbtargexp3psel),
    .apbtargexp3penable_i  (apbtargexp3penable),
    .apbtargexp3paddr_i    (apbtargexp3paddr),
    .apbtargexp3pwrite_i   (apbtargexp3pwrite),
    .apbtargexp3pwdata_i   (apbtargexp3pwdata),
    .apbtargexp3prdata_o   (apbtargexp3prdata),
    .apbtargexp3pready_o   (apbtargexp3pready),
    .apbtargexp3pslverr_o  (apbtargexp3pslverr),
    .apbtargexp3pstrb_i    (apbtargexp3pstrb),
    .apbtargexp3pprot_i    (apbtargexp3pprot),

    .apbtargexp9psel_i     (apbtargexp9psel),
    .apbtargexp9penable_i  (apbtargexp9penable),
    .apbtargexp9paddr_i    (apbtargexp9paddr),
    .apbtargexp9pwrite_i   (apbtargexp9pwrite),
    .apbtargexp9pwdata_i   (apbtargexp9pwdata),
    .apbtargexp9prdata_o   (apbtargexp9prdata),
    .apbtargexp9pready_o   (apbtargexp9pready),
    .apbtargexp9pslverr_o  (apbtargexp9pslverr),
    .apbtargexp9pstrb_i    (apbtargexp9pstrb),
    .apbtargexp9pprot_i    (apbtargexp9pprot),

    .apbtargexp10psel_i    (apbtargexp10psel),
    .apbtargexp10penable_i (apbtargexp10penable),
    .apbtargexp10paddr_i   (apbtargexp10paddr),
    .apbtargexp10pwrite_i  (apbtargexp10pwrite),
    .apbtargexp10pwdata_i  (apbtargexp10pwdata),
    .apbtargexp10prdata_o  (apbtargexp10prdata),
    .apbtargexp10pready_o  (apbtargexp10pready),
    .apbtargexp10pslverr_o (apbtargexp10pslverr),
    .apbtargexp10pstrb_i   (apbtargexp10pstrb),
    .apbtargexp10pprot_i   (apbtargexp10pprot)

    );

  // Core memories for IoT subsystem, suitable for FPGA
  m3ds_sram_subsystem_fpga
    u_sram_subsystem
      (
       .SRAMHRESETn (SRAMHRESETn),
       .SRAM0HCLK   (SRAM0HCLK),
       .SRAM0RDATA  (SRAM0RDATA),
       .SRAM0ADDR   (SRAM0ADDR),
       .SRAM0WREN   (SRAM0WREN),
       .SRAM0WDATA  (SRAM0WDATA),
       .SRAM0CS     (SRAM0CS),
       .SRAM1HCLK   (SRAM1HCLK),
       .SRAM1RDATA  (SRAM1RDATA),
       .SRAM1ADDR   (SRAM1ADDR),
       .SRAM1WREN   (SRAM1WREN),
       .SRAM1WDATA  (SRAM1WDATA),
       .SRAM1CS     (SRAM1CS),
       .SRAM2HCLK   (SRAM2HCLK),
       .SRAM2RDATA  (SRAM2RDATA),
       .SRAM2ADDR   (SRAM2ADDR),
       .SRAM2WREN   (SRAM2WREN),
       .SRAM2WDATA  (SRAM2WDATA),
       .SRAM2CS     (SRAM2CS),
       .SRAM3HCLK   (SRAM3HCLK),
       .SRAM3RDATA  (SRAM3RDATA),
       .SRAM3ADDR   (SRAM3ADDR),
       .SRAM3WREN   (SRAM3WREN),
       .SRAM3WDATA  (SRAM3WDATA),
       .SRAM3CS     (SRAM3CS)
       );

  // --------------------------------------------------------------------
  // Tie-off unused APB master ports 7, 11,12,13,14
  // --------------------------------------------------------------------
  assign apbtargexp7prdata  = {32{1'b0}};
  assign apbtargexp7pready  = 1'b1;
  assign apbtargexp7pslverr = 1'b0;
  assign apbtargexp11prdata  = {32{1'b0}};
  assign apbtargexp11pready  = 1'b1;
  assign apbtargexp11pslverr = 1'b0;
  assign apbtargexp12prdata  = {32{1'b0}};
  assign apbtargexp12pready  = 1'b1;
  assign apbtargexp12pslverr = 1'b0;
  assign apbtargexp13prdata  = {32{1'b0}};
  assign apbtargexp13pready  = 1'b1;
  assign apbtargexp13pslverr = 1'b0;
  assign apbtargexp14prdata  = {32{1'b0}};
  assign apbtargexp14pready  = 1'b1;
  assign apbtargexp14pslverr = 1'b0;


  // --------------------------------------------------------------------
  // Tie-off unused expansion master port signals
  // --------------------------------------------------------------------
  assign targexp1exresp = 1'b0;
  assign targexp1hruser = {3{1'b0}};


  // All peripherals and memories
  m3ds_peripherals_wrapper u_mps2_peripherals_wrapper
(
  //-----------------------------
  //Resets
    .AHBRESETn              ( AHBPRESETn ),
    .DTIMERPRESETn          ( DTIMERPRESETn ),
    .UART0PRESETn           ( UART0PRESETn ),
    .UART1PRESETn           ( UART1PRESETn ),
    .RTCPRESETn             ( RTCPRESETn ),
    .RTCnRTCRST             ( rtc_rst_n ),
    .RTCnPOR                ( RTCnPOR ),
    .WDOGPRESETn            ( WDOGPRESETn ),
    .WDOGRESn               ( WDOGRESn ),
    .TRNGPRESETn            ( TRNGPRESETn ),
    .GPIO0HRESETn           ( GPIO0PRESETn ),
    .GPIO1HRESETn           ( GPIO1PRESETn ),
    .GPIO2HRESETn           ( GPIO2PRESETn ),
    .GPIO3HRESETn           ( GPIO3PRESETn ),

  //-----------------------------
  //Clocks
    .AHB_CLK                ( CPU0HCLK ),      //HCLK from top
    .APB_CLK                ( PCLKG ),         //PCLKG from top
    .DTIMER_CLK             ( DTIMER_CLK ),
    .UART0_CLK              ( UART0_CLK ),
    .UART1_CLK              ( UART1_CLK ),
    .RTC_CLK                ( RTC_CLK ),
    .RTC1HZ_CLK             ( rtc_1hz_clk ),
    .WDOG_CLK               ( WDOG_CLK ),
    .TRNG_CLK               ( TRNG_CLK ),
    .GPIO0_FCLK             ( GPIO0_FCLK ),
    .GPIO1_FCLK             ( GPIO1_FCLK ),
    .GPIO2_FCLK             ( GPIO2_FCLK ),
    .GPIO3_FCLK             ( GPIO3_FCLK ),
    .GPIO0_HCLK             ( GPIO0_HCLK ),
    .GPIO1_HCLK             ( GPIO1_HCLK ),
    .GPIO2_HCLK             ( GPIO2_HCLK ),
    .GPIO3_HCLK             ( GPIO3_HCLK ),

  //-----------------------------
  //AHB interface
  //AHB Master Slave
    .PERIPHHSEL_i           (targexp1hsel ),       //AHB peripheral select
    .PERIPHHREADYIN_i       (targexp1hreadymux ),  //AHB ready input
    .PERIPHHTRANS_i         (targexp1htrans ),     //AHB transfer type
    .PERIPHHSIZE_i          (targexp1hsize ),      //AHB hsize
    .PERIPHHWRITE_i         (targexp1hwrite ),     //AHB hwrite
    .PERIPHHADDR_i          (targexp1haddr ),      //AHB address bus
    .PERIPHHWDATA_i         (targexp1hwdata ),     //AHB write data bus

    .PERIPHHPROT_i          (targexp1hprot ),

    .PERIPHHREADYMUXOUT_o   (targexp1hreadyout ),  //AHB ready output from S->M mux
    .PERIPHHRESP_o          (targexp1hresp ),      //AHB response output from S->M mux
    .PERIPHHRDATA_o         (targexp1hrdata ),     //AHB read data from S->M mux

    .AHBPER0_REG            (ahbper0_reg), // access permission for gpio
    .APBPER0_REG            (apbper0_reg), // access permission for apb peripherals
  //-----------------------------
  //SysCtrl AHB slaveMux control
    .SYSCTRLHSEL_o          (sysctrlhsel_o ),
    .SYSCTRLHREADYOUT_i     (sysctrlhreadyout_i ),
    .SYSCTRLHRDATA_i        (sysctrlhrdata_i ),
    .SYSCTRLHRESP_i         (sysctrlhresp_i ),

  //-----------------------------
  //APB interfaces
  //D(ual)Timer
    .DTIMERPSEL_i           (apbtargexp2psel ),
    .DTIMERPENABLE_i        (apbtargexp2penable ),
    .DTIMERPADDR_i          ({20'h0,apbtargexp2paddr} ),
    .DTIMERPWRITE_i         (apbtargexp2pwrite ),
    .DTIMERPWDATA_i         (apbtargexp2pwdata ),
    .DTIMERPSTRB_i          (apbtargexp2pstrb ),
    .DTIMERPPROT_i          (apbtargexp2pprot[0] ),   //using privileged access bit only
    .DTIMERPRDATA_o         (apbtargexp2prdata ),
    .DTIMERPREADY_o         (apbtargexp2pready ),
    .DTIMERPSLVERR_o        (apbtargexp2pslverr ),

  //UART0
    .UART0PSEL_i            (apbtargexp4psel ),
    .UART0PENABLE_i         (apbtargexp4penable ),
    .UART0PADDR_i           ({20'h0,apbtargexp4paddr} ),
    .UART0PWRITE_i          (apbtargexp4pwrite ),
    .UART0PWDATA_i          (apbtargexp4pwdata ),
    .UART0PSTRB_i           (apbtargexp4pstrb ),
    .UART0PPROT_i           (apbtargexp4pprot[0] ),
    .UART0PRDATA_o          (apbtargexp4prdata ),
    .UART0PREADY_o          (apbtargexp4pready ),
    .UART0PSLVERR_o         (apbtargexp4pslverr ),

  //UART1
    .UART1PSEL_i            (apbtargexp5psel ),
    .UART1PENABLE_i         (apbtargexp5penable ),
    .UART1PADDR_i           ({20'h0,apbtargexp5paddr} ),
    .UART1PWRITE_i          (apbtargexp5pwrite ),
    .UART1PWDATA_i          (apbtargexp5pwdata ),
    .UART1PSTRB_i           (apbtargexp5pstrb ),
    .UART1PPROT_i           (apbtargexp5pprot[0] ),
    .UART1PRDATA_o          (apbtargexp5prdata ),
    .UART1PREADY_o          (apbtargexp5pready ),
    .UART1PSLVERR_o         (apbtargexp5pslverr ),

  //RTC
    .RTCPSEL_i              (apbtargexp6psel ),
    .RTCPENABLE_i           (apbtargexp6penable ),
    .RTCPADDR_i             ({20'h0,apbtargexp6paddr} ),
    .RTCPWRITE_i            (apbtargexp6pwrite ),
    .RTCPWDATA_i            (apbtargexp6pwdata ),
    .RTCPSTRB_i             (apbtargexp6pstrb ),
    .RTCPPROT_i             (apbtargexp6pprot[0] ),
    .RTCPRDATA_o            (apbtargexp6prdata ),
    .RTCPREADY_o            (apbtargexp6pready ),
    .RTCPSLVERR_o           (apbtargexp6pslverr ),

  //W(atch)DOG
    .WDOGPSEL_i             (apbtargexp8psel ),
    .WDOGPENABLE_i          (apbtargexp8penable ),
    .WDOGPADDR_i            ({20'h0,apbtargexp8paddr} ),
    .WDOGPWRITE_i           (apbtargexp8pwrite ),
    .WDOGPWDATA_i           (apbtargexp8pwdata ),
    .WDOGPSTRB_i            (apbtargexp8pstrb ),
    .WDOGPPROT_i            (apbtargexp8pprot[0] ),
    .WDOGPRDATA_o           (apbtargexp8prdata ),
    .WDOGPREADY_o           (apbtargexp8pready ),
    .WDOGPSLVERR_o          (apbtargexp8pslverr ),

  //TRNG
    .TRNGPSEL_i             (apbtargexp15psel ),
    .TRNGPENABLE_i          (apbtargexp15penable ),
    .TRNGPADDR_i            ({20'h0,apbtargexp15paddr} ),
    .TRNGPWRITE_i           (apbtargexp15pwrite ),
    .TRNGPWDATA_i           (apbtargexp15pwdata ),
    .TRNGPSTRB_i            (apbtargexp15pstrb ),
    .TRNGPPROT_i            (apbtargexp15pprot[0] ),
    .TRNGPRDATA_o           (apbtargexp15prdata ),
    .TRNGPREADY_o           (apbtargexp15pready ),
    .TRNGPSLVERR_o          (apbtargexp15pslverr ),

  //-----------------------------
  //Other/Functional peripheral module specific interfaces
  //-----------------------------
  //D(ual)TIMER
    .DTIMERECOREVNUM_i      ( 4'd0 ),              // ECO revision number
    .DTIMERTIMCLKEN1_i      ( 1'b1 ),              // Timer clock enable 1
    .DTIMERTIMCLKEN2_i      ( 1'b1 ),              // Timer clock enable 2
    .DTIMERTIMINT1_o        (  ),                  // Counter 1 interrupt
    .DTIMERTIMINT2_o        (  ),                  // Counter 2 interrupt
    .DTIMERTIMINTC_o        ( cpu0intisr[10] ),    // Counter combined interrupt

  //-----------------------------
  //UART0
    .UART0ECOREVNUM_i       ( 4'd0 ),              // Engineering-change-order revision bits
    .UART0RXD_i             ( uart_rxd_mcu ),        // Serial input
    .UART0TXD_o             ( uart_txd_mcu ),        // Transmit data output
    .UART0TXEN_o            ( uart_txd_mcu_en ),       // Transmit enabled
    .UART0BAUDTICK_o        (  ),                  // x16 Tick
    .UART0TXINT_o           ( w_uart0_txint ),     // Transmit Interrupt
    .UART0RXINT_o           ( w_uart0_rxint ),     // Receive Interrupt
    .UART0TXOVRINT_o        ( w_uart0_txovrint ),  // Transmit overrun Interrupt
    .UART0RXOVRINT_o        ( w_uart0_rxovrint ),  // Receive overrun Interrupt
    .UART0UARTINT_o         (  ),                  // Combined interrupt

  //-----------------------------
  //UART1
    .UART1ECOREVNUM_i       ( 4'd0 ),              // Engineering-change-order revision bits
    .UART1RXD_i             ( uart_rxd ),          // Serial input
    .UART1TXD_o             ( uart_txd ),          // Transmit data output
    .UART1TXEN_o            ( /*Always driven */ ),// Transmit enabled
    .UART1BAUDTICK_o        (   ),                 // x16 Tick
    .UART1TXINT_o           ( w_uart1_txint ),     // Transmit Interrupt
    .UART1RXINT_o           ( w_uart1_rxint ),     // Receive Interrupt
    .UART1TXOVRINT_o        ( w_uart1_txovrint ),  // Transmit overrun Interrupt
    .UART1RXOVRINT_o        ( w_uart1_rxovrint ),  // Receive overrun Interrupt
    .UART1UARTINT_o         (  ),                  // Combined interrupt

  //-----------------------------
  //RTC
    .RTCSCANENABLE_i        ( 1'b0 ),              // Test mode enable (not used in RTC)
    .RTCSCANINPCLK_i        ( 1'b0 ),              // PCLK Scan chain input
    .RTCSCANINCLK1HZ_i      ( 1'b0 ),              // CLK1HZ Scan chain input
    .RTCSCANOUTPCLK_o       (      ),              // PCLK Scan chain output
    .RTCSCANOUTCLK1HZ_o     (      ),              // CLK1HZ Scan chain output
    .RTCRTCINTR_o           ( cpu0intisr[5] ),     // RTC interrupt

  //-----------------------------
  //W(atch)DOG
    .WDOGECOREVNUM_i        ( 4'd0 ),              // ECO revision number
    .WDOGCLKEN_i            ( 1'b1 ),              // Watchdog clock enable
    .WDOGINT_o              ( cpu0intnmi ),        // Watchdog interrupt
    .WDOGRES_o              ( wdog_reset_req ),    // Watchdog timeout reset request

  //-----------------------------
  //TRNG
    .TRNGSCANMODE_i         ( DFTSCANMODE ),
    .TRNGINT_o              ( cpu0intisr[44] ),

  //-----------------------------
  //GPIO0
    .GPIO0ECOREVNUM_i       ( 4'd0 ),  // Engineering-change-order revision bits
    .GPIO0PORTIN_i          ( io_exp_port_i[15:0] ),    // GPIO Interface input
    .GPIO0PORTOUT_o         ( io_exp_port_o[15:0] ),    // GPIO output
    .GPIO0PORTEN_o          ( io_exp_port_oen[15:0] ),  // GPIO output enable
    .GPIO0PORTFUNC_o        ( gpio0_altfunc_o ),        // Alternate function control
    .GPIO0GPIOINT_o         ( w_gpio0_portint ),        // Interrupt output for each pin
    .GPIO0COMBINT_o         ( cpu0intisr[6] ),          // Combined interrupt

  //-----------------------------
  //GPIO1
    .GPIO1ECOREVNUM_i       ( 4'd0 ),  // Engineering-change-order revision bits
    .GPIO1PORTIN_i          ( io_exp_port_i[31:16] ),   // GPIO Interface input
    .GPIO1PORTOUT_o         ( io_exp_port_o[31:16] ),   // GPIO output
    .GPIO1PORTEN_o          ( io_exp_port_oen[31:16] ), // GPIO output enable
    .GPIO1PORTFUNC_o        ( gpio1_altfunc_o ),        // Alternate function control
    .GPIO1GPIOINT_o         ( w_gpio1_portint ),        // Interrupt output for each pin
    .GPIO1COMBINT_o         ( cpu0intisr[7] ),          // Combined interrupt

  //-----------------------------
  //GPIO2
    .GPIO2ECOREVNUM_i       ( 4'd0 ),  // Engineering-change-order revision bits
    .GPIO2PORTIN_i          ( io_exp_port_i[47:32] ),   // GPIO Interface input
    .GPIO2PORTOUT_o         ( io_exp_port_o[47:32] ),   // GPIO output
    .GPIO2PORTEN_o          ( io_exp_port_oen[47:32] ), // GPIO output enable
    .GPIO2PORTFUNC_o        ( gpio2_altfunc_o ),        // Alternate function control
    .GPIO2GPIOINT_o         ( /* not used */ ),         // Interrupt output for each pin
    .GPIO2COMBINT_o         ( cpu0intisr[42] ),         // Combined interrupt

  //-----------------------------
  //GPIO3
    .GPIO3ECOREVNUM_i       ( 4'd0 ),  // Engineering-change-order revision bits
    .GPIO3PORTIN_i          ( {{12{1'b0}},           io_exp_port_i[51:48]} ),   // GPIO Interface input
    .GPIO3PORTOUT_o         ( {GPIO3PORTOUT_o[15:4], io_exp_port_o[51:48]} ),   // GPIO output
    .GPIO3PORTEN_o          ( {GPIO3PORTEN_o[15:4],  io_exp_port_oen[51:48]} ), // GPIO output enable
    .GPIO3PORTFUNC_o        ( gpio3_altfunc_o ),        // Alternate function control
    .GPIO3GPIOINT_o         ( /* not used */ ),         // Interrupt output for each pin
    .GPIO3COMBINT_o         ( cpu0intisr[43] ),         // Combined interrupt

  //-----------------------------
  //GPIO4
    .GPIO4ECOREVNUM_i       ( 4'd0 ),  // Engineering-change-order revision bits
    .GPIO4PORTIN_i          ( GPIO4PORTIN_i ),     // GPIO Interface input
    .GPIO4PORTOUT_o         ( /* not used */ ),    // GPIO output
    .GPIO4PORTEN_o          ( /* not used */ ),    // GPIO output enable
    .GPIO4PORTFUNC_o        ( /* not used */ ),    // Alternate function control
    .GPIO4GPIOINT_o         ( /* not used */ ),    // Interrupt output for each pin
    .GPIO4COMBINT_o         ( cpu0intisr[54] ),    // Combined interrupt

  //-----------------------------
  //GPIO5
    .GPIO5ECOREVNUM_i       ( 4'd0 ),  // Engineering-change-order revision bits
    .GPIO5PORTIN_i          ( GPIO5PORTIN_i ),     // GPIO Interface input
    .GPIO5PORTOUT_o         ( /* not used */ ),    // GPIO output
    .GPIO5PORTEN_o          ( /* not used */ ),    // GPIO output enable
    .GPIO5PORTFUNC_o        ( /* not used */ ),    // Alternate function control
    .GPIO5GPIOINT_o         ( /* not used */ ),    // Interrupt output for each pin
    .GPIO5COMBINT_o         ( cpu0intisr[55] ),    // Combined interrupt
  // --------------------------------------------------------------------
  //MPS2 Peripherals
  // --------------------------------------------------------------------
    .nPOR                   (MPS2nPOR),
  `ifdef CLOCK_BRIDGES
    .SCLK                   (SCLK),                // Peripheral clock
    .SCLKG                  (SCLKG),               // Gated PCLK for bus
  `endif
    .CLK_100HZ              (clk_100hz),           // 100Hz clock

  // --------------------------------------------------------------------
  // UART
  // --------------------------------------------------------------------
    .UART2_RXD              (uart2_rxd),           // Uart 2 receive data
    .UART2_TXD              (uart2_txd),           // Uart 2 transmit data
    .UART2_TXEN             (uart2_txden),         // Uart 2 transmit data enable
    .UART3_RXD              (uart3_rxd),           // Uart 3 receive data
    .UART3_TXD              (uart3_txd),           // Uart 3 transmit data
    .UART3_TXEN             (uart3_txden),         // Uart 3 transmit data enable
    .UART4_RXD              (uart4_rxd),           // Uart 4 receive data
    .UART4_TXD              (uart4_txd),           // Uart 4 transmit data
    .UART4_TXEN             (uart4_txden),         // Uart 4 transmit data enable

  // --------------------------------------------------------------------
  // I/Os
  // --------------------------------------------------------------------
    .LEDS                   (leds),                // LEDs
    .BUTTONS                (buttons),             // Push buttons
    .DLL_LOCKED             (dll_locked),          // DLL/PLL locked information

    .FPGA_MISC              (fpga_misc),

  // --------------------------------------------------------------------
  // SPI
  // --------------------------------------------------------------------
    .SPI0_CLK_OUT           (spi0_clk_out),        // SPI clock
    .SPI0_CLK_OUT_EN_n      (spi0_clk_out_en_n),   // SPI clock output enable (active low)
    .SPI0_DATA_OUT          (spi0_data_out),       // SPI data out
    .SPI0_DATA_OUT_EN_n     (spi0_data_out_en_n),  // SPI data output enable (active low)
    .SPI0_DATA_IN           (spi0_data_in),        // SPI data in
    .SPI0_SEL               (spi0_sel),            // SPI device select

  // --------------------------------------------------------------------
  // Audio
  // --------------------------------------------------------------------
    .AUDIO_MCLK             (audio_mclk),          // Audio codec master clock (12.288MHz)
    .AUDIO_SCLK             (audio_sclk),          // Audio interface bit clock
    .AUDIO_LRCK             (audio_lrck),          // Audio Left/Right clock
    .AUDIO_SDOUT            (audio_sdout),         // Audio DAC data
    .AUDIO_SDIN             (audio_sdin),          // Audio ADC data
    .AUDIO_NRST             (audio_nrst),          // Audio reset

    .AUDIO_SCL              (audio_scl),
    .AUDIO_SDA_I            (audio_sda_i),
    .AUDIO_SDA_O_EN_n       (audio_sda_o_en_n),
    // When audio_sda_o_en_n=0, pull SDA low

  // --------------------------------------------------------------------
  // CLCD
  // --------------------------------------------------------------------
    .CLCD_SCL               (clcd_scl),
    .CLCD_SDA_I             (clcd_sda_i),
    .CLCD_SDA_O_EN_n        (clcd_sda_o_en_n),

    .SPI1_CLK_OUT           (spi1_clk_out),                   //CLCD SPI clock
    .SPI1_CLK_OUT_EN_n      (spi1_clk_out_en_n),              //CLCD SPI clock output enable (active low)
    .SPI1_DATA_OUT          (spi1_data_out),                  //CLCD SPI data out
    .SPI1_DATA_OUT_EN_n     (spi1_data_out_en_n),             //CLCD SPI data output enable (active low)
    .SPI1_DATA_IN           (spi1_data_in),                   //CLCD SPI data in
    .SPI1_SEL               (spi1_sel),                       //CLCD SPI device select

  // --------------------------------------------------------------------
  // ADC SPI
  // --------------------------------------------------------------------
    .ADC_SPI2_CLK_OUT       (adc_spi2_clk_out),               //ADC SPI clock
    .ADC_SPI2_CLK_OUT_EN_n  (adc_spi2_clk_out_en_n),          //ADC SPI clock output enable (active low)
    .ADC_SPI2_DATA_OUT      (adc_spi2_data_out),              //ADC SPI data out
    .ADC_SPI2_DATA_OUT_EN_n (adc_spi2_data_out_en_n),         //ADC SPI data output enable (active low)
    .ADC_SPI2_DATA_IN       (adc_spi2_data_in),               //ADC SPI data in
    .ADC_SPI2_SEL           (adc_spi2_sel),                   //ADC SPI device select

  // --------------------------------------------------------------------
  // SHIELD 0
  // --------------------------------------------------------------------
    .SHIELD0_SCL            (shield0_scl),
    .SHIELD0_SDA_I          (shield0_sda_i),
    .SHIELD0_SDA_O_EN_n     (shield0_sda_o_en_n),

    .SHIELD0_SPI3_CLK_OUT   (shield0_spi3_clk_out      ),        // Shield0 SPI clock
    .SHIELD0_SPI3_CLK_OUT_EN_n(shield0_spi3_clk_out_en_n ),      // Shield0 SPI clock output enable (active low)
    .SHIELD0_SPI3_DATA_OUT  (shield0_spi3_data_out     ),        // Shield0 SPI data out
    .SHIELD0_SPI3_DATA_OUT_EN_n(shield0_spi3_data_out_en_n),     // Shield0 SPI data output enable (active low)
    .SHIELD0_SPI3_DATA_IN   (shield0_spi3_data_in      ),        // Shield0 SPI data in
    .SHIELD0_SPI3_SEL       (shield0_spi3_sel          ),        // Shield0 SPI device select
  // When audio_sda_o_en_n=0, pull SDA low

  // --------------------------------------------------------------------
  // Shield 1
  // --------------------------------------------------------------------
    .SHIELD1_SCL            (shield1_scl       ),
    .SHIELD1_SDA_I          (shield1_sda_i     ),
    .SHIELD1_SDA_O_EN_n     (shield1_sda_o_en_n),

    .SHIELD1_SPI4_CLK_OUT   (shield1_spi4_clk_out      ),        // Shield1 SPI clock
    .SHIELD1_SPI4_CLK_OUT_EN_n(shield1_spi4_clk_out_en_n ),      // Shield1 SPI clock output enable (active low)
    .SHIELD1_SPI4_DATA_OUT  (shield1_spi4_data_out     ),        // Shield1 SPI data out
    .SHIELD1_SPI4_DATA_OUT_EN_n(shield1_spi4_data_out_en_n),     // Shield1 SPI data output enable (active low)
    .SHIELD1_SPI4_DATA_IN   (shield1_spi4_data_in      ),        // Shield1 SPI data in
    .SHIELD1_SPI4_SEL       (shield1_spi4_sel          ),        // Shield1 SPI device select

  // --------------------------------------------------------------------
  // Serial Communication Controller interface
  // --------------------------------------------------------------------
    .CFGCLK                 (CFGCLK),
    .nCFGRST                (nCFGRST),

    .CFGLOAD                (CFGLOAD),
    .CFGWnR                 (CFGWnR),
    .CFGDATAIN              (CFGDATAIN),
    .CFGDATAOUT             (CFGDATAOUT),
    .CFGINT                 (cfgint),
    .EFUSES                 (), // for use with embedded flash
    .TEST_CTRL              (TEST_CTRL),

    .spi_interrupt_o        (/* compined interrupt not used*/ ), // Interrupt from FPGA APB subsystem to processor
    .spi0_interrupt_o       (cpu0intisr[49] ),      // Interrupt from FPGA APB subsystem to processor
    .spi1_interrupt_o       (cpu0intisr[50] ),      // Interrupt from FPGA APB subsystem to processor
    .spi2_interrupt_o       (cpu0intisr[51] ),      // Interrupt from FPGA APB subsystem to processor
    .spi3_interrupt_o       (cpu0intisr[52] ),      // Interrupt from FPGA APB subsystem to processor
    .spi4_interrupt_o       (cpu0intisr[53] ),      // Interrupt from FPGA APB subsystem to processor
    .I2S_INTERRUPT          (i2s_interrupt ),       // Interrupt from FPGA APB subsystem to processor
    .UART_INTERRUPTS        (uart_interrupts),      // Interrupt from FPGA APB subsystem to processor

  // --------------------------------------------------------------------
  //MPS2 Memory Subsystem
  // --------------------------------------------------------------------

  // --------------------------------------------------------------------
  // ZBT Synchronous SRAM
  // --------------------------------------------------------------------

  // 64-bit ZBT Synchronous SRAM1 connections
    .ZBT_SRAM1_A            (zbt_sram1_a     ),    // Address
    .ZBT_SRAM1_DQ_I         (zbt_sram1_dq_i  ),    // Data input
    .ZBT_SRAM1_DQ_O         (zbt_sram1_dq_o  ),    // Data Output
    .ZBT_SRAM1_DQ_OEN       (zbt_sram1_dq_oen),    // 3-state Buffer Enable
    .ZBT_SRAM1_BWN          (zbt_sram1_bwn   ),    // Byte lane writes     (active low)
    .ZBT_SRAM1_CEN          (zbt_sram1_cen   ),    // Chip Select (active low)
    .ZBT_SRAM1_WEN          (zbt_sram1_wen   ),    // Write enable
    .ZBT_SRAM1_OEN          (zbt_sram1_oen   ),    // Output enable (active low)
    .ZBT_SRAM1_LBON         (zbt_sram1_lbon  ),    // Not used (tied to 0)
    .ZBT_SRAM1_ADV          (zbt_sram1_adv   ),    // Not used (tied to 0)
    .ZBT_SRAM1_ZZ           (zbt_sram1_zz    ),    // Not used (tied to 0)
    .ZBT_SRAM1_CKEN         (zbt_sram1_cken  ),    // Not used (tied to 0)

  // 32-bit ZBT Synchronous SRAM2 connections
    .ZBT_SRAM2_A            (zbt_sram2_a     ),    // Address
    .ZBT_SRAM2_DQ_I         (zbt_sram2_dq_i  ),    // Data input
    .ZBT_SRAM2_DQ_O         (zbt_sram2_dq_o  ),    // Data Output
    .ZBT_SRAM2_DQ_OEN       (zbt_sram2_dq_oen),    // 3-state Buffer Enable
    .ZBT_SRAM2_BWN          (zbt_sram2_bwn   ),    // Byte lane writes (active low)
    .ZBT_SRAM2_CEN          (zbt_sram2_cen   ),    // Chip Select (active low)
    .ZBT_SRAM2_WEN          (zbt_sram2_wen   ),    // Write enable
    .ZBT_SRAM2_OEN          (zbt_sram2_oen   ),    // Output enable (active low)
    .ZBT_SRAM2_LBON         (zbt_sram2_lbon  ),    // Not used (tied to 0)
    .ZBT_SRAM2_ADV          (zbt_sram2_adv   ),    // Not used (tied to 0)
    .ZBT_SRAM2_ZZ           (zbt_sram2_zz    ),    // Not used (tied to 0)
    .ZBT_SRAM2_CKEN         (zbt_sram2_cken  ),    // Not used (tied to 0)

  // 32-bit ZBT Synchronous SRAM3 connections
    .ZBT_SRAM3_A            (zbt_sram3_a     ),    // Address
    .ZBT_SRAM3_DQ_I         (zbt_sram3_dq_i  ),    // Data input
    .ZBT_SRAM3_DQ_O         (zbt_sram3_dq_o  ),    // Data Output
    .ZBT_SRAM3_DQ_OEN       (zbt_sram3_dq_oen),    // 3-state Buffer Enable
    .ZBT_SRAM3_BWN          (zbt_sram3_bwn   ),    // Byte lane writes (active low)
    .ZBT_SRAM3_CEN          (zbt_sram3_cen   ),    // Chip Select (active low)
    .ZBT_SRAM3_WEN          (zbt_sram3_wen   ),    // Write enable
    .ZBT_SRAM3_OEN          (zbt_sram3_oen   ),    // Output enable (active low)
    .ZBT_SRAM3_LBON         (zbt_sram3_lbon  ),    // Not used (tied to 0)
    .ZBT_SRAM3_ADV          (zbt_sram3_adv   ),    // Not used (tied to 0)
    .ZBT_SRAM3_ZZ           (zbt_sram3_zz    ),    // Not used (tied to 0)
    .ZBT_SRAM3_CKEN         (zbt_sram3_cken  ),    // Not used (tied to 0)

  // 16-bit smb connections
    .SMB_ADDR               (smb_addr      ),      // Address
    .SMB_DATA_I             (smb_data_i    ),      // Read Data
    .SMB_DATA_O             (smb_data_o    ),      // Write Data
    .SMB_DATA_O_NEN         (smb_data_o_nen),      // Write Data 3-state ctrl
    .SMB_CEN                (smb_cen       ),      // Active low chip enable
    .SMB_OEN                (smb_oen       ),      // Active low output enable (read)
    .SMB_WEN                (smb_wen       ),      // Active low write enable
    .SMB_UBN                (smb_ubn       ),      // Active low Upper Byte Enable
    .SMB_LBN                (smb_lbn       ),      // Active low Upper Byte Enable
    .SMB_NRD                (smb_nrd       ),      // Active low read enable
    .SMB_NRESET             (smb_nreset    ),      // Active low reset

  // --------------------------------------------------------------------
  // VGA
  // --------------------------------------------------------------------
    .VGA_HSYNC              (vga_hsync ),    // VGA H-Sync
    .VGA_VSYNC              (vga_vsync ),    // VGA V-Sync
    .VGA_R                  (vga_r     ),    // VGA red data
    .VGA_G                  (vga_g     ),    // VGA green data
    .VGA_B                  (vga_b     ),    // VGA blue data

  // --------------------------------------------------------------------
  // Ethernet
  // --------------------------------------------------------------------
    .SMB_ETH_IRQ_N          (SMB_ETH_IRQ_n   ),
    .ETH_INTERRUPT          (eth_interrupt   )

);



  // --------------------------------------------------------------------
  // Default Slave for AHB Expansion master port
  // --------------------------------------------------------------------

  cmsdk_ahb_default_slave u_cmsdk_ahb_default_slave (
   // Inputs
    .HCLK         (CPU0HCLK),          // Clock
    .HRESETn      (CPU0SYSRESETn),     // Reset
    .HSEL         (targexp0hsel),      // Slave select
    .HTRANS       (targexp0htrans),    // Transfer type
    .HREADY       (targexp0hreadymux), // System ready

   // Outputs
    .HREADYOUT    (targexp0hreadyout), // Slave ready
    .HRESP        (targexp0hresp));    // Slave response

  assign   targexp0hrdata = 32'h00000000;
  assign   targexp0exresp = 1'b0;
  assign   targexp0hruser = {3{1'b0}};

  // --------------------------------------------------------------------
  // System Control
  // --------------------------------------------------------------------

  beetle_sysctrl u_beetle_sysctrl (
   // AHB Inputs
    .HCLK         (SYSCTRLHCLK),
    .HRESETn      (SYSCTRLRESETn),
    .FCLK         (SYSCTRL_FCLK),
    .PORESETn     (CPU0PORESETn),
    .HSEL         (sysctrlhsel_o),
    .HREADY       (targexp1hreadymux),
    .HTRANS       (targexp1htrans),
    .HSIZE        (targexp1hsize),
    .HWRITE       (targexp1hwrite),
    .HADDR        (targexp1haddr[11:0]),
    .HWDATA       (targexp1hwdata),

   // Endianness
    .BIGEND       (cpu0_bigend),

   // AHB Outputs
    .HREADYOUT    (sysctrlhreadyout_i),
    .HRESP        (sysctrlhresp_i),
    .HRDATA       (sysctrlhrdata_i),
   //Note:
   //Each 32-bit output is fully aligned with the programmer's model.
   //Individual bits can be active(RW/WO) or tied/reseverved as per the spec.
   //This implementation guarantees a relatively stable sysctrl entity
   //irrespective of actual register bit definitions.
    .AHBPER0_REG  (ahbper0_reg),
    .APBPER0_REG  (apbper0_reg),
   // Reset information
    .SYSRESETREQ  (cpu0sysresetreq),
    .WDOGRESETREQ (wdog_reset_req),
    .LOCKUP       (cpu0lockup),
    // Engineering-change-order revision bits
    .ECOREVNUM    (4'h0),
   // System control signals
    .REMAP        (),
    .PMUENABLE    (),
    .LOCKUPRESET  (lockupreset)
   );

endmodule
