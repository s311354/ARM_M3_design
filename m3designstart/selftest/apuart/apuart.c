/*
 * Copyright:
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2015 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     apuart.c
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 *
 */

#include <stdio.h>

#include "SMM_MPS2.h"                   // MPS2 common header

#include "apuart.h"

#define CNTLQ       0x11
#define CNTLS       0x13
#define DEL         0x7F
#define BACKSPACE   0x08
#define CR          0x0D
#define LF          0x0A
#define ESC         0x1B

void BT4UartInit(void)
{
   	CMSDK_UART1->BAUDDIV = SystemCoreClock / 115200;  // 115200 at 25MHz

    CMSDK_UART1->CTRL    = ((1ul <<  0) |              /* TX enable */
                            (1ul <<  1) );             /* RX enable */
    return;
}

apError apBT4_UART_TEST(void)
{
    char temp = 0;
    
    BT4UartInit();
    
    while(1)
    {
        temp = 0;
        // Read from BT4 UART and output to consol UART 
        if(CMSDK_UART1->STATE & 2)     // If Receive Holding register is not empty
            temp = (CMSDK_UART1->DATA);
        
        if(temp)
        {
            while ((CMSDK_UART0->STATE & 1)); // Wait if Transmit Holding register is full

            if(((temp >= 0x20) && (temp < 0x7F)) || (temp == '\r') || (temp == '\n'))
                CMSDK_UART0->DATA = temp; // write to transmit holding register
        }
        
        temp = 0;
        // Read from consol UART and output to BT4 UART 
        if((CMSDK_UART0->STATE & 2)) // If Receive Holding register not empty
        {
            temp = CMSDK_UART0->DATA;
        }
        
        if(temp)
        {
            while ((CMSDK_UART1->STATE & 1)); // Wait if Transmit Holding register is full

            CMSDK_UART1->DATA = temp; // write to transmit holding register
        }
    }
    return apERR_NONE;
}

