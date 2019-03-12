/**************************************************************************//**
 * @file     startup_CM3DS_MPS2.s
 * @brief    CMSIS Cortex-M3 Core Device Startup File for
 *           Device CM3DS_MPS2_
 * @version  V3.01
 * @date     06. March 2012
 *
 * @note      Should use with GCC for ARM Embedded Processors
 * Copyright (C) 2012,2017 ARM Limited. All rights reserved.
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
/*****************************************************************************/
/* startup_CM3DS_MPS2.s: Startup file for CM3DS_MPS2 device series               */
/*****************************************************************************/
/* Version: GNU Tools for ARM Embedded Processors                          */
/*****************************************************************************/


    .syntax unified
    .arch armv7-m

    .section .stack
    .align 3

/*
// <h> Stack Configuration
//   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
// </h>
*/

    .section .stack
    .align 3
#ifdef __STACK_SIZE
    .equ    Stack_Size, __STACK_SIZE
#else
    .equ    Stack_Size, 0x200
#endif
    .globl    __StackTop
    .globl    __StackLimit
__StackLimit:
    .space    Stack_Size
    .size __StackLimit, . - __StackLimit
__StackTop:
    .size __StackTop, . - __StackTop


/*
// <h> Heap Configuration
//   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
// </h>
*/

    .section .heap
    .align 3
#ifdef __HEAP_SIZE
    .equ    Heap_Size, __HEAP_SIZE
#else
    .equ    Heap_Size, 0
#endif
    .globl    __HeapBase
    .globl    __HeapLimit
__HeapBase:
    .if    Heap_Size
    .space    Heap_Size
    .endif
    .size __HeapBase, . - __HeapBase
__HeapLimit:
    .size __HeapLimit, . - __HeapLimit


/* Vector Table */

    .section .isr_vector
    .align 2
    .globl __isr_vector
__isr_vector:
    .long   __StackTop                  /* Top of Stack                  */
    .long   Reset_Handler               /* Reset Handler                 */
    .long   NMI_Handler                 /* NMI Handler                   */
    .long   HardFault_Handler           /* Hard Fault Handler            */
    .long   MemManage_Handler           /* MPU Fault Handler             */
    .long   BusFault_Handler            /* Bus Fault Handler             */
    .long   UsageFault_Handler          /* Usage Fault Handler           */
    .long   0                           /* Reserved                      */
    .long   0                           /* Reserved                      */
    .long   0                           /* Reserved                      */
    .long   0                           /* Reserved                      */
    .long   SVC_Handler                 /* SVCall Handler                */
    .long   DebugMon_Handler            /* Debug Monitor Handler         */
    .long   0                           /* Reserved                      */
    .long   PendSV_Handler              /* PendSV Handler                */
    .long   SysTick_Handler             /* SysTick Handler               */

    /* External Interrupts */
    .long   UART0_Handler               /* 16+ 0: UART 0 RX and TX Handler   */
    .long   Spare1_Handler              /* 16+ 1: Not Used                   */
    .long   UART1_Handler               /* 16+ 2: UART 1 RX and TX Handler   */
    .long   Spare3_Handler              /* 16+ 3: Not Used                   */
    .long   Spare4_Handler              /* 16+ 4: Not Used                   */
    .long   RTC_Handler                 /* 16+ 5: RTC Handler          */
    .long   PORT0_COMB_Handler          /* 16+ 6: GPIO Port 0 Combined Handler */
    .long   PORT1_COMB_Handler          /* 16+ 7: GPIO Port 1 Combined Handler */
    .long   TIMER0_Handler              /* 16+ 8: TIMER 0 handler            */
    .long   TIMER1_Handler              /* 16+ 9: TIMER 1 handler            */
    .long   DUALTIMER_HANDLER           /* 16+10: Dual timer 2 handler       */
    .long   Spare11_Handler             /* 16+11: Not Used                   */
    .long   UARTOVF_Handler             /* 16+12: UART 0-4 Overflow Handler  */
    .long   Spare13_Handler             /* 16+13: Not Used                   */
    .long   Spare14_Handler             /* 16+14: Not Used                   */
    .long   TSC_Handler                 /* 16+15: DMA done + error Handler   */
    .long   PORT0_0_Handler             /* 16+16: GPIO Port 0 pin 0 Handler  */
    .long   PORT0_1_Handler             /* 16+17: GPIO Port 0 pin 1 Handler  */
    .long   PORT0_2_Handler             /* 16+18: GPIO Port 0 pin 2 Handler  */
    .long   PORT0_3_Handler             /* 16+19: GPIO Port 0 pin 3 Handler  */
    .long   PORT0_4_Handler             /* 16+20: GPIO Port 0 pin 4 Handler  */
    .long   PORT0_5_Handler             /* 16+21: GPIO Port 0 pin 5 Handler  */
    .long   PORT0_6_Handler             /* 16+22: GPIO Port 0 pin 6 Handler  */
    .long   PORT0_7_Handler             /* 16+23: GPIO Port 0 pin 7 Handler  */
    .long   PORT0_8_Handler             /* 16+24: GPIO Port 0 pin 8 Handler  */
    .long   PORT0_9_Handler             /* 16+25: GPIO Port 0 pin 9 Handler  */
    .long   PORT0_10_Handler            /* 16+26: GPIO Port 0 pin 10 Handler */
    .long   PORT0_11_Handler            /* 16+27: GPIO Port 0 pin 11 Handler */
    .long   PORT0_12_Handler            /* 16+28: GPIO Port 0 pin 12 Handler */
    .long   PORT0_13_Handler            /* 16+29: GPIO Port 0 pin 13 Handler */
    .long   PORT0_14_Handler            /* 16+30: GPIO Port 0 pin 14 Handler */
    .long   PORT0_15_Handler            /* 16+31: GPIO Port 0 pin 15 Handler */
    .long   SYSERROR_Handler          /* System Error Handler */
    .long   EFLASH_Handler            /* Embedded Flash Handler */
    .long   CORDIO0_Handler           /* Cordio Handler */
    .long   CORDIO1_Handler           /* Cordio Handler */
    .long   CORDIO2_Handler           /* Cordio Handler */
    .long   CORDIO3_Handler           /* Cordio Handler */
    .long   CORDIO4_Handler           /* Cordio Handler */
    .long   CORDIO5_Handler           /* Cordio Handler */
    .long   CORDIO6_Handler           /* Cordio Handler */
    .long   CORDIO7_Handler           /* Cordio Handler */
    .long   PORT2_COMB_Handler        /* GPIO Port 2 Combined Handler */
    .long   PORT3_COMB_Handler        /* GPIO Port 3 Combined Handler */
    .long   TRNG_Handler              /* Random Number Handler */
    .long   UART2_Handler             /* UART 2 RX and TX Handler */
    .long   UART3_Handler             /* UART 3 RX and TX Handler */
    .long   ETHERNET_Handler          /* Ethernet Handler */
    .long   I2S_Handler               /* I2S Handler */
    .long   MPS2_SPI0_Handler         /* SPI Handler (spi header) */
    .long   MPS2_SPI1_Handler         /* SPI Handler (clcd) */
    .long   MPS2_SPI2_Handler         /* SPI Handler (spi 1 ADC replacement) */
    .long   MPS2_SPI3_Handler         /* SPI Handler (spi 0 shield 0 replacement) */
    .long   MPS2_SPI4_Handler         /* SPI Handler */
    .long   PORT4_COMB_Handler        /* GPIO Port 4 Combined Handler */
    .long   PORT5_COMB_Handler        /* GPIO Port 5 Combined Handler */
    .long   UART4_Handler             /* UART 4 RX and TX Handler */
    .size    __isr_vector, . - __isr_vector

/* Reset Handler */
    .text
    .thumb
    .thumb_func
    .align 2
    .globl    Reset_Handler
    .type    Reset_Handler, %function
Reset_Handler:
/*     Loop to copy data from read only memory to RAM. The ranges
 *      of copy from/to are specified by following symbols evaluated in
 *      linker script.
 *      __etext: End of code section, i.e., begin of data sections to copy from.
 *      __data_start__/__data_end__: RAM address range that data should be
 *      copied to. Both must be aligned to 4 bytes boundary.  */

    ldr    r1, =__etext
    ldr    r2, =__data_start__
    ldr    r3, =__data_end__

    subs    r3, r2
    ble    .LC1
.LC0:
    subs    r3, #4
    ldr    r0, [r1, r3]
    str    r0, [r2, r3]
    bgt    .LC0
.LC1:

#ifdef __STARTUP_CLEAR_BSS
/*     This part of work usually is done in C library startup code. Otherwise,
 *     define this macro to enable it in this startup.
 *
 *     Loop to zero out BSS section, which uses following symbols
 *     in linker script:
 *      __bss_start__: start of BSS section. Must align to 4
 *      __bss_end__: end of BSS section. Must align to 4
 */
    ldr r1, =__bss_start__
    ldr r2, =__bss_end__

    movs    r0, 0
.LC2:
    cmp     r1, r2
    itt    lt
    strlt   r0, [r1], #4
    blt    .LC2
#endif /* __STARTUP_CLEAR_BSS */

#ifndef __NO_SYSTEM_INIT
    /* bl    SystemInit */
    ldr     r0,=SystemInit
    blx     r0
#endif

    bl    main
    bl    exit


    .pool
    .size Reset_Handler, . - Reset_Handler

/*    Macro to define default handlers. Default handler
 *    will be weak symbol and just dead loops. They can be
 *    overwritten by other handlers */
    .macro    def_default_handler    handler_name
    .align 1
    .thumb_func
    .weak    \handler_name
    .type    \handler_name, %function
\handler_name :
    b    .
    .size    \handler_name, . - \handler_name
    .endm

/* System Exception Handlers */

    def_default_handler    NMI_Handler
    def_default_handler    HardFault_Handler
    def_default_handler    MemManage_Handler
    def_default_handler    BusFault_Handler
    def_default_handler    UsageFault_Handler
    def_default_handler    SVC_Handler
    def_default_handler    DebugMon_Handler
    def_default_handler    PendSV_Handler
    def_default_handler    SysTick_Handler

/* IRQ Handlers */

    def_default_handler    UART0_Handler
    def_default_handler    Spare1_Handler
    def_default_handler    UART1_Handler
    def_default_handler    Spare3_Handler
    def_default_handler    Spare4_Handler
    def_default_handler    RTC_Handler
    def_default_handler    PORT0_COMB_Handler
    def_default_handler    PORT1_COMB_Handler
    def_default_handler    TIMER0_Handler
    def_default_handler    TIMER1_Handler
    def_default_handler    DUALTIMER_HANDLER
    def_default_handler    Spare11_Handler
    def_default_handler    UARTOVF_Handler
    def_default_handler    Spare13_Handler
    def_default_handler    Spare14_Handler
    def_default_handler    TSC_Handler
    def_default_handler    PORT0_0_Handler
    def_default_handler    PORT0_1_Handler
    def_default_handler    PORT0_2_Handler
    def_default_handler    PORT0_3_Handler
    def_default_handler    PORT0_4_Handler
    def_default_handler    PORT0_5_Handler
    def_default_handler    PORT0_6_Handler
    def_default_handler    PORT0_7_Handler
    def_default_handler    PORT0_8_Handler
    def_default_handler    PORT0_9_Handler
    def_default_handler    PORT0_10_Handler
    def_default_handler    PORT0_11_Handler
    def_default_handler    PORT0_12_Handler
    def_default_handler    PORT0_13_Handler
    def_default_handler    PORT0_14_Handler
    def_default_handler    PORT0_15_Handler
    def_default_handler    SYSERROR_Handler          /* System Error Handler */
    def_default_handler    EFLASH_Handler            /* Embedded Flash Handler */
    def_default_handler    CORDIO0_Handler           /* Cordio Handler */
    def_default_handler    CORDIO1_Handler           /* Cordio Handler */
    def_default_handler    CORDIO2_Handler           /* Cordio Handler */
    def_default_handler    CORDIO3_Handler           /* Cordio Handler */
    def_default_handler    CORDIO4_Handler           /* Cordio Handler */
    def_default_handler    CORDIO5_Handler           /* Cordio Handler */
    def_default_handler    CORDIO6_Handler           /* Cordio Handler */
    def_default_handler    CORDIO7_Handler           /* Cordio Handler */
    def_default_handler    PORT2_COMB_Handler        /* GPIO Port 2 Combined Handler */
    def_default_handler    PORT3_COMB_Handler        /* GPIO Port 3 Combined Handler */
    def_default_handler    TRNG_Handler              /* Random Number Handler */
    def_default_handler    UART2_Handler             /* UART 2 RX and TX Handler */
    def_default_handler    UART3_Handler             /* UART 3 RX and TX Handler */
    def_default_handler    ETHERNET_Handler          /* Ethernet Handler */
    def_default_handler    I2S_Handler               /* I2S Handler */
    def_default_handler    MPS2_SPI0_Handler         /* SPI Handler (spi header) */
    def_default_handler    MPS2_SPI1_Handler         /* SPI Handler (clcd) */
    def_default_handler    MPS2_SPI2_Handler         /* SPI Handler (spi 1 ADC replacement) */
    def_default_handler    MPS2_SPI3_Handler         /* SPI Handler (spi 0 shield 0 replacement) */
    def_default_handler    MPS2_SPI4_Handler         /* SPI Handler */
    def_default_handler    PORT4_COMB_Handler        /* GPIO Port 4 Combined Handler */
    def_default_handler    PORT5_COMB_Handler        /* GPIO Port 5 Combined Handler */
    def_default_handler    UART4_Handler             /* UART 4 RX and TX Handler */

    /*
    def_default_handler    Default_Handler
    .weak    DEF_IRQHandler
    .set    DEF_IRQHandler, Default_Handler
    */
    .end

