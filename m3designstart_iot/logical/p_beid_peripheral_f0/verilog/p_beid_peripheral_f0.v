//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//        (C) COPYRIGHT 2015 ARM Limited or its affiliates.
//            ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
//      SVN Information
//
//      Checked In          :  2015-09-17 13:43:40 +0100 (Thu, 17 Sep 2015)
//
//      Revision            :  2354
//
//      Release Information : CM3DesignStart-r0p0-02rel0
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : p_beid_peripheral_f0 top file
//-----------------------------------------------------------------------------


module p_beid_peripheral_f0
  (
    TIMER0PCLK, TIMER0PCLKG, TIMER0PRESETn, TIMER0PSEL, TIMER0PADDR, TIMER0PENABLE, TIMER0PWRITE,
    TIMER0PWDATA, TIMER0PPROT, TIMER0PRDATA, TIMER0PREADY, TIMER0PSLVERR, TIMER0EXTIN, TIMER0PRIVMODEN, TIMER0TIMERINT, TIMER1PCLK,
    TIMER1PCLKG, TIMER1PRESETn, TIMER1PSEL, TIMER1PADDR, TIMER1PENABLE, TIMER1PWRITE, TIMER1PWDATA, TIMER1PPROT,
    TIMER1PRDATA, TIMER1PREADY, TIMER1PSLVERR, TIMER1EXTIN, TIMER1PRIVMODEN, TIMER1TIMERINT
  );

  // ----------------------------------------------------------------------------
  // Port declarations
  // ----------------------------------------------------------------------------
  // TIMER0
  input          TIMER0PCLK;     // PCLK for timer operation
  input          TIMER0PCLKG;    // PCLK for timer operation
  input          TIMER0PRESETn;  // PCLK for timer operation

  input          TIMER0PSEL;     // Device select
  input   [11:2] TIMER0PADDR;    // Address
  input          TIMER0PENABLE;  // Transfer control
  input          TIMER0PWRITE;   // Write control
  input   [31:0] TIMER0PWDATA;   // Write data
  input   [2:0]  TIMER0PPROT;    // Protection type. Only PPROT[0] is used 0 indicates NORMAL access and 1 indicates PRIVILEGED

  output  [31:0] TIMER0PRDATA;   // Read data
  output         TIMER0PREADY;   // Device ready
  output         TIMER0PSLVERR;  // Device error response

  input          TIMER0EXTIN;    // Extenal input
  input          TIMER0PRIVMODEN;// Control whether timer0 regs can be written in NON-PRIV mode or not
  output         TIMER0TIMERINT; // Timer interrupt output

  // TIMER1
  input          TIMER1PCLK;     // PCLK for timer operation
  input          TIMER1PCLKG;    // PCLK for timer operation
  input          TIMER1PRESETn;  // PCLK for timer operation

  input          TIMER1PSEL;     // Device select
  input   [11:2] TIMER1PADDR;    // Address
  input          TIMER1PENABLE;  // Transfer control
  input          TIMER1PWRITE;   // Write control
  input   [31:0] TIMER1PWDATA;   // Write data
  input   [2:0]  TIMER1PPROT;    // Protection type. Only PPROT[0] is used 0 indicates NORMAL access and 1 indicates PRIVILEGED

  output  [31:0] TIMER1PRDATA;   // Read data
  output         TIMER1PREADY;   // Device ready
  output         TIMER1PSLVERR;  // Device error response

  input          TIMER1EXTIN;    // Extenal input
  input          TIMER1PRIVMODEN;// Control whether timer0 regs can be written in NON-PRIV mode or not
  output         TIMER1TIMERINT; // Timer interrupt output

  // ----------------------------------------------------------------------------
  // Port wire/reg declarsations
  // ----------------------------------------------------------------------------
  //Timer0
  wire           TIMER0PCLK;     // PCLK for timer operation
  wire           TIMER0PCLKG;    // PCLK for timer operation
  wire           TIMER0PRESETn;  // PCLK for timer operation

  wire           TIMER0PSEL;     // Device select
  wire    [11:2] TIMER0PADDR;    // Address
  wire           TIMER0PENABLE;  // Transfer control
  wire           TIMER0PWRITE;   // Write control
  wire    [31:0] TIMER0PWDATA;   // Write data
  wire    [2:0]  TIMER0PPROT;    // Protection type. Only PPROT[0] is used 0 indicates NORMAL access and 1 indicates PRIVILEGED

  wire    [31:0] TIMER0PRDATA;   // Read data
  wire           TIMER0PREADY;   // Device ready
  wire           TIMER0PSLVERR;  // Device error response

  wire           TIMER0EXTIN;    // Extenal input
  wire           TIMER0PRIVMODEN;// Control whether timer0 regs can be written in NON-PRIV mode or not
  wire           TIMER0TIMERINT; // Timer interrupt wire

  // TIMER1
  wire           TIMER1PCLK;     // PCLK for timer operation
  wire           TIMER1PCLKG;    // PCLK for timer operation
  wire           TIMER1PRESETn;  // PCLK for timer operation

  wire           TIMER1PSEL;     // Device select
  wire    [11:2] TIMER1PADDR;    // Address
  wire           TIMER1PENABLE;  // Transfer control
  wire           TIMER1PWRITE;   // Write control
  wire    [31:0] TIMER1PWDATA;   // Write data
  wire    [2:0]  TIMER1PPROT;    // Protection type. Only PPROT[0] is used 0 indicates NORMAL access and 1 indicates PRIVILEGED

  wire    [31:0] TIMER1PRDATA;   // Read data
  wire           TIMER1PREADY;   // Device ready
  wire           TIMER1PSLVERR;  // Device error response

  wire           TIMER1EXTIN;    // Extenal input
  wire           TIMER1PRIVMODEN;// Control whether timer0 regs can be written in NON-PRIV mode or not
  wire           TIMER1TIMERINT; // Timer interrupt wire

  //------------------------------------------------
  // Internal wires
  //------------------------------------------------
  wire     [3:0] timer0ecorevnum_static_o; // Engineering-change-order revision bits for Timer0
  wire     [3:0] timer1ecorevnum_static_o; // Engineering-change-order revision bits for Timer1

  // ------------------------------------------------------------
  // ECOREVNUM static regs
  // ------------------------------------------------------------
  //   -- Timer0
  p_beid_peripheral_f0_static_reg #(4) u_p_beid_peripheral_f0_static_reg0(
    .clk        (TIMER0PCLKG),
    .reset_n    (TIMER0PRESETn),
    .static_i   (4'b0),
    .static_o   (timer0ecorevnum_static_o)
  );

  //   -- Timer1
  p_beid_peripheral_f0_static_reg #(4) u_p_beid_peripheral_f0_static_reg1(
    .clk        (TIMER1PCLKG),
    .reset_n    (TIMER1PRESETn),
    .static_i   (4'b0),
    .static_o   (timer1ecorevnum_static_o)
  );


  // ------------------------------------------------------------
  // Timer instances
  // ------------------------------------------------------------
  // Timer0
  p_beid_peripheral_f0_timer u_p_beid_peripheral_f0_timer0(
    .PCLK       (TIMER0PCLK),
    .PCLKG      (TIMER0PCLKG),
    .PRESETn    (TIMER0PRESETn),

    .PSEL       (TIMER0PSEL),
    .PADDR      (TIMER0PADDR),
    .PENABLE    (TIMER0PENABLE),
    .PWRITE     (TIMER0PWRITE),
    .PWDATA     (TIMER0PWDATA),
    .PPROT      (TIMER0PPROT),

    .ECOREVNUM  (timer0ecorevnum_static_o),

    .PRDATA     (TIMER0PRDATA),
    .PREADY     (TIMER0PREADY),
    .PSLVERR    (TIMER0PSLVERR),
    .EXTIN      (TIMER0EXTIN),
    .PRIVMODEN  (TIMER0PRIVMODEN),
    .TIMERINT   (TIMER0TIMERINT)
  );

  // Timer1
  p_beid_peripheral_f0_timer u_p_beid_peripheral_f0_timer1(
    .PCLK       (TIMER1PCLK),
    .PCLKG      (TIMER1PCLKG),
    .PRESETn    (TIMER1PRESETn),

    .PSEL       (TIMER1PSEL),
    .PADDR      (TIMER1PADDR),
    .PENABLE    (TIMER1PENABLE),
    .PWRITE     (TIMER1PWRITE),
    .PWDATA     (TIMER1PWDATA),
    .PPROT      (TIMER1PPROT),

    .ECOREVNUM  (timer1ecorevnum_static_o),

    .PRDATA     (TIMER1PRDATA),
    .PREADY     (TIMER1PREADY),
    .PSLVERR    (TIMER1PSLVERR),

    .EXTIN      (TIMER1EXTIN),
    .PRIVMODEN  (TIMER1PRIVMODEN),
    .TIMERINT   (TIMER1TIMERINT)
  );

endmodule
