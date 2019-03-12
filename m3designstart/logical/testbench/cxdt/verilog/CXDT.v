//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//            (C) COPYRIGHT 2013-2016 ARM Limited or its affiliates.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
//      Release Information : TM840-MN-22010-r0p0-00rel0
//
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// CXDT - CoreSight Debug Tester
//-----------------------------------------------------------------------------
//
// This block drives JTAG or SerialWire protocol by executing a code image
// compiled for the ARMv6-M architecture.
//
// This module instantiates a fast, non-synthesisable execution engine.
// The simulation engine supports semihosted printing, so does not
// require retarget code.
//-----------------------------------------------------------------------------

module CXDT
  #(
    parameter IMAGENAME     = "image.bin",
    parameter IMAGEPLUSARG  = "cxdtbinname",
    parameter SWCLKTCKDELAY = 5
    )
   (input  wire       CLK,
    input  wire       PORESETn,

    // Debug Interface
    input  wire       TDO,
    output wire       nTRST,
    output wire       SWCLKTCK,
    output wire       TDI,
    inout  wire       SWDIOTMS
    );

   localparam ADDRWIDTH = 19; // 512kB


//-----------------------------------------------------------------------------
// SWJTAG Signals
//-----------------------------------------------------------------------------

   wire          swdotms;
   wire          swdotms_en;

   // Tri-State Buffer for SWDIOTMS
   bufif1 (SWDIOTMS, swdotms, swdotms_en);


//-----------------------------------------------------------------------------
// Select CXDT Implementation
//-----------------------------------------------------------------------------
`ifdef CXDT_SYNTH
   // Synthesisable Implementation (not supported)
`else
   // Behavioural Simulation Engine (fast, default)
`define CXDT_V6MENGINE
`endif


//-----------------------------------------------------------------------------
// v6m_exec_engine implementation
//-----------------------------------------------------------------------------
`ifdef CXDT_V6MENGINE
   // Specify v6m_eval_engine parameters:

   localparam v6m_verbose = 0; // Print debug messages
   localparam v6m_log2_input_words  = 2;  // 32x4 of inputs
   localparam v6m_log2_output_words = 3;  // 32x8 of outputs
   localparam v6m_log2_stack_words  = 12; // 8kB local private stacks
   localparam v6m_log2_memory_words = (ADDRWIDTH-2); // code and heap

   // Generate input and output arrays and assign drivers:

   wire [31:0] v6m_inputs  [0:(2**v6m_log2_input_words)-1];
   reg  [31:0] v6m_outputs [0:(2**v6m_log2_output_words)-1];


   // Inputs
   assign v6m_inputs[0][31:1] = 31'b0;
   assign v6m_inputs[1][31:1] = 31'b0;
   assign v6m_inputs[2][31:1] = 31'b0;
   assign v6m_inputs[3][31:0] = 32'b0;
   assign v6m_inputs[0][0]    = (SWDIOTMS === 1'b1);
   assign v6m_inputs[1][0]    = (TDO      === 1'b1);
   assign v6m_inputs[2][0]    = (PORESETn === 1'b1);


   // Outputs
   assign swdotms     = v6m_outputs[0][0];
   assign swdotms_en  = v6m_outputs[1][0];
   assign SWCLKTCK    = v6m_outputs[2][0];
   assign nTRST       = v6m_outputs[3][0];
   assign TDI         = v6m_outputs[4][0];


   // Include execution engine source code:
`include "v6m_exec_engine.v"


   // Load image and call reset routine at simulation start:
   reg             plusargimage_specified;
   reg [512*8-1:0] plusargimagename;

   initial begin
      // Test whether an image name was supplied via a plusarg
      plusargimage_specified=$value$plusargs({IMAGEPLUSARG,"=%s"}, plusargimagename);
      if(plusargimage_specified)
        begin
           $display("Loading CXDT from plusarg +%s",IMAGEPLUSARG);
           v6m_load_binary(plusargimagename);
        end
      else
        begin
           $display("Loading CXDT from parameter IMAGENAME (%s)",IMAGENAME);
           v6m_load_binary(IMAGENAME);
        end
   end


   // Regulate SWCLKTCK speed
   reg           swclktckedge;

   initial
     swclktckedge <= 1'b0;

   always@(swclktckedge)
     #SWCLKTCKDELAY swclktckedge <= ~swclktckedge;

   // Run vector 11 ("SVC") on every edge of swclktckedge
   always @(posedge swclktckedge)
     v6m_exec_vector(11);


`endif //  `ifdef CXDT_V6MENGINE


endmodule
