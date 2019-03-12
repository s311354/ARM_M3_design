/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2013 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     apSSP.c
 * Release:  Version 2.0
 * ----------------------------------------------------------------
 */
  
/*
 * Code implementation file for the SSP (Serial Peripheral Interface).
 */

#include <stdio.h>
#include <stdlib.h>

#include "SMM_MPS2.h"

#include "apssp.h"

#define SSP_CS(x)   ((x) ? (MPS2_FPGAIO->MISC |= SPI_nSS_Msk)    : (MPS2_FPGAIO->MISC &= ~SPI_nSS_Msk))

// Wait for SSP Read/Write FIFO to clear
// returns FALSE if SSP time out
int apSSP_Wait()
{
    int waittimer;
    
    waittimer = SSPMAXTIME;
    
    while ((MPS2_SSP1->SR & SSP_SR_BSY_Msk) && waittimer) {
        apSleepus(100);
        waittimer--;
    }
    
    if (waittimer)
        return FALSE; // TRUE;
    else
        return TRUE;    // FALSE;
}

/* Generic EEPROM read or write function
 *
 * Inputs:
 *     instruction - EEPROM instruction type
 *     eeaddr      - EEPROM address (16bits)
 *     eedout      - EEPROM write data
 *
 * Outputs:
 *     eedin       - Pointer to return EEPROM read data
 *
 * Returns TRUE if successful or FALSE if SSP times out
 */
int apSSP_ByteRDRW(unsigned int instruction,
                   unsigned int eeaddr, 
                   unsigned char eedout,
                   unsigned char *eedin)
{
    int timeerr;

    timeerr = FALSE;

    // Make sure write buffer is free
    while (MPS2_SSP1->SR & SSP_SR_BSY_Msk)
    	continue;
    
    // Enable chip select (nCS = 0)
    SSP_CS(0);
    apSleepus(1);

    // Write EEPROM instruction and empty read FIFO
    MPS2_SSP1->DR = instruction;
    if (apSSP_Wait())
        timeerr = TRUE;
    *eedin = MPS2_SSP1->DR;

    // Write address if byte read/write
    if ((instruction == EEREAD) || (instruction == EEWRITE)) {
        MPS2_SSP1->DR = (eeaddr >> 8) & 0xFF;
        if (apSSP_Wait())
            timeerr = TRUE;
        *eedin = MPS2_SSP1->DR;
        MPS2_SSP1->DR = eeaddr & 0xFF;
        if (apSSP_Wait())
            timeerr = TRUE;
        *eedin  = MPS2_SSP1->DR;
    }

    // Read/Write data
    if ((instruction != EEWREN) && (instruction != EEWDI)) {
        MPS2_SSP1->DR = eedout;        // Write byte to EEPROM
        if (apSSP_Wait())
            timeerr = TRUE;
        *eedin = MPS2_SSP1->DR;        // Read last byte from FIFO
    }

    apSleepus(1);

    // Disable chip select (nCS = 1)
    SSP_CS(1);

    if (timeerr)
        return TRUE;
    else
        return FALSE;
}

/* SSP Init
 * The 25LC080 EEPROM is a Motorola SSP format device, 2MHz max operation.
 * Data is latched in on the rising edge of SCLK and output after the falling edge of SCLK.
 * FsspCLK=25MHz, SCLK=0.78MHz. SPO=0 and SPH=0.
 *
 * Data frames are 4 * 8bit back-to-back to give 32bits, SSPCS controls the device /CS.
 * So Byte1=Instruction, Byte2/3=Address High/Low byte, Byte4=Data. 
 */
void apSSP_Init(unsigned int master)
{
    //Disable serial port operation
    MPS2_SSP1->CR1 = 0;

    // Disable FIFO DMA
    MPS2_SSP1->DMACR = 0;
    
    // Set serial clock rate, Format, data size
    MPS2_SSP1->CR0 = SSP_CR0_SCR_DFLT | SSP_CR0_FRF_MOT | SSP_CR0_DSS_8;
    
    // Clock prescale register set to /8, with SCR gives 0.78MHz SCLK
    MPS2_SSP1->CPSR = SSP_CPSR_DFLT;

    // Mask all FIFO/IRQ interrupts apart from the Tx FIFO empty interrupt
    MPS2_SSP1->IMSC = 0x8;
    
    if(master)
    {
        // Enable serial port operation
        MPS2_SSP1->CR1 = SSP_CR1_SSE_Msk;
    }
    else
    {
        // Enable slave mode
        MPS2_SSP1->CR1 |= SSP_CR1_MS_Msk;
        // Enable serial port operation
        MPS2_SSP1->CR1 |= SSP_CR1_SSE_Msk;        
    }
    
    // Clear existing IRQ's
    MPS2_SSP1->ICR = 0x3;
    
}

/* Routine to test SSP interface with external eeprom connected */
apError apSSP_TEST(void)
{
    unsigned int    eeaddr, wrcount;
    unsigned char   eedin, eedout, temp;
    unsigned int    failtest;
//    const int asserted = 1, deasserted = 0;
    failtest = FALSE;
    
    // Make sure EEPROM test harness is in
    printf("Please plug SPI test harness into J21\n");
    printf("The test will read and write data to the EEPROM\n");
    Wait_For_Enter(FALSE);

    apSSP_Init(1);
     
    // Write 256 bytes of data to the EEPROM and check the data was stored correctly.
    for (eeaddr = 0; eeaddr < 256; eeaddr++) {

        // Send out data that does not match the address
        eedout = 255 - (eeaddr & 0xFF);
        
        // Write Enable Sequence
        if (apSSP_ByteRDRW(EEWREN, 0, 0, &temp))
            failtest = TRUE;

        // Write 8bits of data
        if (apSSP_ByteRDRW(EEWRITE, eeaddr, eedout, &temp))
            failtest = TRUE;

        // Wait for write to complete, this should take < 10ms (1000 reads at 0.78MHz SCLK)
        wrcount = 0;
        do {
            if (apSSP_ByteRDRW(EERDSR, eeaddr, eedout, &temp) || (wrcount > 1000)) {
                printf_err("Error: Timout failure on nCS0\n");
                failtest = TRUE;
            }
            wrcount++;
        } while((temp & EERDSR_WIP) && !failtest);

        // Write Disable Sequence
        if (apSSP_ByteRDRW(EEWDI, 0, 0, &temp)) {
            printf_err("Error: Timout failure on nCS0\n");
            failtest = TRUE;
        }

        // Read 8bits of data
        if (apSSP_ByteRDRW(EEREAD, eeaddr, eedout, &eedin)) {
            printf_err("Error: Timout failure on nCS0\n");
            failtest = TRUE;
        }

        // Compare results
        if (eedin != eedout) {
            printf_err("Error: Data error on nCS0 sent:%02X, received:%02X\n", eedout ,eedin);
            eeaddr   = 256;
            failtest = TRUE;
        }
    }

    if(failtest == FALSE)
        printf("Data read/write successful.\n");

    if (failtest)
        return apERR_SSP_START;
    else
        return apERR_NONE;
}
/* Routine to test SSP interface in master mode */
apError apSSP_TEST_M(void)
{
    unsigned int    wrcount, eedin;
    char test_msg[] = "Master Slave Test\n";
    int timeerr;
    
    printf("Master mode test\n");

    apSSP_Init(1);
     
    // Make sure write buffer is free
    while (MPS2_SSP1->SR & SSP_SR_BSY_Msk)
    	continue;
    
    for (wrcount = 0; wrcount < sizeof(test_msg); wrcount++)
    {
        // Enable chip select (nCS = 0)
        SSP_CS(0);
        apSleepus(1);

        MPS2_SSP1->DR = test_msg[wrcount];        // Write message
        if (apSSP_Wait())
            timeerr = TRUE;
        eedin = MPS2_SSP1->DR;

        // Disable chip select (nCS = 1)
        SSP_CS(1);
        apSleepus(1);
    }

    return apERR_NONE;
}

/* Routine to test SSP interface in slave mode */
apError apSSP_TEST_S(void)
{
    unsigned char   eedin, temp;

    printf("Slave Mode Test\n");

    apSSP_Init(0);
    
    MPS2_SSP1->DR = 0x55;
    
    printf("\nReceived :- ");    
    while(1)
    {
        if(MPS2_SSP1->SR & SSP_SR_RNE_Msk)
        {
            eedin = MPS2_SSP1->DR;
            if((eedin >= 0x20) && (eedin <= 0x7E))
            {
                printf("%c", eedin);
            }
            else
            {
                printf(" 0x%x ", eedin);
            }
            
            if( (char)eedin == '\n')
                break;
        }
        
        if ((CMSDK_UART1->STATE & 2)) // If Receive Holding register not empty
        {
            temp = CMSDK_UART1->DATA;
            if((temp == 'x') || (temp == 'X'))
                break;
        }
    }
    
    printf("\n");
    
    return apERR_NONE;
}
