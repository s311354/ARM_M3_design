// ----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//        (C) COPYRIGHT 2004-2013 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      RCS Information:
//
//      RCS Filename       : $RCSfile$
//      Revision           : $Revision: 22144 $
//      Release Information : CM3DesignStart-r0p0-01rel0
//
// ----------------------------------------------------------------------------
//  Purpose : AHB BlockRam/OnChip
// ----------------------------------------------------------------------------

`include "fpga_options_defs.v"

module ahb_blockram_128
  (//Inputs
   HCLK, HRESETn, HSELBRAM, HREADY, HTRANS, HSIZE, HWRITE, HADDR, HWDATA,
   //Outputs
   HREADYOUT, HRESP, HRDATA
   );

// --------------------------------------------------------------------------
// Parameter Declarations
// --------------------------------------------------------------------------
  parameter ADDRESSWIDTH = 18; //256K

// -----------------------------------------------------------------------------
// Constant Declarations
// -----------------------------------------------------------------------------
  parameter AW  = (ADDRESSWIDTH-1);
  parameter AWT = ((1<<(AW-1))-1);
  // HTRANS transfer type signal encoding
  parameter TRN_IDLE   = 2'b00;
  parameter TRN_BUSY   = 2'b01;
  parameter TRN_NONSEQ = 2'b10;
  parameter TRN_SEQ    = 2'b11;
  // HRESP transfer response signal encoding
  parameter RSP_OKAY   = 1'b0;
  parameter RSP_ERROR  = 1'b1;
  parameter RSP_RETRY  = 1'b0;
  parameter RSP_SPLIT  = 1'b1;

// --------------------------------------------------------------------------
// Port Definitions
// --------------------------------------------------------------------------
  input         HCLK;      // system bus clock
  input         HRESETn;   // system bus reset
  input         HSELBRAM;  // AHB peripheral select
  input         HREADY;  // AHB ready input
  input   [1:0] HTRANS;    // AHB transfer type
  input   [2:0] HSIZE;     // AHB hsize
  input         HWRITE;    // AHB hwrite
  input  [AW:0] HADDR;     // AHB address bus
  input [127:0] HWDATA;    // AHB write data bus
  output        HREADYOUT; // AHB ready output to S->M mux
  output        HRESP;     // AHB response
  output[127:0] HRDATA;    // AHB read data bus

// --------------------------------------------------------------------------
// Signal Declarations
// --------------------------------------------------------------------------
  // I/O pins
  wire          HCLK;      // system bus clock
  wire          HRESETn;   // system bus reset
  wire          HSELBRAM;  // AHB peripheral select
  wire          HREADY;  // AHB ready input
  wire    [1:0] HTRANS;    // AHB transfer type
  wire    [2:0] HSIZE;     // AHB hsize
  wire          HWRITE;    // AHB hwrite
  wire   [AW:0] HADDR;     // AHB address bus
  wire  [127:0] HWDATA;    // AHB write data bus
  wire          HREADYOUT; // AHB ready output to S->M mux
  wire          HRESP;     // AHB response
  wire  [127:0] HRDATA;    // AHB read data bus

  // Memory Array
  reg     [7:0] BRAM0  [0:AWT];
  reg     [7:0] BRAM1  [0:AWT];
  reg     [7:0] BRAM2  [0:AWT];
  reg     [7:0] BRAM3  [0:AWT];
  reg     [7:0] BRAM4  [0:AWT];
  reg     [7:0] BRAM5  [0:AWT];
  reg     [7:0] BRAM6  [0:AWT];
  reg     [7:0] BRAM7  [0:AWT];
  reg     [7:0] BRAM8  [0:AWT];
  reg     [7:0] BRAM9  [0:AWT];
  reg     [7:0] BRAM10 [0:AWT];
  reg     [7:0] BRAM11 [0:AWT];
  reg     [7:0] BRAM12 [0:AWT];
  reg     [7:0] BRAM13 [0:AWT];
  reg     [7:0] BRAM14 [0:AWT];
  reg     [7:0] BRAM15 [0:AWT];

  // Internal signals
  reg  [AW-4:0] reg_haddr;  // Registered address
  wire          trn_valid;  // Transfer valid
  wire   [15:0] nxt_wr_en;  // Next write enable
  reg    [15:0] reg_wr_en;  // Registered write enable
  wire          wr_en_actv; // Active Write enable
  wire          size___8bit;
  wire          size__16bit;
  wire          size__32bit;
  wire          size__64bit;
  wire          size_128bit;

  // -----------------------------------------------------------------------------
  // Main body of code
  // -----------------------------------------------------------------------------

  assign trn_valid = HSELBRAM & HREADY & HTRANS[1];

  // -----------------------------------------------------------------------------
  // RAM Write Interface
  // -----------------------------------------------------------------------------
  assign wr_en_actv   = (trn_valid & HWRITE) | (|reg_wr_en);

  assign size___8bit = (HSIZE[2:0]==3'b000);
  assign size__16bit = (HSIZE[2:0]==3'b001);
  assign size__32bit = (HSIZE[2:0]==3'b010);
  assign size__64bit = (HSIZE[2:0]==3'b011);
  assign size_128bit = (HSIZE[2:0]==3'b100);

  assign nxt_wr_en[0]  = (((HADDR[3:0]==4'b0000) && size___8bit) ||
                          ((HADDR[3:1]==3'b000)  && size__16bit) ||
                          ((HADDR[3:2]==2'b00)   && size__32bit) ||
                          ((HADDR[3]  ==1'b0)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;

  assign nxt_wr_en[1]  = (((HADDR[3:0]==4'b0001) && size___8bit) ||
                          ((HADDR[3:1]==3'b000)  && size__16bit) ||
                          ((HADDR[3:2]==2'b00)   && size__32bit) ||
                          ((HADDR[3]  ==1'b0)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[2]  = (((HADDR[3:0]==4'b0010) && size___8bit) ||
                          ((HADDR[3:1]==3'b001)  && size__16bit) ||
                          ((HADDR[3:2]==2'b00)   && size__32bit) ||
                          ((HADDR[3]  ==1'b0)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[3]  = (((HADDR[3:0]==4'b0011) && size___8bit) ||
                          ((HADDR[3:1]==3'b001)  && size__16bit) ||
                          ((HADDR[3:2]==2'b00)   && size__32bit) ||
                          ((HADDR[3]  ==1'b0)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[4]  = (((HADDR[3:0]==4'b0100) && size___8bit) ||
                          ((HADDR[3:1]==3'b010)  && size__16bit) ||
                          ((HADDR[3:2]==2'b01)   && size__32bit) ||
                          ((HADDR[3]  ==1'b0)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[5]  = (((HADDR[3:0]==4'b0101) && size___8bit) ||
                          ((HADDR[3:1]==3'b010)  && size__16bit) ||
                          ((HADDR[3:2]==2'b01)   && size__32bit) ||
                          ((HADDR[3]  ==1'b0)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[6]  = (((HADDR[3:0]==4'b0110) && size___8bit) ||
                          ((HADDR[3:1]==3'b011)  && size__16bit) ||
                          ((HADDR[3:2]==2'b01)   && size__32bit) ||
                          ((HADDR[3]  ==1'b0)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[7]  = (((HADDR[3:0]==4'b0111) && size___8bit) ||
                          ((HADDR[3:1]==3'b011)  && size__16bit) ||
                          ((HADDR[3:2]==2'b01)   && size__32bit) ||
                          ((HADDR[3]  ==1'b0)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[8]  = (((HADDR[3:0]==4'b1000) && size___8bit) ||
                          ((HADDR[3:1]==3'b100)  && size__16bit) ||
                          ((HADDR[3:2]==2'b10)   && size__32bit) ||
                          ((HADDR[3]  ==1'b1)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[9]  = (((HADDR[3:0]==4'b1001) && size___8bit) ||
                          ((HADDR[3:1]==3'b100)  && size__16bit) ||
                          ((HADDR[3:2]==2'b10)   && size__32bit) ||
                          ((HADDR[3]  ==1'b1)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[10] = (((HADDR[3:0]==4'b1010) && size___8bit) ||
                          ((HADDR[3:1]==3'b101)  && size__16bit) ||
                          ((HADDR[3:2]==2'b10)   && size__32bit) ||
                          ((HADDR[3]  ==1'b1)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[11] = (((HADDR[3:0]==4'b1011) && size___8bit) ||
                          ((HADDR[3:1]==3'b101)  && size__16bit) ||
                          ((HADDR[3:2]==2'b10)   && size__32bit) ||
                          ((HADDR[3]  ==1'b1)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[12] = (((HADDR[3:0]==4'b1100) && size___8bit) ||
                          ((HADDR[3:1]==3'b110)  && size__16bit) ||
                          ((HADDR[3:2]==2'b11)   && size__32bit) ||
                          ((HADDR[3]  ==1'b1)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[13] = (((HADDR[3:0]==4'b1101) && size___8bit) ||
                          ((HADDR[3:1]==3'b110)  && size__16bit) ||
                          ((HADDR[3:2]==2'b11)   && size__32bit) ||
                          ((HADDR[3]  ==1'b1)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[14] = (((HADDR[3:0]==4'b1110) && size___8bit) ||
                          ((HADDR[3:1]==3'b111)  && size__16bit) ||
                          ((HADDR[3:2]==2'b11)   && size__32bit) ||
                          ((HADDR[3]  ==1'b1)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;
  assign nxt_wr_en[15] = (((HADDR[3:0]==4'b1111) && size___8bit) ||
                          ((HADDR[3:1]==3'b111)  && size__16bit) ||
                          ((HADDR[3:2]==2'b11)   && size__32bit) ||
                          ((HADDR[3]  ==1'b1)    && size__64bit) ||
                                                    size_128bit )? trn_valid & HWRITE : 1'b0;

  always @ (negedge HRESETn or posedge HCLK)
  begin
    if (~HRESETn)
      reg_wr_en <= 16'h0000;
    else if (wr_en_actv)
      reg_wr_en <= nxt_wr_en;
  end

  // Infer Block RAM - syntax is very specific.
  always @ (posedge HCLK)
    begin
      if (reg_wr_en[0])
        BRAM0[reg_haddr] <= HWDATA[7:0];
      if (reg_wr_en[1])
        BRAM1[reg_haddr] <= HWDATA[15:8];
      if (reg_wr_en[2])
        BRAM2[reg_haddr] <= HWDATA[23:16];
      if (reg_wr_en[3])
        BRAM3[reg_haddr] <= HWDATA[31:24];
      if (reg_wr_en[4])
        BRAM4[reg_haddr] <= HWDATA[39:32];
      if (reg_wr_en[5])
        BRAM5[reg_haddr] <= HWDATA[47:40];
      if (reg_wr_en[6])
        BRAM6[reg_haddr] <= HWDATA[55:48];
      if (reg_wr_en[7])
        BRAM7[reg_haddr] <= HWDATA[63:56];
      if (reg_wr_en[8])
        BRAM8[reg_haddr] <= HWDATA[71:64];
      if (reg_wr_en[9])
        BRAM9[reg_haddr] <= HWDATA[79:72];
      if (reg_wr_en[10])
        BRAM10[reg_haddr] <= HWDATA[87:80];
      if (reg_wr_en[11])
        BRAM11[reg_haddr] <= HWDATA[95:88];
      if (reg_wr_en[12])
        BRAM12[reg_haddr] <= HWDATA[103:96];
      if (reg_wr_en[13])
        BRAM13[reg_haddr] <= HWDATA[111:104];
      if (reg_wr_en[14])
        BRAM14[reg_haddr] <= HWDATA[119:112];
      if (reg_wr_en[15])
        BRAM15[reg_haddr] <= HWDATA[127:120];

      // do not use enable on read interface.
      reg_haddr <= HADDR[AW:4];
    end

  // -----------------------------------------------------------------------------
  // AHB Outputs
  // -----------------------------------------------------------------------------
  assign HRESP     = RSP_OKAY;
  assign HREADYOUT = 1'b1;
  assign HRDATA    = {BRAM15[reg_haddr],BRAM14[reg_haddr],
                      BRAM13[reg_haddr],BRAM12[reg_haddr],
                      BRAM11[reg_haddr],BRAM10[reg_haddr],
                      BRAM9[reg_haddr],BRAM8[reg_haddr],
                      BRAM7[reg_haddr],BRAM6[reg_haddr],
                      BRAM5[reg_haddr],BRAM4[reg_haddr],
                      BRAM3[reg_haddr],BRAM2[reg_haddr],
                      BRAM1[reg_haddr],BRAM0[reg_haddr]};

  // -----------------------------------------------------------------------------
  // Initial image
  // -----------------------------------------------------------------------------

`ifdef SIMULATION
`ifndef RAMPRELOAD_SPI
  // Simulation
  integer i;
  reg [127:0] fileimage [0:AWT];

  initial
  begin
    for (i=0;i<=AWT; i= i+1)
    begin
      fileimage[i] = 0; // initialize memory to 0
    end

    $readmemh("./flash_main.ini", fileimage);

    // Copy from single array to splitted array
    for (i=0;i<=AWT; i= i+1)
    begin
      {BRAM15[i],BRAM14[i],BRAM13[i],BRAM12[i],BRAM11[i],BRAM10[i],BRAM9[i],BRAM8[i],
       BRAM7[i],BRAM6[i],BRAM5[i],BRAM4[i],BRAM3[i],BRAM2[i],BRAM1[i],BRAM0[i]} = fileimage[i];
    end
  end

`endif // RAMPRELOAD_SPI
`endif // MODEL_TECH

endmodule


