//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2012-2013 ARM Limited.
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
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : Simple behavioral model of 16-bit flash memory
//-----------------------------------------------------------------------------

module cmsdk_flash_rom16 #(
// --------------------------------------------------------------------------
// Parameter Declarations
// --------------------------------------------------------------------------
 parameter AW       = 16,// Address width
 parameter filename = "image.dat",
 parameter WS       = 0  // wait state
 )
 (
  // reset and clock for emulating read timing
  input  wire           rst_n,
  input  wire           clk,

  input  wire  [AW-2:0] addr,
  output wire  [15:0]   rdata
  );

  reg       [7:0]  rom_data[0:((1<<AW)-1)]; // Data array
  integer          i;            // Loop counter for init
  reg    [AW-2:0]  lastaddr1;

  wire     [31:0]  nxt_waitstate_cnt;
  reg      [31:0]  reg_waitstate_cnt;
  wire             data_ready;

// Start of main code
  // Initialize ROM
  initial
    begin
    for (i=0;i<(1<<AW);i=i+1)
      begin
      rom_data[i] = 8'h00; //Initialize all data to 0
      end
      if (filename != "")
        begin
        $readmemh(filename, rom_data); // Then read in program code
        end
      else
        begin
        $display("WARNING: ROM image is empty!\n");
        end
    end

  // Wait state control
  always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      lastaddr1 <= {(AW-1){1'b1}};
    else
      lastaddr1 <= addr;
  end

  // Counter increment each time if address stay the same,
  // and return to 0 if address changed
  assign nxt_waitstate_cnt = (addr != lastaddr1) ? 0 :
                           ((reg_waitstate_cnt >= WS) ? WS : (reg_waitstate_cnt+1));

    // Register wait state counter
  always @(posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      reg_waitstate_cnt <= 0;
    else
      reg_waitstate_cnt <= nxt_waitstate_cnt;
  end

  assign data_ready = (nxt_waitstate_cnt >= WS);

  // Read operation  - output only if address is stable for WS cycles
  assign rdata[ 7: 0] =  (data_ready) ? rom_data[(2*addr)  ] : {8{1'b1}} ;
  assign rdata[15: 8] =  (data_ready) ? rom_data[(2*addr)+1] : {8{1'b1}} ;

endmodule
