/*
 *-----------------------------------------------------------------------------
 * The confidential and proprietary information contained in this file may
 * only be used by a person authorised under and to the extent permitted
 * by a subsisting licensing agreement from ARM Limited.
 *
 *            (C) COPYRIGHT 2010-2017 ARM Limited.
 *                ALL RIGHTS RESERVED
 *
 * This entire notice must be reproduced on all copies of this file
 * and copies of this file may only be made by a person if such person is
 * permitted to do so under the terms of a subsisting license agreement
 * from ARM Limited.
 *
 *      SVN Information
 *
 *      Checked In          : $Date: 2012-05-28 18:02:02 +0100 (Mon, 28 May 2012) $
 *
 *      Revision            : $Revision: 210375 $
 *
 *      Release Information : CM3DesignStart-r0p0-02rel0
 *-----------------------------------------------------------------------------
 */
/*********************************************************************//******
 * @file     CM3DS_MPS2_driver.c
 * @brief    CM3DS_MPS2 Example Device Driver C File
 * @version  $State:$
 * @date     $Date: 2012-05-28 18:02:02 +0100 (Mon, 28 May 2012) $
 *
 ******************************************************************************/

#include "CM3DS_MPS2.h"



/** \mainpage ARM CM3DS_MPS2 LIBRARY
 *
 *
 * This user manual describes the ARM Corex M Series CM3DS_MPS2 Library which utilises the
 * Cortex Microcontroller Software Interface Standard (CMSIS). it also includes drivers
 * for the following modules:
 *
 *    - UART
 *    - Timer
 *    - GPIO
 *
 * The library contains C and assembly functions that have been ported and tested on the MDK
 * toolchain.
 */


/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @return none
 *
 * @brief  Enable the microcontroller timer interrupts.
 */

 void CM3DS_MPS2_timer_EnableIRQ(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER)
 {
       CM3DS_MPS2_TIMER->CTRL |= CM3DS_MPS2_TIMER_CTRL_IRQEN_Msk;
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @return none
 *
 * @brief  Disable the microcontroller timer interrutps.
 */

 void CM3DS_MPS2_timer_DisableIRQ(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER)
 {
       CM3DS_MPS2_TIMER->CTRL &= ~CM3DS_MPS2_TIMER_CTRL_IRQEN_Msk;
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @return none
 *
 * @brief  Start the Timer.
 */

 void CM3DS_MPS2_timer_StartTimer(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER)
 {
       CM3DS_MPS2_TIMER->CTRL |= CM3DS_MPS2_TIMER_CTRL_EN_Msk;
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @return none
 *
 * @brief  Stop the Timer.
 */

 void CM3DS_MPS2_timer_StopTimer(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER)
 {
       CM3DS_MPS2_TIMER->CTRL &= ~CM3DS_MPS2_TIMER_CTRL_EN_Msk;
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @return TimerValue
 *
 * @brief  Returns the current value of the timer.
 */

 uint32_t CM3DS_MPS2_timer_GetValue(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER)
 {
       return CM3DS_MPS2_TIMER->VALUE;
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @param value the value to which the timer is to be set
 * @return TimerValue
 *
 * @brief  Sets the timer to the specified value.
 */

 void CM3DS_MPS2_timer_SetValue(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER, uint32_t value)
 {
       CM3DS_MPS2_TIMER->VALUE = value;
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @return TimerReload
 *
 * @brief  Returns the reload value of the timer. The reload value is the value which the timer is set to after an underflow occurs.
 */

 uint32_t CM3DS_MPS2_timer_GetReload(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER)
 {
       return CM3DS_MPS2_TIMER->RELOAD;
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @param value Value to be loaded
 * @return none
 *
 * @brief  Sets the reload value of the timer to the specified value. The reload value is the value which the timer is set to after an underflow occurs.
 */

 void CM3DS_MPS2_timer_SetReload(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER, uint32_t value)
 {
       CM3DS_MPS2_TIMER->RELOAD = value;
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @return none
 *
 * @brief  Clears the timer IRQ if set.
 */

 void CM3DS_MPS2_timer_ClearIRQ(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER)
 {
       CM3DS_MPS2_TIMER->INTCLEAR = CM3DS_MPS2_TIMER_INTCLEAR_Msk;
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @return none
 *
 * @brief  Returns the IRQ status of the timer in question.
 */

 uint32_t  CM3DS_MPS2_timer_StatusIRQ(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER)
 {
       return CM3DS_MPS2_TIMER->INTSTATUS;
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @param reload The value to which the timer is to be set after an underflow has occurred
 * @param irq_en Defines whether the timer IRQ is to be enabled
 * @return none
 *
 * @brief  Initialises the timer to use the internal clock and specifies the timer reload value and whether IRQ is enabled or not.
 */

  void CM3DS_MPS2_timer_Init_IntClock(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER, uint32_t reload,
 uint32_t irq_en)
 {
       CM3DS_MPS2_TIMER->CTRL = 0;
       CM3DS_MPS2_TIMER->VALUE = reload;
       CM3DS_MPS2_TIMER->RELOAD = reload;
       if (irq_en!=0)                                                                          /* non zero - enable IRQ */
         CM3DS_MPS2_TIMER->CTRL = (CM3DS_MPS2_TIMER_CTRL_IRQEN_Msk | CM3DS_MPS2_TIMER_CTRL_EN_Msk);
       else{                                                                                   /* zero - do not enable IRQ */
         CM3DS_MPS2_TIMER->CTRL = ( CM3DS_MPS2_TIMER_CTRL_EN_Msk);                                       /* enable timer */
        }
 }

/**
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @param reload The value to which the timer is to be set after an underflow has occurred
 * @param irq_en Defines whether the timer IRQ is to be enabled
 * @return none
 *
 * @brief  Initialises the timer to use the external clock and specifies the timer reload value and whether IRQ is enabled or not.
 */

 void CM3DS_MPS2_timer_Init_ExtClock(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER, uint32_t reload,
 uint32_t irq_en)
 {
       CM3DS_MPS2_TIMER->CTRL = 0;
       CM3DS_MPS2_TIMER->VALUE = reload;
       CM3DS_MPS2_TIMER->RELOAD = reload;
       if (irq_en!=0)                                                                                  /* non zero - enable IRQ */
            CM3DS_MPS2_TIMER->CTRL = (CM3DS_MPS2_TIMER_CTRL_IRQEN_Msk |
                                   CM3DS_MPS2_TIMER_CTRL_SELEXTCLK_Msk |CM3DS_MPS2_TIMER_CTRL_EN_Msk);
       else  {                                                                                         /* zero - do not enable IRQ */
            CM3DS_MPS2_TIMER->CTRL = ( CM3DS_MPS2_TIMER_CTRL_EN_Msk |
                                    CM3DS_MPS2_TIMER_CTRL_SELEXTCLK_Msk);                                   /* enable timer */
         }
 }

/**
 *
 * @brief  Initialises the timer to use the internal clock but with an external enable. It also specifies the timer reload value and whether IRQ is enabled or not.
 *
 * @param *CM3DS_MPS2_TIMER Timer Pointer
 * @param reload The value to which the timer is to be set after an underflow has occurred
 * @param irq_en Defines whether the timer IRQ is to be enabled
 * @return none
 *
 *
 */

 void CM3DS_MPS2_timer_Init_ExtEnable(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER, uint32_t reload,
 uint32_t irq_en)
 {
       CM3DS_MPS2_TIMER->CTRL = 0;
       CM3DS_MPS2_TIMER->VALUE = reload;
       CM3DS_MPS2_TIMER->RELOAD = reload;
       if (irq_en!=0)                                                                                  /* non zero - enable IRQ */
            CM3DS_MPS2_TIMER->CTRL = (CM3DS_MPS2_TIMER_CTRL_IRQEN_Msk |
                                   CM3DS_MPS2_TIMER_CTRL_SELEXTEN_Msk | CM3DS_MPS2_TIMER_CTRL_EN_Msk);
       else  {                                                                                         /* zero - do not enable IRQ */
            CM3DS_MPS2_TIMER->CTRL = ( CM3DS_MPS2_TIMER_CTRL_EN_Msk |
                                    CM3DS_MPS2_TIMER_CTRL_SELEXTEN_Msk);                                    /* enable timer */
         }
 }


  /*UART driver functions*/

/**
 *
 * @brief  Initialises the UART specifying the UART Baud rate divider value and whether the send and recieve functionality is enabled. It also specifies which of the various interrupts are enabled.
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @param divider The value to which the UART baud rate divider is to be set
 * @param tx_en Defines whether the UART transmit is to be enabled
 * @param rx_en Defines whether the UART receive is to be enabled
 * @param tx_irq_en Defines whether the UART transmit buffer full interrupt is to be enabled
 * @param rx_irq_en Defines whether the UART receive buffer full interrupt is to be enabled
 * @param tx_ovrirq_en Defines whether the UART transmit buffer overrun interrupt is to be enabled
 * @param rx_ovrirq_en Defines whether the UART receive buffer overrun interrupt is to be enabled
 * @return 1 if initialisation failed, 0 if successful.
 */

 uint32_t CM3DS_MPS2_uart_init(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART, uint32_t divider, uint32_t tx_en,
                           uint32_t rx_en, uint32_t tx_irq_en, uint32_t rx_irq_en, uint32_t tx_ovrirq_en, uint32_t rx_ovrirq_en)
 {
       uint32_t new_ctrl=0;

       if (tx_en!=0)        new_ctrl |= CM3DS_MPS2_UART_CTRL_TXEN_Msk;
       if (rx_en!=0)        new_ctrl |= CM3DS_MPS2_UART_CTRL_RXEN_Msk;
       if (tx_irq_en!=0)    new_ctrl |= CM3DS_MPS2_UART_CTRL_TXIRQEN_Msk;
       if (rx_irq_en!=0)    new_ctrl |= CM3DS_MPS2_UART_CTRL_RXIRQEN_Msk;
       if (tx_ovrirq_en!=0) new_ctrl |= CM3DS_MPS2_UART_CTRL_TXORIRQEN_Msk;
       if (rx_ovrirq_en!=0) new_ctrl |= CM3DS_MPS2_UART_CTRL_RXORIRQEN_Msk;

       CM3DS_MPS2_UART->CTRL = 0;         /* Disable UART when changing configuration */
       CM3DS_MPS2_UART->BAUDDIV = divider;
       CM3DS_MPS2_UART->CTRL = new_ctrl;  /* Update CTRL register to new value */

       if((CM3DS_MPS2_UART->STATE & (CM3DS_MPS2_UART_STATE_RXOR_Msk | CM3DS_MPS2_UART_STATE_TXOR_Msk))) return 1;
       else return 0;
 }

/**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @return RxBufferFull
 *
 * @brief  Returns whether the RX buffer is full.
 */

 uint32_t CM3DS_MPS2_uart_GetRxBufferFull(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
        return ((CM3DS_MPS2_UART->STATE & CM3DS_MPS2_UART_STATE_RXBF_Msk)>> CM3DS_MPS2_UART_STATE_RXBF_Pos);
 }

/**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @return TxBufferFull
 *
 * @brief  Returns whether the TX buffer is full.
 */

 uint32_t CM3DS_MPS2_uart_GetTxBufferFull(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
        return ((CM3DS_MPS2_UART->STATE & CM3DS_MPS2_UART_STATE_TXBF_Msk)>> CM3DS_MPS2_UART_STATE_TXBF_Pos);
 }

/**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @param txchar Character to be sent
 * @return none
 *
 * @brief  Sends a character to the TX buffer for transmission.
 */

 void CM3DS_MPS2_uart_SendChar(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART, char txchar)
 {
       while(CM3DS_MPS2_UART->STATE & CM3DS_MPS2_UART_STATE_TXBF_Msk);
       CM3DS_MPS2_UART->DATA = (uint32_t)txchar;
 }

/**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @return rxchar
 *
 * @brief  returns the character from the RX buffer which has been received.
 */

 char CM3DS_MPS2_uart_ReceiveChar(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
       while(!(CM3DS_MPS2_UART->STATE & CM3DS_MPS2_UART_STATE_RXBF_Msk));
       return (char)(CM3DS_MPS2_UART->DATA);
 }

/**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @return 0 - No overrun
 * @return 1 - TX overrun
 * @return 2 - RX overrun
 * @return 3 - TX & RX overrun
 *
 * @brief  returns the current overrun status of both the RX & TX buffers.
 */


 uint32_t CM3DS_MPS2_uart_GetOverrunStatus(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
        return ((CM3DS_MPS2_UART->STATE & (CM3DS_MPS2_UART_STATE_RXOR_Msk | CM3DS_MPS2_UART_STATE_TXOR_Msk))>>CM3DS_MPS2_UART_STATE_TXOR_Pos);
 }

/**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @return 0 - No overrun
 * @return 1 - TX overrun
 * @return 2 - RX overrun
 * @return 3 - TX & RX overrun
 *
 * @brief  Clears the overrun status of both the RX & TX buffers and then returns the current overrun status.
 */

 uint32_t CM3DS_MPS2_uart_ClearOverrunStatus(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
       CM3DS_MPS2_UART->STATE = (CM3DS_MPS2_UART_STATE_RXOR_Msk | CM3DS_MPS2_UART_STATE_TXOR_Msk);
        return ((CM3DS_MPS2_UART->STATE & (CM3DS_MPS2_UART_STATE_RXOR_Msk | CM3DS_MPS2_UART_STATE_TXOR_Msk))>>CM3DS_MPS2_UART_STATE_TXOR_Pos);
 }

/**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @return BaudDiv
 *
 * @brief  Returns the current UART Baud rate divider. Note that the Baud rate divider is the difference between the clock frequency and the Baud frequency.
 */

 uint32_t CM3DS_MPS2_uart_GetBaudDivider(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
       return CM3DS_MPS2_UART->BAUDDIV;
 }

 /**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @return TXStatus
 *
 * @brief  Returns the TX interrupt status.
 */

 uint32_t CM3DS_MPS2_uart_GetTxIRQStatus(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
       return ((CM3DS_MPS2_UART->INTSTATUS & CM3DS_MPS2_UART_CTRL_TXIRQ_Msk)>>CM3DS_MPS2_UART_CTRL_TXIRQ_Pos);
 }

/**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @return RXStatus
 *
 * @brief  Returns the RX interrupt status.
 */

 uint32_t CM3DS_MPS2_uart_GetRxIRQStatus(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
       return ((CM3DS_MPS2_UART->INTSTATUS & CM3DS_MPS2_UART_CTRL_RXIRQ_Msk)>>CM3DS_MPS2_UART_CTRL_RXIRQ_Pos);
 }

 /**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @return none
 *
 * @brief  Clears the TX buffer full interrupt status.
 */

 void CM3DS_MPS2_uart_ClearTxIRQ(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
       CM3DS_MPS2_UART->INTCLEAR = CM3DS_MPS2_UART_CTRL_TXIRQ_Msk;
 }

/**
 *
 * @param *CM3DS_MPS2_UART UART Pointer
 * @return none
 *
 * @brief  Clears the RX interrupt status.
 */

 void CM3DS_MPS2_uart_ClearRxIRQ(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
       CM3DS_MPS2_UART->INTCLEAR = CM3DS_MPS2_UART_CTRL_RXIRQ_Msk;
 }


 /*GPIO driver functions*/

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param outenable Bit pattern to be used to set output enable register
 * @return none
 *
 * @brief  Sets pins on a port as an output. Set the bit corresponding to the pin number to 1 for output i.e. Set bit 1 of outenable to 1 to set pin 1 as an output. This function is thread safe.
 */

 void CM3DS_MPS2_gpio_SetOutEnable(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t outenableset)
 {
       CM3DS_MPS2_GPIO->OUTENABLESET = outenableset;
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param outenable Bit pattern to be used to set output enable register
 * @return none
 *
 * @brief  Sets pins on a port as an input. Set the bit corresponding to the pin number to 1 for input i.e. Set bit 1 of outenable to 1 to set pin 1 as an input. This function is thread safe.
 */

 void CM3DS_MPS2_gpio_ClrOutEnable(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t outenableclr)
 {
       CM3DS_MPS2_GPIO->OUTENABLECLR = outenableclr;
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @return outputstatus
 *
 * @brief  returns a uint32_t which defines the whether pins on a port are set as inputs or outputs i.e. if bit 1 of the returned uint32_t is set to 1 then this means that pin 1 is an output.
 */

 uint32_t CM3DS_MPS2_gpio_GetOutEnable(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO)
 {
       return CM3DS_MPS2_GPIO->OUTENABLESET;
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param AltFunc uint32_t to specify whether the alternate function for the pins on the port is enabled
 * @return none
 *
 * @brief  enables the alternative function for pins. Set the bit corresponding to the pin number to 1 for alternate function i.e. Set bit 1 of ALtFunc to 1 to set pin 1 to its alternative function. This function is thread safe.
 */

 void CM3DS_MPS2_gpio_SetAltFunc(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t AltFuncset)
 {
       CM3DS_MPS2_GPIO->ALTFUNCSET = AltFuncset;
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param AltFunc uint32_t to specify whether the alternate function for the pins on the port is enabled
 * @return none
 *
 * @brief  disables the alternative function for pins. Set the bit corresponding to the pin number to 1 to disable alternate function i.e. Set bit 1 of ALtFunc to 1 to set pin 1 to the orignal output function. This function is thread safe.
 */

 void CM3DS_MPS2_gpio_ClrAltFunc(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t AltFuncclr)
 {
       CM3DS_MPS2_GPIO->ALTFUNCCLR = AltFuncclr;
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @return AltFuncStatus
 *
 * @brief  returns a uint32_t which defines the whether pins on a port are set to their alternative or their original output functionality i.e. if bit 1 of the returned uint32_t is set to 1 then this means that pin 1 is set to its alternative function.
 */

 uint32_t CM3DS_MPS2_gpio_GetAltFunc(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO)
 {
       return CM3DS_MPS2_GPIO->ALTFUNCSET;
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param Num The pin number for which to clear the Interrupt
 * @return NewIntStatus
 *
 * @brief  Clears the interrupt flag for the specified pin and then returns the new interrupt status of the pin. This function is thread safe.
 */

 uint32_t CM3DS_MPS2_gpio_IntClear(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num)
 {
       CM3DS_MPS2_GPIO->INTCLEAR = (1 << Num);

       return CM3DS_MPS2_GPIO->INTSTATUS;
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param Num The pin number for which to enable the Interrupt
 * @return NewIntEnStatus
 *
 * @brief  Enables interrupts for the specified pin and then returns the new interrupt enable status of the pin. This function is thread safe.
 */

 uint32_t CM3DS_MPS2_gpio_SetIntEnable(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num)
 {
       CM3DS_MPS2_GPIO->INTENSET = (1 << Num);

       return CM3DS_MPS2_GPIO->INTENSET;
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param Num The pin number for which to disable the Interrupt
 * @return NewIntEnStatus
 *
 * @brief  Disables interrupts for the specified pin and then returns the new interrupt enable status of the pin. This function is thread safe.
 */

  uint32_t CM3DS_MPS2_gpio_ClrIntEnable(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num)
 {
       CM3DS_MPS2_GPIO->INTENCLR = (1 << Num);

       return CM3DS_MPS2_GPIO->INTENCLR;
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param Num The pin number for which to set the Interrupt type
 * @return none
 *
 * @brief  Changes the interrupt type for the specified pin to a high level interrupt. This function is thread safe.
 */

 void CM3DS_MPS2_gpio_SetIntHighLevel(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num)
 {
       CM3DS_MPS2_GPIO->INTTYPECLR = (1 << Num); /* Clear INT TYPE bit */
       CM3DS_MPS2_GPIO->INTPOLSET = (1 << Num);  /* Set INT POLarity bit */
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param Num The pin number for which to set the Interrupt type
 * @return none
 *
 * @brief  Changes the interrupt type for the specified pin to a rising edge interrupt. This function is thread safe.
 */

 void CM3DS_MPS2_gpio_SetIntRisingEdge(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num)
 {
       CM3DS_MPS2_GPIO->INTTYPESET = (1 << Num); /* Set INT TYPE bit */
       CM3DS_MPS2_GPIO->INTPOLSET = (1 << Num);  /* Set INT POLarity bit */
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param Num The pin number for which to set the Interrupt type
 * @return none
 *
 * @brief  Changes the interrupt type for the specified pin to a low level interrupt. This function is thread safe.
 */

 void CM3DS_MPS2_gpio_SetIntLowLevel(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num)
 {
       CM3DS_MPS2_GPIO->INTTYPECLR = (1 << Num);  /* Clear INT TYPE bit */
       CM3DS_MPS2_GPIO->INTPOLCLR = (1 << Num);   /* Clear INT POLarity bit */
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param Num The pin number for which to set the Interrupt type
 * @return none
 *
 * @brief  Changes the interrupt type for the specified pin to a falling edge interrupt. This function is thread safe.
 */

 void CM3DS_MPS2_gpio_SetIntFallingEdge(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num)
 {
       CM3DS_MPS2_GPIO->INTTYPESET = (1 << Num);  /* Set INT TYPE bit */
       CM3DS_MPS2_GPIO->INTPOLCLR = (1 << Num);   /* Clear INT POLarity bit */
 }

/**
 *
 * @param *CM3DS_MPS2_GPIO GPIO Pointer
 * @param mask The output port mask
 * @param value The value to output to the specified port
 * @return none
 *
 * @brief Outputs the specified value on the desired port using the user defined mask to perform Masked access.
 */

 void CM3DS_MPS2_gpio_MaskedWrite(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t value, uint32_t mask)
 {
       CM3DS_MPS2_GPIO->LB_MASKED[0x00FF & mask] = value;
       CM3DS_MPS2_GPIO->UB_MASKED[((0xFF00 & mask) >> 8)] = value;
 }

 /*I2S driver functions*/
 int CM3DS_MPS2_i2s_config(CM3DS_MPS2_I2S_TypeDef *pI2S,
                uint32_t tx_enable, uint32_t tx_int_enable, uint32_t tx_waterlevel,
                uint32_t rx_enable, uint32_t rx_int_enable, uint32_t rx_waterlevel)
 {
   uint32_t i2s_control_val;
   // TX water level range from 3 to 0
   // Generate IRQ if TX Fifo space > TX water level
   if (tx_waterlevel > 3) return 1; // Error if out of range
   // RX water level range from 4 to 1
   // Generate IRQ if RX Fifo space < RX water level
   if ((rx_waterlevel > 4)||(rx_waterlevel == 0)) return 1; // Error if out of range

     i2s_control_val  = (rx_waterlevel << CM3DS_MPS2_I2S_CONTROL_RXWLVL_Pos) |
                      (tx_waterlevel << CM3DS_MPS2_I2S_CONTROL_TXWLVL_Pos) |
               (rx_int_enable & 0x1) << CM3DS_MPS2_I2S_CONTROL_RXIRQEN_Pos |
                   (rx_enable & 0x1) << CM3DS_MPS2_I2S_CONTROL_RXEN_Pos    |
               (tx_int_enable & 0x1) << CM3DS_MPS2_I2S_CONTROL_TXIRQEN_Pos |
                  (tx_enable & 0x1) << CM3DS_MPS2_I2S_CONTROL_TXEN_Pos;

   pI2S->CONTROL  = i2s_control_val;
   return 0;
 }

 int CM3DS_MPS2_i2s_tx_fifo_empty(CM3DS_MPS2_I2S_TypeDef *pI2S){
   return (pI2S->STATUS & CM3DS_MPS2_I2S_STATUS_TXEmpty_Msk) >> CM3DS_MPS2_I2S_STATUS_TXEmpty_Pos;
   }

 int CM3DS_MPS2_i2s_tx_fifo_full(CM3DS_MPS2_I2S_TypeDef *pI2S){
   return (pI2S->STATUS & CM3DS_MPS2_I2S_STATUS_TXFull_Msk)  >> CM3DS_MPS2_I2S_STATUS_TXFull_Pos;
   }

 int CM3DS_MPS2_i2s_rx_fifo_empty(CM3DS_MPS2_I2S_TypeDef *pI2S){
   return (pI2S->STATUS & CM3DS_MPS2_I2S_STATUS_RXEmpty_Msk) >> CM3DS_MPS2_I2S_STATUS_RXEmpty_Pos;
   }

 int CM3DS_MPS2_i2s_rx_fifo_full(CM3DS_MPS2_I2S_TypeDef *pI2S){
   return (pI2S->STATUS & CM3DS_MPS2_I2S_STATUS_RXFull_Msk)  >> CM3DS_MPS2_I2S_STATUS_RXFull_Pos;
   }

 int CM3DS_MPS2_i2s_rx_irq_alert(CM3DS_MPS2_I2S_TypeDef *pI2S){
   return (pI2S->STATUS & CM3DS_MPS2_I2S_STATUS_RXIRQ_Msk)  >> CM3DS_MPS2_I2S_STATUS_RXIRQ_Pos;
   }

 int CM3DS_MPS2_i2s_tx_irq_alert(CM3DS_MPS2_I2S_TypeDef *pI2S){
   return (pI2S->STATUS & CM3DS_MPS2_I2S_STATUS_TXIRQ_Msk)  >> CM3DS_MPS2_I2S_STATUS_TXIRQ_Pos;
   }

 int CM3DS_MPS2_i2s_tx_stop(CM3DS_MPS2_I2S_TypeDef *pI2S){
   pI2S->CONTROL &= ~CM3DS_MPS2_I2S_CONTROL_TXEN_Msk;
   return 0;
   }

 int CM3DS_MPS2_i2s_rx_stop(CM3DS_MPS2_I2S_TypeDef *pI2S){
   pI2S->CONTROL &= ~CM3DS_MPS2_I2S_CONTROL_RXEN_Msk;
   return 0;
   }

 int CM3DS_MPS2_i2s_get_tx_error(CM3DS_MPS2_I2S_TypeDef *pI2S){
   return ((pI2S->ERROR & CM3DS_MPS2_I2S_ERROR_TXERR_Msk) >> CM3DS_MPS2_I2S_ERROR_TXERR_Pos);
   }

 int CM3DS_MPS2_i2s_get_rx_error(CM3DS_MPS2_I2S_TypeDef *pI2S){
   return ((pI2S->ERROR & CM3DS_MPS2_I2S_ERROR_RXERR_Msk) >> CM3DS_MPS2_I2S_ERROR_RXERR_Pos);
   }

 void CM3DS_MPS2_i2s_clear_tx_error(CM3DS_MPS2_I2S_TypeDef *pI2S){
   pI2S->ERRORCLR = CM3DS_MPS2_I2S_ERROR_TXERR_Msk;
   return;
   }

 void CM3DS_MPS2_i2s_clear_rx_error(CM3DS_MPS2_I2S_TypeDef *pI2S){
   pI2S->ERRORCLR = CM3DS_MPS2_I2S_ERROR_RXERR_Msk;
   return;;
   }

 void CM3DS_MPS2_i2s_fifo_reset(CM3DS_MPS2_I2S_TypeDef *pI2S){
   pI2S->CONTROL |= CM3DS_MPS2_I2S_CONTROL_FIFORST_Msk;
   pI2S->CONTROL &= ~CM3DS_MPS2_I2S_CONTROL_FIFORST_Msk;
   return;
   }

 void CM3DS_MPS2_i2s_codec_reset(CM3DS_MPS2_I2S_TypeDef *pI2S){
   int i;
   pI2S->CONTROL |= CM3DS_MPS2_I2S_CONTROL_CODECRST_Msk;
   for (i=0;i<6;i++) { // delay loop
     __NOP();
     }
   pI2S->CONTROL &= ~CM3DS_MPS2_I2S_CONTROL_CODECRST_Msk;
   return;
   }

 int CM3DS_MPS2_i2s_speed_config(CM3DS_MPS2_I2S_TypeDef *pI2S, uint32_t divide_ratio){
   if (divide_ratio < 18) return 1; // Error: Divide ratio too small to send all bits
   if (divide_ratio > 0x3FF) return 1; // Error: Divide ratio too large (only 10 bits)

   pI2S->DIVIDE = divide_ratio;
   return 0;
   }

 /*I2C driver functions*/
 // Write 8 bits of data to the serial bus
 void CM3DS_MPS2_i2c_send_byte(unsigned char c)
 {
     int loop;

     for (loop = 0; loop < 8; loop++) {
         // apSleepus(1);
         CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;
         // apSleepus(1);
         if (c & (1 << (7 - loop)))
             CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk;
         else
             CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SDA_Msk;
         // apSleepus(1);
         CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SCL_Msk;
         // apSleepus(1);
         CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;
     }

     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);
 }

 // Read 8 bits of data from the serial bus
 unsigned char CM3DS_MPS2_i2c_receive_byte(void)
 {
     int data, loop;

     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk;
     data         = 0;

     for (loop = 0; loop < 8; loop++) {
         // apSleepus(1);
         CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;
         // apSleepus(1);
         CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SCL_Msk | CM3DS_MPS2_I2C_SDA_Msk;
         // apSleepus(1);
         if ((CM3DS_MPS2_I2C->CONTROL & CM3DS_MPS2_I2C_SDA_Msk))
             data += (1 << (7 - loop));
         // apSleepus(1);
         CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;
     }

     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);

     return data;
 }

 // Read the acknowledge bit
 int CM3DS_MPS2_i2c_receive_ack(void)
 {
     int nack;

     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     nack = CM3DS_MPS2_I2C->CONTROL & CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);
     if(nack==0)
         return 1;

     return 0;
 }

 // Write the acknowledge bit
 void CM3DS_MPS2_i2c_send_ack(void)
 {
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);
 }

 // Write data stream and read one byte
 unsigned char CM3DS_MPS2_i2c_read(unsigned char reg_addr, unsigned char sadr)
 {
     unsigned char rxdata;

     // Start bit
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk | CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);

     // Set serial and register address
     CM3DS_MPS2_i2c_send_byte(sadr);
     CM3DS_MPS2_i2c_receive_ack();
     CM3DS_MPS2_i2c_send_byte(reg_addr);
     CM3DS_MPS2_i2c_receive_ack();

     // Start bit
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk | CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);

     // Read from serial address
     CM3DS_MPS2_i2c_send_byte(sadr | 1);
     CM3DS_MPS2_i2c_receive_ack();
     rxdata = CM3DS_MPS2_i2c_receive_byte();
     CM3DS_MPS2_i2c_send_ack();

     // Stop bit, clock the ack
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;

     // Actual stop bit
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);

     return rxdata;
 }

 // Write data stream and write one byte
 void CM3DS_MPS2_i2c_write(unsigned char reg_addr, unsigned char data_byte, unsigned char sadr)
 {
     // Start bit
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk | CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);

     // Set serial and register address
     CM3DS_MPS2_i2c_send_byte(sadr);
     CM3DS_MPS2_i2c_receive_ack();
     CM3DS_MPS2_i2c_send_byte(reg_addr);
     CM3DS_MPS2_i2c_receive_ack();
     CM3DS_MPS2_i2c_send_byte(data_byte);

     // Stop bit, clock the ack
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SCL_Msk;

     // Actual stop bit
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROLC = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SCL_Msk;
     // apSleepus(1);
     CM3DS_MPS2_I2C->CONTROL = CM3DS_MPS2_I2C_SDA_Msk;
     // apSleepus(1);
 }
