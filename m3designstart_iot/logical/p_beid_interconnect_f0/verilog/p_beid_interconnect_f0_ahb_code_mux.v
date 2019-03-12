//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//        (C) COPYRIGHT 2015 ARM Limited or its affiliates.
//            ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
//      SVN Information
//
//      Checked In          :  2015-09-17 13:43:40 +0100 (Thu, 17 Sep 2015)
//
//      Revision            :  2354
//
//      Release Information : CM3DesignStart-r0p0-02rel0
//
// -----------------------------------------------------------------------------
//  Purpose : Bus Multiplexer to combine the ICODE and DCODE buses
// -----------------------------------------------------------------------------
// File content is a simple (unchanged) version of CM3 - CortexM3 integration - cm3_code_mux.v
// Used CM3 release: AT425-BU-50000-r2p1-00rel0
//    Revision: 143211
//    Release Information : CM3DesignStart-r0p0-02rel0
//-----------------------------------------------------------------------------

`define RESP_OKAY 2'b00

module p_beid_interconnect_f0_ahb_code_mux (
  // Inputs
  HCLK, HRESETn,
  HADDRI, HTRANSI, HSIZEI, HBURSTI, HPROTI,
  HADDRD, HTRANSD, HSIZED, HBURSTD, HPROTD, HWDATAD, HWRITED, EXREQD,
  HRDATAC, HREADYC, HRESPC, EXRESPC,
  // Outputs
  HRDATAI, HREADYI, HRESPI, HRDATAD, HREADYD, HRESPD, EXRESPD,
  HADDRC, HWDATAC, HTRANSC, HWRITEC, HSIZEC, HBURSTC, HPROTC, EXREQC
  );

  // Common AHB signals
  input         HCLK;             // AHB system clock
  input         HRESETn;          // AHB system reset

  // CPU side inputs
  input [31:0]  HADDRI;           // ICode address
  input  [1:0]  HTRANSI;          // ICode transfer type
  input  [2:0]  HSIZEI;           // ICode transfer size
  input  [2:0]  HBURSTI;          // ICode burst type
  input  [3:0]  HPROTI;           // ICode protection control
  input [31:0]  HADDRD;           // DCode address
  input  [1:0]  HTRANSD;          // DCode transfer type
  input  [2:0]  HSIZED;           // DCode transfer size
  input  [2:0]  HBURSTD;          // DCode burst type
  input  [3:0]  HPROTD;           // DCode protection control
  input [31:0]  HWDATAD;          // DCode write data
  input         HWRITED;          // DCode write not read
  input         EXREQD;           // DCode exclusive request

  // Code side inputs
  input [31:0]  HRDATAC;          // Code bus read data
  input         HREADYC;          // Code bus transfer completed
  input  [1:0]  HRESPC;           // Code bus response status
  input         EXRESPC;          // Code bus exclusive response

  // CPU side outputs
  output [31:0] HRDATAI;          // ICode read data
  output        HREADYI;          // ICode transfer completed
  output  [1:0] HRESPI;           // ICode response status
  output [31:0] HRDATAD;          // DCode read data
  output        HREADYD;          // DCode transfer completed
  output  [1:0] HRESPD;           // DCode response status
  output        EXRESPD;          // DCode exclusive response

  // Code side outputs
  output [31:0] HADDRC;           // Code bus address
  output [31:0] HWDATAC;          // Code bus write data
  output  [1:0] HTRANSC;          // Code bus transfer type
  output        HWRITEC;          // Code bus write not read
  output  [2:0] HSIZEC;           // Code bus transfer size
  output  [2:0] HBURSTC;          // Code bus burst type
  output  [3:0] HPROTC;           // Code bus protection control
  output        EXREQC;           // Code bus exclusive request

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  wire          d_trans_active;     // Active transaction on DCode bus
  reg           d_trans_active_reg; // Registered d_trans_active

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

  assign d_trans_active = HTRANSD[1];

  // Address and control
  assign HADDRC  = d_trans_active ? HADDRD  : HADDRI;
  assign HTRANSC = d_trans_active ? HTRANSD : HTRANSI;
  assign HWRITEC = d_trans_active ? HWRITED : 1'b0;
  assign HSIZEC  = d_trans_active ? HSIZED  : HSIZEI;
  assign HBURSTC = d_trans_active ? HBURSTD : HBURSTI;
  assign HPROTC  = d_trans_active ? HPROTD  : HPROTI;

  // Read/write data
  assign HRDATAI = HRDATAC;
  assign HRDATAD = HRDATAC;
  assign HWDATAC = HWDATAD;

  // Ready response
  assign HREADYI = HREADYC;
  assign HREADYD = HREADYC;

  // Transfer response status
  assign HRESPI  = d_trans_active_reg ? `RESP_OKAY : HRESPC;
  assign HRESPD  = d_trans_active_reg ? HRESPC     : `RESP_OKAY;

  // Exclusive request/response
  assign EXREQC  = EXREQD;
  assign EXRESPD = d_trans_active_reg & EXRESPC;

  // Registered d_trans_active
  always @ (posedge HCLK or negedge HRESETn)
    begin
      if (!HRESETn)
        d_trans_active_reg <= 1'b0;
      else if (HREADYC)
        d_trans_active_reg <= d_trans_active;
    end

//------------------------------------------------------------------------------
// Assertions
//------------------------------------------------------------------------------


endmodule

