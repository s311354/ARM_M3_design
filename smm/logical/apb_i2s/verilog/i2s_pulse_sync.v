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
// Abstract : I2S interface pulse synchronization
//-----------------------------------------------------------------------------

module i2s_pulse_sync (
  input   wire     clk1,
  input   wire     rst1_n,

  input   wire     clk2,
  input   wire     rst2_n,

  input   wire     pulse_in,
  output  wire     pulse_out
  );


  reg     reg_pulse_latch;
  wire    nxt_pulse_latch;

  wire    sync_pulse_req;
  reg     last_pulse_req;
  wire    sync_pulse_ack;


  // Pulse latch
  assign nxt_pulse_latch = pulse_in | (reg_pulse_latch & ~sync_pulse_ack);

  always @ (posedge clk1 or negedge rst1_n)
    if (!rst1_n)
       reg_pulse_latch  <= 1'b0;
    else
       reg_pulse_latch  <= nxt_pulse_latch;

  i2s_sync_cell u_sync_req (
    .clk    (clk2),
    .rst_n  (rst2_n),
    .din    (reg_pulse_latch),
    .dout   (sync_pulse_req)
    );

  always @ (posedge clk2 or negedge rst2_n)
    if (!rst2_n)
       last_pulse_req  <= 1'b0;
    else
       last_pulse_req  <= sync_pulse_req;

  // Pulse out is rising edge of sync_pulse_req
  assign pulse_out = sync_pulse_req & ~last_pulse_req;

  i2s_sync_cell u_sync_ack (
    .clk    (clk1),
    .rst_n  (rst1_n),
    .din    (sync_pulse_req),
    .dout   (sync_pulse_ack)
    );

endmodule
