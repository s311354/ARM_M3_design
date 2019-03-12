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
 *      Checked In          : $Date: 2013-04-08 17:48:08 +0100 (Mon, 08 Apr 2013) $
 *
 *      Revision            : $Revision: 243249 $
 *
 *      Release Information : CM3DesignStart-r0p0-02rel0
 *-----------------------------------------------------------------------------
 */
/*
  Interrupt demonstration

  This test demonstrate interrupt generation using various peripherals.
  - using simple timer
  - using gpio with various configurations
  - using uart

*/

#include "CM3DS_MPS2.h"

#include "uart_stdout.h"
#include "CM3DS_MPS2_driver.h"
#include <stdio.h>
#include <string.h>

//
// Global Variables to track test progress
//

volatile uint32_t tx_count = 0;                 /*transmit counter */
volatile uint32_t rx_count = 0;                 /*receive counter */
const     char str_tx[12] = "hello world";      /*transmission string*/
const int uart_str_length = 11;
volatile char str_rx[12] ;             /*string that is received*/

volatile int irq_triggered;          /* Detected interrupt operation from GPIO IRQ handler */
volatile uint32_t timer_stopped = 0; /* timer irq executed and stopped */

//
// Demonstrations
//

int  TimerExample(void);    // Timer interrupt
int  GPIOIntExample(void);  // GPIO interrupt
void UartExample(void);     // UART interrupt
int  gpio0_id_check(void);  // Detect GPIO 0 present
int  timer0_id_check(void); // Detect Timer 0 present
int  uart2_id_check(void);  // Detect UART 2 present
int  uart3_id_check(void);  // Detect UART 3 present
int  Check_IRQNUM(void);    // Check number of interrupts

// ----------------------------------------------------------
// Main program
// ----------------------------------------------------------

int main (void)
{
  // UART init
  UartStdOutInit();  // Initialize UART2 for printf (retargeting)

  // Test banner message and revision number
  puts("\nCortex-M3 DesignStart - Interrupt Demo - revision $Revision: 243249 $\n");

  if (timer0_id_check()!=0)  puts ("Timer 0 not present. TimerExample skipped.");
  else                       TimerExample();    // Timer 0 interrupt example

  if (gpio0_id_check()!=0)   puts ("GPIO 0 not present. GPIOIntExample skipped.");
  else                       GPIOIntExample();  // GPIO PORT0 interrupt example

#ifndef FPGA_IMAGE
  if ((uart2_id_check()!=0)||(uart3_id_check()!=0))
     puts ("UART 2 or UART 3 not present. UartExample skipped.");
  else                       UartExample();     // Uart interrupt example
#else
     puts ("UART2 tx has to be joined to UART3 rx\nFor MPS2 board UartExample skipped.");
#endif

  if (Check_IRQNUM() == 0)
     puts ("** TEST PASSED ** \n");
  else
     puts ("** TEST FAILED ** \n");

  UartEndSimulation();    // send test end character to finish test
  /* Simulation stops in UartEndSimulation */

  return 0;
}

// ----------------------------------------------------------
// Check number of Interrupts
// ----------------------------------------------------------
int Check_IRQNUM()
{
  //
  // Number of implemented Interrupts
  //
  // Determine number of implemented interrupts by pending all interrupts
  // then reading back the pend register contents. Only configured interrupts will
  // show as pending. This checks if the number of implemented interrupts are
  // consistent with the values on NUMIRQ.
  //
  // NOTE : Higher interrupts in the context of this check refers to interrupts with
  //        a bigger exception number

  int numirq;
  int ispr_rd;
  int j;
  int EXPECTED_IRQNUM = 32;
  int fail = 1;

  // Ensure interrupts are disabled
  NVIC->ICER[0] = 0xFFFFFFFFUL;

  // Pend all interrupts
  NVIC->ISPR[0] = 0xFFFFFFFFUL;

  // Count pending interrupts
  numirq = 0;
  ispr_rd = NVIC->ISPR[0];
  for (j=0; j<32; j++)
    {
      if ((ispr_rd & 0x00000001) == 1) numirq++;
      ispr_rd >>= 1;
    }

  if (numirq != EXPECTED_IRQNUM)
    {
      printf ("\n\nIRQNUM: %u, expected %d\tFAIL\n\n", numirq, EXPECTED_IRQNUM);
      fail = 1;
    }
  else
    {
      printf ("\n\nIRQNUM: %u\t\tPASS\n\n", numirq);
      fail = 0;
    }

  // Clear all pending interrupts
  NVIC->ICPR[0] = 0xFFFFFFFFUL;
  return fail;
}

// ----------------------------------------------------------
// Timer demo
// ----------------------------------------------------------
int TimerExample(void)
{
  puts("\n\n\n");
  puts("+*************************+");
  puts("*                         *");
  puts("*  Timer0 Interrupt demo  *");
  puts("*                         *");
  puts("+*************************+\n\n");

  NVIC_ClearPendingIRQ(TIMER0_IRQn);
  NVIC_EnableIRQ(TIMER0_IRQn);

  // initialise Timer0 with internal clock, with interrupt generation
  CM3DS_MPS2_timer_Init_IntClock(CM3DS_MPS2_TIMER0, 0x100, 1);

  while (timer_stopped==0) {
    __WFE(); // enter sleep
    }
  puts("   Timer test done");  // Banner

  return 0;
}
// ----------------------------------------------------------
// UART demo
// ----------------------------------------------------------

/* Timer IRQ Driven UART Transmission of "hello world"

    - Program UART 2 to operate as transmit only, with transmit IRQ enabled
    - Program UART 3 to operate as receive only, with receive IRQ enabled
    - The first character of the "hello world" message is transmit
    - The rest of the message transmission is handled by UART transmit IRQ, until
      all characters are transmitted.
    - The receive process is also handled by UART receive IRQ.
    - A while loop is used to wait until both transmit and receive has completed the test
    - When finished then print string received
   */


// ----------------------------------------------------------
// UART interrupt test
// ----------------------------------------------------------

void UartExample(void)
{
  uint32_t transmission_complete = 0;    /*transmission complete bool*/

  puts("+*************************+");
  puts("*                         *");
  puts("*   UART Interrupt demo   *");
  puts("*                         *");
  puts("+*************************+\n\n");

  CM3DS_MPS2_gpio_SetAltFunc(CM3DS_MPS2_GPIO0, 0x0010);  //enable alt functions for UART transmission
  CM3DS_MPS2_gpio_SetAltFunc(CM3DS_MPS2_GPIO1, 0x0400);  //enable alt functions for UART transmission

  // Ensure Interrupt is not pending

  NVIC_ClearPendingIRQ(UART2_IRQn);
  NVIC_ClearPendingIRQ(UART3_IRQn);

  // Enable Interrupts

  NVIC_EnableIRQ(UART2_IRQn);
  NVIC_EnableIRQ(UART3_IRQn);

  /* Initialize UART in cross over configuration
   uint32_t CM3DS_MPS2_uart_init(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART,
                             uint32_t            divider,
                             uint32_t            tx_en,
                             uint32_t            rx_en,
                             uint32_t            tx_irq_en,
                             uint32_t            rx_irq_en,
                             uint32_t            tx_ovrirq_en,
                             uint32_t            rx_ovrirq_en)
  */
  /* enable UARTs with selected baud rate
       UART #0 - transmit
       UART #1 - receive
  */
  CM3DS_MPS2_uart_init(CM3DS_MPS2_UART2, 0x200, 1, 0, 1, 0, 0, 0);
  CM3DS_MPS2_uart_init(CM3DS_MPS2_UART3, 0x200, 0, 1, 0, 1, 0, 0);

  rx_count = 0;
  tx_count = 0;

  printf ("Transmit message : %s\n", str_tx);

  /* Start first character transfer */
  tx_count++;
  CM3DS_MPS2_uart_SendChar(CM3DS_MPS2_UART2, str_tx[0]); // send the character
  /* The rest of the transfers are handled by interrupts */

  while(transmission_complete==0)    // loop until transmission completed
  {

    if ((tx_count==uart_str_length) && (rx_count==uart_str_length)) transmission_complete = 1;
  }

  printf ("Received message : %s\n", str_rx);

  while(strcmp((char *)str_rx, str_tx)){ // hang if received message != transmit message
  }

  NVIC_DisableIRQ(UART2_IRQn);   //disable both UART2 TX and UART3 RX IRQs
  NVIC_DisableIRQ(UART3_IRQn);

  return;
}

// ----------------------------------------------------------
// GPIO interrupt test
// ----------------------------------------------------------
/*
      GPIO interrupt example

    - Enable all pins as output
    - Set DataOut[10:7] to 0xA ready for a test of all IRQs
    - Set pin7 as a High Level, pin8 as a Low Level, pin9 as a Rising Edge and pin10 as a Falling Edge,
      then clear all pending IRQs
    - enable the CM3DS_MPS2 GPIO interrupt for pins 7, 8, 9, 10.
    - set Dataout[10:7] to 0xB to test the high level interrupt on pin 7
    - if irq_triggered != 0 (set in ISR) then print message saying IRQ occurred and set irq_triggered = 0
    - else amend err_code
    - set Dataout[10:7] to 0x9 to test the low level interrupt on pin 8
    - if irq_triggered != 0 (set in ISR) then print message saying IRQ occurred and set irq_triggered = 0
    - else amend err_code
    - set Dataout[10:7] to 0xD to test the rising edge interrupt on pin 9
    - if irq_triggered != 0 (set in ISR) then print message saying IRQ occurred and set irq_triggered = 0
    - else amend err_code
    - set Dataout[10:7] to 0x5 to test the falling edge interrupt on pin 10
    - if irq_triggered != 0 (set in ISR) then print message saying IRQ occurred and set irq_triggered = 0
    - else amend err_code
    - if test on all pins pass the test as a whole passes and return 0 to main
    - else return an error and print error message
*/
int GPIOIntExample(void)
{

  int irq_counter = 0;
  int err_code = 0;

  puts("\n\n\n");
  puts("+*************************+");
  puts("*                         *");
  puts("*  GPIO PORT0: Interrupt  *");
  puts("*         Example         *");
  puts("*                         *");
  puts("+*************************+\n\n");

  CM3DS_MPS2_gpio_SetOutEnable(CM3DS_MPS2_GPIO0, 0x780); //set output enable to output on ports [10:7] of GPIO 0
  // By setting the port to output the pins are controllable by software

  CM3DS_MPS2_GPIO0->DATAOUT = (0xA << 7);   // set current I/O port value

  CM3DS_MPS2_gpio_SetIntHighLevel(CM3DS_MPS2_GPIO0, 7);   //set pin 7 to high level interrupts
  CM3DS_MPS2_gpio_SetIntLowLevel(CM3DS_MPS2_GPIO0, 8);    //set pin 8 to low level interrupts
  CM3DS_MPS2_gpio_SetIntRisingEdge(CM3DS_MPS2_GPIO0, 9);  //set pin 9 to rising edge interrupts
  CM3DS_MPS2_gpio_SetIntFallingEdge(CM3DS_MPS2_GPIO0, 10); //set pin 10 to falling edge interrupts

  NVIC_ClearPendingIRQ(PORT0_7_IRQn);                   //clear all global NVIC PORT0 pending interrupts
  NVIC_ClearPendingIRQ(PORT0_8_IRQn);
  NVIC_ClearPendingIRQ(PORT0_9_IRQn);
  NVIC_ClearPendingIRQ(PORT0_10_IRQn);

  NVIC_EnableIRQ(PORT0_7_IRQn);                         //enable NVIC interrupts on PORT0
  NVIC_EnableIRQ(PORT0_8_IRQn);
  NVIC_EnableIRQ(PORT0_9_IRQn);
  NVIC_EnableIRQ(PORT0_10_IRQn);

  if ((NVIC->ISER[0]>>PORT0_7_IRQn)!=0x0F) {            // Cortex-M0 DesignStart only has 16 IRQ
    printf("Not all of IRQ[%d to %d] are available.\nUse combined GPIO interrupt for test\n\n",
           PORT0_7_IRQn,PORT0_10_IRQn);
    NVIC_EnableIRQ(PORT0_ALL_IRQn);                     //enable combined NVIC interrupts on PORT0
    }

  CM3DS_MPS2_gpio_SetIntEnable(CM3DS_MPS2_GPIO0, 7);
  CM3DS_MPS2_GPIO0->DATAOUT = (0xB << 7); // emulating high level input on pin 0.
  CM3DS_MPS2_gpio_ClrIntEnable(CM3DS_MPS2_GPIO0, 7);

  puts("    ...Test GPIO0[7]...\n");

  if(irq_triggered){   //if irq flag set then print message else amend error code
    puts("      High Level IRQ:\n     Detected On Pin 7\n\n");
    irq_triggered = 0;
    irq_counter++;
  }
  else err_code |= (1 << irq_counter);

  CM3DS_MPS2_gpio_SetIntEnable(CM3DS_MPS2_GPIO0, 8);
  CM3DS_MPS2_GPIO0->DATAOUT = (0x9 << 7); // emulating low level input on pin 8.
  CM3DS_MPS2_gpio_ClrIntEnable(CM3DS_MPS2_GPIO0, 8);

  puts("    ...Test GPIO0[8]...\n");

  if(irq_triggered){  //if irq flag set then print message else amend error code
    puts("       Low Level IRQ\n     Detected On Pin 8\n\n");
    irq_triggered = 0;
    irq_counter++;
  }
  else err_code |= (1 << 1);

  CM3DS_MPS2_gpio_SetIntEnable(CM3DS_MPS2_GPIO0, 9);
  CM3DS_MPS2_GPIO0->DATAOUT = (0xD << 7); // emulating rising edge input on pin 9.
  CM3DS_MPS2_gpio_ClrIntEnable(CM3DS_MPS2_GPIO0, 9);

  puts("    ...Test GPIO0[9]...\n");

  if(irq_triggered){  //if irq flag set then print message else amend error code
    puts("      Rising Edge IRQ\n     Detected On Pin 9\n\n");
    irq_triggered = 0;
    irq_counter++;
  }
  else err_code |= (1 << 2);

  CM3DS_MPS2_gpio_SetIntEnable(CM3DS_MPS2_GPIO0, 10);
  CM3DS_MPS2_GPIO0->DATAOUT = (0x5 << 7); // emulating falling edge input on pin 10.
  CM3DS_MPS2_gpio_ClrIntEnable(CM3DS_MPS2_GPIO0, 10);

  puts("    ...Test GPIO0[10]...\n");

  if(irq_triggered){  //if irq flag set then print message else amend error code
    puts("     Falling Edge IRQ:\n     Detected On Pin 10\n\n");
    irq_triggered = 0;
    irq_counter++;
  }
   else err_code |= (1 << 3);

  /* check to see whether intstatus, for the specified pin, is 1, which corresponds to a rising edge interrupt */

  if(irq_counter == 4){
    printf("    All %d IRQs Detected\n\n", irq_counter);
  }


  // print pass or fail message depending on the status of the test

  if(err_code == 0){
    puts("\n");
    puts(" +***********************+");
    puts(" *                       *");
    puts(" *   GPIO 0 IRQ Tests    *");
    puts(" *  Passed Successfully  *");
    puts(" *                       *");
    puts(" +***********************+\n");
  }
  else{

    /*if the port did not have 1 of each IRQs as expected then display error*/

    printf("\n** TEST FAILED ** IRQ Tests Error Code: (0x%x\n", err_code);
  }

  NVIC_DisableIRQ(PORT0_7_IRQn);    //disable GPIO0 IRQ
  NVIC_DisableIRQ(PORT0_8_IRQn);
  NVIC_DisableIRQ(PORT0_9_IRQn);
  NVIC_DisableIRQ(PORT0_10_IRQn);
  NVIC_DisableIRQ(PORT0_ALL_IRQn);
  return err_code;
}

// ----------------------------------------------------------
// Peripheral detection
// ----------------------------------------------------------
/* Detect the part number to see if device is present                */

int gpio0_id_check(void)
{
#define HW32_REG(ADDRESS)  (*((volatile unsigned long  *)(ADDRESS)))
if ((HW32_REG(CM3DS_MPS2_GPIO0_BASE + 0xFE0) != 0x20) ||
    (HW32_REG(CM3DS_MPS2_GPIO0_BASE + 0xFE4) != 0xB8))
  return 1; /* part ID does not match */
else
  return 0;
}

int timer0_id_check(void)
{
if ((HW32_REG(CM3DS_MPS2_TIMER0_BASE + 0xFE0) != 0x22) ||
    (HW32_REG(CM3DS_MPS2_TIMER0_BASE + 0xFE4) != 0xB8))
  return 1; /* part ID does not match */
else
  return 0;
}

int uart2_id_check(void)
{
if ((HW32_REG(CM3DS_MPS2_UART2_BASE + 0xFE0) != 0x21) ||
    (HW32_REG(CM3DS_MPS2_UART2_BASE + 0xFE4) != 0xB8))
  return 1; /* part ID does not match */
else
  return 0;
}
int uart3_id_check(void)
{
if ((HW32_REG(CM3DS_MPS2_UART3_BASE + 0xFE0) != 0x21) ||
    (HW32_REG(CM3DS_MPS2_UART3_BASE + 0xFE4) != 0xB8))
  return 1; /* part ID does not match */
else
  return 0;
}
// ----------------------------------------------------------
// Handlers
// ----------------------------------------------------------
// ---------------------------------
// UART 2 Interrupt service routines
// ---------------------------------
//

void UART2_Handler(void)
{
  CM3DS_MPS2_uart_ClearTxIRQ(CM3DS_MPS2_UART2); // clear TX IRQ
  // If the message output is not finished, output next character
  if (tx_count < uart_str_length) {
    CM3DS_MPS2_uart_SendChar(CM3DS_MPS2_UART2,str_tx[tx_count]);
    tx_count++;
    }

}

// ---------------------------------
// UART 3 Interrupt service routines
// ---------------------------------

void UART3_Handler(void)
{
  CM3DS_MPS2_uart_ClearRxIRQ(CM3DS_MPS2_UART3); //clear RX IRQ
  str_rx[rx_count]=CM3DS_MPS2_uart_ReceiveChar(CM3DS_MPS2_UART3); // Read data
  rx_count++;
}

// ---------------------------------
// Timer 0 Interrupt service routines
// ---------------------------------

void TIMER0_Handler(void)
{
  timer_stopped = 1;                      // set timer stopped bool, so that
                                          // system does not wait for another interrupt
  CM3DS_MPS2_timer_StopTimer(CM3DS_MPS2_TIMER0);    // stop timer
  CM3DS_MPS2_timer_ClearIRQ(CM3DS_MPS2_TIMER0);     // clear timer 0 IRQ
  puts("   [Timer 0 IRQ]");
}

// ---------------------------------
// GPIO Port 0 Interrupt service routines
// ---------------------------------
//
void PORT0_7_Handler(void)
{
  irq_triggered = 1;                            /* high level */
  CM3DS_MPS2_GPIO0->DATAOUT = (0xA << 7);                  /* Deassert Port 0 pin 7 to 0 */
  CM3DS_MPS2_gpio_IntClear(CM3DS_MPS2_GPIO0, 7);        //clear GPIO interrupt on pin N
}

void PORT0_8_Handler(void)
{
  irq_triggered = 1;                            /*low level*/
  CM3DS_MPS2_GPIO0->DATAOUT = (0xB << 7);                  /* Deassert Port 0 pin 8 to 1 */
  CM3DS_MPS2_gpio_IntClear(CM3DS_MPS2_GPIO0, 8);        //clear GPIO interrupt on pin N
}

void PORT0_9_Handler(void)
{
  irq_triggered = 1;                            /*rising edge*/
  CM3DS_MPS2_gpio_IntClear(CM3DS_MPS2_GPIO0, 9);        //clear GPIO interrupt on pin N
}

void PORT0_10_Handler(void)
{
  irq_triggered = 1;                            /*falling edge*/
  CM3DS_MPS2_gpio_IntClear(CM3DS_MPS2_GPIO0, 10);        //clear GPIO interrupt on pin N
}

void PORT0_COMB_Handler(void)   /* Combined handler */
{
  irq_triggered = 1;
  if (CM3DS_MPS2_GPIO0->INTSTATUS & 0x80){ /* high level */
    CM3DS_MPS2_GPIO0->DATAOUT = (0xA << 7);                  /* Deassert Port 0 pin 7 to 0 */
    CM3DS_MPS2_gpio_IntClear(CM3DS_MPS2_GPIO0, 7);        //clear GPIO interrupt on pin N
    }
  if (CM3DS_MPS2_GPIO0->INTSTATUS & 0x100){ /* low level*/
    CM3DS_MPS2_GPIO0->DATAOUT = (0xB << 7);                  /* Deassert Port 0 pin 8 to 1 */
    CM3DS_MPS2_gpio_IntClear(CM3DS_MPS2_GPIO0, 8);        //clear GPIO interrupt on pin N
    }
  if (CM3DS_MPS2_GPIO0->INTSTATUS & 0x200){ /* rising edge*/
    CM3DS_MPS2_gpio_IntClear(CM3DS_MPS2_GPIO0, 9);         //clear GPIO interrupt on pin N
    }
  if (CM3DS_MPS2_GPIO0->INTSTATUS & 0x400){ /* falling edge*/
    CM3DS_MPS2_gpio_IntClear(CM3DS_MPS2_GPIO0, 10);         //clear GPIO interrupt on pin N
    }
  return;
}

