//------------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2017 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//  Revision            : $Revision: 143211 $
//  Release information : CM3DesignStart-r0p0-02rel0
//
//------------------------------------------------------------------------------
// Purpose: Wrapper for ARM Cycle Model
//------------------------------------------------------------------------------

module CORTEXM3INTEGRATIONDS
 (//----------------------------------------------------------------------------
  // Port declarations
  //----------------------------------------------------------------------------

  // PMU
  input  wire          ISOLATEn,          // Isolate core power domain
  input  wire          RETAINn,           // Retain core state during power-down

  // Debug
  input  wire          nTRST,             // Test reset
  input  wire          SWDITMS,           // Test Mode Select/SWDIN
  input  wire          SWCLKTCK,          // Test clock / SWCLK
  input  wire          TDI,               // Test Data In
  input  wire          CDBGPWRUPACK,      // Debug power up acknowledge

  // Miscellaneous
  input  wire          PORESETn,          // PowerOn reset
  input  wire          SYSRESETn,         // System reset
  input  wire          RSTBYPASS,         // Reset Bypass
  input  wire          CGBYPASS,          // Architectural clock gate bypass
  input  wire          FCLK,              // Free running clock
  input  wire          HCLK,              // System clock
  input  wire          TRACECLKIN,        // TPIU trace port clock
  input  wire          STCLK,             // System Tick clock
  input  wire   [25:0] STCALIB,           // System Tick calibration
  input  wire   [31:0] AUXFAULT,          // Auxillary FSR pulse input  wires
  input  wire          BIGEND,            // Static endianess select

  // Interrupt
  input  wire  [239:0] INTISR,            // Interrupts
  input  wire          INTNMI,            // Non-maskable Interrupt

  // Code (instruction & literal) bus
  input  wire          HREADYI,           // ICode-bus ready
  input  wire   [31:0] HRDATAI,           // ICode-bus read data
  input  wire    [1:0] HRESPI,            // ICode-bus transfer response
  input  wire          IFLUSH,            // ICode-bus buffer flush
  input  wire          HREADYD,           // DCode-bus ready
  input  wire   [31:0] HRDATAD,           // DCode-bus read data
  input  wire    [1:0] HRESPD,            // DCode-bus transfer response
  input  wire          EXRESPD,           // DCode-bus exclusive response

  // System Bus
  input  wire          HREADYS,           // System-bus ready
  input  wire   [31:0] HRDATAS,           // System-bus read data
  input  wire    [1:0] HRESPS,            // System-bus transfer response
  input  wire          EXRESPS,           // System-bus exclusive response

  // Sleep
  input  wire          RXEV,              // Wait for exception input  wire
  input  wire          SLEEPHOLDREQn,     // Hold core in sleep mode

  // External Debug Request
  input  wire          EDBGRQ,            // Debug Request
  input  wire          DBGRESTART,        // External Debug Restart request

  // DAP HMASTER override
  input  wire          FIXMASTERTYPE,     // Override HMASTER for AHB-AP accesses

  // WIC
  input  wire          WICENREQ,          // WIC mode Request from PMU

  // Timestamp interface
  input  wire [47:0]   TSVALUEB,          // Binary coded timestamp value

  // Scan
  input  wire          SE,                // Scan Enable

  // Logic disable
  input  wire          MPUDISABLE,        // Disable the MPU (act as default)
  input  wire          DBGEN,             // Enable debug
  input  wire          NIDEN,             // Enable non-invasive debug

  // Added for DesignStart
  // Tie-High if code mux is used
  input  wire         DNOTITRANS,         // I/DCode arbitration control

  // Debug
  output wire         TDO,                // Test Data Out
  output wire         nTDOEN,             // Test Data Out Enable
  output wire         CDBGPWRUPREQ,       // Debug power up request

  // Single Wire
  output wire         SWDO,               // SingleWire data out
  output wire         SWDOEN,             // SingleWire output enable
  output wire         JTAGNSW,            // JTAG mode(1) or SW mode(0)

  // Single Wire Viewer
  output wire         SWV,                // SingleWire Viewer Data

  // TracePort Output
  output wire         TRACECLK,           // TracePort clock reference
  output wire   [3:0] TRACEDATA,          // TracePort Data

  // HTM data
  output wire  [31:0] HTMDHADDR,          // HTM data HADDR
  output wire   [1:0] HTMDHTRANS,         // HTM data HTRANS
  output wire   [2:0] HTMDHSIZE,          // HTM data HSIZE
  output wire   [2:0] HTMDHBURST,         // HTM data HBURST
  output wire   [3:0] HTMDHPROT,          // HTM data HPROT
  output wire  [31:0] HTMDHWDATA,         // HTM data HWDATA
  output wire         HTMDHWRITE,         // HTM data HWRITE
  output wire  [31:0] HTMDHRDATA,         // HTM data HRDATA
  output wire         HTMDHREADY,         // HTM data HREADY
  output wire   [1:0] HTMDHRESP,          // HTM data HRESP

  // Code (instruction & literal) bus
  output wire   [1:0] HTRANSI,            // ICode-bus transfer type
  output wire   [2:0] HSIZEI,             // ICode-bus transfer size
  output wire  [31:0] HADDRI,             // ICode-bus address
  output wire   [2:0] HBURSTI,            // ICode-bus burst length
  output wire   [3:0] HPROTI,             // ICode-bus protection
  output wire   [1:0] MEMATTRI,           // ICode-bus memory attributes
  output wire   [1:0] HMASTERD,           // DCode-bus master
  output wire   [1:0] HTRANSD,            // DCode-bus transfer type
  output wire   [2:0] HSIZED,             // DCode-bus transfer size
  output wire  [31:0] HADDRD,             // DCode-bus address
  output wire   [2:0] HBURSTD,            // DCode-bus burst length
  output wire   [3:0] HPROTD,             // DCode-bus protection
  output wire   [1:0] MEMATTRD,           // ICode-bus memory attributes
  output wire         EXREQD,             // ICode-bus exclusive request
  output wire         HWRITED,            // DCode-bus write not read
  output wire  [31:0] HWDATAD,            // DCode-bus write data

  // System Bus
  output wire   [1:0] HMASTERS,           // System-bus master
  output wire   [1:0] HTRANSS,            // System-bus transfer type
  output wire         HWRITES,            // System-bus write not read
  output wire   [2:0] HSIZES,             // System-bus transfer size
  output wire         HMASTLOCKS,         // System-bus lock
  output wire  [31:0] HADDRS,             // System-bus address
  output wire  [31:0] HWDATAS,            // System-bus write data
  output wire   [2:0] HBURSTS,            // System-bus burst length
  output wire   [3:0] HPROTS,             // System-bus protection
  output wire   [1:0] MEMATTRS,           // System-bus memory attributes
  output wire         EXREQS,             // System-bus exclusive request

  // Core Status
  output wire   [3:0] BRCHSTAT,           // Branch status
  output wire         HALTED,             // Core is halted via debug
  output wire         DBGRESTARTED,       // External Debug Restart Ready
  output wire         LOCKUP,             // Lockup indication
  output wire         SLEEPING,           // Core is sleeping
  output wire         SLEEPDEEP,          // System can enter deep sleep
  output wire         SLEEPHOLDACKn,      // Indicate core is force in sleep mode
  output wire   [8:0] ETMINTNUM,          // Interrupt that is currently active
  output wire   [2:0] ETMINTSTAT,         // Interrupt activation status
  output wire   [7:0] CURRPRI,            // Current Int Priority
  output wire         TRCENA,             // Trace Enable

  // Reset request
  output wire         SYSRESETREQ,        // System reset request

  // Events
  output wire         TXEV,               // Event output

  // Clock gating control
  output wire         GATEHCLK,           // when high, HCLK can be turned off

  // WIC
  output wire         WICENACK,           // WIC mode acknowledge from WIC
  output wire         WAKEUP);             // Wake-up request from WIC

  wire  [31:0] pc;
  wire  [31:0] r0;
  wire  [31:0] r1;
  wire  [31:0] r2;
  wire  [31:0] r3;
  wire  [31:0] r4;
  wire  [31:0] r5;
  wire  [31:0] r6;
  wire  [31:0] r7;
  wire  [31:0] r8;
  wire  [31:0] r9;
  wire  [31:0] r10;
  wire  [31:0] r11;
  wire  [31:0] r12;
  wire  [31:0] r13;
  wire  [31:0] r14;
  wire  [31:0] cpsr;
  wire  [31:0] ClkCount;
  wire  [31:0] scs_actlr;
  wire  [31:0] scs_cpuid;
  wire  [31:0] scs_icsr;
  wire  [31:0] scs_vtor;
  wire  [31:0] scs_aircr;
  wire  [31:0] scs_scr;
  wire  [31:0] scs_ccr;
  wire  [31:0] scs_shpr1;
  wire  [31:0] scs_shpr2;
  wire  [31:0] scs_shpr3;
  wire  [31:0] scs_shcsr;
  wire  [31:0] scs_cfsr;
  wire  [31:0] scs_hfsr;
  wire  [31:0] scs_dfsr;
  wire  [31:0] scs_mmfar;
  wire  [31:0] scs_bfar;
  wire  [31:0] scs_afsr;
  wire  [31:0] scs_cpacr;
  wire  [31:0] scs_dhcsr;
  wire  [31:0] scs_dcrdr;
  wire  [31:0] scs_demcr;
  wire  [31:0] syst_csr;
  wire  [31:0] syst_rvr;
  wire  [31:0] syst_cvr;
  wire  [31:0] syst_calib;
  wire  [31:0] nvic_ictr;
  wire  [31:0] nvic_iser0;
  wire  [31:0] nvic_iser1;
  wire  [31:0] nvic_iser2;
  wire  [31:0] nvic_iser3;
  wire  [31:0] nvic_iser4;
  wire  [31:0] nvic_iser5;
  wire  [31:0] nvic_iser6;
  wire  [31:0] nvic_iser7;
  wire  [31:0] nvic_icer0;
  wire  [31:0] nvic_icer1;
  wire  [31:0] nvic_icer2;
  wire  [31:0] nvic_icer3;
  wire  [31:0] nvic_icer4;
  wire  [31:0] nvic_icer5;
  wire  [31:0] nvic_icer6;
  wire  [31:0] nvic_icer7;
  wire  [31:0] nvic_ispr0;
  wire  [31:0] nvic_ispr1;
  wire  [31:0] nvic_ispr2;
  wire  [31:0] nvic_ispr3;
  wire  [31:0] nvic_ispr4;
  wire  [31:0] nvic_ispr5;
  wire  [31:0] nvic_ispr6;
  wire  [31:0] nvic_ispr7;
  wire  [31:0] nvic_icpr0;
  wire  [31:0] nvic_icpr1;
  wire  [31:0] nvic_icpr2;
  wire  [31:0] nvic_icpr3;
  wire  [31:0] nvic_icpr4;
  wire  [31:0] nvic_icpr5;
  wire  [31:0] nvic_icpr6;
  wire  [31:0] nvic_icpr7;
  wire  [31:0] nvic_iabr0;
  wire  [31:0] nvic_iabr1;
  wire  [31:0] nvic_iabr2;
  wire  [31:0] nvic_iabr3;
  wire  [31:0] nvic_iabr4;
  wire  [31:0] nvic_iabr5;
  wire  [31:0] nvic_iabr6;
  wire  [31:0] nvic_iabr7;
  wire  [31:0] nvic_ipr0;
  wire  [31:0] nvic_ipr1;
  wire  [31:0] nvic_ipr2;
  wire  [31:0] nvic_ipr3;
  wire  [31:0] nvic_ipr4;
  wire  [31:0] nvic_ipr5;
  wire  [31:0] nvic_ipr6;
  wire  [31:0] nvic_ipr7;
  wire  [31:0] nvic_ipr8;
  wire  [31:0] nvic_ipr9;
  wire  [31:0] nvic_ipr10;
  wire  [31:0] nvic_ipr11;
  wire  [31:0] nvic_ipr12;
  wire  [31:0] nvic_ipr13;
  wire  [31:0] nvic_ipr14;
  wire  [31:0] nvic_ipr15;
  wire  [31:0] nvic_ipr16;
  wire  [31:0] nvic_ipr17;
  wire  [31:0] nvic_ipr18;
  wire  [31:0] nvic_ipr19;
  wire  [31:0] nvic_ipr20;
  wire  [31:0] nvic_ipr21;
  wire  [31:0] nvic_ipr22;
  wire  [31:0] nvic_ipr23;
  wire  [31:0] nvic_ipr24;
  wire  [31:0] nvic_ipr25;
  wire  [31:0] nvic_ipr26;
  wire  [31:0] nvic_ipr27;
  wire  [31:0] nvic_ipr28;
  wire  [31:0] nvic_ipr29;
  wire  [31:0] nvic_ipr30;
  wire  [31:0] nvic_ipr31;
  wire  [31:0] nvic_ipr32;
  wire  [31:0] nvic_ipr33;
  wire  [31:0] nvic_ipr34;
  wire  [31:0] nvic_ipr35;
  wire  [31:0] nvic_ipr36;
  wire  [31:0] nvic_ipr37;
  wire  [31:0] nvic_ipr38;
  wire  [31:0] nvic_ipr39;
  wire  [31:0] nvic_ipr40;
  wire  [31:0] nvic_ipr41;
  wire  [31:0] nvic_ipr42;
  wire  [31:0] nvic_ipr43;
  wire  [31:0] nvic_ipr44;
  wire  [31:0] nvic_ipr45;
  wire  [31:0] nvic_ipr46;
  wire  [31:0] nvic_ipr47;
  wire  [31:0] nvic_ipr48;
  wire  [31:0] nvic_ipr49;
  wire  [31:0] nvic_ipr50;
  wire  [31:0] nvic_ipr51;
  wire  [31:0] nvic_ipr52;
  wire  [31:0] nvic_ipr53;
  wire  [31:0] nvic_ipr54;
  wire  [31:0] nvic_ipr55;
  wire  [31:0] nvic_ipr56;
  wire  [31:0] nvic_ipr57;
  wire  [31:0] nvic_ipr58;
  wire  [31:0] nvic_ipr59;
  wire  [31:0] mpu_ctrl;
  wire  [31:0] mpu_rnr;
  wire  [31:0] mpu_rbar;
  wire  [31:0] mpu_rasr;

  CORTEXM3INTEGRATIONDS_dsm

    u_dsm (
       // Inputs
       .ISOLATEn       (ISOLATEn),         // Isolate core power domain
       .RETAINn        (RETAINn),          // Retain core state during power-down

       // Resets
       .PORESETn       (PORESETn),         // Power on reset - reset processor and debugSynchronous to FCLK and HCLK
       .SYSRESETn      (SYSRESETn),        // System reset   - reset processor onlySynchronous to FCLK and HCLK
       .RSTBYPASS      (RSTBYPASS),        // Reset bypass - disable internal generated reset for testing (e.gATPG)
       .CGBYPASS       (CGBYPASS),         // Clock gating bypass - disable internal clock gating for testing.
       .SE             (SE),

      // Clocks
       .FCLK           (FCLK),             // Free running clock - NVIC, SysTick, debug
       .HCLK           (HCLK),             // System clock - AHB, processor
                                           // it is separated so that it can be gated off when no debugger is attached
       .TRACECLKIN     (TRACECLKIN),
       // SysTick
       .STCLK          (STCLK),            // External reference clock for SysTick (Not really a clock, it is sampled by DFF)
       .STCALIB        (STCALIB),          // Calibration info for SysTick

       .AUXFAULT       (AUXFAULT),         // Auxiliary Fault Status Register inputs (1 cycle pulse)

       // Configuration - system
       .BIGEND         (BIGEND),           // Big Endian - select when exiting system reset
       .DNOTITRANS     (DNOTITRANS),       // I-CODE & D-CODE merging configuration.
                                           // Set to 1 when using cm3_code_mux to merge I-CODE and D-CODE
                                           // This disable I-CODE from generating a transfer when D-CODE bus need a transfer

       //SWJDAP signal for single processor mode
       .nTRST          (nTRST),            // JTAG TAP Reset
       .SWCLKTCK       (SWCLKTCK),         // SW/JTAG Clock
       .SWDITMS        (SWDITMS),          // SW Debug Data In / JTAG Test Mode Select
       .TDI            (TDI),              // JTAG TAP Data In / Alternative input function
       .CDBGPWRUPACK   (CDBGPWRUPACK),     // Debug Power Domain up acknowledge

       // IRQs
       .INTISR         (INTISR),           // Interrupts
       .INTNMI         (INTNMI),           // Non-maskable Interrupt

       // I-CODE Bus
       .HREADYI        (HREADYI),          // I-CODE bus ready
       .HRDATAI        (HRDATAI),          // I-CODE bus read data
       .HRESPI         (HRESPI),           // I-CODE bus response
       .IFLUSH         (IFLUSH),

       // D-CODE Bus
       .HREADYD        (HREADYD),          // D-CODE bus ready
       .HRDATAD        (HRDATAD),          // D-CODE bus read data
       .HRESPD         (HRESPD),           // D-CODE bus response
       .EXRESPD        (EXRESPD),          // D-CODE bus exclusive response

       // System Bus
       .HREADYS        (HREADYS),          // System bus ready
       .HRDATAS        (HRDATAS),          // System bus read data
       .HRESPS         (HRESPS),           // System bus response
       .EXRESPS        (EXRESPS),          // System bus exclusive response

           // Sleep
       .RXEV           (RXEV),             // Receive Event input
       .SLEEPHOLDREQn  (SLEEPHOLDREQn),    // Extend Sleep request

       // External Debug Request
       .EDBGRQ         (EDBGRQ),           // External Debug Request
       .DBGRESTART     (DBGRESTART),       // Debug Restart request

       // DAP HMASTER override
       .FIXMASTERTYPE  (FIXMASTERTYPE),    // Override HMASTER for AHB-AP accesses

       // WIC
       .WICENREQ       (WICENREQ),         // Enable WIC interface function

       // Timestamp interface
       .TSVALUEB       (TSVALUEB),         // Binary coded timestamp value for trace
       // Timestamp clock ratio change is rarely used

       // Configuration - debug
       .DBGEN          (DBGEN),            // Halting Debug Enable
       .NIDEN          (NIDEN),            // Non-invasive debug enable for ETM
       .MPUDISABLE     (MPUDISABLE),       // Disable MPU functionality

       // Outputs

       //SWJDAP signal for single processor mode
       .TDO            (TDO),              // JTAG TAP Data Out
       .nTDOEN         (nTDOEN),           // TDO enable
       .CDBGPWRUPREQ   (CDBGPWRUPREQ),     // Debug Power Domain up request
       .SWDO           (SWDO),             // SW Data Out
       .SWDOEN         (SWDOEN),           // SW Data Out Enable
       .JTAGNSW        (JTAGNSW),          // JTAG/not Serial Wire Mode

       // Single Wire Viewer
       .SWV            (SWV),              // SingleWire Viewer Data

       //TPIU signals for single processor mode
       .TRACECLK       (TRACECLK),         // TRACECLK output
       .TRACEDATA      (TRACEDATA),        // Trace Data

       // CoreSight AHB Trace Macrocell (HTM) bus capture interface
       .HTMDHADDR      (HTMDHADDR),        // HTM data HADDR
       .HTMDHTRANS     (HTMDHTRANS),       // HTM data HTRANS
       .HTMDHSIZE      (HTMDHSIZE),        // HTM data HSIZE
       .HTMDHBURST     (HTMDHBURST),       // HTM data HBURST
       .HTMDHPROT      (HTMDHPROT),        // HTM data HPROT
       .HTMDHWDATA     (HTMDHWDATA),       // HTM data HWDATA
       .HTMDHWRITE     (HTMDHWRITE),       // HTM data HWRITE
       .HTMDHRDATA     (HTMDHRDATA),       // HTM data HRDATA
       .HTMDHREADY     (HTMDHREADY),       // HTM data HREADY
       .HTMDHRESP      (HTMDHRESP),        // HTM data HRESP

       // AHB I-Code bus
       .HADDRI         (HADDRI),           // I-CODE bus address
       .HTRANSI        (HTRANSI),          // I-CODE bus transfer type
       .HSIZEI         (HSIZEI),           // I-CODE bus transfer size
       .HBURSTI        (HBURSTI),          // I-CODE bus burst length
       .HPROTI         (HPROTI),           // I-CODE bus protection
       .MEMATTRI       (MEMATTRI),         // I-CODE bus memory attributes

       // AHB D-Code bus
       .HADDRD         (HADDRD),           // D-CODE bus address
       .HTRANSD        (HTRANSD),          // D-CODE bus transfer type
       .HSIZED         (HSIZED),           // D-CODE bus transfer size
       .HWRITED        (HWRITED),          // D-CODE bus write not read
       .HBURSTD        (HBURSTD),          // D-CODE bus burst length
       .HPROTD         (HPROTD),           // D-CODE bus protection
       .MEMATTRD       (MEMATTRD),         // D-CODE bus memory attributes
       .HMASTERD       (HMASTERD),         // D-CODE bus master
       .HWDATAD        (HWDATAD),          // D-CODE bus write data
       .EXREQD         (EXREQD),           // D-CODE bus exclusive request

       // AHB System bus
       .HADDRS         (HADDRS),           // System bus address
       .HTRANSS        (HTRANSS),          // System bus transfer type
       .HSIZES         (HSIZES),           // System bus transfer size
       .HWRITES        (HWRITES),          // System bus write not read
       .HBURSTS        (HBURSTS),          // System bus burst length
       .HPROTS         (HPROTS),           // System bus protection
       .HMASTLOCKS     (HMASTLOCKS),       // System bus lock
       .MEMATTRS       (MEMATTRS),         // System bus memory attributes
       .HMASTERS       (HMASTERS),         // System bus master
       .HWDATAS        (HWDATAS),          // System bus write data
       .EXREQS         (EXREQS),           // System bus exclusive request

       // Status
       .BRCHSTAT       (BRCHSTAT),         // Branch State
       .HALTED         (HALTED),           // The processor is halted
       .DBGRESTARTED   (DBGRESTARTED),     // Debug Restart interface handshaking
       .LOCKUP         (LOCKUP),           // The processor is locked up
       .SLEEPING       (SLEEPING),         // The processor is in sleep mdoe (sleep/deep sleep)
       .SLEEPDEEP      (SLEEPDEEP),        // The processor is in deep sleep mode
       .SLEEPHOLDACKn  (SLEEPHOLDACKn),    // Acknowledge for SLEEPHOLDREQn
       .ETMINTNUM      (ETMINTNUM),        // Current exception number
       .ETMINTSTAT     (ETMINTSTAT),       // Exception/Interrupt activation status
       .CURRPRI        (CURRPRI),          // Current exception priority
       .TRCENA         (TRCENA),           // Trace Enable

       // Reset Request
       .SYSRESETREQ    (SYSRESETREQ),      // System Reset Request

       // Events
       .TXEV           (TXEV),             // Transmit Event

       // Clock gating control
       .GATEHCLK       (GATEHCLK),         // when high, HCLK can be turned off

       .WAKEUP         (WAKEUP),           // Wake up request from WIC to PMU

       .WICENACK       (WICENACK),         // Acknowledge for WICENREQ - WIC operation deep sleep mode
// DSM specific signals
        .uCORTEXM3_dsm_pc(pc),
        .uCORTEXM3_dsm_r0(r0),
        .uCORTEXM3_dsm_r1(r1),
        .uCORTEXM3_dsm_r2(r2),
        .uCORTEXM3_dsm_r3(r3),
        .uCORTEXM3_dsm_r4(r4),
        .uCORTEXM3_dsm_r5(r5),
        .uCORTEXM3_dsm_r6(r6),
        .uCORTEXM3_dsm_r7(r7),
        .uCORTEXM3_dsm_r8(r8),
        .uCORTEXM3_dsm_r9(r9),
        .uCORTEXM3_dsm_r10(r10),
        .uCORTEXM3_dsm_r11(r11),
        .uCORTEXM3_dsm_r12(r12),
        .uCORTEXM3_dsm_r13(r13),
        .uCORTEXM3_dsm_r14(r14),
        .uCORTEXM3_dsm_cpsr(cpsr),
        .uCORTEXM3_dsm_ClkCount(ClkCount),
        .uCORTEXM3_dsm_scs_actlr(scs_actlr),
        .uCORTEXM3_dsm_scs_cpuid(scs_cpuid),
        .uCORTEXM3_dsm_scs_icsr(scs_icsr),
        .uCORTEXM3_dsm_scs_vtor(scs_vtor),
        .uCORTEXM3_dsm_scs_aircr(scs_aircr),
        .uCORTEXM3_dsm_scs_scr(scs_scr),
        .uCORTEXM3_dsm_scs_ccr(scs_ccr),
        .uCORTEXM3_dsm_scs_shpr1(scs_shpr1),
        .uCORTEXM3_dsm_scs_shpr2(scs_shpr2),
        .uCORTEXM3_dsm_scs_shpr3(scs_shpr3),
        .uCORTEXM3_dsm_scs_shcsr(scs_shcsr),
        .uCORTEXM3_dsm_scs_cfsr(scs_cfsr),
        .uCORTEXM3_dsm_scs_hfsr(scs_hfsr),
        .uCORTEXM3_dsm_scs_dfsr(scs_dfsr),
        .uCORTEXM3_dsm_scs_mmfar(scs_mmfar),
        .uCORTEXM3_dsm_scs_bfar(scs_bfar),
        .uCORTEXM3_dsm_scs_afsr(scs_afsr),
        .uCORTEXM3_dsm_scs_cpacr(scs_cpacr),
        .uCORTEXM3_dsm_scs_dhcsr(scs_dhcsr),
        .uCORTEXM3_dsm_scs_dcrdr(scs_dcrdr),
        .uCORTEXM3_dsm_scs_demcr(scs_demcr),
        .uCORTEXM3_dsm_syst_csr(syst_csr),
        .uCORTEXM3_dsm_syst_rvr(syst_rvr),
        .uCORTEXM3_dsm_syst_cvr(syst_cvr),
        .uCORTEXM3_dsm_syst_calib(syst_calib),
        .uCORTEXM3_dsm_nvic_ictr(nvic_ictr),
        .uCORTEXM3_dsm_nvic_iser0(nvic_iser0),
        .uCORTEXM3_dsm_nvic_iser1(nvic_iser1),
        .uCORTEXM3_dsm_nvic_iser2(nvic_iser2),
        .uCORTEXM3_dsm_nvic_iser3(nvic_iser3),
        .uCORTEXM3_dsm_nvic_iser4(nvic_iser4),
        .uCORTEXM3_dsm_nvic_iser5(nvic_iser5),
        .uCORTEXM3_dsm_nvic_iser6(nvic_iser6),
        .uCORTEXM3_dsm_nvic_iser7(nvic_iser7),
        .uCORTEXM3_dsm_nvic_icer0(nvic_icer0),
        .uCORTEXM3_dsm_nvic_icer1(nvic_icer1),
        .uCORTEXM3_dsm_nvic_icer2(nvic_icer2),
        .uCORTEXM3_dsm_nvic_icer3(nvic_icer3),
        .uCORTEXM3_dsm_nvic_icer4(nvic_icer4),
        .uCORTEXM3_dsm_nvic_icer5(nvic_icer5),
        .uCORTEXM3_dsm_nvic_icer6(nvic_icer6),
        .uCORTEXM3_dsm_nvic_icer7(nvic_icer7),
        .uCORTEXM3_dsm_nvic_ispr0(nvic_ispr0),
        .uCORTEXM3_dsm_nvic_ispr1(nvic_ispr1),
        .uCORTEXM3_dsm_nvic_ispr2(nvic_ispr2),
        .uCORTEXM3_dsm_nvic_ispr3(nvic_ispr3),
        .uCORTEXM3_dsm_nvic_ispr4(nvic_ispr4),
        .uCORTEXM3_dsm_nvic_ispr5(nvic_ispr5),
        .uCORTEXM3_dsm_nvic_ispr6(nvic_ispr6),
        .uCORTEXM3_dsm_nvic_ispr7(nvic_ispr7),
        .uCORTEXM3_dsm_nvic_icpr0(nvic_icpr0),
        .uCORTEXM3_dsm_nvic_icpr1(nvic_icpr1),
        .uCORTEXM3_dsm_nvic_icpr2(nvic_icpr2),
        .uCORTEXM3_dsm_nvic_icpr3(nvic_icpr3),
        .uCORTEXM3_dsm_nvic_icpr4(nvic_icpr4),
        .uCORTEXM3_dsm_nvic_icpr5(nvic_icpr5),
        .uCORTEXM3_dsm_nvic_icpr6(nvic_icpr6),
        .uCORTEXM3_dsm_nvic_icpr7(nvic_icpr7),
        .uCORTEXM3_dsm_nvic_iabr0(nvic_iabr0),
        .uCORTEXM3_dsm_nvic_iabr1(nvic_iabr1),
        .uCORTEXM3_dsm_nvic_iabr2(nvic_iabr2),
        .uCORTEXM3_dsm_nvic_iabr3(nvic_iabr3),
        .uCORTEXM3_dsm_nvic_iabr4(nvic_iabr4),
        .uCORTEXM3_dsm_nvic_iabr5(nvic_iabr5),
        .uCORTEXM3_dsm_nvic_iabr6(nvic_iabr6),
        .uCORTEXM3_dsm_nvic_iabr7(nvic_iabr7),
        .uCORTEXM3_dsm_nvic_ipr0(nvic_ipr0),
        .uCORTEXM3_dsm_nvic_ipr1(nvic_ipr1),
        .uCORTEXM3_dsm_nvic_ipr2(nvic_ipr2),
        .uCORTEXM3_dsm_nvic_ipr3(nvic_ipr3),
        .uCORTEXM3_dsm_nvic_ipr4(nvic_ipr4),
        .uCORTEXM3_dsm_nvic_ipr5(nvic_ipr5),
        .uCORTEXM3_dsm_nvic_ipr6(nvic_ipr6),
        .uCORTEXM3_dsm_nvic_ipr7(nvic_ipr7),
        .uCORTEXM3_dsm_nvic_ipr8(nvic_ipr8),
        .uCORTEXM3_dsm_nvic_ipr9(nvic_ipr9),
        .uCORTEXM3_dsm_nvic_ipr10(nvic_ipr10),
        .uCORTEXM3_dsm_nvic_ipr11(nvic_ipr11),
        .uCORTEXM3_dsm_nvic_ipr12(nvic_ipr12),
        .uCORTEXM3_dsm_nvic_ipr13(nvic_ipr13),
        .uCORTEXM3_dsm_nvic_ipr14(nvic_ipr14),
        .uCORTEXM3_dsm_nvic_ipr15(nvic_ipr15),
        .uCORTEXM3_dsm_nvic_ipr16(nvic_ipr16),
        .uCORTEXM3_dsm_nvic_ipr17(nvic_ipr17),
        .uCORTEXM3_dsm_nvic_ipr18(nvic_ipr18),
        .uCORTEXM3_dsm_nvic_ipr19(nvic_ipr19),
        .uCORTEXM3_dsm_nvic_ipr20(nvic_ipr20),
        .uCORTEXM3_dsm_nvic_ipr21(nvic_ipr21),
        .uCORTEXM3_dsm_nvic_ipr22(nvic_ipr22),
        .uCORTEXM3_dsm_nvic_ipr23(nvic_ipr23),
        .uCORTEXM3_dsm_nvic_ipr24(nvic_ipr24),
        .uCORTEXM3_dsm_nvic_ipr25(nvic_ipr25),
        .uCORTEXM3_dsm_nvic_ipr26(nvic_ipr26),
        .uCORTEXM3_dsm_nvic_ipr27(nvic_ipr27),
        .uCORTEXM3_dsm_nvic_ipr28(nvic_ipr28),
        .uCORTEXM3_dsm_nvic_ipr29(nvic_ipr29),
        .uCORTEXM3_dsm_nvic_ipr30(nvic_ipr30),
        .uCORTEXM3_dsm_nvic_ipr31(nvic_ipr31),
        .uCORTEXM3_dsm_nvic_ipr32(nvic_ipr32),
        .uCORTEXM3_dsm_nvic_ipr33(nvic_ipr33),
        .uCORTEXM3_dsm_nvic_ipr34(nvic_ipr34),
        .uCORTEXM3_dsm_nvic_ipr35(nvic_ipr35),
        .uCORTEXM3_dsm_nvic_ipr36(nvic_ipr36),
        .uCORTEXM3_dsm_nvic_ipr37(nvic_ipr37),
        .uCORTEXM3_dsm_nvic_ipr38(nvic_ipr38),
        .uCORTEXM3_dsm_nvic_ipr39(nvic_ipr39),
        .uCORTEXM3_dsm_nvic_ipr40(nvic_ipr40),
        .uCORTEXM3_dsm_nvic_ipr41(nvic_ipr41),
        .uCORTEXM3_dsm_nvic_ipr42(nvic_ipr42),
        .uCORTEXM3_dsm_nvic_ipr43(nvic_ipr43),
        .uCORTEXM3_dsm_nvic_ipr44(nvic_ipr44),
        .uCORTEXM3_dsm_nvic_ipr45(nvic_ipr45),
        .uCORTEXM3_dsm_nvic_ipr46(nvic_ipr46),
        .uCORTEXM3_dsm_nvic_ipr47(nvic_ipr47),
        .uCORTEXM3_dsm_nvic_ipr48(nvic_ipr48),
        .uCORTEXM3_dsm_nvic_ipr49(nvic_ipr49),
        .uCORTEXM3_dsm_nvic_ipr50(nvic_ipr50),
        .uCORTEXM3_dsm_nvic_ipr51(nvic_ipr51),
        .uCORTEXM3_dsm_nvic_ipr52(nvic_ipr52),
        .uCORTEXM3_dsm_nvic_ipr53(nvic_ipr53),
        .uCORTEXM3_dsm_nvic_ipr54(nvic_ipr54),
        .uCORTEXM3_dsm_nvic_ipr55(nvic_ipr55),
        .uCORTEXM3_dsm_nvic_ipr56(nvic_ipr56),
        .uCORTEXM3_dsm_nvic_ipr57(nvic_ipr57),
        .uCORTEXM3_dsm_nvic_ipr58(nvic_ipr58),
        .uCORTEXM3_dsm_nvic_ipr59(nvic_ipr59),
        .uCORTEXM3_dsm_mpu_ctrl(mpu_ctrl),
        .uCORTEXM3_dsm_mpu_rnr(mpu_rnr),
        .uCORTEXM3_dsm_mpu_rbar(mpu_rbar),
        .uCORTEXM3_dsm_mpu_rasr(mpu_rasr)
   );

endmodule
