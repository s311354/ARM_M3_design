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
 * File:     apsonar.c
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 *
 */

#include <stdio.h>

#include "SMM_MPS2.h"                   // MPS2 common header

#include "apsonar.h"

#define CNTLQ       0x11
#define CNTLS       0x13
#define DEL         0x7F
#define BACKSPACE   0x08
#define CR          0x0D
#define LF          0x0A
#define ESC         0x1B

char reading[6];
unsigned int char_count = 0;

void SonarUartInit(void)
{
   	CMSDK_UART3->BAUDDIV = SystemCoreClock / 9600;  // 9600 at 25MHz

    CMSDK_UART3->CTRL    = ((1ul <<  1) |              /* RX enable */
                            (1ul <<  3) );             /* RX INT enable */
}

void SonarUartUnInit(void)
{
    CMSDK_UART3->CTRL    &= ~((1ul <<  1) |              /* RX disable */
                              (1ul <<  3) );             /* RX INT disable */
}

void UARTRX3_Handler(void)
{
    char temp;
    
    if((CMSDK_UART3->INTSTATUS & (1 << 1)) && (CMSDK_UART3->STATE & 2))     // If Receive Holding register is not empty
    {
        CMSDK_UART3->INTCLEAR = (1 << 1);
        temp = CMSDK_UART3->DATA;
        if((temp == 'R') && (char_count == 0))
        {
            reading[0] = temp;
            char_count = 1;
        }
        else if ((temp == 13) && (( char_count > 0) && (char_count < 6)))
        {
            reading[char_count] = temp;
            reading[char_count + 1] = 0;
            
            char_count = 0;
        }
        else if ((temp != 0) && (( char_count > 0) && (char_count < 6)))
        {
            reading[char_count] = temp;
            char_count++;
        }
        else if (temp != 0)
        {
            char_count = 0;
            reading[0] = 0;
        }
    }      
}

// Get a character
unsigned char SonarGetReading(void)
{
  if(CMSDK_UART3->STATE & 2)     // If Receive Holding register is not empty
    return (CMSDK_UART3->DATA);
  else
    return (0);
}

apError apSONAR_TEST(void)
{
    char temp = 0;
    unsigned count = 0;
    
    printf ("Testing Sonar Sensor\n");
    
    SonarUartInit();
    NVIC_EnableIRQ(UART3_IRQn);
    
    while(1)
    {
        if((reading[0] == 'R') && (char_count == 0))
        {
            if(count == 0)
            {
                reading[4] = 0;
                printf("Sensor Reading = %s\r", reading);
                count = 20;
            }
            else
            {
                count--;
                apSleep(50);
            }
        }
        
        if ((CMSDK_UART1->STATE & 2)) // If Receive Holding register not empty
        {
            temp = CMSDK_UART1->DATA;
            if((temp == 'x') || (temp == 'X'))
                break;
        }
    }
    printf("\n");
    NVIC_DisableIRQ(UART3_IRQn);
    SonarUartUnInit();
    
    return apERR_NONE;
}

/********************************************************************
 * Microphone test
*********************************************************************/
apError apMICROPHONE_TEST(void)
{
    char temp = 0;
    unsigned int count = 100;
    unsigned int last_detect = 0, noise_detect = 0;
    
    printf ("Testing Microphone Sensor\n");
    
    CMSDK_GPIO1->OUTENABLECLR = (1 << 0);
    
    while(1)
    {
//        apSleep(10);
        
        if((noise_detect == 0) && ((CMSDK_GPIO1->DATA & (1 << 0)) == 1))
        {
            printf("1: Noise detected\n");
            noise_detect = 1;
        }
        else if((noise_detect == 1) && ((CMSDK_GPIO1->DATA & (1 << 0)) == 0))
        {
            printf("0: All quiet\n");
            noise_detect = 0;
        }
        
//        printf("%x %x\n",CMSDK_GPIO0->DATA, CMSDK_GPIO1->DATA);
        
//        if((CMSDK_GPIO1->DATA & (1 << 0)) == 1)
//        {
//            noise_detect += 1;
//        }            
//        else if((CMSDK_GPIO1->DATA & (1 << 0)) == 0)
//        {
//            if(noise_detect)
//                noise_detect -= 1;
//        }
//        
//        count -= 1;
//        if (count == 0)
//        {
//            if(last_detect != noise_detect)
//            {
//                if (noise_detect)
//                    printf("Noise detected, level %d\n" , noise_detect);
//                else
//                    printf("All quiet\n");
//            }
//            count = 100;
//            last_detect = noise_detect;
//            noise_detect = 0;
//        }
//        
        // Terminate test by typing x on console
        if ((CMSDK_UART1->STATE & 2)) // If Receive Holding register not empty
        {
            temp = CMSDK_UART1->DATA;
            if((temp == 'x') || (temp == 'X'))
                break;
        }
    }
    
    return apERR_NONE;
}


