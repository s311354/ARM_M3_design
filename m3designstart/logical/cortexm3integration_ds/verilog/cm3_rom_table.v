//------------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2004-2010 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//  Revision            : $Revision: 365823 $
//  Release information : CM3DesignStart-r0p0-02rel0
//
// -----------------------------------------------------------------------------
//  ROM Table to identify Coresight Debug components in the system
//  Contains customer modifiable sections for new added peripherals, and
//  ID values for the system.
//  Only supports up to 16 peripheral entries
//
// CID indicates ROM-Table (Device Class 1)
//
// PID 0-4 indicate:
// ARM Part number 4C3 Revision 0
//     Generic Rom Table for Cortex-M3
//
// PID 0-4 should be updated to reflect the actual manufacturer and device code.
// -----------------------------------------------------------------------------

module cm3_rom_table (/*AUTOARG*/
  // Inputs
  PCLK, PRESETn, PSEL, PENABLE, PADDR, PWRITE,
  // Outputs
  PRDATA
  );

  // ---------------------------------------------------------------------------
  // Parameters
  // ---------------------------------------------------------------------------
  parameter DEBUG_LVL = 3;
  parameter TRACE_LVL = 1;

  // Inputs
  //======
  input         PCLK;           //APB Clock
  input         PRESETn;        //APB Reset
  input         PSEL;           //APB Select
  input         PENABLE;        //APB Enable
  input  [11:2] PADDR;          //APB Address
  input         PWRITE;         //APB Write

  // Outputs
  // =======

  output [31:0] PRDATA;         // APB Read Data

  // Local controls
  wire          addr_reg_we;
  wire    [5:0] nxt_addr_reg;
  reg     [5:0] addr_reg;

  // Logic removal
  reg    [31:0] apb_rdata;


  //----------------------------------------------------------------------------
  // ROM table trace not present logic removal terms
  //----------------------------------------------------------------------------
  assign PRDATA  = (DEBUG_LVL > 0) ? apb_rdata : {32{1'b0}};

  // ---------------------------------------------------------------------------
  // Control registration. Map addresses into two regions
  // Only supports 4 LSBs of address
  // ---------------------------------------------------------------------------
  assign addr_reg_we  = PSEL & ~PWRITE;
  assign nxt_addr_reg = {&PADDR[11:6], ~|PADDR[11:6],PADDR[5:2]};

  always @ (posedge PCLK or negedge PRESETn)
    if (!PRESETn)
      addr_reg <= 6'b000000;
    else if (addr_reg_we)
      addr_reg <= nxt_addr_reg;

  // ---------------------------------------------------------------------------
  // Read Multiplexor
  // ---------------------------------------------------------------------------
  always @ (addr_reg)
    case (addr_reg)
      // NVIC (0x000) - Do not modify
      6'b0_1_0000 : apb_rdata = 32'hFFF0F003;
      // DWT  (0x004) - Do not modify
      6'b0_1_0001 : apb_rdata = 32'hFFF02003;
      // FPB  (0x008) - Do not modify
      6'b0_1_0010 : apb_rdata = 32'hFFF03003;
      // ITM  (0x00C) - Do not modify
      6'b0_1_0011 : apb_rdata = (TRACE_LVL > 0) ? 32'hFFF01003 : 32'hFFF01002;

      // --------------------------------------------------------------------
      // Customer modifyable section
      //
      // This two locations are reserved for TPIU and ETM, the
      // address offset values can be change, but do not change to
      // other debug compoennts.  If TPIU or ETM is not present, put
      // the LSB to 0.
      //
      // TPIU (0x010)
      6'b0_1_0100 : apb_rdata = (TRACE_LVL > 0) ? 32'hFFF41003 : 32'hFFF41002;
      // ETM  (0x014)
      6'b0_1_0101 : apb_rdata = (TRACE_LVL > 1) ? 32'hFFF42003 : 32'hFFF42002;

      // Additional debug components can be added here


      // Target Identification IDs - for identification of target platform
      // PID4
      6'b1_0_0100 : apb_rdata = 32'h00000004;
      // PID5
      6'b1_0_0101 : apb_rdata = 32'h00000000;
      // PID6
      6'b1_0_0110 : apb_rdata = 32'h00000000;
      // PID7
      6'b1_0_0111 : apb_rdata = 32'h00000000;
      // PID0
      6'b1_0_1000 : apb_rdata = 32'h000000C3;
      // PID1
      6'b1_0_1001 : apb_rdata = 32'h000000B4;
      // PID2
      6'b1_0_1010 : apb_rdata = 32'h0000000B;
      // PID3
      6'b1_0_1011 : apb_rdata = 32'h00000000;

      // End of customer modifications
      // --------------------------------------------------------------------
      // MEMTYPE - Indicates that system memory can be accessed
      6'b1_0_0011 : apb_rdata = 32'h00000001;
      // Do not modify the following ID registers
      // CID0
      6'b1_0_1100 : apb_rdata = 32'h0000000D;
      // CID1
      6'b1_0_1101 : apb_rdata = 32'h00000010;
      // CID2
      6'b1_0_1110 : apb_rdata = 32'h00000005;
      // CID3
      6'b1_0_1111 : apb_rdata = 32'h000000B1;

      default     : apb_rdata = 32'h00000000;
    endcase

endmodule
