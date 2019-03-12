/**************************************************************************//**
 * @file     CM3DS_MPS2.h
 * @brief    CMSIS Cortex-M3 Core Peripheral Access Layer Header File for
 *           Device CM3DS_MPS2
 * @version  V3.01
 * @date     06. March 2012
 *
 * @note
 * Copyright (C) 2010-2017 ARM Limited. All rights reserved.
 *
 * @par
 * ARM Limited (ARM) is supplying this software for use with Cortex-M
 * processor based microcontrollers.  This file can be freely distributed
 * within development tools that are supporting such ARM based processors.
 *
 * @par
 * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
 * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 *
 ******************************************************************************/


#ifndef CM3DS_MPS2_H
#define CM3DS_MPS2_H

#ifdef __cplusplus
 extern "C" {
#endif

/** @addtogroup CM3DS_MPS2_Definitions CM3DS_MPS2 Definitions
  This file defines all structures and symbols for CM3DS_MPS2:
    - registers and bitfields
    - peripheral base address
    - peripheral ID
    - Peripheral definitions
  @{
*/


/******************************************************************************/
/*                Processor and Core Peripherals                              */
/******************************************************************************/
/** @addtogroup CM3DS_MPS2_CMSIS Device CMSIS Definitions
  Configuration of the Cortex-M3 Processor and Core Peripherals
  @{
*/

/*
 * ==========================================================================
 * ---------- Interrupt Number Definition -----------------------------------
 * ==========================================================================
 */

typedef enum IRQn
{
/******  Cortex-M3 Processor Exceptions Numbers ***************************************************/
  NonMaskableInt_IRQn           = -14,    /*!<  2 Cortex-M3 Non Maskable Interrupt                        */
  HardFault_IRQn                = -13,    /*!<  3 Cortex-M3 Hard Fault Interrupt                          */
  MemoryManagement_IRQn         = -12,    /*!<  4 Cortex-M3 Memory Management Interrupt            */
  BusFault_IRQn                 = -11,    /*!<  5 Cortex-M3 Bus Fault Interrupt                    */
  UsageFault_IRQn               = -10,    /*!<  6 Cortex-M3 Usage Fault Interrupt                  */
  SVCall_IRQn                   = -5,     /*!< 11 Cortex-M3 SV Call Interrupt                      */
  DebugMonitor_IRQn             = -4,     /*!< 12 Cortex-M3 Debug Monitor Interrupt                */
  PendSV_IRQn                   = -2,     /*!< 14 Cortex-M3 Pend SV Interrupt                      */
  SysTick_IRQn                  = -1,     /*!< 15 Cortex-M3 System Tick Interrupt                  */

/******  CM3DS_MPS2 Specific Interrupt Numbers *******************************************************/
  UART0_IRQn                    = 0,       /* UART 0 RX and TX Combined Interrupt   */
  Spare1_IRQn                   = 1,       /* Undefined                             */
  UART1_IRQn                    = 2,       /* UART 1 RX and TX Combined Interrupt   */
  Spare3_IRQn                   = 3,       /* Undefined                             */
  Spare4_IRQn                   = 4,       /* Undefined                             */
  RTC_IRQn                      = 5,       /* RTC Interrupt                         */
  PORT0_ALL_IRQn                = 6,       /* GPIO Port 0 combined Interrupt        */
  PORT1_ALL_IRQn                = 7,       /* GPIO Port 1 combined Interrupt        */
  TIMER0_IRQn                   = 8,       /* TIMER 0 Interrupt                     */
  TIMER1_IRQn                   = 9,       /* TIMER 1 Interrupt                     */
  DUALTIMER_IRQn                = 10,      /* Dual Timer Interrupt                  */
  Spare11_IRQn                  = 11,      /* Undefined                             */
  UARTOVF_IRQn                  = 12,      /* UART 0,1,2,3,4 Overflow Interrupt     */
  Spare13_IRQn                  = 13,      /* Undefined                             */
  Spare14_IRQn                  = 14,      /* Undefined                             */
  TSC_IRQn                      = 15,      /* Touch Screen Interrupt                */
  PORT0_0_IRQn                  = 16,      /*!< All P0 I/O pins can be used as interrupt source. */
  PORT0_1_IRQn                  = 17,      /*!< There are 16 pins in total                       */
  PORT0_2_IRQn                  = 18,
  PORT0_3_IRQn                  = 19,
  PORT0_4_IRQn                  = 20,
  PORT0_5_IRQn                  = 21,
  PORT0_6_IRQn                  = 22,
  PORT0_7_IRQn                  = 23,
  PORT0_8_IRQn                  = 24,
  PORT0_9_IRQn                  = 25,
  PORT0_10_IRQn                 = 26,
  PORT0_11_IRQn                 = 27,
  PORT0_12_IRQn                 = 28,
  PORT0_13_IRQn                 = 29,
  PORT0_14_IRQn                 = 30,
  PORT0_15_IRQn                 = 31,
  SYSERROR_IRQn                 = 32,      /* System Error Interrupt                */
  EFLASH_IRQn                   = 33,      /* Embedded Flash Interrupt              */
  CORDIO0_IRQn                  = 34,      /* Reserved for radio                    */
  CORDIO1_IRQn                  = 35,      /* Reserved for radio                    */
  CORDIO2_IRQn                  = 36,      /* Reserved for radio                    */
  CORDIO3_IRQn                  = 37,      /* Reserved for radio                    */
  CORDIO4_IRQn                  = 38,      /* Reserved for radio                    */
  CORDIO5_IRQn                  = 39,      /* Reserved for radio                    */
  CORDIO6_IRQn                  = 40,      /* Reserved for radio                    */
  CORDIO7_IRQn                  = 41,      /* Reserved for radio                    */
  PORT2_ALL_IRQn                = 42,      /* GPIO Port 2 combined Interrupt        */
  PORT3_ALL_IRQn                = 43,      /* GPIO Port 3 combined Interrupt        */
  TRNG_IRQn                     = 44,      /* Random number generator Interrupt     */
  UART2_IRQn                    = 45,      /* UART 2 RX and TX Combined Interrupt   */
  UART3_IRQn                    = 46,      /* UART 3 RX and TX Combined Interrupt   */
  ETHERNET_IRQn                 = 47,      /* Ethernet interrupt                    */
  I2S_IRQn                      = 48,      /* I2S Interrupt                         */
  MPS2_SPI0_IRQn                = 49,      /* SPI Interrupt (spi header)            */
  MPS2_SPI1_IRQn                = 50,      /* SPI Interrupt (clcd)                  */
  MPS2_SPI2_IRQn                = 51,      /* SPI Interrupt (spi 1 ADC replacement) */
  MPS2_SPI3_IRQn                = 52,      /* SPI Interrupt (spi 0 shield 0 replacement) */
  MPS2_SPI4_IRQn                = 53,      /* SPI Interrupt  (shield 1)             */
  PORT4_ALL_IRQn                = 54,      /* GPIO Port 4 combined Interrupt        */
  PORT5_ALL_IRQn                = 55,      /* GPIO Port 5 combined Interrupt        */
  UART4_IRQn                    = 56       /* UART 4 RX and TX Combined Interrupt   */
} IRQn_Type;


/*
 * ==========================================================================
 * ----------- Processor and Core Peripheral Section ------------------------
 * ==========================================================================
 */

/* Configuration of the Cortex-M3 Processor and Core Peripherals */
#define __CM3_REV                 0x0201    /*!< Core Revision r2p1                             */
#define __NVIC_PRIO_BITS          3         /*!< Number of Bits used for Priority Levels        */
#define __Vendor_SysTickConfig    0         /*!< Set to 1 if different SysTick Config is used   */
#define __MPU_PRESENT             1         /*!< MPU present or not                             */

/*@}*/ /* end of group CM3DS_MPS2_CMSIS */


#include "core_cm3.h"                     /* Cortex-M3 processor and core peripherals           */
#include "system_CM3DS.h"             /* CM3DS System include file                      */


/******************************************************************************/
/*                Device Specific Peripheral registers structures             */
/******************************************************************************/
/** @addtogroup CM3DS_MPS2_Peripherals CM3DS_MPS2 Peripherals
  CM3DS_MPS2 Device Specific Peripheral registers structures
  @{
*/

#if defined ( __CC_ARM   )
  #pragma push
#pragma anon_unions
#elif defined(__ICCARM__)
  #pragma language=extended
#elif defined(__GNUC__)
  /* anonymous unions are enabled by default */
#elif defined(__TMS470__)
/* anonymous unions are enabled by default */
#elif defined(__TASKING__)
  #pragma warning 586
#else
  #warning Not supported compiler type
#endif

/*------------- Universal Asynchronous Receiver Transmitter (UART) -----------*/
typedef struct
{
  __IO   uint32_t  DATA;          /*!< Offset: 0x000 Data Register    (R/W) */
  __IO   uint32_t  STATE;         /*!< Offset: 0x004 Status Register  (R/W) */
  __IO   uint32_t  CTRL;          /*!< Offset: 0x008 Control Register (R/W) */
  union {
    __I    uint32_t  INTSTATUS;   /*!< Offset: 0x00C Interrupt Status Register (R/ ) */
    __O    uint32_t  INTCLEAR;    /*!< Offset: 0x00C Interrupt Clear Register ( /W) */
    };
  __IO   uint32_t  BAUDDIV;       /*!< Offset: 0x010 Baudrate Divider Register (R/W) */

} CM3DS_MPS2_UART_TypeDef;

/* CM3DS_MPS2_UART DATA Register Definitions */

#define CM3DS_MPS2_UART_DATA_Pos               0                                            /*!< CM3DS_MPS2_UART_DATA_Pos: DATA Position */
#define CM3DS_MPS2_UART_DATA_Msk              (0xFFul << CM3DS_MPS2_UART_DATA_Pos)               /*!< CM3DS_MPS2_UART DATA: DATA Mask */

#define CM3DS_MPS2_UART_STATE_RXOR_Pos         3                                            /*!< CM3DS_MPS2_UART STATE: RXOR Position */
#define CM3DS_MPS2_UART_STATE_RXOR_Msk         (0x1ul << CM3DS_MPS2_UART_STATE_RXOR_Pos)         /*!< CM3DS_MPS2_UART STATE: RXOR Mask */

#define CM3DS_MPS2_UART_STATE_TXOR_Pos         2                                            /*!< CM3DS_MPS2_UART STATE: TXOR Position */
#define CM3DS_MPS2_UART_STATE_TXOR_Msk         (0x1ul << CM3DS_MPS2_UART_STATE_TXOR_Pos)         /*!< CM3DS_MPS2_UART STATE: TXOR Mask */

#define CM3DS_MPS2_UART_STATE_RXBF_Pos         1                                            /*!< CM3DS_MPS2_UART STATE: RXBF Position */
#define CM3DS_MPS2_UART_STATE_RXBF_Msk         (0x1ul << CM3DS_MPS2_UART_STATE_RXBF_Pos)         /*!< CM3DS_MPS2_UART STATE: RXBF Mask */

#define CM3DS_MPS2_UART_STATE_TXBF_Pos         0                                            /*!< CM3DS_MPS2_UART STATE: TXBF Position */
#define CM3DS_MPS2_UART_STATE_TXBF_Msk         (0x1ul << CM3DS_MPS2_UART_STATE_TXBF_Pos )        /*!< CM3DS_MPS2_UART STATE: TXBF Mask */

#define CM3DS_MPS2_UART_CTRL_HSTM_Pos          6                                            /*!< CM3DS_MPS2_UART CTRL: HSTM Position */
#define CM3DS_MPS2_UART_CTRL_HSTM_Msk          (0x01ul << CM3DS_MPS2_UART_CTRL_HSTM_Pos)         /*!< CM3DS_MPS2_UART CTRL: HSTM Mask */

#define CM3DS_MPS2_UART_CTRL_RXORIRQEN_Pos     5                                            /*!< CM3DS_MPS2_UART CTRL: RXORIRQEN Position */
#define CM3DS_MPS2_UART_CTRL_RXORIRQEN_Msk     (0x01ul << CM3DS_MPS2_UART_CTRL_RXORIRQEN_Pos)    /*!< CM3DS_MPS2_UART CTRL: RXORIRQEN Mask */

#define CM3DS_MPS2_UART_CTRL_TXORIRQEN_Pos     4                                            /*!< CM3DS_MPS2_UART CTRL: TXORIRQEN Position */
#define CM3DS_MPS2_UART_CTRL_TXORIRQEN_Msk     (0x01ul << CM3DS_MPS2_UART_CTRL_TXORIRQEN_Pos)    /*!< CM3DS_MPS2_UART CTRL: TXORIRQEN Mask */

#define CM3DS_MPS2_UART_CTRL_RXIRQEN_Pos       3                                            /*!< CM3DS_MPS2_UART CTRL: RXIRQEN Position */
#define CM3DS_MPS2_UART_CTRL_RXIRQEN_Msk       (0x01ul << CM3DS_MPS2_UART_CTRL_RXIRQEN_Pos)      /*!< CM3DS_MPS2_UART CTRL: RXIRQEN Mask */

#define CM3DS_MPS2_UART_CTRL_TXIRQEN_Pos       2                                            /*!< CM3DS_MPS2_UART CTRL: TXIRQEN Position */
#define CM3DS_MPS2_UART_CTRL_TXIRQEN_Msk       (0x01ul << CM3DS_MPS2_UART_CTRL_TXIRQEN_Pos)      /*!< CM3DS_MPS2_UART CTRL: TXIRQEN Mask */

#define CM3DS_MPS2_UART_CTRL_RXEN_Pos          1                                            /*!< CM3DS_MPS2_UART CTRL: RXEN Position */
#define CM3DS_MPS2_UART_CTRL_RXEN_Msk          (0x01ul << CM3DS_MPS2_UART_CTRL_RXEN_Pos)         /*!< CM3DS_MPS2_UART CTRL: RXEN Mask */

#define CM3DS_MPS2_UART_CTRL_TXEN_Pos          0                                            /*!< CM3DS_MPS2_UART CTRL: TXEN Position */
#define CM3DS_MPS2_UART_CTRL_TXEN_Msk          (0x01ul << CM3DS_MPS2_UART_CTRL_TXEN_Pos)         /*!< CM3DS_MPS2_UART CTRL: TXEN Mask */

#define CM3DS_MPS2_UART_INTSTATUS_RXORIRQ_Pos  3                                            /*!< CM3DS_MPS2_UART CTRL: RXORIRQ Position */
#define CM3DS_MPS2_UART_CTRL_RXORIRQ_Msk       (0x01ul << CM3DS_MPS2_UART_INTSTATUS_RXORIRQ_Pos) /*!< CM3DS_MPS2_UART CTRL: RXORIRQ Mask */

#define CM3DS_MPS2_UART_CTRL_TXORIRQ_Pos       2                                            /*!< CM3DS_MPS2_UART CTRL: TXORIRQ Position */
#define CM3DS_MPS2_UART_CTRL_TXORIRQ_Msk       (0x01ul << CM3DS_MPS2_UART_CTRL_TXORIRQ_Pos)      /*!< CM3DS_MPS2_UART CTRL: TXORIRQ Mask */

#define CM3DS_MPS2_UART_CTRL_RXIRQ_Pos         1                                            /*!< CM3DS_MPS2_UART CTRL: RXIRQ Position */
#define CM3DS_MPS2_UART_CTRL_RXIRQ_Msk         (0x01ul << CM3DS_MPS2_UART_CTRL_RXIRQ_Pos)        /*!< CM3DS_MPS2_UART CTRL: RXIRQ Mask */

#define CM3DS_MPS2_UART_CTRL_TXIRQ_Pos         0                                            /*!< CM3DS_MPS2_UART CTRL: TXIRQ Position */
#define CM3DS_MPS2_UART_CTRL_TXIRQ_Msk         (0x01ul << CM3DS_MPS2_UART_CTRL_TXIRQ_Pos)        /*!< CM3DS_MPS2_UART CTRL: TXIRQ Mask */

#define CM3DS_MPS2_UART_BAUDDIV_Pos            0                                            /*!< CM3DS_MPS2_UART BAUDDIV: BAUDDIV Position */
#define CM3DS_MPS2_UART_BAUDDIV_Msk            (0xFFFFFul << CM3DS_MPS2_UART_BAUDDIV_Pos)        /*!< CM3DS_MPS2_UART BAUDDIV: BAUDDIV Mask */


/*----------------------------- Timer (TIMER) -------------------------------*/
typedef struct
{
  __IO   uint32_t  CTRL;          /*!< Offset: 0x000 Control Register (R/W) */
  __IO   uint32_t  VALUE;         /*!< Offset: 0x004 Current Value Register (R/W) */
  __IO   uint32_t  RELOAD;        /*!< Offset: 0x008 Reload Value Register  (R/W) */
  union {
    __I    uint32_t  INTSTATUS;   /*!< Offset: 0x00C Interrupt Status Register (R/ ) */
    __O    uint32_t  INTCLEAR;    /*!< Offset: 0x00C Interrupt Clear Register ( /W) */
    };

} CM3DS_MPS2_TIMER_TypeDef;

/* CM3DS_MPS2_TIMER CTRL Register Definitions */

#define CM3DS_MPS2_TIMER_CTRL_IRQEN_Pos          3                                              /*!< CM3DS_MPS2_TIMER CTRL: IRQEN Position */
#define CM3DS_MPS2_TIMER_CTRL_IRQEN_Msk          (0x01ul << CM3DS_MPS2_TIMER_CTRL_IRQEN_Pos)         /*!< CM3DS_MPS2_TIMER CTRL: IRQEN Mask */

#define CM3DS_MPS2_TIMER_CTRL_SELEXTCLK_Pos      2                                              /*!< CM3DS_MPS2_TIMER CTRL: SELEXTCLK Position */
#define CM3DS_MPS2_TIMER_CTRL_SELEXTCLK_Msk      (0x01ul << CM3DS_MPS2_TIMER_CTRL_SELEXTCLK_Pos)     /*!< CM3DS_MPS2_TIMER CTRL: SELEXTCLK Mask */

#define CM3DS_MPS2_TIMER_CTRL_SELEXTEN_Pos       1                                              /*!< CM3DS_MPS2_TIMER CTRL: SELEXTEN Position */
#define CM3DS_MPS2_TIMER_CTRL_SELEXTEN_Msk       (0x01ul << CM3DS_MPS2_TIMER_CTRL_SELEXTEN_Pos)      /*!< CM3DS_MPS2_TIMER CTRL: SELEXTEN Mask */

#define CM3DS_MPS2_TIMER_CTRL_EN_Pos             0                                              /*!< CM3DS_MPS2_TIMER CTRL: EN Position */
#define CM3DS_MPS2_TIMER_CTRL_EN_Msk             (0x01ul << CM3DS_MPS2_TIMER_CTRL_EN_Pos)            /*!< CM3DS_MPS2_TIMER CTRL: EN Mask */

#define CM3DS_MPS2_TIMER_VAL_CURRENT_Pos         0                                              /*!< CM3DS_MPS2_TIMER VALUE: CURRENT Position */
#define CM3DS_MPS2_TIMER_VAL_CURRENT_Msk         (0xFFFFFFFFul << CM3DS_MPS2_TIMER_VAL_CURRENT_Pos)  /*!< CM3DS_MPS2_TIMER VALUE: CURRENT Mask */

#define CM3DS_MPS2_TIMER_RELOAD_VAL_Pos          0                                              /*!< CM3DS_MPS2_TIMER RELOAD: RELOAD Position */
#define CM3DS_MPS2_TIMER_RELOAD_VAL_Msk          (0xFFFFFFFFul << CM3DS_MPS2_TIMER_RELOAD_VAL_Pos)   /*!< CM3DS_MPS2_TIMER RELOAD: RELOAD Mask */

#define CM3DS_MPS2_TIMER_INTSTATUS_Pos           0                                              /*!< CM3DS_MPS2_TIMER INTSTATUS: INTSTATUSPosition */
#define CM3DS_MPS2_TIMER_INTSTATUS_Msk           (0x01ul << CM3DS_MPS2_TIMER_INTSTATUS_Pos)          /*!< CM3DS_MPS2_TIMER INTSTATUS: INTSTATUSMask */

#define CM3DS_MPS2_TIMER_INTCLEAR_Pos            0                                              /*!< CM3DS_MPS2_TIMER INTCLEAR: INTCLEAR Position */
#define CM3DS_MPS2_TIMER_INTCLEAR_Msk            (0x01ul << CM3DS_MPS2_TIMER_INTCLEAR_Pos)           /*!< CM3DS_MPS2_TIMER INTCLEAR: INTCLEAR Mask */


/*------------- Timer (TIM) --------------------------------------------------*/
typedef struct
{
  __IO uint32_t Timer1Load;                  /* Offset: 0x000 (R/W) Timer 1 Load */
  __I  uint32_t Timer1Value;                 /* Offset: 0x004 (R/ ) Timer 1 Counter Current Value */
  __IO uint32_t Timer1Control;               /* Offset: 0x008 (R/W) Timer 1 Control */
  __O  uint32_t Timer1IntClr;                /* Offset: 0x00C ( /W) Timer 1 Interrupt Clear */
  __I  uint32_t Timer1RIS;                   /* Offset: 0x010 (R/ ) Timer 1 Raw Interrupt Status */
  __I  uint32_t Timer1MIS;                   /* Offset: 0x014 (R/ ) Timer 1 Masked Interrupt Status */
  __IO uint32_t Timer1BGLoad;                /* Offset: 0x018 (R/W) Background Load Register */
       uint32_t RESERVED0;
  __IO uint32_t Timer2Load;                  /* Offset: 0x020 (R/W) Timer 2 Load */
  __I  uint32_t Timer2Value;                 /* Offset: 0x024 (R/ ) Timer 2 Counter Current Value */
  __IO uint32_t Timer2Control;               /* Offset: 0x028 (R/W) Timer 2 Control */
  __O  uint32_t Timer2IntClr;                /* Offset: 0x02C ( /W) Timer 2 Interrupt Clear */
  __I  uint32_t Timer2RIS;                   /* Offset: 0x030 (R/ ) Timer 2 Raw Interrupt Status */
  __I  uint32_t Timer2MIS;                   /* Offset: 0x034 (R/ ) Timer 2 Masked Interrupt Status */
  __IO uint32_t Timer2BGLoad;                /* Offset: 0x038 (R/W) Background Load Register */
       uint32_t RESERVED1[945];
  __IO uint32_t ITCR;                        /* Offset: 0xF00 (R/W) Integration Test Control Register */
  __O  uint32_t ITOP;                        /* Offset: 0xF04 ( /W) Integration Test Output Set Register */
} CM3DS_MPS2_DUALTIMER_BOTH_TypeDef;

#define CM3DS_MPS2_DUALTIMER1_LOAD_Pos            0                                                /* CM3DS_MPS2_DUALTIMER1 LOAD: LOAD Position */
#define CM3DS_MPS2_DUALTIMER1_LOAD_Msk            (0xFFFFFFFFul << CM3DS_MPS2_DUALTIMER1_LOAD_Pos)      /* CM3DS_MPS2_DUALTIMER1 LOAD: LOAD Mask */

#define CM3DS_MPS2_DUALTIMER1_VALUE_Pos           0                                                /* CM3DS_MPS2_DUALTIMER1 VALUE: VALUE Position */
#define CM3DS_MPS2_DUALTIMER1_VALUE_Msk           (0xFFFFFFFFul << CM3DS_MPS2_DUALTIMER1_VALUE_Pos)     /* CM3DS_MPS2_DUALTIMER1 VALUE: VALUE Mask */

#define CM3DS_MPS2_DUALTIMER1_CTRL_EN_Pos         7                                                /* CM3DS_MPS2_DUALTIMER1 CTRL_EN: CTRL Enable Position */
#define CM3DS_MPS2_DUALTIMER1_CTRL_EN_Msk         (0x1ul << CM3DS_MPS2_DUALTIMER1_CTRL_EN_Pos)          /* CM3DS_MPS2_DUALTIMER1 CTRL_EN: CTRL Enable Mask */

#define CM3DS_MPS2_DUALTIMER1_CTRL_MODE_Pos       6                                                /* CM3DS_MPS2_DUALTIMER1 CTRL_MODE: CTRL MODE Position */
#define CM3DS_MPS2_DUALTIMER1_CTRL_MODE_Msk       (0x1ul << CM3DS_MPS2_DUALTIMER1_CTRL_MODE_Pos)        /* CM3DS_MPS2_DUALTIMER1 CTRL_MODE: CTRL MODE Mask */

#define CM3DS_MPS2_DUALTIMER1_CTRL_INTEN_Pos      5                                                /* CM3DS_MPS2_DUALTIMER1 CTRL_INTEN: CTRL Int Enable Position */
#define CM3DS_MPS2_DUALTIMER1_CTRL_INTEN_Msk      (0x1ul << CM3DS_MPS2_DUALTIMER1_CTRL_INTEN_Pos)       /* CM3DS_MPS2_DUALTIMER1 CTRL_INTEN: CTRL Int Enable Mask */

#define CM3DS_MPS2_DUALTIMER1_CTRL_PRESCALE_Pos   2                                                /* CM3DS_MPS2_DUALTIMER1 CTRL_PRESCALE: CTRL PRESCALE Position */
#define CM3DS_MPS2_DUALTIMER1_CTRL_PRESCALE_Msk   (0x3ul << CM3DS_MPS2_DUALTIMER1_CTRL_PRESCALE_Pos)    /* CM3DS_MPS2_DUALTIMER1 CTRL_PRESCALE: CTRL PRESCALE Mask */

#define CM3DS_MPS2_DUALTIMER1_CTRL_SIZE_Pos       1                                                /* CM3DS_MPS2_DUALTIMER1 CTRL_SIZE: CTRL SIZE Position */
#define CM3DS_MPS2_DUALTIMER1_CTRL_SIZE_Msk       (0x1ul << CM3DS_MPS2_DUALTIMER1_CTRL_SIZE_Pos)        /* CM3DS_MPS2_DUALTIMER1 CTRL_SIZE: CTRL SIZE Mask */

#define CM3DS_MPS2_DUALTIMER1_CTRL_ONESHOOT_Pos   0                                                /* CM3DS_MPS2_DUALTIMER1 CTRL_ONESHOOT: CTRL ONESHOOT Position */
#define CM3DS_MPS2_DUALTIMER1_CTRL_ONESHOOT_Msk   (0x1ul << CM3DS_MPS2_DUALTIMER1_CTRL_ONESHOOT_Pos)    /* CM3DS_MPS2_DUALTIMER1 CTRL_ONESHOOT: CTRL ONESHOOT Mask */

#define CM3DS_MPS2_DUALTIMER1_INTCLR_Pos          0                                                /* CM3DS_MPS2_DUALTIMER1 INTCLR: INT Clear Position */
#define CM3DS_MPS2_DUALTIMER1_INTCLR_Msk          (0x1ul << CM3DS_MPS2_DUALTIMER1_INTCLR_Pos)           /* CM3DS_MPS2_DUALTIMER1 INTCLR: INT Clear  Mask */

#define CM3DS_MPS2_DUALTIMER1_RAWINTSTAT_Pos      0                                                /* CM3DS_MPS2_DUALTIMER1 RAWINTSTAT: Raw Int Status Position */
#define CM3DS_MPS2_DUALTIMER1_RAWINTSTAT_Msk      (0x1ul << CM3DS_MPS2_DUALTIMER1_RAWINTSTAT_Pos)       /* CM3DS_MPS2_DUALTIMER1 RAWINTSTAT: Raw Int Status Mask */

#define CM3DS_MPS2_DUALTIMER1_MASKINTSTAT_Pos     0                                                /* CM3DS_MPS2_DUALTIMER1 MASKINTSTAT: Mask Int Status Position */
#define CM3DS_MPS2_DUALTIMER1_MASKINTSTAT_Msk     (0x1ul << CM3DS_MPS2_DUALTIMER1_MASKINTSTAT_Pos)      /* CM3DS_MPS2_DUALTIMER1 MASKINTSTAT: Mask Int Status Mask */

#define CM3DS_MPS2_DUALTIMER1_BGLOAD_Pos          0                                                /* CM3DS_MPS2_DUALTIMER1 BGLOAD: Background Load Position */
#define CM3DS_MPS2_DUALTIMER1_BGLOAD_Msk          (0xFFFFFFFFul << CM3DS_MPS2_DUALTIMER1_BGLOAD_Pos)    /* CM3DS_MPS2_DUALTIMER1 BGLOAD: Background Load Mask */

#define CM3DS_MPS2_DUALTIMER2_LOAD_Pos            0                                                /* CM3DS_MPS2_DUALTIMER2 LOAD: LOAD Position */
#define CM3DS_MPS2_DUALTIMER2_LOAD_Msk            (0xFFFFFFFFul << CM3DS_MPS2_DUALTIMER2_LOAD_Pos)      /* CM3DS_MPS2_DUALTIMER2 LOAD: LOAD Mask */

#define CM3DS_MPS2_DUALTIMER2_VALUE_Pos           0                                                /* CM3DS_MPS2_DUALTIMER2 VALUE: VALUE Position */
#define CM3DS_MPS2_DUALTIMER2_VALUE_Msk           (0xFFFFFFFFul << CM3DS_MPS2_DUALTIMER2_VALUE_Pos)     /* CM3DS_MPS2_DUALTIMER2 VALUE: VALUE Mask */

#define CM3DS_MPS2_DUALTIMER2_CTRL_EN_Pos         7                                                /* CM3DS_MPS2_DUALTIMER2 CTRL_EN: CTRL Enable Position */
#define CM3DS_MPS2_DUALTIMER2_CTRL_EN_Msk         (0x1ul << CM3DS_MPS2_DUALTIMER2_CTRL_EN_Pos)          /* CM3DS_MPS2_DUALTIMER2 CTRL_EN: CTRL Enable Mask */

#define CM3DS_MPS2_DUALTIMER2_CTRL_MODE_Pos       6                                                /* CM3DS_MPS2_DUALTIMER2 CTRL_MODE: CTRL MODE Position */
#define CM3DS_MPS2_DUALTIMER2_CTRL_MODE_Msk       (0x1ul << CM3DS_MPS2_DUALTIMER2_CTRL_MODE_Pos)        /* CM3DS_MPS2_DUALTIMER2 CTRL_MODE: CTRL MODE Mask */

#define CM3DS_MPS2_DUALTIMER2_CTRL_INTEN_Pos      5                                                /* CM3DS_MPS2_DUALTIMER2 CTRL_INTEN: CTRL Int Enable Position */
#define CM3DS_MPS2_DUALTIMER2_CTRL_INTEN_Msk      (0x1ul << CM3DS_MPS2_DUALTIMER2_CTRL_INTEN_Pos)       /* CM3DS_MPS2_DUALTIMER2 CTRL_INTEN: CTRL Int Enable Mask */

#define CM3DS_MPS2_DUALTIMER2_CTRL_PRESCALE_Pos   2                                                /* CM3DS_MPS2_DUALTIMER2 CTRL_PRESCALE: CTRL PRESCALE Position */
#define CM3DS_MPS2_DUALTIMER2_CTRL_PRESCALE_Msk   (0x3ul << CM3DS_MPS2_DUALTIMER2_CTRL_PRESCALE_Pos)    /* CM3DS_MPS2_DUALTIMER2 CTRL_PRESCALE: CTRL PRESCALE Mask */

#define CM3DS_MPS2_DUALTIMER2_CTRL_SIZE_Pos       1                                                /* CM3DS_MPS2_DUALTIMER2 CTRL_SIZE: CTRL SIZE Position */
#define CM3DS_MPS2_DUALTIMER2_CTRL_SIZE_Msk       (0x1ul << CM3DS_MPS2_DUALTIMER2_CTRL_SIZE_Pos)        /* CM3DS_MPS2_DUALTIMER2 CTRL_SIZE: CTRL SIZE Mask */

#define CM3DS_MPS2_DUALTIMER2_CTRL_ONESHOOT_Pos   0                                                /* CM3DS_MPS2_DUALTIMER2 CTRL_ONESHOOT: CTRL ONESHOOT Position */
#define CM3DS_MPS2_DUALTIMER2_CTRL_ONESHOOT_Msk   (0x1ul << CM3DS_MPS2_DUALTIMER2_CTRL_ONESHOOT_Pos)    /* CM3DS_MPS2_DUALTIMER2 CTRL_ONESHOOT: CTRL ONESHOOT Mask */

#define CM3DS_MPS2_DUALTIMER2_INTCLR_Pos          0                                                /* CM3DS_MPS2_DUALTIMER2 INTCLR: INT Clear Position */
#define CM3DS_MPS2_DUALTIMER2_INTCLR_Msk          (0x1ul << CM3DS_MPS2_DUALTIMER2_INTCLR_Pos)           /* CM3DS_MPS2_DUALTIMER2 INTCLR: INT Clear  Mask */

#define CM3DS_MPS2_DUALTIMER2_RAWINTSTAT_Pos      0                                                /* CM3DS_MPS2_DUALTIMER2 RAWINTSTAT: Raw Int Status Position */
#define CM3DS_MPS2_DUALTIMER2_RAWINTSTAT_Msk      (0x1ul << CM3DS_MPS2_DUALTIMER2_RAWINTSTAT_Pos)       /* CM3DS_MPS2_DUALTIMER2 RAWINTSTAT: Raw Int Status Mask */

#define CM3DS_MPS2_DUALTIMER2_MASKINTSTAT_Pos     0                                                /* CM3DS_MPS2_DUALTIMER2 MASKINTSTAT: Mask Int Status Position */
#define CM3DS_MPS2_DUALTIMER2_MASKINTSTAT_Msk     (0x1ul << CM3DS_MPS2_DUALTIMER2_MASKINTSTAT_Pos)      /* CM3DS_MPS2_DUALTIMER2 MASKINTSTAT: Mask Int Status Mask */

#define CM3DS_MPS2_DUALTIMER2_BGLOAD_Pos          0                                                /* CM3DS_MPS2_DUALTIMER2 BGLOAD: Background Load Position */
#define CM3DS_MPS2_DUALTIMER2_BGLOAD_Msk          (0xFFFFFFFFul << CM3DS_MPS2_DUALTIMER2_BGLOAD_Pos)    /* CM3DS_MPS2_DUALTIMER2 BGLOAD: Background Load Mask */


typedef struct
{
  __IO uint32_t TimerLoad;                   /* Offset: 0x000 (R/W) Timer Load */
  __I  uint32_t TimerValue;                  /* Offset: 0x000 (R/W) Timer Counter Current Value */
  __IO uint32_t TimerControl;                /* Offset: 0x000 (R/W) Timer Control */
  __O  uint32_t TimerIntClr;                 /* Offset: 0x000 (R/W) Timer Interrupt Clear */
  __I  uint32_t TimerRIS;                    /* Offset: 0x000 (R/W) Timer Raw Interrupt Status */
  __I  uint32_t TimerMIS;                    /* Offset: 0x000 (R/W) Timer Masked Interrupt Status */
  __IO uint32_t TimerBGLoad;                 /* Offset: 0x000 (R/W) Background Load Register */
} CM3DS_MPS2_DUALTIMER_SINGLE_TypeDef;

#define CM3DS_MPS2_DUALTIMER_LOAD_Pos             0                                               /* CM3DS_MPS2_DUALTIMER LOAD: LOAD Position */
#define CM3DS_MPS2_DUALTIMER_LOAD_Msk             (0xFFFFFFFFul << CM3DS_MPS2_DUALTIMER_LOAD_Pos)      /* CM3DS_MPS2_DUALTIMER LOAD: LOAD Mask */

#define CM3DS_MPS2_DUALTIMER_VALUE_Pos            0                                               /* CM3DS_MPS2_DUALTIMER VALUE: VALUE Position */
#define CM3DS_MPS2_DUALTIMER_VALUE_Msk            (0xFFFFFFFFul << CM3DS_MPS2_DUALTIMER_VALUE_Pos)     /* CM3DS_MPS2_DUALTIMER VALUE: VALUE Mask */

#define CM3DS_MPS2_DUALTIMER_CTRL_EN_Pos          7                                               /* CM3DS_MPS2_DUALTIMER CTRL_EN: CTRL Enable Position */
#define CM3DS_MPS2_DUALTIMER_CTRL_EN_Msk          (0x1ul << CM3DS_MPS2_DUALTIMER_CTRL_EN_Pos)          /* CM3DS_MPS2_DUALTIMER CTRL_EN: CTRL Enable Mask */

#define CM3DS_MPS2_DUALTIMER_CTRL_MODE_Pos        6                                               /* CM3DS_MPS2_DUALTIMER CTRL_MODE: CTRL MODE Position */
#define CM3DS_MPS2_DUALTIMER_CTRL_MODE_Msk        (0x1ul << CM3DS_MPS2_DUALTIMER_CTRL_MODE_Pos)        /* CM3DS_MPS2_DUALTIMER CTRL_MODE: CTRL MODE Mask */

#define CM3DS_MPS2_DUALTIMER_CTRL_INTEN_Pos       5                                               /* CM3DS_MPS2_DUALTIMER CTRL_INTEN: CTRL Int Enable Position */
#define CM3DS_MPS2_DUALTIMER_CTRL_INTEN_Msk       (0x1ul << CM3DS_MPS2_DUALTIMER_CTRL_INTEN_Pos)       /* CM3DS_MPS2_DUALTIMER CTRL_INTEN: CTRL Int Enable Mask */

#define CM3DS_MPS2_DUALTIMER_CTRL_PRESCALE_Pos    2                                               /* CM3DS_MPS2_DUALTIMER CTRL_PRESCALE: CTRL PRESCALE Position */
#define CM3DS_MPS2_DUALTIMER_CTRL_PRESCALE_Msk    (0x3ul << CM3DS_MPS2_DUALTIMER_CTRL_PRESCALE_Pos)    /* CM3DS_MPS2_DUALTIMER CTRL_PRESCALE: CTRL PRESCALE Mask */

#define CM3DS_MPS2_DUALTIMER_CTRL_SIZE_Pos        1                                               /* CM3DS_MPS2_DUALTIMER CTRL_SIZE: CTRL SIZE Position */
#define CM3DS_MPS2_DUALTIMER_CTRL_SIZE_Msk        (0x1ul << CM3DS_MPS2_DUALTIMER_CTRL_SIZE_Pos)        /* CM3DS_MPS2_DUALTIMER CTRL_SIZE: CTRL SIZE Mask */

#define CM3DS_MPS2_DUALTIMER_CTRL_ONESHOOT_Pos    0                                               /* CM3DS_MPS2_DUALTIMER CTRL_ONESHOOT: CTRL ONESHOOT Position */
#define CM3DS_MPS2_DUALTIMER_CTRL_ONESHOOT_Msk    (0x1ul << CM3DS_MPS2_DUALTIMER_CTRL_ONESHOOT_Pos)    /* CM3DS_MPS2_DUALTIMER CTRL_ONESHOOT: CTRL ONESHOOT Mask */

#define CM3DS_MPS2_DUALTIMER_INTCLR_Pos           0                                               /* CM3DS_MPS2_DUALTIMER INTCLR: INT Clear Position */
#define CM3DS_MPS2_DUALTIMER_INTCLR_Msk           (0x1ul << CM3DS_MPS2_DUALTIMER_INTCLR_Pos)           /* CM3DS_MPS2_DUALTIMER INTCLR: INT Clear  Mask */

#define CM3DS_MPS2_DUALTIMER_RAWINTSTAT_Pos       0                                               /* CM3DS_MPS2_DUALTIMER RAWINTSTAT: Raw Int Status Position */
#define CM3DS_MPS2_DUALTIMER_RAWINTSTAT_Msk       (0x1ul << CM3DS_MPS2_DUALTIMER_RAWINTSTAT_Pos)       /* CM3DS_MPS2_DUALTIMER RAWINTSTAT: Raw Int Status Mask */

#define CM3DS_MPS2_DUALTIMER_MASKINTSTAT_Pos      0                                               /* CM3DS_MPS2_DUALTIMER MASKINTSTAT: Mask Int Status Position */
#define CM3DS_MPS2_DUALTIMER_MASKINTSTAT_Msk      (0x1ul << CM3DS_MPS2_DUALTIMER_MASKINTSTAT_Pos)      /* CM3DS_MPS2_DUALTIMER MASKINTSTAT: Mask Int Status Mask */

#define CM3DS_MPS2_DUALTIMER_BGLOAD_Pos           0                                               /* CM3DS_MPS2_DUALTIMER BGLOAD: Background Load Position */
#define CM3DS_MPS2_DUALTIMER_BGLOAD_Msk           (0xFFFFFFFFul << CM3DS_MPS2_DUALTIMER_BGLOAD_Pos)    /* CM3DS_MPS2_DUALTIMER BGLOAD: Background Load Mask */

/*-------------------- General Purpose Input Output (GPIO) -------------------*/
typedef struct
{
  __IO   uint32_t  DATA;                     /* Offset: 0x000 (R/W) DATA Register */
  __IO   uint32_t  DATAOUT;                  /* Offset: 0x004 (R/W) Data Output Latch Register */
         uint32_t  RESERVED0[2];
  __IO   uint32_t  OUTENABLESET;             /* Offset: 0x010 (R/W) Output Enable Set Register */
  __IO   uint32_t  OUTENABLECLR;             /* Offset: 0x014 (R/W) Output Enable Clear Register */
  __IO   uint32_t  ALTFUNCSET;               /* Offset: 0x018 (R/W) Alternate Function Set Register */
  __IO   uint32_t  ALTFUNCCLR;               /* Offset: 0x01C (R/W) Alternate Function Clear Register */
  __IO   uint32_t  INTENSET;                 /* Offset: 0x020 (R/W) Interrupt Enable Set Register */
  __IO   uint32_t  INTENCLR;                 /* Offset: 0x024 (R/W) Interrupt Enable Clear Register */
  __IO   uint32_t  INTTYPESET;               /* Offset: 0x028 (R/W) Interrupt Type Set Register */
  __IO   uint32_t  INTTYPECLR;               /* Offset: 0x02C (R/W) Interrupt Type Clear Register */
  __IO   uint32_t  INTPOLSET;                /* Offset: 0x030 (R/W) Interrupt Polarity Set Register */
  __IO   uint32_t  INTPOLCLR;                /* Offset: 0x034 (R/W) Interrupt Polarity Clear Register */
  union {
    __I    uint32_t  INTSTATUS;              /* Offset: 0x038 (R/ ) Interrupt Status Register */
    __O    uint32_t  INTCLEAR;               /* Offset: 0x038 ( /W) Interrupt Clear Register */
    };
         uint32_t RESERVED1[241];
  __IO   uint32_t LB_MASKED[256];            /* Offset: 0x400 - 0x7FC Lower byte Masked Access Register (R/W) */
  __IO   uint32_t UB_MASKED[256];            /* Offset: 0x800 - 0xBFC Upper byte Masked Access Register (R/W) */
} CM3DS_MPS2_GPIO_TypeDef;

#define CM3DS_MPS2_GPIO_DATA_Pos            0                                          /* CM3DS_MPS2_GPIO DATA: DATA Position */
#define CM3DS_MPS2_GPIO_DATA_Msk            (0xFFFFul << CM3DS_MPS2_GPIO_DATA_Pos)          /* CM3DS_MPS2_GPIO DATA: DATA Mask */

#define CM3DS_MPS2_GPIO_DATAOUT_Pos         0                                          /* CM3DS_MPS2_GPIO DATAOUT: DATAOUT Position */
#define CM3DS_MPS2_GPIO_DATAOUT_Msk         (0xFFFFul << CM3DS_MPS2_GPIO_DATAOUT_Pos)       /* CM3DS_MPS2_GPIO DATAOUT: DATAOUT Mask */

#define CM3DS_MPS2_GPIO_OUTENSET_Pos        0                                          /* CM3DS_MPS2_GPIO OUTEN: OUTEN Position */
#define CM3DS_MPS2_GPIO_OUTENSET_Msk        (0xFFFFul << CM3DS_MPS2_GPIO_OUTEN_Pos)         /* CM3DS_MPS2_GPIO OUTEN: OUTEN Mask */

#define CM3DS_MPS2_GPIO_OUTENCLR_Pos        0                                          /* CM3DS_MPS2_GPIO OUTEN: OUTEN Position */
#define CM3DS_MPS2_GPIO_OUTENCLR_Msk        (0xFFFFul << CM3DS_MPS2_GPIO_OUTEN_Pos)         /* CM3DS_MPS2_GPIO OUTEN: OUTEN Mask */

#define CM3DS_MPS2_GPIO_ALTFUNCSET_Pos      0                                          /* CM3DS_MPS2_GPIO ALTFUNC: ALTFUNC Position */
#define CM3DS_MPS2_GPIO_ALTFUNCSET_Msk      (0xFFFFul << CM3DS_MPS2_GPIO_ALTFUNC_Pos)       /* CM3DS_MPS2_GPIO ALTFUNC: ALTFUNC Mask */

#define CM3DS_MPS2_GPIO_ALTFUNCCLR_Pos      0                                          /* CM3DS_MPS2_GPIO ALTFUNC: ALTFUNC Position */
#define CM3DS_MPS2_GPIO_ALTFUNCCLR_Msk      (0xFFFFul << CM3DS_MPS2_GPIO_ALTFUNC_Pos)       /* CM3DS_MPS2_GPIO ALTFUNC: ALTFUNC Mask */

#define CM3DS_MPS2_GPIO_INTENSET_Pos        0                                          /* CM3DS_MPS2_GPIO INTEN: INTEN Position */
#define CM3DS_MPS2_GPIO_INTENSET_Msk        (0xFFFFul << CM3DS_MPS2_GPIO_INTEN_Pos)         /* CM3DS_MPS2_GPIO INTEN: INTEN Mask */

#define CM3DS_MPS2_GPIO_INTENCLR_Pos        0                                          /* CM3DS_MPS2_GPIO INTEN: INTEN Position */
#define CM3DS_MPS2_GPIO_INTENCLR_Msk        (0xFFFFul << CM3DS_MPS2_GPIO_INTEN_Pos)         /* CM3DS_MPS2_GPIO INTEN: INTEN Mask */

#define CM3DS_MPS2_GPIO_INTTYPESET_Pos      0                                          /* CM3DS_MPS2_GPIO INTTYPE: INTTYPE Position */
#define CM3DS_MPS2_GPIO_INTTYPESET_Msk      (0xFFFFul << CM3DS_MPS2_GPIO_INTTYPE_Pos)       /* CM3DS_MPS2_GPIO INTTYPE: INTTYPE Mask */

#define CM3DS_MPS2_GPIO_INTTYPECLR_Pos      0                                          /* CM3DS_MPS2_GPIO INTTYPE: INTTYPE Position */
#define CM3DS_MPS2_GPIO_INTTYPECLR_Msk      (0xFFFFul << CM3DS_MPS2_GPIO_INTTYPE_Pos)       /* CM3DS_MPS2_GPIO INTTYPE: INTTYPE Mask */

#define CM3DS_MPS2_GPIO_INTPOLSET_Pos       0                                          /* CM3DS_MPS2_GPIO INTPOL: INTPOL Position */
#define CM3DS_MPS2_GPIO_INTPOLSET_Msk       (0xFFFFul << CM3DS_MPS2_GPIO_INTPOL_Pos)        /* CM3DS_MPS2_GPIO INTPOL: INTPOL Mask */

#define CM3DS_MPS2_GPIO_INTPOLCLR_Pos       0                                          /* CM3DS_MPS2_GPIO INTPOL: INTPOL Position */
#define CM3DS_MPS2_GPIO_INTPOLCLR_Msk       (0xFFFFul << CM3DS_MPS2_GPIO_INTPOL_Pos)        /* CM3DS_MPS2_GPIO INTPOL: INTPOL Mask */

#define CM3DS_MPS2_GPIO_INTSTATUS_Pos       0                                          /* CM3DS_MPS2_GPIO INTSTATUS: INTSTATUS Position */
#define CM3DS_MPS2_GPIO_INTSTATUS_Msk       (0xFFul << CM3DS_MPS2_GPIO_INTSTATUS_Pos)       /* CM3DS_MPS2_GPIO INTSTATUS: INTSTATUS Mask */

#define CM3DS_MPS2_GPIO_INTCLEAR_Pos        0                                          /* CM3DS_MPS2_GPIO INTCLEAR: INTCLEAR Position */
#define CM3DS_MPS2_GPIO_INTCLEAR_Msk        (0xFFul << CM3DS_MPS2_GPIO_INTCLEAR_Pos)        /* CM3DS_MPS2_GPIO INTCLEAR: INTCLEAR Mask */

#define CM3DS_MPS2_GPIO_MASKLOWBYTE_Pos     0                                          /* CM3DS_MPS2_GPIO MASKLOWBYTE: MASKLOWBYTE Position */
#define CM3DS_MPS2_GPIO_MASKLOWBYTE_Msk     (0x00FFul << CM3DS_MPS2_GPIO_MASKLOWBYTE_Pos)   /* CM3DS_MPS2_GPIO MASKLOWBYTE: MASKLOWBYTE Mask */

#define CM3DS_MPS2_GPIO_MASKHIGHBYTE_Pos    0                                          /* CM3DS_MPS2_GPIO MASKHIGHBYTE: MASKHIGHBYTE Position */
#define CM3DS_MPS2_GPIO_MASKHIGHBYTE_Msk    (0xFF00ul << CM3DS_MPS2_GPIO_MASKHIGHBYTE_Pos)  /* CM3DS_MPS2_GPIO MASKHIGHBYTE: MASKHIGHBYTE Mask */

/*------------- System Control (SYSCON) --------------------------------------*/
typedef struct
{
  __IO   uint32_t  REMAP;                    /* Offset: 0x000 (R/W) Remap Control Register */
  __IO   uint32_t  PMUCTRL;                  /* Offset: 0x004 (R/W) PMU Control Register */
  __IO   uint32_t  RESETOP;                  /* Offset: 0x008 (R/W) Reset Option Register */
  __IO   uint32_t  RESERVED0;
  __IO   uint32_t  RSTINFO;                  /* Offset: 0x010 (R/W) Reset Information Register */
} CM3DS_MPS2_SYSCON_TypeDef;

#define CM3DS_MPS2_SYSCON_REMAP_Pos                 0
#define CM3DS_MPS2_SYSCON_REMAP_Msk                 (0x01ul << CM3DS_MPS2_SYSCON_REMAP_Pos)               /* CM3DS_MPS2_SYSCON MEME_CTRL: REMAP Mask */

#define CM3DS_MPS2_SYSCON_PMUCTRL_EN_Pos            0
#define CM3DS_MPS2_SYSCON_PMUCTRL_EN_Msk            (0x01ul << CM3DS_MPS2_SYSCON_PMUCTRL_EN_Pos)          /* CM3DS_MPS2_SYSCON PMUCTRL: PMUCTRL ENABLE Mask */

#define CM3DS_MPS2_SYSCON_LOCKUPRST_RESETOP_Pos     0
#define CM3DS_MPS2_SYSCON_LOCKUPRST_RESETOP_Msk     (0x01ul << CM3DS_MPS2_SYSCON_LOCKUPRST_RESETOP_Pos)   /* CM3DS_MPS2_SYSCON SYS_CTRL: LOCKUP RESET ENABLE Mask */

#define CM3DS_MPS2_SYSCON_RSTINFO_SYSRESETREQ_Pos   0
#define CM3DS_MPS2_SYSCON_RSTINFO_SYSRESETREQ_Msk   (0x00001ul << CM3DS_MPS2_SYSCON_RSTINFO_SYSRESETREQ_Pos) /* CM3DS_MPS2_SYSCON RSTINFO: SYSRESETREQ Mask */

#define CM3DS_MPS2_SYSCON_RSTINFO_WDOGRESETREQ_Pos  1
#define CM3DS_MPS2_SYSCON_RSTINFO_WDOGRESETREQ_Msk  (0x00001ul << CM3DS_MPS2_SYSCON_RSTINFO_WDOGRESETREQ_Pos) /* CM3DS_MPS2_SYSCON RSTINFO: WDOGRESETREQ Mask */

#define CM3DS_MPS2_SYSCON_RSTINFO_LOCKUPRESET_Pos   2
#define CM3DS_MPS2_SYSCON_RSTINFO_LOCKUPRESET_Msk   (0x00001ul << CM3DS_MPS2_SYSCON_RSTINFO_LOCKUPRESET_Pos) /* CM3DS_MPS2_SYSCON RSTINFO: LOCKUPRESET Mask */

/*------------- PL230 uDMA (PL230) --------------------------------------*/
/** @addtogroup CM3DS_MPS2_PL230 CM3DS_MPS2 uDMA controller
  @{
*/
typedef struct
{
  __I    uint32_t  DMA_STATUS;           /*!< Offset: 0x000 DMA status Register (R/W) */
  __O    uint32_t  DMA_CFG;              /*!< Offset: 0x004 DMA configuration Register ( /W) */
  __IO   uint32_t  CTRL_BASE_PTR;        /*!< Offset: 0x008 Channel Control Data Base Pointer Register  (R/W) */
  __I    uint32_t  ALT_CTRL_BASE_PTR;    /*!< Offset: 0x00C Channel Alternate Control Data Base Pointer Register  (R/ ) */
  __I    uint32_t  DMA_WAITONREQ_STATUS; /*!< Offset: 0x010 Channel Wait On Request Status Register  (R/ ) */
  __O    uint32_t  CHNL_SW_REQUEST;      /*!< Offset: 0x014 Channel Software Request Register  ( /W) */
  __IO   uint32_t  CHNL_USEBURST_SET;    /*!< Offset: 0x018 Channel UseBurst Set Register  (R/W) */
  __O    uint32_t  CHNL_USEBURST_CLR;    /*!< Offset: 0x01C Channel UseBurst Clear Register  ( /W) */
  __IO   uint32_t  CHNL_REQ_MASK_SET;    /*!< Offset: 0x020 Channel Request Mask Set Register  (R/W) */
  __O    uint32_t  CHNL_REQ_MASK_CLR;    /*!< Offset: 0x024 Channel Request Mask Clear Register  ( /W) */
  __IO   uint32_t  CHNL_ENABLE_SET;      /*!< Offset: 0x028 Channel Enable Set Register  (R/W) */
  __O    uint32_t  CHNL_ENABLE_CLR;      /*!< Offset: 0x02C Channel Enable Clear Register  ( /W) */
  __IO   uint32_t  CHNL_PRI_ALT_SET;     /*!< Offset: 0x030 Channel Primary-Alterante Set Register  (R/W) */
  __O    uint32_t  CHNL_PRI_ALT_CLR;     /*!< Offset: 0x034 Channel Primary-Alterante Clear Register  ( /W) */
  __IO   uint32_t  CHNL_PRIORITY_SET;    /*!< Offset: 0x038 Channel Priority Set Register  (R/W) */
  __O    uint32_t  CHNL_PRIORITY_CLR;    /*!< Offset: 0x03C Channel Priority Clear Register  ( /W) */
         uint32_t  RESERVED0[3];
  __IO   uint32_t  ERR_CLR;              /*!< Offset: 0x04C Bus Error Clear Register  (R/W) */

} CM3DS_MPS2_PL230_TypeDef;

#define PL230_DMA_CHNL_BITS 0

#define CM3DS_MPS2_PL230_DMA_STATUS_MSTREN_Pos          0                                                          /*!< CM3DS_MPS2_PL230 DMA STATUS: MSTREN Position */
#define CM3DS_MPS2_PL230_DMA_STATUS_MSTREN_Msk          (0x00000001ul << CM3DS_MPS2_PL230_DMA_STATUS_MSTREN_Pos)        /*!< CM3DS_MPS2_PL230 DMA STATUS: MSTREN Mask */

#define CM3DS_MPS2_PL230_DMA_STATUS_STATE_Pos           0                                                          /*!< CM3DS_MPS2_PL230 DMA STATUS: STATE Position */
#define CM3DS_MPS2_PL230_DMA_STATUS_STATE_Msk           (0x0000000Ful << CM3DS_MPS2_PL230_DMA_STATUS_STATE_Pos)         /*!< CM3DS_MPS2_PL230 DMA STATUS: STATE Mask */

#define CM3DS_MPS2_PL230_DMA_STATUS_CHNLS_MINUS1_Pos    0                                                          /*!< CM3DS_MPS2_PL230 DMA STATUS: CHNLS_MINUS1 Position */
#define CM3DS_MPS2_PL230_DMA_STATUS_CHNLS_MINUS1_Msk    (0x0000001Ful << CM3DS_MPS2_PL230_DMA_STATUS_CHNLS_MINUS1_Pos)  /*!< CM3DS_MPS2_PL230 DMA STATUS: CHNLS_MINUS1 Mask */

#define CM3DS_MPS2_PL230_DMA_STATUS_TEST_STATUS_Pos     0                                                          /*!< CM3DS_MPS2_PL230 DMA STATUS: TEST_STATUS Position */
#define CM3DS_MPS2_PL230_DMA_STATUS_TEST_STATUS_Msk     (0x00000001ul << CM3DS_MPS2_PL230_DMA_STATUS_TEST_STATUS_Pos)   /*!< CM3DS_MPS2_PL230 DMA STATUS: TEST_STATUS Mask */

#define CM3DS_MPS2_PL230_DMA_CFG_MSTREN_Pos             0                                                          /*!< CM3DS_MPS2_PL230 DMA CFG: MSTREN Position */
#define CM3DS_MPS2_PL230_DMA_CFG_MSTREN_Msk             (0x00000001ul << CM3DS_MPS2_PL230_DMA_CFG_MSTREN_Pos)           /*!< CM3DS_MPS2_PL230 DMA CFG: MSTREN Mask */

#define CM3DS_MPS2_PL230_DMA_CFG_CPCCACHE_Pos           2                                                          /*!< CM3DS_MPS2_PL230 DMA CFG: CPCCACHE Position */
#define CM3DS_MPS2_PL230_DMA_CFG_CPCCACHE_Msk           (0x00000001ul << CM3DS_MPS2_PL230_DMA_CFG_CPCCACHE_Pos)         /*!< CM3DS_MPS2_PL230 DMA CFG: CPCCACHE Mask */

#define CM3DS_MPS2_PL230_DMA_CFG_CPCBUF_Pos             1                                                          /*!< CM3DS_MPS2_PL230 DMA CFG: CPCBUF Position */
#define CM3DS_MPS2_PL230_DMA_CFG_CPCBUF_Msk             (0x00000001ul << CM3DS_MPS2_PL230_DMA_CFG_CPCBUF_Pos)           /*!< CM3DS_MPS2_PL230 DMA CFG: CPCBUF Mask */

#define CM3DS_MPS2_PL230_DMA_CFG_CPCPRIV_Pos            0                                                          /*!< CM3DS_MPS2_PL230 DMA CFG: CPCPRIV Position */
#define CM3DS_MPS2_PL230_DMA_CFG_CPCPRIV_Msk            (0x00000001ul << CM3DS_MPS2_PL230_DMA_CFG_CPCPRIV_Pos)          /*!< CM3DS_MPS2_PL230 DMA CFG: CPCPRIV Mask */

#define CM3DS_MPS2_PL230_CTRL_BASE_PTR_Pos              PL230_DMA_CHNL_BITS + 5                                    /*!< CM3DS_MPS2_PL230 STATUS: BASE_PTR Position */
#define CM3DS_MPS2_PL230_CTRL_BASE_PTR_Msk              (0x0FFFFFFFul << CM3DS_MPS2_PL230_CTRL_BASE_PTR_Pos)            /*!< CM3DS_MPS2_PL230 STATUS: BASE_PTR Mask */

#define CM3DS_MPS2_PL230_ALT_CTRL_BASE_PTR_Pos          0                                                          /*!< CM3DS_MPS2_PL230 STATUS: MSTREN Position */
#define CM3DS_MPS2_PL230_ALT_CTRL_BASE_PTR_Msk          (0xFFFFFFFFul << CM3DS_MPS2_PL230_ALT_CTRL_BASE_PTR_Pos)        /*!< CM3DS_MPS2_PL230 STATUS: MSTREN Mask */

#define CM3DS_MPS2_PL230_DMA_WAITONREQ_STATUS_Pos       0                                                          /*!< CM3DS_MPS2_PL230 DMA_WAITONREQ_STATUS: DMA_WAITONREQ_STATUS Position */
#define CM3DS_MPS2_PL230_DMA_WAITONREQ_STATUS_Msk       (0xFFFFFFFFul << CM3DS_MPS2_PL230_DMA_WAITONREQ_STATUS_Pos)     /*!< CM3DS_MPS2_PL230 DMA_WAITONREQ_STATUS: DMA_WAITONREQ_STATUS Mask */

#define CM3DS_MPS2_PL230_CHNL_SW_REQUEST_Pos            0                                                          /*!< CM3DS_MPS2_PL230 CHNL_SW_REQUEST: CHNL_SW_REQUEST Position */
#define CM3DS_MPS2_PL230_CHNL_SW_REQUEST_Msk            (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_SW_REQUEST_Pos)          /*!< CM3DS_MPS2_PL230 CHNL_SW_REQUEST: CHNL_SW_REQUEST Mask */

#define CM3DS_MPS2_PL230_CHNL_USEBURST_SET_Pos          0                                                          /*!< CM3DS_MPS2_PL230 CHNL_USEBURST: SET Position */
#define CM3DS_MPS2_PL230_CHNL_USEBURST_SET_Msk          (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_USEBURST_SET_Pos)        /*!< CM3DS_MPS2_PL230 CHNL_USEBURST: SET Mask */

#define CM3DS_MPS2_PL230_CHNL_USEBURST_CLR_Pos          0                                                          /*!< CM3DS_MPS2_PL230 CHNL_USEBURST: CLR Position */
#define CM3DS_MPS2_PL230_CHNL_USEBURST_CLR_Msk          (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_USEBURST_CLR_Pos)        /*!< CM3DS_MPS2_PL230 CHNL_USEBURST: CLR Mask */

#define CM3DS_MPS2_PL230_CHNL_REQ_MASK_SET_Pos          0                                                          /*!< CM3DS_MPS2_PL230 CHNL_REQ_MASK: SET Position */
#define CM3DS_MPS2_PL230_CHNL_REQ_MASK_SET_Msk          (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_REQ_MASK_SET_Pos)        /*!< CM3DS_MPS2_PL230 CHNL_REQ_MASK: SET Mask */

#define CM3DS_MPS2_PL230_CHNL_REQ_MASK_CLR_Pos          0                                                          /*!< CM3DS_MPS2_PL230 CHNL_REQ_MASK: CLR Position */
#define CM3DS_MPS2_PL230_CHNL_REQ_MASK_CLR_Msk          (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_REQ_MASK_CLR_Pos)        /*!< CM3DS_MPS2_PL230 CHNL_REQ_MASK: CLR Mask */

#define CM3DS_MPS2_PL230_CHNL_ENABLE_SET_Pos            0                                                          /*!< CM3DS_MPS2_PL230 CHNL_ENABLE: SET Position */
#define CM3DS_MPS2_PL230_CHNL_ENABLE_SET_Msk            (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_ENABLE_SET_Pos)          /*!< CM3DS_MPS2_PL230 CHNL_ENABLE: SET Mask */

#define CM3DS_MPS2_PL230_CHNL_ENABLE_CLR_Pos            0                                                          /*!< CM3DS_MPS2_PL230 CHNL_ENABLE: CLR Position */
#define CM3DS_MPS2_PL230_CHNL_ENABLE_CLR_Msk            (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_ENABLE_CLR_Pos)          /*!< CM3DS_MPS2_PL230 CHNL_ENABLE: CLR Mask */

#define CM3DS_MPS2_PL230_CHNL_PRI_ALT_SET_Pos           0                                                          /*!< CM3DS_MPS2_PL230 CHNL_PRI_ALT: SET Position */
#define CM3DS_MPS2_PL230_CHNL_PRI_ALT_SET_Msk           (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_PRI_ALT_SET_Pos)         /*!< CM3DS_MPS2_PL230 CHNL_PRI_ALT: SET Mask */

#define CM3DS_MPS2_PL230_CHNL_PRI_ALT_CLR_Pos           0                                                          /*!< CM3DS_MPS2_PL230 CHNL_PRI_ALT: CLR Position */
#define CM3DS_MPS2_PL230_CHNL_PRI_ALT_CLR_Msk           (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_PRI_ALT_CLR_Pos)         /*!< CM3DS_MPS2_PL230 CHNL_PRI_ALT: CLR Mask */

#define CM3DS_MPS2_PL230_CHNL_PRIORITY_SET_Pos          0                                                          /*!< CM3DS_MPS2_PL230 CHNL_PRIORITY: SET Position */
#define CM3DS_MPS2_PL230_CHNL_PRIORITY_SET_Msk          (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_PRIORITY_SET_Pos)        /*!< CM3DS_MPS2_PL230 CHNL_PRIORITY: SET Mask */

#define CM3DS_MPS2_PL230_CHNL_PRIORITY_CLR_Pos          0                                                          /*!< CM3DS_MPS2_PL230 CHNL_PRIORITY: CLR Position */
#define CM3DS_MPS2_PL230_CHNL_PRIORITY_CLR_Msk          (0xFFFFFFFFul << CM3DS_MPS2_PL230_CHNL_PRIORITY_CLR_Pos)        /*!< CM3DS_MPS2_PL230 CHNL_PRIORITY: CLR Mask */

#define CM3DS_MPS2_PL230_ERR_CLR_Pos                    0                                                          /*!< CM3DS_MPS2_PL230 ERR: CLR Position */
#define CM3DS_MPS2_PL230_ERR_CLR_Msk                    (0x00000001ul << CM3DS_MPS2_PL230_ERR_CLR_Pos)                  /*!< CM3DS_MPS2_PL230 ERR: CLR Mask */


/*------------------- Watchdog ----------------------------------------------*/
typedef struct
{

  __IO    uint32_t  LOAD;                   /* Offset: 0x000 (R/W) Watchdog Load Register */
  __I     uint32_t  VALUE;                  /* Offset: 0x004 (R/ ) Watchdog Value Register */
  __IO    uint32_t  CTRL;                   /* Offset: 0x008 (R/W) Watchdog Control Register */
  __O     uint32_t  INTCLR;                 /* Offset: 0x00C ( /W) Watchdog Clear Interrupt Register */
  __I     uint32_t  RAWINTSTAT;             /* Offset: 0x010 (R/ ) Watchdog Raw Interrupt Status Register */
  __I     uint32_t  MASKINTSTAT;            /* Offset: 0x014 (R/ ) Watchdog Interrupt Status Register */
        uint32_t  RESERVED0[762];
  __IO    uint32_t  LOCK;                   /* Offset: 0xC00 (R/W) Watchdog Lock Register */
        uint32_t  RESERVED1[191];
  __IO    uint32_t  ITCR;                   /* Offset: 0xF00 (R/W) Watchdog Integration Test Control Register */
  __O     uint32_t  ITOP;                   /* Offset: 0xF04 ( /W) Watchdog Integration Test Output Set Register */
}CM3DS_MPS2_WATCHDOG_TypeDef;

#define CM3DS_MPS2_Watchdog_LOAD_Pos               0                                              /* CM3DS_MPS2_Watchdog LOAD: LOAD Position */
#define CM3DS_MPS2_Watchdog_LOAD_Msk              (0xFFFFFFFFul << CM3DS_MPS2_Watchdog_LOAD_Pos)       /* CM3DS_MPS2_Watchdog LOAD: LOAD Mask */

#define CM3DS_MPS2_Watchdog_VALUE_Pos              0                                              /* CM3DS_MPS2_Watchdog VALUE: VALUE Position */
#define CM3DS_MPS2_Watchdog_VALUE_Msk             (0xFFFFFFFFul << CM3DS_MPS2_Watchdog_VALUE_Pos)      /* CM3DS_MPS2_Watchdog VALUE: VALUE Mask */

#define CM3DS_MPS2_Watchdog_CTRL_RESEN_Pos         1                                              /* CM3DS_MPS2_Watchdog CTRL_RESEN: Enable Reset Output Position */
#define CM3DS_MPS2_Watchdog_CTRL_RESEN_Msk        (0x1ul << CM3DS_MPS2_Watchdog_CTRL_RESEN_Pos)        /* CM3DS_MPS2_Watchdog CTRL_RESEN: Enable Reset Output Mask */

#define CM3DS_MPS2_Watchdog_CTRL_INTEN_Pos         0                                              /* CM3DS_MPS2_Watchdog CTRL_INTEN: Int Enable Position */
#define CM3DS_MPS2_Watchdog_CTRL_INTEN_Msk        (0x1ul << CM3DS_MPS2_Watchdog_CTRL_INTEN_Pos)        /* CM3DS_MPS2_Watchdog CTRL_INTEN: Int Enable Mask */

#define CM3DS_MPS2_Watchdog_INTCLR_Pos             0                                              /* CM3DS_MPS2_Watchdog INTCLR: Int Clear Position */
#define CM3DS_MPS2_Watchdog_INTCLR_Msk            (0x1ul << CM3DS_MPS2_Watchdog_INTCLR_Pos)            /* CM3DS_MPS2_Watchdog INTCLR: Int Clear Mask */

#define CM3DS_MPS2_Watchdog_RAWINTSTAT_Pos         0                                              /* CM3DS_MPS2_Watchdog RAWINTSTAT: Raw Int Status Position */
#define CM3DS_MPS2_Watchdog_RAWINTSTAT_Msk        (0x1ul << CM3DS_MPS2_Watchdog_RAWINTSTAT_Pos)        /* CM3DS_MPS2_Watchdog RAWINTSTAT: Raw Int Status Mask */

#define CM3DS_MPS2_Watchdog_MASKINTSTAT_Pos        0                                              /* CM3DS_MPS2_Watchdog MASKINTSTAT: Mask Int Status Position */
#define CM3DS_MPS2_Watchdog_MASKINTSTAT_Msk       (0x1ul << CM3DS_MPS2_Watchdog_MASKINTSTAT_Pos)       /* CM3DS_MPS2_Watchdog MASKINTSTAT: Mask Int Status Mask */

#define CM3DS_MPS2_Watchdog_LOCK_Pos               0                                              /* CM3DS_MPS2_Watchdog LOCK: LOCK Position */
#define CM3DS_MPS2_Watchdog_LOCK_Msk              (0x1ul << CM3DS_MPS2_Watchdog_LOCK_Pos)              /* CM3DS_MPS2_Watchdog LOCK: LOCK Mask */

#define CM3DS_MPS2_Watchdog_INTEGTESTEN_Pos        0                                              /* CM3DS_MPS2_Watchdog INTEGTESTEN: Integration Test Enable Position */
#define CM3DS_MPS2_Watchdog_INTEGTESTEN_Msk       (0x1ul << CM3DS_MPS2_Watchdog_INTEGTESTEN_Pos)       /* CM3DS_MPS2_Watchdog INTEGTESTEN: Integration Test Enable Mask */

#define CM3DS_MPS2_Watchdog_INTEGTESTOUTSET_Pos    1                                              /* CM3DS_MPS2_Watchdog INTEGTESTOUTSET: Integration Test Output Set Position */
#define CM3DS_MPS2_Watchdog_INTEGTESTOUTSET_Msk   (0x1ul << CM3DS_MPS2_Watchdog_INTEGTESTOUTSET_Pos)   /* CM3DS_MPS2_Watchdog INTEGTESTOUTSET: Integration Test Output Set Mask */

/*------------------- FPGA control ----------------------------------------------*/
#if defined ( __CC_ARM   )
#pragma anon_unions
#endif

typedef struct
{
  /*!< Offset: 0x000 LDE0 Register    (R/W) */
  __IO   uint32_t  LEDS;      // <h> LEDS </h>
                              //   <o.0> LED0
                              //     <0=> LED0 off
                              //     <1=> LED0 on
                              //   <o.1> LED1
                              //     <0=> LED1 off
                              //     <1=> LED1 on
         uint32_t  RESERVED0;
  __I    uint32_t  BUTTONS;   // <h> BUTTONS </h>
                              //   <o.0> BUTTON0
                              //     <0=> off
                              //     <1=> on
                              //   <o.1> BUTTON1
                              //     <0=> off
                              //     <1=> on
         uint32_t  RESERVED1;
  __IO   uint32_t  COUNT1HZ;  // <h> 1Hz up counter </h>
  __IO   uint32_t  CNT100HZ;  // <h> 100Hz up counter </h>
  __IO   uint32_t  COUNTCYC;  // <h> Cycle counter </h>
  __IO   uint32_t  PRESCALE;  // <h> Reload value for prescale counter</h>
  __IO   uint32_t  PSCNTR;    // <h> Prescale counter for cycle counter</h>
         uint32_t  RESERVED2[10];
  __IO   uint32_t  MISC;      // <h> Misc controls </h>
                              //   <o.0> CLCD_CS
                              //     <0=> off
                              //     <1=> on
                              //   <o.1> SPI_nSS
                              //     <0=> off
                              //     <1=> on
                              //   <o.2> CLCD_T_CS
                              //     <0=> off
                              //     <1=> on
                              //   <o.3> CLCD_RESET
                              //     <0=> off
                              //     <1=> on
                              //   <o.4> CLCD_RS
                              //     <0=> off
                              //     <1=> on
                              //   <o.5> CLCD_RD
                              //     <0=> off
                              //     <1=> on
                              //   <o.6> CLCD_BL_CTRL
                              //     <0=> off
                              //     <1=> on

} CM3DS_MPS2_FPGASYS_TypeDef;

/*------------------- Audio I2S control ----------------------------------------------*/
typedef struct
{
  /*!< Offset: 0x000 CONTROL Register    (R/W) */
  __IO   uint32_t  CONTROL; // <h> CONTROL </h>
                              //   <o.0> TX Enable
                              //     <0=> TX disabled
                              //     <1=> TX enabled
                              //   <o.1> TX IRQ Enable
                              //     <0=> TX IRQ disabled
                              //     <1=> TX IRQ enabled
                              //   <o.2> RX Enable
                              //     <0=> RX disabled
                              //     <1=> RX enabled
                              //   <o.3> RX IRQ Enable
                              //     <0=> RX IRQ disabled
                              //     <1=> RX IRQ enabled
                              //   <o.10..8> TX Buffer Water Level
                              //     <0=> / IRQ triggers when any space available
                              //     <1=> / IRQ triggers when more than 1 space available
                              //     <2=> / IRQ triggers when more than 2 space available
                              //     <3=> / IRQ triggers when more than 3 space available
                              //     <4=> Undefined!
                              //     <5=> Undefined!
                              //     <6=> Undefined!
                              //     <7=> Undefined!
                              //   <o.14..12> RX Buffer Water Level
                              //     <0=> Undefined!
                              //     <1=> / IRQ triggers when less than 1 space available
                              //     <2=> / IRQ triggers when less than 2 space available
                              //     <3=> / IRQ triggers when less than 3 space available
                              //     <4=> / IRQ triggers when less than 4 space available
                              //     <5=> Undefined!
                              //     <6=> Undefined!
                              //     <7=> Undefined!
                              //   <o.16> FIFO reset
                              //     <0=> Normal operation
                              //     <1=> FIFO reset
                              //   <o.17> Audio Codec reset
                              //     <0=> Normal operation
                              //     <1=> Assert audio Codec reset
  /*!< Offset: 0x004 STATUS Register     (R/ ) */
  __I    uint32_t  STATUS;  // <h> STATUS </h>
                              //   <o.0> TX Buffer alert
                              //     <0=> TX buffer don't need service yet
                              //     <1=> TX buffer need service
                              //   <o.1> RX Buffer alert
                              //     <0=> RX buffer don't need service yet
                              //     <1=> RX buffer need service
                              //   <o.2> TX Buffer Empty
                              //     <0=> TX buffer have data
                              //     <1=> TX buffer empty
                              //   <o.3> TX Buffer Full
                              //     <0=> TX buffer not full
                              //     <1=> TX buffer full
                              //   <o.4> RX Buffer Empty
                              //     <0=> RX buffer have data
                              //     <1=> RX buffer empty
                              //   <o.5> RX Buffer Full
                              //     <0=> RX buffer not full
                              //     <1=> RX buffer full
  union {
   /*!< Offset: 0x008 Error Status Register (R/ ) */
    __I    uint32_t  ERROR;  // <h> ERROR </h>
                              //   <o.0> TX error
                              //     <0=> Okay
                              //     <1=> TX overrun/underrun
                              //   <o.1> RX error
                              //     <0=> Okay
                              //     <1=> RX overrun/underrun
   /*!< Offset: 0x008 Error Clear Register  ( /W) */
    __O    uint32_t  ERRORCLR;  // <h> ERRORCLR </h>
                              //   <o.0> TX error
                              //     <0=> Okay
                              //     <1=> Clear TX error
                              //   <o.1> RX error
                              //     <0=> Okay
                              //     <1=> Clear RX error
    };
   /*!< Offset: 0x00C Divide ratio Register (R/W) */
  __IO   uint32_t  DIVIDE;  // <h> Divide ratio for Left/Right clock </h>
                              //   <o.9..0> TX error (default 0x80)
   /*!< Offset: 0x010 Transmit Buffer       ( /W) */
  __O    uint32_t  TXBUF;  // <h> Transmit buffer </h>
                              //   <o.15..0> Right channel
                              //   <o.31..16> Left channel
   /*!< Offset: 0x014 Receive Buffer        (R/ ) */
  __I    uint32_t  RXBUF;  // <h> Receive buffer </h>
                              //   <o.15..0> Right channel
                              //   <o.31..16> Left channel
         uint32_t  RESERVED1[186];
  __IO uint32_t ITCR;         // <h> Integration Test Control Register </h>
                              //   <o.0> ITEN
                              //     <0=> Normal operation
                              //     <1=> Integration Test mode enable
  __O  uint32_t ITIP1;        // <h> Integration Test Input Register 1</h>
                              //   <o.0> SDIN
  __O  uint32_t ITOP1;        // <h> Integration Test Output Register 1</h>
                              //   <o.0> SDOUT
                              //   <o.1> SCLK
                              //   <o.2> LRCK
                              //   <o.3> IRQOUT
} CM3DS_MPS2_I2S_TypeDef;

#define CM3DS_MPS2_I2S_CONTROL_TXEN_Pos        0
#define CM3DS_MPS2_I2S_CONTROL_TXEN_Msk        (1UL<<CM3DS_MPS2_I2S_CONTROL_TXEN_Pos)

#define CM3DS_MPS2_I2S_CONTROL_TXIRQEN_Pos     1
#define CM3DS_MPS2_I2S_CONTROL_TXIRQEN_Msk     (1UL<<CM3DS_MPS2_I2S_CONTROL_TXIRQEN_Pos)

#define CM3DS_MPS2_I2S_CONTROL_RXEN_Pos        2
#define CM3DS_MPS2_I2S_CONTROL_RXEN_Msk        (1UL<<CM3DS_MPS2_I2S_CONTROL_RXEN_Pos)

#define CM3DS_MPS2_I2S_CONTROL_RXIRQEN_Pos     3
#define CM3DS_MPS2_I2S_CONTROL_RXIRQEN_Msk     (1UL<<CM3DS_MPS2_I2S_CONTROL_RXIRQEN_Pos)

#define CM3DS_MPS2_I2S_CONTROL_TXWLVL_Pos      8
#define CM3DS_MPS2_I2S_CONTROL_TXWLVL_Msk      (7UL<<CM3DS_MPS2_I2S_CONTROL_TXWLVL_Pos)

#define CM3DS_MPS2_I2S_CONTROL_RXWLVL_Pos      12
#define CM3DS_MPS2_I2S_CONTROL_RXWLVL_Msk      (7UL<<CM3DS_MPS2_I2S_CONTROL_RXWLVL_Pos)
/* FIFO reset*/
#define CM3DS_MPS2_I2S_CONTROL_FIFORST_Pos     16
#define CM3DS_MPS2_I2S_CONTROL_FIFORST_Msk     (1UL<<CM3DS_MPS2_I2S_CONTROL_FIFORST_Pos)
/* Codec reset*/
#define CM3DS_MPS2_I2S_CONTROL_CODECRST_Pos    17
#define CM3DS_MPS2_I2S_CONTROL_CODECRST_Msk    (1UL<<CM3DS_MPS2_I2S_CONTROL_CODECRST_Pos)

#define CM3DS_MPS2_I2S_STATUS_TXIRQ_Pos        0
#define CM3DS_MPS2_I2S_STATUS_TXIRQ_Msk        (1UL<<CM3DS_MPS2_I2S_STATUS_TXIRQ_Pos)

#define CM3DS_MPS2_I2S_STATUS_RXIRQ_Pos        1
#define CM3DS_MPS2_I2S_STATUS_RXIRQ_Msk        (1UL<<CM3DS_MPS2_I2S_STATUS_RXIRQ_Pos)

#define CM3DS_MPS2_I2S_STATUS_TXEmpty_Pos      2
#define CM3DS_MPS2_I2S_STATUS_TXEmpty_Msk      (1UL<<CM3DS_MPS2_I2S_STATUS_TXEmpty_Pos)

#define CM3DS_MPS2_I2S_STATUS_TXFull_Pos       3
#define CM3DS_MPS2_I2S_STATUS_TXFull_Msk       (1UL<<CM3DS_MPS2_I2S_STATUS_TXFull_Pos)

#define CM3DS_MPS2_I2S_STATUS_RXEmpty_Pos      4
#define CM3DS_MPS2_I2S_STATUS_RXEmpty_Msk      (1UL<<CM3DS_MPS2_I2S_STATUS_RXEmpty_Pos)

#define CM3DS_MPS2_I2S_STATUS_RXFull_Pos       5
#define CM3DS_MPS2_I2S_STATUS_RXFull_Msk       (1UL<<CM3DS_MPS2_I2S_STATUS_RXFull_Pos)

#define CM3DS_MPS2_I2S_ERROR_TXERR_Pos         0
#define CM3DS_MPS2_I2S_ERROR_TXERR_Msk         (1UL<<CM3DS_MPS2_I2S_ERROR_TXERR_Pos)

#define CM3DS_MPS2_I2S_ERROR_RXERR_Pos         1
#define CM3DS_MPS2_I2S_ERROR_RXERR_Msk         (1UL<<CM3DS_MPS2_I2S_ERROR_RXERR_Pos)

/*------------------- I2C ----------------------------------------------*/
typedef struct
{
  __IO    uint32_t  CONTROL;
  __IO    uint32_t  CONTROLC;
}CM3DS_MPS2_I2C_TypeDef;

#define CM3DS_MPS2_I2C_SCL_Pos  0
#define CM3DS_MPS2_I2C_SCL_Msk  (1UL<<CM3DS_MPS2_I2C_SCL_Pos)

#define CM3DS_MPS2_I2C_SDA_Pos  1
#define CM3DS_MPS2_I2C_SDA_Msk  (1UL<<CM3DS_MPS2_I2C_SDA_Pos)

/*------------------- SCC ----------------------------------------------*/
typedef struct
{
  __IO    uint32_t  CFG_REG0;           /* Offset: 0x0 APB RW SCC */
  __IO    uint32_t  CFG_REG1;           /* Offset: 0x4 APB RW SCC */
  __IO    uint32_t  CFG_REG2;           /* Offset: 0x8 APB RW SCC */
  __IO    uint32_t  CFG_REG3;           /* Offset: 0xC APB RW SCC */
  __IO    uint32_t  CFG_REG4;           /* Offset: 0x10 APB RW SCC */
          uint32_t  RESERVED0[35];
  __IO    uint32_t  SYS_CFGDATA_SERIAL; /* Offset: 0xA0 APB RW SCC */
  __IO    uint32_t  SYS_CFGDATA_APB;    /* Offset: 0xA4 APB RW SCC */
  __IO    uint32_t  SYS_CFGCTRL;        /* Offset: 0xA8 APB RW SCC */
  __IO    uint32_t  SYS_CFGSTAT;        /* Offset: 0xAC APB RW SCC */
          uint32_t  RESERVED1[20];
  __IO    uint32_t  SCC_DLLLOCK; /* Offset: 0x100 APB R  SCC RW */
  __IO    uint32_t  SCC_LED;     /* Offset: 0x104 APB RW SCC R */
  __IO    uint32_t  SCC_SW;      /* Offset: 0x108 APB R  SCC RW */
          uint32_t  RESERVED2[5];
  __IO    uint32_t  SCC_APBLOCK; /* Offset: 0x120 APB RW SCC R */
          uint32_t  RESERVED3[949];
  __IO    uint32_t  SCC_AID;     /* Offset: 0xff8 APB R  SCC RW */
  __IO    uint32_t  SCC_ID;      /* Offset: 0xffc APB R  SCC RW */
}CM3DS_MPS2_SCC_TypeDef;


/* --------------------  End of section using anonymous unions  ------------------- */

#if defined ( __CC_ARM   )
  #pragma pop
#elif defined(__ICCARM__)
  /* leave anonymous unions enabled */
#elif defined(__GNUC__)
  /* anonymous unions are enabled by default */
#elif defined(__TMS470__)
  /* anonymous unions are enabled by default */
#elif defined(__TASKING__)
  #pragma warning restore
#else
  #warning Not supported compiler type
#endif


/******************************************************************************/
/*                         Peripheral memory map                              */
/******************************************************************************/
/* Peripheral and SRAM base address */
#define CM3DS_MPS2_FLASH_BASE        (0x00000000UL)  /*!< (FLASH     ) Base Address */
#define CM3DS_MPS2_SRAM_BASE         (0x20000000UL)  /*!< (SRAM      ) Base Address */
#define CM3DS_MPS2_PERIPH_BASE       (0x40000000UL)  /*!< (Peripheral) Base Address */

#define CM3DS_MPS2_RAM_BASE          (0x20000000UL)
#define CM3DS_MPS2_APB_BASE          (0x40000000UL)
#define CM3DS_MPS2_AHB_BASE          (0x40010000UL)

/* APB peripherals                                                           */
#define CM3DS_MPS2_TIMER0_BASE       (CM3DS_MPS2_APB_BASE + 0x0000UL)
#define CM3DS_MPS2_TIMER1_BASE       (CM3DS_MPS2_APB_BASE + 0x1000UL)
#define CM3DS_MPS2_DUALTIMER_BASE    (CM3DS_MPS2_APB_BASE + 0x2000UL)
#define CM3DS_MPS2_DUALTIMER_1_BASE  (CM3DS_MPS2_DUALTIMER_BASE)
#define CM3DS_MPS2_DUALTIMER_2_BASE  (CM3DS_MPS2_DUALTIMER_BASE + 0x20UL)
#define CM3DS_MPS2_UART0_BASE        (CM3DS_MPS2_APB_BASE + 0x4000UL)
#define CM3DS_MPS2_UART1_BASE        (CM3DS_MPS2_APB_BASE + 0x5000UL)
#define CM3DS_MPS2_RTC_BASE          (CM3DS_MPS2_APB_BASE + 0x6000UL)
#define CM3DS_MPS2_WATCHDOG_BASE     (CM3DS_MPS2_APB_BASE + 0x8000UL)
#define CM3DS_MPS2_TRNG_BASE         (CM3DS_MPS2_APB_BASE + 0xF000UL)

/* AHB peripherals                                                           */
#define CM3DS_MPS2_ZBT1_BASE         (0x00400000UL)
#define CM3DS_MPS2_ZBT2_BASE         (0x20400000UL)
#define CM3DS_MPS2_PSRAM_BASE        (0x21000000UL)
#define CM3DS_MPS2_GPIO0_BASE        (CM3DS_MPS2_AHB_BASE + 0x0000UL)
#define CM3DS_MPS2_GPIO1_BASE        (CM3DS_MPS2_AHB_BASE + 0x1000UL)
#define CM3DS_MPS2_GPIO2_BASE        (CM3DS_MPS2_AHB_BASE + 0x2000UL)
#define CM3DS_MPS2_GPIO3_BASE        (CM3DS_MPS2_AHB_BASE + 0x3000UL)
#define CM3DS_MPS2_SYSCTRL_BASE      (CM3DS_MPS2_AHB_BASE + 0xF000UL)
#define CM3DS_MPS2_EXTSPI_BASE       (0x40020000UL)
#define CM3DS_MPS2_CLCDSPI_BASE      (0x40021000UL)
#define CM3DS_MPS2_CLCDTOUCH_BASE    (0x40022000UL)
#define CM3DS_MPS2_AUDIOCFG_BASE     (0x40023000UL)
#define CM3DS_MPS2_AUDIO_BASE        (0x40024000UL)
#define CM3DS_MPS2_SPIADC_BASE       (0x40025000UL)
#define CM3DS_MPS2_SPISH0_BASE       (0x40026000UL)
#define CM3DS_MPS2_SPISH1_BASE       (0x40027000UL)
#define CM3DS_MPS2_FPGASYS_BASE      (0x40028000UL)
#define CM3DS_MPS2_AUDIOSH0_BASE     (0x40029000UL)
#define CM3DS_MPS2_AUDIOSH1_BASE     (0x4002A000UL)
#define CM3DS_MPS2_UART2_BASE        (0x4002C000UL)
#define CM3DS_MPS2_UART3_BASE        (0x4002D000UL)
#define CM3DS_MPS2_UART4_BASE        (0x4002E000UL)
#define CM3DS_MPS2_SCC_BASE          (0x4002F000UL)
#define CM3DS_MPS2_GPIO4_BASE        (0x40030000UL)
#define CM3DS_MPS2_GPIO5_BASE        (0x40031000UL)
#define CM3DS_MPS2_ETH_BASE          (0x40200000UL)
#define CM3DS_MPS2_VGACON_BASE       (0x41000000UL)
#define CM3DS_MPS2_VGAIMAGE_BASE     (0x41100000UL)

/* Core peripherals                                                           */
#define CM3DS_MPS2_COREPERIP_BASE    (0xE0000000UL)
#define CM3DS_MPS2_COREAPB_BASE      (0xE0040000UL)
#define CM3DS_MPS2_COREROM_BASE      (0xE00FF000UL)

/* Peripheral and SRAM size */
#define CM3DS_MPS2_FLASH_SIZE        (0x40000UL)
#define CM3DS_MPS2_SRAM_SIZE         (0x20000UL)
#define CM3DS_MPS2_APB_SIZE          (0x10000UL)
#define CM3DS_MPS2_PSRAM_SIZE        (0x1000000UL)
#define CM3DS_MPS2_ZBT2_SIZE         (0x400000UL)
#define CM3DS_MPS2_ZBT1_SIZE         (0x400000UL)

/******************************************************************************/
/*                         Peripheral declaration                             */
/******************************************************************************/
#define CM3DS_MPS2_UART0             ((CM3DS_MPS2_UART_TypeDef   *) CM3DS_MPS2_UART0_BASE   )
#define CM3DS_MPS2_UART1             ((CM3DS_MPS2_UART_TypeDef   *) CM3DS_MPS2_UART1_BASE   )
#define CM3DS_MPS2_UART2             ((CM3DS_MPS2_UART_TypeDef   *) CM3DS_MPS2_UART2_BASE   )
#define CM3DS_MPS2_UART3             ((CM3DS_MPS2_UART_TypeDef   *) CM3DS_MPS2_UART3_BASE   )
#define CM3DS_MPS2_UART4             ((CM3DS_MPS2_UART_TypeDef   *) CM3DS_MPS2_UART4_BASE   )
#define CM3DS_MPS2_TIMER0            ((CM3DS_MPS2_TIMER_TypeDef  *) CM3DS_MPS2_TIMER0_BASE )
#define CM3DS_MPS2_TIMER1            ((CM3DS_MPS2_TIMER_TypeDef  *) CM3DS_MPS2_TIMER1_BASE )
#define CM3DS_MPS2_DUALTIMER         ((CM3DS_MPS2_DUALTIMER_BOTH_TypeDef  *) CM3DS_MPS2_DUALTIMER_BASE )
#define CM3DS_MPS2_DUALTIMER1        ((CM3DS_MPS2_DUALTIMER_SINGLE_TypeDef  *) CM3DS_MPS2_DUALTIMER_1_BASE )
#define CM3DS_MPS2_DUALTIMER2        ((CM3DS_MPS2_DUALTIMER_SINGLE_TypeDef  *) CM3DS_MPS2_DUALTIMER_2_BASE )
#define CM3DS_MPS2_WATCHDOG          ((CM3DS_MPS2_WATCHDOG_TypeDef  *) CM3DS_MPS2_WATCHDOG_BASE   )
#define CM3DS_MPS2_GPIO0             ((CM3DS_MPS2_GPIO_TypeDef   *) CM3DS_MPS2_GPIO0_BASE )
#define CM3DS_MPS2_GPIO1             ((CM3DS_MPS2_GPIO_TypeDef   *) CM3DS_MPS2_GPIO1_BASE )
#define CM3DS_MPS2_GPIO2             ((CM3DS_MPS2_GPIO_TypeDef   *) CM3DS_MPS2_GPIO2_BASE )
#define CM3DS_MPS2_GPIO3             ((CM3DS_MPS2_GPIO_TypeDef   *) CM3DS_MPS2_GPIO3_BASE )
#define CM3DS_MPS2_GPIO4             ((CM3DS_MPS2_GPIO_TypeDef   *) CM3DS_MPS2_GPIO4_BASE )
#define CM3DS_MPS2_GPIO5             ((CM3DS_MPS2_GPIO_TypeDef   *) CM3DS_MPS2_GPIO5_BASE )
#define CM3DS_MPS2_SYSCON            ((CM3DS_MPS2_SYSCON_TypeDef *) CM3DS_MPS2_SYSCTRL_BASE )
#define CM3DS_MPS2_I2C               ((CM3DS_MPS2_I2C_TypeDef *) CM3DS_MPS2_AUDIOCFG_BASE )
#define CM3DS_MPS2_I2S               ((CM3DS_MPS2_I2S_TypeDef     *) CM3DS_MPS2_AUDIO_BASE )
#define CM3DS_MPS2_FPGASYS           ((CM3DS_MPS2_FPGASYS_TypeDef *) CM3DS_MPS2_FPGASYS_BASE )
#define CM3DS_MPS2_SCC               ((CM3DS_MPS2_SCC_TypeDef *) CM3DS_MPS2_SCC_BASE )

#ifdef __cplusplus
}
#endif

#endif  /* CM3DS_MPS2_H */
