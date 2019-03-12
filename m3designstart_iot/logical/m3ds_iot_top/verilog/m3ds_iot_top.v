//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//        (C) COPYRIGHT 2015-2017 ARM Limited or its affiliates.
//            ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
//      SVN Information
//
//      Checked In          :  2015-10-21 11:30:36 +0100 (Wed, 21 Oct 2015)
//
//      Revision            :  2624
//
//      Release Information : CM3DesignStart-r0p0-02rel0
//
//-----------------------------------------------------------------------------
// Purpose : DesignStart verion of IoT subsystem for M3 top level
//           Instantiated in user_partition
//-----------------------------------------------------------------------------
//
// Description : m3ds3_iot_top
// Vendor  : arm.com
// Library : Subsystem
// Module  : ds3_iot_top
// Version : 1
//
// -----------------------------------------------------------------------------
// Verilog-2001 (IEEE Std 1364-2001)
// -----------------------------------------------------------------------------

module m3ds_iot_top #(

  parameter WIC_LINES        = 67)                                    // Static in Designstart


  // ----------------------------------------------------------------------------
  // Port declarations
  // ----------------------------------------------------------------------------

  // ----------------------------------------------------------------------------
  // Clocks & Resets
  // ----------------------------------------------------------------------------
 (input  wire                                 CPU0FCLK,               // A free-running clock. This must be active
                                                                      // when the processor is running, for debugging,
                                                                      // and for the Nested Vectored Interrupt Controller (NVIC)
                                                                      // to detect interrupts. Beid implements the WIC with
                                                                      // LATCH thus during WIC based sleep it can be gated

  input  wire                                 CPU0HCLK,               // A system clock. This must be the same as CPU0FCLK
                                                                      // when active. You can gate this off when the processor is
                                                                      // in sleep mode, unless:
                                                                      // There can be debugger access. Typically, CPU0HCLK
                                                                      // can be kept active when the debugger is connected.
                                                                      // There can be activity in the trace interface. The
                                                                      // trace interfaces are running on CPU0HCLK and must be the
                                                                      // same as the clock that downstream ATB devices use.
                                                                      // Transactions must not be present on the trace
                                                                      // interface with the clock stopped.

  input  wire                                 TPIUTRACECLKIN,         // Async clock for the TPIU traceport side.
                                                                      // A synchronous reset is generated internally from
                                                                      // CPU0PORESTn. Must be active when the TPIU is active

  input  wire                                 CPU0PORESETn,           // Power-on reset. Resets the entire Cortex-M3
                                                                      // system and debug components, but excluding the CTI
                                                                      // trigger interface and CTI wrapper.
                                                                      // Deassert the reset synchronously to CPU0FCLK.
                                                                      // Assert the reset at powerup.
                                                                      // Assert the reset for at least three CPU0FCLK cycles.

  input  wire                                 CPU0SYSRESETn,          // System Reset. Resets the processor and the WIC
                                                                      // excluding debug logic in the NVIC, FPB, DWT, and ITM.
                                                                      // Deassert the reset synchronously to CPU0FCLK.
                                                                      // This reset must be asserted when CPU0PORESETn is asserted.
                                                                      // Assert this reset for at least three CPU0FCLK cycles
                                                                      // Shall be asserted when CPU0PORESETn is asserted.

  input  wire                                 CPU0STCLK,              // Clock enable of the alternative clock source of SysTick
                                                                      // timer. CPU0STCLK CPU0FCLK is gated with this CPU0STCLK

  input  wire [25:0]                          CPU0STCALIB,            // Calibration signal for alternative clock source of
                                                                      // SysTick timer

                                                                      // The PCLKG must be synchronous to FLSHCLK whenever the two
                                                                      // clocks are on at the same time.

  input  wire                                 SRAM0HCLK,              // AHB clock of the SRAM bridge 0
  input  wire                                 SRAM1HCLK,              // AHB clock of the SRAM bridge 1
  input  wire                                 SRAM2HCLK,              // AHB clock of the SRAM bridge 2
  input  wire                                 SRAM3HCLK,              // AHB clock of the SRAM bridge 3

  input  wire                                 MTXHCLK,                // AHB Matrix interconnect Clock
  input  wire                                 MTXHRESETn,             // AHB Matrix interconnect Reset.
                                                                      // AHB to APB bridge Reset
                                                                      // AHB reset of the SRAM bridges
                                                                      // Deassert the reset synchronously to MTXHCLK

  input  wire                                 AHB2APBHCLK,            // AHB to APB bridge Clock
  input  wire                                 TIMER0PCLK,             // The free running clock, TIMER0PCLK, is used for timer
                                                                      // operation. This must be the same frequency as, and
                                                                      // synchronous to, the TIMER0PCLKG signal
  input  wire                                 TIMER0PCLKG,            // APB register read or write logic that permits the clock
                                                                      // to peripheral register logic to stop when there is no APB
                                                                      // activity
  input  wire                                 TIMER0PRESETn,          // Deassert the reset synchronously to TIMER0PCLK
  input  wire                                 TIMER1PCLK,             // The free running clock, TIMER1PCLK, is used for timer
                                                                      // operation. This must be the same frequency as, and
                                                                      // synchronous to, the TIMER1PCLKG signal
  input  wire                                 TIMER1PCLKG,            // APB register read or write logic that permits the clock
                                                                      // to peripheral register logic to stop when there is no APB
                                                                      // activity
  input  wire                                 TIMER1PRESETn,          // Deassert the reset synchronously to TIMER1PCLK

  // ----------------------------------------------------------------------------
  // AHB2SRAM<0..3> Interfaces
  // ----------------------------------------------------------------------------
  input  wire [31:0]                          SRAM0RDATA,             // SRAM Read data bus
  output wire [12:0]                          SRAM0ADDR,              // SRAM address
  output wire [3:0]                           SRAM0WREN,              // SRAM Byte write enable
  output wire [31:0]                          SRAM0WDATA,             // SRAM Write data
  output wire                                 SRAM0CS,                // SRAM Chip select

  input  wire [31:0]                          SRAM1RDATA,             // SRAM Read data bus
  output wire [12:0]                          SRAM1ADDR,              // SRAM address
  output wire [3:0]                           SRAM1WREN,              // SRAM Byte write enable
  output wire [31:0]                          SRAM1WDATA,             // SRAM Write data
  output wire                                 SRAM1CS,                // SRAM Chip select

  input  wire [31:0]                          SRAM2RDATA,             // SRAM Read data bus
  output wire [12:0]                          SRAM2ADDR,              // SRAM address
  output wire [3:0]                           SRAM2WREN,              // SRAM Byte write enable
  output wire [31:0]                          SRAM2WDATA,             // SRAM Write data
  output wire                                 SRAM2CS,                // SRAM Chip select

  input  wire [31:0]                          SRAM3RDATA,             // SRAM Read data bus
  output wire [12:0]                          SRAM3ADDR,              // SRAM address
  output wire [3:0]                           SRAM3WREN,              // SRAM Byte write enable
  output wire [31:0]                          SRAM3WDATA,             // SRAM Write data
  output wire                                 SRAM3CS,                // SRAM Chip select

  // ----------------------------------------------------------------------------
  // Timer<0..1> Interfaces
  // ----------------------------------------------------------------------------
  input  wire                                 TIMER0EXTIN,            // Extenal input
  input  wire                                 TIMER0PRIVMODEN,        // Defines if the timer memory mapped registers
                                                                      // are writeable only by privileged access
                                                                      //  0. Non privileged access can write MMRs
                                                                      //  1. Only Privileged access can write MMRs

  input  wire                                 TIMER1EXTIN,            // Extenal input
  input  wire                                 TIMER1PRIVMODEN,        // Defines if the timer memory mapped registers
                                                                      // are writeable only by privileged access
                                                                      //  0. Non privileged access can write MMRs
                                                                      //  1. Only Privileged access can write MMRs

  // ----------------------------------------------------------------------------
  // Interrupts and events
  // ----------------------------------------------------------------------------
  output wire                                 TIMER0TIMERINT,         // Timer interrupt output
  output wire                                 TIMER1TIMERINT,         // Timer interrupt output

  // ----------------------------------------------------------------------------
  // AHB Target Expansion ports
  // ----------------------------------------------------------------------------
  //  amba.com/AMBA3/AHBLite/r2p0_0, TARGFLASH0, master
  output wire                                 TARGFLASH0HSEL,         // TARGFLASH0, HSELx,
  output wire [31:0]                          TARGFLASH0HADDR,        // TARGFLASH0, HADDR,
  output wire [1:0]                           TARGFLASH0HTRANS,       // TARGFLASH0, HTRANS,
  output wire                                 TARGFLASH0HWRITE,       // TARGFLASH0, HWRITE,
  output wire [2:0]                           TARGFLASH0HSIZE,        // TARGFLASH0, HSIZE,
  output wire [2:0]                           TARGFLASH0HBURST,       // TARGFLASH0, HBURST,
  output wire [3:0]                           TARGFLASH0HPROT,        // TARGFLASH0, HPROT,
  output wire [1:0]                           TARGFLASH0MEMATTR,
  output wire                                 TARGFLASH0EXREQ,
  output wire [3:0]                           TARGFLASH0HMASTER,
  output wire [31:0]                          TARGFLASH0HWDATA,       // TARGFLASH0, HWDATA,
  output wire                                 TARGFLASH0HMASTLOCK,    // TARGFLASH0, HMASTLOCK,
  output wire                                 TARGFLASH0HREADYMUX,    // TARGFLASH0, HREADYOUT,
  output wire                                 TARGFLASH0HAUSER,       // TARGFLASH0, HAUSER,
  output wire [3:0]                           TARGFLASH0HWUSER,       // TARGFLASH0, HWUSER,
  input  wire [31:0]                          TARGFLASH0HRDATA,       // TARGFLASH0, HRDATA,
  input  wire                                 TARGFLASH0HREADYOUT,    // TARGFLASH0, HREADY,
  input  wire                                 TARGFLASH0HRESP,        // TARGFLASH0, HRESP,
  input  wire                                 TARGFLASH0EXRESP,
  input  wire [2:0]                           TARGFLASH0HRUSER,       // TARGFLASH0, HRUSER,

  //  amba.com/AMBA3/AHBLite/r2p0_0, TARGEXP0, master
  output wire                                 TARGEXP0HSEL,           // TARGEXP0, HSELx,
  output wire [31:0]                          TARGEXP0HADDR,          // TARGEXP0, HADDR,
  output wire [1:0]                           TARGEXP0HTRANS,         // TARGEXP0, HTRANS,
  output wire                                 TARGEXP0HWRITE,         // TARGEXP0, HWRITE,
  output wire [2:0]                           TARGEXP0HSIZE,          // TARGEXP0, HSIZE,
  output wire [2:0]                           TARGEXP0HBURST,         // TARGEXP0, HBURST,
  output wire [3:0]                           TARGEXP0HPROT,          // TARGEXP0, HPROT,
  output wire [1:0]                           TARGEXP0MEMATTR,
  output wire                                 TARGEXP0EXREQ,
  output wire [3:0]                           TARGEXP0HMASTER,
  output wire [31:0]                          TARGEXP0HWDATA,         // TARGEXP0, HWDATA,
  output wire                                 TARGEXP0HMASTLOCK,      // TARGEXP0, HMASTLOCK,
  output wire                                 TARGEXP0HREADYMUX,      // TARGEXP0, HREADYOUT,
  output wire                                 TARGEXP0HAUSER,         // TARGEXP0, HAUSER,
  output wire [3:0]                           TARGEXP0HWUSER,         // TARGEXP0, HWUSER,
  input  wire [31:0]                          TARGEXP0HRDATA,         // TARGEXP0, HRDATA,
  input  wire                                 TARGEXP0HREADYOUT,      // TARGEXP0, HREADY,
  input  wire                                 TARGEXP0HRESP,          // TARGEXP0, HRESP,
  input  wire                                 TARGEXP0EXRESP,
  input  wire [2:0]                           TARGEXP0HRUSER,         // TARGEXP0, HRUSER,

  //  amba.com/AMBA3/AHBLite/r2p0_0, TARGEXP1, master
  output wire                                 TARGEXP1HSEL,           // TARGEXP1, HSELx,
  output wire [31:0]                          TARGEXP1HADDR,          // TARGEXP1, HADDR,
  output wire [1:0]                           TARGEXP1HTRANS,         // TARGEXP1, HTRANS,
  output wire                                 TARGEXP1HWRITE,         // TARGEXP1, HWRITE,
  output wire [2:0]                           TARGEXP1HSIZE,          // TARGEXP1, HSIZE,
  output wire [2:0]                           TARGEXP1HBURST,         // TARGEXP1, HBURST,
  output wire [3:0]                           TARGEXP1HPROT,          // TARGEXP1, HPROT,
  output wire [1:0]                           TARGEXP1MEMATTR,
  output wire                                 TARGEXP1EXREQ,
  output wire [3:0]                           TARGEXP1HMASTER,
  output wire [31:0]                          TARGEXP1HWDATA,         // TARGEXP1, HWDATA,
  output wire                                 TARGEXP1HMASTLOCK,      // TARGEXP1, HMASTLOCK,
  output wire                                 TARGEXP1HREADYMUX,      // TARGEXP1, HREADYOUT,
  output wire                                 TARGEXP1HAUSER,         // TARGEXP1, HAUSER,
  output wire [3:0]                           TARGEXP1HWUSER,         // TARGEXP1, HWUSER,
  input  wire [31:0]                          TARGEXP1HRDATA,         // TARGEXP1, HRDATA,
  input  wire                                 TARGEXP1HREADYOUT,      // TARGEXP1, HREADY,
  input  wire                                 TARGEXP1HRESP,          // TARGEXP1, HRESP,
  input  wire                                 TARGEXP1EXRESP,
  input  wire [2:0]                           TARGEXP1HRUSER,         // TARGEXP1, HRUSER,

  // ----------------------------------------------------------------------------
  // AHB Initiator Expansion ports
  // ----------------------------------------------------------------------------
  //  amba.com/AMBA3/AHBLite/r2p0_0, INITEXP0, slave
  input  wire                                 INITEXP0HSEL,           // INITEXP0, HSELx,
  input  wire [31:0]                          INITEXP0HADDR,          // INITEXP0, HADDR,
  input  wire [1:0]                           INITEXP0HTRANS,         // INITEXP0, HTRANS,
  input  wire                                 INITEXP0HWRITE,         // INITEXP0, HWRITE,
  input  wire [2:0]                           INITEXP0HSIZE,          // INITEXP0, HSIZE,
  input  wire [2:0]                           INITEXP0HBURST,         // INITEXP0, HBURST,
  input  wire [3:0]                           INITEXP0HPROT,          // INITEXP0, HPROT,
  input  wire [1:0]                           INITEXP0MEMATTR,
  input  wire                                 INITEXP0EXREQ,
  input  wire [3:0]                           INITEXP0HMASTER,
  input  wire [31:0]                          INITEXP0HWDATA,         // INITEXP0, HWDATA,
  input  wire                                 INITEXP0HMASTLOCK,      // INITEXP0, HMASTLOCK,
  input  wire                                 INITEXP0HAUSER,         // INITEXP0, HAUSER,
  input  wire [3:0]                           INITEXP0HWUSER,         // INITEXP0, HWUSER,
  output wire [31:0]                          INITEXP0HRDATA,         // INITEXP0, HRDATA,
  output wire                                 INITEXP0HREADY,         // INITEXP0, HREADY,
  output wire                                 INITEXP0HRESP,          // INITEXP0, HRESP,
  output wire                                 INITEXP0EXRESP,
  output wire [2:0]                           INITEXP0HRUSER,         // INITEXP0, HRUSER,

  //  amba.com/AMBA3/AHBLite/r2p0_0, INITEXP1, slave
  input  wire                                 INITEXP1HSEL,           // INITEXP1, HSELx,
  input  wire [31:0]                          INITEXP1HADDR,          // INITEXP1, HADDR,
  input  wire [1:0]                           INITEXP1HTRANS,         // INITEXP1, HTRANS,
  input  wire                                 INITEXP1HWRITE,         // INITEXP1, HWRITE,
  input  wire [2:0]                           INITEXP1HSIZE,          // INITEXP1, HSIZE,
  input  wire [2:0]                           INITEXP1HBURST,         // INITEXP1, HBURST,
  input  wire [3:0]                           INITEXP1HPROT,          // INITEXP1, HPROT,
  input  wire [1:0]                           INITEXP1MEMATTR,
  input  wire                                 INITEXP1EXREQ,
  input  wire [3:0]                           INITEXP1HMASTER,
  input  wire [31:0]                          INITEXP1HWDATA,         // INITEXP1, HWDATA,
  input  wire                                 INITEXP1HMASTLOCK,      // INITEXP1, HMASTLOCK,
  input  wire                                 INITEXP1HAUSER,         // INITEXP1, HAUSER,
  input  wire [3:0]                           INITEXP1HWUSER,         // INITEXP1, HWUSER,
  output wire [31:0]                          INITEXP1HRDATA,         // INITEXP1, HRDATA,
  output wire                                 INITEXP1HREADY,         // INITEXP1, HREADY,
  output wire                                 INITEXP1HRESP,          // INITEXP1, HRESP,
  output wire                                 INITEXP1EXRESP,
  output wire [2:0]                           INITEXP1HRUSER,         // INITEXP1, HRUSER,

  // ----------------------------------------------------------------------------
  // APB TARGET Expansion ports
  // ----------------------------------------------------------------------------
  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP2, master
  output wire                                 APBTARGEXP2PSEL,        // APBTARGEXP2, PSELx,
  output wire                                 APBTARGEXP2PENABLE,     // APBTARGEXP2, PENABLE,
  output wire [11:0]                          APBTARGEXP2PADDR,       // APBTARGEXP2, PADDR,
  output wire                                 APBTARGEXP2PWRITE,      // APBTARGEXP2, PWRITE,
  output wire [31:0]                          APBTARGEXP2PWDATA,      // APBTARGEXP2, PWDATA,
  input  wire [31:0]                          APBTARGEXP2PRDATA,      // APBTARGEXP2, PRDATA,
  input  wire                                 APBTARGEXP2PREADY,      // APBTARGEXP2, PREADY,
  input  wire                                 APBTARGEXP2PSLVERR,     // APBTARGEXP2, PSLVERR,
  output wire [3:0]                           APBTARGEXP2PSTRB,       // APBTARGEXP2, PSTRB,
  output wire [2:0]                           APBTARGEXP2PPROT,       // APBTARGEXP2, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP3, master
  output wire                                 APBTARGEXP3PSEL,        // APBTARGEXP3, PSELx,
  output wire                                 APBTARGEXP3PENABLE,     // APBTARGEXP3, PENABLE,
  output wire [11:0]                          APBTARGEXP3PADDR,       // APBTARGEXP3, PADDR,
  output wire                                 APBTARGEXP3PWRITE,      // APBTARGEXP3, PWRITE,
  output wire [31:0]                          APBTARGEXP3PWDATA,      // APBTARGEXP3, PWDATA,
  input  wire [31:0]                          APBTARGEXP3PRDATA,      // APBTARGEXP3, PRDATA,
  input  wire                                 APBTARGEXP3PREADY,      // APBTARGEXP3, PREADY,
  input  wire                                 APBTARGEXP3PSLVERR,     // APBTARGEXP3, PSLVERR,
  output wire [3:0]                           APBTARGEXP3PSTRB,       // APBTARGEXP3, PSTRB,
  output wire [2:0]                           APBTARGEXP3PPROT,       // APBTARGEXP3, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP4, master
  output wire                                 APBTARGEXP4PSEL,        // APBTARGEXP4, PSELx,
  output wire                                 APBTARGEXP4PENABLE,     // APBTARGEXP4, PENABLE,
  output wire [11:0]                          APBTARGEXP4PADDR,       // APBTARGEXP4, PADDR,
  output wire                                 APBTARGEXP4PWRITE,      // APBTARGEXP4, PWRITE,
  output wire [31:0]                          APBTARGEXP4PWDATA,      // APBTARGEXP4, PWDATA,
  input  wire [31:0]                          APBTARGEXP4PRDATA,      // APBTARGEXP4, PRDATA,
  input  wire                                 APBTARGEXP4PREADY,      // APBTARGEXP4, PREADY,
  input  wire                                 APBTARGEXP4PSLVERR,     // APBTARGEXP4, PSLVERR,
  output wire [3:0]                           APBTARGEXP4PSTRB,       // APBTARGEXP4, PSTRB,
  output wire [2:0]                           APBTARGEXP4PPROT,       // APBTARGEXP4, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP5, master
  output wire                                 APBTARGEXP5PSEL,        // APBTARGEXP5, PSELx,
  output wire                                 APBTARGEXP5PENABLE,     // APBTARGEXP5, PENABLE,
  output wire [11:0]                          APBTARGEXP5PADDR,       // APBTARGEXP5, PADDR,
  output wire                                 APBTARGEXP5PWRITE,      // APBTARGEXP5, PWRITE,
  output wire [31:0]                          APBTARGEXP5PWDATA,      // APBTARGEXP5, PWDATA,
  input  wire [31:0]                          APBTARGEXP5PRDATA,      // APBTARGEXP5, PRDATA,
  input  wire                                 APBTARGEXP5PREADY,      // APBTARGEXP5, PREADY,
  input  wire                                 APBTARGEXP5PSLVERR,     // APBTARGEXP5, PSLVERR,
  output wire [3:0]                           APBTARGEXP5PSTRB,       // APBTARGEXP5, PSTRB,
  output wire [2:0]                           APBTARGEXP5PPROT,       // APBTARGEXP5, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP6, master
  output wire                                 APBTARGEXP6PSEL,        // APBTARGEXP6, PSELx,
  output wire                                 APBTARGEXP6PENABLE,     // APBTARGEXP6, PENABLE,
  output wire [11:0]                          APBTARGEXP6PADDR,       // APBTARGEXP6, PADDR,
  output wire                                 APBTARGEXP6PWRITE,      // APBTARGEXP6, PWRITE,
  output wire [31:0]                          APBTARGEXP6PWDATA,      // APBTARGEXP6, PWDATA,
  input  wire [31:0]                          APBTARGEXP6PRDATA,      // APBTARGEXP6, PRDATA,
  input  wire                                 APBTARGEXP6PREADY,      // APBTARGEXP6, PREADY,
  input  wire                                 APBTARGEXP6PSLVERR,     // APBTARGEXP6, PSLVERR,
  output wire [3:0]                           APBTARGEXP6PSTRB,       // APBTARGEXP6, PSTRB,
  output wire [2:0]                           APBTARGEXP6PPROT,       // APBTARGEXP6, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP7, master
  output wire                                 APBTARGEXP7PSEL,        // APBTARGEXP7, PSELx,
  output wire                                 APBTARGEXP7PENABLE,     // APBTARGEXP7, PENABLE,
  output wire [11:0]                          APBTARGEXP7PADDR,       // APBTARGEXP7, PADDR,
  output wire                                 APBTARGEXP7PWRITE,      // APBTARGEXP7, PWRITE,
  output wire [31:0]                          APBTARGEXP7PWDATA,      // APBTARGEXP7, PWDATA,
  input  wire [31:0]                          APBTARGEXP7PRDATA,      // APBTARGEXP7, PRDATA,
  input  wire                                 APBTARGEXP7PREADY,      // APBTARGEXP7, PREADY,
  input  wire                                 APBTARGEXP7PSLVERR,     // APBTARGEXP7, PSLVERR,
  output wire [3:0]                           APBTARGEXP7PSTRB,       // APBTARGEXP7, PSTRB,
  output wire [2:0]                           APBTARGEXP7PPROT,       // APBTARGEXP7, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP8, master
  output wire                                 APBTARGEXP8PSEL,        // APBTARGEXP8, PSELx,
  output wire                                 APBTARGEXP8PENABLE,     // APBTARGEXP8, PENABLE,
  output wire [11:0]                          APBTARGEXP8PADDR,       // APBTARGEXP8, PADDR,
  output wire                                 APBTARGEXP8PWRITE,      // APBTARGEXP8, PWRITE,
  output wire [31:0]                          APBTARGEXP8PWDATA,      // APBTARGEXP8, PWDATA,
  input  wire [31:0]                          APBTARGEXP8PRDATA,      // APBTARGEXP8, PRDATA,
  input  wire                                 APBTARGEXP8PREADY,      // APBTARGEXP8, PREADY,
  input  wire                                 APBTARGEXP8PSLVERR,     // APBTARGEXP8, PSLVERR,
  output wire [3:0]                           APBTARGEXP8PSTRB,       // APBTARGEXP8, PSTRB,
  output wire [2:0]                           APBTARGEXP8PPROT,       // APBTARGEXP8, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP9, master
  output wire                                 APBTARGEXP9PSEL,        // APBTARGEXP9, PSELx,
  output wire                                 APBTARGEXP9PENABLE,     // APBTARGEXP9, PENABLE,
  output wire [11:0]                          APBTARGEXP9PADDR,       // APBTARGEXP9, PADDR,
  output wire                                 APBTARGEXP9PWRITE,      // APBTARGEXP9, PWRITE,
  output wire [31:0]                          APBTARGEXP9PWDATA,      // APBTARGEXP9, PWDATA,
  input  wire [31:0]                          APBTARGEXP9PRDATA,      // APBTARGEXP9, PRDATA,
  input  wire                                 APBTARGEXP9PREADY,      // APBTARGEXP9, PREADY,
  input  wire                                 APBTARGEXP9PSLVERR,     // APBTARGEXP9, PSLVERR,
  output wire [3:0]                           APBTARGEXP9PSTRB,       // APBTARGEXP9, PSTRB,
  output wire [2:0]                           APBTARGEXP9PPROT,       // APBTARGEXP9, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP10, master
  output wire                                 APBTARGEXP10PSEL,       // APBTARGEXP10, PSELx,
  output wire                                 APBTARGEXP10PENABLE,    // APBTARGEXP10, PENABLE,
  output wire [11:0]                          APBTARGEXP10PADDR,      // APBTARGEXP10, PADDR,
  output wire                                 APBTARGEXP10PWRITE,     // APBTARGEXP10, PWRITE,
  output wire [31:0]                          APBTARGEXP10PWDATA,     // APBTARGEXP10, PWDATA,
  input  wire [31:0]                          APBTARGEXP10PRDATA,     // APBTARGEXP10, PRDATA,
  input  wire                                 APBTARGEXP10PREADY,     // APBTARGEXP10, PREADY,
  input  wire                                 APBTARGEXP10PSLVERR,    // APBTARGEXP10, PSLVERR,
  output wire [3:0]                           APBTARGEXP10PSTRB,      // APBTARGEXP10, PSTRB,
  output wire [2:0]                           APBTARGEXP10PPROT,      // APBTARGEXP10, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP11, master
  output wire                                 APBTARGEXP11PSEL,       // APBTARGEXP11, PSELx,
  output wire                                 APBTARGEXP11PENABLE,    // APBTARGEXP11, PENABLE,
  output wire [11:0]                          APBTARGEXP11PADDR,      // APBTARGEXP11, PADDR,
  output wire                                 APBTARGEXP11PWRITE,     // APBTARGEXP11, PWRITE,
  output wire [31:0]                          APBTARGEXP11PWDATA,     // APBTARGEXP11, PWDATA,
  input  wire [31:0]                          APBTARGEXP11PRDATA,     // APBTARGEXP11, PRDATA,
  input  wire                                 APBTARGEXP11PREADY,     // APBTARGEXP11, PREADY,
  input  wire                                 APBTARGEXP11PSLVERR,    // APBTARGEXP11, PSLVERR,
  output wire [3:0]                           APBTARGEXP11PSTRB,      // APBTARGEXP11, PSTRB,
  output wire [2:0]                           APBTARGEXP11PPROT,      // APBTARGEXP11, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP12, master
  output wire                                 APBTARGEXP12PSEL,       // APBTARGEXP12, PSELx,
  output wire                                 APBTARGEXP12PENABLE,    // APBTARGEXP12, PENABLE,
  output wire [11:0]                          APBTARGEXP12PADDR,      // APBTARGEXP12, PADDR,
  output wire                                 APBTARGEXP12PWRITE,     // APBTARGEXP12, PWRITE,
  output wire [31:0]                          APBTARGEXP12PWDATA,     // APBTARGEXP12, PWDATA,
  input  wire [31:0]                          APBTARGEXP12PRDATA,     // APBTARGEXP12, PRDATA,
  input  wire                                 APBTARGEXP12PREADY,     // APBTARGEXP12, PREADY,
  input  wire                                 APBTARGEXP12PSLVERR,    // APBTARGEXP12, PSLVERR,
  output wire [3:0]                           APBTARGEXP12PSTRB,      // APBTARGEXP12, PSTRB,
  output wire [2:0]                           APBTARGEXP12PPROT,      // APBTARGEXP12, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP13, master
  output wire                                 APBTARGEXP13PSEL,       // APBTARGEXP13, PSELx,
  output wire                                 APBTARGEXP13PENABLE,    // APBTARGEXP13, PENABLE,
  output wire [11:0]                          APBTARGEXP13PADDR,      // APBTARGEXP13, PADDR,
  output wire                                 APBTARGEXP13PWRITE,     // APBTARGEXP13, PWRITE,
  output wire [31:0]                          APBTARGEXP13PWDATA,     // APBTARGEXP13, PWDATA,
  input  wire [31:0]                          APBTARGEXP13PRDATA,     // APBTARGEXP13, PRDATA,
  input  wire                                 APBTARGEXP13PREADY,     // APBTARGEXP13, PREADY,
  input  wire                                 APBTARGEXP13PSLVERR,    // APBTARGEXP13, PSLVERR,
  output wire [3:0]                           APBTARGEXP13PSTRB,      // APBTARGEXP13, PSTRB,
  output wire [2:0]                           APBTARGEXP13PPROT,      // APBTARGEXP13, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP14, master
  output wire                                 APBTARGEXP14PSEL,       // APBTARGEXP14, PSELx,
  output wire                                 APBTARGEXP14PENABLE,    // APBTARGEXP14, PENABLE,
  output wire [11:0]                          APBTARGEXP14PADDR,      // APBTARGEXP14, PADDR,
  output wire                                 APBTARGEXP14PWRITE,     // APBTARGEXP14, PWRITE,
  output wire [31:0]                          APBTARGEXP14PWDATA,     // APBTARGEXP14, PWDATA,
  input  wire [31:0]                          APBTARGEXP14PRDATA,     // APBTARGEXP14, PRDATA,
  input  wire                                 APBTARGEXP14PREADY,     // APBTARGEXP14, PREADY,
  input  wire                                 APBTARGEXP14PSLVERR,    // APBTARGEXP14, PSLVERR,
  output wire [3:0]                           APBTARGEXP14PSTRB,      // APBTARGEXP14, PSTRB,
  output wire [2:0]                           APBTARGEXP14PPROT,      // APBTARGEXP14, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP15, master
  output wire                                 APBTARGEXP15PSEL,       // APBTARGEXP15, PSELx,
  output wire                                 APBTARGEXP15PENABLE,    // APBTARGEXP15, PENABLE,
  output wire [11:0]                          APBTARGEXP15PADDR,      // APBTARGEXP15, PADDR,
  output wire                                 APBTARGEXP15PWRITE,     // APBTARGEXP15, PWRITE,
  output wire [31:0]                          APBTARGEXP15PWDATA,     // APBTARGEXP15, PWDATA,
  input  wire [31:0]                          APBTARGEXP15PRDATA,     // APBTARGEXP15, PRDATA,
  input  wire                                 APBTARGEXP15PREADY,     // APBTARGEXP15, PREADY,
  input  wire                                 APBTARGEXP15PSLVERR,    // APBTARGEXP15, PSLVERR,
  output wire [3:0]                           APBTARGEXP15PSTRB,      // APBTARGEXP15, PSTRB,
  output wire [2:0]                           APBTARGEXP15PPROT,      // APBTARGEXP15, PPROT,

  // ----------------------------------------------------------------------------
  // No DAP or PPB ports - CoreSight SoC not supported in DesignStart
  // ----------------------------------------------------------------------------

  // ----------------------------------------------------------------------------
  // CPU Debug
  // ----------------------------------------------------------------------------
  input  wire                                 CPU0EDBGRQ,             // External debug request. Combined debug request from ETM
                                                                      // trace unit and multiprocessor debug support to connect
                                                                      // to CoreSight Embedded Cross Trigger.
  input  wire                                 CPU0DBGRESTART,         // External restart request. The processor exits the halt
                                                                      // state when the CPU0DBGRESTART signal is deasserted during
                                                                      // 4-phase handshaking.
  output wire                                 CPU0DBGRESTARTED,       // Handshake for CPU0DBGRESTART. Devices driving
                                                                      // CPU0DBGRESTART must observe this signal to generate the
                                                                      // required 4-phase handshaking.
  output wire [31:0]                          CPU0HTMDHADDR,          // HTM data (debug visibility)
  output wire [1:0]                           CPU0HTMDHTRANS,         // HTM data
  output wire [2:0]                           CPU0HTMDHSIZE,          // HTM data
  output wire [2:0]                           CPU0HTMDHBURST,         // HTM data
  output wire [3:0]                           CPU0HTMDHPROT,          // HTM data
  output wire [31:0]                          CPU0HTMDHWDATA,         // HTM data
  output wire                                 CPU0HTMDHWRITE,         // HTM data
  output wire [31:0]                          CPU0HTMDHRDATA,         // HTM data
  output wire                                 CPU0HTMDHREADY,         // HTM data
  output wire [1:0]                           CPU0HTMDHRESP,          // HTM data

  // ----------------------------------------------------------------------------
  // CPU Trace external interface
  // ----------------------------------------------------------------------------
  input  wire [47:0]                          CPU0TSVALUEB,           // Global timestamp value.
  output wire [8:0]                           CPU0ETMINTNUM,          // Marks the interrupt number of the current execution
                                                                      // context.
  output wire [2:0]                           CPU0ETMINTSTAT,         // Interrupt status. Marks interrupt status of current
                                                                      // cycle:
                                                                      //  0b000 - no status
                                                                      //  0b001 - interrupt entry
                                                                      //  0b010 - interrupt exit
                                                                      //  0b011 - interrupt return
                                                                      //  0b100 - vector fetch and stack push.
                                                                      // ETMINTSTAT entry or return is asserted in the first
                                                                      // cycle of the new interrupt context. Exit occurs
                                                                      // without ETMIVALID.

  // ----------------------------------------------------------------------------
  // CPU Control, Status and Configuration
  // ----------------------------------------------------------------------------
  output wire                                 CPU0HALTED,             // In halting mode debug. HALTED remains asserted while
                                                                      // the core is in debug.
  input  wire                                 CPU0MPUDISABLE,         // If asserted the MPU is invisible and unusable. Tie HIGH
                                                                      // to disable the MPU. Tie LOW to enable the MPU, if present
  output wire                                 CPU0SLEEPING,           // Indicated that the processor is in sleep mode (sleep mode)
  output wire                                 CPU0SLEEPDEEP,          // Indicates that the processor is in deep sleep mode
  input  wire                                 CPU0SLEEPHOLDREQn,      // Request to extend sleep. Can only be asserted when
                                                                      // SLEEPING is HIGH
  output wire                                 CPU0SLEEPHOLDACKn,      // Acknowledge for CPU0SLEEPHOLDREQn
  output wire                                 CPU0WAKEUP,             // Active-HIGH signal to the PMU that indicates that a
                                                                      // wake-up event has occurred and the processor system domain
                                                                      // requires its clocks and power to be restored.
  output wire                                 CPU0WICENACK,           // Active-HIGH acknowledge signal for WICENREQ. If you do not
                                                                      // require PMU, then tie this signal HIGH to enable the WIC if
                                                                      // the WIC is implemented
  output wire [WIC_LINES-1:0]                CPU0WICSENSE,           // Not exported in DesignStart Eval
  input  wire                                 CPU0WICENREQ,           // Active-HIGH request for deep sleep to be WIC-based deep
                                                                      // sleep. The PMU drives this
  output wire                                 CPU0SYSRESETREQ,        // Processor control - system reset request AIRC.SYSRESETREQ
                                                                      // MMR controls this bit
  output wire                                 CPU0LOCKUP,             // Indicates that the core is locked up.
  output wire                                 CPU0CDBGPWRUPREQ,       // Debug Power Domain up request
  input  wire                                 CPU0CDBGPWRUPACK,       // Debug Power Domain up acknowledge
  output wire [3:0]                           CPU0BRCHSTAT,           // 0b0000 = No branch currently in decode
                                                                      // 0b0001 = Decode time conditional branch backwards currently
                                                                      //          in decode
                                                                      // 0b0010 = Decode time conditional branch currently in
                                                                      //          decode
                                                                      // 0b0011 = Execute time conditional branch currently in
                                                                      //          decode
                                                                      // 0b0100 = Decode time unconditional branch currently in
                                                                      //          decode
                                                                      // 0b0101 = Execute time unconditional branch in decode
                                                                      // 0b0110 = Reserved
                                                                      // 0b0111 = Reserved
                                                                      // 0b1000 = Conditional branch in decode taken, cycle after
                                                                      //          0b0001 or 0b0010

  // ----------------------------------------------------------------------------
  // CSS configuration inputs
  // ----------------------------------------------------------------------------
  input  wire [3:1]                           MTXREMAP,               // REMAP[0]: The Embedded flash memory region represents the
                                                                      // maximum supported eFlash size: 512kByte. If the size of the
                                                                      // actual eFlash banks is 256kByte, the upper 256kByte can be
                                                                      // remapped to the AHB expansion port as follows
                                                                      //       REMAP[0]=`1b0 -> 512kbyte eFlash
                                                                      //       REMAP[0]=`1b1 -> 256kbyte eFlash upper 256kbytes
                                                                      //                        mapped to AHB expansion port
                                                                      // REMAP[1]: If SRAM1 is not present the corresponding memory
                                                                      //           range can be mapped to AHB expansion port as
                                                                      //           follows
                                                                      //       REMAP[1]=`1b0 -> SRAM1 present
                                                                      //       REMAP[1]=`1b1 -> SRAM1 not available, mapped to AHB
                                                                      // REMAP[2]: If SRAM2 is not present the corresponding memory
                                                                      //           range expansion port can be mapped to AHB
                                                                      //           expansion port as follows
                                                                      //       REMAP[2]=`1b0 -> SRAM2 present
                                                                      //       REMAP[2]=`1b1 -> SRAM2 not available, mapped to  AHB
                                                                      // REMAP[3]: If SRAM3 is not present the corresponding memory
                                                                      //           range expansion port can be mapped to AHB
                                                                      //           expansion port as follows
                                                                      //       REMAP[3]=`1b0 -> SRAM3 present
                                                                      //       REMAP[3]=`1b1 -> SRAM3 not available, mapped to  AHB
                                                                      //                        expansion port

  // ----------------------------------------------------------------------------
  // Events
  // ----------------------------------------------------------------------------
  input   wire                                CPU0RXEV,               // RX event input of the Cortex-M3 Causes a wake-up from a WFE
  output  wire                                CPU0TXEV,               // instruction TX event output of the Cortex-M3 Event
                                                                      // transmitted as a result of SEV instruction. This is a
                                                                      // single-cycle pulse. You can use it to implement a more
                                                                      // power efficient spin-lock in a multi-processor system

  // ----------------------------------------------------------------------------
  // Interrupts from the system
  // ----------------------------------------------------------------------------
  input  wire [239:0]                         CPU0INTISR,             // External interrupt signals
  input  wire                                 CPU0INTNMI,             // Non-maskable Interrupt
  output wire [7:0]                           CPU0CURRPRI,            // Indicates what priority interrupt, or base boost, is being
                                                                      // used now. CURRPRI represents the pre-emption priority, and
                                                                      // does not indicate secondary priority.
  input  wire [31:0]                          CPU0AUXFAULT,           // Auxiliary fault status information from the system.

  // PMU Interface/Clock Reset control interface
  output wire                                 APBQACTIVE,             // APB bus active signal for global clock gating control of
                                                                      // all APB peripherals attached to SSE-050 that support
                                                                      // gated APB clock
  output wire                                 TIMER0PCLKQACTIVE,      // APB bus active signal for clock gating control of Timer 0
                                                                      // APB clock TIMER0PCLKG (i.e.PSEL)
  output wire                                 TIMER1PCLKQACTIVE,      // APB bus active signal for clock gating control of Timer 1
                                                                      // APB clock TIMER1PCLKG (i.e.PSEL)

  // ----------------------------------------------------------------------------
  // JTAG and SW connections are made at fpga_top level
  // ----------------------------------------------------------------------------

  // ----------------------------------------------------------------------------
  // Trace Port  connections are made at fpga_top level
  // ----------------------------------------------------------------------------

  // ----------------------------------------------------------------------------
  // Secure Debug  Control
  // ----------------------------------------------------------------------------
  input  wire                                 CPU0DBGEN,              // External debug enable. If CPU0DBGEN is de-asserted, then
                                                                      // the halt debugging feature of the processor is disabled,
                                                                      // and the invasive debug features on the CTI are also
                                                                      // disabled. If CPU0DBGEN is asserted,then you can use debug
                                                                      // features, but you must still set other enables, such as
                                                                      // C_DEBUGEN, to enable debug events such as halt to occur.
                                                                      // Either tie HIGH or connect to a debug access controller
                                                                      // if required.
  input  wire                                 CPU0NIDEN,              // Strap signal Non Invasive debug enable. NIDEN must be HIGH
                                                                      // to enable the ETM trace unit to trace instructions.
  input  wire                                 CPU0FIXMASTERTYPE,      // The AHB-AP can issue AHB transactions with a HMASTER value
                                                                      // of either 1, to indicate DAP, or 0, to indicate processor
                                                                      // data side, depending on how the AHB-AP is configured using
                                                                      // the MasterType bit in the AHB-AP Control and Status Word
                                                                      // Register. You can use FIXMASTERTYPE to prevent this if
                                                                      // required. If it is tied to 0b1, then the HMASTER that the
                                                                      // AHB-AP issues is always 1, to indicate DAP, and it cannot
                                                                      // imitate the processor. If it is tied to 0b0, then HMASTER
                                                                      // can be issued as either 0 or 1.
  input wire                                  CPU0ISOLATEn,           // CPU Clock gating term. Tie High
  input wire                                  CPU0RETAINn,            // Connected by power annotation within CPU
   // ----------------------------------------------------------------------------
   // Test control signals
   // ----------------------------------------------------------------------------

   //Test control signals
  input wire                                  DFTSCANMODE,            // Reset bypass - disable internal generated reset for testing
                                                                      // (e.g. ATPG)
  input wire                                  DFTCGEN,                // Clock gating bypass - disable internal clock gating for
                                                                      // testing. This signal is used to ensure safe shift, the
                                                                      // clock is forced on during the shift mode.
  input wire                                  DFTSE,                  // DFT Scan Enable

  // ----------------------------------------------------------------------------
  // Status signals to sysctrl.
  // ----------------------------------------------------------------------------
  output wire                                 CPU0BIGEND,             // Constant wire status

  // ----------------------------------------------------------------------------
  // Debug and Trace
  // ----------------------------------------------------------------------------
  input  wire                                 nTRST,                  // Test reset
  input  wire                                 SWDITMS,                // Test Mode Select/SWDIN
  input  wire                                 SWCLKTCK,               // Test clock / SWCLK
  input  wire                                 TDI,                    // Test Data In
  output wire                                 TDO,                    // Test Data Out
  output wire                                 nTDOEN,                 // Test Data Out Enable

  // Single Wire
  output wire                                 SWDO,                   // SingleWire data out
  output wire                                 SWDOEN,                 // SingleWire output enable
  output wire                                 JTAGNSW,                // JTAG mode(1) or SW mode(0)

  // Single Wire Viewer
  output wire                                 SWV,                    // SingleWire Viewer Data

  // TracePort Output
  output wire                                 TRACECLK,               // TracePort clock reference
  output wire [3:0]                           TRACEDATA,              // TracePort Data
  output wire                                 TRCENA,                 // Trace Enable

  output wire                                 CPU0GATEHCLK            // When high, CPU HCLK can be turned off
  );

  //Derived parameters
  localparam WICSENSE_MAX     = (WIC_LINES-1);
  // ------------------------------------------------------------
  // u_p_beid_interconnect_f0 - Interconnect package
  // ------------------------------------------------------------

  // CPU I-Code (<->CodeMux)
  wire   [31:0] haddri;
  wire    [1:0] htransi;
  wire    [2:0] hsizei;
  wire    [2:0] hbursti;
  wire    [3:0] hproti;
  wire    [1:0] memattri;
  wire   [31:0] hrdatai;
  wire          hreadyi;
  wire    [1:0] hrespi;

  // CPU D-Code (<-> Code Mux)
  wire   [31:0] haddrd;
  wire    [1:0] htransd;
  wire    [1:0] hmasterd;
  wire    [2:0] hsized;
  wire    [2:0] hburstd;
  wire    [3:0] hprotd;
  wire    [1:0] memattrd;
  wire   [31:0] hwdatad;
  wire          hwrited;
  wire          exreqd;
  wire   [31:0] hrdatad;
  wire          hreadyd;
  wire    [1:0] hrespd;
  wire          exrespd;

  // CPU System bus (<-> AHB MTX)
  wire   [31:0] haddrs;
  wire    [1:0] htranss;
  wire    [1:0] hmasters;
  wire          hwrites;
  wire    [2:0] hsizes;
  wire          hmastlocks;
  wire   [31:0] hwdatas;
  wire    [2:0] hbursts;
  wire    [3:0] hprots;
  wire    [1:0] memattrs;
  wire          exreqs;
  wire          hreadys;
  wire   [31:0] hrdatas;
  wire    [1:0] hresps;
  wire          exresps;

  //Connections
  // Control port
  wire    [3:0] mtxremap_int;

  // AHB MTX (<-> SRAM0)
  wire          targsram0hsel;
  wire   [31:0] targsram0haddr;
  wire    [1:0] targsram0htrans;
  wire          targsram0hwrite;
  wire    [2:0] targsram0hsize;
  wire   [31:0] targsram0hwdata;
  wire          targsram0hreadymux;
  wire          targsram0hreadyout;
  wire   [31:0] targsram0hrdata;
  wire          targsram0hresp;
  wire          targsram0exresp_int;

  wire    [2:0] targsram0hruser_int;

  // AHB MTX (<-> SRAM1)
  wire          targsram1hsel;
  wire   [31:0] targsram1haddr;
  wire    [1:0] targsram1htrans;
  wire          targsram1hwrite;
  wire    [2:0] targsram1hsize;
  wire   [31:0] targsram1hwdata;
  wire          targsram1hreadymux;
  wire          targsram1hreadyout;
  wire   [31:0] targsram1hrdata;
  wire          targsram1hresp;
  wire          targsram1exresp_int;

  wire    [2:0] targsram1hruser_int;

  // AHB MTX (<-> SRAM2)
  wire          targsram2hsel;
  wire   [31:0] targsram2haddr;
  wire    [1:0] targsram2htrans;
  wire          targsram2hwrite;
  wire    [2:0] targsram2hsize;
  wire   [31:0] targsram2hwdata;
  wire          targsram2hreadymux;
  wire          targsram2hreadyout;
  wire   [31:0] targsram2hrdata;
  wire          targsram2hresp;
  wire          targsram2exresp_int;

  wire    [2:0] targsram2hruser_int;

  // AHB MTX (<-> SRAM3)
  wire          targsram3hsel;
  wire   [31:0] targsram3haddr;
  wire    [1:0] targsram3htrans;
  wire          targsram3hwrite;
  wire    [2:0] targsram3hsize;
  wire   [31:0] targsram3hwdata;
  wire          targsram3hreadymux;
  wire          targsram3hreadyout;
  wire   [31:0] targsram3hrdata;
  wire          targsram3hresp;
  wire          targsram3exresp_int;

  wire    [2:0] targsram3hruser_int;

  // AHB MTX (Test signals not used in RTL)
  wire          mtxscanenable_int;
  wire          mtxscaninhclk_int;

  // APBTARGEXP0
  wire   [11:0] apbtargexp0paddr;
  wire          apbtargexp0penable;
  wire          apbtargexp0pwrite;
  wire    [3:0] apbtargexp0pstrb;
  wire    [2:0] apbtargexp0pprot;
  wire   [31:0] apbtargexp0pwdata;
  wire          apbtargexp0psel;
  wire   [31:0] apbtargexp0prdata;
  wire          apbtargexp0pready;
  wire          apbtargexp0pslverr;

  // APBTARGEXP1
  wire   [11:0] apbtargexp1paddr;
  wire          apbtargexp1penable;
  wire          apbtargexp1pwrite;
  wire    [3:0] apbtargexp1pstrb;
  wire    [2:0] apbtargexp1pprot;
  wire   [31:0] apbtargexp1pwdata;
  wire          apbtargexp1psel;
  wire   [31:0] apbtargexp1prdata;
  wire          apbtargexp1pready;
  wire          apbtargexp1pslverr;

  //CM3 I/D Unused User signals tied off
  wire          hauserinitcm3di_int = 1'b0;
  wire   [3:0]  hwuserinitcm3di_int = 4'h0;
  //CM3 SYS Unused User Signals tied off
  wire          hauserinitcm3s_int  = 1'b0;
  wire   [3:0]  hwuserinitcm3s_int  = 4'h0;

  // Untentionally unused signals;
  wire          unused;

  //QACTIVE signal mapping
  assign TIMER0PCLKQACTIVE  = apbtargexp0psel;
  assign TIMER1PCLKQACTIVE  = apbtargexp1psel;

  //Flash size Mapping, fixed at 256k
  assign mtxremap_int = {MTXREMAP[3:1] , 1'b1};

  //Bus MTX Test Signals tied off because not used in RTL
  assign mtxscanenable_int = 1'b0;
  assign mtxscaninhclk_int = 1'b0;

  // Package instantiation
 p_beid_interconnect_f0 u_p_beid_interconnect_f0 (
    .MTXHCLK              (MTXHCLK),
    .MTXHRESETn           (MTXHRESETn),
    .AHB2APBHCLK          (AHB2APBHCLK),
    .MTXREMAP             (mtxremap_int),
    .APBQACTIVE           (APBQACTIVE),
    .HADDRI               (haddri),
    .HTRANSI              (htransi),
    .HSIZEI               (hsizei),
    .HBURSTI              (hbursti),
    .HPROTI               (hproti),
    .MEMATTRI             (memattri),
    .HRDATAI              (hrdatai),
    .HREADYI              (hreadyi),
    .HRESPI               (hrespi),
    .HADDRD               (haddrd),
    .HTRANSD              (htransd),
    .HMASTERD             (hmasterd),
    .HSIZED               (hsized),
    .HBURSTD              (hburstd),
    .HPROTD               (hprotd),
    .MEMATTRD             (memattrd),
    .HWDATAD              (hwdatad),
    .HWRITED              (hwrited),
    .EXREQD               (exreqd),
    .HRDATAD              (hrdatad),
    .HREADYD              (hreadyd),
    .HRESPD               (hrespd),
    .EXRESPD              (exrespd),
    .HAUSERINITCM3DI      (hauserinitcm3di_int),
    .HWUSERINITCM3DI      (hwuserinitcm3di_int),
    .HRUSERINITCM3DI      (/*Not supported*/),
    .HADDRS               (haddrs),
    .HTRANSS              (htranss),
    .HMASTERS             (hmasters),
    .HWRITES              (hwrites),
    .HSIZES               (hsizes),
    .HMASTLOCKS           (hmastlocks),
    .HWDATAS              (hwdatas),
    .HBURSTS              (hbursts),
    .HPROTS               (hprots),
    .MEMATTRS             (memattrs),
    .EXREQS               (exreqs),
    .HAUSERINITCM3S       (hauserinitcm3s_int),
    .HWUSERINITCM3S       (hwuserinitcm3s_int),
    .HRUSERINITCM3S       (/*Not supported*/),
    .HREADYS              (hreadys),
    .HRDATAS              (hrdatas),
    .HRESPS               (hresps),
    .EXRESPS              (exresps),
    .INITEXP0HSEL         (INITEXP0HSEL),
    .INITEXP0HADDR        (INITEXP0HADDR),
    .INITEXP0HTRANS       (INITEXP0HTRANS),
    .INITEXP0HMASTER      (INITEXP0HMASTER),
    .INITEXP0HWRITE       (INITEXP0HWRITE),
    .INITEXP0HSIZE        (INITEXP0HSIZE),
    .INITEXP0HMASTLOCK    (INITEXP0HMASTLOCK),
    .INITEXP0HWDATA       (INITEXP0HWDATA),
    .INITEXP0HBURST       (INITEXP0HBURST),
    .INITEXP0HPROT        (INITEXP0HPROT),
    .INITEXP0MEMATTR      (INITEXP0MEMATTR),
    .INITEXP0EXREQ        (INITEXP0EXREQ),
    .INITEXP0HREADY       (INITEXP0HREADY),
    .INITEXP0HRDATA       (INITEXP0HRDATA),
    .INITEXP0HRESP        (INITEXP0HRESP),
    .INITEXP0EXRESP       (INITEXP0EXRESP),
    .INITEXP0HAUSER       (INITEXP0HAUSER),
    .INITEXP0HWUSER       (INITEXP0HWUSER),
    .INITEXP0HRUSER       (INITEXP0HRUSER),
    .INITEXP1HSEL         (INITEXP1HSEL),
    .INITEXP1HADDR        (INITEXP1HADDR),
    .INITEXP1HTRANS       (INITEXP1HTRANS),
    .INITEXP1HMASTER      (INITEXP1HMASTER),
    .INITEXP1HWRITE       (INITEXP1HWRITE),
    .INITEXP1HSIZE        (INITEXP1HSIZE),
    .INITEXP1HMASTLOCK    (INITEXP1HMASTLOCK),
    .INITEXP1HWDATA       (INITEXP1HWDATA),
    .INITEXP1HBURST       (INITEXP1HBURST),
    .INITEXP1HPROT        (INITEXP1HPROT),
    .INITEXP1MEMATTR      (INITEXP1MEMATTR),
    .INITEXP1EXREQ        (INITEXP1EXREQ),
    .INITEXP1HREADY       (INITEXP1HREADY),
    .INITEXP1HRDATA       (INITEXP1HRDATA),
    .INITEXP1HRESP        (INITEXP1HRESP),
    .INITEXP1EXRESP       (INITEXP1EXRESP),
    .INITEXP1HAUSER       (INITEXP1HAUSER),
    .INITEXP1HWUSER       (INITEXP1HWUSER),
    .INITEXP1HRUSER       (INITEXP1HRUSER),
    .TARGEXP0HSEL         (TARGEXP0HSEL),
    .TARGEXP0HADDR        (TARGEXP0HADDR),
    .TARGEXP0HTRANS       (TARGEXP0HTRANS),
    .TARGEXP0HMASTER      (TARGEXP0HMASTER),
    .TARGEXP0HWRITE       (TARGEXP0HWRITE),
    .TARGEXP0HSIZE        (TARGEXP0HSIZE),
    .TARGEXP0HMASTLOCK    (TARGEXP0HMASTLOCK),
    .TARGEXP0HWDATA       (TARGEXP0HWDATA),
    .TARGEXP0HBURST       (TARGEXP0HBURST),
    .TARGEXP0HPROT        (TARGEXP0HPROT),
    .TARGEXP0MEMATTR      (TARGEXP0MEMATTR),
    .TARGEXP0EXREQ        (TARGEXP0EXREQ),
    .TARGEXP0HREADYMUX    (TARGEXP0HREADYMUX),
    .TARGEXP0HREADYOUT    (TARGEXP0HREADYOUT),
    .TARGEXP0HRDATA       (TARGEXP0HRDATA),
    .TARGEXP0HRESP        (TARGEXP0HRESP),
    .TARGEXP0EXRESP       (TARGEXP0EXRESP),
    .TARGEXP0HAUSER       (TARGEXP0HAUSER),
    .TARGEXP0HWUSER       (TARGEXP0HWUSER),
    .TARGEXP0HRUSER       (TARGEXP0HRUSER),
    .TARGEXP1HSEL         (TARGEXP1HSEL),
    .TARGEXP1HADDR        (TARGEXP1HADDR),
    .TARGEXP1HTRANS       (TARGEXP1HTRANS),
    .TARGEXP1HMASTER      (TARGEXP1HMASTER),
    .TARGEXP1HWRITE       (TARGEXP1HWRITE),
    .TARGEXP1HSIZE        (TARGEXP1HSIZE),
    .TARGEXP1HMASTLOCK    (TARGEXP1HMASTLOCK),
    .TARGEXP1HWDATA       (TARGEXP1HWDATA),
    .TARGEXP1HBURST       (TARGEXP1HBURST),
    .TARGEXP1HPROT        (TARGEXP1HPROT),
    .TARGEXP1MEMATTR      (TARGEXP1MEMATTR),
    .TARGEXP1EXREQ        (TARGEXP1EXREQ),
    .TARGEXP1HREADYMUX    (TARGEXP1HREADYMUX),
    .TARGEXP1HREADYOUT    (TARGEXP1HREADYOUT),
    .TARGEXP1HRDATA       (TARGEXP1HRDATA),
    .TARGEXP1HRESP        (TARGEXP1HRESP),
    .TARGEXP1EXRESP       (TARGEXP1EXRESP),
    .TARGEXP1HAUSER       (TARGEXP1HAUSER),
    .TARGEXP1HWUSER       (TARGEXP1HWUSER),
    .TARGEXP1HRUSER       (TARGEXP1HRUSER),
    .TARGFLASH0HSEL       (TARGFLASH0HSEL),
    .TARGFLASH0HADDR      (TARGFLASH0HADDR),
    .TARGFLASH0HTRANS     (TARGFLASH0HTRANS),
    .TARGFLASH0HMASTER    (TARGFLASH0HMASTER),
    .TARGFLASH0HWRITE     (TARGFLASH0HWRITE),
    .TARGFLASH0HSIZE      (TARGFLASH0HSIZE),
    .TARGFLASH0HMASTLOCK  (TARGFLASH0HMASTLOCK),
    .TARGFLASH0HWDATA     (TARGFLASH0HWDATA),
    .TARGFLASH0HBURST     (TARGFLASH0HBURST),
    .TARGFLASH0HPROT      (TARGFLASH0HPROT),
    .TARGFLASH0MEMATTR    (TARGFLASH0MEMATTR),
    .TARGFLASH0EXREQ      (TARGFLASH0EXREQ),
    .TARGFLASH0HREADYMUX  (TARGFLASH0HREADYMUX),
    .TARGFLASH0HREADYOUT  (TARGFLASH0HREADYOUT),
    .TARGFLASH0HRDATA     (TARGFLASH0HRDATA),
    .TARGFLASH0HRESP      (TARGFLASH0HRESP),
    .TARGFLASH0EXRESP     (TARGFLASH0EXRESP),
    .TARGFLASH0HAUSER     (TARGFLASH0HAUSER),
    .TARGFLASH0HWUSER     (TARGFLASH0HWUSER),
    .TARGFLASH0HRUSER     (TARGFLASH0HRUSER),
    .TARGSRAM0HSEL        (targsram0hsel),
    .TARGSRAM0HADDR       (targsram0haddr),
    .TARGSRAM0HTRANS      (targsram0htrans),
    .TARGSRAM0HMASTER     (/*Not supported*/),
    .TARGSRAM0HWRITE      (targsram0hwrite),
    .TARGSRAM0HSIZE       (targsram0hsize),
    .TARGSRAM0HMASTLOCK   (/*Not supported*/),
    .TARGSRAM0HWDATA      (targsram0hwdata),
    .TARGSRAM0HBURST      (/*Not supported*/),
    .TARGSRAM0HPROT       (/*Not supported*/),
    .TARGSRAM0MEMATTR     (/*Not supported*/),
    .TARGSRAM0EXREQ       (/*Not supported*/),
    .TARGSRAM0HREADYMUX   (targsram0hreadymux),
    .TARGSRAM0HREADYOUT   (targsram0hreadyout),
    .TARGSRAM0HRDATA      (targsram0hrdata),
    .TARGSRAM0HRESP       (targsram0hresp),
    .TARGSRAM0EXRESP      (targsram0exresp_int),
    .TARGSRAM0HAUSER      (/*Not supported*/),
    .TARGSRAM0HWUSER      (/*Not supported*/),
    .TARGSRAM0HRUSER      (targsram0hruser_int),
    .TARGSRAM1HSEL        (targsram1hsel),
    .TARGSRAM1HADDR       (targsram1haddr),
    .TARGSRAM1HTRANS      (targsram1htrans),
    .TARGSRAM1HMASTER     (/*Not supported*/),
    .TARGSRAM1HWRITE      (targsram1hwrite),
    .TARGSRAM1HSIZE       (targsram1hsize),
    .TARGSRAM1HMASTLOCK   (/*Not supported*/),
    .TARGSRAM1HWDATA      (targsram1hwdata),
    .TARGSRAM1HBURST      (/*Not supported*/),
    .TARGSRAM1HPROT       (/*Not supported*/),
    .TARGSRAM1MEMATTR     (/*Not supported*/),
    .TARGSRAM1EXREQ       (/*Not supported*/),
    .TARGSRAM1HREADYMUX   (targsram1hreadymux),
    .TARGSRAM1HREADYOUT   (targsram1hreadyout),
    .TARGSRAM1HRDATA      (targsram1hrdata),
    .TARGSRAM1HRESP       (targsram1hresp),
    .TARGSRAM1EXRESP      (targsram1exresp_int),
    .TARGSRAM1HAUSER      (/*Not supported*/),
    .TARGSRAM1HWUSER      (/*Not supported*/),
    .TARGSRAM1HRUSER      (targsram1hruser_int),
    .TARGSRAM2HSEL        (targsram2hsel),
    .TARGSRAM2HADDR       (targsram2haddr),
    .TARGSRAM2HTRANS      (targsram2htrans),
    .TARGSRAM2HMASTER     (/*Not supported*/),
    .TARGSRAM2HWRITE      (targsram2hwrite),
    .TARGSRAM2HSIZE       (targsram2hsize),
    .TARGSRAM2HMASTLOCK   (/*Not supported*/),
    .TARGSRAM2HWDATA      (targsram2hwdata),
    .TARGSRAM2HBURST      (/*Not supported*/),
    .TARGSRAM2HPROT       (/*Not supported*/),
    .TARGSRAM2MEMATTR     (/*Not supported*/),
    .TARGSRAM2EXREQ       (/*Not supported*/),
    .TARGSRAM2HREADYMUX   (targsram2hreadymux),
    .TARGSRAM2HREADYOUT   (targsram2hreadyout),
    .TARGSRAM2HRDATA      (targsram2hrdata),
    .TARGSRAM2HRESP       (targsram2hresp),
    .TARGSRAM2EXRESP      (targsram2exresp_int),
    .TARGSRAM2HAUSER      (/*Not supported*/),
    .TARGSRAM2HWUSER      (/*Not supported*/),
    .TARGSRAM2HRUSER      (targsram2hruser_int),
    .TARGSRAM3HSEL        (targsram3hsel),
    .TARGSRAM3HADDR       (targsram3haddr),
    .TARGSRAM3HTRANS      (targsram3htrans),
    .TARGSRAM3HMASTER     (/*Not supported*/),
    .TARGSRAM3HWRITE      (targsram3hwrite),
    .TARGSRAM3HSIZE       (targsram3hsize),
    .TARGSRAM3HMASTLOCK   (/*Not supported*/),
    .TARGSRAM3HWDATA      (targsram3hwdata),
    .TARGSRAM3HBURST      (/*Not supported*/),
    .TARGSRAM3HPROT       (/*Not supported*/),
    .TARGSRAM3MEMATTR     (/*Not supported*/),
    .TARGSRAM3EXREQ       (/*Not supported*/),
    .TARGSRAM3HREADYMUX   (targsram3hreadymux),
    .TARGSRAM3HREADYOUT   (targsram3hreadyout),
    .TARGSRAM3HRDATA      (targsram3hrdata),
    .TARGSRAM3HRESP       (targsram3hresp),
    .TARGSRAM3EXRESP      (targsram3exresp_int),
    .TARGSRAM3HAUSER      (/*Not supported*/),
    .TARGSRAM3HWUSER      (/*Not supported*/),
    .TARGSRAM3HRUSER      (targsram3hruser_int),
    .SCANENABLE           (mtxscanenable_int),
    .SCANINHCLK           (mtxscaninhclk_int),
    .SCANOUTHCLK          (/*Not supported*/),
    .APBTARGEXP0PADDR     (apbtargexp0paddr),
    .APBTARGEXP0PENABLE   (apbtargexp0penable),
    .APBTARGEXP0PWRITE    (apbtargexp0pwrite),
    .APBTARGEXP0PSTRB     (apbtargexp0pstrb),
    .APBTARGEXP0PPROT     (apbtargexp0pprot),
    .APBTARGEXP0PWDATA    (apbtargexp0pwdata),
    .APBTARGEXP0PSEL      (apbtargexp0psel),
    .APBTARGEXP0PRDATA    (apbtargexp0prdata),
    .APBTARGEXP0PREADY    (apbtargexp0pready),
    .APBTARGEXP0PSLVERR   (apbtargexp0pslverr),
    .APBTARGEXP1PADDR     (apbtargexp1paddr),
    .APBTARGEXP1PENABLE   (apbtargexp1penable),
    .APBTARGEXP1PWRITE    (apbtargexp1pwrite),
    .APBTARGEXP1PSTRB     (apbtargexp1pstrb),
    .APBTARGEXP1PPROT     (apbtargexp1pprot),
    .APBTARGEXP1PWDATA    (apbtargexp1pwdata),
    .APBTARGEXP1PSEL      (apbtargexp1psel),
    .APBTARGEXP1PRDATA    (apbtargexp1prdata),
    .APBTARGEXP1PREADY    (apbtargexp1pready),
    .APBTARGEXP1PSLVERR   (apbtargexp1pslverr),
    .APBTARGEXP2PADDR     (APBTARGEXP2PADDR),
    .APBTARGEXP2PENABLE   (APBTARGEXP2PENABLE),
    .APBTARGEXP2PWRITE    (APBTARGEXP2PWRITE),
    .APBTARGEXP2PSTRB     (APBTARGEXP2PSTRB),
    .APBTARGEXP2PPROT     (APBTARGEXP2PPROT),
    .APBTARGEXP2PWDATA    (APBTARGEXP2PWDATA),
    .APBTARGEXP2PSEL      (APBTARGEXP2PSEL),
    .APBTARGEXP2PRDATA    (APBTARGEXP2PRDATA),
    .APBTARGEXP2PREADY    (APBTARGEXP2PREADY),
    .APBTARGEXP2PSLVERR   (APBTARGEXP2PSLVERR),
    .APBTARGEXP3PADDR     (APBTARGEXP3PADDR),
    .APBTARGEXP3PENABLE   (APBTARGEXP3PENABLE),
    .APBTARGEXP3PWRITE    (APBTARGEXP3PWRITE),
    .APBTARGEXP3PSTRB     (APBTARGEXP3PSTRB),
    .APBTARGEXP3PPROT     (APBTARGEXP3PPROT),
    .APBTARGEXP3PWDATA    (APBTARGEXP3PWDATA),
    .APBTARGEXP3PSEL      (APBTARGEXP3PSEL),
    .APBTARGEXP3PRDATA    (APBTARGEXP3PRDATA),
    .APBTARGEXP3PREADY    (APBTARGEXP3PREADY),
    .APBTARGEXP3PSLVERR   (APBTARGEXP3PSLVERR),
    .APBTARGEXP4PADDR     (APBTARGEXP4PADDR),
    .APBTARGEXP4PENABLE   (APBTARGEXP4PENABLE),
    .APBTARGEXP4PWRITE    (APBTARGEXP4PWRITE),
    .APBTARGEXP4PSTRB     (APBTARGEXP4PSTRB),
    .APBTARGEXP4PPROT     (APBTARGEXP4PPROT),
    .APBTARGEXP4PWDATA    (APBTARGEXP4PWDATA),
    .APBTARGEXP4PSEL      (APBTARGEXP4PSEL),
    .APBTARGEXP4PRDATA    (APBTARGEXP4PRDATA),
    .APBTARGEXP4PREADY    (APBTARGEXP4PREADY),
    .APBTARGEXP4PSLVERR   (APBTARGEXP4PSLVERR),
    .APBTARGEXP5PADDR     (APBTARGEXP5PADDR),
    .APBTARGEXP5PENABLE   (APBTARGEXP5PENABLE),
    .APBTARGEXP5PWRITE    (APBTARGEXP5PWRITE),
    .APBTARGEXP5PSTRB     (APBTARGEXP5PSTRB),
    .APBTARGEXP5PPROT     (APBTARGEXP5PPROT),
    .APBTARGEXP5PWDATA    (APBTARGEXP5PWDATA),
    .APBTARGEXP5PSEL      (APBTARGEXP5PSEL),
    .APBTARGEXP5PRDATA    (APBTARGEXP5PRDATA),
    .APBTARGEXP5PREADY    (APBTARGEXP5PREADY),
    .APBTARGEXP5PSLVERR   (APBTARGEXP5PSLVERR),
    .APBTARGEXP6PADDR     (APBTARGEXP6PADDR),
    .APBTARGEXP6PENABLE   (APBTARGEXP6PENABLE),
    .APBTARGEXP6PWRITE    (APBTARGEXP6PWRITE),
    .APBTARGEXP6PSTRB     (APBTARGEXP6PSTRB),
    .APBTARGEXP6PPROT     (APBTARGEXP6PPROT),
    .APBTARGEXP6PWDATA    (APBTARGEXP6PWDATA),
    .APBTARGEXP6PSEL      (APBTARGEXP6PSEL),
    .APBTARGEXP6PRDATA    (APBTARGEXP6PRDATA),
    .APBTARGEXP6PREADY    (APBTARGEXP6PREADY),
    .APBTARGEXP6PSLVERR   (APBTARGEXP6PSLVERR),
    .APBTARGEXP7PADDR     (APBTARGEXP7PADDR),
    .APBTARGEXP7PENABLE   (APBTARGEXP7PENABLE),
    .APBTARGEXP7PWRITE    (APBTARGEXP7PWRITE),
    .APBTARGEXP7PSTRB     (APBTARGEXP7PSTRB),
    .APBTARGEXP7PPROT     (APBTARGEXP7PPROT),
    .APBTARGEXP7PWDATA    (APBTARGEXP7PWDATA),
    .APBTARGEXP7PSEL      (APBTARGEXP7PSEL),
    .APBTARGEXP7PRDATA    (APBTARGEXP7PRDATA),
    .APBTARGEXP7PREADY    (APBTARGEXP7PREADY),
    .APBTARGEXP7PSLVERR   (APBTARGEXP7PSLVERR),
    .APBTARGEXP8PADDR     (APBTARGEXP8PADDR),
    .APBTARGEXP8PENABLE   (APBTARGEXP8PENABLE),
    .APBTARGEXP8PWRITE    (APBTARGEXP8PWRITE),
    .APBTARGEXP8PSTRB     (APBTARGEXP8PSTRB),
    .APBTARGEXP8PPROT     (APBTARGEXP8PPROT),
    .APBTARGEXP8PWDATA    (APBTARGEXP8PWDATA),
    .APBTARGEXP8PSEL      (APBTARGEXP8PSEL),
    .APBTARGEXP8PRDATA    (APBTARGEXP8PRDATA),
    .APBTARGEXP8PREADY    (APBTARGEXP8PREADY),
    .APBTARGEXP8PSLVERR   (APBTARGEXP8PSLVERR),
    .APBTARGEXP9PADDR     (APBTARGEXP9PADDR),
    .APBTARGEXP9PENABLE   (APBTARGEXP9PENABLE),
    .APBTARGEXP9PWRITE    (APBTARGEXP9PWRITE),
    .APBTARGEXP9PSTRB     (APBTARGEXP9PSTRB),
    .APBTARGEXP9PPROT     (APBTARGEXP9PPROT),
    .APBTARGEXP9PWDATA    (APBTARGEXP9PWDATA),
    .APBTARGEXP9PSEL      (APBTARGEXP9PSEL),
    .APBTARGEXP9PRDATA    (APBTARGEXP9PRDATA),
    .APBTARGEXP9PREADY    (APBTARGEXP9PREADY),
    .APBTARGEXP9PSLVERR   (APBTARGEXP9PSLVERR),
    .APBTARGEXP10PADDR    (APBTARGEXP10PADDR),
    .APBTARGEXP10PENABLE  (APBTARGEXP10PENABLE),
    .APBTARGEXP10PWRITE   (APBTARGEXP10PWRITE),
    .APBTARGEXP10PSTRB    (APBTARGEXP10PSTRB),
    .APBTARGEXP10PPROT    (APBTARGEXP10PPROT),
    .APBTARGEXP10PWDATA   (APBTARGEXP10PWDATA),
    .APBTARGEXP10PSEL     (APBTARGEXP10PSEL),
    .APBTARGEXP10PRDATA   (APBTARGEXP10PRDATA),
    .APBTARGEXP10PREADY   (APBTARGEXP10PREADY),
    .APBTARGEXP10PSLVERR  (APBTARGEXP10PSLVERR),
    .APBTARGEXP11PADDR    (APBTARGEXP11PADDR),
    .APBTARGEXP11PENABLE  (APBTARGEXP11PENABLE),
    .APBTARGEXP11PWRITE   (APBTARGEXP11PWRITE),
    .APBTARGEXP11PSTRB    (APBTARGEXP11PSTRB),
    .APBTARGEXP11PPROT    (APBTARGEXP11PPROT),
    .APBTARGEXP11PWDATA   (APBTARGEXP11PWDATA),
    .APBTARGEXP11PSEL     (APBTARGEXP11PSEL),
    .APBTARGEXP11PRDATA   (APBTARGEXP11PRDATA),
    .APBTARGEXP11PREADY   (APBTARGEXP11PREADY),
    .APBTARGEXP11PSLVERR  (APBTARGEXP11PSLVERR),
    .APBTARGEXP12PADDR    (APBTARGEXP12PADDR),
    .APBTARGEXP12PENABLE  (APBTARGEXP12PENABLE),
    .APBTARGEXP12PWRITE   (APBTARGEXP12PWRITE),
    .APBTARGEXP12PSTRB    (APBTARGEXP12PSTRB),
    .APBTARGEXP12PPROT    (APBTARGEXP12PPROT),
    .APBTARGEXP12PWDATA   (APBTARGEXP12PWDATA),
    .APBTARGEXP12PSEL     (APBTARGEXP12PSEL),
    .APBTARGEXP12PRDATA   (APBTARGEXP12PRDATA),
    .APBTARGEXP12PREADY   (APBTARGEXP12PREADY),
    .APBTARGEXP12PSLVERR  (APBTARGEXP12PSLVERR),
    .APBTARGEXP13PADDR    (APBTARGEXP13PADDR),
    .APBTARGEXP13PENABLE  (APBTARGEXP13PENABLE),
    .APBTARGEXP13PWRITE   (APBTARGEXP13PWRITE),
    .APBTARGEXP13PSTRB    (APBTARGEXP13PSTRB),
    .APBTARGEXP13PPROT    (APBTARGEXP13PPROT),
    .APBTARGEXP13PWDATA   (APBTARGEXP13PWDATA),
    .APBTARGEXP13PSEL     (APBTARGEXP13PSEL),
    .APBTARGEXP13PRDATA   (APBTARGEXP13PRDATA),
    .APBTARGEXP13PREADY   (APBTARGEXP13PREADY),
    .APBTARGEXP13PSLVERR  (APBTARGEXP13PSLVERR),
    .APBTARGEXP14PADDR    (APBTARGEXP14PADDR),
    .APBTARGEXP14PENABLE  (APBTARGEXP14PENABLE),
    .APBTARGEXP14PWRITE   (APBTARGEXP14PWRITE),
    .APBTARGEXP14PSTRB    (APBTARGEXP14PSTRB),
    .APBTARGEXP14PPROT    (APBTARGEXP14PPROT),
    .APBTARGEXP14PWDATA   (APBTARGEXP14PWDATA),
    .APBTARGEXP14PSEL     (APBTARGEXP14PSEL),
    .APBTARGEXP14PRDATA   (APBTARGEXP14PRDATA),
    .APBTARGEXP14PREADY   (APBTARGEXP14PREADY),
    .APBTARGEXP14PSLVERR  (APBTARGEXP14PSLVERR),
    .APBTARGEXP15PADDR    (APBTARGEXP15PADDR),
    .APBTARGEXP15PENABLE  (APBTARGEXP15PENABLE),
    .APBTARGEXP15PWRITE   (APBTARGEXP15PWRITE),
    .APBTARGEXP15PSTRB    (APBTARGEXP15PSTRB),
    .APBTARGEXP15PPROT    (APBTARGEXP15PPROT),
    .APBTARGEXP15PWDATA   (APBTARGEXP15PWDATA),
    .APBTARGEXP15PSEL     (APBTARGEXP15PSEL),
    .APBTARGEXP15PRDATA   (APBTARGEXP15PRDATA),
    .APBTARGEXP15PREADY   (APBTARGEXP15PREADY),
    .APBTARGEXP15PSLVERR  (APBTARGEXP15PSLVERR)
  );

  // ------------------------------------------------------------
  // CortexM3 Integration level configurations
  // ------------------------------------------------------------
  wire [239:0] INTISR      = CPU0INTISR;
  // Configuration parameters which are fixed when using the Designstart system
  wire core_dnotitrans_int = 1'b1;        // Must be HIGH is code mux is used
  wire core_bigend         = 1'b0;        // Peripherals in this system do not support BIGEND
  assign CPU0BIGEND        = core_bigend; // FPGA system status

  // WICSENSE not available in CortexM3 DesignStart
  assign CPU0WICSENSE = {(WICSENSE_MAX+1){1'b0}};

  // Designstart simplified integration level with trace
  CORTEXM3INTEGRATIONDS u_CORTEXM3INTEGRATION (
       // Inputs
       .ISOLATEn       (CPU0ISOLATEn),       // Isolate core power domain
       .RETAINn        (CPU0RETAINn),        // Retain core state during power-down

       // Resets
       .PORESETn       (CPU0PORESETn),       // Power on reset - reset processor and debugSynchronous to FCLK and HCLK
       .SYSRESETn      (CPU0SYSRESETn),      // System reset   - reset processor onlySynchronous to FCLK and HCLK
       .RSTBYPASS      (DFTSCANMODE),        // Reset bypass - disable internal generated reset for testing (e.gATPG)
       .CGBYPASS       (DFTCGEN),            // Clock gating bypass - disable internal clock gating for testing.
       .SE             (DFTSE),

       // Clocks
       .FCLK           (CPU0FCLK),           // Free running clock - NVIC, SysTick, debug
       .HCLK           (CPU0HCLK),           // System clock - AHB, processor
                                             // it is separated so that it can be gated off when no debugger is attached
       .TRACECLKIN     (TPIUTRACECLKIN),     // Trace clock input.
       // SysTick
       .STCLK          (CPU0STCLK),          // External reference clock for SysTick (Not really a clock, it is sampled by DFF)
       .STCALIB        (CPU0STCALIB),        // Calibration info for SysTick

       .AUXFAULT       (CPU0AUXFAULT),       // Auxiliary Fault Status Register inputs (1 cycle pulse)

       // Configuration - system
       .BIGEND         (core_bigend),        // Big Endian - select when exiting system reset
       .DNOTITRANS     (core_dnotitrans_int),// I-CODE & D-CODE merging configuration.
                                             // Set to 1 when using cm3_code_mux to merge I-CODE and D-CODE
                                             // This disable I-CODE from generating a transfer when D-CODE bus need a transfer

       //SWJDAP signal for single processor mode
       .nTRST          (nTRST),              // JTAG TAP Reset
       .SWCLKTCK       (SWCLKTCK),           // SW/JTAG Clock
       .SWDITMS        (SWDITMS),            // SW Debug Data In / JTAG Test Mode Select
       .TDI            (TDI),                // JTAG TAP Data In / Alternative input function
       .CDBGPWRUPACK   (CPU0CDBGPWRUPACK),   // Debug Power Domain up acknowledge.

       // IRQs
       .INTISR         (INTISR),             // Interrupts
       .INTNMI         (CPU0INTNMI),         // Non-maskable Interrupt

       // I-CODE Bus
       .HREADYI        (hreadyi),            // I-CODE bus ready
       .HRDATAI        (hrdatai),            // I-CODE bus read data
       .HRESPI         (hrespi),             // I-CODE bus response
       .IFLUSH         (1'b0),               // Recerved input

       // D-CODE Bus
       .HREADYD        (hreadyd),            // D-CODE bus ready
       .HRDATAD        (hrdatad),            // D-CODE bus read data
       .HRESPD         (hrespd),             // D-CODE bus response
       .EXRESPD        (exrespd),            // D-CODE bus exclusive response

       // System Bus
       .HREADYS        (hreadys),            // System bus ready
       .HRDATAS        (hrdatas),            // System bus read data
       .HRESPS         (hresps),             // System bus response
       .EXRESPS        (exresps),            // System bus exclusive response

       // Sleep
       .RXEV           (CPU0RXEV),           // Receive Event input
       .SLEEPHOLDREQn  (CPU0SLEEPHOLDREQn),  // Extend Sleep request

       // External Debug Request
       .EDBGRQ         (CPU0EDBGRQ),         // External Debug Request
       .DBGRESTART     (CPU0DBGRESTART),     // Debug Restart request

       // DAP HMASTER override
       .FIXMASTERTYPE  (CPU0FIXMASTERTYPE),  // Override HMASTER for AHB-AP accesses

       // WIC
       .WICENREQ       (CPU0WICENREQ),       // Enable WIC interface function

       // Timestamp interface
       .TSVALUEB       (CPU0TSVALUEB),       // Binary coded timestamp value for trace
       // Timestamp clock ratio change is rarely used

       // Configuration - debug
       .DBGEN          (CPU0DBGEN),          // Halting Debug Enable
       .NIDEN          (CPU0NIDEN),          // Non-invasive debug enable for ETM
       .MPUDISABLE     (CPU0MPUDISABLE),     // Disable MPU functionality

       // Outputs

       //SWJDAP signal for single processor mode
       .TDO            (TDO),                // JTAG TAP Data Out
       .nTDOEN         (nTDOEN),             // TDO enable
       .CDBGPWRUPREQ   (CPU0CDBGPWRUPREQ),   // Debug Power Domain up request
       .SWDO           (SWDO),               // SW Data Out
       .SWDOEN         (SWDOEN),             // SW Data Out Enable
       .JTAGNSW        (JTAGNSW),            // JTAG/not Serial Wire Mode

       // Single Wire Viewer
       .SWV            (SWV),                // SingleWire Viewer Data

       //TPIU signals for single processor mode
       .TRACECLK       (TRACECLK),           // TRACECLK output
       .TRACEDATA      (TRACEDATA),          // Trace Data

       // CoreSight AHB Trace Macrocell (HTM) bus capture interface
       // Connected here for visibility but usually not used in SoC.
       .HTMDHADDR      (CPU0HTMDHADDR),      // HTM data HADDR
       .HTMDHTRANS     (CPU0HTMDHTRANS),     // HTM data HTRANS
       .HTMDHSIZE      (CPU0HTMDHSIZE),      // HTM data HSIZE
       .HTMDHBURST     (CPU0HTMDHBURST),     // HTM data HBURST
       .HTMDHPROT      (CPU0HTMDHPROT),      // HTM data HPROT
       .HTMDHWDATA     (CPU0HTMDHWDATA),     // HTM data HWDATA
       .HTMDHWRITE     (CPU0HTMDHWRITE),     // HTM data HWRITE
       .HTMDHRDATA     (CPU0HTMDHRDATA),     // HTM data HRDATA
       .HTMDHREADY     (CPU0HTMDHREADY),     // HTM data HREADY
       .HTMDHRESP      (CPU0HTMDHRESP),      // HTM data HRESP

       // AHB I-Code bus
       .HADDRI         (haddri),             // I-CODE bus address
       .HTRANSI        (htransi),            // I-CODE bus transfer type
       .HSIZEI         (hsizei),             // I-CODE bus transfer size
       .HBURSTI        (hbursti),            // I-CODE bus burst length
       .HPROTI         (hproti),             // i-code bus protection
       .MEMATTRI       (memattri),           // I-CODE bus memory attributes

       // AHB D-Code bus
       .HADDRD         (haddrd),             // D-CODE bus address
       .HTRANSD        (htransd),            // D-CODE bus transfer type
       .HSIZED         (hsized),             // D-CODE bus transfer size
       .HWRITED        (hwrited),            // D-CODE bus write not read
       .HBURSTD        (hburstd),            // D-CODE bus burst length
       .HPROTD         (hprotd),             // D-CODE bus protection
       .MEMATTRD       (memattrd),           // D-CODE bus memory attributes
       .HMASTERD       (hmasterd),           // D-CODE bus master
       .HWDATAD        (hwdatad),            // D-CODE bus write data
       .EXREQD         (exreqd),             // D-CODE bus exclusive request

       // AHB System bus
       .HADDRS         (haddrs),             // System bus address
       .HTRANSS        (htranss),            // System bus transfer type
       .HSIZES         (hsizes),             // System bus transfer size
       .HWRITES        (hwrites),            // System bus write not read
       .HBURSTS        (hbursts),            // System bus burst length
       .HPROTS         (hprots),             // System bus protection
       .HMASTLOCKS     (hmastlocks),         // System bus lock
       .MEMATTRS       (memattrs),           // System bus memory attributes
       .HMASTERS       (hmasters),           // System bus master
       .HWDATAS        (hwdatas),            // System bus write data
       .EXREQS         (exreqs),             // System bus exclusive request

       // Status
       .BRCHSTAT       (CPU0BRCHSTAT),       // Branch State
       .HALTED         (CPU0HALTED),         // The processor is halted
       .DBGRESTARTED   (CPU0DBGRESTARTED),   // Debug Restart interface handshaking
       .LOCKUP         (CPU0LOCKUP),         // The processor is locked up
       .SLEEPING       (CPU0SLEEPING),       // The processor is in sleep mdoe (sleep/deep sleep)
       .SLEEPDEEP      (CPU0SLEEPDEEP),      // The processor is in deep sleep mode
       .SLEEPHOLDACKn  (CPU0SLEEPHOLDACKn),  // Acknowledge for SLEEPHOLDREQn
       .ETMINTNUM      (CPU0ETMINTNUM),      // Current exception number
       .ETMINTSTAT     (CPU0ETMINTSTAT),     // Exception/Interrupt activation status
       .CURRPRI        (CPU0CURRPRI),        // Current exception priority
       .TRCENA         (TRCENA),             // Trace Enable

       // Reset Request
       .SYSRESETREQ    (CPU0SYSRESETREQ),    // System Reset Request

       // Events
       .TXEV           (CPU0TXEV),           // Transmit Event

       // Clock gating control
       .GATEHCLK       (CPU0GATEHCLK),       // when high, HCLK can be turned off

       .WAKEUP         (CPU0WAKEUP),         // Wake up request from WIC to PMU
       .WICENACK       (CPU0WICENACK)        // Acknowledge for WICENREQ - WIC operation deep sleep mode
   );


  // ------------------------------------------------------------
  // u_beid_peripheral_f0 - Peripheral package
  // ------------------------------------------------------------

  // Connection

  // Package instantiation
  p_beid_peripheral_f0 u_beid_peripheral_f0(
    .TIMER0PCLK           (TIMER0PCLK),
    .TIMER0PCLKG          (TIMER0PCLKG),
    .TIMER0PRESETn        (TIMER0PRESETn),
    .TIMER0PSEL           (apbtargexp0psel),
    .TIMER0PADDR          (apbtargexp0paddr[11:2]),
    .TIMER0PENABLE        (apbtargexp0penable),
    .TIMER0PWRITE         (apbtargexp0pwrite),
    .TIMER0PWDATA         (apbtargexp0pwdata),
    .TIMER0PPROT          (apbtargexp0pprot),
    .TIMER0PRDATA         (apbtargexp0prdata),
    .TIMER0PREADY         (apbtargexp0pready),
    .TIMER0PSLVERR        (apbtargexp0pslverr),
    .TIMER0EXTIN          (TIMER0EXTIN),
    .TIMER0PRIVMODEN      (TIMER0PRIVMODEN),
    .TIMER0TIMERINT       (TIMER0TIMERINT),
    .TIMER1PCLK           (TIMER1PCLK),
    .TIMER1PCLKG          (TIMER1PCLKG),
    .TIMER1PRESETn        (TIMER1PRESETn),
    .TIMER1PSEL           (apbtargexp1psel),
    .TIMER1PADDR          (apbtargexp1paddr[11:2]),
    .TIMER1PENABLE        (apbtargexp1penable),
    .TIMER1PWRITE         (apbtargexp1pwrite),
    .TIMER1PWDATA         (apbtargexp1pwdata),
    .TIMER1PPROT          (apbtargexp1pprot),
    .TIMER1PRDATA         (apbtargexp1prdata),
    .TIMER1PREADY         (apbtargexp1pready),
    .TIMER1PSLVERR        (apbtargexp1pslverr),
    .TIMER1EXTIN          (TIMER1EXTIN),
    .TIMER1PRIVMODEN      (TIMER1PRIVMODEN),
    .TIMER1TIMERINT       (TIMER1TIMERINT)
  );


  // ------------------------------------------------------------
  // u_e_beid_f0_ahb_to_sram0 - AHB to SRAM bridge
  // ------------------------------------------------------------

  // Connection
  assign targsram0exresp_int = 1'b0;
  assign targsram0hruser_int = 3'b000;

  // module instantiation
  cmsdk_ahb_to_sram #(.AW (15)) u_e_beid_f0_ahb_to_sram0 (
    .HCLK                 (SRAM0HCLK),
    .HRESETn              (MTXHRESETn),
    .HSEL                 (targsram0hsel),
    .HREADY               (targsram0hreadymux),
    .HTRANS               (targsram0htrans),
    .HSIZE                (targsram0hsize),
    .HWRITE               (targsram0hwrite),
    .HADDR                (targsram0haddr[14:0]),
    .HWDATA               (targsram0hwdata),
    .HREADYOUT            (targsram0hreadyout),
    .HRESP                (targsram0hresp),
    .HRDATA               (targsram0hrdata),

    .SRAMRDATA            (SRAM0RDATA),
    .SRAMADDR             (SRAM0ADDR),
    .SRAMWEN              (SRAM0WREN),
    .SRAMWDATA            (SRAM0WDATA),
    .SRAMCS               (SRAM0CS)
  );

  // ------------------------------------------------------------
  // u_e_beid_f0_ahb_to_sram1 - AHB to SRAM bridge
  // ------------------------------------------------------------

  // Connection
  assign targsram1exresp_int = 1'b0;
  assign targsram1hruser_int = 3'b000;

  // module instantiation
  cmsdk_ahb_to_sram #(.AW (15)) u_e_beid_f0_ahb_to_sram1 (
    .HCLK                 (SRAM1HCLK),
    .HRESETn              (MTXHRESETn),
    .HSEL                 (targsram1hsel),
    .HREADY               (targsram1hreadymux),
    .HTRANS               (targsram1htrans),
    .HSIZE                (targsram1hsize),
    .HWRITE               (targsram1hwrite),
    .HADDR                (targsram1haddr[14:0]),
    .HWDATA               (targsram1hwdata),
    .HREADYOUT            (targsram1hreadyout),
    .HRESP                (targsram1hresp),
    .HRDATA               (targsram1hrdata),

    .SRAMRDATA            (SRAM1RDATA),
    .SRAMADDR             (SRAM1ADDR),
    .SRAMWEN              (SRAM1WREN),
    .SRAMWDATA            (SRAM1WDATA),
    .SRAMCS               (SRAM1CS)
  );

  // ------------------------------------------------------------
  // u_e_beid_f0_ahb_to_sram2 - AHB to SRAM bridge
  // ------------------------------------------------------------

  // Connection
  assign targsram2exresp_int = 1'b0;
  assign targsram2hruser_int = 3'b000;

  // module instantiation
  cmsdk_ahb_to_sram #(.AW (15)) u_e_beid_f0_ahb_to_sram2 (
    .HCLK                 (SRAM2HCLK),
    .HRESETn              (MTXHRESETn),
    .HSEL                 (targsram2hsel),
    .HREADY               (targsram2hreadymux),
    .HTRANS               (targsram2htrans),
    .HSIZE                (targsram2hsize),
    .HWRITE               (targsram2hwrite),
    .HADDR                (targsram2haddr[14:0]),
    .HWDATA               (targsram2hwdata),
    .HREADYOUT            (targsram2hreadyout),
    .HRESP                (targsram2hresp),
    .HRDATA               (targsram2hrdata),

    .SRAMRDATA            (SRAM2RDATA),
    .SRAMADDR             (SRAM2ADDR),
    .SRAMWEN              (SRAM2WREN),
    .SRAMWDATA            (SRAM2WDATA),
    .SRAMCS               (SRAM2CS)
  );

  // ------------------------------------------------------------
  // u_e_beid_f0_ahb_to_sram3 - AHB to SRAM bridge
  // ------------------------------------------------------------

  // Connection
  assign targsram3exresp_int = 1'b0;
  assign targsram3hruser_int = 3'b000;

  // module instantiation
  cmsdk_ahb_to_sram #(.AW (15)) u_e_beid_f0_ahb_to_sram3 (
    .HCLK                 (SRAM3HCLK),
    .HRESETn              (MTXHRESETn),
    .HSEL                 (targsram3hsel),
    .HREADY               (targsram3hreadymux),
    .HTRANS               (targsram3htrans),
    .HSIZE                (targsram3hsize),
    .HWRITE               (targsram3hwrite),
    .HADDR                (targsram3haddr[14:0]),
    .HWDATA               (targsram3hwdata),
    .HREADYOUT            (targsram3hreadyout),
    .HRESP                (targsram3hresp),
    .HRDATA               (targsram3hrdata),

    .SRAMRDATA            (SRAM3RDATA),
    .SRAMADDR             (SRAM3ADDR),
    .SRAMWEN              (SRAM3WREN),
    .SRAMWDATA            (SRAM3WDATA),
    .SRAMCS               (SRAM3CS)
  );

  // Resolve unused but necessary wires
  assign unused = |{targsram0haddr[31:15],
                    targsram1haddr[31:15],
                    targsram2haddr[31:15],
                    targsram3haddr[31:15],
                    apbtargexp0paddr[1:0],
                    apbtargexp0pstrb,
                    apbtargexp1paddr[1:0],
                    apbtargexp1pstrb
                    };

endmodule
