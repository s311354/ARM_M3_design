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
 * File:     aplani.c
 * Release:  Version 1.0
 * ----------------------------------------------------------------
 */

/*
 * Code implementation file for the LAN Ethernet interface.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ETH_MPS2.h"

#include "aplan.h"

// test packet header
static unsigned char testpkt[] =
{
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xDE, 0xAD
};

#define TX_PKT_SIZE 256
#define RX_PKT_SIZE 300

static unsigned char txpkt[TX_PKT_SIZE];

static unsigned char rxpkt[RX_PKT_SIZE];

// Selftest functions

int smsc9220_check_id(void)
{
    int error;
    unsigned int id;
    error = 0;

    id = smsc9220_read_id();

    // If bottom and top halves of the word are the same
    if(((id >> 16) & 0xFFFF) == (id & 0xFFFF)) {
        printf_err("Error: The SMSC9220 bus is in 16-bit mode. 32-bit mode was expected.\n");
        error = 1;
        return error;
    }
    switch(((id >> 16) & 0xFFFF)) {
        case 0x9220:
            printf("SMSC9220 is identified successfully.\n");
            break;

        default:
            printf("SMSC9220 id reads: %#08x, either an unknown chip (SMSC%x?), or error.\n",
                    ((id >> 16) & 0xFFFF), ((id >> 16) & 0xFFFF));
            error = 1;
            break;
    }

    return error;
}

int smsc9220_check_macaddress(void)
{
    int error;
    const unsigned int mac_valid_high = 0xC00A;
    const unsigned int mac_valid_low = 0x00F70200;
    unsigned int mac_low;
    unsigned int mac_high;

    error = 0;

    // Read current mac address.
    smsc9220_mac_regread(SMSC9220_MAC_ADDRH, &mac_high);
    smsc9220_mac_regread(SMSC9220_MAC_ADDRL, &mac_low);

    // Print mac address in 2-nibble (8-bit) parts.
    printf("MAC address read: %02X:%02X:%02X:%02X:%02X:%02X:\n",
            mac_low & 0xFF, (mac_low >> 8) & 0xFF,
            (mac_low >> 16) & 0xFF, (mac_low >> 24) & 0xFF,
            mac_high & 0xFF, (mac_high >> 8) & 0xFF);

    // If it's invalid, assign a temporary valid address:
    if(mac_high == 0xFFFF || mac_low == 0xFFFFFFFF ||
        mac_high == 0x00000000 || mac_low == 0x00000000 ||
        (mac_low & (1 << 15))) {
        printf("MAC Address is invalid. Assigning temporary address.\n");
    } else {
        printf("Assigning temporary MAC address.\n");
    }

    // Writing temporary address:
    smsc9220_mac_regwrite(SMSC9220_MAC_ADDRH, mac_valid_high);
    smsc9220_mac_regwrite(SMSC9220_MAC_ADDRL, mac_valid_low);

    // Verify write was correct:
    smsc9220_mac_regread(SMSC9220_MAC_ADDRH, &mac_high);
    smsc9220_mac_regread(SMSC9220_MAC_ADDRL, &mac_low);

    printf("MAC address after modification: %02X:%02X:%02X:%02X:%02X:%02X\n",
            mac_low & 0xFF, (mac_low >> 8) & 0xFF,
            (mac_low >> 16) & 0xFF, (mac_low >> 24) & 0xFF,
            mac_high & 0xFF, (mac_high >> 8) & 0xFF);

    if(mac_high != mac_valid_high || mac_low != mac_valid_low) {
        printf("Writing temporary mac address failed.\n");
        printf("MAC Address written was: mac_high: %#08x, mac_low: %#08x\n",
               mac_valid_high, mac_valid_low);
        error = TRUE;
        return error;
    }

    printf("\n");
    return error;
}

void smsc9220_print_mac_registers()
{
    unsigned int read;
    int i;

    i = 0;
    read = 0;

    for(i = 1; i <= 0xC; i++) {
        smsc9220_mac_regread(i, &read);
        apDebug("MAC Register %d: %#08x\n",i,read);
    }

    apDebug("\n");
    return;
}
static void smsc9220_print_phy_registers()
{
    unsigned short read;
    unsigned int i;

    i = 0;
    read = 0;
    for(i = 0; i <= 6; i++) {
        smsc9220_phy_regread(i, &read);
        apDebug("PHY Register %d: %#08x\n",i,read);
    }
    smsc9220_phy_regread(i = 17, &read);
    apDebug("Phy Register %d: %#08x\n", i, read);

    smsc9220_phy_regread(i = 18, &read);
    apDebug("Phy Register %d: %#08x\n", i, read);

    smsc9220_phy_regread(i = 27, &read);
    apDebug("Phy Register %d: %#08x\n", i, read);

    smsc9220_phy_regread(i = 29, &read);
    apDebug("Phy Register %d: %#08x\n", i, read);

    smsc9220_phy_regread(i = 30, &read);
    apDebug("Phy Register %d: %#08x\n", i, read);

    smsc9220_phy_regread(i = 31, &read);
    apDebug("Phy Register %d: %#08x\n", i, read);

    apDebug("\n");
    return;
}

int smsc9220_initialise(void)
{
    unsigned int id;
    int error = 0;

    // Set base address for ethernet controller
    id = SCB->CPUID;
    
    if(EXTRACT_BITS(id, 7, 4) == 7)
        SMSC9220 = (SMSC9220_TypeDef *)SMSC9220_BASE_CORTEX_M7;
    else
        SMSC9220 = (SMSC9220_TypeDef *)SMSC9220_BASE;
        
    if(smsc9220_check_id()) {
    	printf("Reading the Ethernet ID register failed.\n"
               "Check that the SMSC9220 device is present on the system.\n");
        error = TRUE;
        return error;
    }

    if(smsc9220_soft_reset()) {
        printf_err("Error: SMSC9220 soft reset failed to complete.\n");
        error = TRUE;
    }

    smsc9220_print_mac_registers();
    smsc9220_print_phy_registers();

    smsc9220_set_txfifo(5);

    // Sets automatic flow control thresholds, and backpressure
    // threshold to defaults specified.
    SMSC9220->AFC_CFG = 0x006E3740;

    if(smsc9220_wait_eeprom()) {
        printf_err("Error: EEPROM failed to finish initialisation.\n");
        error = TRUE;
    }

    // Configure GPIOs as LED outputs.
    SMSC9220->GPIO_CFG = 0x70070000;

    smsc9220_init_irqs();

    /* Configure MAC addresses here if needed. */

    if(smsc9220_check_phy()) {
        printf_err("Error: SMSC9220 PHY not present.\n");
        error = TRUE;
    }

    if(smsc9220_reset_phy()) {
        printf_err("Error: SMSC9220 PHY reset failed.\n");
        error = TRUE;
        return error;
    }

    apSleep(100);
    // Checking whether phy reset completed successfully.
    {
        unsigned short phyreset;
        phyreset = 0;
        smsc9220_phy_regread(SMSC9220_PHY_BCONTROL, &phyreset);
        if(phyreset & (1 << 15)) {
            printf_err("Error: SMSC9220 PHY reset stage failed to complete.\n");
            error = TRUE;
            return error;
        }
    }

    /* Advertise capabilities */
    smsc9220_advertise_cap();


    /* Begin to establish link */
    smsc9220_establish_link();      // bit [12] of BCONTROL seems self-clearing.
                                    // Although it's not so in the manual.

    /* Interrupt threshold */
    SMSC9220->FIFO_INT = 0xFF000000;

    /* ENABLE TX Data available interrupt */    // Change this, we need polled mode!!!
    // Disabled for now
    // SMSC9220->INT_EN |= (1 << 9);

    smsc9220_enable_mac_xmit();

    smsc9220_enable_xmit();

    SMSC9220->RX_CFG = 0;

    smsc9220_enable_mac_recv();

    // Rx status FIFO level irq threshold
    SMSC9220->FIFO_INT &= ~(0xFF);  // Clear 2 bottom nibbles

    // Do we need this?
    // SMSC9220->INT_EN |= (1 << 3);    // Enable RX FIFO irq.

    smsc9220_print_mac_registers();
    smsc9220_print_phy_registers();

    // This sleep is compulsory otherwise txmit/receive will fail.
    apSleep(2000);
    return error;
}


// Basic equivalent of memcmp. Compares two buffers up to size of len.
static unsigned int compare_buf(unsigned char *buf1, unsigned char *buf2, int len)
{
    int i;
    unsigned char *tmpbuf1, *tmpbuf2;

    tmpbuf1 = buf1;
    tmpbuf2 = buf2;

    if(len < 0 || len > 0x1000) {
        apDebug("Buffer length invalid or larger than 4KB.\n");
        return 1;
    }

    if(!buf1 || !buf2) {
        apDebug("Invalid buffer pointers for comparison.\n");
        return 1;
    }

    for(i = 0; i < len; i++) {
        if(*tmpbuf1 != *tmpbuf2) {
            return 1;
        }
        tmpbuf1++;
        tmpbuf2++;
    }
    return 0;
}

static unsigned int smsc9220_test_loopback(void)
{
    unsigned int index;
    unsigned int txfifo_inf;
    unsigned int pktsize;
    
    index = 0;
    pktsize = TX_PKT_SIZE;
    
    txfifo_inf = SMSC9220->TX_FIFO_INF;
    apDebug("TX_FIFO_INF: %#08x\n", txfifo_inf);

    if((txfifo_inf & 0xFFFF) >= pktsize) {
        // Send single packet.
        smsc9220_xmit_packet(txpkt, pktsize);
    } else {
        printf("Insufficient tx fifo space for packet size %d\n",pktsize);
        return 1;
    }

    apSleep(5);

    // Receive all that's available in Rx DATA Fifo.
    if(smsc9220_recv_packet((unsigned int *)rxpkt, &index)) {
        printf("Packet receive failed.\n");
        return 1;
    }

    if(compare_buf(rxpkt, txpkt, TX_PKT_SIZE)) {
        printf("Sent and received packets do not match.\n");
        return 1;
    }

    return 0;
}

apError apLANI_TEST()
{
    int failtest;
    int tries, i;
    failtest = FALSE;

    // Make sure loop back cable is in
    printf("Please connect an Ethernet loopback cable into J6 top.\n");
    printf("The test will transmit and receive Ethernet packets.\n");
    Wait_For_Enter(FALSE);

    if(smsc9220_initialise()) {
        printf("SMSC9220 initialisation failed.\n\n");
        return apERR_LANI_START;
    }

    if(smsc9220_check_macaddress()) {
        printf("Invalid MAC Address. Selftest was unable to change MAC address.\n\n");
        return apERR_LANI_START;
    }

    if(smsc9220_check_ready()) {
        printf_err("Error: Ready bit not set.\n");
    } else {
        apDebug("Ready bit is set.\n");
    }

    NVIC_ClearPendingIRQ(ETHERNET_IRQn);

    printf("Data loop back test...\n");

    for(tries = 0; tries < 1000; tries++) {
        for(i=0; i < 16; i++)
        {
            txpkt[i] = testpkt[i];
        }
        for( ; i < TX_PKT_SIZE; i++)
        {
            txpkt[i++] = tries & 0xff;
            txpkt[i] = ((i-16)>>1) & 0xff;
        }
        if(smsc9220_test_loopback()) {
            printf_err("Error: Loopback test failed on transfer %d\n",tries+1);
            failtest = TRUE;
            break;
        } else {
            apDebug("Transfer %d successful.\n",tries+1);
        }
        memset(rxpkt, 0, RX_PKT_SIZE);
    }

    smsc9220_set_soft_int();	   // Generate a soft irq.

    if (ap_check_peripheral_interrupt("Ethernet", ETHERNET_IRQn, 1))
        failtest = TRUE;

    smsc9220_clear_soft_int();     // Clear soft irq.

    NVIC_ClearPendingIRQ(ETHERNET_IRQn);

    if (failtest)
        return apERR_LANI_START;
    else
        return apERR_NONE;
}
