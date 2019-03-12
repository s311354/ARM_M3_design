//  ----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 2001 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  and copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information :
//
//
//  Filename            : RtcParams.v.rca
//
//  File Revision       : 1.4
//
//  Release Information : PrimeCell(TM)-PL031-REL1v0
//
//------------------------------------------------------------------------------
// Purpose    : Parameter definitions
//
//------------------------------------------------------------------------------



// --=================================================================--
// Constant declarations
// --=================================================================--

// ---------------------------------------------------------------------
// Integration Test
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Peripheral Id
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Assign the Peripheral ID
//
// The Peripheral ID is a 32-bit value composed of the
// following 4 fields:
// Bits [11:0] -> Part Number used to identify the peripheral
//                For the NEW peripheral this is 0x031
// Bits[19:12] -> Designer ID (ARM)
//                ARM is designated 0x41
// Bits[23:20] -> Peripheral Revision Number
//
// Bits[31:24] -> Peripheral Configuration Options
//                For the peripheral is 0x00
//
// The 32-bits are readable via 4 separate address locations with
// each location returning 8 valid bits at positions [7:0]. The
// values returned by the 4 Peripheral ID registers are given below:
//
// PeriphID0 = 0x31
// PeriphID1 = 0x10
// PeriphID2 = 0x04
// PeriphID3 = 0x00
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Peripheral Identification register values
// ---------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Peripheral Identification register values
// -----------------------------------------------------------------------------
`define RTC_PERIPHID0      8'b00110001
// Peripheral identification register 0

`define RTC_PERIPHID1      8'b00010000
// Peripheral identification register 1

`define RTC_PERIPHID2      4'b0100
// LS 4 bits of Peripheral identification register 2 indicates the designer code

`define RTC_PERIPHID3      8'b00000000
// Peripheral identification register 3

// ---------------------------------------------------------------------
// Assign the PrimeCell ID
//
// PCellID0 = 0x0D
// PCellID1 = 0xF0
// PCellID2 = 0x05
// PCellID3 = 0xB1
// These PrimeCell ID values should not be changed.
// ---------------------------------------------------------------------

// -----------------------------------------------------------------------------
// PrimeCell Identification register values
// -----------------------------------------------------------------------------
`define PRIMECELLID0       8'b00001101
// PrimeCell identification register 0

`define PRIMECELLID1       8'b11110000
// PrimeCell identification register 1

`define PRIMECELLID2       8'b00000101
// PrimeCell identification register 2

`define PRIMECELLID3       8'b10110001
// PrimeCell identification register 3

// =============================================================================
// The Address definitions for the registers in the peripheral
// =============================================================================
// -----------------------------------------------------------------------------
// Functional mode registers
// -----------------------------------------------------------------------------
`define PADDR_RTCDR        10'b0000000000
 // RTCDR at offset 0x00

`define PADDR_RTCMR        10'b0000000001
// RTCMR at offset 0x04

`define PADDR_RTCLR        10'b0000000010
// RTCLR at offset 0x08

`define PADDR_RTCCR        10'b0000000011
// RTCCR at offset 0x0c

`define PADDR_RTCIMSC      10'b0000000100
// RTCIMSC at offset 0x10

`define PADDR_RTCRIS       10'b0000000101
// RTCRIS at offset 0x14

`define PADDR_RTCMIS       10'b0000000110
// RTCMIS at offset 0x18

`define PADDR_RTCICR       10'b0000000111
// RTCICR at offset 1c

// -----------------------------------------------------------------------------
// Integration Test registers
// -----------------------------------------------------------------------------

`define PADDR_RTCITCR       10'b0000100000
// ITCR at offset 0x80

//`define PADDR_RTCITIP       10'b0000100001
// ITIP at offset 0x84

`define PADDR_RTCITOP       10'b0000100010
// ITOP at offset 0x88

`define PADDR_RTCTOFFSET    10'b0000100011
// RTCTOFFSET at offset 0x8C

`define PADDR_RTCTCOUNT     10'b0000100100
// RTCTCOUNT at offset 0x90

// ---------------------------------------------------------------------
// Peripheral Id registers
// ---------------------------------------------------------------------
`define PADDR_PERIPHID0     10'b1111111000
// PeriphID0 at offset 0xFE0

`define PADDR_PERIPHID1     10'b1111111001
// PeriphID1 at offset 0xFE4

`define PADDR_PERIPHID2     10'b1111111010
// PeriphID2 at offset 0xFE8

`define PADDR_PERIPHID3     10'b1111111011
// PeriphID3 at offset 0xFEC

`define PADDR_PRIMECELLID0      10'b1111111100
// PCellID0 at offset 0xFF0

`define PADDR_PRIMECELLID1      10'b1111111101
// PCellID1 at offset 0xFF4

`define PADDR_PRIMECELLID2      10'b1111111110
// PCellID2 at offset 0xFF8

`define PADDR_PRIMECELLID3      10'b1111111111
// PCellID3 at offset 0xFFC


//==========================End of RtcPackage==============================


