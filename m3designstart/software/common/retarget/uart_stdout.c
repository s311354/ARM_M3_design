/*
 *-----------------------------------------------------------------------------
 * The confidential and proprietary information contained in this file may
 * only be used by a person authorised under and to the extent permitted
 * by a subsisting licensing agreement from ARM Limited.
 *
 *            (C) COPYRIGHT 2010-2017  ARM Limited or its affiliates.
 *                ALL RIGHTS RESERVED
 *
 * This entire notice must be reproduced on all copies of this file
 * and copies of this file may only be made by a person if such person is
 * permitted to do so under the terms of a subsisting license agreement
 * from ARM Limited.
 *
 *      SVN Information
 *
 *      Checked In          : $Date: 2013-04-10 15:14:20 +0100 (Wed, 10 Apr 2013) $
 *
 *      Revision            : $Revision: 243501 $
 *
 *      Release Information : CM3DesignStart-r0p0-02rel0
 *-----------------------------------------------------------------------------
 */

 /*

 UART functions for retargetting

 */
// #include <stdio.h>

#include "CM3DS_MPS2.h"
#include <stdio.h>


#define CNTLQ       0x11
#define CNTLS       0x13
#define DEL         0x7F
#define BACKSPACE   0x08
#define CR          0x0D
#define LF          0x0A
#define ESC         0x1B

#define TRUE 1
#define FALSE 0

#ifdef FPGA_IMAGE
void UartStdOutInit(void)
{
    CM3DS_MPS2_UART1->BAUDDIV = SystemCoreClock / 38400;  // 38400 at 25MHz

    CM3DS_MPS2_UART1->CTRL = ((1ul <<  0) |              /* TX enable */
                              (1ul <<  1) );             /* RX enable */
    return;
}

// Output a character
unsigned char UartPutc(unsigned char my_ch)
{
  unsigned char * text = (unsigned char *)CM3DS_MPS2_VGACON_BASE;

  while ((CM3DS_MPS2_UART1->STATE & 1)); // Wait if Transmit Holding register is full

  if (my_ch == '\n')
  {
    CM3DS_MPS2_UART1->DATA  = '\r';
    while ((CM3DS_MPS2_UART1->STATE & 1)); // Wait if Transmit Holding register is full
  }

  CM3DS_MPS2_UART1->DATA = my_ch; // write to transmit holding register

  *text = my_ch;             // echo character to text screen

  return (my_ch);
}

// Get a character
unsigned char UartGetc(void)
{
  unsigned char my_ch;

  while ((CM3DS_MPS2_UART1->STATE & 2)==0) // Wait if Receive Holding register is empty
  {
      CM3DS_MPS2_FPGASYS->LEDS = ((CM3DS_MPS2_FPGASYS->CNT100HZ / 100) & 0x3);
  }

  my_ch = CM3DS_MPS2_UART1->DATA;

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
                UartPutc (0x08);               /* echo backspace                 */
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
                UartPutc (*lp = c);            /* echo and store character       */
                fflush (stdout);
                lp++;                          /* increment line pointer         */
                cnt++;                         /* and count                      */
                break;
        }
    } while (cnt < len - 2  &&  c != LF);      /* check limit and CR             */
    *lp = 0;                                   /* mark end of string             */
    return (TRUE);
}

void UartEndSimulation(void)
{
  printf("End of Simulation test\n");
  while(1);
}

#else
// Simulation

void UartStdOutInit(void)
{
  CM3DS_MPS2_UART0->BAUDDIV = 16;
  CM3DS_MPS2_UART0->CTRL    = 0x41; // High speed test mode, TX only
//  CM3DS_MPS2_GPIO1->ALTFUNCSET = (1<<5);
  return;
}
// Output a character
unsigned char UartPutc(unsigned char my_ch)
{
  while ((CM3DS_MPS2_UART0->STATE & 1)); // Wait if Transmit Holding register is full
  CM3DS_MPS2_UART0->DATA = my_ch; // write to transmit holding register
  return (my_ch);
}
// Get a character
unsigned char UartGetc(void)
{
  while ((CM3DS_MPS2_UART0->STATE & 2)==0); // Wait if Receive Holding register is empty
  return (CM3DS_MPS2_UART0->DATA);
}

void UartEndSimulation(void)
{
  UartPutc((char) 0x4); // End of simulation
  while(1);
}

#endif
