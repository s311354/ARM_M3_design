// -----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//               (C) COPYRIGHT 2015,2017 ARM Limited.
//                   ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
// SVN Information
//
// Checked In : $Date: 2015-07-10 09:16:18 +0100 (Fri, 10 Jul 2015) $
// Revision : $Revision: 365823 $
//
// Release Information : CM3DesignStart-r0p0-02rel0
//
// -----------------------------------------------------------------------------
// Verilog-2001 (IEEE Std 1364-2001)
// -----------------------------------------------------------------------------
// Purpose : beetle peripherals integration controlled by AHB and/or APB
//
// -----------------------------------------------------------------------------


module beetle_peripherals_fpga
(
  //-----------------------------
  //Resets
  input  wire         AHBRESETn,            //AHB domain reset for slave_mux and default_slave
  input  wire         DTIMERPRESETn,        //APB domain + System (functional) clock domain (global reset)
  input  wire         UART0PRESETn,         //APB domain = System (functional) clock
  input  wire         UART1PRESETn,         //APB domain = System (functional) clock
  input  wire         RTCPRESETn,           //APB domain
  input  wire         RTCnRTCRST,           //RTC1HZ_CLK domain
  input  wire         RTCnPOR,              //RTC power on reset
  input  wire         WDOGPRESETn,          //APB domain of WDOG
  input  wire         WDOGRESn,             //WDOG_CLK domain
  input  wire         TRNGPRESETn,          //APB domain = System (functional) clock
  input  wire         GPIO0HRESETn,         //AHB domain + System (functional) clock domain (global reset)
  input  wire         GPIO1HRESETn,         //AHB domain + System (functional) clock domain (global reset)
  input  wire         GPIO2HRESETn,         //AHB domain + System (functional) clock domain (global reset)
  input  wire         GPIO3HRESETn,         //AHB domain + System (functional) clock domain (global reset)

  //-----------------------------
  //Clocks
  input  wire         AHB_CLK,              // HCLK from top
  input  wire         APB_CLK,              // PCLKG from top
  input  wire         DTIMER_CLK,
  input  wire         UART0_CLK,
  input  wire         UART1_CLK,
  input  wire         RTC_CLK,              // System Clock (Functional + APB IF)
  input  wire         RTC1HZ_CLK,
  input  wire         WDOG_CLK,
  input  wire         TRNG_CLK,             // System Clock (Functional + APB IF)
  input  wire         GPIO0_FCLK,           // System Clock (Functional IF)
  input  wire         GPIO1_FCLK,           // System Clock (Functional IF)
  input  wire         GPIO2_FCLK,           // System Clock (Functional IF)
  input  wire         GPIO3_FCLK,           // System Clock (Functional IF)
  input  wire         GPIO0_HCLK,           // System Clock (APB IF)
  input  wire         GPIO1_HCLK,           // System Clock (APB IF)
  input  wire         GPIO2_HCLK,           // System Clock (APB IF)
  input  wire         GPIO3_HCLK,           // System Clock (APB IF)

  //-----------------------------
  //AHB interface
  //AHB Master Slave
  input  wire         PERIPHHSEL_i,         //AHB peripheral select
  input  wire         PERIPHHREADYIN_i,     //AHB ready input
  input  wire [1:0]   PERIPHHTRANS_i,       //AHB transfer type
  input  wire [2:0]   PERIPHHSIZE_i,        //AHB hsize
  input  wire         PERIPHHWRITE_i,       //AHB hwrite
  input  wire [31:0]  PERIPHHADDR_i,        //AHB address bus
  input  wire [31:0]  PERIPHHWDATA_i,       //AHB write data bus

  input  wire         PERIPHHPROT_i,

  output wire         PERIPHHREADYMUXOUT_o, //AHB ready output from S->M mux
  output wire         PERIPHHRESP_o,        //AHB response output from S->M mux
  output wire [31:0]  PERIPHHRDATA_o,       //AHB read data from S->M mux

  input  wire [31:0]  AHBPER0_REG,          // Access permission for GPIOs
  input  wire [31:0]  APBPER0_REG,          // Access permission for APB peripherals
  //-----------------------------
  //SysCtrl AHB slaveMux control
  output wire         SYSCTRLHSEL_o,
  input  wire         SYSCTRLHREADYOUT_i,
  input  wire [31:0]  SYSCTRLHRDATA_i,
  input  wire         SYSCTRLHRESP_i,

  //-----------------------------
  //APB interfaces
  //D(ual)Timer
  input  wire         DTIMERPSEL_i,         //APBTARGEXP2PSEL
  input  wire         DTIMERPENABLE_i,      //APBTARGEXP2PENABLE
  input  wire [31:0]  DTIMERPADDR_i,        //APBTARGEXP2PADDR
  input  wire         DTIMERPWRITE_i,       //APBTARGEXP2PWRITE
  input  wire [31:0]  DTIMERPWDATA_i,       //APBTARGEXP2PWDATA
  input  wire [3:0]   DTIMERPSTRB_i,        //APBTARGEXP2PSTRB
  input  wire         DTIMERPPROT_i,        //APBTARGEXP2PPROT
  output wire [31:0]  DTIMERPRDATA_o,       //APBTARGEXP2PRDATA
  output wire         DTIMERPREADY_o,       //APBTARGEXP2PREADY
  output wire         DTIMERPSLVERR_o,      //APBTARGEXP2PSLVERR

  //UART0
  input  wire         UART0PSEL_i,          //APBTARGEXP4PSEL
  input  wire         UART0PENABLE_i,       //APBTARGEXP4PENABLE
  input  wire [31:0]  UART0PADDR_i,         //APBTARGEXP4PADDR
  input  wire         UART0PWRITE_i,        //APBTARGEXP4PWRITE
  input  wire [31:0]  UART0PWDATA_i,        //APBTARGEXP4PWDATA
  input  wire [3:0]   UART0PSTRB_i,         //APBTARGEXP4PSTRB
  input  wire         UART0PPROT_i,         //APBTARGEXP4PPROT
  output wire [31:0]  UART0PRDATA_o,        //APBTARGEXP4PRDATA
  output wire         UART0PREADY_o,        //APBTARGEXP4PREADY
  output wire         UART0PSLVERR_o,       //APBTARGEXP4PSLVERR

  //UART1
  input  wire         UART1PSEL_i,          //APBTARGEXP5PSEL
  input  wire         UART1PENABLE_i,       //APBTARGEXP5PENABLE
  input  wire [31:0]  UART1PADDR_i,         //APBTARGEXP5PADDR
  input  wire         UART1PWRITE_i,        //APBTARGEXP5PWRITE
  input  wire [31:0]  UART1PWDATA_i,        //APBTARGEXP5PWDATA
  input  wire [3:0]   UART1PSTRB_i,         //APBTARGEXP5PSTRB
  input  wire         UART1PPROT_i,         //APBTARGEXP5PPROT
  output wire [31:0]  UART1PRDATA_o,        //APBTARGEXP5PRDATA
  output wire         UART1PREADY_o,        //APBTARGEXP5PREADY
  output wire         UART1PSLVERR_o,       //APBTARGEXP5PSLVERR

  //RTC
  input  wire         RTCPSEL_i,            //APBTARGEXP6PSEL
  input  wire         RTCPENABLE_i,         //APBTARGEXP6PENABLE
  input  wire [31:0]  RTCPADDR_i,           //APBTARGEXP6PADDR
  input  wire         RTCPWRITE_i,          //APBTARGEXP6PWRITE
  input  wire [31:0]  RTCPWDATA_i,          //APBTARGEXP6PWDATA
  input  wire [3:0]   RTCPSTRB_i,           //APBTARGEXP6PSTRB
  input  wire         RTCPPROT_i,           //APBTARGEXP6PPROT
  output wire [31:0]  RTCPRDATA_o,          //APBTARGEXP6PRDATA
  output wire         RTCPREADY_o,          //APBTARGEXP6PREADY
  output wire         RTCPSLVERR_o,         //APBTARGEXP6PSLVERR

  //W(atch)DOG
  input  wire         WDOGPSEL_i,           //APBTARGEXP8PSEL
  input  wire         WDOGPENABLE_i,        //APBTARGEXP8PENABLE
  input  wire [31:0]  WDOGPADDR_i,          //APBTARGEXP8PADDR
  input  wire         WDOGPWRITE_i,         //APBTARGEXP8PWRITE
  input  wire [31:0]  WDOGPWDATA_i,         //APBTARGEXP8PWDATA
  input  wire [3:0]   WDOGPSTRB_i,          //APBTARGEXP8PSTRB
  input  wire         WDOGPPROT_i,          //APBTARGEXP8PPROT
  output wire [31:0]  WDOGPRDATA_o,         //APBTARGEXP8PRDATA
  output wire         WDOGPREADY_o,         //APBTARGEXP8PREADY
  output wire         WDOGPSLVERR_o,        //APBTARGEXP8PSLVERR

  //TRNG
  input  wire         TRNGPSEL_i,           //APBTARGEXP15PSEL
  input  wire         TRNGPENABLE_i,        //APBTARGEXP15PENABLE
  input  wire [31:0]  TRNGPADDR_i,          //APBTARGEXP15PADDR
  input  wire         TRNGPWRITE_i,         //APBTARGEXP15PWRITE
  input  wire [31:0]  TRNGPWDATA_i,         //APBTARGEXP15PWDATA
  input  wire [3:0]   TRNGPSTRB_i,          //APBTARGEXP15PSTRB
  input  wire         TRNGPPROT_i,          //APBTARGEXP15PPROT
  output wire [31:0]  TRNGPRDATA_o,         //APBTARGEXP15PRDATA
  output wire         TRNGPREADY_o,         //APBTARGEXP15PREADY
  output wire         TRNGPSLVERR_o,        //APBTARGEXP15PSLVERR

  //-----------------------------
  //Other/Functional peripheral module specific interfaces
  //-----------------------------
  //D(ual)TIMER
  input  wire [3:0]   DTIMERECOREVNUM_i,    // ECO revision number
  input  wire         DTIMERTIMCLKEN1_i,    // Timer clock enable 1
  input  wire         DTIMERTIMCLKEN2_i,    // Timer clock enable 2
  output wire         DTIMERTIMINT1_o,      // Counter 1 interrupt
  output wire         DTIMERTIMINT2_o,      // Counter 2 interrupt
  output wire         DTIMERTIMINTC_o,      // Counter combined interrupt

  //-----------------------------
  //UART0
  input  wire [3:0]   UART0ECOREVNUM_i,     // Engineering-change-order revision bits
  input  wire         UART0RXD_i,           // Serial input
  output wire         UART0TXD_o,           // Transmit data output
  output wire         UART0TXEN_o,          // Transmit enabled
  output wire         UART0BAUDTICK_o,      // Baud rate (x16) Tick
  output wire         UART0TXINT_o,         // Transmit Interrupt
  output wire         UART0RXINT_o,         // Receive Interrupt
  output wire         UART0TXOVRINT_o,      // Transmit overrun Interrupt
  output wire         UART0RXOVRINT_o,      // Receive overrun Interrupt
  output wire         UART0UARTINT_o,       // Combined interrupt

  //-----------------------------
  //UART1
  input  wire [3:0]   UART1ECOREVNUM_i,     // Engineering-change-order revision bits
  input  wire         UART1RXD_i,           // Serial input
  output wire         UART1TXD_o,           // Transmit data output
  output wire         UART1TXEN_o,          // Transmit enabled
  output wire         UART1BAUDTICK_o,      // Baud rate (x16) Tick
  output wire         UART1TXINT_o,         // Transmit Interrupt
  output wire         UART1RXINT_o,         // Receive Interrupt
  output wire         UART1TXOVRINT_o,      // Transmit overrun Interrupt
  output wire         UART1RXOVRINT_o,      // Receive overrun Interrupt
  output wire         UART1UARTINT_o,       // Combined interrupt

  //-----------------------------
  //RTC
  input  wire         RTCSCANENABLE_i,      // Test mode enable
  input  wire         RTCSCANINPCLK_i,      // PCLK Scan chain input
  input  wire         RTCSCANINCLK1HZ_i,    // CLK1HZ Scan chain input
  output wire         RTCSCANOUTPCLK_o,     // PCLK Scan chain output
  output wire         RTCSCANOUTCLK1HZ_o,   // CLK1HZ Scan chain output
  output wire         RTCRTCINTR_o,         // RTC interrupt

  //-----------------------------
  //W(atch)DOG
  input  wire [3:0]   WDOGECOREVNUM_i,      // ECO revision number
  input  wire         WDOGCLKEN_i,          // Watchdog clock enable
  output wire         WDOGINT_o,            // Watchdog interrupt
  output wire         WDOGRES_o,            // Watchdog timeout reset

  //-----------------------------
  //TRNG
  input  wire         TRNGSCANMODE_i,
  output wire         TRNGINT_o,

  //-----------------------------
  //GPIO0
  input  wire [3:0]   GPIO0ECOREVNUM_i,     // Engineering-change-order revision bits
  input  wire [15:0]  GPIO0PORTIN_i,        // GPIO Interface input
  output wire [15:0]  GPIO0PORTOUT_o,       // GPIO output
  output wire [15:0]  GPIO0PORTEN_o,        // GPIO output enable
  output wire [15:0]  GPIO0PORTFUNC_o,      // Alternate function control
  output wire [15:0]  GPIO0GPIOINT_o,       // Interrupt output for each pin
  output wire         GPIO0COMBINT_o,       // Combined interrupt

  //-----------------------------
  //GPIO1
  input  wire [3:0]   GPIO1ECOREVNUM_i,     // Engineering-change-order revision bits
  input  wire [15:0]  GPIO1PORTIN_i,        // GPIO Interface input
  output wire [15:0]  GPIO1PORTOUT_o,       // GPIO output
  output wire [15:0]  GPIO1PORTEN_o,        // GPIO output enable
  output wire [15:0]  GPIO1PORTFUNC_o,      // Alternate function control
  output wire [15:0]  GPIO1GPIOINT_o,       // Interrupt output for each pin
  output wire         GPIO1COMBINT_o,       // Combined interrupt

  //-----------------------------
  //GPIO2
  input  wire [3:0]   GPIO2ECOREVNUM_i,     // Engineering-change-order revision bits
  input  wire [15:0]  GPIO2PORTIN_i,        // GPIO Interface input
  output wire [15:0]  GPIO2PORTOUT_o,       // GPIO output
  output wire [15:0]  GPIO2PORTEN_o,        // GPIO output enable
  output wire [15:0]  GPIO2PORTFUNC_o,      // Alternate function control
  output wire [15:0]  GPIO2GPIOINT_o,       // Interrupt output for each pin
  output wire         GPIO2COMBINT_o,       // Combined interrupt

  //-----------------------------
  //GPIO3
  input  wire [3:0]   GPIO3ECOREVNUM_i,     // Engineering-change-order revision bits
  input  wire [15:0]  GPIO3PORTIN_i,        // GPIO Interface input
  output wire [15:0]  GPIO3PORTOUT_o,       // GPIO output
  output wire [15:0]  GPIO3PORTEN_o,        // GPIO output enable
  output wire [15:0]  GPIO3PORTFUNC_o,      // Alternate function control
  output wire [15:0]  GPIO3GPIOINT_o,       // Interrupt output for each pin
  output wire         GPIO3COMBINT_o        // Combined interrupt

);


//-----------------------------
//Local parameters
//-----------------------------
  localparam AHB_PORT0_ENABLE = 1;  //default slave
  localparam AHB_PORT1_ENABLE = 1;  //Reserved for alternate QSPI boot connection
  localparam AHB_PORT2_ENABLE = 1;  //GPIO0
  localparam AHB_PORT3_ENABLE = 1;  //GPIO1
  localparam AHB_PORT4_ENABLE = 1;  //GPIO2
  localparam AHB_PORT5_ENABLE = 1;  //GPIO3
  localparam AHB_PORT6_ENABLE = 1;  //SysCtrl
  localparam AHB_PORT7_ENABLE = 0;  //unused
  localparam AHB_PORT8_ENABLE = 0;  //unused
  localparam AHB_PORT9_ENABLE = 0;  //unused
  localparam AHB_DATA_WIDTH = 32;   //DATA width


  wire defslave_HSEL;
  wire defslave_HREADYOUT;
  wire defslave_HRESP;
  wire [31:0] defslave_HRDATA={32{1'b0}};

  // Reserved for alternate boot configuration
  wire QSPI_HSEL;
  wire QSPI_HREADYOUT;
  wire QSPI_HRESP;
  wire [31:0] QSPI_HRDATA;


  wire GPIO0_HSEL;
  wire GPIO0_HREADYOUT;
  wire GPIO0_HRESP;
  wire [31:0] GPIO0_HRDATA;

  wire GPIO1_HSEL;
  wire GPIO1_HREADYOUT;
  wire GPIO1_HRESP;
  wire [31:0] GPIO1_HRDATA;

  wire GPIO2_HSEL;
  wire GPIO2_HREADYOUT;
  wire GPIO2_HRESP;
  wire [31:0] GPIO2_HRDATA;

  wire GPIO3_HSEL;
  wire GPIO3_HREADYOUT;
  wire GPIO3_HRESP;
  wire [31:0] GPIO3_HRDATA;

  //-------------------------------
  //AHB Decoder, Mux, default slave
  //-------------------------------
  m3ds_ahb_decoder u_beetle_ahb_decoder (
    .HSEL_i(PERIPHHSEL_i),
    .decode_address_i(PERIPHHADDR_i[31:10]),  //lower 10 bits are not compared
    .PERIPHHPROT_i(PERIPHHPROT_i),
    .periph_sysprot_i({1'b0,AHBPER0_REG[3:0],1'b0}),  //SysCtrl,GPIO3-GPIO0,unused
    .HSEL0_o(defslave_HSEL),
    .HSEL2_o(GPIO0_HSEL),
    .HSEL3_o(GPIO1_HSEL),
    .HSEL4_o(GPIO2_HSEL),
    .HSEL5_o(GPIO3_HSEL),
    .HSEL6_o(SYSCTRLHSEL_o)
  );

  cmsdk_ahb_slave_mux
  #(
    .PORT0_ENABLE(AHB_PORT0_ENABLE),  //default slave
    .PORT1_ENABLE(AHB_PORT1_ENABLE),  //reserved for alternate boot using QSPI
    .PORT2_ENABLE(AHB_PORT2_ENABLE),  //GPIO0
    .PORT3_ENABLE(AHB_PORT3_ENABLE),  //GPIO1
    .PORT4_ENABLE(AHB_PORT4_ENABLE),  //GPIO2
    .PORT5_ENABLE(AHB_PORT5_ENABLE),  //GPIO3
    .PORT6_ENABLE(AHB_PORT6_ENABLE),  //SYSCTRL
    .PORT7_ENABLE(AHB_PORT7_ENABLE),  //unused
    .PORT8_ENABLE(AHB_PORT8_ENABLE),  //unused
    .PORT9_ENABLE(AHB_PORT9_ENABLE),  //unused
    .DW(AHB_DATA_WIDTH)               //32bits
  ) u_cmsdk_ahb_slave_mux (
    .HCLK(AHB_CLK),                   // Top Clock
    .HRESETn(AHBRESETn),              // Top Reset
    .HREADY(PERIPHHREADYIN_i),        // Top Bus ready
    .HSEL0(defslave_HSEL),            // HSEL for AHB Slave #0 -> Default slave
    .HREADYOUT0(defslave_HREADYOUT),  // HREADY for Slave connection #0
    .HRESP0(defslave_HRESP),          // HRESP  for slave connection #0
    .HRDATA0(defslave_HRDATA),        // HRDATA for slave connection #0
    .HSEL1(QSPI_HSEL),                // HSEL for AHB Slave #1 -> QSPI AHB
    .HREADYOUT1(QSPI_HREADYOUT),      // HREADY for Slave connection #1
    .HRESP1(QSPI_HRESP),              // HRESP  for slave connection #1
    .HRDATA1(QSPI_HRDATA),            // HRDATA for slave connection #1
    .HSEL2(GPIO0_HSEL),               // HSEL for AHB Slave #2
    .HREADYOUT2(GPIO0_HREADYOUT),     // HREADY for Slave connection #2 -> GPIO0
    .HRESP2(GPIO0_HRESP),             // HRESP  for slave connection #2
    .HRDATA2(GPIO0_HRDATA),           // HRDATA for slave connection #2
    .HSEL3(GPIO1_HSEL),               // HSEL for AHB Slave #3
    .HREADYOUT3(GPIO1_HREADYOUT),     // HREADY for Slave connection #3
    .HRESP3(GPIO1_HRESP),             // HRESP  for slave connection #3
    .HRDATA3(GPIO1_HRDATA),           // HRDATA for slave connection #3
    .HSEL4(GPIO2_HSEL),               // HSEL for AHB Slave #4
    .HREADYOUT4(GPIO2_HREADYOUT),     // HREADY for Slave connection #4
    .HRESP4(GPIO2_HRESP),             // HRESP  for slave connection #4
    .HRDATA4(GPIO2_HRDATA),           // HRDATA for slave connection #4
    .HSEL5(GPIO3_HSEL),               // HSEL for AHB Slave #5
    .HREADYOUT5(GPIO3_HREADYOUT),     // HREADY for Slave connection #5
    .HRESP5(GPIO3_HRESP),             // HRESP  for slave connection #5
    .HRDATA5(GPIO3_HRDATA),           // HRDATA for slave connection #5
    .HSEL6(SYSCTRLHSEL_o),            // HSEL for AHB Slave #6
    .HREADYOUT6(SYSCTRLHREADYOUT_i),  // HREADY for Slave connection #6
    .HRESP6(SYSCTRLHRESP_i),          // HRESP  for slave connection #6
    .HRDATA6(SYSCTRLHRDATA_i),        // HRDATA for slave connection #6
    .HSEL7(1'b0),                     // HSEL for AHB Slave #7
    .HREADYOUT7(1'b0),                // HREADY for Slave connection #7
    .HRESP7(1'b1),                    // HRESP  for slave connection #7
    .HRDATA7({32{1'b0}}),             // HRDATA for slave connection #7
    .HSEL8(1'b0),                     // HSEL for AHB Slave #8
    .HREADYOUT8(1'b0),                // HREADY for Slave connection #8
    .HRESP8(1'b1),                    // HRESP  for slave connection #8
    .HRDATA8({32{1'b0}}),             // HRDATA for slave connection #8
    .HSEL9(1'b0),                     // HSEL for AHB Slave #9
    .HREADYOUT9(1'b0),                // HREADY for Slave connection #9
    .HRESP9(1'b1),                    // HRESP  for slave connection #9
    .HRDATA9({32{1'b0}}),             // HRDATA for slave connection #9
    .HREADYOUT(PERIPHHREADYMUXOUT_o), // HREADY output to AHB master and AHB slaves
    .HRESP(PERIPHHRESP_o),            // HRESP to AHB master
    .HRDATA(PERIPHHRDATA_o)           // Read data to AHB master
  );

  cmsdk_ahb_default_slave
  u_cmsdk_ahb_default_slave
  (
    .HCLK(AHB_CLK),                 // Clock
    .HRESETn(AHBRESETn),            // Reset
    .HSEL(defslave_HSEL),           // Slave select
    .HTRANS(PERIPHHTRANS_i),        // Transfer type
    .HREADY(PERIPHHREADYIN_i),      // System ready
    .HREADYOUT(defslave_HREADYOUT), // Slave ready
    .HRESP(defslave_HRESP)          // Slave response
  );

  //-------------------------
  //APB only IPs
  //-------------------------
  //DTIMER
  wire psel_valid_dtimer;
  wire penable_valid_dtimer;
  assign DTIMERPSLVERR_o = 1'b0;  //APBTARGEXP2PSLVERR


  m3ds_apb_decoder #(
      .ADDR_WIDTH(12)
    ) u_beetle_apb_decoder_dtimer (
    .psel_i(DTIMERPSEL_i),
    .paddr_i(DTIMERPADDR_i),
    .penable_i(DTIMERPENABLE_i),
    .pprot_i(DTIMERPPROT_i),
    .secure_i(APBPER0_REG[2]),
    .pready_i(1'b1),

    .psel_valid_o(psel_valid_dtimer),     //decoded psel to slave
    .penable_valid_o(penable_valid_dtimer),  //decoded penable to slave
    .pready_o(DTIMERPREADY_o)
  );

  cmsdk_apb_dualtimers u_cmsdk_apb_dualtimers (
    .PCLK(DTIMER_CLK),              // APB clock
    .PRESETn(DTIMERPRESETn),        // APB reset
    .PENABLE(penable_valid_dtimer), // APB enable
    .PSEL(psel_valid_dtimer),       // APB periph select
    .PADDR(DTIMERPADDR_i[11:2]),    // APB address bus [11:2]
    .PWRITE(DTIMERPWRITE_i),        // APB write
    .PWDATA(DTIMERPWDATA_i),        // APB write data [31:0]

    .TIMCLK(DTIMER_CLK),            // Timer clock
    .TIMCLKEN1(DTIMERTIMCLKEN1_i),  // Timer clock enable 1
    .TIMCLKEN2(DTIMERTIMCLKEN2_i),  // Timer clock enable 2

    .ECOREVNUM(DTIMERECOREVNUM_i),  // ECO revision number [3:0]

    .PRDATA(DTIMERPRDATA_o),        // APB read data [31:0]

    .TIMINT1(DTIMERTIMINT1_o),      // Counter 1 interrupt
    .TIMINT2(DTIMERTIMINT2_o),      // Counter 2 interrupt
    .TIMINTC(DTIMERTIMINTC_o)       // Counter combined interrupt
  );

  //-------------------------
  //UART0
  wire psel_valid_uart0;
  wire penable_valid_uart0;
  wire pready_uart0;

  m3ds_apb_decoder #(
      .ADDR_WIDTH(12)
    ) u_beetle_apb_decoder_uart0 (
    .psel_i(UART0PSEL_i),
    .paddr_i(UART0PADDR_i),
    .penable_i(UART0PENABLE_i),
    .pprot_i(UART0PPROT_i),
    .secure_i(APBPER0_REG[4]),
    .pready_i(pready_uart0),

    .psel_valid_o(psel_valid_uart0),     //decoded psel to slave
    .penable_valid_o(penable_valid_uart0),  //decoded penable to slave
    .pready_o(UART0PREADY_o)
  );

  cmsdk_apb_uart u_cmsdk_apb_uart_0 (
    .PCLK(UART0_CLK),       // Clock
    .PCLKG(APB_CLK),        // Gated Clock
    .PRESETn(UART0PRESETn), // Reset

    .PSEL(psel_valid_uart0),     // Device select
    .PADDR(UART0PADDR_i[11:2]),    // Address [11:2]
    .PENABLE(penable_valid_uart0),  // Transfer control
    .PWRITE(UART0PWRITE_i),   // Write control
    .PWDATA(UART0PWDATA_i),   // Write data [31:0]

    .ECOREVNUM(UART0ECOREVNUM_i),// Engineering-change-order revision bits [3:0]

    .PRDATA(UART0PRDATA_o),   // Read data [31:0]
    .PREADY(pready_uart0),   // Device ready
    .PSLVERR(UART0PSLVERR_o),  // Device error response

    .RXD(UART0RXD_i),      // Serial input
    .TXD(UART0TXD_o),      // Transmit data output
    .TXEN(UART0TXEN_o),     // Transmit enabled
    .BAUDTICK(UART0BAUDTICK_o), // Baud rate (x16) Tick

    .TXINT(UART0TXINT_o),    // Transmit Interrupt
    .RXINT(UART0RXINT_o),    // Receive Interrupt
    .TXOVRINT(UART0TXOVRINT_o), // Transmit overrun Interrupt
    .RXOVRINT(UART0RXOVRINT_o), // Receive overrun Interrupt
    .UARTINT(UART0UARTINT_o)    // Combined interrupt
  );

  //-------------------------
  //UART1
  wire psel_valid_uart1;
  wire penable_valid_uart1;
  wire pready_uart1;

  m3ds_apb_decoder #(
      .ADDR_WIDTH(12)
    ) u_beetle_apb_decoder_uart1 (
    .psel_i(UART1PSEL_i),
    .paddr_i(UART1PADDR_i),
    .penable_i(UART1PENABLE_i),
    .pprot_i(UART1PPROT_i),
    .secure_i(APBPER0_REG[5]),
    .pready_i(pready_uart1),

    .psel_valid_o(psel_valid_uart1),     //decoded psel to slave
    .penable_valid_o(penable_valid_uart1),  //decoded penable to slave
    .pready_o(UART1PREADY_o)
  );

  cmsdk_apb_uart u_cmsdk_apb_uart_1 (
    .PCLK(UART1_CLK),       // Clock
    .PCLKG(APB_CLK),        // Gated Clock
    .PRESETn(UART1PRESETn), // Reset

    .PSEL(psel_valid_uart1),     // Device select
    .PADDR(UART1PADDR_i[11:2]),    // Address [11:2]
    .PENABLE(penable_valid_uart1),  // Transfer control
    .PWRITE(UART1PWRITE_i),   // Write control
    .PWDATA(UART1PWDATA_i),   // Write data [31:0]

    .ECOREVNUM(UART1ECOREVNUM_i),// Engineering-change-order revision bits [3:0]

    .PRDATA(UART1PRDATA_o),   // Read data [31:0]
    .PREADY(pready_uart1),   // Device ready
    .PSLVERR(UART1PSLVERR_o),  // Device error response

    .RXD(UART1RXD_i),      // Serial input
    .TXD(UART1TXD_o),      // Transmit data output
    .TXEN(UART1TXEN_o),     // Transmit enabled
    .BAUDTICK(UART1BAUDTICK_o), // Baud rate (x16) Tick

    .TXINT(UART1TXINT_o),    // Transmit Interrupt
    .RXINT(UART1RXINT_o),    // Receive Interrupt
    .TXOVRINT(UART1TXOVRINT_o), // Transmit overrun Interrupt
    .RXOVRINT(UART1RXOVRINT_o), // Receive overrun Interrupt
    .UARTINT(UART1UARTINT_o)    // Combined interrupt
  );

  //-------------------------
  //RTC
  wire psel_valid_rtc;
  wire penable_valid_rtc;
  assign RTCPSLVERR_o = 1'b0;

  m3ds_apb_decoder #(
      .ADDR_WIDTH(12)
    ) u_beetle_apb_decoder_rtc (
    .psel_i(RTCPSEL_i),
    .paddr_i(RTCPADDR_i),
    .penable_i(RTCPENABLE_i),
    .pprot_i(RTCPPROT_i),
    .secure_i(APBPER0_REG[6]),
    .pready_i(1'b1),

    .psel_valid_o(psel_valid_rtc),     //decoded psel to slave
    .penable_valid_o(penable_valid_rtc),  //decoded penable to slave
    .pready_o(RTCPREADY_o)
  );


  //-------------------------
  // Real time clock
  Rtc u_rtc (
    // Inputs
    .PCLK           (RTC_CLK),
    .PRESETn        (RTCPRESETn),
    .PSEL           (psel_valid_rtc),
    .PENABLE        (penable_valid_rtc),
    .PWRITE         (RTCPWRITE_i),
    .PADDR          (RTCPADDR_i[11:2]),
    .PWDATA         (RTCPWDATA_i),
    .CLK1HZ         (RTC1HZ_CLK),
    .nRTCRST        (RTCnRTCRST),
    .nPOR           (RTCnPOR),
    .SCANENABLE     (RTCSCANENABLE_i),
    .SCANINPCLK     (RTCSCANINPCLK_i),
    .SCANINCLK1HZ   (RTCSCANINCLK1HZ_i),
    // Outputs
    .PRDATA         (RTCPRDATA_o),
    .RTCINTR        (RTCRTCINTR_o),
    .SCANOUTPCLK    (RTCSCANOUTPCLK_o),
    .SCANOUTCLK1HZ  (RTCSCANOUTCLK1HZ_o)
  );



  //-------------------------
  //TRNG
  wire psel_valid_trng;
  wire penable_valid_trng;
  assign TRNGPSLVERR_o = 1'b0;

  m3ds_apb_decoder #(
      .ADDR_WIDTH(12)
    ) u_beetle_apb_decoder_trng (
    .psel_i(TRNGPSEL_i),
    .paddr_i(TRNGPADDR_i),
    .penable_i(TRNGPENABLE_i),
    .pprot_i(TRNGPPROT_i),
    .secure_i(APBPER0_REG[15]),     //TIE_HIGH in sysctrl, TRNG is privileged only
    .pready_i(1'b1),

    .psel_valid_o(psel_valid_trng),     //decoded psel to slave
    .penable_valid_o(penable_valid_trng),  //decoded penable to slave
    .pready_o(TRNGPREADY_o)
  );

  dx_trng_top u_trng (
    .cc_penable(penable_valid_trng),    // APB enable
    .rng_clk(TRNG_CLK),                 // APB clock
    .scanmode(TRNGSCANMODE_i),          // Scan operation
    .cc_psel(psel_valid_trng),          // APB periph select
    .cc_pwrite(TRNGPWRITE_i),           // APB write
    .cc_paddr(TRNGPADDR_i[11:0]),       // APB address bus [11:0]
    .cc_pwdata(TRNGPWDATA_i),           // APB write data [31:0]
    .cc_prdata(TRNGPRDATA_o),           // APB read data [31:0]
    .sys_rst_n(TRNGPRESETn),            // APB reset
    .cc_host_int_req(TRNGINT_o)         // TRNG interrupt request
  );

  //-------------------------
  //W(atch)DOG
  wire psel_valid_wdog;
  wire penable_valid_wdog;
  assign WDOGPSLVERR_o = 1'b0;

  m3ds_apb_decoder #(
      .ADDR_WIDTH(12)
    ) u_beetle_apb_decoder_wdog (
    .psel_i(WDOGPSEL_i),
    .paddr_i(WDOGPADDR_i),
    .penable_i(WDOGPENABLE_i),
    .pprot_i(WDOGPPROT_i),
    .secure_i(APBPER0_REG[8]),
    .pready_i(1'b1),

    .psel_valid_o(psel_valid_wdog),     //decoded psel to slave
    .penable_valid_o(penable_valid_wdog),  //decoded penable to slave
    .pready_o(WDOGPREADY_o)
  );

  cmsdk_apb_watchdog u_cmsdk_apb_watchdog (
    .PCLK(APB_CLK),               // APB clock
    .PRESETn(WDOGPRESETn),        // APB reset
    .PENABLE(penable_valid_wdog), // APB enable
    .PSEL(psel_valid_wdog),       // APB periph select
    .PADDR(WDOGPADDR_i[11:2]),    // APB address bus [11:2]
    .PWRITE(WDOGPWRITE_i),        // APB write
    .PWDATA(WDOGPWDATA_i),        // APB write data [31:0]

    .WDOGCLK(WDOG_CLK),           // Watchdog clock
    .WDOGCLKEN(WDOGCLKEN_i),      // Watchdog clock enable
    .WDOGRESn(WDOGRESn),          // Watchdog clock reset

    .ECOREVNUM(WDOGECOREVNUM_i),   // ECO revision number [3:0]

    .PRDATA(WDOGPRDATA_o),         // APB read data [31:0]

    .WDOGINT(WDOGINT_o),       // Watchdog interrupt
    .WDOGRES(WDOGRES_o)        // Watchdog timeout reset
  );    // Watchdog timeout reset

  //-------------------------
  //AHB only IPs
  //-------------------------
  //GPIO0
  cmsdk_ahb_gpio #(
    // Parameter to define valid bit pattern for Alternate functions
    // If an I/O pin does not have alternate function its function mask
    // can be set to 0 to reduce gate count.
    // By default every bit can have alternate function
    .ALTERNATE_FUNC_MASK(16'hFFFF),
    // Default alternate function settings
    .ALTERNATE_FUNC_DEFAULT(16'h0000),
    // By default use little endian
    .BE(0)
  ) u_cmsdk_ahb_gpio_0 (
    // AHB Inputs
    .HCLK(GPIO0_HCLK),            // system bus clock
    .HRESETn(GPIO0HRESETn),       // system bus reset
    .FCLK(GPIO0_FCLK),            // system bus free clock
    .HSEL(GPIO0_HSEL),            // AHB peripheral select
    .HREADY(PERIPHHREADYIN_i),    // AHB ready input
    .HTRANS(PERIPHHTRANS_i),      // AHB transfer type [1:0]
    .HSIZE(PERIPHHSIZE_i),        // AHB hsize [2:0]
    .HWRITE(PERIPHHWRITE_i),      // AHB hwrite
    .HADDR(PERIPHHADDR_i[11:0]),  // AHB address bus [11:0]
    .HWDATA(PERIPHHWDATA_i),      // AHB write data bus [31:0]

    .ECOREVNUM(GPIO0ECOREVNUM_i), // Engineering-change-order revision bits [3:0]

    .PORTIN(GPIO0PORTIN_i),       // GPIO Interface input [15:0]

   // AHB Outputs
    .HREADYOUT(GPIO0_HREADYOUT),  // AHB ready output to S->M mux
    .HRESP(GPIO0_HRESP),          // AHB response
    .HRDATA(GPIO0_HRDATA),        //[31:0]

    .PORTOUT(GPIO0PORTOUT_o),     // GPIO output [15:0]
    .PORTEN(GPIO0PORTEN_o),       // GPIO output enable [15:0]
    .PORTFUNC(GPIO0PORTFUNC_o),   // Alternate function control [15:0]

    .GPIOINT(GPIO0GPIOINT_o),     // Interrupt output for each pin [15:0]
    .COMBINT(GPIO0COMBINT_o)      // Combined interrupt
  );

  //GPIO1
  cmsdk_ahb_gpio #(
    // Parameter to define valid bit pattern for Alternate functions
    // If an I/O pin does not have alternate function its function mask
    // can be set to 0 to reduce gate count.
    // By default every bit can have alternate function
    .ALTERNATE_FUNC_MASK(16'hFFFF),
    // Default alternate function settings
    .ALTERNATE_FUNC_DEFAULT(16'h0000),
    // By default use little endian
    .BE(0)
  ) u_cmsdk_ahb_gpio_1 (
    // AHB Inputs
    .HCLK(GPIO1_HCLK),            // system bus clock
    .HRESETn(GPIO1HRESETn),       // system bus reset
    .FCLK(GPIO1_FCLK),            // system bus free clock
    .HSEL(GPIO1_HSEL),            // AHB peripheral select
    .HREADY(PERIPHHREADYIN_i),    // AHB ready input
    .HTRANS(PERIPHHTRANS_i),      // AHB transfer type [1:0]
    .HSIZE(PERIPHHSIZE_i),        // AHB hsize [2:0]
    .HWRITE(PERIPHHWRITE_i),      // AHB hwrite
    .HADDR(PERIPHHADDR_i[11:0]),  // AHB address bus [11:0]
    .HWDATA(PERIPHHWDATA_i),      // AHB write data bus [31:0]

    .ECOREVNUM(GPIO1ECOREVNUM_i), // Engineering-change-order revision bits [3:0]

    .PORTIN(GPIO1PORTIN_i),       // GPIO Interface input [15:0]

   // AHB Outputs
    .HREADYOUT(GPIO1_HREADYOUT),  // AHB ready output to S->M mux
    .HRESP(GPIO1_HRESP),          // AHB response
    .HRDATA(GPIO1_HRDATA),        //[31:0]

    .PORTOUT(GPIO1PORTOUT_o),     // GPIO output [15:0]
    .PORTEN(GPIO1PORTEN_o),       // GPIO output enable [15:0]
    .PORTFUNC(GPIO1PORTFUNC_o),   // Alternate function control [15:0]

    .GPIOINT(GPIO1GPIOINT_o),     // Interrupt output for each pin [15:0]
    .COMBINT(GPIO1COMBINT_o)      // Combined interrupt
  );

  //GPIO2
  cmsdk_ahb_gpio #(
    // Parameter to define valid bit pattern for Alternate functions
    // If an I/O pin does not have alternate function its function mask
    // can be set to 0 to reduce gate count.
    // By default every bit can have alternate function
    .ALTERNATE_FUNC_MASK(16'hFFFF),
    // Default alternate function settings
    .ALTERNATE_FUNC_DEFAULT(16'h0000),
    // By default use little endian
    .BE(0)
  ) u_cmsdk_ahb_gpio_2 (
    // AHB Inputs
    .HCLK(GPIO2_HCLK),            // system bus clock
    .HRESETn(GPIO2HRESETn),       // system bus reset
    .FCLK(GPIO2_FCLK),            // system bus free clock
    .HSEL(GPIO2_HSEL),            // AHB peripheral select
    .HREADY(PERIPHHREADYIN_i),    // AHB ready input
    .HTRANS(PERIPHHTRANS_i),      // AHB transfer type [1:0]
    .HSIZE(PERIPHHSIZE_i),        // AHB hsize [2:0]
    .HWRITE(PERIPHHWRITE_i),      // AHB hwrite
    .HADDR(PERIPHHADDR_i[11:0]),  // AHB address bus [11:0]
    .HWDATA(PERIPHHWDATA_i),      // AHB write data bus [31:0]

    .ECOREVNUM(GPIO2ECOREVNUM_i), // Engineering-change-order revision bits [3:0]

    .PORTIN(GPIO2PORTIN_i),       // GPIO Interface input [15:0]

   // AHB Outputs
    .HREADYOUT(GPIO2_HREADYOUT),  // AHB ready output to S->M mux
    .HRESP(GPIO2_HRESP),          // AHB response
    .HRDATA(GPIO2_HRDATA),        //[31:0]

    .PORTOUT(GPIO2PORTOUT_o),     // GPIO output [15:0]
    .PORTEN(GPIO2PORTEN_o),       // GPIO output enable [15:0]
    .PORTFUNC(GPIO2PORTFUNC_o),   // Alternate function control [15:0]

    .GPIOINT(GPIO2GPIOINT_o),     // Interrupt output for each pin [15:0]
    .COMBINT(GPIO2COMBINT_o)      // Combined interrupt
  );

  //GPIO3
  cmsdk_ahb_gpio #(
    // Parameter to define valid bit pattern for Alternate functions
    // If an I/O pin does not have alternate function its function mask
    // can be set to 0 to reduce gate count.
    // By default every bit can have alternate function
    .ALTERNATE_FUNC_MASK(16'hFFFF),
    // Default alternate function settings
    .ALTERNATE_FUNC_DEFAULT(16'h0000),
    // By default use little endian
    .BE(0)
  ) u_cmsdk_ahb_gpio_3 (
    // AHB Inputs
    .HCLK(GPIO3_HCLK),            // system bus clock
    .HRESETn(GPIO3HRESETn),       // system bus reset
    .FCLK(GPIO3_FCLK),            // system bus free clock
    .HSEL(GPIO3_HSEL),            // AHB peripheral select
    .HREADY(PERIPHHREADYIN_i),    // AHB ready input
    .HTRANS(PERIPHHTRANS_i),      // AHB transfer type [1:0]
    .HSIZE(PERIPHHSIZE_i),        // AHB hsize [2:0]
    .HWRITE(PERIPHHWRITE_i),      // AHB hwrite
    .HADDR(PERIPHHADDR_i[11:0]),  // AHB address bus [11:0]
    .HWDATA(PERIPHHWDATA_i),      // AHB write data bus [31:0]

    .ECOREVNUM(GPIO3ECOREVNUM_i), // Engineering-change-order revision bits [3:0]

    .PORTIN(GPIO3PORTIN_i),       // GPIO Interface input [15:0]

   // AHB Outputs
    .HREADYOUT(GPIO3_HREADYOUT),  // AHB ready output to S->M mux
    .HRESP(GPIO3_HRESP),          // AHB response
    .HRDATA(GPIO3_HRDATA),        //[31:0]

    .PORTOUT(GPIO3PORTOUT_o),     // GPIO output [15:0]
    .PORTEN(GPIO3PORTEN_o),       // GPIO output enable [15:0]
    .PORTFUNC(GPIO3PORTFUNC_o),   // Alternate function control [15:0]

    .GPIOINT(GPIO3GPIOINT_o),     // Interrupt output for each pin [15:0]
    .COMBINT(GPIO3COMBINT_o)      // Combined interrupt
  );


// Placeholder for supporting an altenate boot image using QSPI
// AHB slave mux inputs are tied off
   assign  QSPI_HRDATA    = 32'h00000000;
   assign  QSPI_HRESP     = 1'b0;
   assign  QSPI_HREADYOUT = 1'b1;
   assign  QSPI_HSEL      = 1'b0;

endmodule
