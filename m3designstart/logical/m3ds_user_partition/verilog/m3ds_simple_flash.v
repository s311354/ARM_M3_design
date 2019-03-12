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

//-----------------------------------------------------------------------------
// Abstract : User Flash Controller wrapper for DesignStart
//
//-----------------------------------------------------------------------------

module m3ds_simple_flash (

  input  wire                                 hclk,
  input  wire                                 pclk,
  input  wire                                 pclkg,
  input  wire                                 hresetn,

  input  wire                                 hsel_i,                   // targflash0, hselx,
  input  wire [31:0]                          haddr_i,                  // targflash0, haddr,
  input  wire [1:0]                           htrans_i,                 // targflash0, htrans,
  input  wire                                 hwrite_i,                 // targflash0, hwrite,
  input  wire [2:0]                           hsize_i,                  // targflash0, hsize,
  input  wire [2:0]                           hburst_i,                 // targflash0, hburst,
  input  wire [3:0]                           hprot_i,                  // targflash0, hprot,
  input  wire [1:0]                           memattr_i,
  input  wire                                 exreq_i,
  input  wire [3:0]                           hmaster_i,
  input  wire [31:0]                          hwdata_i,                 // targflash0, hwdata,
  input  wire                                 hmastlock_i,              // targflash0, hmastlock,
  input  wire                                 hreadymux_i,              // targflash0, hreadyout,
  input  wire                                 hauser_i,                 // targflash0, hauser,
  input  wire [3:0]                           hwuser_i,                 // targflash0, hwuser,

  output wire [31:0]                          hrdata_o,                 // targflash0, hrdata,
  output wire                                 hreadyout_o,              // targflash0, hready,
  output wire                                 hresp_o,                  // targflash0, hresp,
  output wire                                 exresp_o,
  output wire [2:0]                           hruser_o,                 // targflash0, hruser,

  output wire                                 flash_err_o,              // Flash memory/system error
  output wire                                 flash_int_o,              // EFlash interrupt

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP3, master
  input  wire                                 apbtargexp3psel_i,        // APBTARGEXP3, PSELx,
  input  wire                                 apbtargexp3penable_i,     // APBTARGEXP3, PENABLE,
  input  wire [11:0]                          apbtargexp3paddr_i,       // APBTARGEXP3, PADDR,
  input  wire                                 apbtargexp3pwrite_i,      // APBTARGEXP3, PWRITE,
  input  wire [31:0]                          apbtargexp3pwdata_i,      // APBTARGEXP3, PWDATA,
  output wire [31:0]                          apbtargexp3prdata_o,      // APBTARGEXP3, PRDATA,
  output wire                                 apbtargexp3pready_o,      // APBTARGEXP3, PREADY,
  output wire                                 apbtargexp3pslverr_o,     // APBTARGEXP3, PSLVERR,
  input  wire [3:0]                           apbtargexp3pstrb_i,       // APBTARGEXP3, PSTRB,
  input  wire [2:0]                           apbtargexp3pprot_i,       // APBTARGEXP3, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP9, master
  input  wire                                 apbtargexp9psel_i,        // APBTARGEXP9, PSELx,
  input  wire                                 apbtargexp9penable_i,     // APBTARGEXP9, PENABLE,
  input  wire [11:0]                          apbtargexp9paddr_i,       // APBTARGEXP9, PADDR,
  input  wire                                 apbtargexp9pwrite_i,      // APBTARGEXP9, PWRITE,
  input  wire [31:0]                          apbtargexp9pwdata_i,      // APBTARGEXP9, PWDATA,
  output wire [31:0]                          apbtargexp9prdata_o,      // APBTARGEXP9, PRDATA,
  output wire                                 apbtargexp9pready_o,      // APBTARGEXP9, PREADY,
  output wire                                 apbtargexp9pslverr_o,     // APBTARGEXP9, PSLVERR,
  input  wire [3:0]                           apbtargexp9pstrb_i,       // APBTARGEXP9, PSTRB,
  input  wire [2:0]                           apbtargexp9pprot_i,       // APBTARGEXP9, PPROT,

  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP10, master
  input  wire                                 apbtargexp10psel_i,       // APBTARGEXP10, PSELx,
  input  wire                                 apbtargexp10penable_i,    // APBTARGEXP10, PENABLE,
  input  wire [11:0]                          apbtargexp10paddr_i,      // APBTARGEXP10, PADDR,
  input  wire                                 apbtargexp10pwrite_i,     // APBTARGEXP10, PWRITE,
  input  wire [31:0]                          apbtargexp10pwdata_i,     // APBTARGEXP10, PWDATA,
  output wire [31:0]                          apbtargexp10prdata_o,     // APBTARGEXP10, PRDATA,
  output wire                                 apbtargexp10pready_o,     // APBTARGEXP10, PREADY,
  output wire                                 apbtargexp10pslverr_o,    // APBTARGEXP10, PSLVERR,
  input  wire [3:0]                           apbtargexp10pstrb_i,      // APBTARGEXP10, PSTRB,
  input  wire [2:0]                           apbtargexp10pprot_i       // APBTARGEXP10, PPROT,
  );

  // --------------------------------------------------------------------
  // For FPGA, the flash region is implemented using SRAM.
  // --------------------------------------------------------------------

  // Block is 128 bits wide, but uses HSIZE to correctly allocate byte lanes.
  // Read is full width, need to decode external to module
  reg  [1:0]   targflash0haddr_3_2_q;
  reg  [31:0]  targflash0hrdata;
  wire [127:0] targflash0hrdata_128;


    ahb_blockram_128
    #(.ADDRESSWIDTH(18)) // 256KB
    u_ahb_blockram_128
    (
    //Inputs
    .HCLK                 (hclk),
    .HRESETn              (hresetn),
    .HSELBRAM             (hsel_i),
    .HREADY               (hreadymux_i),
    .HTRANS               (htrans_i),
    .HSIZE                (hsize_i),
    .HWRITE               (hwrite_i),
    .HADDR                (haddr_i[17:0]),
    .HWDATA               ({4{hwdata_i}}),
    //Outputs
    .HREADYOUT            (hreadyout_o),
    .HRESP                (hresp_o),
    .HRDATA               (targflash0hrdata_128)
    );

  assign exresp_o = 1'b0;
  assign hruser_o = 3'b000;

  // Data is output from RAMs using registered address
  // Need registered address to then select which 32 bit slice from 128 bit output.
  always @(posedge hclk)
      targflash0haddr_3_2_q <= haddr_i[3:2];

  always @(targflash0hrdata_128 or targflash0haddr_3_2_q)
      case (targflash0haddr_3_2_q)
          2'b00   : targflash0hrdata = targflash0hrdata_128[31:0];
          2'b01   : targflash0hrdata = targflash0hrdata_128[63:32];
          2'b10   : targflash0hrdata = targflash0hrdata_128[95:64];
          2'b11   : targflash0hrdata = targflash0hrdata_128[127:96];
          default : targflash0hrdata = {32{1'bx}};
      endcase

  assign hrdata_o = targflash0hrdata;

  assign flash_err_o = 1'b0;      //reserved flash memory/system error
  assign flash_int_o = 1'b0;      //Reserved EFlash interrupt

  // --------------------------------------------------------------------
  // User APB Ports for flash controller and cache if needed
  // --------------------------------------------------------------------
// APB Master ports reserved for memory subsystem control
// Tie-off reserved APB master port 3 to OK response
  assign apbtargexp3prdata_o  = {32{1'b0}};
  assign apbtargexp3pready_o  = 1'b1;
  assign apbtargexp3pslverr_o = 1'b0;
// tie-off reserved apb master port 9 to ok response
  assign apbtargexp9prdata_o  = {32{1'b0}};
  assign apbtargexp9pready_o  = 1'b1;
  assign apbtargexp9pslverr_o = 1'b0;
// tie-off reserved apb master port 10 to ok response
  assign apbtargexp10prdata_o  = {32{1'b0}};
  assign apbtargexp10pready_o  = 1'b1;
  assign apbtargexp10pslverr_o = 1'b0;

  // Signals intentionally unused in the example
  wire unused = pclk                    | pclkg                   |
                (|hprot_i)              |(|haddr_i[31:18])        |
                (|memattr_i)            |
                exreq_i                 | (|hmaster_i)            |
                hmastlock_i             | hauser_i                |
                (|hwuser_i)             | (|hburst_i)             |
                apbtargexp3psel_i       | apbtargexp3penable_i    |
                (|apbtargexp3paddr_i)   | apbtargexp3pwrite_i     |
                (|apbtargexp3pwdata_i)  | (|apbtargexp3pstrb_i)   |
                (|apbtargexp3pprot_i)   |
                apbtargexp9psel_i       | apbtargexp9penable_i    |
                (|apbtargexp9paddr_i)   | apbtargexp9pwrite_i     |
                (|apbtargexp9pwdata_i)  | (|apbtargexp9pstrb_i)   |
                (|apbtargexp9pprot_i)   |
                apbtargexp10psel_i      | apbtargexp10penable_i   |
                (|apbtargexp10paddr_i)  | apbtargexp10pwrite_i    |
                (|apbtargexp10pwdata_i) | (|apbtargexp10pstrb_i)  |
                (|apbtargexp10pprot_i);

endmodule
