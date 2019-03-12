//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//        (C) COPYRIGHT 2013 ARM Limited or its affiliates.
//            ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
// -----------------------------------------------------------------------------
//
//      SVN Information
//
//      Checked In          : $Date: 2013-04-05 11:54:17 +0100 (Fri, 05 Apr 2013) $
//
//      Revision            : $Revision: 242973 $
//
//      Release Information : CM3DesignStart-r0p0-01rel0
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : I2S interface double flip-flop synchronization
//-----------------------------------------------------------------------------

module i2s_sync_cell (
  input   wire     clk,
  input   wire     rst_n,
  input   wire     din,
  output  wire     dout
  );

  reg   sync1;
  reg   sync2;

  // synchroniser
  always @ (posedge clk or negedge rst_n)
    if (!rst_n)
      begin
       sync1  <= 1'b0;
       sync2  <= 1'b0;
      end
    else
      begin
        sync1 <= din;
        sync2 <= sync1;
      end

  assign dout = sync2;

endmodule
