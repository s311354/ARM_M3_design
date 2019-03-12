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
 *      Checked In          : $Date: 2013-03-27 23:58:01 +0000 (Wed, 27 Mar 2013) $
 *
 *      Revision            : $Revision: 242484 $
 *
 *      Release Information : CM3DesignStart-r0p0-02rel0
 *-----------------------------------------------------------------------------
 */

/*
  A simple test to check the functionalities of UART functions in the example device driver.
*/

#include "CM3DS_MPS2.h"
#include <stdio.h>
#include "string.h"
#include "uart_stdout.h"
#include "CM3DS_MPS2_driver.h"
#include "CM3DS_function.h"

/* variables shared between interrupt handlers and test program code */
int volatile uart_txorirq_executed = 0;  /* set to 1 if UARTOVF_Handler (tx overflow) executed */
int volatile uart_txorirq_counter = 0;   /* number of time UARTOVF_Handler (tx overflow) executed */
int volatile uart_data_received = 0;     /* set to 1 if UART3_Handler (rx) executed */
int volatile uart_data_sent = 0;         /* set to 1 if UART2_Handler (tx) executed */
int volatile uart_rxorirq_executed = 0;  /* set to 1 if UARTOVF_Handler (rx overflow) executed */
int volatile uart_rxorirq_counter = 0;   /* number of time UARTOVF_Handler (rx overflow) executed */

/* Test Functions declarations */
int Uart_Init(void);      /* Function to test UART initialization */
int Uart_Buffull(void);   /* Function to test UART buffer full */
int Uart_OR(void);        /* Function to test UART overrun */
int Uart_IRQ(void);       /* Function to test UART interrupt */
int uart2_id_check(void);  /* Detect UART 2 present */
int uart3_id_check(void);  /* Detect UART 3 present */
int gpio0_id_check(void);  /* Detect GPIO 0 present */
int gpio1_id_check(void);  /* Detect GPIO 1 present */

int main (void)
{
  int result = 0;

  // UART init
  UartStdOutInit();

  // Test banner message and revision number
  puts("\nCortex-M3 DesignStart - UART Driver Test - revision $Revision: 242484 $\n");

  if ((uart2_id_check()!=0)||(uart3_id_check()!=0)||(gpio0_id_check()!=0)||(gpio1_id_check()!=0)) {
    puts("** TEST SKIPPED ** UART 2 / UART 3 / GPIO 0 / GPIO 1 not available");
    UartEndSimulation();
    return 0;}


  result |= Uart_Init();
  result |= Uart_Buffull();
  result |= Uart_OR();
  result |= Uart_IRQ();

  if (result == 0) {
    puts("** TEST PASSED **\n");
  } else {
    printf("** TEST FAILED **, Error code: (0x%x)\n", result);
  }

  UartEndSimulation();
  return 0;
}

void UARTOVF_Handler(void)                                   /*UART Overrun ISR*/
{
if(CM3DS_MPS2_uart_GetOverrunStatus(CM3DS_MPS2_UART2) == 1){
    uart_txorirq_executed = 1;                                /*set TX Overrun flag*/
    uart_txorirq_counter++;                                   /*increment TX Overrun counter*/
    CM3DS_MPS2_uart_ClearOverrunStatus(CM3DS_MPS2_UART2);             /*clear UART2 Overrun IRQ*/
  }
if(CM3DS_MPS2_uart_GetOverrunStatus(CM3DS_MPS2_UART3) == 2){
    uart_rxorirq_executed = 1;                                /*set RX Overrun flag*/
    uart_rxorirq_counter++;                                   /*increment RX Overrun counter*/
    CM3DS_MPS2_uart_ClearOverrunStatus(CM3DS_MPS2_UART3);             /*clear UART3 Overrun IRQ*/
  }
}


void UART2_Handler(void)                    /*UART2 TX RX ISR*/
{
  if(CM3DS_MPS2_uart_GetTxIRQStatus(CM3DS_MPS2_UART2) == 1) {
    uart_data_sent = 1;                         /*set data sent flag*/
    CM3DS_MPS2_uart_ClearTxIRQ(CM3DS_MPS2_UART2);       /*clear UART2 TX IRQ*/
  }
  if(CM3DS_MPS2_uart_GetRxIRQStatus(CM3DS_MPS2_UART2) == 1) {
    uart_data_received = 1;                         /*set data received flag*/
    CM3DS_MPS2_uart_ClearRxIRQ(CM3DS_MPS2_UART2);       /*clear UART2 RX IRQ*/
  }
}

void UART3_Handler(void)                    /*UART3 TX RX ISR*/
{
  if(CM3DS_MPS2_uart_GetTxIRQStatus(CM3DS_MPS2_UART3) == 1) {
    uart_data_sent = 1;                         /*set data sent flag*/
    CM3DS_MPS2_uart_ClearTxIRQ(CM3DS_MPS2_UART3);       /*clear UART3 TX IRQ*/
  }
  if(CM3DS_MPS2_uart_GetRxIRQStatus(CM3DS_MPS2_UART3) == 1) {
    uart_data_received = 1;                         /*set data received flag*/
    CM3DS_MPS2_uart_ClearRxIRQ(CM3DS_MPS2_UART3);       /*clear UART3 RX IRQ*/
  }
}

/* Initialize UART and check return status */
int Uart_Init(void)
{
  int err_code = 0;

  puts("\nStage 1 UART Initialization\n");        //initialise UART2 and UART3 with Baud divider of 32
                                                  //and all interrupts enabled and also tx and rx enabled
  CM3DS_MPS2_gpio_SetAltFunc(CM3DS_MPS2_GPIO0, 0x0011);
  CM3DS_MPS2_gpio_SetAltFunc(CM3DS_MPS2_GPIO1, 0x4400);
  if(CM3DS_MPS2_uart_init(CM3DS_MPS2_UART2, 0x20, 1, 1, 1, 1, 1, 1) == 0)
    printf("UART2 Initialised Successfully (Baud Divider of: %d)\n", CM3DS_MPS2_uart_GetBaudDivider(CM3DS_MPS2_UART2));
    /* CM3DS_MPS2_uart_init() returns 1 if the overflow status is non-zero */
  else
  {
    puts("UART2 Initialization Failed\n");
    err_code = 1;
  }
  if(CM3DS_MPS2_uart_init(CM3DS_MPS2_UART3, 0x20, 1, 1, 1, 1, 1, 1) == 0)
    printf("UART3 Initialised Successfully (Baud Divider of: %d)\n", CM3DS_MPS2_uart_GetBaudDivider(CM3DS_MPS2_UART3));
    /* CM3DS_MPS2_uart_init() returns 1 if the overflow status is non-zero */
  else
  {
    puts("UART3 Initialization Failed\n");
    err_code |= 2;
  }

  if(!err_code) return 0;
  else return 1;
  }


int Uart_Buffull(void)             //function for testing the Buffer full functions and simple transmission
{
  int err_code = 0;
  int i, k;
  char received[12] = {0,0,0,0, 0,0,0,0, 0,0,0,0};
  char transmit[12] = "hello world";

  puts("\nStage 2 Simple Transmission - TX and RX Test\n");

  i = 0; /* transmit character counter */
  k = 0; /* receive character counter */

  while((CM3DS_MPS2_uart_GetTxBufferFull(CM3DS_MPS2_UART2) == 0)){    //while the TX buffer is not full send it data to transmit
    CM3DS_MPS2_UART2->DATA = (uint32_t)transmit[i];
    i++;
  }

  if(CM3DS_MPS2_uart_GetTxBufferFull(CM3DS_MPS2_UART2)) puts("TX Buffer Full ...restarting transmission");
  else{
    err_code = (1 << 0);
    printf("** TEST FAILED **, Error Code: (0x%x)", err_code);
  }

  /*receive data from transmission and dispose of it*/

  if(CM3DS_MPS2_uart_GetRxBufferFull(CM3DS_MPS2_UART3) == 1) CM3DS_MPS2_uart_ReceiveChar(CM3DS_MPS2_UART3);
  else{
    err_code = (1 << 1);
    printf("** TEST FAILED **, Error Code: (0x%x)", err_code);
  }

  i = 0;

  while(k < 12){   //while received string is not the length of the original string

    if(CM3DS_MPS2_uart_GetRxBufferFull(CM3DS_MPS2_UART3) == 1){   //receive data from RX buffer when full
      received[k] = CM3DS_MPS2_uart_ReceiveChar(CM3DS_MPS2_UART3);
      printf("RX Buffer Full ...receiving data... %c\n", received[k]);
      k++;
    }

    /*Send data to TX buffer if the TX buffer is not
    full and the RX buffer of UART3 is also not full.
    The receive buffer status is checked because the
    printf statement in the receive polling takes
    long time so this code cannot handle maximum
    throughput */

    if((CM3DS_MPS2_uart_GetTxBufferFull(CM3DS_MPS2_UART2) == 0) && (CM3DS_MPS2_uart_GetRxBufferFull(CM3DS_MPS2_UART3) != 1)){
      if(i < 12){
        CM3DS_MPS2_UART2->DATA = (uint32_t)transmit[i];
        i++;
      }
    }
  }
  printf("\nCharacters received: %s\n", received);    //when all characters received print the received string

  if(strcmp(received, transmit)){
    err_code = 4;
    puts("** TEST FAILED **, Error : Strings DO Not Match!");
  }

  if(!err_code) return 0;
  else return 2;
}

int Uart_OR(void)              /*function to test driver Overrun functions*/
{
  int i = 0, TX = 0, RX = 0, err_code = 0;
  char transmit[12] = "hello world";

  puts("\nStage 3 Polling");

  puts("\n- Stage 3a Overrun Polling\n");

  while(1)
  {
    if(i < 4) CM3DS_MPS2_UART2->DATA = (uint32_t)'a';                     //if the loop iteration, the value of i, is less
                                                                      //that 4 then send the TX buffer data to cause a
    while(i > 10){                                                    //TX overrun if the loop iteration, i, is greater
      CM3DS_MPS2_UART2->DATA = (uint32_t)'a';                             //than 10 then send the TX buffer to cause another
      if(CM3DS_MPS2_uart_GetOverrunStatus(CM3DS_MPS2_UART2) == 1) break;      //TX buffer overrun
    }

  if(CM3DS_MPS2_uart_GetOverrunStatus(CM3DS_MPS2_UART2) == 1){
    puts("TX Buffer Overrun Occurred");
    CM3DS_MPS2_uart_ClearOverrunStatus(CM3DS_MPS2_UART2);
    TX = 1;
  }else if(CM3DS_MPS2_uart_GetOverrunStatus(CM3DS_MPS2_UART3) == 2){
    puts("RX Buffer Overrun Occurred");                             //RX buffer overrun will occur as the data
    CM3DS_MPS2_uart_ClearOverrunStatus(CM3DS_MPS2_UART3);                   //is never read from the RX buffer
    RX = 1;
  }

  i++;
  if(RX & TX) break;
 }

  puts("\n- Stage 3b TX & RX IRQ Polling\n");

  //clear the TX IRQ status and then print the new status
  CM3DS_MPS2_uart_ClearTxIRQ(CM3DS_MPS2_UART2);
  printf("TX IRQ Status: %d\n", CM3DS_MPS2_uart_GetTxIRQStatus(CM3DS_MPS2_UART2));

  if(CM3DS_MPS2_uart_GetTxIRQStatus(CM3DS_MPS2_UART2)) err_code = (1 << 0);

  //clear the RX IRQ status and then print the new status
  CM3DS_MPS2_uart_ClearRxIRQ(CM3DS_MPS2_UART3);
  printf("RX IRQ Status: %d\n", CM3DS_MPS2_uart_GetRxIRQStatus(CM3DS_MPS2_UART3));

  if(CM3DS_MPS2_uart_GetRxIRQStatus(CM3DS_MPS2_UART3)) err_code = (1 << 1);

  CM3DS_MPS2_uart_SendChar(CM3DS_MPS2_UART2, transmit[1]);

  while(!CM3DS_MPS2_uart_GetTxIRQStatus(CM3DS_MPS2_UART2));
  printf("TX IRQ Status: %d\n", CM3DS_MPS2_uart_GetTxIRQStatus(CM3DS_MPS2_UART2));     //send data and wait until the TX IRQ status
  if(!CM3DS_MPS2_uart_GetTxIRQStatus(CM3DS_MPS2_UART2)) err_code = (1 << 2);           //is set and then print the new status
  else CM3DS_MPS2_uart_ClearTxIRQ(CM3DS_MPS2_UART2);


  while(!CM3DS_MPS2_uart_GetRxIRQStatus(CM3DS_MPS2_UART3));
  printf("RX IRQ Status: %d\n", CM3DS_MPS2_uart_GetRxIRQStatus(CM3DS_MPS2_UART3));     //send data and wait until the RX IRQ status
  if(!CM3DS_MPS2_uart_GetRxIRQStatus(CM3DS_MPS2_UART3)) err_code = (1 << 3);           //is set and then print the new status
  else CM3DS_MPS2_uart_ClearRxIRQ(CM3DS_MPS2_UART3);



  if(err_code){
    printf("** TEST FAILED **, Polling Test Error Code: (0x%x)", err_code);
  }
  else puts("Polling Test Passed");

  if(!err_code) return 0;
  else return 4;
}

int Uart_IRQ(void){

/*function to test the TX & RX overrun IRQ functions and the TX and RX IRQ driver
  functions using a simple interrupt orientated send and receive*/

  int i = 0, j = 0; /* i=transmit character counter, j = receive character counter */
  int err_code = 0;
  char received[12] = {0,0,0,0, 0,0,0,0, 0,0,0,0};
  char transmit[12] = "hello world";

  puts("\nStage 4 IRQ\n");
  puts("- Stage 4a Overrun IRQ\n");

  CM3DS_MPS2_uart_init(CM3DS_MPS2_UART2, 0x20, 1, 1, 0, 1, 1, 1); //disable UART2 TX
  CM3DS_MPS2_uart_init(CM3DS_MPS2_UART3, 0x20, 1, 1, 1, 0, 1, 1); //disable UART3 RX

  NVIC_EnableIRQ(UARTOVF_IRQn);         //enable UART overflow IRQs

  while(uart_txorirq_counter <= 3)       //repeat until 3 TX OR IRQs have occurred
  {
    if(uart_txorirq_executed){
      puts("UART TX Overrun IRQ");       //if an TX OR IRQ is performed then this variable is set,
      uart_txorirq_executed = 0;         //uart_txorirq_executed, and this statement will be printed
    }
    CM3DS_MPS2_UART2->DATA = (uint32_t)'a';  //always send data to the TX buffer to cause TX OR and do not
    if(uart_rxorirq_executed){           //receive data to cause RX OR
      puts("UART RX Overrun IRQ");
      uart_rxorirq_executed = 0;
    }
  }

  if(uart_rxorirq_counter < 3){
    err_code = (1 << 0);
    printf("** TEST FAILED ** UART RX Overrun Error, Error Code: (0x%x)", err_code);
  }
  else puts("UART RX Overrun Passed");

  j = 0;
  uart_data_received = 1;  //set uart_data_received to one so that the first character is sent

  puts("\n- Stage 4b TX/RX IRQ\n");

  /*- Send a character from the transmit variable
    - When its received by UART3 transfer it from RX buffer to the received variable
    - set flag to say it's been received
    - when received flag has been set send the next character from transmit variable
    - repeat until all characters have been received*/

  CM3DS_MPS2_uart_init(CM3DS_MPS2_UART2, 0x20, 1, 1, 1, 1, 1, 1); //enable UART2 TX IRQ
  CM3DS_MPS2_uart_init(CM3DS_MPS2_UART3, 0x20, 1, 1, 1, 1, 1, 1); //enable UART3 RX IRQ

  NVIC_EnableIRQ(UART2_IRQn);   //enable both UART2 and UART3 IRQs
  NVIC_EnableIRQ(UART3_IRQn);

  while(j < 11)   /*while j, the received character counter, is less than 11, the number of characters to be sent*/
  { /* uart_data_received and uart_data_sent are updated by TX and RX handlers */
    if(uart_data_received){
      puts("UART TX IRQ ....data sent");                    //if the data has been received (which is set in the
      CM3DS_MPS2_uart_SendChar(CM3DS_MPS2_UART2, transmit[i]);      //RX IRQ) then send the character corresponding to
      i++;                                                  //the character counter, i, increment character counter
      uart_data_received = 0;
    }
    if(uart_data_sent){                                     //if the data has been set (which is set in the
      printf("UART RX IRQ ....data received.... ");         //TX IRQ) then receive the character corresponding to
      received[j] = CM3DS_MPS2_uart_ReceiveChar(CM3DS_MPS2_UART3);  //the character counter, j, increment character counter
      printf("%c\n", received[j]);
      j++;
      uart_data_sent = 0;
    }
  }

  printf("\nString received: %s\n\n", received);

  if(strcmp(received, transmit)){
    err_code = 1;
    puts("** TEST FAILED ** Strings Do Not Match!");
  }

  NVIC_DisableIRQ(UARTOVF_IRQn);       //disable all the enabled IRQs
  NVIC_DisableIRQ(UART2_IRQn);
  NVIC_DisableIRQ(UART3_IRQn);

  if(!err_code) return 0;
  else return 8;
}

// ----------------------------------------------------------
// Peripheral detection
// ----------------------------------------------------------
/* Detect the part number to see if device is present                */

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

int gpio0_id_check(void)
{
if ((HW32_REG(CM3DS_MPS2_GPIO0_BASE + 0xFE0) != 0x20) ||
    (HW32_REG(CM3DS_MPS2_GPIO0_BASE + 0xFE4) != 0xB8))
  return 1; /* part ID does not match */
else
  return 0;
}

int gpio1_id_check(void)
{
if ((HW32_REG(CM3DS_MPS2_GPIO1_BASE + 0xFE0) != 0x20) ||
    (HW32_REG(CM3DS_MPS2_GPIO1_BASE + 0xFE4) != 0xB8))
  return 1; /* part ID does not match */
else
  return 0;
}
