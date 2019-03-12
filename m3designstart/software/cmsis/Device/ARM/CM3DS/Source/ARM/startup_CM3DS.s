;/**************************************************************************//**
; * @file     startup_CM3DS_MPS2.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           Device CM3DS_MPS2
; * @version  V3.01
; * @date     06. March 2012
; *
; * @note
; * Copyright (C) 2012,2017 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/
;/*
;//-------- <<< Use Configuration Wizard in Context Menu >>> ------------------
;*/


; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000400

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000C00

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     UART0_Handler             ; UART 0 RX and TX Handler
                DCD     Spare1_Handler            ; Not Used
                DCD     UART1_Handler             ; UART 1 RX and TX Handler
                DCD     Spare3_Handler            ; Not Used
                DCD     Spare4_Handler            ; Not Used
                DCD     RTC_Handler               ; RTC Handler
                DCD     PORT0_COMB_Handler        ; GPIO Port 0 Combined Handler
                DCD     PORT1_COMB_Handler        ; GPIO Port 1 Combined Handler
                DCD     TIMER0_Handler            ; TIMER 0 handler
                DCD     TIMER1_Handler            ; TIMER 1 handler
                DCD     DUALTIMER_HANDLER         ; Dual timer handler
                DCD     Spare11_Handler           ; Not Used
                DCD     UARTOVF_Handler           ; UART 0,1,2 Overflow Handler
                DCD     Spare13_Handler           ; Not Used
                DCD     Spare14_Handler           ; Not Used
                DCD     TSC_Handler               ; TSC handler
                DCD     PORT0_0_Handler           ; GPIO Port 0 pin 0 Handler
                DCD     PORT0_1_Handler           ; GPIO Port 0 pin 1 Handler
                DCD     PORT0_2_Handler           ; GPIO Port 0 pin 2 Handler
                DCD     PORT0_3_Handler           ; GPIO Port 0 pin 3 Handler
                DCD     PORT0_4_Handler           ; GPIO Port 0 pin 4 Handler
                DCD     PORT0_5_Handler           ; GPIO Port 0 pin 5 Handler
                DCD     PORT0_6_Handler           ; GPIO Port 0 pin 6 Handler
                DCD     PORT0_7_Handler           ; GPIO Port 0 pin 7 Handler
                DCD     PORT0_8_Handler           ; GPIO Port 0 pin 8 Handler
                DCD     PORT0_9_Handler           ; GPIO Port 0 pin 9 Handler
                DCD     PORT0_10_Handler          ; GPIO Port 0 pin 10 Handler
                DCD     PORT0_11_Handler          ; GPIO Port 0 pin 11 Handler
                DCD     PORT0_12_Handler          ; GPIO Port 0 pin 12 Handler
                DCD     PORT0_13_Handler          ; GPIO Port 0 pin 13 Handler
                DCD     PORT0_14_Handler          ; GPIO Port 0 pin 14 Handler
                DCD     PORT0_15_Handler          ; GPIO Port 0 pin 15 Handler
                DCD     SYSERROR_Handler          ; System Error Handler
                DCD     EFLASH_Handler            ; Embedded Flash Handler
                DCD     CORDIO0_Handler           ; Cordio Handler
                DCD     CORDIO1_Handler           ; Cordio Handler
                DCD     CORDIO2_Handler           ; Cordio Handler
                DCD     CORDIO3_Handler           ; Cordio Handler
                DCD     CORDIO4_Handler           ; Cordio Handler
                DCD     CORDIO5_Handler           ; Cordio Handler
                DCD     CORDIO6_Handler           ; Cordio Handler
                DCD     CORDIO7_Handler           ; Cordio Handler
                DCD     PORT2_COMB_Handler        ; GPIO Port 2 Combined Handler
                DCD     PORT3_COMB_Handler        ; GPIO Port 3 Combined Handler
                DCD     TRNG_Handler              ; Random Number Handler
                DCD     UART2_Handler             ; UART 2 RX and TX Handler
                DCD     UART3_Handler             ; UART 3 RX and TX Handler
                DCD     ETHERNET_Handler          ; Ethernet Handler
                DCD     I2S_Handler               ; I2S Handler
                DCD     MPS2_SPI0_Handler         ; SPI Handler (spi header)
                DCD     MPS2_SPI1_Handler         ; SPI Handler (clcd)
                DCD     MPS2_SPI2_Handler         ; SPI Handler (spi 1 ADC replacement)
                DCD     MPS2_SPI3_Handler         ; SPI Handler (spi 0 shield 0 replacement)
                DCD     MPS2_SPI4_Handler         ; SPI Handler
                DCD     PORT4_COMB_Handler        ; GPIO Port 4 Combined Handler
                DCD     PORT5_COMB_Handler        ; GPIO Port 5 Combined Handler
                DCD     UART4_Handler             ; UART 4 RX and TX Handler
__Vectors_End

__Vectors_Size  EQU     __Vectors_End - __Vectors

                AREA    |.text|, CODE, READONLY


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
                IMPORT  SystemInit
                IMPORT  __main
                LDR     R0, =SystemInit
                BLX     R0
                LDR     R0, =__main
                BX      R0
                ENDP


; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler\
                PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler\
                PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC
                EXPORT UART0_Handler              [WEAK]
                EXPORT Spare1_Handler             [WEAK]
                EXPORT UART1_Handler              [WEAK]
                EXPORT Spare3_Handler             [WEAK]
                EXPORT Spare4_Handler             [WEAK]
                EXPORT RTC_Handler                [WEAK]
                EXPORT PORT0_COMB_Handler         [WEAK]
                EXPORT PORT1_COMB_Handler         [WEAK]
                EXPORT TIMER0_Handler             [WEAK]
                EXPORT TIMER1_Handler             [WEAK]
                EXPORT DUALTIMER_HANDLER          [WEAK]
                EXPORT Spare11_Handler            [WEAK]
                EXPORT UARTOVF_Handler            [WEAK]
                EXPORT Spare13_Handler            [WEAK]
                EXPORT Spare14_Handler            [WEAK]
                EXPORT TSC_Handler                [WEAK]
                EXPORT PORT0_0_Handler            [WEAK]
                EXPORT PORT0_1_Handler            [WEAK]
                EXPORT PORT0_2_Handler            [WEAK]
                EXPORT PORT0_3_Handler            [WEAK]
                EXPORT PORT0_4_Handler            [WEAK]
                EXPORT PORT0_5_Handler            [WEAK]
                EXPORT PORT0_6_Handler            [WEAK]
                EXPORT PORT0_7_Handler            [WEAK]
                EXPORT PORT0_8_Handler            [WEAK]
                EXPORT PORT0_9_Handler            [WEAK]
                EXPORT PORT0_10_Handler           [WEAK]
                EXPORT PORT0_11_Handler           [WEAK]
                EXPORT PORT0_12_Handler           [WEAK]
                EXPORT PORT0_13_Handler           [WEAK]
                EXPORT PORT0_14_Handler           [WEAK]
                EXPORT PORT0_15_Handler           [WEAK]
                EXPORT SYSERROR_Handler           [WEAK]
                EXPORT EFLASH_Handler             [WEAK]
                EXPORT CORDIO0_Handler            [WEAK]
                EXPORT CORDIO1_Handler            [WEAK]
                EXPORT CORDIO2_Handler            [WEAK]
                EXPORT CORDIO3_Handler            [WEAK]
                EXPORT CORDIO4_Handler            [WEAK]
                EXPORT CORDIO5_Handler            [WEAK]
                EXPORT CORDIO6_Handler            [WEAK]
                EXPORT CORDIO7_Handler            [WEAK]
                EXPORT PORT2_COMB_Handler         [WEAK]
                EXPORT PORT3_COMB_Handler         [WEAK]
                EXPORT TRNG_Handler               [WEAK]
                EXPORT UART2_Handler              [WEAK]
                EXPORT UART3_Handler              [WEAK]
                EXPORT ETHERNET_Handler           [WEAK]
                EXPORT I2S_Handler                [WEAK]
                EXPORT MPS2_SPI0_Handler          [WEAK]
                EXPORT MPS2_SPI1_Handler          [WEAK]
                EXPORT MPS2_SPI2_Handler          [WEAK]
                EXPORT MPS2_SPI3_Handler          [WEAK]
                EXPORT MPS2_SPI4_Handler          [WEAK]
                EXPORT PORT4_COMB_Handler         [WEAK]
                EXPORT PORT5_COMB_Handler         [WEAK]
                EXPORT UART4_Handler              [WEAK]
UART0_Handler
Spare1_Handler
UART1_Handler
Spare3_Handler
Spare4_Handler
RTC_Handler
PORT0_COMB_Handler
PORT1_COMB_Handler
TIMER0_Handler
TIMER1_Handler
DUALTIMER_HANDLER
Spare11_Handler
UARTOVF_Handler
Spare13_Handler
Spare14_Handler
TSC_Handler
PORT0_0_Handler
PORT0_1_Handler
PORT0_2_Handler
PORT0_3_Handler
PORT0_4_Handler
PORT0_5_Handler
PORT0_6_Handler
PORT0_7_Handler
PORT0_8_Handler
PORT0_9_Handler
PORT0_10_Handler
PORT0_11_Handler
PORT0_12_Handler
PORT0_13_Handler
PORT0_14_Handler
PORT0_15_Handler
SYSERROR_Handler
EFLASH_Handler
CORDIO0_Handler
CORDIO1_Handler
CORDIO2_Handler
CORDIO3_Handler
CORDIO4_Handler
CORDIO5_Handler
CORDIO6_Handler
CORDIO7_Handler
PORT2_COMB_Handler
PORT3_COMB_Handler
TRNG_Handler
UART2_Handler
UART3_Handler
ETHERNET_Handler
I2S_Handler
MPS2_SPI0_Handler
MPS2_SPI1_Handler
MPS2_SPI2_Handler
MPS2_SPI3_Handler
MPS2_SPI4_Handler
PORT4_COMB_Handler
PORT5_COMB_Handler
UART4_Handler
                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                IF      :DEF:__MICROLIB

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap

__user_initial_stackheap PROC
                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR
                ENDP

                ALIGN

                ENDIF


                END
