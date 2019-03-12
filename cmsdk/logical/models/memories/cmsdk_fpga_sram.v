//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2010-2013 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2013-04-10 15:27:13 +0100 (Wed, 10 Apr 2013) $
//
//      Revision            : $Revision: 243506 $
//
//      Release Information : Cortex-M System Design Kit-r1p0-00rel0
//
// ----------------------------------------------------------------------------
//  Abstract : FPGA BlockRam/OnChip SRAM
// ----------------------------------------------------------------------------
// The read operation is pipelined. Write operation is not pipelined.

module cmsdk_fpga_sram #(
// --------------------------------------------------------------------------
// Parameter Declarations
// --------------------------------------------------------------------------
  parameter AW = 16
 )
 (
  // Inputs
  input  wire          CLK,
  input  wire [AW-1:2] ADDR,
  input  wire [31:0]   WDATA,
  input  wire [3:0]    WREN,
  input  wire          CS,

  // Outputs
  output wire [31:0]   RDATA
  );

// -----------------------------------------------------------------------------
// Constant Declarations
// -----------------------------------------------------------------------------
localparam AWT = ((1<<(AW-2))-1);

  // Memory Array
  reg     [7:0]   BRAM0 [AWT:0];
  reg     [7:0]   BRAM1 [AWT:0];
  reg     [7:0]   BRAM2 [AWT:0];
  reg     [7:0]   BRAM3 [AWT:0];

  // Internal signals
  reg     [AW-3:0]  addr_q1;
  wire    [3:0]     write_enable;
  reg               cs_reg;
  wire    [31:0]    read_data;

  assign write_enable[3:0] = WREN[3:0] & {4{CS}};

  always @ (posedge CLK)
    begin
    cs_reg <= CS;
    end

  // Infer Block RAM - syntax is very specific.
  always @ (posedge CLK)
    begin
      if (write_enable[0])
        BRAM0[ADDR] <= WDATA[7:0];
      if (write_enable[1])
        BRAM1[ADDR] <= WDATA[15:8];
      if (write_enable[2])
        BRAM2[ADDR] <= WDATA[23:16];
      if (write_enable[3])
        BRAM3[ADDR] <= WDATA[31:24];
      // do not use enable on read interface.
      addr_q1 <= ADDR[AW-1:2];
    end

  assign read_data  = {BRAM3[addr_q1],BRAM2[addr_q1],BRAM1[addr_q1],BRAM0[addr_q1]};

  assign RDATA      = (cs_reg) ? read_data : {32{1'b0}};



endmodule
