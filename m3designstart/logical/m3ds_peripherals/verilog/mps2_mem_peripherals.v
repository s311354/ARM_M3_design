//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2013-2017 ARM Limited.
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
// Abstract : V2M-MPS2 FPGA System Level
//-----------------------------------------------------------------------------

`include "fpga_options_defs.v"

module mps2_mem_peripherals (
    input  wire          ahbclk,            // Free running clock
    input  wire          hresetn,           // HRESETn for system
    // --------------------------------------------------------------------
    // I/Os
    // --------------------------------------------------------------------

    //GPIO4
    input  wire [3:0]    GPIO4ECOREVNUM_i,  // Engineering-change-order revision bits
    input  wire [15:0]   GPIO4PORTIN_i,     // GPIO Interface input
    output wire [15:0]   GPIO4PORTOUT_o,    // GPIO output
    output wire [15:0]   GPIO4PORTEN_o,     // GPIO output enable
    output wire [15:0]   GPIO4PORTFUNC_o,   // Alternate function control
    output wire [15:0]   GPIO4GPIOINT_o,    // Interrupt output for each pin
    output wire          GPIO4COMBINT_o,    // Combined interrupt

    //GPIO5
    input  wire [3:0]    GPIO5ECOREVNUM_i,  // Engineering-change-order revision bits
    input  wire [15:0]   GPIO5PORTIN_i,     // GPIO Interface input
    output wire [15:0]   GPIO5PORTOUT_o,    // GPIO output
    output wire [15:0]   GPIO5PORTEN_o,     // GPIO output enable
    output wire [15:0]   GPIO5PORTFUNC_o,   // Alternate function control
    output wire [15:0]   GPIO5GPIOINT_o,    // Interrupt output for each pin
    output wire          GPIO5COMBINT_o,    // Combined interrupt

    // --------------------------------------------------------------------
    // ZBT Synchronous SRAM
    // --------------------------------------------------------------------

    // 64-bit ZBT Synchronous SRAM1 connections
    output wire [19:0]   zbt_sram1_a,       // Address
    input  wire [63:0]   zbt_sram1_dq_i,    // Data input
    output wire [63:0]   zbt_sram1_dq_o,    // Data Output
    output wire          zbt_sram1_dq_oen,  // 3-state Buffer Enable
    output wire [7:0]    zbt_sram1_bwn,     // Byte lane writes (active low)
    output wire          zbt_sram1_cen,     // Chip Select (active low)
    output wire          zbt_sram1_wen,     // Write enable
    output wire          zbt_sram1_oen,     // Output enable (active low)
    output wire          zbt_sram1_lbon,    // Not used (tied to 0)
    output wire          zbt_sram1_adv,     // Not used (tied to 0)
    output wire          zbt_sram1_zz,      // Not used (tied to 0)
    output wire          zbt_sram1_cken,    // Not used (tied to 0)

    // 32-bit ZBT Synchronous SRAM2 connections
    output wire [19:0]   zbt_sram2_a,       // Address
    input  wire [31:0]   zbt_sram2_dq_i,    // Data input
    output wire [31:0]   zbt_sram2_dq_o,    // Data Output
    output wire          zbt_sram2_dq_oen,  // 3-state Buffer Enable
    output wire [3:0]    zbt_sram2_bwn,     // Byte lane writes (active low)
    output wire          zbt_sram2_cen,     // Chip Select (active low)
    output wire          zbt_sram2_wen,     // Write enable
    output wire          zbt_sram2_oen,     // Output enable (active low)
    output wire          zbt_sram2_lbon,    // Not used (tied to 0)
    output wire          zbt_sram2_adv,     // Not used (tied to 0)
    output wire          zbt_sram2_zz,      // Not used (tied to 0)
    output wire          zbt_sram2_cken,    // Not used (tied to 0)

    // 32-bit ZBT Synchronous SRAM3 connections
    output wire [19:0]   zbt_sram3_a,       // Address
    input  wire [31:0]   zbt_sram3_dq_i,    // Data input
    output wire [31:0]   zbt_sram3_dq_o,    // Data Output
    output wire          zbt_sram3_dq_oen,  // 3-state Buffer Enable
    output wire [3:0]    zbt_sram3_bwn,     // Byte lane writes (active low)
    output wire          zbt_sram3_cen,     // Chip Select (active low)
    output wire          zbt_sram3_wen,     // Write enable
    output wire          zbt_sram3_oen,     // Output enable (active low)
    output wire          zbt_sram3_lbon,    // Not used (tied to 0)
    output wire          zbt_sram3_adv,     // Not used (tied to 0)
    output wire          zbt_sram3_zz,      // Not used (tied to 0)
    output wire          zbt_sram3_cken,    // Not used (tied to 0)

    // 16-bit smb connections
    output wire [25:0]   smb_addr,          // Address
    input  wire [15:0]   smb_data_i,        // Read Data
    output wire [15:0]   smb_data_o,        // Write Data
    output wire          smb_data_o_nen,    // Write Data 3-state ctrl
    output wire          smb_cen,           // Active low chip enable
    output wire          smb_oen,           // Active low output enable (read)
    output wire          smb_wen,           // Active low write enable
    output wire          smb_ubn,           // Active low Upper Byte Enable
    output wire          smb_lbn,           // Active low Upper Byte Enable
    output wire          smb_nrd,           // Active low read enable
    output wire          smb_nreset,        // Active low reset

    // --------------------------------------------------------------------
    // VGA
    // --------------------------------------------------------------------
    output wire          vga_hsync,         // VGA H-Sync
    output wire          vga_vsync,         // VGA V-Sync
    output wire [3:0]    vga_r,             // VGA red data
    output wire [3:0]    vga_g,             // VGA green data
    output wire [3:0]    vga_b,             // VGA blue data

    // --------------------------------------------------------------------
    // Ethernet
    // --------------------------------------------------------------------
    input  wire          SMB_ETH_IRQ_n,
    output wire          eth_interrupt,     // Interrupt from off chip ethernet to processor

    input  wire          HSEL,
    input  wire [31:0]   HADDR,
    input  wire [1:0]    HTRANS,
    input  wire [2:0]    HSIZE,
    input  wire [3:0]    HPROT,
    input  wire          HWRITE,
    input  wire          HREADY,
    input  wire [31:0]   HWDATA,
    output wire [31:0]   HRDATA,
    output wire          HRESP,
    output wire          HREADYOUT
    ); // end of top level pin list

  //---------------------------------------------------
  // Internal wires
  //---------------------------------------------------
  wire            hclk_sys;            // AHB system clock

  // Static Memory Interface (SMI) for PSRAM and Ethernet
  wire            smi_hsel;
  wire    [25:0]  smi_haddr;           // remapped HADDR to include chip select info
  wire            smi_hresp;
  wire            smi_hreadyout;
  wire    [31:0]  smi_hrdata;

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

`ifdef CLOCK_BRIDGES
  //25mhz clock for clock domain crossing
  wire            sclk;
  wire            sclk_gated;
`endif
  // --------------------------------------------------------------------
  // Ethernet interrupt synchronisation
  // --------------------------------------------------------------------
  wire            SMB_ETH_IRQ; // Input is active low

  // --------------------------------------------------------------------
  // ZBT Synchronous SRAM for CODE region
  // --------------------------------------------------------------------
  wire            rdmux_sel;  // Mux ctrl for read data
  wire     [1:0]  zbt_sram1_ce_n;

  // --------------------------------------------------------------------
  // System Bus infrastructure
  // --------------------------------------------------------------------
  // SRAM AHB signals
  wire            sram1_hsel;
  wire    [31:0]  sram1_haddr;    // 4MB range
  wire            sram1_hresp;
  wire            sram1_hreadyout;
  wire    [31:0]  sram1_hrdata;
  wire    [63:0]  sram1_hrdata_64;

  wire            sram2_hsel;
  wire    [31:0]  sram2_haddr;    // 4MB range
  wire            sram2_hresp;
  wire            sram2_hreadyout;
  wire    [31:0]  sram2_hrdata;

  wire            sram3_hsel;
  wire    [31:0]  sram3_haddr;    // 4MB range
  wire            sram3_hresp;
  wire            sram3_hreadyout;
  wire    [31:0]  sram3_hrdata;

  wire            sram1_addressed;
  wire            sram2_3_addressed;

  wire            vga_hsel;
  wire            vga_hresp;
  wire            vga_hreadyout;
  wire    [31:0]  vga_hrdata;

  wire            gpio4_hsel;     // AHB GPIO bus interface signals
  wire            gpio4_hreadyout;
  wire    [31:0]  gpio4_hrdata;
  wire            gpio4_hresp;

  wire            gpio5_hsel;     // AHB GPIO bus interface signals
  wire            gpio5_hreadyout;
  wire    [31:0]  gpio5_hrdata;
  wire            gpio5_hresp;

  wire            defslv_hsel;
  wire            defslv_hresp;
  wire            defslv_hreadyout;
  wire    [31:0]  defslv_hrdata;

  wire            psram_hsel;
  wire            ethen_hsel;

// extra wires for clock domain crossing to psram and ethernet
  wire            hresetn_25;
  wire            smi_hsel_25;
  wire    [25:0]  smi_haddr_25;
  wire     [1:0]  fpgasys_htrans_25;
  wire     [2:0]  fpgasys_hsize_25;
  wire            fpgasys_hwrite_25;
  wire   [31:0]   fpgasys_hwdata_25;
  wire            fpgasys_hready_25;
  wire            smi_hreadyout_25;
  wire   [31:0]   smi_hrdata_25;
  wire    [1:0]   smi_hresp_25;
  wire   [31:0]   bridge_smi_haddr;
  wire   [31:0]   bridge_smi_haddr_25;

  // --------------------------------------------------------------------
  // VGA
  // --------------------------------------------------------------------
`ifdef INCLUDE_VGA
`ifdef VGA_8BIT_IMAGE
  wire   [7:0]  vga_scr_data;
`else
  wire   [11:0] vga_scr_data;
`endif
`endif
// extra wires for clock domain crossing for vga
  wire [1:0]  bridge_vga_hresp;
  wire [31:0] vga_hrdata_25;
  wire        vga_hreadyout_25;
  wire        vga_hready_25;
  wire [1:0]  vga_hresp_25;
  wire [31:0] vga_bridge_haddr_25;
  wire [31:0] vga_hwdata_25;
  wire [1:0]  vga_htrans_25;
  wire        vga_hwrite_25;

  assign fpgasys_hsel = HSEL;
  assign fpgasys_haddr = HADDR;
  assign fpgasys_htrans = HTRANS;
  assign fpgasys_hsize = HSIZE;
  assign fpgasys_hwrite = HWRITE;
  assign fpgasys_hready = HREADY;
  assign fpgasys_hwdata = HWDATA;
  assign HRDATA = fpgasys_hrdata;
  assign HRESP = fpgasys_hresp;
  assign HREADYOUT = fpgasys_hreadyout;

  assign hclk_sys     = ahbclk; // Not gated because SPI or SCC might need access to bus

  // --------------------------------------------------------------------
  // ZBT Synchronous SRAM for CODE region
  // --------------------------------------------------------------------

  // Since we are using a 32-bit bus master, we need to
  // do this read mux
  assign defslv_hrdata = {32{1'b0}};

  assign zbt_sram1_cen   =  &zbt_sram1_ce_n[1:0];
  assign sram1_hrdata = (rdmux_sel) ?
         sram1_hrdata_64[63:32] : sram1_hrdata_64[31:0];
  assign zbt_sram1_zz    =  1'b0;
  assign zbt_sram1_lbon  =  1'b0;

  assign zbt_sram2_dq_o  = fpgasys_hwdata[31: 0];
  assign sram2_hrdata    = zbt_sram2_dq_i;
  assign zbt_sram2_zz    =  1'b0;
  assign zbt_sram2_lbon  =  1'b0;

  assign zbt_sram3_dq_o  = fpgasys_hwdata[31: 0];
  assign sram3_hrdata    = zbt_sram3_dq_i;
  assign zbt_sram3_zz    =  1'b0;
  assign zbt_sram3_lbon  =  1'b0;

  // SRAM2 and SRAM3 are both in SRAM region
  assign sram1_addressed   = (fpgasys_haddr[31:16] >= 16'h0040) & (fpgasys_haddr[31:16] < 16'h0080);
  assign sram2_3_addressed = (fpgasys_haddr[31:16] >= 16'h2040) & (fpgasys_haddr[31:16] < 16'h2080);
  assign sram1_hsel = fpgasys_hsel & sram1_addressed;
  assign sram2_hsel = fpgasys_hsel & sram2_3_addressed & (~fpgasys_haddr[2]);
  assign sram3_hsel = fpgasys_hsel & sram2_3_addressed & ( fpgasys_haddr[2]);

  // SMI address range include PSRAM and ethernet
  assign psram_hsel = fpgasys_hsel & (fpgasys_haddr[31:24]==8'h21);
  assign ethen_hsel = fpgasys_hsel & (fpgasys_haddr[31:20]==12'h402);
  assign smi_hsel   = psram_hsel|ethen_hsel;
`ifdef INCLUDE_VGA
  // VGA
  assign vga_hsel = fpgasys_hsel & ((fpgasys_haddr[31:20]==12'h411)|(fpgasys_haddr[31:20]==12'h410));
`else
  assign vga_hsel = 1'b0;
`endif

  assign gpio4_hsel  = fpgasys_hsel & (fpgasys_haddr[31:12]==20'h40030);
  assign gpio5_hsel  = fpgasys_hsel & (fpgasys_haddr[31:12]==20'h40031);
  assign defslv_hsel = fpgasys_hsel &~(sram1_hsel|sram2_hsel|sram3_hsel|vga_hsel|
                                            smi_hsel  |gpio4_hsel|gpio5_hsel);

  // Addresses are interleave between two ZBT SSRAM
  assign sram2_haddr[31:0] = {{10{1'b0}},fpgasys_haddr[22:3],fpgasys_haddr[1:0]};
  assign sram3_haddr[31:0] = {{10{1'b0}},fpgasys_haddr[22:3],fpgasys_haddr[1:0]};


  // AHB Slave Mux
  cmsdk_ahb_slave_mux #(
    .PORT0_ENABLE(1),  // ZBT0
    .PORT1_ENABLE(1),  // ZBT1
    .PORT2_ENABLE(1),  // ZBT2
    .PORT3_ENABLE(1),  // VGA
    .PORT4_ENABLE(1),  // Static Memory Interface
    .PORT5_ENABLE(1),  // GPIO #4
    .PORT6_ENABLE(1),  // GPIO #5
    .PORT7_ENABLE(0),  // Not used
    .PORT8_ENABLE(0),  // Not used
    .PORT9_ENABLE(1))  // Default slave
    u_ahb_slave_mux_sys_bus (
    .HCLK         (hclk_sys),
    .HRESETn      (hresetn),
    .HREADY       (fpgasys_hready),
    .HSEL0        (sram1_hsel),        // Input Port 0
    .HREADYOUT0   (sram1_hreadyout),
    .HRESP0       (sram1_hresp),
    .HRDATA0      (sram1_hrdata),
    .HSEL1        (sram2_hsel),        // Input Port 1
    .HREADYOUT1   (sram2_hreadyout),
    .HRESP1       (sram2_hresp),
    .HRDATA1      (sram2_hrdata),
    .HSEL2        (sram3_hsel),        // Input Port 2
    .HREADYOUT2   (sram3_hreadyout),
    .HRESP2       (sram3_hresp),
    .HRDATA2      (sram3_hrdata),
    .HSEL3        (vga_hsel),          // Input Port 3
    .HREADYOUT3   (vga_hreadyout),
    .HRESP3       (vga_hresp),
    .HRDATA3      (vga_hrdata),
    .HSEL4        (smi_hsel),          // Input Port 4
    .HREADYOUT4   (smi_hreadyout),
    .HRESP4       (smi_hresp),
    .HRDATA4      (smi_hrdata),
    .HSEL5        (gpio4_hsel),        // Input Port 5
    .HREADYOUT5   (gpio4_hreadyout),
    .HRESP5       (gpio4_hresp),
    .HRDATA5      (gpio4_hrdata),
    .HSEL6        (gpio5_hsel),        // Input Port 6
    .HREADYOUT6   (gpio5_hreadyout),
    .HRESP6       (gpio5_hresp),
    .HRDATA6      (gpio5_hrdata),
    .HSEL7        (1'b0),              // Input Port 7
    .HREADYOUT7   (1'b1),
    .HRESP7       (1'b0),
    .HRDATA7      ({32{1'b0}}),
    .HSEL8        (1'b0),              // Input Port 8
    .HREADYOUT8   (1'b1),
    .HRESP8       (1'b0),
    .HRDATA8      ({32{1'b0}}),
    .HSEL9        (defslv_hsel),       // Input Port 9
    .HREADYOUT9   (defslv_hreadyout),
    .HRESP9       (defslv_hresp),
    .HRDATA9      (defslv_hrdata),

    .HREADYOUT    (fpgasys_hreadyout), // Outputs
    .HRESP        (fpgasys_hresp),
    .HRDATA       (fpgasys_hrdata)
  );

  // Default slave
  cmsdk_ahb_default_slave u_ahb_default_slave_0 (
    .HCLK         (hclk_sys),
    .HRESETn      (hresetn),
    .HSEL         (defslv_hsel),
    .HTRANS       (fpgasys_htrans),
    .HREADY       (fpgasys_hready),
    .HREADYOUT    (defslv_hreadyout),
    .HRESP        (defslv_hresp)
  );


  // --------------------------------------------------------------------
  // ZBT Synchronous SRAM for CODE region
  // --------------------------------------------------------------------

  ahb_zbtram_64
   #(.AW (23)) // 23 is 8MB
    u_ahb_zbtram_64 (
    // Inputs
    .HCLK       (hclk_sys),

    .HRESETn    (hresetn),
    .HSELSSRAM  (sram1_hsel),
    .HREADYIn   (fpgasys_hready),
    .HTRANS     (fpgasys_htrans),
    .HSIZE      (fpgasys_hsize[1:0]),
    .HWRITE     (fpgasys_hwrite),
    .HADDR      (fpgasys_haddr),

    .HWDATA     ({fpgasys_hwdata[31:0],fpgasys_hwdata[31:0]}),

    // Outputs
    .HREADYOut  (sram1_hreadyout),   // always ready (zero wait state
    .HRESP      (sram1_hresp),       // always okay
    .HRDATA     (sram1_hrdata_64),

    .PADDR      ({32{1'b0}}),
    .PSEL       (1'b0),
    .PENABLE    (1'b0),
    .PWRITE     (1'b0),
    .PSTRB      ({4{1'b0}}),
    .PWDATA     ({32{1'b0}}),
    .PRDATA     (),
    .PREADY     (),
    .PSLVERR    (),

    .SADDR      (zbt_sram1_a),
    .SDATAEN    (zbt_sram1_dq_oen),  // Active low 3-state enable
    .SnWBYTE    (zbt_sram1_bwn),
    .SnOE       (zbt_sram1_oen),     // Active low Output Enable
    .SnCE       (zbt_sram1_ce_n),    // Active low chip select
    .SADVnLD    (zbt_sram1_adv),     // Always 0
    .SnWR       (zbt_sram1_wen),     // Write enable
    .SnCKE      (zbt_sram1_cken),    // Always 0

    .SWDATA     (zbt_sram1_dq_o[63:0]),
    .SRDATA     (zbt_sram1_dq_i[63:0]),
    .rdmux_sel  (rdmux_sel)
  );

  // --------------------------------------------------------------------
  // ZBT Synchronous SRAM for System Bus
  // --------------------------------------------------------------------

  //-----------------------------
  // Lower word
  // Controller for ZBT SSRAM 2
  //
  ahb_zbtram_32 #(.AW (22)) // 4MB
   u_ahb_zbt_2
    (
    // Inputs
    .HCLK       (hclk_sys),

    .HRESETn    (hresetn),
    .HSELSSRAM  (sram2_hsel),
    .HREADYIn   (fpgasys_hready),
    .HTRANS     (fpgasys_htrans),
    .HPROT      (4'b0000), // Not used
    .HSIZE      (fpgasys_hsize[1:0]),
    .HWRITE     (fpgasys_hwrite),
    .HADDR      (sram2_haddr),

    // Outputs
    .HREADYOut  (sram2_hreadyout), // always ready (zero wait state
    .HRESP      (sram2_hresp), // always okay

    .SADDR      (zbt_sram2_a),
    .SDATAEN    (zbt_sram2_dq_oen), // Active low 3-state enable
    .SnWBYTE    (zbt_sram2_bwn),
    .SnOE       (zbt_sram2_oen),     // Active low Output Enable
    .SnCE       (zbt_sram2_cen), // Active low chip select
    .SADVnLD    (zbt_sram2_adv),  // Always 0
    .SnWR       (zbt_sram2_wen),  // Write
    .SnCKE      (zbt_sram2_cken)  // Always 0
  );

  //-----------------------------
  // Upper word
  // Controller for ZBT SSRAM 3
  //
  ahb_zbtram_32 #(.AW (22)) // 4MB
   u_ahb_zbt_3
    (
    // Inputs
    .HCLK       (hclk_sys),

    .HRESETn    (hresetn),
    .HSELSSRAM  (sram3_hsel),
    .HREADYIn   (fpgasys_hready),
    .HTRANS     (fpgasys_htrans),
    .HPROT      (4'b0000), // Not used
    .HSIZE      (fpgasys_hsize[1:0]),
    .HWRITE     (fpgasys_hwrite),
    .HADDR      (sram3_haddr),

    // Outputs
    .HREADYOut  (sram3_hreadyout), // always ready (zero wait state
    .HRESP      (sram3_hresp), // always okay

    .SADDR      (zbt_sram3_a),
    .SDATAEN    (zbt_sram3_dq_oen), // Active low 3-state enable
    .SnWBYTE    (zbt_sram3_bwn),
    .SnOE       (zbt_sram3_oen),     // Active low Output Enable
    .SnCE       (zbt_sram3_cen), // Active low chip select
    .SADVnLD    (zbt_sram3_adv),  // Always 0
    .SnWR       (zbt_sram3_wen),  // Write
    .SnCKE      (zbt_sram3_cken)  // Always 0
  );

  //-----------------------------
  // PSRAM interface
  // Use asynchronous read/write mode

  assign smi_haddr[25] = ~ethen_hsel; // Chip select for Ethernet
  assign smi_haddr[24] = ~psram_hsel; // Chip select for PSRAM
  assign smi_haddr[23:0] = fpgasys_haddr[23:0];

`ifdef INCLUDE_PSRAM
`ifdef CLOCK_BRIDGES
  assign bridge_smi_haddr[31:26] = 6'b0;
  assign bridge_smi_haddr[25:0] = smi_haddr[25:0];
  // --------------------------------------------------------------------------
  // ahb to ahb clk domain crossing
  // --------------------------------------------------------------------------

  Ahb2AhbAsync32 u_Ahb2AhbAsync_ethernet
  (
  .HCLKS        (hclk_sys),
  .HRESETSn     (hresetn),
  .HCLKM        (sclk),
  .HRESETMn     (hresetn),
  .HSELS        (smi_hsel),
  .HADDRS       (bridge_smi_haddr),
  .HTRANSS      (fpgasys_htrans),
  .HWRITES      (fpgasys_hwrite),
  .HSIZES       (fpgasys_hsize),
  .HBURSTS      (3'b0),
  .HPROTS       (4'b0011),
  .HMASTLOCKS   (1'b0),
  .HWDATAS      (fpgasys_hwdata),
  .HREADYS      (fpgasys_hready),
  .HRDATAM      (smi_hrdata_25),
  .HREADYM      (smi_hreadyout_25),
  .HRESPM       (smi_hresp_25),
  .HGRANTM      (1'b1),
  .SCANENABLE   (1'b0),
  .SCANINHCLKS  (1'b0),
  .SCANINHCLKM  (1'b0),

  .HRDATAS      (smi_hrdata),
  .HRESPS       (smi_hresp),
  .HREADYOUTS   (smi_hreadyout),
  .HADDRM       (bridge_smi_haddr_25 ),
  .HTRANSM      (fpgasys_htrans_25),
  .HWRITEM      (fpgasys_hwrite_25),
  .HSIZEM       (fpgasys_hsize_25),
  .HBURSTM      (),
  .HPROTM       (),
  .HLOCKM       (),
  .HWDATAM      (fpgasys_hwdata_25),
  .HBUSREQM     (),
  .SCANOUTHCLKS (),
  .SCANOUTHCLKM ()
  );

  assign fpgasys_hready_25 = smi_hreadyout_25;
  assign smi_hsel_25 = 1'b1;
  assign smi_hresp_25[1] = 1'b0;
`else
assign smi_hsel_25 = smi_hsel;
assign bridge_smi_haddr_25[25:0] = smi_haddr[25:0];
assign fpgasys_htrans_25 = fpgasys_htrans;
assign fpgasys_hsize_25  = fpgasys_hsize;
assign fpgasys_hwrite_25 = fpgasys_hwrite;
assign fpgasys_hwdata_25 = fpgasys_hwdata;
assign fpgasys_hready_25 = fpgasys_hready;

assign smi_hreadyout = smi_hreadyout_25;
assign smi_hrdata    = smi_hrdata_25;
assign smi_hresp     = smi_hresp_25[0];
`endif

  // Note: actual address is 24 bit [23:0], but added two MSB for chip select
  // This is a modified version of CMSDK interface, for PSRAM on MPS2 board
  cmsdk_ahb_to_extmem16_psram #(.AW(26)) u_cmsdk_ahb_to_extmem16_psram (
`ifdef CLOCK_BRIDGES
    .HCLK       (sclk),
`else
    .HCLK       (hclk_sys),
`endif
    .HRESETn    (hresetn),

    .HSEL       (smi_hsel_25),
    .HADDR      (bridge_smi_haddr_25[25:0]),
    .HTRANS     (fpgasys_htrans_25),
    .HSIZE      (fpgasys_hsize_25), // [2:0]
    .HWRITE     (fpgasys_hwrite_25),
    .HWDATA     (fpgasys_hwdata_25),
    .HREADY     (fpgasys_hready_25),

    .HREADYOUT  (smi_hreadyout_25),
    .HRDATA     (smi_hrdata_25),
    .HRESP      (smi_hresp_25[0]),

    .CFGREADCYCLE(3'b111),
    .CFGWRITECYCLE(3'b111),
    .CFGTURNAROUNDCYCLE(3'b111),
    .CFGSIZE    (1'b1), // 1 = 16-bit

    .DATAIN     (smb_data_i),
    .ADDR       (smb_addr),
    .DATAOUT    (smb_data_o),
    .DATAOEn    (smb_data_o_nen),
    .WEn        (smb_wen),
    .OEn        (smb_oen),
    .CEn        (smb_cen),
    .LBn        (smb_lbn),
    .UBn        (smb_ubn)
    );


  assign smb_nrd       = smb_cen | ~smb_wen;
  assign smb_nreset    = hresetn;

`else

  assign smb_addr      = {25{1'b0}};
  assign smb_data_o    = {16{1'b0}};
  assign smb_data_o_nen = 1'b1; // Active low
  assign smb_cen       = 1'b1;
  assign smb_oen       = 1'b1;
  assign smb_wen       = 1'b1;
  assign smb_ubn       = 1'b1;
  assign smb_lbn       = 1'b1;
  assign smb_nrd       = 1'b1;
  assign smb_nreset    = hresetn;


`endif
  // --------------------------------------------------------------------
  // VGA
  // --------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // ahb to ahb clk domain crossing
  // --------------------------------------------------------------------------
`ifdef INCLUDE_VGA
`ifdef CLOCK_BRIDGES
  Ahb2AhbAsync32 u_Ahb2AhbAsync_vga
  (
  .HCLKS        (hclk_sys),                   //done
  .HRESETSn     (hresetn),                    //done
  .HCLKM        (sclk),                       //done
  .HRESETMn     (hresetn),                    //done
  .HSELS        (vga_hsel),                   //done
  .HADDRS       ({8'b0,fpgasys_haddr[23:0]}), //done
  .HTRANSS      (fpgasys_htrans),             //done
  .HWRITES      (fpgasys_hwrite),             //done
  .HSIZES       (fpgasys_hsize),              //done
  .HBURSTS      (3'b0),
  .HPROTS       (4'b0011),
  .HMASTLOCKS   (1'b0),
  .HWDATAS      (fpgasys_hwdata),             //done
  .HREADYS      (fpgasys_hready),             //done
  .HRDATAM      (vga_hrdata_25),              //done
  .HREADYM      (vga_hreadyout_25),           //done
  .HRESPM       (vga_hresp_25),               //done
  .HGRANTM      (1'b1),
  .SCANENABLE   (1'b0),
  .SCANINHCLKS  (1'b0),
  .SCANINHCLKM  (1'b0),

  .HRDATAS      (vga_hrdata),                 //done
  .HRESPS       (bridge_vga_hresp),           //done
  .HREADYOUTS   (vga_hreadyout),              //done
  .HADDRM       (vga_bridge_haddr_25 ),
  .HTRANSM      (vga_htrans_25),
  .HWRITEM      (vga_hwrite_25),
  .HSIZEM       (),
  .HBURSTM      (),
  .HPROTM       (),
  .HLOCKM       (),
  .HWDATAM      (vga_hwdata_25),
  .HBUSREQM     (),
  .SCANOUTHCLKS (),
  .SCANOUTHCLKM ()
  );

  assign vga_hresp = bridge_vga_hresp[0];
  assign vga_hready_25 = vga_hreadyout_25;
`else
assign vga_bridge_haddr_25[23:0] = fpgasys_haddr[23:0];
assign vga_htrans_25 = fpgasys_htrans;
assign vga_hwrite_25 = fpgasys_hwrite;
assign vga_hwdata_25 = fpgasys_hwdata;
assign vga_hready_25 = fpgasys_hready;

assign vga_hreadyout = vga_hreadyout_25;
assign vga_hrdata    = vga_hrdata_25;
assign vga_hresp     = vga_hresp_25[0];

`endif

  AHBVGA u_ahbvga(
`ifdef CLOCK_BRIDGES
    .HCLK       (sclk),
`else
    .HCLK       (hclk_sys),
`endif
    .HRESETn      (hresetn),
    .HCLKEN       (1'b1),
    .HADDR        (vga_bridge_haddr_25[23:0]),
    .HWDATA       (vga_hwdata_25),
    .HREADY       (vga_hready_25),
    .HWRITE       (vga_hwrite_25),
    .HTRANS       (vga_htrans_25),
`ifdef CLOCK_BRIDGES
    .HSEL         (1'b1),
`else
    .HSEL         (vga_hsel),
`endif

    .HRDATA       (vga_hrdata_25), // Note: Not used, tied low
    .HREADYOUT    (vga_hreadyout_25),

    .hsync        (vga_hsync),
    .vsync        (vga_vsync),
    .rgb          (vga_scr_data)
  );

`ifdef VGA_8BIT_IMAGE
  assign vga_r     = {vga_scr_data[7:5], 1'b0};
  assign vga_g     = {vga_scr_data[4:2], 1'b0};
  assign vga_b     = {vga_scr_data[1:0], 2'b00};
`else
  assign vga_r     = vga_scr_data[11:8];
  assign vga_g     = vga_scr_data[7:4];
  assign vga_b     = vga_scr_data[3:0];
`endif

  assign vga_hresp_25[0] = 1'b0;

`else
  assign vga_hsync = 1'b0;
  assign vga_vsync = 1'b0;
  assign vga_r     = {4{1'b0}};
  assign vga_g     = {4{1'b0}};
  assign vga_b     = {4{1'b0}};

  assign vga_hresp     = 1'b0;
  assign vga_hreadyout = 1'b1;
  assign vga_hrdata    = {32{1'b0}};

`endif

  // --------------------------------------------------------------------
  // FPGA level GPIO
  // --------------------------------------------------------------------

  cmsdk_ahb_gpio #(
    .ALTERNATE_FUNC_MASK     (16'hFFFF), // Enable pin muxing for Port #2
    .ALTERNATE_FUNC_DEFAULT  (16'h0000), // All pins default to GPIO
    .BE                      (1'b0)
    )
    u_ahb_gpio_4  (
   // AHB Inputs
    .HCLK         (hclk_sys),
    .HRESETn      (hresetn),
    .FCLK         (ahbclk),
    .HSEL         (gpio4_hsel),
    .HREADY       (fpgasys_hready),
    .HTRANS       (fpgasys_htrans),
    .HSIZE        (fpgasys_hsize),
    .HWRITE       (fpgasys_hwrite),
    .HADDR        (fpgasys_haddr[11:0]),
    .HWDATA       (fpgasys_hwdata),
   // AHB Outputs
    .HREADYOUT    (gpio4_hreadyout),
    .HRESP        (gpio4_hresp),
    .HRDATA       (gpio4_hrdata),

    .ECOREVNUM    (GPIO4ECOREVNUM_i),// Engineering-change-order revision bits

    .PORTIN       (GPIO4PORTIN_i),   // GPIO Interface inputs
    .PORTOUT      (GPIO4PORTOUT_o),  // GPIO Interface outputs
    .PORTEN       (GPIO4PORTEN_o),
    .PORTFUNC     (GPIO4PORTFUNC_o), // Alternate function control

    .GPIOINT      (GPIO4GPIOINT_o),  // Interrupt outputs
    .COMBINT      (GPIO4COMBINT_o)
  );

  cmsdk_ahb_gpio #(
    .ALTERNATE_FUNC_MASK     (16'hFFFF), // Enable pin muxing for Port #3
    .ALTERNATE_FUNC_DEFAULT  (16'h0000), // All pins default to GPIO
    .BE                      (1'b0)
    )
    u_ahb_gpio_5  (
   // AHB Inputs
    .HCLK         (hclk_sys),
    .HRESETn      (hresetn),
    .FCLK         (ahbclk),
    .HSEL         (gpio5_hsel),
    .HREADY       (fpgasys_hready),
    .HTRANS       (fpgasys_htrans),
    .HSIZE        (fpgasys_hsize),
    .HWRITE       (fpgasys_hwrite),
    .HADDR        (fpgasys_haddr[11:0]),
    .HWDATA       (fpgasys_hwdata),
   // AHB Outputs
    .HREADYOUT    (gpio5_hreadyout),
    .HRESP        (gpio5_hresp),
    .HRDATA       (gpio5_hrdata),

    .ECOREVNUM    (GPIO5ECOREVNUM_i),// Engineering-change-order revision bits

    .PORTIN       (GPIO5PORTIN_i),   // GPIO Interface inputs
    .PORTOUT      (GPIO5PORTOUT_o),  // GPIO Interface outputs
    .PORTEN       (GPIO5PORTEN_o),
    .PORTFUNC     (GPIO5PORTFUNC_o), // Alternate function control

    .GPIOINT      (GPIO5GPIOINT_o),  // Interrupt outputs
    .COMBINT      (GPIO5COMBINT_o)
  );

  // --------------------------------------------------------------------
  // Ethernet interrupt synchronisation
  // --------------------------------------------------------------------
  assign SMB_ETH_IRQ = ~SMB_ETH_IRQ_n; // Input is active low

  // Simple interrupt signal synchroniser
  // (Reference design from CMSDK)
  cmsdk_irq_sync u_eth_irq_sync (
      .RSTn  (hresetn),
`ifdef CLOCK_BRIDGES
      .CLK   (sclk),
`else
      .CLK   (hclk_sys),
`endif
      .IRQIN (SMB_ETH_IRQ),
      .IRQOUT(eth_interrupt)
      );


endmodule



