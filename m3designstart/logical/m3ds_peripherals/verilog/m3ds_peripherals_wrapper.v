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
// Checked In : $Date: 2015-06-30 10:21:40 +0100 (Tue, 30 Jun 2015) $
// Revision : $Revision: 365823 $
//
// Release Information : CM3DesignStart-r0p0-02rel0
//
// -----------------------------------------------------------------------------
// Verilog-2001 (IEEE Std 1364-2001)
// -----------------------------------------------------------------------------
// Purpose : Closely coupled APB peripherals for M3 Designstart
//           MPS2-platform specific peripherals
// -----------------------------------------------------------------------------

`include "fpga_options_defs.v"

module m3ds_peripherals_wrapper
(
  //-----------------------------
  //Resets
    input  wire          AHBRESETn,                 // AHB domain reset for slave_mux and default_slave
    input  wire          DTIMERPRESETn,             // APB domain + System (functional) clock domain (global reset)
    input  wire          UART0PRESETn,              // APB domain = System (functional) clock
    input  wire          UART1PRESETn,              // APB domain = System (functional) clock
    input  wire          RTCPRESETn,                // APB domain
    input  wire          RTCnRTCRST,                // RTC1HZ_CLK domain
    input  wire          RTCnPOR,                   // RTC power on reset
    input  wire          WDOGPRESETn,               // APB domain of WDOG
    input  wire          WDOGRESn,                  // WDOG_CLK domain
    input  wire          TRNGPRESETn,               // APB domain = System (functional) clock
    input  wire          GPIO0HRESETn,              // AHB domain + System (functional) clock domain (global reset)
    input  wire          GPIO1HRESETn,              // AHB domain + System (functional) clock domain (global reset)
    input  wire          GPIO2HRESETn,              // AHB domain + System (functional) clock domain (global reset)
    input  wire          GPIO3HRESETn,              // AHB domain + System (functional) clock domain (global reset)

  //-----------------------------
  //Clocks
    input  wire          AHB_CLK,                   // HCLK from top
    input  wire          APB_CLK,                   // PCLKG from top
    input  wire          DTIMER_CLK,
    input  wire          UART0_CLK,
    input  wire          UART1_CLK,
    input  wire          RTC_CLK,                   // System Clock (Functional + APB IF)
    input  wire          RTC1HZ_CLK,
    input  wire          WDOG_CLK,
    input  wire          TRNG_CLK,                  // System Clock (Functional + APB IF)
    input  wire          GPIO0_FCLK,                // System Clock (Functional IF)
    input  wire          GPIO1_FCLK,                // System Clock (Functional IF)
    input  wire          GPIO2_FCLK,                // System Clock (Functional IF)
    input  wire          GPIO3_FCLK,                // System Clock (Functional IF)
    input  wire          GPIO0_HCLK,                // System Clock (APB IF)
    input  wire          GPIO1_HCLK,                // System Clock (APB IF)
    input  wire          GPIO2_HCLK,                // System Clock (APB IF)
    input  wire          GPIO3_HCLK,                // System Clock (APB IF)

  //-----------------------------
  //AHB interface
  //AHB Master Slave
    input  wire          PERIPHHSEL_i,              // AHB peripheral select
    input  wire          PERIPHHREADYIN_i,          // AHB ready input
    input  wire [1:0]    PERIPHHTRANS_i,            // AHB transfer type
    input  wire [2:0]    PERIPHHSIZE_i,             // AHB hsize
    input  wire          PERIPHHWRITE_i,            // AHB hwrite
    input  wire [31:0]   PERIPHHADDR_i,             // AHB address bus
    input  wire [31:0]   PERIPHHWDATA_i,            // AHB write data bus

    input  wire [3:0]    PERIPHHPROT_i,

    output wire          PERIPHHREADYMUXOUT_o,      // AHB ready output from S->M mux
    output wire          PERIPHHRESP_o,             // AHB response output from S->M mux
    output wire [31:0]   PERIPHHRDATA_o,            // AHB read data from S->M mux

    input  wire [31:0]   AHBPER0_REG,               // Access permission for GPIOs
    input  wire [31:0]   APBPER0_REG,               // Access permission for APB peripherals
  //-----------------------------
  //SysCtrl AHB slaveMux control
    output wire          SYSCTRLHSEL_o,
    input  wire          SYSCTRLHREADYOUT_i,
    input  wire [31:0]   SYSCTRLHRDATA_i,
    input  wire          SYSCTRLHRESP_i,

  //-----------------------------
  //APB interfaces
  //D(ual)Timer
    input  wire          DTIMERPSEL_i,              // APBTARGEXP2PSEL
    input  wire          DTIMERPENABLE_i,           // APBTARGEXP2PENABLE
    input  wire [31:0]   DTIMERPADDR_i,             // APBTARGEXP2PADDR
    input  wire          DTIMERPWRITE_i,            // APBTARGEXP2PWRITE
    input  wire [31:0]   DTIMERPWDATA_i,            // APBTARGEXP2PWDATA
    input  wire [3:0]    DTIMERPSTRB_i,             // APBTARGEXP2PSTRB
    input  wire          DTIMERPPROT_i,             // APBTARGEXP2PPROT
    output wire [31:0]   DTIMERPRDATA_o,            // APBTARGEXP2PRDATA
    output wire          DTIMERPREADY_o,            // APBTARGEXP2PREADY
    output wire          DTIMERPSLVERR_o,           // APBTARGEXP2PSLVERR

  //UART0
    input  wire          UART0PSEL_i,               // APBTARGEXP4PSEL
    input  wire          UART0PENABLE_i,            // APBTARGEXP4PENABLE
    input  wire [31:0]   UART0PADDR_i,              // APBTARGEXP4PADDR
    input  wire          UART0PWRITE_i,             // APBTARGEXP4PWRITE
    input  wire [31:0]   UART0PWDATA_i,             // APBTARGEXP4PWDATA
    input  wire [3:0]    UART0PSTRB_i,              // APBTARGEXP4PSTRB
    input  wire          UART0PPROT_i,              // APBTARGEXP4PPROT
    output wire [31:0]   UART0PRDATA_o,             // APBTARGEXP4PRDATA
    output wire          UART0PREADY_o,             // APBTARGEXP4PREADY
    output wire          UART0PSLVERR_o,            // APBTARGEXP4PSLVERR

  //UART1
    input  wire          UART1PSEL_i,               // APBTARGEXP5PSEL
    input  wire          UART1PENABLE_i,            // APBTARGEXP5PENABLE
    input  wire [31:0]   UART1PADDR_i,              // APBTARGEXP5PADDR
    input  wire          UART1PWRITE_i,             // APBTARGEXP5PWRITE
    input  wire [31:0]   UART1PWDATA_i,             // APBTARGEXP5PWDATA
    input  wire [3:0]    UART1PSTRB_i,              // APBTARGEXP5PSTRB
    input  wire          UART1PPROT_i,              // APBTARGEXP5PPROT
    output wire [31:0]   UART1PRDATA_o,             // APBTARGEXP5PRDATA
    output wire          UART1PREADY_o,             // APBTARGEXP5PREADY
    output wire          UART1PSLVERR_o,            // APBTARGEXP5PSLVERR

  //RTC
    input  wire          RTCPSEL_i,                 // APBTARGEXP6PSEL
    input  wire          RTCPENABLE_i,              // APBTARGEXP6PENABLE
    input  wire [31:0]   RTCPADDR_i,                // APBTARGEXP6PADDR
    input  wire          RTCPWRITE_i,               // APBTARGEXP6PWRITE
    input  wire [31:0]   RTCPWDATA_i,               // APBTARGEXP6PWDATA
    input  wire [ 3:0]   RTCPSTRB_i,                // APBTARGEXP6PSTRB
    input  wire          RTCPPROT_i,                // APBTARGEXP6PPROT
    output wire [31:0]   RTCPRDATA_o,               // APBTARGEXP6PRDATA
    output wire          RTCPREADY_o,               // APBTARGEXP6PREADY
    output wire          RTCPSLVERR_o,              // APBTARGEXP6PSLVERR
  //W(atch)DOG
    input  wire          WDOGPSEL_i,                // APBTARGEXP8PSEL
    input  wire          WDOGPENABLE_i,             // APBTARGEXP8PENABLE
    input  wire [31:0]   WDOGPADDR_i,               // APBTARGEXP8PADDR
    input  wire          WDOGPWRITE_i,              // APBTARGEXP8PWRITE
    input  wire [31:0]   WDOGPWDATA_i,              // APBTARGEXP8PWDATA
    input  wire [3:0]    WDOGPSTRB_i,               // APBTARGEXP8PSTRB
    input  wire          WDOGPPROT_i,               // APBTARGEXP8PPROT
    output wire [31:0]   WDOGPRDATA_o,              // APBTARGEXP8PRDATA
    output wire          WDOGPREADY_o,              // APBTARGEXP8PREADY
    output wire          WDOGPSLVERR_o,             // APBTARGEXP8PSLVERR
  //TRNG
    input  wire          TRNGPSEL_i,                // APBTARGEXP15PSEL
    input  wire          TRNGPENABLE_i,             // APBTARGEXP15PENABLE
    input  wire [31:0]   TRNGPADDR_i,               // APBTARGEXP15PADDR
    input  wire          TRNGPWRITE_i,              // APBTARGEXP15PWRITE
    input  wire [31:0]   TRNGPWDATA_i,              // APBTARGEXP15PWDATA
    input  wire [3:0]    TRNGPSTRB_i,               // APBTARGEXP15PSTRB
    input  wire          TRNGPPROT_i,               // APBTARGEXP15PPROT
    output wire [31:0]   TRNGPRDATA_o,              // APBTARGEXP15PRDATA
    output wire          TRNGPREADY_o,              // APBTARGEXP15PREADY
    output wire          TRNGPSLVERR_o,             // APBTARGEXP15PSLVERR


  //-----------------------------
  //Other/Functional peripheral module specific interfaces
  //-----------------------------
  //D(ual)TIMER
    input  wire [3:0]    DTIMERECOREVNUM_i,         // ECO revision number
    input  wire          DTIMERTIMCLKEN1_i,         // Timer clock enable 1
    input  wire          DTIMERTIMCLKEN2_i,         // Timer clock enable 2
    output wire          DTIMERTIMINT1_o,           // Counter 1 interrupt
    output wire          DTIMERTIMINT2_o,           // Counter 2 interrupt
    output wire          DTIMERTIMINTC_o,           // Counter combined interrupt

  //-----------------------------
  //UART0
    input  wire [3:0]    UART0ECOREVNUM_i,          // Engineering-change-order revision bits
    input  wire          UART0RXD_i,                // Serial input
    output wire          UART0TXD_o,                // Transmit data output
    output wire          UART0TXEN_o,               // Transmit enabled
    output wire          UART0BAUDTICK_o,           // Baud rate (x16) Tick
    output wire          UART0TXINT_o,              // Transmit Interrupt
    output wire          UART0RXINT_o,              // Receive Interrupt
    output wire          UART0TXOVRINT_o,           // Transmit overrun Interrupt
    output wire          UART0RXOVRINT_o,           // Receive overrun Interrupt
    output wire          UART0UARTINT_o,            // Combined interrupt

  //-----------------------------
  //UART1
    input  wire [3:0]    UART1ECOREVNUM_i,          // Engineering-change-order revision bits
    input  wire          UART1RXD_i,                // Serial input
    output wire          UART1TXD_o,                // Transmit data output
    output wire          UART1TXEN_o,               // Transmit enabled
    output wire          UART1BAUDTICK_o,           // Baud rate (x16) Tick
    output wire          UART1TXINT_o,              // Transmit Interrupt
    output wire          UART1RXINT_o,              // Receive Interrupt
    output wire          UART1TXOVRINT_o,           // Transmit overrun Interrupt
    output wire          UART1RXOVRINT_o,           // Receive overrun Interrupt
    output wire          UART1UARTINT_o,            // Combined interrupt

  //-----------------------------
  //RTC
    input  wire          RTCSCANENABLE_i,           // Test mode enable
    input  wire          RTCSCANINPCLK_i,           // PCLK Scan chain input
    input  wire          RTCSCANINCLK1HZ_i,         // CLK1HZ Scan chain input
    output wire          RTCSCANOUTPCLK_o,          // PCLK Scan chain output
    output wire          RTCSCANOUTCLK1HZ_o,        // CLK1HZ Scan chain output
    output wire          RTCRTCINTR_o,              // RTC interrupt

  //-----------------------------
  //W(atch)DOG
    input  wire [3:0]    WDOGECOREVNUM_i,           // ECO revision number
    input  wire          WDOGCLKEN_i,               // Watchdog clock enable
    output wire          WDOGINT_o,                 // Watchdog interrupt
    output wire          WDOGRES_o,                 // Watchdog timeout reset

  //-----------------------------
  //TRNG
    input  wire          TRNGSCANMODE_i,
    output wire          TRNGINT_o,

  //-----------------------------
  //GPIO0
    input  wire [3:0]    GPIO0ECOREVNUM_i,          // Engineering-change-order revision bits
    input  wire [15:0]   GPIO0PORTIN_i,             // GPIO Interface input
    output wire [15:0]   GPIO0PORTOUT_o,            // GPIO output
    output wire [15:0]   GPIO0PORTEN_o,             // GPIO output enable
    output wire [15:0]   GPIO0PORTFUNC_o,           // Alternate function control
    output wire [15:0]   GPIO0GPIOINT_o,            // Interrupt output for each pin
    output wire          GPIO0COMBINT_o,            // Combined interrupt

  //-----------------------------
  //GPIO1
    input  wire [3:0]    GPIO1ECOREVNUM_i,          // Engineering-change-order revision bits
    input  wire [15:0]   GPIO1PORTIN_i,             // GPIO Interface input
    output wire [15:0]   GPIO1PORTOUT_o,            // GPIO output
    output wire [15:0]   GPIO1PORTEN_o,             // GPIO output enable
    output wire [15:0]   GPIO1PORTFUNC_o,           // Alternate function control
    output wire [15:0]   GPIO1GPIOINT_o,            // Interrupt output for each pin
    output wire          GPIO1COMBINT_o,            // Combined interrupt

  //-----------------------------
  //GPIO2
    input  wire [3:0]    GPIO2ECOREVNUM_i,          // Engineering-change-order revision bits
    input  wire [15:0]   GPIO2PORTIN_i,             // GPIO Interface input
    output wire [15:0]   GPIO2PORTOUT_o,            // GPIO output
    output wire [15:0]   GPIO2PORTEN_o,             // GPIO output enable
    output wire [15:0]   GPIO2PORTFUNC_o,           // Alternate function control
    output wire [15:0]   GPIO2GPIOINT_o,            // Interrupt output for each pin
    output wire          GPIO2COMBINT_o,            // Combined interrupt

  //-----------------------------
  //GPIO3
    input  wire [3:0]    GPIO3ECOREVNUM_i,          // Engineering-change-order revision bits
    input  wire [15:0]   GPIO3PORTIN_i,             // GPIO Interface input
    output wire [15:0]   GPIO3PORTOUT_o,            // GPIO output
    output wire [15:0]   GPIO3PORTEN_o,             // GPIO output enable
    output wire [15:0]   GPIO3PORTFUNC_o,           // Alternate function control
    output wire [15:0]   GPIO3GPIOINT_o,            // Interrupt output for each pin
    output wire          GPIO3COMBINT_o,            // Combined interrupt

  //-----------------------------
  //GPIO4
    input  wire [3:0]    GPIO4ECOREVNUM_i,          // Engineering-change-order revision bits
    input  wire [15:0]   GPIO4PORTIN_i,             // GPIO Interface input
    output wire [15:0]   GPIO4PORTOUT_o,            // GPIO output
    output wire [15:0]   GPIO4PORTEN_o,             // GPIO output enable
    output wire [15:0]   GPIO4PORTFUNC_o,           // Alternate function control
    output wire [15:0]   GPIO4GPIOINT_o,            // Interrupt output for each pin
    output wire          GPIO4COMBINT_o,            // Combined interrupt

  //-----------------------------
  //GPIO5
    input  wire [3:0]    GPIO5ECOREVNUM_i,          // Engineering-change-order revision bits
    input  wire [15:0]   GPIO5PORTIN_i,             // GPIO Interface input
    output wire [15:0]   GPIO5PORTOUT_o,            // GPIO output
    output wire [15:0]   GPIO5PORTEN_o,             // GPIO output enable
    output wire [15:0]   GPIO5PORTFUNC_o,           // Alternate function control
    output wire [15:0]   GPIO5GPIOINT_o,            // Interrupt output for each pin
    output wire          GPIO5COMBINT_o,            // Combined interrupt
  // --------------------------------------------------------------------
  //MPS2 Peripherals
  // --------------------------------------------------------------------
    input  wire          nPOR,
  `ifdef CLOCK_BRIDGES
    input  wire          SCLK,                      // Peripheral clock
    input  wire          SCLKG,                     // Gated PCLK for bus
  `endif
    input  wire          CLK_100HZ,
  // --------------------------------------------------------------------
  // UART
  // --------------------------------------------------------------------
    input  wire          UART2_RXD,                 // Uart 2 receive data
    output wire          UART2_TXD,                 // Uart 2 transmit data
    output wire          UART2_TXEN,                // Uart 2 transmit data enable

    input  wire          UART3_RXD,                 // Uart 3 receive data
    output wire          UART3_TXD,                 // Uart 3 transmit data
    output wire          UART3_TXEN,                // Uart 3 transmit data enable

    input  wire          UART4_RXD,                 // Uart 4 receive data
    output wire          UART4_TXD,                 // Uart 4 transmit data
    output wire          UART4_TXEN,                // Uart 4 transmit data enable

  // --------------------------------------------------------------------
  // I/Os
  // --------------------------------------------------------------------
    output wire [1:0]    LEDS,                      // LEDs
    input  wire [1:0]    BUTTONS,                   // Push buttons
    input  wire [7:0]    DLL_LOCKED,                // DLL/PLL locked information

    output wire [9:0]    FPGA_MISC,

  // --------------------------------------------------------------------
  // SPI
  // --------------------------------------------------------------------
    output wire          SPI0_CLK_OUT,              // SPI clock
    output wire          SPI0_CLK_OUT_EN_n,         // SPI clock output enable (active low)
    output wire          SPI0_DATA_OUT,             // SPI data out
    output wire          SPI0_DATA_OUT_EN_n,        // SPI data output enable (active low)
    input  wire          SPI0_DATA_IN,              // SPI data in
    output wire          SPI0_SEL,                  // SPI device select

  // --------------------------------------------------------------------
  // Audio
  // --------------------------------------------------------------------
    input  wire          AUDIO_MCLK,                // Audio codec master clock (12.288MHz)
    input  wire          AUDIO_SCLK,                // Audio interface bit clock
    output wire          AUDIO_LRCK,                // Audio Left/Right clock
    output wire          AUDIO_SDOUT,               // Audio DAC data
    input  wire          AUDIO_SDIN,                // Audio ADC data
    output wire          AUDIO_NRST,                // Audio reset

    output wire          AUDIO_SCL,
    input  wire          AUDIO_SDA_I,
    output wire          AUDIO_SDA_O_EN_n,
  // When audio_sda_o_en_n=0, pull SDA low

  // --------------------------------------------------------------------
  // CLCD
  // --------------------------------------------------------------------
    output wire          CLCD_SCL,
    input  wire          CLCD_SDA_I,
    output wire          CLCD_SDA_O_EN_n,

    output wire          SPI1_CLK_OUT,              // CLCD SPI clock
    output wire          SPI1_CLK_OUT_EN_n,         // CLCD SPI clock output enable (active low)
    output wire          SPI1_DATA_OUT,             // CLCD SPI data out
    output wire          SPI1_DATA_OUT_EN_n,        // CLCD SPI data output enable (active low)
    input  wire          SPI1_DATA_IN,              // CLCD SPI data in
    output wire          SPI1_SEL,                  // CLCD SPI device select

  // --------------------------------------------------------------------
  // ADC SPI
  // --------------------------------------------------------------------
    output wire          ADC_SPI2_CLK_OUT,          // ADC SPI clock
    output wire          ADC_SPI2_CLK_OUT_EN_n,     // ADC SPI clock output enable (active low)
    output wire          ADC_SPI2_DATA_OUT,         // ADC SPI data out
    output wire          ADC_SPI2_DATA_OUT_EN_n,    // ADC SPI data output enable (active low)
    input  wire          ADC_SPI2_DATA_IN,          // ADC SPI data in
    output wire          ADC_SPI2_SEL,              // ADC SPI device select

  // --------------------------------------------------------------------
  // Shield 0
  // --------------------------------------------------------------------
    output wire          SHIELD0_SCL,
    input  wire          SHIELD0_SDA_I,
    output wire          SHIELD0_SDA_O_EN_n,

    output wire          SHIELD0_SPI3_CLK_OUT,       // shield0 SPI clock
    output wire          SHIELD0_SPI3_CLK_OUT_EN_n,  // shield0 SPI clock output enable (active low)
    output wire          SHIELD0_SPI3_DATA_OUT,      // shield0 SPI data out
    output wire          SHIELD0_SPI3_DATA_OUT_EN_n, // shield0 SPI data output enable (active low)
    input  wire          SHIELD0_SPI3_DATA_IN,       // shield0 SPI data in
    output wire          SHIELD0_SPI3_SEL,           // shield0 SPI device select
  // When audio_sda_o_en_n=0, pull SDA low

  // --------------------------------------------------------------------
  // Shield 1
  // --------------------------------------------------------------------
    output wire          SHIELD1_SCL,
    input  wire          SHIELD1_SDA_I,
    output wire          SHIELD1_SDA_O_EN_n,

    output wire          SHIELD1_SPI4_CLK_OUT,       // shield1 SPI clock
    output wire          SHIELD1_SPI4_CLK_OUT_EN_n,  // shield1 SPI clock output enable (active low)
    output wire          SHIELD1_SPI4_DATA_OUT,      // shield1 SPI data out
    output wire          SHIELD1_SPI4_DATA_OUT_EN_n, // shield1 SPI data output enable (active low)
    input  wire          SHIELD1_SPI4_DATA_IN,       // shield1 SPI data in
    output wire          SHIELD1_SPI4_SEL,           // shield1 SPI device select

  // --------------------------------------------------------------------
  // Serial Communication Controller interface
  // --------------------------------------------------------------------
    input  wire          CFGCLK,
    input  wire          nCFGRST,

    input  wire          CFGLOAD,
    input  wire          CFGWnR,
    input  wire          CFGDATAIN,
    output wire          CFGDATAOUT,

    output wire          CFGINT,
    output wire          spi_interrupt_o,            // Combined SPI interrupts
    output wire          spi0_interrupt_o,
    output wire          spi1_interrupt_o,
    output wire          spi2_interrupt_o,
    output wire          spi3_interrupt_o,
    output wire          spi4_interrupt_o,
    output wire          I2S_INTERRUPT,              // Interrupt from FPGA APB subsystem to processor
    output wire [11:0]   UART_INTERRUPTS,            // Interrupt from FPGA APB subsystem UARTS to processor
    output wire          ETH_INTERRUPT,              // Interrupt from off chip ethernet to processor

//MPS2 Memory Subsystem
// --------------------------------------------------------------------
// ZBT Synchronous SRAM
// --------------------------------------------------------------------

// 64-bit ZBT Synchronous SRAM1 connections
    output wire [19:0]   ZBT_SRAM1_A,                // Address
    input  wire [63:0]   ZBT_SRAM1_DQ_I,             // Data input
    output wire [63:0]   ZBT_SRAM1_DQ_O,             // Data Output
    output wire          ZBT_SRAM1_DQ_OEN,           // 3-state Buffer Enable
    output wire [7:0]    ZBT_SRAM1_BWN,              // Byte lane writes (active low)
    output wire          ZBT_SRAM1_CEN,              // Chip Select (active low)
    output wire          ZBT_SRAM1_WEN,              // Write enable
    output wire          ZBT_SRAM1_OEN,              // Output enable (active low)
    output wire          ZBT_SRAM1_LBON,             // Not used (tied to 0)
    output wire          ZBT_SRAM1_ADV,              // Not used (tied to 0)
    output wire          ZBT_SRAM1_ZZ,               // Not used (tied to 0)
    output wire          ZBT_SRAM1_CKEN,             // Not used (tied to 0)

// 32-bit ZBT Synchronous SRAM2 connections
    output wire [19:0]   ZBT_SRAM2_A,                // Address
    input  wire [31:0]   ZBT_SRAM2_DQ_I,             // Data input
    output wire [31:0]   ZBT_SRAM2_DQ_O,             // Data Output
    output wire          ZBT_SRAM2_DQ_OEN,           // 3-state Buffer Enable
    output wire [3:0]    ZBT_SRAM2_BWN,              // Byte lane writes (active low)
    output wire          ZBT_SRAM2_CEN,              // Chip Select (active low)
    output wire          ZBT_SRAM2_WEN,              // Write enable
    output wire          ZBT_SRAM2_OEN,              // Output enable (active low)
    output wire          ZBT_SRAM2_LBON,             // Not used (tied to 0)
    output wire          ZBT_SRAM2_ADV,              // Not used (tied to 0)
    output wire          ZBT_SRAM2_ZZ,               // Not used (tied to 0)
    output wire          ZBT_SRAM2_CKEN,             // Not used (tied to 0)

// 32-bit ZBT Synchronous SRAM3 connections
    output wire [19:0]   ZBT_SRAM3_A,                // Address
    input  wire [31:0]   ZBT_SRAM3_DQ_I,             // Data input
    output wire [31:0]   ZBT_SRAM3_DQ_O,             // Data Output
    output wire          ZBT_SRAM3_DQ_OEN,           // 3-state Buffer Enable
    output wire [3:0]    ZBT_SRAM3_BWN,              // Byte lane writes (active low)
    output wire          ZBT_SRAM3_CEN,              // Chip Select (active low)
    output wire          ZBT_SRAM3_WEN,              // Write enable
    output wire          ZBT_SRAM3_OEN,              // Output enable (active low)
    output wire          ZBT_SRAM3_LBON,             // Not used (tied to 0)
    output wire          ZBT_SRAM3_ADV,              // Not used (tied to 0)
    output wire          ZBT_SRAM3_ZZ,               // Not used (tied to 0)
    output wire          ZBT_SRAM3_CKEN,             // Not used (tied to 0)

// 16-bit smb connections
    output wire [25:0]   SMB_ADDR,                   // Address
    input  wire [15:0]   SMB_DATA_I,                 // Read Data
    output wire [15:0]   SMB_DATA_O,                 // Write Data
    output wire          SMB_DATA_O_NEN,             // Write Data 3-state ctrl
    output wire          SMB_CEN,                    // Active low chip enable
    output wire          SMB_OEN,                    // Active low output enable (read)
    output wire          SMB_WEN,                    // Active low write enable
    output wire          SMB_UBN,                    // Active low Upper Byte Enable
    output wire          SMB_LBN,                    // Active low Upper Byte Enable
    output wire          SMB_NRD,                    // Active low read enable
    output wire          SMB_NRESET,                 // Active low reset

// --------------------------------------------------------------------
// VGA
// --------------------------------------------------------------------
    output wire          VGA_HSYNC,                  // VGA H-Sync
    output wire          VGA_VSYNC,                  // VGA V-Sync
    output wire [3:0]    VGA_R,                      // VGA red data
    output wire [3:0]    VGA_G,                      // VGA green data
    output wire [3:0]    VGA_B,                      // VGA blue data

// --------------------------------------------------------------------
// Ethernet
// --------------------------------------------------------------------
    input  wire          SMB_ETH_IRQ_N,
    output wire [31:0]   EFUSES,
    output wire [2:0]    TEST_CTRL
);

  wire w_beetle_hsel;
  wire w_beetle_hreadyout;
  wire w_beetle_hresp;
  wire [31:0] w_beetle_hrdata;

  wire w_defslave_hsel;
  wire w_defslave_hreadyout;
  wire w_defslave_hresp;
  wire [31:0] w_defslave_hrdata;

  wire w_fpga_hsel;
  wire w_fpga_hreadyout;
  wire w_fpga_hresp;
  wire [31:0] w_fpga_hrdata;

  wire w_mps2_hsel;
  wire w_mps2_hreadyout;
  wire w_mps2_hresp;
  wire [31:0] w_mps2_hrdata;

  //-------------------------------
  //AHB Decoder, Mux, default slave
  //-------------------------------
  mps2_ahb_decoder u_mps2_ahb_decoder (
    .HSEL_i             (PERIPHHSEL_i),
    .decode_address_i   (PERIPHHADDR_i[31:16]),  //lower 10 bits are not compared
    .BEETLE_HSEL_o      (w_beetle_hsel),
    .DEFSLAVE_HSEL_o    (w_defslave_hsel),
    .FPGA_HSEL_o        (w_fpga_hsel),
    .MPS2_HSEL_o        (w_mps2_hsel),
    .CFG_BOOT           (1'b0)
  );

  cmsdk_ahb_slave_mux
  #(
    .PORT0_ENABLE(1'b1),  //beetle_peripheral
    .PORT1_ENABLE(1'b1),  //fpga_apb_subsystem
    .PORT2_ENABLE(1'b1),  //mps2_external_subsystem
    .PORT3_ENABLE(1'b1),  //default slave
    .PORT4_ENABLE(1'b0),  //unused
    .PORT5_ENABLE(1'b0),  //unused
    .PORT6_ENABLE(1'b0),  //unused
    .PORT7_ENABLE(1'b0),  //unused
    .PORT8_ENABLE(1'b0),  //unused
    .PORT9_ENABLE(1'b0),  //unused
    .DW(32)               //32bits
  ) u_mps2_ahb_slave_mux (
    .HCLK(AHB_CLK),                   // Top Clock
    .HRESETn(AHBRESETn),              // Top Reset
    .HREADY(PERIPHHREADYIN_i),        // Top Bus ready
    .HSEL0(w_beetle_hsel),            // HSEL for AHB Slave #0 -> Default slave
    .HREADYOUT0(w_beetle_hreadyout),  // HREADY for Slave connection #0
    .HRESP0(w_beetle_hresp),          // HRESP  for slave connection #0
    .HRDATA0(w_beetle_hrdata),        // HRDATA for slave connection #0
    .HSEL1(w_fpga_hsel),              // HSEL for AHB Slave #1 -> BEETLE AHB
    .HREADYOUT1(w_fpga_hreadyout),    // HREADY for Slave connection #1
    .HRESP1(w_fpga_hresp),            // HRESP  for slave connection #1
    .HRDATA1(w_fpga_hrdata),          // HRDATA for slave connection #1
    .HSEL2(w_mps2_hsel),              // HSEL for AHB Slave #2
    .HREADYOUT2(w_mps2_hreadyout),    // HREADY for Slave connection #2 -> FPGA
    .HRESP2(w_mps2_hresp),            // HRESP  for slave connection #2
    .HRDATA2(w_mps2_hrdata),          // HRDATA for slave connection #2
    .HSEL3(w_defslave_hsel),          // HSEL for AHB Slave #3
    .HREADYOUT3(w_defslave_hreadyout),// HREADY for Slave connection #3
    .HRESP3(w_defslave_hresp),        // HRESP  for slave connection #3
    .HRDATA3(w_defslave_hrdata),      // HRDATA for slave connection #3
    .HSEL4(1'b0),         // HSEL for AHB Slave #4
    .HREADYOUT4(1'b0),    // HREADY for Slave connection #4
    .HRESP4(1'b1),        // HRESP  for slave connection #4
    .HRDATA4({32{1'b0}}), // HRDATA for slave connection #4
    .HSEL5(1'b0),         // HSEL for AHB Slave #5
    .HREADYOUT5(1'b0),    // HREADY for Slave connection #5
    .HRESP5(1'b1),        // HRESP  for slave connection #5
    .HRDATA5({32{1'b0}}), // HRDATA for slave connection #5
    .HSEL6(1'b0),         // HSEL for AHB Slave #6
    .HREADYOUT6(1'b0),    // HREADY for Slave connection #6
    .HRESP6(1'b1),        // HRESP  for slave connection #6
    .HRDATA6({32{1'b0}}), // HRDATA for slave connection #6
    .HSEL7(1'b0),         // HSEL for AHB Slave #7
    .HREADYOUT7(1'b0),    // HREADY for Slave connection #7
    .HRESP7(1'b1),        // HRESP  for slave connection #7
    .HRDATA7({32{1'b0}}), // HRDATA for slave connection #7
    .HSEL8(1'b0),         // HSEL for AHB Slave #8
    .HREADYOUT8(1'b0),    // HREADY for Slave connection #8
    .HRESP8(1'b1),        // HRESP  for slave connection #8
    .HRDATA8({32{1'b0}}), // HRDATA for slave connection #8
    .HSEL9(1'b0),         // HSEL for AHB Slave #9
    .HREADYOUT9(1'b0),    // HREADY for Slave connection #9
    .HRESP9(1'b1),        // HRESP  for slave connection #9
    .HRDATA9({32{1'b0}}), // HRDATA for slave connection #9
    .HREADYOUT(PERIPHHREADYMUXOUT_o), // HREADY output to AHB master and AHB slaves
    .HRESP(PERIPHHRESP_o),            // HRESP to AHB master
    .HRDATA(PERIPHHRDATA_o)           // Read data to AHB master

  );

  // Default slave
  cmsdk_ahb_default_slave u_ahb_default_slave_0 (
    .HCLK         (AHB_CLK),
    .HRESETn      (AHBRESETn),
    .HSEL         (w_defslave_hsel),
    .HTRANS       (PERIPHHTRANS_i),
    .HREADY       (PERIPHHREADYIN_i),
    .HREADYOUT    (w_defslave_hreadyout),
    .HRESP        (w_defslave_hresp)
  );

  assign w_defslave_hrdata = {32{1'b0}};

beetle_peripherals_fpga u_beetle_peripherals_fpga_subsystem
(
  //-----------------------------
  //Resets
  .AHBRESETn            (AHBRESETn    ),  //AHB domain reset for slave_mux and default_slave
  .DTIMERPRESETn        (DTIMERPRESETn),  //APB domain + System (functional) clock domain (global reset)
  .UART0PRESETn         (UART0PRESETn ),  //APB domain = System (functional) clock
  .UART1PRESETn         (UART1PRESETn ),  //APB domain = System (functional) clock
  .RTCPRESETn           (RTCPRESETn   ),  //APB domain
  .RTCnRTCRST           (RTCnRTCRST   ),  //RTC1HZ_CLK domain
  .RTCnPOR              (RTCnPOR      ),  //RTC power on reset
  .WDOGPRESETn          (WDOGPRESETn  ),  //APB domain of WDOG
  .WDOGRESn             (WDOGRESn     ),  //WDOG_CLK domain
  .TRNGPRESETn          (TRNGPRESETn  ),  //APB domain = System (functional) clock
  .GPIO0HRESETn         (GPIO0HRESETn ),  //AHB domain + System (functional) clock domain (global reset)
  .GPIO1HRESETn         (GPIO1HRESETn ),  //AHB domain + System (functional) clock domain (global reset)
  .GPIO2HRESETn         (GPIO2HRESETn ),  //AHB domain + System (functional) clock domain (global reset)
  .GPIO3HRESETn         (GPIO3HRESETn ),  //AHB domain + System (functional) clock domain (global reset)

  //-----------------------------
  //Clocks
  .AHB_CLK              (AHB_CLK   ),  //HCLK from top
  .APB_CLK              (APB_CLK   ),  //PCLKG from top
  .DTIMER_CLK           (DTIMER_CLK),
  .UART0_CLK            (UART0_CLK ),
  .UART1_CLK            (UART1_CLK ),
  .RTC_CLK              (RTC_CLK   ),
  .RTC1HZ_CLK           (RTC1HZ_CLK),
  .WDOG_CLK             (WDOG_CLK  ),
  .TRNG_CLK             (TRNG_CLK  ),  // System Clock (Functional + APB IF)
  .GPIO0_FCLK           (GPIO0_FCLK),  // System Clock (Functional IF)
  .GPIO1_FCLK           (GPIO1_FCLK),  // System Clock (Functional IF)
  .GPIO2_FCLK           (GPIO2_FCLK),  // System Clock (Functional IF)
  .GPIO3_FCLK           (GPIO3_FCLK),  // System Clock (Functional IF)
  .GPIO0_HCLK           (GPIO0_HCLK),  // System Clock (APB IF)
  .GPIO1_HCLK           (GPIO1_HCLK),  // System Clock (APB IF)
  .GPIO2_HCLK           (GPIO2_HCLK),  // System Clock (APB IF)
  .GPIO3_HCLK           (GPIO3_HCLK),  // System Clock (APB IF)

  //-----------------------------
  //AHB interface
  //AHB Master Slave
  .PERIPHHSEL_i         (w_beetle_hsel   ),  //AHB peripheral select
  .PERIPHHREADYIN_i     (PERIPHHREADYIN_i),  //AHB ready input
  .PERIPHHTRANS_i       (PERIPHHTRANS_i  ),  //AHB transfer type
  .PERIPHHSIZE_i        (PERIPHHSIZE_i   ),  //AHB hsize
  .PERIPHHWRITE_i       (PERIPHHWRITE_i  ),  //AHB hwrite
  .PERIPHHADDR_i        (PERIPHHADDR_i   ),  //AHB address bus
  .PERIPHHWDATA_i       (PERIPHHWDATA_i  ),  //AHB write data bus

  .PERIPHHPROT_i        (PERIPHHPROT_i[1]),

  .PERIPHHREADYMUXOUT_o (w_beetle_hreadyout),  //AHB ready output from S->M mux
  .PERIPHHRESP_o        (w_beetle_hresp       ),  //AHB response output from S->M mux
  .PERIPHHRDATA_o       (w_beetle_hrdata      ),  //AHB read data from S->M mux

  .AHBPER0_REG          (AHBPER0_REG         ),  // Access permission for GPIOs
  .APBPER0_REG          (APBPER0_REG         ),  // Access permission for APB peripherals
  //-----------------------------
  //SysCtrl AHB slaveMux control
  .SYSCTRLHSEL_o        (SYSCTRLHSEL_o     ),
  .SYSCTRLHREADYOUT_i   (SYSCTRLHREADYOUT_i),
  .SYSCTRLHRDATA_i      (SYSCTRLHRDATA_i   ),
  .SYSCTRLHRESP_i       (SYSCTRLHRESP_i    ),

  //-----------------------------
  //APB interfaces
  //D(ual)Timer
  .DTIMERPSEL_i         (DTIMERPSEL_i   ),  //APBTARGEXP2PSEL
  .DTIMERPENABLE_i      (DTIMERPENABLE_i),  //APBTARGEXP2PENABLE
  .DTIMERPADDR_i        (DTIMERPADDR_i  ),  //APBTARGEXP2PADDR
  .DTIMERPWRITE_i       (DTIMERPWRITE_i ),  //APBTARGEXP2PWRITE
  .DTIMERPWDATA_i       (DTIMERPWDATA_i ),  //APBTARGEXP2PWDATA
  .DTIMERPSTRB_i        (DTIMERPSTRB_i  ),  //APBTARGEXP2PSTRB
  .DTIMERPPROT_i        (DTIMERPPROT_i  ),  //APBTARGEXP2PPROT
  .DTIMERPRDATA_o       (DTIMERPRDATA_o ),  //APBTARGEXP2PRDATA
  .DTIMERPREADY_o       (DTIMERPREADY_o ),  //APBTARGEXP2PREADY
  .DTIMERPSLVERR_o      (DTIMERPSLVERR_o),  //APBTARGEXP2PSLVERR

  //UART0
  .UART0PSEL_i          (UART0PSEL_i    ),  //APBTARGEXP4PSEL
  .UART0PENABLE_i       (UART0PENABLE_i ),  //APBTARGEXP4PENABLE
  .UART0PADDR_i         (UART0PADDR_i   ),  //APBTARGEXP4PADDR
  .UART0PWRITE_i        (UART0PWRITE_i  ),  //APBTARGEXP4PWRITE
  .UART0PWDATA_i        (UART0PWDATA_i  ),  //APBTARGEXP4PWDATA
  .UART0PSTRB_i         (UART0PSTRB_i   ),  //APBTARGEXP4PSTRB
  .UART0PPROT_i         (UART0PPROT_i   ),  //APBTARGEXP4PPROT
  .UART0PRDATA_o        (UART0PRDATA_o  ),  //APBTARGEXP4PRDATA
  .UART0PREADY_o        (UART0PREADY_o  ),  //APBTARGEXP4PREADY
  .UART0PSLVERR_o       (UART0PSLVERR_o ),  //APBTARGEXP4PSLVERR

  //UART1
  .UART1PSEL_i          (UART1PSEL_i    ),  //APBTARGEXP5PSEL
  .UART1PENABLE_i       (UART1PENABLE_i ),  //APBTARGEXP5PENABLE
  .UART1PADDR_i         (UART1PADDR_i   ),  //APBTARGEXP5PADDR
  .UART1PWRITE_i        (UART1PWRITE_i  ),  //APBTARGEXP5PWRITE
  .UART1PWDATA_i        (UART1PWDATA_i  ),  //APBTARGEXP5PWDATA
  .UART1PSTRB_i         (UART1PSTRB_i   ),  //APBTARGEXP5PSTRB
  .UART1PPROT_i         (UART1PPROT_i   ),  //APBTARGEXP5PPROT
  .UART1PRDATA_o        (UART1PRDATA_o  ),  //APBTARGEXP5PRDATA
  .UART1PREADY_o        (UART1PREADY_o  ),  //APBTARGEXP5PREADY
  .UART1PSLVERR_o       (UART1PSLVERR_o ),  //APBTARGEXP5PSLVERR

  //RTC
  .RTCPSEL_i            (RTCPSEL_i      ),  //APBTARGEXP6PSEL
  .RTCPENABLE_i         (RTCPENABLE_i   ),  //APBTARGEXP6PENABLE
  .RTCPADDR_i           (RTCPADDR_i     ),  //APBTARGEXP6PADDR
  .RTCPWRITE_i          (RTCPWRITE_i    ),  //APBTARGEXP6PWRITE
  .RTCPWDATA_i          (RTCPWDATA_i    ),  //APBTARGEXP6PWDATA
  .RTCPSTRB_i           (RTCPSTRB_i     ),  //APBTARGEXP6PSTRB
  .RTCPPROT_i           (RTCPPROT_i     ),  //APBTARGEXP6PPROT
  .RTCPRDATA_o          (RTCPRDATA_o    ),  //APBTARGEXP6PRDATA
  .RTCPREADY_o          (RTCPREADY_o    ),  //APBTARGEXP6PREADY
  .RTCPSLVERR_o         (RTCPSLVERR_o   ),  //APBTARGEXP6PSLVERR

  //W(atch)DOG
  .WDOGPSEL_i           (WDOGPSEL_i     ),  //APBTARGEXP8PSEL
  .WDOGPENABLE_i        (WDOGPENABLE_i  ),  //APBTARGEXP8PENABLE
  .WDOGPADDR_i          (WDOGPADDR_i    ),  //APBTARGEXP8PADDR
  .WDOGPWRITE_i         (WDOGPWRITE_i   ),  //APBTARGEXP8PWRITE
  .WDOGPWDATA_i         (WDOGPWDATA_i   ),  //APBTARGEXP8PWDATA
  .WDOGPSTRB_i          (WDOGPSTRB_i    ),  //APBTARGEXP8PSTRB
  .WDOGPPROT_i          (WDOGPPROT_i    ),  //APBTARGEXP8PPROT
  .WDOGPRDATA_o         (WDOGPRDATA_o   ),  //APBTARGEXP8PRDATA
  .WDOGPREADY_o         (WDOGPREADY_o   ),  //APBTARGEXP8PREADY
  .WDOGPSLVERR_o        (WDOGPSLVERR_o  ),  //APBTARGEXP8PSLVERR

  //TRNG
  .TRNGPSEL_i           (TRNGPSEL_i     ),  //APBTARGEXP15PSEL
  .TRNGPENABLE_i        (TRNGPENABLE_i  ),  //APBTARGEXP15PENABLE
  .TRNGPADDR_i          (TRNGPADDR_i    ),  //APBTARGEXP15PADDR
  .TRNGPWRITE_i         (TRNGPWRITE_i   ),  //APBTARGEXP15PWRITE
  .TRNGPWDATA_i         (TRNGPWDATA_i   ),  //APBTARGEXP15PWDATA
  .TRNGPSTRB_i          (TRNGPSTRB_i    ),  //APBTARGEXP15PSTRB
  .TRNGPPROT_i          (TRNGPPROT_i    ),  //APBTARGEXP15PPROT
  .TRNGPRDATA_o         (TRNGPRDATA_o   ),  //APBTARGEXP15PRDATA
  .TRNGPREADY_o         (TRNGPREADY_o   ),  //APBTARGEXP15PREADY
  .TRNGPSLVERR_o        (TRNGPSLVERR_o  ),  //APBTARGEXP15PSLVERR


  //-----------------------------
  //Other/Functional peripheral module specific interfaces
  //-----------------------------
  //D(ual)TIMER
  .DTIMERECOREVNUM_i    (DTIMERECOREVNUM_i),  // ECO revision number
  .DTIMERTIMCLKEN1_i    (DTIMERTIMCLKEN1_i),  // Timer clock enable 1
  .DTIMERTIMCLKEN2_i    (DTIMERTIMCLKEN2_i),  // Timer clock enable 2
  .DTIMERTIMINT1_o      (DTIMERTIMINT1_o  ),  // Counter 1 interrupt
  .DTIMERTIMINT2_o      (DTIMERTIMINT2_o  ),  // Counter 2 interrupt
  .DTIMERTIMINTC_o      (DTIMERTIMINTC_o  ),  // Counter combined interrupt

  //-----------------------------
  //UART0
  .UART0ECOREVNUM_i     (UART0ECOREVNUM_i),  // Engineering-change-order revision bits
  .UART0RXD_i           (UART0RXD_i      ),  // Serial input
  .UART0TXD_o           (UART0TXD_o      ),  // Transmit data output
  .UART0TXEN_o          (UART0TXEN_o     ),  // Transmit enabled
  .UART0BAUDTICK_o      (UART0BAUDTICK_o ),  // Baud rate (x16) Tick
  .UART0TXINT_o         (UART0TXINT_o    ),  // Transmit Interrupt
  .UART0RXINT_o         (UART0RXINT_o    ),  // Receive Interrupt
  .UART0TXOVRINT_o      (UART0TXOVRINT_o ),  // Transmit overrun Interrupt
  .UART0RXOVRINT_o      (UART0RXOVRINT_o ),  // Receive overrun Interrupt
  .UART0UARTINT_o       (UART0UARTINT_o  ),  // Combined interrupt

  //-----------------------------
  //UART1
  .UART1ECOREVNUM_i     (UART1ECOREVNUM_i),  // Engineering-change-order revision bits
  .UART1RXD_i           (UART1RXD_i      ),  // Serial input
  .UART1TXD_o           (UART1TXD_o      ),  // Transmit data output
  .UART1TXEN_o          (UART1TXEN_o     ),  // Transmit enabled
  .UART1BAUDTICK_o      (UART1BAUDTICK_o ),  // Baud rate (x16) Tick
  .UART1TXINT_o         (UART1TXINT_o    ),  // Transmit Interrupt
  .UART1RXINT_o         (UART1RXINT_o    ),  // Receive Interrupt
  .UART1TXOVRINT_o      (UART1TXOVRINT_o ),  // Transmit overrun Interrupt
  .UART1RXOVRINT_o      (UART1RXOVRINT_o ),  // Receive overrun Interrupt
  .UART1UARTINT_o       (UART1UARTINT_o  ),  // Combined interrupt

  //-----------------------------
  //RTC
  .RTCSCANENABLE_i      (RTCSCANENABLE_i   ),  // Test mode enable
  .RTCSCANINPCLK_i      (RTCSCANINPCLK_i   ),  // PCLK Scan chain input
  .RTCSCANINCLK1HZ_i    (RTCSCANINCLK1HZ_i ),  // CLK1HZ Scan chain input
  .RTCSCANOUTPCLK_o     (RTCSCANOUTPCLK_o  ),  // PCLK Scan chain output
  .RTCSCANOUTCLK1HZ_o   (RTCSCANOUTCLK1HZ_o),  // CLK1HZ Scan chain output
  .RTCRTCINTR_o         (RTCRTCINTR_o      ),  // RTC interrupt

  //----------------------------------------
  //W(atch)DOG
  .WDOGECOREVNUM_i      (WDOGECOREVNUM_i     ),  // ECO revision number
  .WDOGCLKEN_i          (WDOGCLKEN_i         ),  // Watchdog clock enable
  .WDOGINT_o            (WDOGINT_o           ),  // Watchdog interrupt
  .WDOGRES_o            (WDOGRES_o           ),  // Watchdog timeout reset

  //----------------------------------------
  //TRNG
  .TRNGSCANMODE_i       (TRNGSCANMODE_i      ),
  .TRNGINT_o            (TRNGINT_o           ),

  //----------------------------------------
  //GPIO0
  .GPIO0ECOREVNUM_i     (GPIO0ECOREVNUM_i    ),  // Engineering-change-order revision bits
  .GPIO0PORTIN_i        (GPIO0PORTIN_i       ),  // GPIO Interface input
  .GPIO0PORTOUT_o       (GPIO0PORTOUT_o      ),  // GPIO output
  .GPIO0PORTEN_o        (GPIO0PORTEN_o       ),  // GPIO output enable
  .GPIO0PORTFUNC_o      (GPIO0PORTFUNC_o     ),  // Alternate function control
  .GPIO0GPIOINT_o       (GPIO0GPIOINT_o      ),  // Interrupt output for each pin
  .GPIO0COMBINT_o       (GPIO0COMBINT_o      ),  // Combined interrupt

  //----------------------------------------
  //GPIO1
  .GPIO1ECOREVNUM_i     (GPIO1ECOREVNUM_i    ),  // Engineering-change-order revision bits
  .GPIO1PORTIN_i        (GPIO1PORTIN_i       ),  // GPIO Interface input
  .GPIO1PORTOUT_o       (GPIO1PORTOUT_o      ),  // GPIO output
  .GPIO1PORTEN_o        (GPIO1PORTEN_o       ),  // GPIO output enable
  .GPIO1PORTFUNC_o      (GPIO1PORTFUNC_o     ),  // Alternate function control
  .GPIO1GPIOINT_o       (GPIO1GPIOINT_o      ),  // Interrupt output for each pin
  .GPIO1COMBINT_o       (GPIO1COMBINT_o      ),  // Combined interrupt

  //----------------------------------------
  //GPIO2
  .GPIO2ECOREVNUM_i     (GPIO2ECOREVNUM_i    ),  // Engineering-change-order revision bits
  .GPIO2PORTIN_i        (GPIO2PORTIN_i       ),  // GPIO Interface input
  .GPIO2PORTOUT_o       (GPIO2PORTOUT_o      ),  // GPIO output
  .GPIO2PORTEN_o        (GPIO2PORTEN_o       ),  // GPIO output enable
  .GPIO2PORTFUNC_o      (GPIO2PORTFUNC_o     ),  // Alternate function control
  .GPIO2GPIOINT_o       (GPIO2GPIOINT_o      ),  // Interrupt output for each pin
  .GPIO2COMBINT_o       (GPIO2COMBINT_o      ),  // Combined interrupt

  //----------------------------------------
  //GPIO3
  .GPIO3ECOREVNUM_i     (GPIO3ECOREVNUM_i    ),  // Engineering-change-order revision bits
  .GPIO3PORTIN_i        (GPIO3PORTIN_i       ),  // GPIO Interface input
  .GPIO3PORTOUT_o       (GPIO3PORTOUT_o      ),  // GPIO output
  .GPIO3PORTEN_o        (GPIO3PORTEN_o       ),  // GPIO output enable
  .GPIO3PORTFUNC_o      (GPIO3PORTFUNC_o     ),  // Alternate function control
  .GPIO3GPIOINT_o       (GPIO3GPIOINT_o      ),  // Interrupt output for each pin
  .GPIO3COMBINT_o       (GPIO3COMBINT_o      )   // Combined interrupt
);

fpga_apb_subsystem u_fpga_ahb_to_apb_subsystem (
  .HCLK                   (AHB_CLK),
  .PCLKG                  (APB_CLK),    // Gated PCLK for bus
`ifdef CLOCK_BRIDGES
  .SCLK                   (SCLK),       // Peripheral clock
  .SCLKG                  (SCLKG),      // Gated PCLK for bus
`endif
  .HRESETN                (AHBRESETn),  // Note: Can be reset by SYSRESETREQ, watchdog
  .FPGA_NPOR              (nPOR),
  .CLK_100HZ              (CLK_100HZ),

  .HSEL                   (w_fpga_hsel),
  .HADDR                  (PERIPHHADDR_i[15:0]),
  .HTRANS                 (PERIPHHTRANS_i),
  .HSIZE                  (PERIPHHSIZE_i),
  .HPROT                  (PERIPHHPROT_i),
  .HWRITE                 (PERIPHHWRITE_i),
  .HREADY                 (PERIPHHREADYIN_i),
  .HWDATA                 (PERIPHHWDATA_i),
  .HRDATA                 (w_fpga_hrdata),
  .HRESP                  (w_fpga_hresp),
  .HREADYOUT              (w_fpga_hreadyout),

  .BUTTONS                (BUTTONS),
  .LEDS                   (LEDS),
  .FPGA_MISC              (FPGA_MISC),

  .SBCON_SDA_I0           (CLCD_SDA_I),
  .SBCON_SCL0             (CLCD_SCL),
  .SBCON_SDAOUTEN0_N      (CLCD_SDA_O_EN_n),

  .SBCON_SDA_I1           (AUDIO_SDA_I),
  .SBCON_SCL1             (AUDIO_SCL),
  .SBCON_SDAOUTEN1_N      (AUDIO_SDA_O_EN_n),

  .SBCON_SDA_I2           (SHIELD0_SDA_I),
  .SBCON_SCL2             (SHIELD0_SCL),
  .SBCON_SDAOUTEN2_N      (SHIELD0_SDA_O_EN_n),

  .SBCON_SDA_I3           (SHIELD1_SDA_I),
  .SBCON_SCL3             (SHIELD1_SCL),
  .SBCON_SDAOUTEN3_N      (SHIELD1_SDA_O_EN_n),

  .SSP0_DIN               (SPI0_DATA_IN),
  .SSP0_DOUT              (SPI0_DATA_OUT),
  .SSP0_DOUT_EN_n         (SPI0_DATA_OUT_EN_n),
  .SSP0_CLK_IN            (1'b0),                         // This used as SPI master only. No SPI clock in
  .SSP0_CLK_OUT           (SPI0_CLK_OUT),
  .SSP0_CLK_OUT_EN_n      (SPI0_CLK_OUT_EN_n),
  .SSP0_FSS_IN            (1'b0),                         // Frame select in. This used as SPI master only
  .SSP0_FSS_OUT           (SPI0_SEL),

  .SSP1_DIN               (SPI1_DATA_IN),
  .SSP1_DOUT              (SPI1_DATA_OUT),
  .SSP1_DOUT_EN_n         (SPI1_DATA_OUT_EN_n),
  .SSP1_CLK_IN            (1'b0),                         // This used as SPI master only. No SPI clock in
  .SSP1_CLK_OUT           (SPI1_CLK_OUT),
  .SSP1_CLK_OUT_EN_n      (SPI1_CLK_OUT_EN_n),
  .SSP1_FSS_IN            (1'b0),                         // Frame select in. This used as SPI master only
  .SSP1_FSS_OUT           (SPI1_SEL),

  .SSP2_DIN               (ADC_SPI2_DATA_IN),
  .SSP2_DOUT              (ADC_SPI2_DATA_OUT),
  .SSP2_DOUT_EN_n         (ADC_SPI2_DATA_OUT_EN_n),
  .SSP2_CLK_IN            (1'b0),                         // This used as SPI master only. No SPI clock in
  .SSP2_CLK_OUT           (ADC_SPI2_CLK_OUT),
  .SSP2_CLK_OUT_EN_n      (ADC_SPI2_CLK_OUT_EN_n),
  .SSP2_FSS_IN            (1'b0),                         // Frame select in. This used as SPI master only
  .SSP2_FSS_OUT           (ADC_SPI2_SEL),

  .SSP3_DIN               (SHIELD0_SPI3_DATA_IN),
  .SSP3_DOUT              (SHIELD0_SPI3_DATA_OUT),
  .SSP3_DOUT_EN_n         (SHIELD0_SPI3_DATA_OUT_EN_n),
  .SSP3_CLK_IN            (1'b0),                         // This used as SPI master only. No SPI clock in
  .SSP3_CLK_OUT           (SHIELD0_SPI3_CLK_OUT),
  .SSP3_CLK_OUT_EN_n      (SHIELD0_SPI3_CLK_OUT_EN_n),
  .SSP3_FSS_IN            (1'b0),                         // Frame select in. This used as SPI master only
  .SSP3_FSS_OUT           (SHIELD0_SPI3_SEL),

  .SSP4_DIN               (SHIELD1_SPI4_DATA_IN),
  .SSP4_DOUT              (SHIELD1_SPI4_DATA_OUT),
  .SSP4_DOUT_EN_n         (SHIELD1_SPI4_DATA_OUT_EN_n),
  .SSP4_CLK_IN            (1'b0),                         // This used as SPI master only. No SPI clock in
  .SSP4_CLK_OUT           (SHIELD1_SPI4_CLK_OUT),
  .SSP4_CLK_OUT_EN_n      (SHIELD1_SPI4_CLK_OUT_EN_n),
  .SSP4_FSS_IN            (1'b0),                         // Frame select in. This used as SPI master only
  .SSP4_FSS_OUT           (SHIELD1_SPI4_SEL),

  .AUDIO_MCLK             (AUDIO_MCLK),     // Audio codec master clock (12.288MHz)
  .AUDIO_SCLK             (AUDIO_SCLK),     // Audio interface bit clock
  .AUDIO_LRCK             (AUDIO_LRCK),     // Audio Left/Right clock
  .AUDIO_SDOUT            (AUDIO_SDOUT),    // Audio DAC data
  .AUDIO_SDIN             (AUDIO_SDIN),     // Audio ADC data
  .AUDIO_NRST             (AUDIO_NRST),     // Audio reset

  .UART2_RXD              (UART2_RXD),
  .UART2_TXD              (UART2_TXD),
  .UART2_TXEN             (UART2_TXEN),

  .UART3_RXD              (UART3_RXD),
  .UART3_TXD              (UART3_TXD),
  .UART3_TXEN             (UART3_TXEN),

  .UART4_RXD              (UART4_RXD),
  .UART4_TXD              (UART4_TXD),
  .UART4_TXEN             (UART4_TXEN),

  .spi_interrupt_o        (spi_interrupt_o),
  .spi0_interrupt_o       (spi0_interrupt_o),
  .spi1_interrupt_o       (spi1_interrupt_o),
  .spi2_interrupt_o       (spi2_interrupt_o),
  .spi3_interrupt_o       (spi3_interrupt_o),
  .spi4_interrupt_o       (spi4_interrupt_o),
  .UART_INTERRUPTS        (UART_INTERRUPTS),
  .I2S_INTERRUPT          (I2S_INTERRUPT),
  .CFGINT                 (CFGINT),

  .CFGCLK                 (CFGCLK),
  .nCFGRST                (nCFGRST),
  .CFGLOAD                (CFGLOAD),
  .CFGWnR                 (CFGWnR),
  .CFGDATAIN              (CFGDATAIN),
  .CFGDATAOUT             (CFGDATAOUT),
  .DLL_LOCKED             (DLL_LOCKED),
  .EFUSES                 (EFUSES),
  .TEST_CTRL              (TEST_CTRL)
  //.zbt_boot_ctrl          (zbt_boot_ctrl)
  );

mps2_mem_peripherals u_mps2_mem_peripherals
    (
    .ahbclk             (AHB_CLK ),    // Free running clock
    .hresetn            (AHBRESETn),   // HRESETn for system

// --------------------------------------------------------------------
// ZBT Synchronous SRAM
// --------------------------------------------------------------------

// 64-bit ZBT Synchronous SRAM1 connections
    .zbt_sram1_a        (ZBT_SRAM1_A     ),    // Address
    .zbt_sram1_dq_i     (ZBT_SRAM1_DQ_I  ),    // Data input
    .zbt_sram1_dq_o     (ZBT_SRAM1_DQ_O  ),    // Data Output
    .zbt_sram1_dq_oen   (ZBT_SRAM1_DQ_OEN),    // 3-state Buffer Enable
    .zbt_sram1_bwn      (ZBT_SRAM1_BWN   ),    // Byte lane writes (active low)
    .zbt_sram1_cen      (ZBT_SRAM1_CEN   ),    // Chip Select (active low)
    .zbt_sram1_wen      (ZBT_SRAM1_WEN   ),    // Write enable
    .zbt_sram1_oen      (ZBT_SRAM1_OEN   ),    // Output enable (active low)
    .zbt_sram1_lbon     (ZBT_SRAM1_LBON  ),    // Not used (tied to 0)
    .zbt_sram1_adv      (ZBT_SRAM1_ADV   ),    // Not used (tied to 0)
    .zbt_sram1_zz       (ZBT_SRAM1_ZZ    ),    // Not used (tied to 0)
    .zbt_sram1_cken     (ZBT_SRAM1_CKEN  ),    // Not used (tied to 0)

// 32-bit ZBT Synchronous SRAM2 connections
    .zbt_sram2_a        (ZBT_SRAM2_A     ),    // Address
    .zbt_sram2_dq_i     (ZBT_SRAM2_DQ_I  ),    // Data input
    .zbt_sram2_dq_o     (ZBT_SRAM2_DQ_O  ),    // Data Output
    .zbt_sram2_dq_oen   (ZBT_SRAM2_DQ_OEN),    // 3-state Buffer Enable
    .zbt_sram2_bwn      (ZBT_SRAM2_BWN   ),    // Byte lane writes (active low)
    .zbt_sram2_cen      (ZBT_SRAM2_CEN   ),    // Chip Select (active low)
    .zbt_sram2_wen      (ZBT_SRAM2_WEN   ),    // Write enable
    .zbt_sram2_oen      (ZBT_SRAM2_OEN   ),    // Output enable (active low)
    .zbt_sram2_lbon     (ZBT_SRAM2_LBON  ),    // Not used (tied to 0)
    .zbt_sram2_adv      (ZBT_SRAM2_ADV   ),    // Not used (tied to 0)
    .zbt_sram2_zz       (ZBT_SRAM2_ZZ    ),    // Not used (tied to 0)
    .zbt_sram2_cken     (ZBT_SRAM2_CKEN  ),    // Not used (tied to 0)

    // 32-bit ZBT Synchronous SRAM3 connections
    .zbt_sram3_a        (ZBT_SRAM3_A     ),    // Address
    .zbt_sram3_dq_i     (ZBT_SRAM3_DQ_I  ),    // Data input
    .zbt_sram3_dq_o     (ZBT_SRAM3_DQ_O  ),    // Data Output
    .zbt_sram3_dq_oen   (ZBT_SRAM3_DQ_OEN),    // 3-state Buffer Enable
    .zbt_sram3_bwn      (ZBT_SRAM3_BWN   ),    // Byte lane writes (active low)
    .zbt_sram3_cen      (ZBT_SRAM3_CEN   ),    // Chip Select (active low)
    .zbt_sram3_wen      (ZBT_SRAM3_WEN   ),    // Write enable
    .zbt_sram3_oen      (ZBT_SRAM3_OEN   ),    // Output enable (active low)
    .zbt_sram3_lbon     (ZBT_SRAM3_LBON  ),    // Not used (tied to 0)
    .zbt_sram3_adv      (ZBT_SRAM3_ADV   ),    // Not used (tied to 0)
    .zbt_sram3_zz       (ZBT_SRAM3_ZZ    ),    // Not used (tied to 0)
    .zbt_sram3_cken     (ZBT_SRAM3_CKEN  ),    // Not used (tied to 0)

    // 16-bit smb connections
    .smb_addr           (SMB_ADDR      ),    // Address
    .smb_data_i         (SMB_DATA_I    ),    // Read Data
    .smb_data_o         (SMB_DATA_O    ),    // Write Data
    .smb_data_o_nen     (SMB_DATA_O_NEN),    // Write Data 3-state ctrl
    .smb_cen            (SMB_CEN       ),    // Active low chip enable
    .smb_oen            (SMB_OEN       ),    // Active low output enable (read)
    .smb_wen            (SMB_WEN       ),    // Active low write enable
    .smb_ubn            (SMB_UBN       ),    // Active low Upper Byte Enable
    .smb_lbn            (SMB_LBN       ),    // Active low Upper Byte Enable
    .smb_nrd            (SMB_NRD       ),    // Active low read enable
    .smb_nreset         (SMB_NRESET    ),    // Active low reset

// --------------------------------------------------------------------
// VGA
// --------------------------------------------------------------------
    .vga_hsync          (VGA_HSYNC ),    // VGA H-Sync
    .vga_vsync          (VGA_VSYNC ),    // VGA V-Sync
    .vga_r              (VGA_R     ),    // VGA red data
    .vga_g              (VGA_G     ),    // VGA green data
    .vga_b              (VGA_B     ),    // VGA blue data

// --------------------------------------------------------------------
// Ethernet
// --------------------------------------------------------------------
    .SMB_ETH_IRQ_n      (SMB_ETH_IRQ_N   ),
    .eth_interrupt      (ETH_INTERRUPT   ),

// --------------------------------------------------------------------
// GPIO4
// --------------------------------------------------------------------
    .GPIO4ECOREVNUM_i    (GPIO4ECOREVNUM_i    ),  // Engineering-change-order revision bits
    .GPIO4PORTIN_i       (GPIO4PORTIN_i       ),  // GPIO Interface input
    .GPIO4PORTOUT_o      (GPIO4PORTOUT_o      ),  // GPIO output
    .GPIO4PORTEN_o       (GPIO4PORTEN_o       ),  // GPIO output enable
    .GPIO4PORTFUNC_o     (GPIO4PORTFUNC_o     ),  // Alternate function control
    .GPIO4GPIOINT_o      (GPIO4GPIOINT_o      ),  // Interrupt output for each pin
    .GPIO4COMBINT_o      (GPIO4COMBINT_o      ),  // Combined interrupt

// --------------------------------------------------------------------
// GPIO5
// --------------------------------------------------------------------
    .GPIO5ECOREVNUM_i    (GPIO5ECOREVNUM_i    ),  // Engineering-change-order revision bits
    .GPIO5PORTIN_i       (GPIO5PORTIN_i       ),  // GPIO Interface input
    .GPIO5PORTOUT_o      (GPIO5PORTOUT_o      ),  // GPIO output
    .GPIO5PORTEN_o       (GPIO5PORTEN_o       ),  // GPIO output enable
    .GPIO5PORTFUNC_o     (GPIO5PORTFUNC_o     ),  // Alternate function control
    .GPIO5GPIOINT_o      (GPIO5GPIOINT_o      ),  // Interrupt output for each pin
    .GPIO5COMBINT_o      (GPIO5COMBINT_o      ),  // Combined interrupt

// --------------------------------------------------------------------
//AHB interface
// --------------------------------------------------------------------
    .HSEL                (w_mps2_hsel),
    .HADDR               (PERIPHHADDR_i),
    .HTRANS              (PERIPHHTRANS_i),
    .HSIZE               (PERIPHHSIZE_i),
    .HPROT               (PERIPHHPROT_i),
    .HWRITE              (PERIPHHWRITE_i),
    .HREADY              (PERIPHHREADYIN_i),
    .HWDATA              (PERIPHHWDATA_i),
    .HRDATA              (w_mps2_hrdata),
    .HRESP               (w_mps2_hresp),
    .HREADYOUT           (w_mps2_hreadyout)
    );

endmodule
