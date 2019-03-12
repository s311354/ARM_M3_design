//===========================================================================--
//  The confidential and proprietary information contained in this file may
//  only be used by a person authorised under and to the extent permitted
//  by a subsisting licensing agreement from ARM Limited.
//
//                (C) COPYRIGHT 2004-2010 ARM Limited
//                    ALL RIGHTS RESERVED
//
//  This entire notice must be reproduced on all copies of this file
//  and copies of this file may only be made by a person if such person is
//  permitted to do so under the terms of a subsisting license agreement
//  from ARM Limited.
//
//  Revision            : $Revision: 365823 $
//  Release information : CM3DesignStart-r0p0-02rel0
//
//-----------------------------------------------------------------------------

module cm3_flash_mux (

    // Common AHB signals
    HCLK,
    HRESETn,

    // Input Port 0
    HADDRS0,
    HTRANSS0,
    HWRITES0,
    HSIZES0,
    HBURSTS0,
    HPROTS0,
    HWDATAS0,
    HREADYS0,

    // Input Port 1
    HADDRS1,
    HTRANSS1,
    HWRITES1,
    HSIZES1,
    HBURSTS1,
    HPROTS1,
    HWDATAS1,
    HREADYS1,

    // Response signals from Slave for Port 0
    HRDATAM0,
    HREADYOUTM0,
    HRESPM0,

    // Response signals to Master for Port 0
    HRDATAS0,
    HREADYOUTS0,
    HRESPS0,

    // Response signals to Master for Port 1
    HRDATAS1,
    HREADYOUTS1,
    HRESPS1,

    // Output Port 0
    HADDRM0,
    HTRANSM0,
    HWRITEM0,
    HSIZEM0,
    HBURSTM0,
    HPROTM0,
    HWDATAM0,
    HREADYMUXM0
    );

// -----------------------------------------------------------------------------
// Input & Output declarations
// -----------------------------------------------------------------------------
    input         HCLK;            // AHB System Clock
    input         HRESETn;         // AHB System Reset

    // Input Port 0
    input  [31:0] HADDRS0;         // Address bus
    input   [1:0] HTRANSS0;        // Transfer type
    input         HWRITES0;        // Transfer direction
    input   [2:0] HSIZES0;         // Transfer size
    input   [2:0] HBURSTS0;        // Burst type
    input   [3:0] HPROTS0;         // Protection control
    input  [31:0] HWDATAS0;        // Write data
    input         HREADYS0;        // Transfer done

    // Input Port 1
    input  [31:0] HADDRS1;         // Address bus
    input   [1:0] HTRANSS1;        // Transfer type
    input         HWRITES1;        // Transfer direction
    input   [2:0] HSIZES1;         // Transfer size
    input   [2:0] HBURSTS1;        // Burst type
    input   [3:0] HPROTS1;         // Protection control
    input  [31:0] HWDATAS1;        // Write data
    input         HREADYS1;        // Transfer done

    input  [31:0] HRDATAM0;        // Read data bus
    input         HREADYOUTM0;     // HREADY feedback
    input         HRESPM0;         // Transfer response

    output [31:0] HRDATAS0;        // Read data bus
    output        HREADYOUTS0;     // HREADY feedback
    output        HRESPS0;         // Transfer response

    output [31:0] HRDATAS1;        // Read data bus
    output        HREADYOUTS1;     // HREADY feedback
    output        HRESPS1;         // Transfer response

    // Output Port 0
    output [31:0] HADDRM0;         // Address bus
    output  [1:0] HTRANSM0;        // Transfer type
    output        HWRITEM0;        // Transfer direction
    output  [2:0] HSIZEM0;         // Transfer size
    output  [2:0] HBURSTM0;        // Burst type
    output  [3:0] HPROTM0;         // Protection control
    output [31:0] HWDATAM0;        // Write data
    output        HREADYMUXM0;     // Transfer done

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

    wire  [31:0] hrdatas0;        // Read data bus
    wire         hreadyouts0;     // HREADY feedback
    wire         hresps0;         // Transfer response

    wire [31:0]  hrdatas1;        // Read data bus
    wire         hreadyouts1;     // HREADY feedback
    wire         hresps1;         // Transfer response

    // Output Port 0
    wire [31:0]  haddrm0;         // Address bus
    wire  [1:0]  htransm0;        // Transfer type
    wire         hwritem0;        // Transfer direction
    wire  [2:0]  hsizem0;         // Transfer size
    wire  [2:0]  hburstm0;        // Burst type
    wire  [3:0]  hprotm0;         // Protection control
    wire [31:0]  hwdatam0;        // Write data
    wire         hreadymuxm0;     // Transfer done

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
// Bus-switch input 0
    wire        sel0;       // Port 0 HSEL signal
    wire [31:0] addr0;      // Port 0 HADDR signal
    wire  [1:0] trans0;     // Port 0 HTRANS signal
    wire        write0;     // Port 0 HWRITE signal
    wire  [2:0] size0;      // Port 0 HSIZE signal
    wire  [2:0] burst0;     // Port 0 HBURST signal
    wire  [3:0] prot0;      // Port 0 HPROTS signal
    wire  [3:0] master0;    // Port 0 HMASTER signal
    wire        mastlock0;  // Port 0 HMASTLOCK signal
    wire        active0;    // Port 0 Active signal
    wire        held_tran0;  // Port 0 HeldTran signal
    wire        readyout0;  // Port 0 Readyout signal
    wire        resp0;      // Port 0 response

// Bus-switch input 1
    wire        sel1;       // Port 1 HSEL signal
    wire [31:0] addr1;      // Port 1 HADDR signal
    wire  [1:0] trans1;     // Port 1 HTRANS signal
    wire        write1;     // Port 1 HWRITE signal
    wire  [2:0] size1;      // Port 1 HSIZE signal
    wire  [2:0] burst1;     // Port 1 HBURST signal
    wire  [3:0] prot1;      // Port 1 HPROTS signal
    wire  [3:0] master1;    // Port 1 HMASTER signal
    wire        mastlock1;  // Port 1 HMASTLOCK signal
    wire        active1;    // Port 1 Active signal
    wire        held_tran1;  // Port 1 HeldTran signal
    wire        readyout1;  // Port 1 Readyout signal
    wire        resp1;      // Port 1 response

// Bus-switch 0 to 0 signals
    wire        sel0_to_0;    // Port 0 to 0 HSEL signal
    wire        active0_to_0; // Port 0 to 0 Active signal

// Bus-switch 1 to 0 signals
    wire        sel1_to_0;    // Port 1 to 0 HSEL signal
    wire        active1_to_0; // Port 1 to 0 Active signal

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

  input_stage_t u_input_stage_t0
    (
    .hclk          (HCLK),
    .hreset_n      (HRESETn),

    // Input Port Address/Control Signals
    .hsels_i       (1'b1),
    .haddrs_i      (HADDRS0),
    .htranss_i     (HTRANSS0),
    .hwrites_i     (HWRITES0),
    .hsizes_i      (HSIZES0),
    .hbursts_i     (HBURSTS0),
    .hprots_i      (HPROTS0),
    .hmasters_i    (4'b0000),
    .hmastlocks_i  (1'b0),
    .hreadys_i     (HREADYS0),

    // Internal Response
    .active_i      (active0),
    .readyout_i    (readyout0),
    .resp_i        (resp0),

    // Input Port Response
    .hreadyouts_o  (hreadyouts0),
    .hresps_o      (hresps0),

    // Internal Address/Control Signals
    .sel_o         (sel0),
    .addr_o        (addr0),
    .trans_o       (trans0),
    .write_o       (write0),
    .size_o        (size0),
    .burst_o       (burst0),
    .prot_o        (prot0),
    .master_o      (master0),
    .mastlock_o    (mastlock0),
    .held_tran_o   (held_tran0)
    );

  input_stage_t u_input_stage_t1
    (
    .hclk          (HCLK),
    .hreset_n      (HRESETn),

    // Input Port Address/Control Signals
    .hsels_i       (1'b1),
    .haddrs_i      (HADDRS1),
    .htranss_i     (HTRANSS1),
    .hwrites_i     (HWRITES1),
    .hsizes_i      (HSIZES1),
    .hbursts_i     (HBURSTS1),
    .hprots_i      (HPROTS1),
    .hmasters_i    (4'b0000),
    .hmastlocks_i  (1'b0),
    .hreadys_i     (HREADYS1),

    // Internal Response
    .active_i      (active1),
    .readyout_i    (readyout1),
    .resp_i        (resp1),

    // Input Port Response
    .hreadyouts_o  (hreadyouts1),
    .hresps_o      (hresps1),

    // Internal Address/Control Signals
    .sel_o         (sel1),
    .addr_o        (addr1),
    .trans_o       (trans1),
    .write_o       (write1),
    .size_o        (size1),
    .burst_o       (burst1),
    .prot_o        (prot1),
    .master_o      (master1),
    .mastlock_o    (mastlock1),
    .held_tran_o   (held_tran1)
    );

  matrix_decode_t u_matrix_decode_t0
    (
    .hclk          (HCLK),
    .hreset_n      (HRESETn),

    .hreadys_i     (HREADYS0),
    .sel_i         (sel0),
    .addr_i        (addr0),

    // Control/Response for Output Stage 0
    .active0_i     (active0_to_0),
    .readyout0_i   (hreadymuxm0),
    .resp0_i       (HRESPM0),
    .rdata0_i      (HRDATAM0),

    // Select signals
    .sel0_o        (sel0_to_0),

    .active_o      (active0),
    .hreadyouts_o  (readyout0),
    .hresps_o      (resp0),
    .hrdatas_o     (hrdatas0)
    );

  matrix_decode_t u_matrix_decode_t1
    (
    .hclk          (HCLK),
    .hreset_n      (HRESETn),

    .hreadys_i     (HREADYS1),
    .sel_i         (sel1),
    .addr_i        (addr1),

    // Control/Response for Output Stage 0
    .active0_i     (active1_to_0),
    .readyout0_i   (hreadymuxm0),
    .resp0_i       (HRESPM0),
    .rdata0_i      (HRDATAM0),

    .sel0_o        (sel1_to_0),

    .active_o      (active1),
    .hreadyouts_o  (readyout1),
    .hresps_o      (resp1),
    .hrdatas_o     (hrdatas1)
    );

  output_stage_t u_output_stage_t0
    (
    .hclk          (HCLK),
    .hreset_n      (HRESETn),

    // Port 0 Signals
    .sel0_i        (sel0_to_0),
    .addr0_i       (addr0),
    .trans0_i      (trans0),
    .write0_i      (write0),
    .size0_i       (size0),
    .burst0_i      (burst0),
    .prot0_i       (prot0),
    .master0_i     (master0),
    .mastlock0_i   (mastlock0),
    .wdata0_i      (HWDATAS0),
    .held_tran0_i  (held_tran0),

    // Port 1 Signals
    .sel1_i        (sel1_to_0),
    .addr1_i       (addr1),
    .trans1_i      (trans1),
    .write1_i      (write1),
    .size1_i       (size1),
    .burst1_i      (burst1),
    .prot1_i       (prot1),
    .master1_i     (master1),
    .mastlock1_i   (mastlock1),
    .wdata1_i      (HWDATAS1),
    .held_tran1_i  (held_tran1),

    // Slave read data and response
    .hreadyoutm_i  (HREADYOUTM0),

    .active0_o     (active0_to_0),
    .active1_o     (active1_to_0),

    // Slave Address/Control Signals
    .hselm_o       (),
    .haddrm_o      (haddrm0),
    .htransm_o     (htransm0),
    .hwritem_o     (hwritem0),
    .hsizem_o      (hsizem0),
    .hburstm_o     (hburstm0),
    .hprotm_o      (hprotm0),
    .hmasterm_o    (),
    .hmastlockm_o  (),
    .hreadymuxm_o  (hreadymuxm0),
    .hwdatam_o     (hwdatam0)
    );

    // -----------------------------------------------------------------------
    // Output Assignments
    // -----------------------------------------------------------------------

    assign HRDATAS0    = hrdatas0;
    assign HREADYOUTS0 = hreadyouts0;
    assign HRESPS0     = hresps0;

    assign HRDATAS1    = hrdatas1;
    assign HREADYOUTS1 = hreadyouts1;
    assign HRESPS1     = hresps1;

    // Output Port 0
    assign HADDRM0     = haddrm0;
    assign HTRANSM0    = htransm0;
    assign HWRITEM0    = hwritem0;
    assign HSIZEM0     = hsizem0;
    assign HBURSTM0    = hburstm0;
    assign HPROTM0     = hprotm0;
    assign HWDATAM0    = hwdatam0;
    assign HREADYMUXM0 = hreadymuxm0;

endmodule

module input_stage_t (
    hclk,
    hreset_n,
// Input Port Address/Control Signals
    hsels_i,
    haddrs_i,
    htranss_i,
    hwrites_i,
    hsizes_i,
    hbursts_i,
    hprots_i,
    hmasters_i,
    hmastlocks_i,
    hreadys_i,

// Internal Response
    active_i,
    readyout_i,
    resp_i,

// Input Port Response
    hreadyouts_o,
    hresps_o,

// Internal Address/Control Signals
    sel_o,
    addr_o,
    trans_o,
    write_o,
    size_o,
    burst_o,
    prot_o,
    master_o,
    mastlock_o,
    held_tran_o
    );

    input         hclk;              // AHB System Clock
    input         hreset_n;          // AHB System Reset
    input         hsels_i;           // Slave Select from AHB
    input  [31:0] haddrs_i;          // Address bus from AHB
    input   [1:0] htranss_i;         // Transfer type from AHB
    input         hwrites_i;         // Transfer direction from AHB
    input   [2:0] hsizes_i;          // Transfer size from AHB
    input   [2:0] hbursts_i;         // Burst type from AHB
    input   [3:0] hprots_i;          // Protection control from AHB
    input   [3:0] hmasters_i;        // Master number from AHB
    input         hmastlocks_i;      // Locked Sequence  from AHB
    input         hreadys_i;         // Transfer done from AHB
    input         active_i;          // Active signal
    input         readyout_i;        // HREADYOUT input
    input         resp_i;            // HRESP input

    output        hreadyouts_o;      // HREADY feedback to AHB
    output        hresps_o;          // Transfer response to AHB
    output        sel_o;             // HSEL output
    output [31:0] addr_o;            // HADDR output
    output  [1:0] trans_o;           // HTRANS output
    output        write_o;           // HWRITE output
    output  [2:0] size_o;            // HSIZE output
    output  [2:0] burst_o;           // HBURST output
    output  [3:0] prot_o;            // HPROT output
    output [3:0]  master_o;          // HMASTER output
    output        mastlock_o;        // HMASTLOCK output
    output        held_tran_o;       // Holding register active flag

//------------------------------------------------------------------------------
// Wire declaration
//------------------------------------------------------------------------------

    reg         hreadyouts;      // HREADY feedback to AHB
    reg         hresps;          // Transfer response to AHB
    reg         sel;             // HSEL output
    reg  [31:0] addr;            // HADDR output
    wire  [1:0] trans;           // HTRANS output
    reg         write;           // HWRITE output
    reg   [2:0] size;            // HSIZE output
    wire  [2:0] burst;           // HBURST output
    reg   [3:0] prot;            // HPROT output
    reg   [3:0] master;          // HMASTER output
    reg         mastlock;        // HMASTLOCK output
    wire        held_tran;       // Holding register active flag

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

// HTRANS transfer type signal encoding
`define FM_TRN_IDLE    2'b00     // Idle Transfer
`define FM_TRN_BUSY    2'b01     // Busy Transfer
`define FM_TRN_NONSEQ  2'b10     // Nonsequential transfer
`define FM_TRN_SEQ     2'b11     // Sequential transfer

// HSIZE transfer type signal encoding
`define FM_SZ_BYTE     3'b000    // 8-bit
`define FM_SZ_HALF     3'b001    // 16-bit
`define FM_SZ_WORD     3'b010    // 32-bit

// HBURST transfer type signal encoding
`define FM_BUR_SINGLE  3'b000    // Single BURST
`define FM_BUR_INCR    3'b001    // Incremental BURSTS
`define FM_BUR_WRAP4   3'b010    // 4-beat wrap
`define FM_BUR_INCR4   3'b011    // 4-beat incr
`define FM_BUR_WRAP8   3'b100    // 8-beat wrap
`define FM_BUR_INCR8   3'b101    // 8-beat incr
`define FM_BUR_WRAP16  3'b110    // 16-beat wrap
`define FM_BUR_INCR16  3'b111    // 16-beat incr

//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
    wire        load_reg;             // Holding register load flag
    wire        pend_tran;            // An active transfer cannot complete
    reg         pend_tran_reg;        // Registered version of PendTran
    wire        addr_valid;           // Indicates address phase of
                                      // valid transfer
    reg         data_valid;           // Indicates data phase of
                                      // valid transfer
    reg   [1:0] reg_trans;            // Registered HTRANSS
    reg  [31:0] reg_addr;             // Registered HADDRS
    reg         reg_write;            // Registered HWRITES
    reg   [2:0] reg_size;             // Registered HSIZES
    reg   [2:0] reg_burst;            // Registered HBURSTS
    reg   [3:0] reg_prot;             // Registered HPROTS
    reg   [3:0] reg_master;           // Registerd HMASTERS
    reg         reg_mastlock;         // Registered HMASTLOCKS
    reg   [1:0] trans_b;              // HTRANS output used for burst information
    reg   [1:0] trans_int;            // HTRANS output
    reg   [2:0] burst_int;            // HBURST output
    reg   [3:0] offset_addr;          // Address offset for boundary logic
    reg   [3:0] check_addr;           // Address check for wrapped bursts
    reg         burst_override;       // Registered BurstOverrideNext
    wire        next_burst_override;  // Indicates burst has been over-ridden
    reg         bound;                // Registered version of BoundNext
    wire        next_bound;           // Indicates boundary wrapping
    wire        bound_en;             // Clock-enable for Bound register

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Holding Registers
//------------------------------------------------------------------------------
// Each input port has a holding register associated with it and a mux to
//  select between the register and the direct input path. The control of
//  the mux is done simply by selecting the holding register when it is loaded
//  with a pending transfer, otherwise the straight through path is used.

  always @ (posedge hclk or negedge hreset_n)
  begin : p_holding_reg_seq1
    if  ( hreset_n ==1'b0 )
    begin
      reg_trans    <= 2'b00;
      reg_addr     <= {32{1'b0}};
      reg_write    <= 1'b0 ;
      reg_size     <= 3'b000;
      reg_burst    <= 3'b000;
      reg_prot     <= {4{1'b0}};
      reg_master   <= 4'b0000;
      reg_mastlock <= 1'b0 ;
    end
    else
    begin
      if  (load_reg)
      begin
        reg_trans    <= htranss_i;
        reg_addr     <= haddrs_i;
        reg_write    <= hwrites_i;
        reg_size     <= hsizes_i;
        reg_burst    <= hbursts_i;
        reg_prot     <= hprots_i;
        reg_master   <= hmasters_i;
        reg_mastlock <= hmastlocks_i;
      end
    end
  end

  // AddrValid indicates the address phase of an active (non-BUSY/IDLE)
  // transfer to this slave port
  assign addr_valid = (hsels_i & htranss_i[1]);

  // The holding register is loaded whenever there is a transfer on the input
  // port which is validated by active HREADYS
  assign load_reg = (addr_valid & hreadys_i);

  // DataValid register
  // AddrValid indicates the data phase of an active (non-BUSY/IDLE)
  // transfer to this slave port. A valid response (HREADY, HRESP) must be
  // generated
  always @ (posedge hclk or negedge hreset_n)
  begin : p_data_valid
    if  (hreset_n == 1'b0)
      data_valid <= 1'b0;
    else
    begin
     if (hreadys_i)
      data_valid  <= addr_valid;
    end
  end

//------------------------------------------------------------------------------
// Generate HeldTran
//------------------------------------------------------------------------------
// The HeldTran signal is used to indicate when there is an active transfer
// being presented to the output stage, either passing straight through or from
// the holding register.

  // PendTran indicates that an active transfer presented to this
  // slave cannot complete immediately.  It is always set after the
  // LoadReg signal has been active. When set, it is cleared when the
  // transfer is being driven onto the selected slave (as indicated by
  // Active being high) and HREADY from the selected slave is high.
  assign pend_tran = (load_reg & (!active_i)) ? 1'b1 :
                    ((active_i & readyout_i) ? 1'b0 : pend_tran_reg);

  // PendTranReg indicates that an active transfer was accepted by the input
  // stage,but not by the output stage, and so the holding registers should be
  // used
  always @ (posedge hclk or negedge hreset_n)
  begin : p_pend_tran_reg
    if (hreset_n == 1'b0)
     pend_tran_reg  <= 1'b0;
    else
     pend_tran_reg  <= pend_tran;
  end

  // HeldTran indicates an active transfer, and is held whilst that transfer is
  // in the holding registers.  It passes to the output stage where it acts as
  // a request line to the arbitration scheme
  assign  held_tran  = (load_reg | pend_tran_reg);

// The output from this stage is selected from the holding register when
//  there is a held transfer. Otherwise the direct path is used.

  always @ (pend_tran_reg or hsels_i or htranss_i or haddrs_i or hwrites_i
            or hsizes_i or hbursts_i or hprots_i or hmastlocks_i or reg_addr
            or reg_write or reg_size or reg_burst or reg_prot or reg_mastlock or
            hmasters_i or reg_master)
  begin : p_mux_comb
    if  ( pend_tran_reg ==1'b0 )
    begin
      sel       = hsels_i;
      trans_int = htranss_i;
      addr      = haddrs_i;
      write     = hwrites_i;
      size      = hsizes_i;
      burst_int = hbursts_i;
      prot      = hprots_i;
      master    = hmasters_i;
      mastlock  = hmastlocks_i;
    end
    else
    begin
      sel       = 1'b1;
      trans_int = `FM_TRN_NONSEQ;
      addr      = reg_addr;
      write     = reg_write;
      size      = reg_size;
      burst_int = reg_burst;
      prot      = reg_prot;
      master    = reg_master;
      mastlock  = reg_mastlock;
    end
  end

// The Transb output is used to select the correct Burst value when completing
// an interrupted defined-lenght burst.

  always @ (pend_tran_reg or htranss_i or reg_trans)
  begin : p_trans_b_comb
    if  ( pend_tran_reg ==1'b0 )
      trans_b = htranss_i;
    else
      trans_b = reg_trans;
  end // block: p_TransbComb


  // Convert SEQ->NONSEQ and BUSY->IDLE when an address boundary is crossed
  // whilst the burst type is being over-ridden, i.e. when completing an
  // interrupted wrapping burst.
  assign trans  = (burst_override & bound) ? {trans_int[1], 1'b0}
                : trans_int;

  assign burst  = (burst_override & (trans_b != `FM_TRN_NONSEQ)) ? `FM_BUR_INCR
                : burst_int;

//------------------------------------------------------------------------------
// HREADYOUT Generation
//------------------------------------------------------------------------------
// There are three possible sources for the HREADYOUT signal.
//  - It is driven LOW when there is a held transfer.
//  - It is driven HIGH when not Selected or for Idle/Busy transfers.
//  - At all other times it is driven from the appropriate shared
//    slave.

  always @ (data_valid or pend_tran_reg or readyout_i or resp_i)
  begin : p_ready_comb
    if  (data_valid == 1'b0)
      begin
        hreadyouts = 1'b1;
        hresps     = 1'b0;
      end
    else if (pend_tran_reg)
      begin
        hreadyouts = 1'b0;
        hresps     = 1'b0;
      end
    else
      begin
        hreadyouts = readyout_i;
        hresps     = resp_i;
      end
  end // block: p_ReadyComb

//------------------------------------------------------------------------------
// Early Burst Termination
//------------------------------------------------------------------------------
// There are times when the output stage will switch to another input port
//  without allowing the current burst to complete. In these cases the HTRANS
//  and HBURST signals need to be overriden to ensure that the transfers
//  reaching the output port meet the AHB specification.

  assign next_burst_override  = ((htranss_i == `FM_TRN_NONSEQ) |
                               (htranss_i == `FM_TRN_IDLE)) ? 1'b0
                              : (((load_reg == 1'b1) &&
                                  (active_i == 1'b0) &&
                                  (htranss_i ==`FM_TRN_SEQ)) ? 1'b1
                                 : burst_override) ;

  // BurstOverride register
  always @ (posedge hclk or negedge hreset_n)
  begin : p_burst_override_seq
    if  ( hreset_n ==1'b0 )
      burst_override  <= 1'b0 ;
    else
      begin
        if (hreadys_i)
          burst_override  <= next_burst_override ;
      end
  end // block: p_BurstOverrideSeq

//------------------------------------------------------------------------------
// Boundary Checking Logic
//------------------------------------------------------------------------------
  // OffsetAddr
  always @ (haddrs_i or hsizes_i)
  begin : p_offset_addr_comb
    case (hsizes_i )
      3'b000:  offset_addr  = haddrs_i[3:0];
      3'b001:  offset_addr  = haddrs_i[4:1];
      3'b010:  offset_addr  = haddrs_i[5:2];
      3'b011:  offset_addr  = haddrs_i[6:3];
      default: offset_addr  = haddrs_i[3:0];
    endcase
  end

  // CheckAddr
  always @ (offset_addr or hbursts_i)
  begin : p_check_addr_comb
    case (hbursts_i )
      `FM_BUR_WRAP4 : begin
        check_addr[1:0] = offset_addr[1:0];
        check_addr[3:2] = 2'b11;
      end

      `FM_BUR_WRAP8 : begin
        check_addr[2:0] = offset_addr[2:0];
        check_addr[3]   = 1'b1 ;
      end

      `FM_BUR_WRAP16 : begin
        check_addr[3:0] = offset_addr[3:0];
      end

      default: begin
        check_addr[3:0] = 4'b0000;
      end
    endcase
  end

  assign next_bound  = (check_addr == 4'b1111) ? 1'b1 : 1'b0;

  assign bound_en  = ((htranss_i [1]) & hreadys_i) ? 1'b1 : 1'b0;

  // Bound register
  always @ (posedge hclk or negedge hreset_n)
  begin : p_bound_seq
    if  ( hreset_n ==1'b0 )
      bound  <= 1'b0 ;
    else
    begin
      if  (bound_en)
        bound  <= next_bound ;
    end
  end

  // output assignments
  assign hreadyouts_o  = hreadyouts;
  assign hresps_o      = hresps;
  assign sel_o         = sel;
  assign addr_o        = addr;
  assign trans_o       = trans;
  assign write_o       = write;
  assign size_o        = size;
  assign burst_o       = burst;
  assign prot_o        = prot;
  assign master_o      = master;
  assign mastlock_o    = mastlock;
  assign held_tran_o   = held_tran;

endmodule

module matrix_decode_t (
    hclk,
    hreset_n,

    hreadys_i,
    sel_i,
    addr_i,

    // Bus-switch output 0
    active0_i,
    readyout0_i,
    resp0_i,
    rdata0_i,

    sel0_o,

    active_o,
    hreadyouts_o,
    hresps_o,
    hrdatas_o
    );

    input         hclk;             // AHB System Clock
    input         hreset_n;         // AHB System Reset
    input         hreadys_i;        // Transfer done
    input         sel_i;            // HSEL input
    input [31:0]  addr_i;           // HADDR input

    // Bus-switch output 0
    input         active0_i;        // O/P stage0 Active signal
    input         readyout0_i;      // HREADYOUT input
    input         resp0_i;          // HRESP input
    input  [31:0] rdata0_i;         // HRDATA input

    output        sel0_o;           // HSEL output

    output        active_o;         // Combinatorial Active O/P
    output        hreadyouts_o;     // HREADY feedback output
    output        hresps_o;         // Transfer response
    output [31:0] hrdatas_o;        // Read Data

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------

    reg           sel0;             // HSEL output

    reg           active;           // Combinatorial Active O/P signal
    reg           hreadyouts;       // Combinatorial HREADYOUT signal
    reg           hresps;           // Combinatorial HRESPS signal
    reg    [31:0] hrdatas;          // Read data bus

    reg     [3:0] addr_out_port;    // Address output ports
    reg     [3:0] data_out_port;    // Data output ports

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Address phase signals
//------------------------------------------------------------------------------
// The address decode is done in two stages. This is so that the address
//  decode occurs in only one process, p_AddrOutPortComb, and then the select
//  signal is factored in.
  always @ (addr_i)
    begin : p_addr_out_port_comb
      case (addr_i [27:24])

        // Bus-switch output 0
        4'b0000 : addr_out_port = 4'b0000;
        default : addr_out_port = 4'b0000;
      endcase // case(Addr [27:24])
    end // block: p_AddrOutPortComb


  // Select signal decode
  always @ (sel_i or addr_out_port)
    begin : p_sel_comb
      sel0  = 1'b0 ;
      if  (sel_i)
      begin
        case (addr_out_port)
          4'b0000 : sel0  = 1'b1 ;
          default: begin
          end
        endcase // case(AddrOutPort)
      end // if (Sel)
    end // block: p_SelComb

// The decoder selects the appropriate Active signal depending on which
//  output stage is required for the transfer.
  always @ (active0_i or
            addr_out_port)
    begin : p_active_comb
      case (addr_out_port )

        4'b0000 : active  = active0_i ;
        default : active  = active0_i ;
      endcase // case(AddrOutPort )
    end // block: p_ActiveComb

//------------------------------------------------------------------------------
// Data phase signals
//------------------------------------------------------------------------------
// The DataOutPort needs to be updated when HREADY from the input stage is high.
//  Note: HREADY must be used, not HREADYOUT, because there are occaisions
//  (namely when the holding register gets loaded) when HREADYOUT may be low
//  but HREADY is high, and in this case it is important that the DataOutPort
//  gets updated.
  always @ (posedge hclk or negedge hreset_n)
    begin : p_data_out_port_seq
      if  (hreset_n == 1'b0)
        data_out_port  <= 4'b0000;
      else
        begin
          if  (hreadys_i)
            data_out_port  <= addr_out_port ;
        end
    end // block: p_DataOutPortSeq

  // HREADYOUTS output decode
  always @ (readyout0_i or
            data_out_port)
  begin : p_ready_comb
    case (data_out_port)

      4'b0000 : hreadyouts  = readyout0_i ;
      default : hreadyouts  = readyout0_i;
    endcase // case(DataOutPort)
  end // block: p_ReadyComb


  // HRESPS output decode
  always @ (resp0_i or
            data_out_port)
  begin : p_resp_comb
    case (data_out_port)
      4'b0000 : hresps  = resp0_i ;
      default: hresps  = resp0_i;
    endcase // case(DataOutPort)
  end // block: p_RespComb

  // HRDATAS output decode
  always @ (rdata0_i or
            data_out_port)
  begin : p_rdata_comb
    case (data_out_port )

      4'b0000 : hrdatas  = rdata0_i ;
      default : hrdatas  = rdata0_i ;
    endcase // case(DataOutPort )
  end // block: p_RdataComb

  // output assignments
  assign sel0_o        = sel0;
  assign active_o      = active;
  assign hreadyouts_o  = hreadyouts;
  assign hresps_o      = hresps;
  assign hrdatas_o     = hrdatas;

endmodule

module output_stage_t (
    hclk,
    hreset_n,

    // Port 0 Signals
    sel0_i,
    addr0_i,
    trans0_i,
    write0_i,
    size0_i,
    burst0_i,
    prot0_i,
    master0_i,
    mastlock0_i,
    wdata0_i,
    held_tran0_i,

    // Port 1 Signals
    sel1_i,
    addr1_i,
    trans1_i,
    write1_i,
    size1_i,
    burst1_i,
    prot1_i,
    master1_i,
    mastlock1_i,
    wdata1_i,
    held_tran1_i,

    // Slave read data and response0
    hreadyoutm_i,

    active0_o,
    active1_o,

    // Slave Address/Control Signals
    hselm_o,
    haddrm_o,
    htransm_o,
    hwritem_o,
    hsizem_o,
    hburstm_o,
    hprotm_o,
    hmasterm_o,
    hmastlockm_o,
    hreadymuxm_o,
    hwdatam_o
    );


    input         hclk;       // AHB system clock
    input         hreset_n;    // AHB system reset

    // Bus-switch input 0
    input         sel0_i;       // Port 0 HSEL signal
    input [31:0]  addr0_i;      // Port 0 HADDR signal
    input  [1:0]  trans0_i;     // Port 0 HTRANS signal
    input         write0_i;     // Port 0 HWRITE signal
    input  [2:0]  size0_i;      // Port 0 HSIZE signal
    input  [2:0]  burst0_i;     // Port 0 HBURST signal
    input  [3:0]  prot0_i;      // Port 0 HPROT signal
    input  [3:0]  master0_i;    // Port 0 HMASTER signal
    input         mastlock0_i;  // Port 0 HMASTLOCK signal
    input [31:0]  wdata0_i;     // Port 0 HWDATA signal
    input         held_tran0_i; // Port 0 HeldTran signal

// Bus-switch input 1
    input         sel1_i;       // Port 1 HSEL signal
    input [31:0]  addr1_i;      // Port 1 HADDR signal
    input  [1:0]  trans1_i;     // Port 1 HTRANS signal
    input         write1_i;     // Port 1 HWRITE signal
    input  [2:0]  size1_i;      // Port 1 HSIZE signal
    input  [2:0]  burst1_i;     // Port 1 HBURST signal
    input  [3:0]  prot1_i;      //  Port 1 HPROT signal
    input  [3:0]  master1_i;    // Port 1 HMASTER signal
    input         mastlock1_i;  // Port 1 HMASTLOCK signal
    input [31:0]  wdata1_i;     // Port 1 HWDATA signal
    input         held_tran1_i; // Port 1 HeldTran signal

    input         hreadyoutm_i; // HREADY feedback

    output        active0_o;    // Port 0 Active signal
    output        active1_o;    // Port 1 Active signal

    // Slave Address/Control Signals
    output        hselm_o;      // Slave select line
    output [31:0] haddrm_o;     // Address
    output  [1:0] htransm_o;    // Transfer type
    output        hwritem_o;    // Transfer direction
    output  [2:0] hsizem_o;     // Transfer size
    output  [2:0] hburstm_o;    // Burst type
    output  [3:0] hprotm_o;     // Protection control
    output  [3:0] hmasterm_o;   // Master ID
    output        hmastlockm_o; // Locked transfer
    output        hreadymuxm_o; // Transfer done
    output [31:0] hwdatam_o;    // Write data

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------

    reg         active0;    // Port 0 Active signal

    reg         active1;    // Port 1 Active signal

    // Slave Address/Control Signals
    reg  [31:0] haddrm;     // Address
    reg         hwritem;    // Transfer direction
    reg   [2:0] hsizem;     // Transfer size
    reg   [3:0] hprotm;     // Protection control
    reg   [3:0] hmasterm;   // Master ID
    reg  [31:0] hwdatam;    // Write data

//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------

    wire        req_port0;      // Port 0 request signal
    wire        req_port1;      // Port 1 request signal

    wire  [3:0] addr_in_port;   // Address input port
    reg   [3:0] data_in_port;   // Data input port
    wire        no_port;        // No port selected signal
    reg         slave_sel;      // Slave select signal

    reg         hsel_lock;      //  Held HSELS during locked sequence
    wire        next_hsel_lock; //  Pre-registered HselLock
    wire        hlock_arb;      //  HMASTLOCK modified by HSEL for arbitration

    reg         hselm;      // internal HSELM
    reg   [1:0] htransm;    // internal HTRANSM
    reg   [2:0] hburstm;    // internal HBURSTM
    reg         hreadymuxm; // internal HREADYMUXM
    reg         hmastlockm; // internal HMASTLOCKM

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Port Selection
//------------------------------------------------------------------------------

  assign req_port0  = (held_tran0_i & sel0_i) ? 1'b1 : 1'b0 ;
  assign req_port1  = (held_tran1_i & sel1_i) ? 1'b1 : 1'b0 ;

  output_arb_t  u_output_arb
        (
        .hclk           (hclk),
        .hreset_n       (hreset_n),
        .req_port0_i    (req_port0),
        .req_port1_i    (req_port1),
        .hreadym_i      (hreadymuxm),
        .hselm_i        (hselm),
        .htransm_i      (htransm),
        .hburstm_i      (hburstm),
        .hmastlockm_i   (hlock_arb),

        .addr_in_port_o (addr_in_port),
        .no_port_o      (no_port)
        );

  // Active signal combinatorial decode
  always @ (addr_in_port or no_port)
  begin : p_active_comb
    // Default values
    active0  = 1'b0 ;
    active1  = 1'b0 ;
    if  ( no_port ==1'b0 )
    begin
      case (addr_in_port )
        4'b0000 : active0  = 1'b1 ;
        4'b0001 : active1  = 1'b1 ;
        default : begin
        end
      endcase // case(AddrInPort )
    end
  end // block: p_ActiveComb


  //  Address/control output decode
  always @(sel0_i or addr0_i or trans0_i or write0_i or size0_i or burst0_i or prot0_i or
           master0_i or mastlock0_i or
         sel1_i or addr1_i or trans1_i or write1_i or size1_i or burst1_i or prot1_i or
           master1_i or mastlock1_i or
            addr_in_port or no_port)
  begin : p_addr_mux
    if  ( no_port )
      begin
        hselm      = 1'b0 ;
        haddrm     = {32{1'b0}};
        htransm    = {2{1'b0}};
        hwritem    = 1'b0 ;
        hsizem     = {3{1'b0}};
        hburstm    = {3{1'b0}};
        hprotm     = {4{1'b0}};
        hmasterm   = {4{1'b0}};
        hmastlockm = 1'b0 ;
      end
    else
      begin
        case (addr_in_port)

          // Bus-switch input 0
          4'b0000 :
            begin
              hselm      = sel0_i ;
              haddrm     = addr0_i ;
              htransm    = trans0_i ;
              hwritem    = write0_i ;
              hsizem     = size0_i ;
              hburstm    = burst0_i ;
              hprotm     = prot0_i ;
              hmasterm   = master0_i;
              hmastlockm = mastlock0_i ;
            end // case: 4'b0000

          // Bus-switch input 1
          4'b0001 :
            begin
              hselm      = sel1_i;
              haddrm     = addr1_i;
              htransm    = trans1_i;
              hwritem    = write1_i;
              hsizem     = size1_i;
              hburstm    = burst1_i;
              hprotm     = prot1_i;
              hmasterm   = master1_i;
              hmastlockm = mastlock1_i;
            end // case: 4'b0001

          default :
            begin
              hselm      = sel0_i ;
              haddrm     = addr0_i ;
              htransm    = trans0_i ;
              hwritem    = write0_i ;
              hsizem     = size0_i ;
              hburstm    = burst0_i ;
              hprotm     = prot0_i ;
              hmasterm   = master0_i;
              hmastlockm = mastlock0_i ;
            end // case: default
        endcase // case(AddrInPort)
      end // else: !if( NoPort )
  end // block: p_AddrMux

  // HselLock provides support for AHB masters that address other
  // slave regions in the middle of a locked sequence (i.e. HSEL is
  // de-asserted during the locked sequence).  Unless HMASTLOCK is
  // held during these intermediate cycles, the OutputArb scheme will
  // lose track of the locked sequence and may allow another input port to
  // access the output port which should be locked.
  assign next_hsel_lock = ((hselm & htransm[1] & hmastlockm) ? 1'b1
                         : ((hmastlockm == 1'b0) ? 1'b0
                            : hsel_lock));

  // Register HselLock
  always @ (posedge hclk or negedge hreset_n)
    begin : p_hsel_lock
      if (hreset_n == 1'b0)
        begin
          hsel_lock <= 1'b0;
        end
      else
        begin
          if (hreadymuxm)
            begin
              hsel_lock <= next_hsel_lock;
            end
        end
    end

  // Version of HMASTLOCK which is masked when not selected, unless a
  // locked sequence has already begun through this port
  assign hlock_arb = hmastlockm & (hsel_lock | hselm);

  // Dataport register
  always @ (posedge hclk or negedge hreset_n)
  begin : p_data_in_port_reg
    if  (hreset_n == 1'b0)
     data_in_port  <= 4'b0000;
    else
      begin
        if  (hreadymuxm)
          data_in_port <= addr_in_port ;
      end // else: !if(HRESETn == 1'b0)
  end // block: p_DataInPortReg

  // HWDATAM output decode
  always @ (wdata0_i or
            wdata1_i or
            data_in_port)
  begin : p_data_mux
    case (data_in_port)
      4'b0000 : hwdatam  = wdata0_i ;
      4'b0001 : hwdatam  = wdata1_i;
      default : hwdatam  = wdata0_i ;
    endcase // case(DataInPort )
  end // block: p_DataMux


//------------------------------------------------------------------------------
// HREADYMUXM generation
//------------------------------------------------------------------------------
// The HREADY signal on the shared slave is generated directly from
//  the shared slave HREADYOUTS if the slave is selected, otherwise
//  it mirrors the HREADY signal of the appropriate input port.
//  it is driven HIGH.
  always @ (posedge hclk or negedge hreset_n)
  begin : p_slave_sel_reg
    if  ( hreset_n ==1'b0 )
      slave_sel  <= 1'b0 ;
    else
    begin
      if  ( hreadymuxm )
        slave_sel  <= hselm ;
    end
  end

  // HREADYMUXM output decode
  always @ (slave_sel or hreadyoutm_i)
  begin : p_hreadys_comb
    if  ( slave_sel )
      hreadymuxm  = hreadyoutm_i ;
    else
      hreadymuxm  = 1'b1 ;
  end

  assign active0_o     = active0;
  assign active1_o     = active1;

    // Slave Address/Control Signals
  assign hselm_o       = hselm;
  assign haddrm_o      = haddrm;
  assign htransm_o     = htransm;
  assign hwritem_o     = hwritem;
  assign hsizem_o      = hsizem;
  assign hburstm_o     = hburstm;
  assign hprotm_o      = hprotm;
  assign hmasterm_o    = hmasterm;
  assign hmastlockm_o  = hmastlockm;
  assign hreadymuxm_o  = hreadymuxm;
  assign hwdatam_o     = hwdatam;

endmodule

module output_arb_t (
    hclk ,
    hreset_n,

    req_port0_i,
    req_port1_i,

    hreadym_i,
    hselm_i,
    htransm_i,
    hburstm_i,
    hmastlockm_i,
    addr_in_port_o,
    no_port_o
    );

    input        hclk;           // AHB system clock
    input        hreset_n;       // AHB system reset
    input        req_port0_i;    // Port 0 request signal
    input        req_port1_i;    // Port 1 request signal
    input        hreadym_i;      // Transfer done
    input        hselm_i;        // Slave select line
    input  [1:0] htransm_i;      // Transfer type
    input  [2:0] hburstm_i;      // Burst type
    input        hmastlockm_i;   // Locked transfer
    output [3:0] addr_in_port_o; // Port address input
    output       no_port_o;      // No port selected signal

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
  assign  addr_in_port_o = {3'b000,req_port1_i & ~req_port0_i};
  assign  no_port_o      = ~hreadym_i | (~req_port0_i & ~req_port1_i);

endmodule
