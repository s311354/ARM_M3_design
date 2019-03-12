/*
 * Copyright:
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2014 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     uart_stdout.c
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 *
 */

#include <stdio.h>

#include "SMM_MPS2.h"                   // MPS2 common header

#include "uart_stdout.h"

#define CNTLQ       0x11
#define CNTLS       0x13
#define DEL         0x7F
#define BACKSPACE   0x08
#define CR          0x0D
#define LF          0x0A
#define ESC         0x1B

#ifdef FPGA_IMAGE
void UartStdOutInit(void)
{
    CMSDK_UART1->BAUDDIV = SystemCoreClock / 38400;  // 38400 at 25MHz

    CMSDK_UART1->CTRL    = ((1ul <<  0) |              /* TX enable */
                            (1ul <<  1) );             /* RX enable */
    
    return;
}

// Output a character
unsigned char UartPutc(unsigned char my_ch)
{
  unsigned char * text = (unsigned char *)MPS2_VGA_TEXT_BUFFER;

  while ((CMSDK_UART1->STATE & 1)); // Wait if Transmit Holding register is full

  if (my_ch == '\n')
  {
	  CMSDK_UART1->DATA  = '\r';
	  while ((CMSDK_UART1->STATE & 1)); // Wait if Transmit Holding register is full
  }

  CMSDK_UART1->DATA = my_ch; // write to transmit holding register

  *text = my_ch;             // echo character to text screen

  return (my_ch);
}

// Get a character
unsigned char UartGetc(void)
{
  unsigned char my_ch;

  while ((CMSDK_UART1->STATE & 2)==0) // Wait if Receive Holding register is empty
  {
      MPS2_FPGAIO->LED = ((MPS2_FPGAIO->CLK100HZ / 100) & 0x3);
  }

  my_ch = CMSDK_UART1->DATA;

  //Convert CR to LF
  if(my_ch == '\r')
	  my_ch = '\n';

  return (my_ch);
}

// Get line from terminal
unsigned int GetLine (char *lp, unsigned int len)
{
   unsigned int cnt = 0;
   char c;

    do {
        c = UartGetc ();
        switch (c) {
            case CNTLQ:                       /* ignore Control S/Q             */
            case CNTLS:
                break;
            case BACKSPACE:
            case DEL:
                if (cnt == 0) {
                    break;
                }
                cnt--;                         /* decrement count                */
                lp--;                          /* and line pointer               */
                UartPutc (0x08);                /* echo backspace                 */
                UartPutc (' ');
                UartPutc (0x08);
                fflush (stdout);
                break;
            case ESC:
            case 0:
            	*lp = 0;                       /* ESC - stop editing line        */
            	return (FALSE);
            case CR:                           /* CR - done, stop editing line   */
            	*lp = c;
            	lp++;                          /* increment line pointer         */
            	cnt++;                         /* and count                      */
            	c = LF;
            default:
            	UartPutc (*lp = c);             /* echo and store character       */
            	fflush (stdout);
            	lp++;                          /* increment line pointer         */
                cnt++;                         /* and count                      */
            	break;
        }
    } while (cnt < len - 2  &&  c != LF);        /* check limit and CR             */
    *lp = 0;                                   /* mark end of string             */
    return (TRUE);
}

#else
void UartStdOutInit(void)
{
  // Simulation
  CMSDK_UART2->BAUDDIV = 16;
  CMSDK_UART2->CTRL    = 0x41; // High speed test mode, TX only
  CMSDK_GPIO1->ALTFUNCSET = (1<<5);
  return;
}
// Output a character
unsigned char UartPutc(unsigned char my_ch)
{
  while ((CMSDK_UART2->STATE & 1)); // Wait if Transmit Holding register is full
  CMSDK_UART2->DATA = my_ch; // write to transmit holding register
  return (my_ch);
}
// Get a character
unsigned char UartGetc(void)
{
  while ((CMSDK_UART2->STATE & 2)==0); // Wait if Receive Holding register is empty
  return (CMSDK_UART2->DATA);
}
#endif

void UartEndSimulation(void)
{
  UartPutc((char) 0x4); // End of simulation
  while(1);
}

