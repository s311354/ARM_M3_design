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
/*************************************************************************//**
 * @file     CM3DS_MPS2_driver.h
 * @brief    CM3DS_MPS2 Driver Header File
 * @version  $State:$
 * @date     $Date: 2012-05-28 18:02:02 +0100 (Mon, 28 May 2012) $
 *
 ******************************************************************************/


/** @addtogroup CMSIS_CM3DS_MPS2_Driver_definitions CM3DS_MPS2 Driver definitions
  This file defines all CM3DS_MPS2 Driver functions for CMSIS core for the following modules:
    - Timer
    - UART
    - GPIO
    - I2S
    - I2C
  @{
 */

 #include "CM3DS_MPS2.h"


 /*UART Driver Declarations*/

  /**
   * @brief Initializes UART module.
   */

 extern uint32_t CM3DS_MPS2_uart_init(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART, uint32_t divider, uint32_t tx_en,
                           uint32_t rx_en, uint32_t tx_irq_en, uint32_t rx_irq_en, uint32_t tx_ovrirq_en, uint32_t rx_ovrirq_en);

  /**
   * @brief Returns whether the UART RX Buffer is Full.
   */

 extern uint32_t CM3DS_MPS2_uart_GetRxBufferFull(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART);

  /**
   * @brief Returns whether the UART TX Buffer is Full.
   */

 extern uint32_t CM3DS_MPS2_uart_GetTxBufferFull(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART);

  /**
   * @brief Sends a character to the UART TX Buffer.
   */


 extern void CM3DS_MPS2_uart_SendChar(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART, char txchar);

  /**
   * @brief Receives a character from the UART RX Buffer.
   */

 extern char CM3DS_MPS2_uart_ReceiveChar(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART);

  /**
   * @brief Returns UART Overrun status.
   */

 extern uint32_t CM3DS_MPS2_uart_GetOverrunStatus(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART);

  /**
   * @brief Clears UART Overrun status Returns new UART Overrun status.
   */

 extern uint32_t CM3DS_MPS2_uart_ClearOverrunStatus(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART);

  /**
   * @brief Returns UART Baud rate Divider value.
   */

 extern uint32_t CM3DS_MPS2_uart_GetBaudDivider(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART);

  /**
   * @brief Return UART TX Interrupt Status.
   */

 extern uint32_t CM3DS_MPS2_uart_GetTxIRQStatus(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART);

  /**
   * @brief Return UART RX Interrupt Status.
   */

 extern uint32_t CM3DS_MPS2_uart_GetRxIRQStatus(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART);

  /**
   * @brief Clear UART TX Interrupt request.
   */

 extern void CM3DS_MPS2_uart_ClearTxIRQ(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART);

  /**
   * @brief Clear UART RX Interrupt request.
   */

 extern void CM3DS_MPS2_uart_ClearRxIRQ(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART);

  /**
   * @brief Set CM3DS_MPS2 Timer for multi-shoot mode with internal clock
   */

 /*Timer Driver Declarations*/

 extern void CM3DS_MPS2_timer_Init_IntClock(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER, uint32_t reload,
 uint32_t irq_en);

  /**
   * @brief Set CM3DS_MPS2 Timer for multi-shoot mode with external enable
   */

 extern void CM3DS_MPS2_timer_Init_ExtClock(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER, uint32_t reload,
 uint32_t irq_en);


  /**
   * @brief Set CM3DS_MPS2 Timer for multi-shoot mode with external clock
   */

 extern void CM3DS_MPS2_timer_Init_ExtEnable(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER, uint32_t reload,
 uint32_t irq_en);

  /**
   * @brief CM3DS_MPS2 Timer interrupt clear
   */


 extern void CM3DS_MPS2_timer_ClearIRQ(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);

  /**
   * @brief Returns timer IRQ status
   */

 uint32_t  CM3DS_MPS2_timer_StatusIRQ(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);

  /**
   * @brief Returns Timer Reload value.
   */

 extern uint32_t CM3DS_MPS2_timer_GetReload(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);

  /**
   * @brief Sets Timer Reload value.
   */

 extern void CM3DS_MPS2_timer_SetReload(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER, uint32_t value);

  /**
   * @brief Returns Timer current value.
   */

 uint32_t CM3DS_MPS2_timer_GetValue(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);

  /**
   * @brief Sets Timer current value.
   */

 extern void CM3DS_MPS2_timer_SetValue(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER, uint32_t value);

  /**
   * @brief Stops CM3DS_MPS2 Timer.
   */

 extern void CM3DS_MPS2_timer_StopTimer(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);

  /**
   * @brief Starts CM3DS_MPS2 Timer.
   */

 extern void CM3DS_MPS2_timer_StartTimer(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);

  /**
   * @brief Enables CM3DS_MPS2 Timer Interrupt requests.
   */

 extern void CM3DS_MPS2_timer_EnableIRQ(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);

  /**
   * @brief Disables CM3DS_MPS2 Timer Interrupt requests.
   */

 extern void CM3DS_MPS2_timer_DisableIRQ(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);

  /**
   * @brief Set CM3DS_MPS2 GPIO Output Enable.
   */

 /*GPIO Driver Declarations*/

 extern void CM3DS_MPS2_gpio_SetOutEnable(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t outenableset);

  /**
   * @brief Clear CM3DS_MPS2 GPIO Output Enable.
   */

 extern void CM3DS_MPS2_gpio_ClrOutEnable(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t outenableclr);

  /**
   * @brief Returns CM3DS_MPS2 GPIO Output Enable.
   */

 extern uint32_t CM3DS_MPS2_gpio_GetOutEnable(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO);

  /**
   * @brief Set CM3DS_MPS2 GPIO Alternate function Enable.
   */

 extern void CM3DS_MPS2_gpio_SetAltFunc(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t AltFuncset);

  /**
   * @brief Clear CM3DS_MPS2 GPIO Alternate function Enable.
   */

 extern void CM3DS_MPS2_gpio_ClrAltFunc(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t AltFuncclr);

  /**
   * @brief Returns CM3DS_MPS2 GPIO Alternate function Enable.
   */

 extern uint32_t CM3DS_MPS2_gpio_GetAltFunc(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO);

  /**
   * @brief Clear CM3DS_MPS2 GPIO Interrupt request.
   */

 extern uint32_t CM3DS_MPS2_gpio_IntClear(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num);

  /**
   * @brief Enable CM3DS_MPS2 GPIO Interrupt request.
   */

 extern uint32_t CM3DS_MPS2_gpio_SetIntEnable(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num);

  /**
   * @brief Disable CM3DS_MPS2 GPIO Interrupt request.
   */

 extern uint32_t CM3DS_MPS2_gpio_ClrIntEnable(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num);

  /**
   * @brief Setup CM3DS_MPS2 GPIO Interrupt as high level.
   */

 extern void CM3DS_MPS2_gpio_SetIntHighLevel(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num);

   /**
   * @brief Setup CM3DS_MPS2 GPIO Interrupt as rising edge.
   */

 extern void CM3DS_MPS2_gpio_SetIntRisingEdge(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num);

     /**
   * @brief Setup CM3DS_MPS2 GPIO Interrupt as low level.
   */

 extern void CM3DS_MPS2_gpio_SetIntLowLevel(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num);

    /**
   * @brief Setup CM3DS_MPS2 GPIO Interrupt as falling edge.
   */

 extern void CM3DS_MPS2_gpio_SetIntFallingEdge(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t Num);

    /**
   * @brief Setup CM3DS_MPS2 GPIO output value using Masked access.
   */

 extern void CM3DS_MPS2_gpio_MaskedWrite(CM3DS_MPS2_GPIO_TypeDef *CM3DS_MPS2_GPIO, uint32_t value, uint32_t mask);

    /**
   * @brief Setup CM3DS_MPS2 I2S Configuration.
   */

 extern int CM3DS_MPS2_i2s_config(CM3DS_MPS2_I2S_TypeDef *pI2S, uint32_t tx_enable, uint32_t tx_int_enable, uint32_t tx_waterlevel,
                       uint32_t rx_enable, uint32_t rx_int_enable, uint32_t rx_waterlevel);

    /**
   * @brief Setup CM3DS_MPS2 I2S Configuration.
   */

 extern int CM3DS_MPS2_i2s_tx_fifo_empty(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Returns I2S TX buffer empty.
   */

 extern int CM3DS_MPS2_i2s_tx_fifo_full(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Returns I2S TX buffer full.
   */

 extern int CM3DS_MPS2_i2s_rx_fifo_empty(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Returns I2S RX buffer empty.
   */

 extern int CM3DS_MPS2_i2s_rx_fifo_full(CM3DS_MPS2_I2S_TypeDef * pI2S);
    /**
   * @brief Returns I2S RX buffer full.
   */

 extern int CM3DS_MPS2_i2s_rx_irq_alert(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Returns I2S RX buffer alert.
   */

 extern int CM3DS_MPS2_i2s_tx_irq_alert(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Returns I2S TX buffer alert.
   */

 extern int CM3DS_MPS2_i2s_tx_stop(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Disable I2S TX.
   */

 extern int CM3DS_MPS2_i2s_rx_stop(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Disable I2S RX.
   */

 extern int CM3DS_MPS2_i2s_get_tx_error(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Returns I2S TX error status.
   */

 extern int CM3DS_MPS2_i2s_get_rx_error(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Returns I2S RX error status.
   */

 extern void i2s_clear_tx_error(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Clear I2S TX error status.
   */

 extern void i2s_clear_rx_error(CM3DS_MPS2_I2S_TypeDef * pI2S);

    /**
   * @brief Clear I2S RX error status.
   */

 extern void i2s_fifo_reset(CM3DS_MPS2_I2S_TypeDef *pI2S);

    /**
   * @brief I2S buffer reset.
   */

 extern void i2s_codec_reset(CM3DS_MPS2_I2S_TypeDef *pI2S);

    /**
   * @brief I2S codec reset.
   */

 extern int CM3DS_MPS2_i2s_speed_config(CM3DS_MPS2_I2S_TypeDef *pI2S, uint32_t divide_ratio);

    /**
   * @brief Setups I2S divide ratio for left/right clock.
   */

 void CM3DS_MPS2_i2c_send_byte(unsigned char c);

    /**
   * @brief Write 8 bits of data to the serial bus.
   */

 unsigned char CM3DS_MPS2_i2c_receive_byte(void);

    /**
   * @brief Read 8 bits of data from the serial bus.
   */

 int CM3DS_MPS2_i2c_receive_ack(void);

    /**
   * @brief Read the acknowledge bit from the serial bus.
   */

 void CM3DS_MPS2_i2c_send_ack(void);

    /**
   * @brief  Write the acknowledge bit to the serial bus.
   */

 unsigned char CM3DS_MPS2_i2c_read(unsigned char reg_addr, unsigned char sadr);

    /**
   * @brief Write data stream and read one byte from the serial bus.
   */


 void CM3DS_MPS2_i2c_write(unsigned char reg_addr, unsigned char data_byte, unsigned char sadr);

    /**
   * @brief Write data stream and write one byte from the serial bus.
   */

  /*@}*/ /* end of group CMSIS_CM3DS_MPS2_Driver_definitions CM3DS_MPS2 Driver definitions */

