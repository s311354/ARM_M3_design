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
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : Simple 8-bit SRAM component behavioral model
//-----------------------------------------------------------------------------

module cmsdk_sram256x8 #(
  parameter  AW       = 18, // Address width
  parameter  filename = "")
 (
  input  wire  [AW-1:0]     Address,
  inout  wire  [7:0]        DataIO,
  input  wire               WEn,
  input  wire               OEn,
  input  wire               CEn);

reg    [7:0]         ram_data[0:((1<<AW)-1)]; // 256k byte of RAM data
integer              i;                 // Loop counter

// Start of main code
// Initialize RAM
initial
  begin
  for (i=0;i<(1<<AW);i=i+1)
    begin
    ram_data[i] = 8'h00; //Initialize all data to 0
    end
  if (filename != "")
    begin
    $readmemh(filename, ram_data); // Then read in program code
    end
  end

// Read from array with Output tristate buffer
assign DataIO[ 7:0] = ((WEn) & (~OEn) & (~CEn)) ? ram_data[Address] : 8'hzz;

// Write
always @(Address or WEn or CEn or DataIO)
begin
  if ((~WEn) & (~CEn))
    begin
    ram_data[Address] = DataIO[ 7:0];
    end
end

endmodule
