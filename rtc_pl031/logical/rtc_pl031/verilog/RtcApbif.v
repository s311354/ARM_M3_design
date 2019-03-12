//  --========================================================================--
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
//  Filename            : RtcApbif.v.rca
//
//  File Revision       : 1.13
//
//  Release Information : PrimeCell(TM)-PL031-REL1v0
//
//  ----------------------------------------------------------------------------
//  Purpose             : This block is the APB interface for the Rtc
//
//  --========================================================================--

`timescale 1ns/1ps
`include "RtcParams.v"


module RtcApbif (
               // Inputs
                 PCLK,
                 PRESETn,
                 nPOR,
                 PSEL,
                 PENABLE,
                 PWRITE,
                 PWDATA,
                 PADDR,
                 RTCDR,
                 RTCRIS,
                 RTCMIS,
                 RawIntSync,
                 MaskInt,
                 CountSync,
                 Offset,
                 Revision,
               // Outputs
                 WrenRTCLR,
                 WrenRTCMR,
                 RTCMR,
                 RTCLR,
                 RTCICR,
                 RTCIMSC,
                 RTCEn,
                 RTCTOFFSET,
                 RTCTCOUNT,
                 IntRTCINTR,
                 TESTCOUNT,
                 TESTOFFSET,
                 PRDATA
                 );



input         PCLK;          // APB Clock
input         PRESETn;       // APB reset signal
input         nPOR;          // Power-on-Reset signal
input         PSEL;          // APB select
input         PENABLE;       // APB enable
input         PWRITE;        // APB data bus
input  [31:0] PWDATA;        // APB Data Bus
input  [11:2] PADDR;         // APB address bus
input  [31:0] RTCDR;         // RTC Data Register
input         RTCRIS;        // RTC Raw Interrupt Status register
input         RTCMIS;        // RTC Masked Interrupt Status register
input         RawIntSync;    // Synchronised raw interrupt
input         MaskInt;       // RTC interrupt
input  [31:0] CountSync;     // Synchronised count value
input  [31:0] Offset;        // Calculated offset value
input  [3:0]  Revision;      // Revision number

output        WrenRTCLR;     // Write enable for RTCLR
output        WrenRTCMR;     // Write enable for RTCMR
output [31:0] RTCMR;         // RTC Match Register
output [31:0] RTCLR;         // RTC Load Register
output        RTCICR;        // RTC Interrupt clear register
output        RTCIMSC;       // RTC Interrupt Mask/Set Clear register
output [31:0] RTCTOFFSET;    // Test Offset register
output [31:0] RTCTCOUNT;     // Test Count register
output        RTCEn;         // RTC enable
output        IntRTCINTR;    // Rtc Interrupt for integration testing
output        TESTCOUNT;     // Test count enable
output        TESTOFFSET;    // Test offset enable
output [31:0] PRDATA;        // APB Read Data


// -----------------------------------------------------------------------------
//
//                             RtcApbif
//                             ========
//
// -----------------------------------------------------------------------------
// Overview
// ========
// The APB interface generates the internal decodes and the corresponding read
// and write signals for the various registers.
//
// Reads and writes to the RTC functional mode and test mode registers qualified
// with their respective select signals will update the registers on a write and
// present the latest data on a read.
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                    Rtc Functional Mode Register Map
// -----------------------------------------------------------------------------
// Offset Read    (Width)     Write (Width)     Description
// -----------------------------------------------------------------------------
// 0x00   RTCDR   (32 bits)  -                  RTC Data Register
// 0x04   RTCMR   (32 bits)  RTCMR   (32 bits)  RTC Match Register
// 0x08   RTCLR   (32 bits)  RTCLR   (32 bits)  RTC Load Register
// 0x0C   RTCCR   (1 bits)   RTCCR   (1 bit)    RTC Control Register
// 0x10   RTCIMSC (1 bit)    RTCIMSC (1 bit)    RTC Interrupt Mask Set/Clear
//                                                  Register
// 0x14   RTCRIS  (1 bit)    -                  RTC Raw Interrupt Status
//                                                  Register
// 0x18   RTCMIS  (1 bit)    -                  RTC Masked Interrupt Status
//                                                  Register
// 0x1c   -                  RTCICR  (1 bit)    RTC Interrupt Clear Register
//
// -----------------------------------------------------------------------------
//                    Rtc Integration Test Mode Register Map
// -----------------------------------------------------------------------------
// Offset        Read (Width)   Write (Width)  Description
// -----------------------------------------------------------------------------
// 0x80   RTCITCR   (3 bits )   (2 bits )      RTC Test Control Register
// 0x84   RTCITIP   (0 bits )   (0 bit  )      RTC Integration Test Input reg
// 0x88   RTCITOP   (1 bit  )   (1 bit  )      RTC Integration Test Output reg
// 0x8C   RTCTOFFSET(32 bits)   (32 bits)      RTC Test Offset Register
// 0x90   RTCTCOUNT (32 bits)   (32 bits)      RTC Test Count Register
//
// -----------------------------------------------------------------------------
//                    Rtc Identification Registers
// -----------------------------------------------------------------------------
// Offset              Read (Width)  Write (Width)   Description
// -----------------------------------------------------------------------------
// 0xFE0  PeriphID0    (8 bits)        -    Peripheral identification register 0
// 0xFE4  PeriphID1    (8 bits)        -    Peripheral identification register 1
// 0xFE8  PeriphID2    (8 bits)        -    Peripheral identification register 2
// 0xFEC  PeriphID3    (8 bits)        -    Peripheral identification register 3
// 0xFF0  PRIMECELLID0 (8 bits)        -    PrimeCell identification register 0
// 0xFF4  PRIMECELLID1 (8 bits)        -    PrimeCell identification register 1
// 0xFF8  PRIMECELLID2 (8 bits)        -    PrimeCell identification register 2
// 0xFFC  PRIMECELLID3 (8 bits)        -    PrimeCell identification register 3
// =============================================================================

// -----------------------------------------------------------------------------
// Defines : The defines are for register address decoding.
// -----------------------------------------------------------------------------
// In RtcPackage.v

// Test register's address 'defines
// In RtcPackage.v

// Peripheral register's address 'defines
// In RtcPackage.v


// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [11:2] GatedPADDR;     // Save power by gating PADDR with PSEL
wire        Wren;           // internal write enable signal
wire        Rden;           // internal read enable signal

// Read signals for RTC functional mode registers
wire        RdenRTCDR;      // RTCDR register read enable
wire        RdenRTCMR;      // RTCMR register read enable
wire        RdenRTCLR;      // RTCLR register read enable
wire        RdenRTCCR;      // RTCCR register read enable
wire        RdenRTCIMSC;    // RTCIMSC register read enable
wire        RdenRTCRIS;     // RTCRIS register read enable
wire        RdenRTCMIS;     // RTCMIS register read enable

// Write signals for RTC functional mode registers
wire        WrenRTCMR;      // RTCMR register write enable
wire        WrenRTCLR;      // RTCLR register write enable
wire        WrenRTCCR;      // RTCCR register write enable
wire        WrenRTCIMSC;    // RTCIMSC register write enable
wire        WrenRTCICR;     // RTCICR register write enable

// Read signals for RTC integration test mode signals
wire        RdenRTCITCR;    // RTCITCR register read enable
wire        RdenRTCITOP;    // RTCITOP register read enable
wire        RdenRTCTOFFSET; // RTCTOFFSET register read enable
wire        RdenRTCTCOUNT;  // RTCTCOUNT register read enable

// Write signals for RTC integration test mode signals
wire        WrenRTCITCR;    // RTCITCR register write enable
wire        WrenRTCITOP;    // RTCITOP register write enable
wire        WrenRTCTOFFSET; // RTCTOFFSET register write enable
wire        WrenRTCTCOUNT;  // RTCTCOUNT register write enable

// Read signals for RTC identification registers
wire        PERIPHID0rd;    // PeripheralID0 read
wire        PERIPHID1rd;    // PeripheralID1 read
wire        PERIPHID2rd;    // PeripheralID2 read
wire        PERIPHID3rd;    // PeripheralID3 read
wire        PRIMECELLID0rd; // PrimeCellID0 read
wire        PRIMECELLID1rd; // PrimeCellID1 read
wire        PRIMECELLID2rd; // PrimeCellID2 read
wire        PRIMECELLID3rd; // PrimeCellID3 read

wire [3:0]  Revision;       // Revision number
wire [31:0] NextPRDATA;     // D-input of PRDATA
wire [31:0] PWDataIn;       // gated PWData
wire        IntraOP;        // Intra chip output
wire        ITEN;           // Integration test enable


// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

// Local copies of RTC registers
reg  [31:0] RTCMR;          // RTC Match register
reg  [31:0] RTCLR;          // RTC Load register
reg         RTCCR;          // RTC Control register
reg         RTCIMSC;        // RTC Interrupt Mask/Set Clear register
reg         RTCIntClr;      // RTC Interrupt Clear register

// D-inputs of RTC Functional mode registers
reg  [31:0] NextRTCMR;      // D-input of RTCMR
reg  [31:0] NextRTCLR;      // D-input of RTCLR
reg         NextRTCCR;      // D-input of RTCCR
reg         NextRTCIMSC;    // D-input of RTCIMSC
reg         NextRTCIntClr;  // D-input of RTCIntClr

// Local copies of RTC Integration test mode registers
reg [2 :0] RTCITCR;         // RTC Test Control Register
reg        RTCITOP;         // RTC Integration test output Register
reg [31:0] RTCTOFFSET;      // RTC Test OFFSET Register
reg [31:0] RTCTCOUNT;       // RTC Test COUNT Register

// D-inputs of RTC Registers
reg [2 :0] NextRTCITCR;     // D-input of RTCITCR
reg        NextRTCITOP;     // D-input of RTCITOP
reg [31:0] NextRTCTOFFSET;  // D-input of RTCTOFFSET
reg [31:0] NextRTCTCOUNT;   // D-input of RTCTCOUNT

reg  [31:0] PRDATA;         // APB read databus


// -----------------------------------------------------------------------------
//
// Main Verilog code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// RTC Functional Mode Register Implementations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Implementation of RTC Match register - Combinational
// -----------------------------------------------------------------------------
always@(PWDataIn or WrenRTCMR or RTCMR)
  begin : p_CombMR
    if(WrenRTCMR == 1'b1)
      NextRTCMR = PWDataIn;
    else
      NextRTCMR = RTCMR;
  end // p_CombMR

// -----------------------------------------------------------------------------
// Implementation of RTC Match register - Sequential
// -----------------------------------------------------------------------------
always@(posedge PCLK or negedge nPOR)
  begin : p_SeqMR
    if(nPOR == 1'b0)
      RTCMR <= 32'h00000000;
    else
      RTCMR <= NextRTCMR;
  end // p_SeqMR

//------------------------------------------------------------------------------
// Implementation of RTC Load register - Combinational
//------------------------------------------------------------------------------
always@(PWDataIn or WrenRTCLR or RTCLR)
  begin : p_CombLR
    if(WrenRTCLR == 1'b1)
      NextRTCLR = PWDataIn;
    else
      NextRTCLR = RTCLR;
  end  // p_CombLR

//------------------------------------------------------------------------------
// Implementation of RTC Load register - Sequential
//------------------------------------------------------------------------------
always@(posedge PCLK or negedge PRESETn)
  begin : p_SeqLR
    if(PRESETn == 1'b0)
      RTCLR <=32'h00000000;
    else
      RTCLR <= NextRTCLR;
  end  // p_SeqLR

//------------------------------------------------------------------------------
// Implementation of RTC Control register - Combinational
//------------------------------------------------------------------------------
always@(PWDataIn or WrenRTCCR or RTCCR)
  begin : p_CombCR
    if(WrenRTCCR == 1'b1)
      NextRTCCR = PWDataIn[0];
    else
      NextRTCCR = RTCCR;
  end  // p_CombCR

//------------------------------------------------------------------------------
// Implementation of RTC Control register - Sequential
//------------------------------------------------------------------------------
always@(posedge PCLK or negedge nPOR)
  begin : p_SeqCR
    if(nPOR == 1'b0)
      RTCCR <= 1'b0;
    else
      RTCCR <= NextRTCCR;
  end  // p_SeqCR

assign RTCEn = RTCCR;

//------------------------------------------------------------------------------
// Implementation of RTC Interrupt Mask Set/Clear register - Combinational
//------------------------------------------------------------------------------
always@(PWDataIn or WrenRTCIMSC or RTCIMSC)
  begin : p_CombIMSC
    if(WrenRTCIMSC == 1'b1)
      NextRTCIMSC = PWDataIn[0];
    else
      NextRTCIMSC = RTCIMSC;
  end  // p_CombIMSC

//------------------------------------------------------------------------------
// Implementation of RTC Interrupt Mask Set/Clear register - Sequential
//------------------------------------------------------------------------------
always@(posedge PCLK or negedge nPOR)
  begin : p_SeqIMSC
    if(nPOR == 1'b0)
      RTCIMSC <= 1'b0;
    else
      RTCIMSC <= NextRTCIMSC;
  end  // p_SeqIMSC

// -----------------------------------------------------------------------------
// Implementation of RTC Interrupt Clear Register. - Combinational
// -----------------------------------------------------------------------------
// The interrupt clear signal is gated with the synchronised raw interrupt so it
// is only enabled when there is an interrupt.
//------------------------------------------------------------------------------
always@(RTCIntClr or WrenRTCICR or PWDataIn or RawIntSync)
  begin : p_CombICR
    NextRTCIntClr = RTCIntClr;
    if(WrenRTCICR == 1'b1)
      NextRTCIntClr = PWDataIn[0];
    else if(RawIntSync == 1'b0)
      NextRTCIntClr = 1'b0;
  end  // p_CombICR

// -----------------------------------------------------------------------------
// Implementation of RTC Interrupt Clear Register. - Sequential
// -----------------------------------------------------------------------------
always@(posedge PCLK or negedge PRESETn)
  begin : p_SeqICR
    if(PRESETn == 1'b0)
      RTCIntClr <= 1'b0;
    else
      RTCIntClr <= NextRTCIntClr;
  end  // p_SeqICR

assign RTCICR = RTCIntClr;


// -----------------------------------------------------------------------------
// RTC Integration Test Mode Register Implementations - Combinational
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Implementation of RTC Integration Test Control Register
//
// This register controls the operation of the RTC under integration test
// conditions. The integration test mode is enable here.
// -----------------------------------------------------------------------------
always@(WrenRTCITCR or PWDataIn or RTCITCR)
  begin : p_CombITCR
    if(WrenRTCITCR == 1'b1)
      NextRTCITCR = PWDataIn[2:0];
    else
      NextRTCITCR = RTCITCR;
  end // p_CombITCR

// -----------------------------------------------------------------------------
// RTC Integration Test Mode Register Implementations - Sequential
// -----------------------------------------------------------------------------
always@(posedge PCLK or negedge PRESETn)
  begin : p_SeqITCR
    if(PRESETn == 1'b0)
      RTCITCR     <= 3'b000;
    else
      RTCITCR     <= NextRTCITCR;
  end // p_SeqITCR

// -----------------------------------------------------------------------------
// Implementation of RTC Integration Test Output Register - Combinational
// -----------------------------------------------------------------------------
// In integration test mode, intra-chip outputs can be written to and read from
// this register. Primary outputs are read only.
// -----------------------------------------------------------------------------
always@(WrenRTCITOP or PWDataIn or RTCITOP)
  begin : p_CombITOP
    if(WrenRTCITOP == 1'b1)
      NextRTCITOP = PWDataIn[0];
    else
      NextRTCITOP = RTCITOP;
  end // p_CombITOP

// -----------------------------------------------------------------------------
// Implementation of RTC Integration Test Output Register - Sequential
// -----------------------------------------------------------------------------
always@(posedge PCLK or negedge PRESETn)
  begin : p_SeqITOP
    if(PRESETn == 1'b0)
      RTCITOP     <= 1'b0;
    else
      RTCITOP     <= NextRTCITOP;
  end // p_SeqITOP

// -----------------------------------------------------------------------------
// Implementation of RTC Test Offset Register - Combinational
// -----------------------------------------------------------------------------
// Data can be written to or read from the offset register for test purposes.
// -----------------------------------------------------------------------------
always@(RdenRTCTOFFSET or TESTOFFSET or Offset or WrenRTCTOFFSET or PWDataIn or
         RTCTOFFSET)
  begin : p_CombTOFFSET
    if(RdenRTCTOFFSET == 1'b1 && TESTOFFSET == 1'b1)
      NextRTCTOFFSET = Offset;
    else if(WrenRTCTOFFSET == 1'b1)
           NextRTCTOFFSET = PWDataIn;
         else
           NextRTCTOFFSET = RTCTOFFSET;
  end // p_CombTOFFSET

// -----------------------------------------------------------------------------
// Implementation of RTC Test Offset Register - Sequential
// -----------------------------------------------------------------------------
always@(posedge PCLK or negedge PRESETn)
  begin : p_SeqTOFFSET
    if(PRESETn == 1'b0)
      RTCTOFFSET     <= 32'h00000000;
    else
      RTCTOFFSET     <= NextRTCTOFFSET;
  end // p_SeqTOFFSET

// -----------------------------------------------------------------------------
// Implementation of RTC Test Count Register - Combinational
// -----------------------------------------------------------------------------
// Data can be written to or read from the count register for test purposes.
// -----------------------------------------------------------------------------
always@(RdenRTCTCOUNT or TESTCOUNT or CountSync or WrenRTCTCOUNT or PWDataIn
         or RTCTCOUNT)
  begin : p_CombTCOUNT
    if(RdenRTCTCOUNT == 1'b1 && TESTCOUNT == 1'b1)
      NextRTCTCOUNT  = CountSync;
    else if(WrenRTCTCOUNT == 1'b1)
           NextRTCTCOUNT = PWDataIn;
         else
           NextRTCTCOUNT = RTCTCOUNT;
  end // p_CombTCOUNT

// -----------------------------------------------------------------------------
// Implementation of RTC Test Count Register - Sequential
// -----------------------------------------------------------------------------
always@(posedge PCLK or negedge PRESETn)
  begin : p_SeqTCOUNT
    if(PRESETn == 1'b0)
      RTCTCOUNT     <= 32'h00000000;
    else
      RTCTCOUNT     <= NextRTCTCOUNT;
  end // p_SeqTCOUNT

// -----------------------------------------------------------------------------
// Test count enable. When set to 1, a write to the RTCTCOUNT  writes data
// directly to the Counter register, and reads from the RTCTCOUNT reads data
// out of the Counter register.
// When this bit is 0, data cannot be written/read to/from the counter register
// (normal operation). The reset value is 0.
// -----------------------------------------------------------------------------
assign TESTCOUNT  = RTCITCR[1];
assign TESTOFFSET = RTCITCR[2];

// -----------------------------------------------------------------------------
// Intra chip outputs.
// When ITEN (Integration test enable bit) is set to 1, data written to the
// RTCITOP register becomes the value of the RTC interrupt.
// When this bit is 0, data written to the RTCITOP register does not become the
// value of the RTC interrupt (normal operation).
// -----------------------------------------------------------------------------

assign ITEN = RTCITCR[0];

assign IntRTCINTR = (ITEN == 1'b1) ? RTCITOP : MaskInt;

// Intra chip Output.
assign IntraOP  =  IntRTCINTR;

// -----------------------------------------------------------------------------
// Write Interface
// -----------------------------------------------------------------------------
// The write databus is gated with PSEL and PWRITE to reduce power consumption.
// This prevents toggling of the internal write databus when there is no
// write or when the device is not selected.
// The address bus is gated with PSEL to prevent internal toggling when the
// device is not selected.
// -----------------------------------------------------------------------------
assign PWDataIn    =  ((PSEL & PWRITE) == 1'b1) ? PWDATA : 32'h00000000;
assign GatedPADDR  =  (PSEL == 1'b1) ? { PADDR[11:2] }   : 10'b0000000000;

//Write enable. This signal indicates if there is a write to one of the RTC
//              registers.
assign Wren = PENABLE & PSEL & PWRITE;

// Functional mode register write signals.
assign WrenRTCMR      = Wren & (GatedPADDR == `PADDR_RTCMR);
assign WrenRTCLR      = Wren & (GatedPADDR == `PADDR_RTCLR);
assign WrenRTCCR      = Wren & (GatedPADDR == `PADDR_RTCCR);
assign WrenRTCIMSC    = Wren & (GatedPADDR == `PADDR_RTCIMSC);
assign WrenRTCICR     = Wren & (GatedPADDR == `PADDR_RTCICR);
// Integration Test mode register write signals.
assign WrenRTCITCR    = Wren & (GatedPADDR == `PADDR_RTCITCR);
assign WrenRTCITOP    = Wren & (GatedPADDR == `PADDR_RTCITOP);
assign WrenRTCTOFFSET = Wren & (GatedPADDR == `PADDR_RTCTOFFSET);
assign WrenRTCTCOUNT  = Wren & (GatedPADDR == `PADDR_RTCTCOUNT);

//------------------------------------------------------------------------------
// Read Interface
//------------------------------------------------------------------------------

//Read enable. This signal indicates if there is a read from one of the RTC
//             registers
assign Rden           = PSEL  & (~PWRITE) & (~PENABLE);

// Functional mode register read signals.
assign RdenRTCDR      =  Rden & (GatedPADDR == `PADDR_RTCDR);
assign RdenRTCMR      =  Rden & (GatedPADDR == `PADDR_RTCMR);
assign RdenRTCLR      =  Rden & (GatedPADDR == `PADDR_RTCLR);
assign RdenRTCCR      =  Rden & (GatedPADDR == `PADDR_RTCCR);
assign RdenRTCIMSC    =  Rden & (GatedPADDR == `PADDR_RTCIMSC);
assign RdenRTCRIS     =  Rden & (GatedPADDR == `PADDR_RTCRIS);
assign RdenRTCMIS     =  Rden & (GatedPADDR == `PADDR_RTCMIS);
// Integration Test mode register read signals.
assign RdenRTCITCR    =  Rden & (GatedPADDR == `PADDR_RTCITCR);
assign RdenRTCITOP    =  Rden & (GatedPADDR == `PADDR_RTCITOP);
assign RdenRTCTOFFSET =  Rden & (GatedPADDR == `PADDR_RTCTOFFSET);
assign RdenRTCTCOUNT  =  Rden & (GatedPADDR == `PADDR_RTCTCOUNT);
// Identification register read signals.
assign PERIPHID0rd    = ((Rden == 1'b1) && (GatedPADDR == `PADDR_PERIPHID0));
assign PERIPHID1rd    = ((Rden == 1'b1) && (GatedPADDR == `PADDR_PERIPHID1));
assign PERIPHID2rd    = ((Rden == 1'b1) && (GatedPADDR == `PADDR_PERIPHID2));
assign PERIPHID3rd    = ((Rden == 1'b1) && (GatedPADDR == `PADDR_PERIPHID3));
assign PRIMECELLID0rd = ((Rden == 1'b1) && (GatedPADDR == `PADDR_PRIMECELLID0));
assign PRIMECELLID1rd = ((Rden == 1'b1) && (GatedPADDR == `PADDR_PRIMECELLID1));
assign PRIMECELLID2rd = ((Rden == 1'b1) && (GatedPADDR == `PADDR_PRIMECELLID2));
assign PRIMECELLID3rd = ((Rden == 1'b1) && (GatedPADDR == `PADDR_PRIMECELLID3));


//------------------------------------------------------------------------------
// Output Mux for selecting data read from different registers
//------------------------------------------------------------------------------

assign NextPRDATA =  (RdenRTCDR   == 1'b1)     ? RTCDR
                   : (RdenRTCMR   == 1'b1)     ? RTCMR
                   : (RdenRTCLR   == 1'b1)     ? RTCLR
                   : (RdenRTCCR   == 1'b1)     ? {28'h0000000,3'b000,RTCCR}
                   : (RdenRTCIMSC == 1'b1)     ? {28'h0000000,3'b000,RTCIMSC}
                   : (RdenRTCRIS  == 1'b1)     ? {28'h0000000,3'b000,RTCRIS}
                   : (RdenRTCMIS  == 1'b1)     ? {28'h0000000,3'b000,RTCMIS}
                   : (RdenRTCITCR == 1'b1)     ? {28'h0000000,1'b0,RTCITCR}
                   : (RdenRTCITOP == 1'b1)     ? {28'h0000000,3'b000,IntraOP}
                   : (RdenRTCTOFFSET == 1'b1)  ? RTCTOFFSET
                   : (RdenRTCTCOUNT  == 1'b1)  ? RTCTCOUNT
                   : (PERIPHID0rd == 1'b1)     ? {24'h000000, `RTC_PERIPHID0}
                   : (PERIPHID1rd == 1'b1)     ? {24'h000000, `RTC_PERIPHID1}
                   : (PERIPHID2rd == 1'b1)     ? {24'h000000, Revision, `RTC_PERIPHID2}
                   : (PERIPHID3rd == 1'b1)     ? {24'h000000, `RTC_PERIPHID3}
                   : (PRIMECELLID0rd == 1'b1)  ? {24'h000000, `PRIMECELLID0}
                   : (PRIMECELLID1rd == 1'b1)  ? {24'h000000, `PRIMECELLID1}
                   : (PRIMECELLID2rd == 1'b1)  ? {24'h000000, `PRIMECELLID2}
                   : (PRIMECELLID3rd == 1'b1)  ? {24'h000000, `PRIMECELLID3}
                   : 32'h00000000;

//------------------------------------------------------------------------------
// Implementation of APB Read Data Bus
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_SeqRead
  if(PRESETn == 1'b0)
    PRDATA <= 32'h00000000;
  else
    PRDATA <= NextPRDATA;
end // p_SeqRead


endmodule


//========================End of RtcApbif=======================================

















