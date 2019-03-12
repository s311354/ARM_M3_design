//------------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2004-2017 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//  Revision            : $Revision: 366206 $
//  Release information : CM3DesignStart-r0p0-02rel0
//
//------------------------------------------------------------------------------
// Purpose: CORTEX-M3 DesignStart Eval Integration Level
//
//          Pre-obfuscation view of integrastion level. When used with the
//          DSM, an additional wrapper is required _above_ this level
//          to handle the additional visibility signals which are exposed
//          The obfuscated code view presents an equivalent of this level
//          in cortexm3ds_logic.
//------------------------------------------------------------------------------

`ifdef ARM_DSM
module CORTEXM3INTEGRATIONDS_dsm
`else
module CORTEXM3INTEGRATIONDS
`endif
  (
   // Inputs
   ISOLATEn, RETAINn, nTRST, SWCLKTCK, SWDITMS, TDI, PORESETn, SYSRESETn,
   RSTBYPASS, CGBYPASS, FCLK, HCLK, TRACECLKIN, STCLK, STCALIB, AUXFAULT, BIGEND,
   INTISR, INTNMI, HREADYI, HRDATAI, HRESPI, IFLUSH, HREADYD, HRDATAD, HRESPD,
   EXRESPD, SE, HREADYS, HRDATAS, HRESPS, EXRESPS, EDBGRQ, DBGRESTART, RXEV,
   SLEEPHOLDREQn, WICENREQ, FIXMASTERTYPE, TSVALUEB, MPUDISABLE,
   DBGEN, NIDEN, CDBGPWRUPACK, DNOTITRANS,
   // Outputs
   TDO, nTDOEN, SWDOEN, SWDO, SWV, JTAGNSW, TRACECLK, TRACEDATA, HTRANSI,
   HSIZEI, HADDRI, HBURSTI, HPROTI, MEMATTRI, HTRANSD, HSIZED, HADDRD, HBURSTD,
   HPROTD, MEMATTRD, HMASTERD, EXREQD, HWRITED, HWDATAD, HTRANSS, HSIZES,
   HADDRS, HBURSTS, HPROTS, MEMATTRS, HMASTERS, EXREQS, HWRITES, HWDATAS,
   HMASTLOCKS, BRCHSTAT, HALTED, LOCKUP, SLEEPING, SLEEPDEEP, ETMINTNUM,
   ETMINTSTAT, SYSRESETREQ, TXEV, TRCENA, CURRPRI, DBGRESTARTED, SLEEPHOLDACKn,
   GATEHCLK, HTMDHADDR, HTMDHTRANS, HTMDHSIZE, HTMDHBURST,
   HTMDHPROT, HTMDHWDATA, HTMDHWRITE, HTMDHRDATA, HTMDHREADY, HTMDHRESP,
   WICENACK, WAKEUP, CDBGPWRUPREQ

  );

  //----------------------------------------------------------------------------
  // Parameters
  //
  //   The user-configurable parameters are as follows, and are declared in the
  //   order given.
  //
  //   1. MPU_PRESENT
  //
  //        MPU present or not.  Set to 1 to include the MPU, or 0 to exclude
  //        the MPU.
  //
  //        Valid values:  0, 1
  //        Default value: 1
  //
  //
  //   2. NUM_IRQ
  //
  //        Number of interrupts.
  //
  //        Valid values:  1 to 240
  //        Default value: 16
  //
  //
  //   3. LVL_WIDTH
  //
  //        Interrupt priority width.
  //
  //        Valid values:  3 to 8
  //        Default value: 3
  //
  //
  //   4. TRACE_LVL
  //
  //        Trace support level.
  //
  //        Valid values:
  //          0 => No trace. No ETM, ITM or DWT triggers and
  //               counters.
  //          1 => Standard trace. ITM and DWT triggers and
  //               counters, but no ETM.
  //          2 => Full trace. Standard trace plus ETM.
  //          3 => Full trace plus HTM port.
  //
  //          This parameter does not affect watchpoints, and
  //          must be 0 if DBG_LEVEL is 0.
  //
  //        Default value: 1
  //
  //
  //   5. DEBUG_LVL
  //
  //        Debug support level.
  //
  //        Valid values:
  //          0 => No debug.  No DAP, breakpoints,
  //               watchpoints, flash patch or halting debug.
  //          1 => Minimum debug.  2 breakpoints,
  //               1 watchpoint, no flash patch.
  //          2 => Full debug minus DWT data matching.
  //          3 => Full debug plus DWT data matching.
  //
  //          When DBG_LEVEL = 1, only one comparator is
  //          implemented in the DWT and this therefore only
  //          allows one watchpoint but also only one trigger
  //          for trace.
  //
  //          Halting debug includes halt, step, MASKINTS,
  //          SNAPSTALL, DbgTmp register and associated
  //          transfer logic and vector catch.
  //
  //          DBG_LEVEL < 3 removes the DATAVADDR0,
  //          DATAVADDR1, DATAVSIZE and DATAVMATCH registers
  //          which are present in the DWT Function
  //          Register 1.
  //
  //        Default value: 3
  //
  //
  //   6. JTAG_PRESENT
  //
  //        JTAG-DP inclusion.  Set to 1 to include the JTAG-DP, or to zero to
  //        exclude the JTAG-DP.  The SW-DP is always included.
  //
  //        Valid values:  0, 1
  //        Default value: 1
  //
  //
  //   7. CLKGATE_PRESENT
  //
  //        Architectural clock gating instantiated.  Set to 1 to include, or 0
  //        to not.
  //
  //        Valid values:  0, 1
  //        Default value: 0
  //
  //
  //   8. RESET_ALL_REGS
  //
  //        Reset all registers.  Set to 1 to apply reset to all registers, even
  //        if not functionally required.
  //
  //        Valid values:  0, 1
  //        Default value: 0
  //
  //   9. OBSERVATION
  //
  //        Allows some of the internal control signals to be exported from
  //        within the processor if set to 1.
  //
  //        Valid values:  0, 1
  //        Default value: 0
  //
  //
  //  10. WIC_PRESENT
  //
  //        WIC present or not.  Set to 1 to include the WIC, or 0 to exclude
  //        the WIC.
  //
  //        Valid values:  0, 1
  //        Default value: 0
  //
  //
  //   11. WIC_LINES
  //
  //        Number of available WIC lines.
  //
  //        Valid values:  3 to 243
  //
  //          If 3, WICMASKNMI, WICMASKMON and WICMASKRXEV are
  //          driven.  If more than 3, WICMASKISR is also
  //          driven.
  //
  //        Default value: 3
  //
  //   12. BB_PRESENT
  //
  //        Bit banding present or not.  Set to 1 to include the bit banding
  //        logic, or 0 to exclude it.
  //
  //        Valid values:  0, 1
  //        Default value: 1
  //
  //   13. CONST_AHB_CTRL
  //
  //        Constant AHB control information during wait-stated transfers.
  //        Set to 1 to include the required logic, or 0 to exclude it.
  //        Note: setting CONST_AHB_CTRL decreases performance in wait-stated
  //              systems. Please see the IIM for more information.
  //
  //        Valid values:  0, 1
  //        Default value: 0
  //
  //
  //----------------------------------------------------------------------------

  parameter MPU_PRESENT     = 1;
  parameter NUM_IRQ         = 64;
  parameter LVL_WIDTH       = 3;
  parameter TRACE_LVL       = 3;
  parameter DEBUG_LVL       = 3;
  parameter JTAG_PRESENT    = 1;
  parameter CLKGATE_PRESENT = 0;
  parameter RESET_ALL_REGS  = 0;
  parameter OBSERVATION     = 0;
  parameter WIC_PRESENT     = 1;
  parameter WIC_LINES       = 67;
  parameter BB_PRESENT      = 1;
  parameter CONST_AHB_CTRL  = 1;


  //----------------------------------------------------------------------------
  // Derived parameters
  //
  //   These parameters must not be modified or overridden.
  //----------------------------------------------------------------------------

  parameter DP_PRESENT = DEBUG_LVL > 0 ? 1 : 0;

  //----------------------------------------------------------------------------
  // Port declarations
  //----------------------------------------------------------------------------

  // PMU
  input          ISOLATEn;           // Isolate core power domain
  input          RETAINn;            // Retain core state during power-down - unused

  // Debug
  input          nTRST;              // Test reset
  input          SWDITMS;            // Test Mode Select/SWDIN
  input          SWCLKTCK;           // Test clock / SWCLK
  input          TDI;                // Test Data In
  input          CDBGPWRUPACK;       // Debug power up acknowledge

  // Miscellaneous
  input          PORESETn;           // PowerOn reset
  input          SYSRESETn;          // System reset
  input          RSTBYPASS;          // Reset Bypass
  input          CGBYPASS;           // Architectural clock gate bypass
  input          FCLK;               // Free running clock
  input          HCLK;               // System clock
  input          TRACECLKIN;         // TPIU trace port clock
  input          STCLK;              // System Tick clock
  input   [25:0] STCALIB;            // System Tick calibration
  input   [31:0] AUXFAULT;           // Auxillary FSR pulse inputs
  input          BIGEND;             // Static endianess select

  // Interrupt
  input  [239:0] INTISR;             // Interrupts
  input          INTNMI;             // Non-maskable Interrupt

  // Code (instruction & literal) bus
  input          HREADYI;            // ICode-bus ready
  input   [31:0] HRDATAI;            // ICode-bus read data
  input    [1:0] HRESPI;             // ICode-bus transfer response
  input          IFLUSH;             // ICode-bus buffer flush
  input          HREADYD;            // DCode-bus ready
  input   [31:0] HRDATAD;            // DCode-bus read data
  input    [1:0] HRESPD;             // DCode-bus transfer response
  input          EXRESPD;            // DCode-bus exclusive response

  // System Bus
  input          HREADYS;            // System-bus ready
  input   [31:0] HRDATAS;            // System-bus read data
  input    [1:0] HRESPS;             // System-bus transfer response
  input          EXRESPS;            // System-bus exclusive response

  // Sleep
  input          RXEV;               // Wait for exception input
  input          SLEEPHOLDREQn;      // Hold core in sleep mode

  // External Debug Request
  input          EDBGRQ;             // Debug Request
  input          DBGRESTART;         // External Debug Restart request

  // DAP HMASTER override
  input          FIXMASTERTYPE;      // Override HMASTER for AHB-AP accesses

  // WIC
  input          WICENREQ;           // WIC mode Request from PMU

  // Timestamp intereace
  input [47:0]   TSVALUEB;           // Binary coded timestamp value

  // Scan
  input          SE;                 // Scan Enable

  // Logic disable
  input          MPUDISABLE;         // Disable the MPU (act as default)
  input          DBGEN;              // Enable debug
  input          NIDEN;              // Enable non-invasive debug

  // Tie-High if code mux is used
  input          DNOTITRANS;         // I/DCode arbitration control

  // Debug
  output         TDO;                // Test Data Out
  output         nTDOEN;             // Test Data Out Enable
  output         CDBGPWRUPREQ;       // Debug power up request

  // Single Wire
  output         SWDO;               // SingleWire data out
  output         SWDOEN;             // SingleWire output enable
  output         JTAGNSW;            // JTAG mode(1) or SW mode(0)

  // Single Wire Viewer
  output         SWV;                // SingleWire Viewer Data

  // TracePort Output
  output         TRACECLK;           // TracePort clock reference
  output   [3:0] TRACEDATA;          // TracePort Data

  // HTM data
  output  [31:0] HTMDHADDR;          // HTM data HADDR
  output   [1:0] HTMDHTRANS;         // HTM data HTRANS
  output   [2:0] HTMDHSIZE;          // HTM data HSIZE
  output   [2:0] HTMDHBURST;         // HTM data HBURST
  output   [3:0] HTMDHPROT;          // HTM data HPROT
  output  [31:0] HTMDHWDATA;         // HTM data HWDATA
  output         HTMDHWRITE;         // HTM data HWRITE
  output  [31:0] HTMDHRDATA;         // HTM data HRDATA
  output         HTMDHREADY;         // HTM data HREADY
  output   [1:0] HTMDHRESP;          // HTM data HRESP

  // Code (instruction & literal) bus
  output   [1:0] HTRANSI;            // ICode-bus transfer type
  output   [2:0] HSIZEI;             // ICode-bus transfer size
  output  [31:0] HADDRI;             // ICode-bus address
  output   [2:0] HBURSTI;            // ICode-bus burst length
  output   [3:0] HPROTI;             // ICode-bus protection
  output   [1:0] MEMATTRI;           // ICode-bus memory attributes
  output   [1:0] HMASTERD;           // DCode-bus master
  output   [1:0] HTRANSD;            // DCode-bus transfer type
  output   [2:0] HSIZED;             // DCode-bus transfer size
  output  [31:0] HADDRD;             // DCode-bus address
  output   [2:0] HBURSTD;            // DCode-bus burst length
  output   [3:0] HPROTD;             // DCode-bus protection
  output   [1:0] MEMATTRD;           // ICode-bus memory attributes
  output         EXREQD;             // ICode-bus exclusive request
  output         HWRITED;            // DCode-bus write not read
  output  [31:0] HWDATAD;            // DCode-bus write data

  // System Bus
  output   [1:0] HMASTERS;           // System-bus master
  output   [1:0] HTRANSS;            // System-bus transfer type
  output         HWRITES;            // System-bus write not read
  output   [2:0] HSIZES;             // System-bus transfer size
  output         HMASTLOCKS;         // System-bus lock
  output  [31:0] HADDRS;             // System-bus address
  output  [31:0] HWDATAS;            // System-bus write data
  output   [2:0] HBURSTS;            // System-bus burst length
  output   [3:0] HPROTS;             // System-bus protection
  output   [1:0] MEMATTRS;           // System-bus memory attributes
  output         EXREQS;             // System-bus exclusive request

  // Core Status
  output   [3:0] BRCHSTAT;           // Branch status
  output         HALTED;             // Core is halted via debug
  output         DBGRESTARTED;       // External Debug Restart Ready
  output         LOCKUP;             // Lockup indication
  output         SLEEPING;           // Core is sleeping
  output         SLEEPDEEP;          // System can enter deep sleep
  output         SLEEPHOLDACKn;      // Indicate core is force in sleep mode
  output   [8:0] ETMINTNUM;          // Interrupt that is currently active
  output   [2:0] ETMINTSTAT;         // Interrupt activation status
  output         TRCENA;             // Trace Enable
  output   [7:0] CURRPRI;            // Current Int Priority

  // Reset request
  output         SYSRESETREQ;        // System reset request

  // Events
  output         TXEV;               // Event output

  // Clock gating control
  output         GATEHCLK;           // when high, HCLK can be turned off

  // WIC
  output         WICENACK;           // WIC mode acknowledge from WIC
  output         WAKEUP;             // Wake-up request from WIC

  //----------------------------------------------------------------------------
  // Internal wires and registers
  //----------------------------------------------------------------------------

  // PMU
  wire           ISOLATEn;           // Isolate core power domain
  wire           RETAINn;            // Retain core state during power-down - unused

  // Debug
  wire           nTDOEN;             // Test Data Out Enable
  wire           SWDO;               // SingleWire data out
  wire           SWDOEN;             // SingleWire output enable
  wire           SWV;                // SingleWire Viewer Data

  // Miscellaneous
  wire           PORESETn;           // PowerOn reset
  wire           SYSRESETn;          // System reset
  wire           RSTBYPASS;          // Reset Bypass
  wire           CGBYPASS;           // Architectural clock gate bypass
  wire           FCLK;               // Free running clock
  wire           TRACECLKIN;         // TPIU trace port clock
  wire           STCLK;              // System Tick clock
  wire    [25:0] STCALIB;            // System Tick calibration
  wire           BIGEND;             // Static endianess select
  wire     [3:0] BRCHSTAT;           // Branch status
  wire           HALTED;             // Core is halted via debug
  wire     [7:0] CURRPRI;            // Current Int Priority
  wire           NIDEN;              // Non-invasive debug enable
  wire           TRCENA;             // Trace Enable
  wire           tpiu_en;            // Control for TPIU clock gating
  wire     [9:0] vect_addr;          // Reserved
  wire           vect_addr_en;       // Reserved
  wire           stk_align_init;     // Reserved

  // ICode
  wire     [1:0] HTRANSI;            // ICode-bus transfer type
  wire     [2:0] HSIZEI;             // ICode-bus transfer size
  wire    [31:0] HADDRI;             // ICode-bus address
  wire     [2:0] HBURSTI;            // ICode-bus burst length
  wire     [3:0] HPROTI;             // ICode-bus protection
  wire     [1:0] MEMATTRI;           // ICode-bus memory attributes
  wire           HREADYI;            // ICode-bus ready
  wire    [31:0] HRDATAI;            // ICode-bus read data
  wire     [1:0] HRESPI;             // ICode-bus transfer response
  wire           IFLUSH;             // ICode-bus buffer flush

  // DCode
  wire     [1:0] HMASTERD;           // DCode-bus master
  wire     [1:0] HTRANSD;            // DCode-bus transfer type
  wire     [2:0] HSIZED;             // DCode-bus transfer size
  wire    [31:0] HADDRD;             // DCode-bus address
  wire     [2:0] HBURSTD;            // DCode-bus burst length
  wire     [3:0] HPROTD;             // DCode-bus protection
  wire     [1:0] MEMATTRD;           // DCode-bus memory attributes
  wire           EXREQD;             // DCode-bus exclusive request
  wire           HWRITED;            // DCode-bus write not read
  wire    [31:0] HWDATAD;            // DCode-bus write data
  wire           HREADYD;            // DCode-bus ready
  wire    [31:0] HRDATAD;            // DCode-bus read data
  wire     [1:0] HRESPD;             // DCode-bus transfer response
  wire           EXRESPD;            // DCode-bus exclusive response

  // System
  wire     [1:0] HMASTERS;           // System-bus master
  wire     [1:0] HTRANSS;            // System-bus transfer type
  wire     [2:0] HSIZES;             // System-bus transfer size
  wire    [31:0] HADDRS;             // System-bus address
  wire     [2:0] HBURSTS;            // System-bus burst length
  wire     [3:0] HPROTS;             // System-bus protection
  wire     [1:0] MEMATTRS;           // System-bus memory attributes
  wire           EXREQS;             // System-bus exclusive request
  wire           HWRITES;            // System-bus write not read
  wire    [31:0] HWDATAS;            // System-bus write data
  wire           HREADYS;            // System-bus ready
  wire    [31:0] HRDATAS;            // System-bus read data
  wire     [1:0] HRESPS;             // System-bus transfer response
  wire           EXRESPS;            // System-bus exclusive response

  // DAP: Debug AHB interface
  wire           dbg_en_sync;        // DBGEN synchronised to DAPCLK
  wire           dap_en;             // DAP-Enable
  wire           dap_clk_en;         // DAP-ClockEn (clock divider)
  wire           dap_reset_n;        // DAP-reset
  reg            dap_sel;            // DAP-select
  reg            dap_enable;         // DAP-enable
  reg            dap_write;          // DAP-write
  reg            dap_abort;          // DAP-abort
  reg     [31:0] dap_addr_mux;       // Muxed DAPADDR from various sources
  wire    [31:0] dap_addr;           // DAP-address
  reg     [31:0] dap_wdata;          // DAP-write data
  reg            dap_ready;          // DAP-transfer response
  reg            dap_slverr;         // DAP-slave error
  reg     [31:0] dap_rdata;          // DAP-read data
  wire           dap_sel_core;       // DAP-select core

  // DAP bus from core
  wire           dap_ready_core;     // DAP-transfer response
  wire           dap_slverr_core;    // DAP-slave error
  wire    [31:0] dap_rdata_core;     // DAP-read data

  // DAP DP Power Controls
  wire           c_sys_power_up;     // System Powerup (SWCLK)
  wire           c_sys_power_up_sync;// Synchronised to FCLK
  wire           c_dbg_power_up_ack_sync; // Synchronised to DAPCLK

  // SWJ-DP
  wire           dap_sel_swj;        // DAP-select
  wire           dap_enable_swj;     // DAP-enable
  wire           dap_write_swj;      // DAP-write
  wire           dap_abort_swj;      // DAP-abort
  wire    [31:0] dap_addr_swj;       // DAP-address
  wire    [31:0] dap_wdata_swj;      // DAP-wdata
  wire           CDBGPWRUPREQ;       // Debug Powerup
  wire           c_sys_power_up_req; // System Powerup
  wire           CDBGPWRUPACK;       // Debug Powerup acknowledge
  wire           c_sys_power_up_ack; // System Powerup acknowledge

  // TPIU
  wire           atb_valid_port1;    // ATB valid signal source 1
  wire    [6:0]  atb_id1;            // ATB ID source 1
  wire    [7:0]  atb_data_port1;     // ATB data source 1
  wire           atb_valid_port2;    // ATB valid signal source 2
  wire    [6:0]  atb_id2;            // ATB ID source 2
  wire    [7:0]  atb_data_port2;     // ATB data source 2
  wire           atb_ready_port1;    // ATB ready signal source 1
  wire           atb_ready_port2;    // ATB ready signal source 2
  wire           t_reset_n;          // TRACECLKIN asychronous reset active low
  wire           TRACECLK;           // Trace Clock
  wire     [3:0] TRACEDATA;          // Trace Data
  wire           trace_swo;          // Trace SingleWire Output
  wire           tpiu_active;        // TPIU is active
  wire           tpiu_baud;          // TPIU baud indicator (in TRACECLK)

  // ATB interface - ITM
  wire           at_valid_itm;       // ATB Valid
  wire           af_ready_itm;       // ATB Flush
  wire     [7:0] at_data_itm;        // ATB Data
  wire           at_ready_itm;       // ATB Ready
  wire     [6:0] at_id_itm;          // ATM ID

  // Sleep interface
  wire           SLEEPING;           // Core is sleeping
  wire           SLEEPDEEP;          // System can enter deep sleep

  // Reset
  wire           SYSRESETREQ;        // System Reset Request

  // ETM
  wire           d_sync;             // DWT generated sync pulse
  wire     [3:0] etm_trigger;        // DWT generated trigger
  wire     [3:0] etm_trig_i_not_d;   // DWT generates trigger on PC match
  wire           atb_atvalid_etm;    // ATB Valid
  wire     [7:0] atb_atdata_etm;     // ATB Data
  wire           atb_atready_etm;    // ATB Ready
  wire     [6:0] atb_atid_etm;       // ATM ID
  wire           etm_dbg_req;        // Debug request from ETM
  wire           etm_fifo_full;      // ETM FIFO is full
  wire    [31:1] etm_ia;             // Instruction Address
  wire           etm_ivalid;         // Instruction data is valid
  wire           etm_istall;         // Stall IVALID from prev. cycle
  wire           etm_dvalid;         // Data Matches are valid
  wire           etm_fold;           // 2 instructions this cycle
  wire           etm_cancel;         // Previous started instruction did not complete
  wire           etm_ccfail;         // Instruction failed condition code
  wire           etm_branch;         // Instruction is Branch
  wire           etm_indirect_branch;// Instruction is indirect branch
  wire           etm_isb;            // Instruction is ISB
  wire     [2:0] ETMINTSTAT;         // Branch is due to int entry[x] or exit[y]
  wire     [8:0] ETMINTNUM;          // Interrupt Source
  wire           etm_flush;          // Pipe flush hint
  wire           etm_find_br;        // Flush indirect branch
  wire           etm_power_up;       // The ETM is powered-up
  wire           etm_en;             // ETM Traceport Enabled
  wire           etm_trigger_out;    // ETM Trigger Status Signal to TPIU
  wire           etm_fifo_full_en;   // System supports FIFOFULL
  wire           combined_dbg_req;   // Combined EDBGRQ and ETM request

  // Private Peripheral Segment
  wire           ppb_psel;           // APB select from Cortex-M3
  wire           ppb_penable;        // APB Enable
  wire           ppb_pwrite;         // APB is write
  wire           ppb_paddr31;        // APB Addr bit 31
  wire    [19:2] ppb_paddr;          // APB address
  wire    [31:0] ppb_pwdata;         // APB write data
  wire    [31:0] ppb_prdata;         // APB read data
  wire           ppb_pready;         // APB Ready response
  wire           ppb_pslverr;        // APB Slave Error Response
  wire           ppb_pseltpiu;       // APB Select for TPIU
  wire           ppb_psel_etm;       // APB Select for ETM
  wire           ppb_psel_rom;       // APB Select for ROM Table
  wire    [31:0] ppb_prdata_tpiu;    // APB Read data from TPIU
  wire    [31:0] ppb_prdata_mux_tpiu;// APB Read data from TPIU (in mux)
  wire    [31:0] ppb_prdata_etm;     // APB Read data from ETM
  wire    [31:0] ppb_prdata_mux_etm; // APB Read data from ETM (in mux)
  wire    [31:0] ppb_prdata_rom;     // APB Read data from ROM Table
  wire    [31:0] ppb_prdata_mux_rom; // APB Read data from ROM Table (in mux)
  wire     [5:0] ppb_lock;           // APB Lock flag

  // Local Reset
  reg            poreset_n_q;        // Power-On Reset out of first register
  reg            poreset_n_qq;       // Power-On Reset out of second register
  reg            refreset_n_q;       // Power-On Reset sync'd to TRACECLKIN out of first register
  reg            refreset_n_qq;      // Power-On Reset  sync'd to TRACECLKINout of second register
  reg            sysreset_n_q;       // System Reset out of first register
  reg            sysreset_n_qq;      // System Reset out of second register
  reg            po_trst_n_q;        // Power-On Test Reset out of first register
  reg            po_trst_n_qq;       // Power-On Test Reset out of second register

  wire           int_poreset_n;      // Above signal with bypass for test
  wire           int_sysreset_n;     // Above signal with bypass for test
  wire           int_po_trst_n;      // Above signal with bypass for test

  // Local Clocks
  wire           dap_clk_src;        // DAP-clock source
  wire           dap_clk;            // DAP-clock gated
  wire           dclk_g;             // Trace Clock gated
  wire           HCLK;               // FCLK gated if sleeping
  wire           cclk;               // Core clock
  wire           int_gate_hclk;      // Internal GATEHCLK output
  wire           trace_clk_in_g;     // TRACECLKIN gated

  // Internal signals for logic removal
  wire    [31:0] int_prdata_rom;
  wire           int_etm_dbg_req;
  wire           int_etm_fifo_full;
  wire           int_etm_power_up;
  wire           int_etm_en;
  wire    [31:0] int_prdata_etm;
  wire     [7:0] int_atb_atdata_etm;
  wire           int_atb_atvalid_etm;
  wire           int_atb_afready_etm;
  wire           int_etm_trigger_out;
  wire     [6:0] int_atb_atid_etm;
  wire    [31:0] int_prdata_tpiu;
  wire           int_trace_clk;
  wire     [3:0] int_trace_data;
  wire           int_trace_swo;
  wire           int_tpiu_active;
  wire           int_tpiu_baud;
  wire           int_atb_ready_port1;
  wire           int_atb_ready_port2;
  wire           int_tdo;
  wire           int_tdoen_n;
  wire           int_dap_sel_swj;
  wire           int_dap_enable_swj;
  wire           int_dap_write_swj;
  wire           int_dap_abort_swj;
  wire    [31:0] int_dap_addr_swj;
  wire    [31:0] int_dap_wdata_swj;
  wire           int_sw_do;
  wire           int_sw_do_en;
  wire           int_c_dbg_power_up_req;
  wire           int_c_sys_power_up_req;
  wire           int_dap_clk;
  wire           int_dclk_g;
  wire           int_cclk;
  wire           int_trace_clk_in;
  wire   [148:0] int_internal_state;

  // DAP Interface - Debug Test
  wire    [31:0] dap_addr_tb;
  wire           dap_sel_tb;
  wire           dap_enable_tb;
  wire           dap_write_tb;
  wire    [31:0] dap_wdata_tb;
  wire           dap_abort_tb;

  // DAP external test select and enable
  wire           dap_en_tb;
  wire     [1:0] etm_ext_in;
  wire     [1:0] etm_max_ext_in;

  // TrickBox read data
  wire    [31:0] ppb_prdata_mux_tbox;

  // Use 1 bit signal array to fail the compile if any of the options is invalid
  wire     [1:1] config_check_0;  // IRQ number
  wire     [1:1] config_check_1;  // Priority register width
  wire     [1:1] config_check_2;  // Debug level
  wire     [1:1] config_check_3;  // Trace level
  wire     [1:1] config_check_4;  // MPU present
  wire     [1:1] config_check_5;  // JTAG present
  wire     [1:1] config_check_6;  // Clock gating
  wire     [1:1] config_check_7;  // Reset all registers
  wire     [1:1] config_check_8;  // Observation
  wire     [1:1] config_check_9;  // Debug level and trace level combination
  wire     [1:1] config_check_10; // WIC lines
  wire     [1:1] config_check_11; // WIC Present
  wire     [1:1] config_check_12; // Bit-banding present
  wire     [1:1] config_check_13; // Constant AHB control

  // WIC
  wire                 mst_wic_en;     // logic removal term
  wire                 int_wake_up;    // Wake-up request from WIC
  wire                 int_wic_en_ack; // WIC mode acknowledge from WIC
  wire                 wic_nmi_pend;   // NMI  pended by WIC
  wire                 wic_rxev_pend;  // RXEV pended by WIC
  wire         [239:0] int_int_isr;    // Incoming IRQs OR'd with WIC pended IRQs
  wire                 int_int_nmi;    // Incoming NMI  OR'd with WIC pended NMI
  wire                 int_rxev;       // Incoming RXEV OR'd with WIC pended RXEV
  wire                 int_ext_dbg_req;// Incoming EDBGRQ OR'd with WIC pended EDBGRQ
  wire                 wic_ds_req_n;   // WIC mode request to core
  wire                 wic_ds_ack_n;   // WIC mode acknowledge from core
  wire                 wic_load;       // Load IRQ/MON/NMI/RXEV sensitivity list
  wire                 wic_clear;      // Clear WIC sensitivity list
  wire         [239:0] wic_mask_isr;   // WIC IRQ sensitivity list
  wire                 wic_mask_mon;   // WIC DBG MON sensitivity
  wire                 wic_mask_nmi;   // WIC NMI sensitivity
  wire                 wic_mask_rxev;  // WIC RXEV sensitivity
  wire [WIC_LINES-1:0] wic_pend;       // IRQ/NMI/RXEV pended by WIC
  wire [WIC_LINES:0]   int_wic_pend;   // IRQ/NMI/RXEV pended by WIC
  wire [WIC_LINES-1:0] wic_int;        // IRQ/NMI/RXEV input to WIC
  wire         [242:0] int_wic_int;    // expanded WICINT
  wire [WIC_LINES-1:0] wic_sense;      // sensitivity list from WIC
  wire         [242:0] wic_mask;       // sensitivity list from core
  wire [WIC_LINES-1:0] int_wic_mask;   // sensitivity list from core
  wire         [241:0] int_wic_irq_pend;
  wire         [239:0] wic_irq_pend;
  wire                 wic_mon_pend;

  //----------------------------------------------------------------------------
  // DSM port declarations
  //----------------------------------------------------------------------------

`ifdef ARM_DSM

  // DSM  Programmers model:
  // DPU register bank and flags
  wire  [31:0] dsm_pc;
  wire  [31:0] dsm_r0;
  wire  [31:0] dsm_r1;
  wire  [31:0] dsm_r2;
  wire  [31:0] dsm_r3;
  wire  [31:0] dsm_r4;
  wire  [31:0] dsm_r5;
  wire  [31:0] dsm_r6;
  wire  [31:0] dsm_r7;
  wire  [31:0] dsm_r8;
  wire  [31:0] dsm_r9;
  wire  [31:0] dsm_r10;
  wire  [31:0] dsm_r11;
  wire  [31:0] dsm_r12;
  wire  [31:0] dsm_r13;
  wire  [31:0] dsm_r14;
  wire  [31:0] dsm_cpsr;
  wire  [31:0] dsm_ClkCount;

  // SCS registers
  wire  [31:0] dsm_scs_actlr;
  wire  [31:0] dsm_scs_cpuid;
  wire  [31:0] dsm_scs_icsr;
  wire  [31:0] dsm_scs_vtor;
  wire  [31:0] dsm_scs_aircr;
  wire  [31:0] dsm_scs_scr;
  wire  [31:0] dsm_scs_ccr;
  wire  [31:0] dsm_scs_shpr1;
  wire  [31:0] dsm_scs_shpr2;
  wire  [31:0] dsm_scs_shpr3;
  wire  [31:0] dsm_scs_shcsr;
  wire  [31:0] dsm_scs_cfsr;
  wire  [31:0] dsm_scs_hfsr;
  wire  [31:0] dsm_scs_dfsr;
  wire  [31:0] dsm_scs_mmfar;
  wire  [31:0] dsm_scs_bfar;
  wire  [31:0] dsm_scs_afsr;
  wire  [31:0] dsm_scs_cpacr;
  wire  [31:0] dsm_scs_dhcsr;
  wire  [31:0] dsm_scs_dcrdr;
  wire  [31:0] dsm_scs_demcr;

  // System Timer registers
  wire  [31:0] dsm_syst_csr;
  wire  [31:0] dsm_syst_rvr;
  wire  [31:0] dsm_syst_cvr;
  wire  [31:0] dsm_syst_calib;

  // NVIC registers
  wire  [31:0] dsm_nvic_ictr;
  wire  [31:0] dsm_nvic_iser0;
  wire  [31:0] dsm_nvic_iser1;
  wire  [31:0] dsm_nvic_iser2;
  wire  [31:0] dsm_nvic_iser3;
  wire  [31:0] dsm_nvic_iser4;
  wire  [31:0] dsm_nvic_iser5;
  wire  [31:0] dsm_nvic_iser6;
  wire  [31:0] dsm_nvic_iser7;
  wire  [31:0] dsm_nvic_icer0;
  wire  [31:0] dsm_nvic_icer1;
  wire  [31:0] dsm_nvic_icer2;
  wire  [31:0] dsm_nvic_icer3;
  wire  [31:0] dsm_nvic_icer4;
  wire  [31:0] dsm_nvic_icer5;
  wire  [31:0] dsm_nvic_icer6;
  wire  [31:0] dsm_nvic_icer7;
  wire  [31:0] dsm_nvic_ispr0;
  wire  [31:0] dsm_nvic_ispr1;
  wire  [31:0] dsm_nvic_ispr2;
  wire  [31:0] dsm_nvic_ispr3;
  wire  [31:0] dsm_nvic_ispr4;
  wire  [31:0] dsm_nvic_ispr5;
  wire  [31:0] dsm_nvic_ispr6;
  wire  [31:0] dsm_nvic_ispr7;
  wire  [31:0] dsm_nvic_icpr0;
  wire  [31:0] dsm_nvic_icpr1;
  wire  [31:0] dsm_nvic_icpr2;
  wire  [31:0] dsm_nvic_icpr3;
  wire  [31:0] dsm_nvic_icpr4;
  wire  [31:0] dsm_nvic_icpr5;
  wire  [31:0] dsm_nvic_icpr6;
  wire  [31:0] dsm_nvic_icpr7;
  wire  [31:0] dsm_nvic_iabr0;
  wire  [31:0] dsm_nvic_iabr1;
  wire  [31:0] dsm_nvic_iabr2;
  wire  [31:0] dsm_nvic_iabr3;
  wire  [31:0] dsm_nvic_iabr4;
  wire  [31:0] dsm_nvic_iabr5;
  wire  [31:0] dsm_nvic_iabr6;
  wire  [31:0] dsm_nvic_iabr7;
  wire  [31:0] dsm_nvic_ipr0;
  wire  [31:0] dsm_nvic_ipr1;
  wire  [31:0] dsm_nvic_ipr2;
  wire  [31:0] dsm_nvic_ipr3;
  wire  [31:0] dsm_nvic_ipr4;
  wire  [31:0] dsm_nvic_ipr5;
  wire  [31:0] dsm_nvic_ipr6;
  wire  [31:0] dsm_nvic_ipr7;
  wire  [31:0] dsm_nvic_ipr8;
  wire  [31:0] dsm_nvic_ipr9;
  wire  [31:0] dsm_nvic_ipr10;
  wire  [31:0] dsm_nvic_ipr11;
  wire  [31:0] dsm_nvic_ipr12;
  wire  [31:0] dsm_nvic_ipr13;
  wire  [31:0] dsm_nvic_ipr14;
  wire  [31:0] dsm_nvic_ipr15;
  wire  [31:0] dsm_nvic_ipr16;
  wire  [31:0] dsm_nvic_ipr17;
  wire  [31:0] dsm_nvic_ipr18;
  wire  [31:0] dsm_nvic_ipr19;
  wire  [31:0] dsm_nvic_ipr20;
  wire  [31:0] dsm_nvic_ipr21;
  wire  [31:0] dsm_nvic_ipr22;
  wire  [31:0] dsm_nvic_ipr23;
  wire  [31:0] dsm_nvic_ipr24;
  wire  [31:0] dsm_nvic_ipr25;
  wire  [31:0] dsm_nvic_ipr26;
  wire  [31:0] dsm_nvic_ipr27;
  wire  [31:0] dsm_nvic_ipr28;
  wire  [31:0] dsm_nvic_ipr29;
  wire  [31:0] dsm_nvic_ipr30;
  wire  [31:0] dsm_nvic_ipr31;
  wire  [31:0] dsm_nvic_ipr32;
  wire  [31:0] dsm_nvic_ipr33;
  wire  [31:0] dsm_nvic_ipr34;
  wire  [31:0] dsm_nvic_ipr35;
  wire  [31:0] dsm_nvic_ipr36;
  wire  [31:0] dsm_nvic_ipr37;
  wire  [31:0] dsm_nvic_ipr38;
  wire  [31:0] dsm_nvic_ipr39;
  wire  [31:0] dsm_nvic_ipr40;
  wire  [31:0] dsm_nvic_ipr41;
  wire  [31:0] dsm_nvic_ipr42;
  wire  [31:0] dsm_nvic_ipr43;
  wire  [31:0] dsm_nvic_ipr44;
  wire  [31:0] dsm_nvic_ipr45;
  wire  [31:0] dsm_nvic_ipr46;
  wire  [31:0] dsm_nvic_ipr47;
  wire  [31:0] dsm_nvic_ipr48;
  wire  [31:0] dsm_nvic_ipr49;
  wire  [31:0] dsm_nvic_ipr50;
  wire  [31:0] dsm_nvic_ipr51;
  wire  [31:0] dsm_nvic_ipr52;
  wire  [31:0] dsm_nvic_ipr53;
  wire  [31:0] dsm_nvic_ipr54;
  wire  [31:0] dsm_nvic_ipr55;
  wire  [31:0] dsm_nvic_ipr56;
  wire  [31:0] dsm_nvic_ipr57;
  wire  [31:0] dsm_nvic_ipr58;
  wire  [31:0] dsm_nvic_ipr59;

  // MPU registers
  wire  [31:0] dsm_mpu_ctrl;
  wire  [31:0] dsm_mpu_rnr;
  wire  [31:0] dsm_mpu_rbar;
  wire  [31:0] dsm_mpu_rasr;

  // DSM disass
  wire    [2:0] dsm_ID;
  wire          dsm_echo_to_stdout;
  wire          dsm_no_tarmac;
  wire          dsm_no_ecs;

  // DSM configuration control
  wire          dsm_mpu_present;
  wire    [7:0] dsm_num_irq;
  wire    [3:0] dsm_lvl_width;
  wire    [1:0] dsm_trace_lvl;
  wire    [1:0] dsm_debug_lvl;
  wire          dsm_clkgate_present;
  wire          dsm_reset_all_regs;
  wire          dsm_observation;
  wire          dsm_wic_present;
  wire    [7:0] dsm_wic_lines;
  wire          dsm_bb_present;
  wire          dsm_const_ahb_ctrl;

`endif

  // ---------------------------------------------------------------------------
  // Reset synchronisers
  // ---------------------------------------------------------------------------

  // PORESET synchroniser
  always @ (posedge FCLK or negedge PORESETn)
    if (!PORESETn)
      begin
        poreset_n_q  <= 1'b0;
        poreset_n_qq <= 1'b0;
      end
    else
      begin
        poreset_n_q  <= 1'b1;
        poreset_n_qq <= poreset_n_q;
      end

  // SYSRESET synchroniser
  always @ (posedge FCLK or negedge SYSRESETn)
    if (!SYSRESETn)
      begin
        sysreset_n_q  <= 1'b0;
        sysreset_n_qq <= 1'b0;
      end
    else
      begin
        sysreset_n_q  <= 1'b1;
        sysreset_n_qq <= sysreset_n_q;
      end

  // nPOTRST synchroniser
  always @ (posedge SWCLKTCK or negedge PORESETn)
    if (!PORESETn)
      begin
        po_trst_n_q  <= 1'b0;
        po_trst_n_qq <= 1'b0;
      end
    else
      begin
        po_trst_n_q  <= 1'b1;
        po_trst_n_qq <= po_trst_n_q;
      end

  // Reset Bypass for Test
  assign int_poreset_n  = RSTBYPASS ? PORESETn : poreset_n_qq;
  assign int_sysreset_n = RSTBYPASS ? PORESETn : sysreset_n_qq;
  assign int_po_trst_n  = RSTBYPASS ? PORESETn : po_trst_n_qq;

  assign dap_reset_n    = int_poreset_n;

  // Synchronise PORESETn to TRACECLKIN
  always @ (posedge TRACECLKIN or negedge int_poreset_n)
    if (!int_poreset_n)
      begin
        refreset_n_q  <= 1'b0;
        refreset_n_qq <= 1'b0;
      end
    else
      begin
        refreset_n_q  <= int_poreset_n;
        refreset_n_qq <= refreset_n_q;
      end

  assign t_reset_n = RSTBYPASS ? PORESETn : refreset_n_qq;


  // ---------------------------------------------------------------------------
  // Architectural clock gates and associated synchronisers
  // ---------------------------------------------------------------------------

  // DAPCLKEN is set to 1 when Debug system is powered up.
  assign dap_clk_en  = c_dbg_power_up_ack_sync;
  assign dap_clk_src = FCLK;

  // Enable HCLK if debugger request power up (active low for sync)
  // HCLK can be turn off when the core is sleep, unless
  // nHCLKEnDbgSync is low (debug requested power up)
  assign int_gate_hclk   = ((SLEEPING | ~SLEEPHOLDACKn | ~ISOLATEn) &
                       ~(c_dbg_power_up_ack_sync | c_sys_power_up_sync));
  assign GATEHCLK = int_gate_hclk;

  // Synchroniser for nHCLKEnDbg
  // (Use active low version so that at reset HCLKEnSync is high)
  cm3_sync #(1)
    u_cm3_sync_hclken
      (//Inputs
       .clk                       (FCLK),
       .reset_n                   (int_poreset_n),
       .d_async_i                 (c_sys_power_up),
       //Outputs
       .q_o                       (c_sys_power_up_sync)
      );

  // Synchroniser for DAPPWRUP
  cm3_sync #(1)
    u_cm3_sync_dappwrup
      (//Inputs
       .clk                       (dap_clk_src),
       .reset_n                   (dap_reset_n),
       .d_async_i                 (CDBGPWRUPACK),
       //Outputs
       .q_o                       (c_dbg_power_up_ack_sync)
      );

  // Synchroniser for DBGEN
  cm3_sync #(1)
    u_cm3_sync_dbgen
      (//Inputs
       .clk                       (dap_clk_src),
       .reset_n                   (dap_reset_n),
       .d_async_i                 (DBGEN),
       //Outputs
       .q_o                       (dbg_en_sync)
      );

  assign dap_en = c_dbg_power_up_ack_sync & dbg_en_sync;

  // Generate gated DAP clock
  cm3_clk_gate #(CLKGATE_PRESENT)
    u_cm3_clk_gate_dapclk
      (// Inputs
       .clk                       (dap_clk_src),
       .clk_enable_i              (dap_clk_en),
       .global_disable_i          (CGBYPASS),
       // Outputs
       .clk_gated_o               (int_dap_clk)
      );

  // Ensure TPIU is enabled if either trace source can
  // be active. If HCLK is stopped, must also stop trace capture
  assign tpiu_en = (TRCENA | etm_en) & ~int_gate_hclk;
  // Generate gated debug clock
  cm3_clk_gate #(CLKGATE_PRESENT)
    u_cm3_clk_gate_dclk
      (// Inputs
       .clk                       (FCLK),
       .clk_enable_i              (tpiu_en),
       .global_disable_i          (CGBYPASS),
       // Outputs
       .clk_gated_o               (int_dclk_g)
      );

  // Generate gated core clock
  cm3_clk_gate #(CLKGATE_PRESENT)
    u_cm3_clk_gate_cclk
      (// Inputs
       .clk                       (FCLK),
       .clk_enable_i              (ISOLATEn),
       .global_disable_i          (CGBYPASS),
       // Outputs
       .clk_gated_o               (int_cclk)
      );

  // Generate gated TRACECLKIN clock
  cm3_clk_gate #(CLKGATE_PRESENT)
    u_cm3_clk_gate_traceclkin
      (// Inputs
       .clk                       (TRACECLKIN),
       .clk_enable_i              (ISOLATEn),
       .global_disable_i          (CGBYPASS),
       // Outputs
       .clk_gated_o               (int_trace_clk_in)
      );

  // Clock gate removal logic
  assign dap_clk        = (CLKGATE_PRESENT != 0) ? int_dap_clk        : dap_clk_src;
  assign dclk_g         = (CLKGATE_PRESENT != 0) ? int_dclk_g         : HCLK;
  assign cclk           = ((CLKGATE_PRESENT != 0) &
                           (WIC_PRESENT     != 0)) ? int_cclk         : FCLK;
  assign trace_clk_in_g = ((CLKGATE_PRESENT != 0) &
                           (WIC_PRESENT     != 0)) ? int_trace_clk_in : TRACECLKIN;


  // Tied low, this signal is rarely used in any systems
  wire tsclkchange = 1'b0;

  // ---------------------------------------------------------------------------
  // Processor instantiation
  // ---------------------------------------------------------------------------

  CORTEXM3 #(MPU_PRESENT, NUM_IRQ, LVL_WIDTH, TRACE_LVL, DEBUG_LVL,
             CLKGATE_PRESENT, RESET_ALL_REGS, OBSERVATION, WIC_PRESENT,
             WIC_LINES, BB_PRESENT, CONST_AHB_CTRL)
    uCORTEXM3
      (/*AUTOINST*/
       // Inputs
       .PORESETn            (int_poreset_n),
       .SYSRESETn           (int_sysreset_n),
       .RSTBYPASS           (RSTBYPASS),
       .CGBYPASS            (CGBYPASS),
       .FCLK                (cclk),
       .HCLK                (HCLK),
       .STCLK               (STCLK),
       .STCALIB             (STCALIB),
       .AUXFAULT            (AUXFAULT),
       .BIGEND              (BIGEND),
       .INTNMI              (int_int_nmi),
       .INTISR              (int_int_isr),
       .ETMPWRUP            (etm_power_up),
       .VECTADDR            (vect_addr),
       .VECTADDREN          (vect_addr_en),
       .EDBGRQ              (combined_dbg_req),
       .DBGRESTART          (DBGRESTART),
       .ETMFIFOFULL         (etm_fifo_full),
       .TPIUACTV            (tpiu_active),
       .TPIUBAUD            (tpiu_baud),
       .RXEV                (int_rxev),
       .SLEEPHOLDREQn       (SLEEPHOLDREQn),
       .STKALIGNINIT        (stk_align_init),
       .FIXMASTERTYPE       (FIXMASTERTYPE),
       .TSVALUEB            (TSVALUEB),
       .TSCLKCHANGE         (tsclkchange),
       .HREADYI             (HREADYI),
       .HRDATAI             (HRDATAI),
       .HRESPI              (HRESPI),
       .IFLUSH              (IFLUSH),
       .HREADYD             (HREADYD),
       .HRDATAD             (HRDATAD),
       .HRESPD              (HRESPD),
       .EXRESPD             (EXRESPD),
       .HREADYS             (HREADYS),
       .HRDATAS             (HRDATAS),
       .HRESPS              (HRESPS),
       .EXRESPS             (EXRESPS),
       .PRDATA              (ppb_prdata),
       .PREADY              (ppb_pready),
       .PSLVERR             (ppb_pslverr),
       .DAPEN               (dap_en),
       .DAPCLKEN            (dap_clk_en),
       .DAPCLK              (dap_clk),
       .DAPRESETn           (dap_reset_n),
       .DAPSEL              (dap_sel_core),
       .DAPENABLE           (dap_enable),
       .DAPWRITE            (dap_write),
       .DAPABORT            (dap_abort),
       .DAPADDR             (dap_addr),
       .DAPWDATA            (dap_wdata),
       .ATREADY             (at_ready_itm),
       .PPBLOCK             (ppb_lock),
       .DNOTITRANS          (DNOTITRANS),
       .WICDSREQn           (wic_ds_req_n),
       .SE                  (SE),
       .MPUDISABLE          (MPUDISABLE),
       .DBGEN               (DBGEN),
       // Outputs
       .SYSRESETREQ         (SYSRESETREQ),
       .TXEV                (TXEV),
       .HTRANSI             (HTRANSI),
       .HSIZEI              (HSIZEI),
       .HADDRI              (HADDRI),
       .HBURSTI             (HBURSTI),
       .HPROTI              (HPROTI),
       .MEMATTRI            (MEMATTRI),
       .HMASTERD            (HMASTERD),
       .HTRANSD             (HTRANSD),
       .HSIZED              (HSIZED),
       .HADDRD              (HADDRD),
       .HBURSTD             (HBURSTD),
       .HPROTD              (HPROTD),
       .MEMATTRD            (MEMATTRD),
       .EXREQD              (EXREQD),
       .HWRITED             (HWRITED),
       .HWDATAD             (HWDATAD),
       .HMASTERS            (HMASTERS),
       .HTRANSS             (HTRANSS),
       .HWRITES             (HWRITES),
       .HSIZES              (HSIZES),
       .HMASTLOCKS          (HMASTLOCKS),
       .HADDRS              (HADDRS),
       .HWDATAS             (HWDATAS),
       .HBURSTS             (HBURSTS),
       .HPROTS              (HPROTS),
       .MEMATTRS            (MEMATTRS),
       .EXREQS              (EXREQS),
       .PADDR31             (ppb_paddr31),
       .PADDR               (ppb_paddr),
       .PSEL                (ppb_psel),
       .PENABLE             (ppb_penable),
       .PWRITE              (ppb_pwrite),
       .PWDATA              (ppb_pwdata),
       .DAPREADY            (dap_ready_core),
       .DAPSLVERR           (dap_slverr_core),
       .DAPRDATA            (dap_rdata_core),
       .ATVALID             (at_valid_itm),
       .AFREADY             (af_ready_itm),
       .ATDATA              (at_data_itm),
       .ETMTRIGGER          (etm_trigger),
       .ETMTRIGINOTD        (etm_trig_i_not_d),
       .ETMIVALID           (etm_ivalid),
       .ETMISTALL           (etm_istall),
       .ETMDVALID           (etm_dvalid),
       .ETMFOLD             (etm_fold),
       .ETMCANCEL           (etm_cancel),
       .ETMIA               (etm_ia[31:1]),
       .ETMICCFAIL          (etm_ccfail),
       .ETMIBRANCH          (etm_branch),
       .ETMIINDBR           (etm_indirect_branch),
       .ETMISB              (etm_isb),
       .ETMINTSTAT          (ETMINTSTAT),
       .ETMINTNUM           (ETMINTNUM),
       .ETMFLUSH            (etm_flush),
       .ETMFINDBR           (etm_find_br),
       .DSYNC               (d_sync),
       .HTMDHADDR           (HTMDHADDR) ,
       .HTMDHTRANS          (HTMDHTRANS),
       .HTMDHSIZE           (HTMDHSIZE) ,
       .HTMDHBURST          (HTMDHBURST),
       .HTMDHPROT           (HTMDHPROT) ,
       .HTMDHWDATA          (HTMDHWDATA),
       .HTMDHRDATA          (HTMDHRDATA),
       .HTMDHWRITE          (HTMDHWRITE),
       .HTMDHREADY          (HTMDHREADY),
       .HTMDHRESP           (HTMDHRESP) ,
       .ATIDITM             (at_id_itm),
       .BRCHSTAT            (BRCHSTAT),
       .HALTED              (HALTED),
       .DBGRESTARTED        (DBGRESTARTED),
       .LOCKUP              (LOCKUP),
       .SLEEPING            (SLEEPING),
       .SLEEPDEEP           (SLEEPDEEP),
       .SLEEPHOLDACKn       (SLEEPHOLDACKn),
       .CURRPRI             (CURRPRI),
       .TRCENA              (TRCENA),
       .INTERNALSTATE       (/*Not Used*/),
       .WICDSACKn           (wic_ds_ack_n),
       .WICLOAD             (wic_load),
       .WICCLEAR            (wic_clear),
       .WICMASKISR          (wic_mask_isr),
       .WICMASKMON          (wic_mask_mon),
       .WICMASKNMI          (wic_mask_nmi),
       .WICMASKRXEV         (wic_mask_rxev)

`ifdef ARM_DSM
      ,
      // DPU register bank and flags
      .dsm_pc(dsm_pc),
      .dsm_r0(dsm_r0),
      .dsm_r1(dsm_r1),
      .dsm_r2(dsm_r2),
      .dsm_r3(dsm_r3),
      .dsm_r4(dsm_r4),
      .dsm_r5(dsm_r5),
      .dsm_r6(dsm_r6),
      .dsm_r7(dsm_r7),
      .dsm_r8(dsm_r8),
      .dsm_r9(dsm_r9),
      .dsm_r10(dsm_r10),
      .dsm_r11(dsm_r11),
      .dsm_r12(dsm_r12),
      .dsm_r13(dsm_r13),
      .dsm_r14(dsm_r14),
      .dsm_cpsr(dsm_cpsr),
      .dsm_ClkCount(dsm_ClkCount),
      .dsm_scs_actlr(dsm_scs_actlr),
      .dsm_scs_cpuid(dsm_scs_cpuid),
      .dsm_scs_icsr(dsm_scs_icsr),
      .dsm_scs_vtor(dsm_scs_vtor),
      .dsm_scs_aircr(dsm_scs_aircr),
      .dsm_scs_scr(dsm_scs_scr),
      .dsm_scs_ccr(dsm_scs_ccr),
      .dsm_scs_shpr1(dsm_scs_shpr1),
      .dsm_scs_shpr2(dsm_scs_shpr2),
      .dsm_scs_shpr3(dsm_scs_shpr3),
      .dsm_scs_shcsr(dsm_scs_shcsr),
      .dsm_scs_cfsr(dsm_scs_cfsr),
      .dsm_scs_hfsr(dsm_scs_hfsr),
      .dsm_scs_dfsr(dsm_scs_dfsr),
      .dsm_scs_mmfar(dsm_scs_mmfar),
      .dsm_scs_bfar(dsm_scs_bfar),
      .dsm_scs_afsr(dsm_scs_afsr),
      .dsm_scs_cpacr(dsm_scs_cpacr),
      .dsm_scs_dhcsr(dsm_scs_dhcsr),
      .dsm_scs_dcrdr(dsm_scs_dcrdr),
      .dsm_scs_demcr(dsm_scs_demcr),
      .dsm_syst_csr(dsm_syst_csr),
      .dsm_syst_rvr(dsm_syst_rvr),
      .dsm_syst_cvr(dsm_syst_cvr),
      .dsm_syst_calib(dsm_syst_calib),
      .dsm_nvic_ictr(dsm_nvic_ictr),
      .dsm_nvic_iser0(dsm_nvic_iser0),
      .dsm_nvic_iser1(dsm_nvic_iser1),
      .dsm_nvic_iser2(dsm_nvic_iser2),
      .dsm_nvic_iser3(dsm_nvic_iser3),
      .dsm_nvic_iser4(dsm_nvic_iser4),
      .dsm_nvic_iser5(dsm_nvic_iser5),
      .dsm_nvic_iser6(dsm_nvic_iser6),
      .dsm_nvic_iser7(dsm_nvic_iser7),
      .dsm_nvic_icer0(dsm_nvic_icer0),
      .dsm_nvic_icer1(dsm_nvic_icer1),
      .dsm_nvic_icer2(dsm_nvic_icer2),
      .dsm_nvic_icer3(dsm_nvic_icer3),
      .dsm_nvic_icer4(dsm_nvic_icer4),
      .dsm_nvic_icer5(dsm_nvic_icer5),
      .dsm_nvic_icer6(dsm_nvic_icer6),
      .dsm_nvic_icer7(dsm_nvic_icer7),
      .dsm_nvic_ispr0(dsm_nvic_ispr0),
      .dsm_nvic_ispr1(dsm_nvic_ispr1),
      .dsm_nvic_ispr2(dsm_nvic_ispr2),
      .dsm_nvic_ispr3(dsm_nvic_ispr3),
      .dsm_nvic_ispr4(dsm_nvic_ispr4),
      .dsm_nvic_ispr5(dsm_nvic_ispr5),
      .dsm_nvic_ispr6(dsm_nvic_ispr6),
      .dsm_nvic_ispr7(dsm_nvic_ispr7),
      .dsm_nvic_icpr0(dsm_nvic_icpr0),
      .dsm_nvic_icpr1(dsm_nvic_icpr1),
      .dsm_nvic_icpr2(dsm_nvic_icpr2),
      .dsm_nvic_icpr3(dsm_nvic_icpr3),
      .dsm_nvic_icpr4(dsm_nvic_icpr4),
      .dsm_nvic_icpr5(dsm_nvic_icpr5),
      .dsm_nvic_icpr6(dsm_nvic_icpr6),
      .dsm_nvic_icpr7(dsm_nvic_icpr7),
      .dsm_nvic_iabr0(dsm_nvic_iabr0),
      .dsm_nvic_iabr1(dsm_nvic_iabr1),
      .dsm_nvic_iabr2(dsm_nvic_iabr2),
      .dsm_nvic_iabr3(dsm_nvic_iabr3),
      .dsm_nvic_iabr4(dsm_nvic_iabr4),
      .dsm_nvic_iabr5(dsm_nvic_iabr5),
      .dsm_nvic_iabr6(dsm_nvic_iabr6),
      .dsm_nvic_iabr7(dsm_nvic_iabr7),
      .dsm_nvic_ipr0(dsm_nvic_ipr0),
      .dsm_nvic_ipr1(dsm_nvic_ipr1),
      .dsm_nvic_ipr2(dsm_nvic_ipr2),
      .dsm_nvic_ipr3(dsm_nvic_ipr3),
      .dsm_nvic_ipr4(dsm_nvic_ipr4),
      .dsm_nvic_ipr5(dsm_nvic_ipr5),
      .dsm_nvic_ipr6(dsm_nvic_ipr6),
      .dsm_nvic_ipr7(dsm_nvic_ipr7),
      .dsm_nvic_ipr8(dsm_nvic_ipr8),
      .dsm_nvic_ipr9(dsm_nvic_ipr9),
      .dsm_nvic_ipr10(dsm_nvic_ipr10),
      .dsm_nvic_ipr11(dsm_nvic_ipr11),
      .dsm_nvic_ipr12(dsm_nvic_ipr12),
      .dsm_nvic_ipr13(dsm_nvic_ipr13),
      .dsm_nvic_ipr14(dsm_nvic_ipr14),
      .dsm_nvic_ipr15(dsm_nvic_ipr15),
      .dsm_nvic_ipr16(dsm_nvic_ipr16),
      .dsm_nvic_ipr17(dsm_nvic_ipr17),
      .dsm_nvic_ipr18(dsm_nvic_ipr18),
      .dsm_nvic_ipr19(dsm_nvic_ipr19),
      .dsm_nvic_ipr20(dsm_nvic_ipr20),
      .dsm_nvic_ipr21(dsm_nvic_ipr21),
      .dsm_nvic_ipr22(dsm_nvic_ipr22),
      .dsm_nvic_ipr23(dsm_nvic_ipr23),
      .dsm_nvic_ipr24(dsm_nvic_ipr24),
      .dsm_nvic_ipr25(dsm_nvic_ipr25),
      .dsm_nvic_ipr26(dsm_nvic_ipr26),
      .dsm_nvic_ipr27(dsm_nvic_ipr27),
      .dsm_nvic_ipr28(dsm_nvic_ipr28),
      .dsm_nvic_ipr29(dsm_nvic_ipr29),
      .dsm_nvic_ipr30(dsm_nvic_ipr30),
      .dsm_nvic_ipr31(dsm_nvic_ipr31),
      .dsm_nvic_ipr32(dsm_nvic_ipr32),
      .dsm_nvic_ipr33(dsm_nvic_ipr33),
      .dsm_nvic_ipr34(dsm_nvic_ipr34),
      .dsm_nvic_ipr35(dsm_nvic_ipr35),
      .dsm_nvic_ipr36(dsm_nvic_ipr36),
      .dsm_nvic_ipr37(dsm_nvic_ipr37),
      .dsm_nvic_ipr38(dsm_nvic_ipr38),
      .dsm_nvic_ipr39(dsm_nvic_ipr39),
      .dsm_nvic_ipr40(dsm_nvic_ipr40),
      .dsm_nvic_ipr41(dsm_nvic_ipr41),
      .dsm_nvic_ipr42(dsm_nvic_ipr42),
      .dsm_nvic_ipr43(dsm_nvic_ipr43),
      .dsm_nvic_ipr44(dsm_nvic_ipr44),
      .dsm_nvic_ipr45(dsm_nvic_ipr45),
      .dsm_nvic_ipr46(dsm_nvic_ipr46),
      .dsm_nvic_ipr47(dsm_nvic_ipr47),
      .dsm_nvic_ipr48(dsm_nvic_ipr48),
      .dsm_nvic_ipr49(dsm_nvic_ipr49),
      .dsm_nvic_ipr50(dsm_nvic_ipr50),
      .dsm_nvic_ipr51(dsm_nvic_ipr51),
      .dsm_nvic_ipr52(dsm_nvic_ipr52),
      .dsm_nvic_ipr53(dsm_nvic_ipr53),
      .dsm_nvic_ipr54(dsm_nvic_ipr54),
      .dsm_nvic_ipr55(dsm_nvic_ipr55),
      .dsm_nvic_ipr56(dsm_nvic_ipr56),
      .dsm_nvic_ipr57(dsm_nvic_ipr57),
      .dsm_nvic_ipr58(dsm_nvic_ipr58),
      .dsm_nvic_ipr59(dsm_nvic_ipr59),
      .dsm_mpu_ctrl(dsm_mpu_ctrl),
      .dsm_mpu_rnr(dsm_mpu_rnr),
      .dsm_mpu_rbar(dsm_mpu_rbar),
      .dsm_mpu_rasr(dsm_mpu_rasr),
      .dsm_ID(dsm_ID),
      .dsm_echo_to_stdout(dsm_echo_to_stdout),
      .dsm_no_tarmac(dsm_no_tarmac),
      .dsm_no_ecs(dsm_no_ecs),
      .dsm_mpu_present(dsm_mpu_present),
      .dsm_num_irq(dsm_num_irq),
      .dsm_lvl_width(dsm_lvl_width),
      .dsm_trace_lvl(dsm_trace_lvl),
      .dsm_debug_lvl(dsm_debug_lvl),
      .dsm_clkgate_present(dsm_clkgate_present),
      .dsm_reset_all_regs(dsm_reset_all_regs),
      .dsm_observation(dsm_observation),
      .dsm_wic_present(dsm_wic_present),
      .dsm_wic_lines(dsm_wic_lines),
      .dsm_bb_present(dsm_bb_present),
      .dsm_const_ahb_ctrl(dsm_const_ahb_ctrl)
`endif

       );

`ifdef ARM_DSM

  //----------------------------------------------------------------------------
  // DSM SETUP
  //----------------------------------------------------------------------------
  // Manually set DSM parameters
  assign dsm_ID = 1'b0;

  assign dsm_echo_to_stdout = 1'b0;
  assign dsm_no_tarmac = 1'b0;

  assign dsm_no_ecs = 1'b0;
  assign dsm_no_etm = 1'b0;

  assign dsm_mpu_present = MPU_PRESENT;
  assign dsm_num_irq     = NUM_IRQ;
  assign dsm_lvl_width   = LVL_WIDTH;
  assign dsm_trace_lvl   = TRACE_LVL;
  assign dsm_debug_lvl   = DEBUG_LVL;
  assign dsm_clkgate_present = CLKGATE_PRESENT;
  assign dsm_reset_all_regs = RESET_ALL_REGS;
  assign dsm_observation = OBSERVATION;
  assign dsm_wic_lines = WIC_LINES;
  assign dsm_bb_present = BB_PRESENT;
  assign dsm_const_ahb_ctrl = CONST_AHB_CTRL;
`endif

  // ---------------------------------------------------------------------------
  // WIC instantiation
  // ---------------------------------------------------------------------------

  // Remove filler bits from WicMask to fit WIC port
  assign wic_mask  = {wic_mask_isr, wic_mask_mon, wic_mask_nmi, wic_mask_rxev};
  assign int_wic_mask = wic_mask[WIC_LINES-1:0];

  // Select incoming IRQs/EDBGRQ/NMI/RXEV used by WIC
  assign int_wic_int  = {INTISR, EDBGRQ, INTNMI, RXEV};
  assign wic_int   = int_wic_int[WIC_LINES-1:0];

  cm3_wic #(WIC_PRESENT, WIC_LINES)
    u_cm3_wic
      (// Inputs
       .FCLK                (FCLK),
       .RESETn              (int_sysreset_n),
       .WICLOAD             (wic_load),
       .WICCLEAR            (wic_clear),
       .WICINT              (wic_int),
       .WICMASK             (int_wic_mask),
       .WICENREQ            (WICENREQ),
       .WICDSACKn           (wic_ds_ack_n),
       // Outputs
       .WAKEUP              (int_wake_up),
       .WICSENSE            (wic_sense),
       .WICPEND             (wic_pend),
       .WICDSREQn           (wic_ds_req_n),
       .WICENACK            (int_wic_en_ack)
       );

  // add dummy MSB to WicPend to facilitate indexing
  assign int_wic_pend    = {1'b0, wic_pend};

  // Split WicPend into component IRQs/NMI/RXEV
  assign int_wic_irq_pend = {{244-WIC_LINES{1'b0}},int_wic_pend[WIC_LINES:3]};
  assign wic_irq_pend     = mst_wic_en ? int_wic_irq_pend[239:0] : {240{1'b0}};
  assign wic_mon_pend     = mst_wic_en ? int_wic_pend[2]         : 1'b0;
  assign wic_nmi_pend     = mst_wic_en ? int_wic_pend[1]         : 1'b0;
  assign wic_rxev_pend    = mst_wic_en ? int_wic_pend[0]         : 1'b0;

  assign int_int_isr      = INTISR                 | wic_irq_pend;
  assign int_int_nmi      = INTNMI                 | wic_nmi_pend;
  assign int_rxev         = (RXEV & ~wic_sense[0]) | wic_rxev_pend;
  assign int_ext_dbg_req  = EDBGRQ                 | wic_mon_pend;

  assign combined_dbg_req = int_ext_dbg_req | etm_dbg_req;

  //----------------------------------------------------------------------------
  // WIC not present logic removal terms
  //----------------------------------------------------------------------------
  assign WAKEUP     = (WIC_PRESENT != 0) ? int_wake_up    : 1'b0;
  assign WICENACK   = (WIC_PRESENT != 0) ? int_wic_en_ack : 1'b0;
  assign mst_wic_en = (WIC_PRESENT != 0) ? 1'b1           : 1'b0;

  // ---------------------------------------------------------------------------
  // Debug port instantiation
  // ---------------------------------------------------------------------------
  DAPSWJDP #(DP_PRESENT, JTAG_PRESENT, RESET_ALL_REGS)
    uDAPSWJDP
      (// Inputs
       .nPOTRST             (int_po_trst_n),
       .nTRST               (nTRST),
       .SWCLKTCK            (SWCLKTCK),
       .SWDITMS             (SWDITMS),
       .TDI                 (TDI),
       .DAPRESETn           (dap_reset_n),
       .DAPCLK              (dap_clk),
       .DAPCLKEN            (dap_clk_en),
       .DAPRDATA            (dap_rdata),
       .DAPREADY            (dap_ready),
       .DAPSLVERR           (dap_slverr),
       .nCDBGPWRDN          (1'b1),
       .CDBGPWRUPACK        (CDBGPWRUPACK),
       .CSYSPWRUPACK        (c_sys_power_up_ack),
       .CDBGRSTACK          (1'b0),
       // Outputs
       .TDO                 (int_tdo),
       .nTDOEN              (int_tdoen_n),
       .DAPSEL              (int_dap_sel_swj),
       .DAPENABLE           (int_dap_enable_swj),
       .DAPWRITE            (int_dap_write_swj),
       .DAPABORT            (int_dap_abort_swj),
       .DAPADDR             (int_dap_addr_swj),
       .DAPWDATA            (int_dap_wdata_swj),
       .CDBGPWRUPREQ        (int_c_dbg_power_up_req),
       .CSYSPWRUPREQ        (int_c_sys_power_up_req),
       .CDBGRSTREQ          (), // Debug reset request to reset controller
       .SWDO                (int_sw_do),
       .SWDOEN              (int_sw_do_en),
       .JTAGNSW             (JTAGNSW), // JTAG/not Serial Wire Mode
       .JTAGTOP             ()  // JTAG-DP TAP controller in one of four top states
                                // (TLR, RTI, Sel-DR, Sel-IR)
     );

  assign c_sys_power_up_ack = c_sys_power_up_req & c_sys_power_up;

  //----------------------------------------------------------------------------
  // Debug not present logic removal terms (SWJ-DP)
  //----------------------------------------------------------------------------
  assign TDO                = (DP_PRESENT != 0) ? int_tdo                : 1'b0;
  assign nTDOEN             = (DP_PRESENT != 0) ? int_tdoen_n            : 1'b1;
  assign dap_sel_swj        = (DP_PRESENT != 0) ? int_dap_sel_swj        : 1'b0;
  assign dap_enable_swj     = (DP_PRESENT != 0) ? int_dap_enable_swj     : 1'b0;
  assign dap_write_swj      = (DP_PRESENT != 0) ? int_dap_write_swj      : 1'b0;
  assign dap_abort_swj      = (DP_PRESENT != 0) ? int_dap_abort_swj      : 1'b0;
  assign dap_addr_swj       = (DP_PRESENT != 0) ? int_dap_addr_swj       : {32{1'b0}};
  assign dap_wdata_swj      = (DP_PRESENT != 0) ? int_dap_wdata_swj      : {32{1'b0}};
  assign CDBGPWRUPREQ       = (DP_PRESENT != 0) ? int_c_dbg_power_up_req : 1'b0;
  assign c_sys_power_up_req = (DP_PRESENT != 0) ? int_c_sys_power_up_req : 1'b0;
  assign SWDO               = (DP_PRESENT != 0) ? int_sw_do              : 1'b0;
  assign SWDOEN             = (DP_PRESENT != 0) ? int_sw_do_en           : 1'b0;

  // Mux the output from the active DP to the AP.
  always @(dap_sel_tb or dap_enable_tb or dap_write_tb or dap_addr_tb or dap_wdata_tb or
           dap_abort_tb or dap_sel_swj or dap_enable_swj or dap_write_swj or
           dap_addr_swj or dap_wdata_swj or dap_abort_swj)
    begin
      if (dap_sel_tb)
        begin
          // Debug core access DAP interface (testbench only)
          dap_sel      = dap_sel_tb;
          dap_enable   = dap_enable_tb;
          dap_write    = dap_write_tb;
          dap_abort    = dap_abort_tb;
          dap_addr_mux = dap_addr_tb;
          dap_wdata    = dap_wdata_tb;
        end
      else
        begin
          // Use SWJ-DP
          dap_sel      = dap_sel_swj;
          dap_enable   = dap_enable_swj;
          dap_write    = dap_write_swj;
          dap_abort    = dap_abort_swj;
          dap_addr_mux = dap_addr_swj;
          dap_wdata    = dap_wdata_swj;
        end
    end

  // Mux to Power Up controls
  assign c_sys_power_up = dap_en_tb | c_sys_power_up_req;

  // Form DAP address
  assign dap_addr = {8'h00, 16'h0000, dap_addr_mux[7:0]};

  //----------------------------------------------------------------------------
  // ETM instantiation - if licensed and TRACE_LVL set accordingly
  //----------------------------------------------------------------------------

  // ETM must be clocked only when core is clocked if
  // ETM interface is active.
  CM3ETM #(TRACE_LVL, CLKGATE_PRESENT, RESET_ALL_REGS)
    uCM3ETM
      (// Inputs
       .FCLK                (HCLK),
       .PORESETn            (int_poreset_n),
       .NIDEN               (NIDEN),
       .FIFOFULLEN          (etm_fifo_full_en),
       .ETMIA               (etm_ia[31:1]),
       .ETMIVALID           (etm_ivalid),
       .ETMISTALL           (etm_istall),
       .ETMDVALID           (etm_dvalid),
       .ETMFOLD             (etm_fold),
       .ETMCANCEL           (etm_cancel),
       .ETMICCFAIL          (etm_ccfail),
       .ETMIBRANCH          (etm_branch),
       .ETMIINDBR           (etm_indirect_branch),
       .ETMISB              (etm_isb),
       .ETMINTSTAT          (ETMINTSTAT),
       .ETMINTNUM           (ETMINTNUM),
       .COREHALT            (HALTED),
       .EXTIN               (etm_ext_in),
       .MAXEXTIN            (etm_max_ext_in),
       .DWTMATCH            (etm_trigger),
       .DWTINOTD            (etm_trig_i_not_d),
       .ATREADYM            (atb_atready_etm),
       .PSEL                (ppb_psel_etm),
       .PENABLE             (ppb_penable),
       .PADDR               (ppb_paddr[11:2]),
       .PWRITE              (ppb_pwrite),
       .PWDATA              (ppb_pwdata),
       .TSVALUEB            (TSVALUEB),
       .TSCLKCHANGE         (tsclkchange),
       .SE                  (SE),
       .CGBYPASS            (CGBYPASS),
       // Outputs
       .ETMPWRUP            (int_etm_power_up),
       .ETMEN               (int_etm_en),
       .PRDATA              (int_prdata_etm),
       .ATDATAM             (int_atb_atdata_etm[7:0]),
       .ATVALIDM            (int_atb_atvalid_etm),
       .AFREADYM            (int_atb_afready_etm),
       .ETMTRIGOUT          (int_etm_trigger_out),
       .ATIDM               (int_atb_atid_etm),
       .ETMDBGRQ            (int_etm_dbg_req),
       .FIFOFULL            (int_etm_fifo_full)

`ifdef ARM_CMS_BUILD
      // DSM
      ,
      .dsm_ID(dsm_ID),
      .dsm_no_etm(dsm_no_etm),
      .dsm_trace_lvl(dsm_trace_lvl),
      .dsm_clkgate_present(dsm_clkgate_present),
      .dsm_reset_all_regs(dsm_reset_all_regs)
`endif
     );


  //----------------------------------------------------------------------------
  // TRACE not present logic removal terms (ETM)
  //----------------------------------------------------------------------------
  assign etm_dbg_req     = (TRACE_LVL > 1) ? int_etm_dbg_req     : 1'b0;
  assign etm_fifo_full   = (TRACE_LVL > 1) ? int_etm_fifo_full   : 1'b0;
  assign etm_power_up    = (TRACE_LVL > 1) ? int_etm_power_up    : 1'b0;
  assign etm_en          = (TRACE_LVL > 1) ? int_etm_en          : 1'b0;
  assign ppb_prdata_etm  = (TRACE_LVL > 1) ? int_prdata_etm      : {32{1'b0}};
  assign atb_atdata_etm  = (TRACE_LVL > 1) ? int_atb_atdata_etm  : {8{1'b0}};
  assign atb_atvalid_etm = (TRACE_LVL > 1) ? int_atb_atvalid_etm : 1'b0;
  assign etm_trigger_out = (TRACE_LVL > 1) ? int_etm_trigger_out : 1'b0;
  assign atb_atid_etm    = (TRACE_LVL > 1) ? int_atb_atid_etm    : {7{1'b0}};

  //----------------------------------------------------------------------------
  // Select correct source for TPIU depending on whether the ETM is present
  // or not.
  //----------------------------------------------------------------------------
  assign atb_valid_port1 = TRACE_LVL > 1 ? atb_atvalid_etm : at_valid_itm;
  assign atb_id1         = TRACE_LVL > 1 ? atb_atid_etm    : at_id_itm;
  assign atb_data_port1  = TRACE_LVL > 1 ? atb_atdata_etm  : at_data_itm;
  assign atb_valid_port2 = TRACE_LVL > 1 ? at_valid_itm    : 1'b0;
  assign atb_id2         = TRACE_LVL > 1 ? at_id_itm       : {7{1'b0}};
  assign atb_data_port2  = TRACE_LVL > 1 ? at_data_itm     : {8{1'b0}};

  //----------------------------------------------------------------------------
  // TPIU instantiation
  //----------------------------------------------------------------------------
  cm3_tpiu #(TRACE_LVL,0)
    u_cm3_tpiu
      (/*AUTOINST*/
       // Inputs
       .CLK                 (dclk_g),
       .CLKEN               (tpiu_en),
       .TRACECLKIN          (trace_clk_in_g),
       .RESETn              (int_poreset_n),
       .TRESETn             (t_reset_n),
       .PWRITE              (ppb_pwrite),
       .PENABLE             (ppb_penable),
       .PSEL                (ppb_pseltpiu),
       .PADDR               (ppb_paddr[11:2]),
       .PWDATA              (ppb_pwdata[12:0]),
       .ATVALID1S           (atb_valid_port1),
       .ATID1S              (atb_id1),
       .ATDATA1S            (atb_data_port1),
       .ATVALID2S           (atb_valid_port2),
       .ATID2S              (atb_id2),
       .ATDATA2S            (atb_data_port2),
       .SYNCREQ             (d_sync),
       .MAXPORTSIZE         (2'b11),
       .TRIGGER             (etm_trigger_out),
       // Outputs
       .PRDATA              (int_prdata_tpiu),
       .TPIUACTV            (int_tpiu_active),
       .TPIUBAUD            (int_tpiu_baud),
       .SWOACTIVE           (/*Can use for pin Muxing*/),
       .ATREADY1S           (int_atb_ready_port1),
       .ATREADY2S           (int_atb_ready_port2),
       .TRACECLK            (int_trace_clk),
       .TRACEDATA           (int_trace_data),
       .TRACESWO            (int_trace_swo)
       );

  //----------------------------------------------------------------------------
  // Select correct destination for TPIU outputs depending on whether the ETM is
  // present or not.
  //----------------------------------------------------------------------------
  assign atb_atready_etm = atb_ready_port1;
  assign at_ready_itm    = TRACE_LVL > 1 ? atb_ready_port2 : atb_ready_port1;

  //----------------------------------------------------------------------------
  // Trace logic removal terms (TPIU)
  //----------------------------------------------------------------------------
  assign ppb_prdata_tpiu = (TRACE_LVL > 0) ? int_prdata_tpiu     : {32{1'b0}};
  assign tpiu_active     = (TRACE_LVL > 0) ? int_tpiu_active     : 1'b0;
  assign tpiu_baud       = (TRACE_LVL > 0) ? int_tpiu_baud       : 1'b0;
  assign atb_ready_port1 = (TRACE_LVL > 0) ? int_atb_ready_port1 : 1'b1;
  assign atb_ready_port2 = (TRACE_LVL > 0) ? int_atb_ready_port2 : 1'b1;
  assign TRACECLK        = (TRACE_LVL > 0) ? int_trace_clk       : 1'b0;
  assign TRACEDATA       = (TRACE_LVL > 0) ? int_trace_data      : {4{1'b0}};
  assign trace_swo       = (TRACE_LVL > 0) ? int_trace_swo       : 1'b0;

  assign SWV = trace_swo;

  // ---------------------------------------------------------------------------
  // DAP bus slave multiplexer
  // ---------------------------------------------------------------------------

  assign dap_sel_core = (dap_addr_mux[31:24]==8'h00) && dap_sel;

  // Bus mux
  always @(dap_sel_core or dap_ready_core or dap_rdata_core or dap_slverr_core)
    begin
      if (dap_sel_core)
        // Core selected
        begin
          dap_ready  = dap_ready_core;
          dap_rdata  = dap_rdata_core;
          dap_slverr = dap_slverr_core;
        end
      else
        // Default slave is selected
        begin
          dap_ready  = 1'b1;
          dap_rdata  = {32{1'b0}};
          dap_slverr = 1'b0;
        end
    end

  // ---------------------------------------------------------------------------
  // Private Peripheral Segment
  // ---------------------------------------------------------------------------

  // Tie offs for normal system
  assign ppb_prdata_mux_tbox = {32{1'b0}};
  assign ppb_pslverr         = 1'b0;
  assign ppb_pready          = 1'b1;

  // PPB selection
  assign ppb_pseltpiu        = ppb_psel & ppb_paddr[19:12]==8'h40;
  assign ppb_psel_etm        = ppb_psel & ppb_paddr[19:12]==8'h41;
  assign ppb_psel_rom        = ppb_psel & ppb_paddr[19:12]==8'hFF;

  assign ppb_prdata_mux_tpiu = (ppb_pseltpiu) ? ppb_prdata_tpiu : {32{1'b0}};
  assign ppb_prdata_mux_etm  = (ppb_psel_etm) ? ppb_prdata_etm  : {32{1'b0}};
  assign ppb_prdata_mux_rom  = (ppb_psel_rom) ? ppb_prdata_rom  : {32{1'b0}};

  assign ppb_prdata          = (ppb_prdata_mux_tpiu | ppb_prdata_mux_etm |
                                ppb_prdata_mux_rom  | ppb_prdata_mux_tbox);

  // ---------------------------------------------------------------------------
  // ROM table instantiation
  // ---------------------------------------------------------------------------
  cm3_rom_table #(DEBUG_LVL, TRACE_LVL)
    u_cm3_rom_table
      (/*AUTOINST*/
       // Inputs
       .PCLK                (HCLK),
       .PRESETn             (int_poreset_n),
       .PSEL                (ppb_psel_rom),
       .PENABLE             (ppb_penable),
       .PADDR               (ppb_paddr[11:2]),
       .PWRITE              (ppb_pwrite),
       // Outputs
       .PRDATA              (int_prdata_rom)
       );

  //----------------------------------------------------------------------------
  // Debug logic removal terms (ROM table)
  //----------------------------------------------------------------------------
  assign ppb_prdata_rom = (DEBUG_LVL > 0) ? int_prdata_rom : {32{1'b0}};

  //----------------------------------------------------------------------------
  // Tie-offs for non testbench
  //----------------------------------------------------------------------------
  assign dap_addr_tb              = {32{1'b0}};
  assign dap_sel_tb               = 1'b0;
  assign dap_enable_tb            = 1'b0;
  assign dap_write_tb             = 1'b0;
  assign dap_wdata_tb             = {32{1'b0}};
  assign dap_abort_tb             = 1'b0;
  assign dap_en_tb                = 1'b0;

  assign etm_ext_in               = 2'b00;
  assign etm_max_ext_in           = 2'b10;
  assign etm_fifo_full_en         = 1'b1;

  // Reserved signals that must always be tied to 1
  assign stk_align_init           = 1'b1;

  // Reserved signals that must always be tied to 0
  assign ppb_lock                 = 6'b000000;
  assign vect_addr                = 10'b0000000000;
  assign vect_addr_en             = 1'b0;

  //----------------------------------------------------------------------------
  // RTL config detection
  //----------------------------------------------------------------------------
  // This section check if the RTL configuration is in the valid range. If the
  // following lines cause a compile time failure it means that the parameters
  // set or passed into this file are incorrect. They must be set to a legal
  // value to allow the compile to complete successfully.

  // Number of IRQ must be range from 1 to 240
  assign config_check_0[((NUM_IRQ > 0) & (NUM_IRQ < 241))] = 1'b1;

  // Number of bit in priority registers must be 3 to 8
  assign config_check_1[((LVL_WIDTH > 2) & (LVL_WIDTH < 9))] = 1'b1;

  // Debug level must be in range from 0 to 3
  assign config_check_2[(DEBUG_LVL >= 0) & (DEBUG_LVL < 4)] = 1'b1;

  // Trace level must be in range from 0 to 3
  assign config_check_3[(TRACE_LVL >= 0) & (TRACE_LVL < 4)] = 1'b1;

  // MPU present option can only be 0 or 1
  assign config_check_4[((MPU_PRESENT == 0) | (MPU_PRESENT == 1))] = 1'b1;

  // JTAG present option can only be 0 or 1
  assign config_check_5[((JTAG_PRESENT == 0) | (JTAG_PRESENT == 1))] = 1'b1;

  // Clock gating present option can only be 0 or 1
  assign config_check_6[((CLKGATE_PRESENT == 0) |(CLKGATE_PRESENT == 1))] = 1'b1;

  // Reset all registers option can only be 0 or 1
  assign config_check_7[((RESET_ALL_REGS == 0) | (RESET_ALL_REGS == 1))] = 1'b1;

  // Observation option can only be 0 or 1
  assign config_check_8[((OBSERVATION == 0) | (OBSERVATION == 1))] = 1'b1;

  // Trace level must be zero if debug level is 0
  assign config_check_9[((DEBUG_LVL != 0) | (TRACE_LVL == 0))] = 1'b1;

  // Number of WIC lines must be in range 3 to 3 + NUM_IRQ
  assign config_check_10[(WIC_LINES > 2) & (WIC_LINES < (NUM_IRQ + 4))] = 1'b1;

  // WIC Present option can only be 0 or 1
  assign config_check_11[((WIC_PRESENT == 0) | (WIC_PRESENT == 1))] = 1'b1;

  // Bit-banding present option can only be 0 or 1
  assign config_check_12[((BB_PRESENT == 0) | (BB_PRESENT == 1))] = 1'b1;

  // AHB constant control option can only be 0 or 1
  assign config_check_13[((CONST_AHB_CTRL == 0) | (CONST_AHB_CTRL == 1))] = 1'b1;


`ifdef TARMAC_BUILD
  //synthesis translate_off
  tarmac utarmac ( 1'b1,
                   1'b1,
                   1'b1,
                   1'b1,
                   1'b1);
  //synthesis translate_on
`endif

endmodule
