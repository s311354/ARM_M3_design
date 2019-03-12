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
//  Revision            : $Revision: $
//  Release information : CM3DesignStart-r0p0-02rel0
//
//------------------------------------------------------------------------------
// Purpose: DesignStart Cycle Model
//------------------------------------------------------------------------------
#ifndef _libcortexm3_integrationds_dsm_systemc_h_
#define _libcortexm3_integrationds_dsm_systemc_h_
#define __CARBON_SYS_INCLUDE_H__

#ifdef CARBON_SC_TRACE
#include <iostream>
#include <iomanip>
#include <string>
#include <sstream>
using namespace std;
#endif
#include <cctype>


#include "systemc.h"
#include "carbon/carbon_sc_multiwrite_signal.h"
#include "libcortexm3_integrationds_dsm.h"

// Enable preprocessor macro CM_SYSC_IO_UNIVENT_TARMAC to enable TARMAC logging support.
// Your build must also include the univent_tarmac.* files and univentUtil libraries
// To enable/disable logging at runtime, you also have to set separately documented environment variables
#ifdef CM_SYSC_IO_UNIVENT_TARMAC
  #include "univent_tarmac.h"
#endif

SC_MODULE(CORTEXM3INTEGRATIONDS_dsm)
{
  #include "carbon/carbon_scmodule.h"
  #include "carbon/carbon_valutil.h"
  #include "carbon/carbon_sctypes.h"


  // CARBON USER CODE [PRE CORTEXM3INTEGRATIONDS_dsm DECLARATIONS] BEGIN
  // CARBON USER CODE END

  // SytemC Module Ports
  sc_in<sc_logic > ISOLATEn;
  sc_in<sc_logic > RETAINn;
  sc_in<sc_logic > nTRST;
  sc_in<sc_logic > SWCLKTCK;
  sc_in<sc_logic > SWDITMS;
  sc_in<sc_logic > TDI;
  sc_in<sc_logic > PORESETn;
  sc_in<sc_logic > SYSRESETn;
  sc_in<sc_logic > RSTBYPASS;
  sc_in<sc_logic > CGBYPASS;
  sc_in<sc_logic > FCLK;
  sc_in<sc_logic > HCLK;
  sc_in<sc_logic > TRACECLKIN;
  sc_in<sc_logic > STCLK;
  sc_in<sc_lv<26> > STCALIB;
  sc_in<sc_lv<32> > AUXFAULT;
  sc_in<sc_logic > BIGEND;
  sc_in<sc_lv<240> > INTISR;
  sc_in<sc_logic > INTNMI;
  sc_in<sc_logic > HREADYI;
  sc_in<sc_lv<32> > HRDATAI;
  sc_in<sc_lv<2> > HRESPI;
  sc_in<sc_logic > IFLUSH;
  sc_in<sc_logic > HREADYD;
  sc_in<sc_lv<32> > HRDATAD;
  sc_in<sc_lv<2> > HRESPD;
  sc_in<sc_logic > EXRESPD;
  sc_in<sc_logic > SE;
  sc_in<sc_logic > HREADYS;
  sc_in<sc_lv<32> > HRDATAS;
  sc_in<sc_lv<2> > HRESPS;
  sc_in<sc_logic > EXRESPS;
  sc_in<sc_logic > EDBGRQ;
  sc_in<sc_logic > DBGRESTART;
  sc_in<sc_logic > RXEV;
  sc_in<sc_logic > SLEEPHOLDREQn;
  sc_in<sc_logic > WICENREQ;
  sc_in<sc_logic > FIXMASTERTYPE;
  sc_in<sc_lv<48> > TSVALUEB;
  sc_in<sc_logic > MPUDISABLE;
  sc_in<sc_logic > DBGEN;
  sc_in<sc_logic > NIDEN;
  sc_in<sc_logic > CDBGPWRUPACK;
  sc_in<sc_logic > DNOTITRANS;
  sc_out<sc_logic > TDO;
  sc_out<sc_logic > nTDOEN;
  sc_out<sc_logic > SWDOEN;
  sc_out<sc_logic > SWDO;
  sc_out<sc_logic > SWV;
  sc_out<sc_logic > JTAGNSW;
  sc_out<sc_logic > TRACECLK;
  sc_out<sc_lv<4> > TRACEDATA;
  sc_out<sc_lv<2> > HTRANSI;
  sc_out<sc_lv<3> > HSIZEI;
  sc_out<sc_lv<32> > HADDRI;
  sc_out<sc_lv<3> > HBURSTI;
  sc_out<sc_lv<4> > HPROTI;
  sc_out<sc_lv<2> > MEMATTRI;
  sc_out<sc_lv<2> > HTRANSD;
  sc_out<sc_lv<3> > HSIZED;
  sc_out<sc_lv<32> > HADDRD;
  sc_out<sc_lv<3> > HBURSTD;
  sc_out<sc_lv<4> > HPROTD;
  sc_out<sc_lv<2> > MEMATTRD;
  sc_out<sc_lv<2> > HMASTERD;
  sc_out<sc_logic > EXREQD;
  sc_out<sc_logic > HWRITED;
  sc_out<sc_lv<32> > HWDATAD;
  sc_out<sc_lv<2> > HTRANSS;
  sc_out<sc_lv<3> > HSIZES;
  sc_out<sc_lv<32> > HADDRS;
  sc_out<sc_lv<3> > HBURSTS;
  sc_out<sc_lv<4> > HPROTS;
  sc_out<sc_lv<2> > MEMATTRS;
  sc_out<sc_lv<2> > HMASTERS;
  sc_out<sc_logic > EXREQS;
  sc_out<sc_logic > HWRITES;
  sc_out<sc_lv<32> > HWDATAS;
  sc_out<sc_logic > HMASTLOCKS;
  sc_out<sc_lv<4> > BRCHSTAT;
  sc_out<sc_logic > HALTED;
  sc_out<sc_logic > LOCKUP;
  sc_out<sc_logic > SLEEPING;
  sc_out<sc_logic > SLEEPDEEP;
  sc_out<sc_lv<9> > ETMINTNUM;
  sc_out<sc_lv<3> > ETMINTSTAT;
  sc_out<sc_logic > SYSRESETREQ;
  sc_out<sc_logic > TXEV;
  sc_out<sc_logic > TRCENA;
  sc_out<sc_lv<8> > CURRPRI;
  sc_out<sc_logic > DBGRESTARTED;
  sc_out<sc_logic > SLEEPHOLDACKn;
  sc_out<sc_logic > GATEHCLK;
  sc_out<sc_lv<32> > HTMDHADDR;
  sc_out<sc_lv<2> > HTMDHTRANS;
  sc_out<sc_lv<3> > HTMDHSIZE;
  sc_out<sc_lv<3> > HTMDHBURST;
  sc_out<sc_lv<4> > HTMDHPROT;
  sc_out<sc_lv<32> > HTMDHWDATA;
  sc_out<sc_logic > HTMDHWRITE;
  sc_out<sc_lv<32> > HTMDHRDATA;
  sc_out<sc_logic > HTMDHREADY;
  sc_out<sc_lv<2> > HTMDHRESP;
  sc_out<sc_logic > WICENACK;
  sc_out<sc_logic > WAKEUP;
  sc_out<sc_logic > CDBGPWRUPREQ;
  sc_buffer<sc_logic > utarmac_tarmac_enable;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_ClkCount;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_cpsr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_mpu_ctrl;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_mpu_rasr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_mpu_rbar;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_mpu_rnr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iabr0;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iabr1;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iabr2;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iabr3;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iabr4;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iabr5;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iabr6;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iabr7;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icer0;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icer1;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icer2;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icer3;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icer4;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icer5;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icer6;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icer7;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icpr0;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icpr1;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icpr2;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icpr3;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icpr4;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icpr5;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icpr6;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_icpr7;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ictr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr0;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr1;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr10;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr11;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr12;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr13;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr14;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr15;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr16;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr17;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr18;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr19;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr2;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr20;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr21;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr22;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr23;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr24;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr25;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr26;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr27;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr28;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr29;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr3;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr30;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr31;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr32;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr33;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr34;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr35;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr36;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr37;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr38;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr39;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr4;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr40;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr41;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr42;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr43;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr44;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr45;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr46;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr47;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr48;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr49;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr5;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr50;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr51;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr52;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr53;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr54;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr55;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr56;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr57;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr58;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr59;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr6;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr7;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr8;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ipr9;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iser0;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iser1;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iser2;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iser3;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iser4;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iser5;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iser6;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_iser7;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ispr0;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ispr1;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ispr2;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ispr3;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ispr4;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ispr5;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ispr6;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_nvic_ispr7;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_pc;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r0;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r1;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r10;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r11;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r12;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r13;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r14;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r2;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r3;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r4;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r5;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r6;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r7;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r8;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_r9;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_actlr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_afsr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_aircr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_bfar;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_ccr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_cfsr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_cpacr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_cpuid;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_dcrdr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_demcr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_dfsr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_dhcsr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_hfsr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_icsr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_mmfar;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_scr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_shcsr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_shpr1;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_shpr2;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_shpr3;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_scs_vtor;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_syst_calib;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_syst_csr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_syst_cvr;
  sc_out<sc_lv<32> > uCORTEXM3_dsm_syst_rvr;

  static double getSimTime(void* clientData);

  virtual void start_of_simulation();
  virtual void end_of_simulation();

  /*
   * To instantiate the model without running the initialization
   * code (i.e. Verilog initial blocks) you should pass 'false' as the
   * value for 'initialize'.  This is important if you are going to
   * restore a simulation from a checkpoint file and have initialization
   * code (e.g. open file for write) that will affect the restored
   * simulation.
   */
  SC_HAS_PROCESS(CORTEXM3INTEGRATIONDS_dsm);
  CORTEXM3INTEGRATIONDS_dsm(sc_module_name inst_name, bool initialize = true, bool dumpWaves = false, CarbonWaveFileType waveType = eWaveFileTypeVCD)
  : sc_module(inst_name),
    ISOLATEn("ISOLATEn"),
    RETAINn("RETAINn"),
    nTRST("nTRST"),
    SWCLKTCK("SWCLKTCK"),
    SWDITMS("SWDITMS"),
    TDI("TDI"),
    PORESETn("PORESETn"),
    SYSRESETn("SYSRESETn"),
    RSTBYPASS("RSTBYPASS"),
    CGBYPASS("CGBYPASS"),
    FCLK("FCLK"),
    HCLK("HCLK"),
    TRACECLKIN("TRACECLKIN"),
    STCLK("STCLK"),
    STCALIB("STCALIB"),
    AUXFAULT("AUXFAULT"),
    BIGEND("BIGEND"),
    INTISR("INTISR"),
    INTNMI("INTNMI"),
    HREADYI("HREADYI"),
    HRDATAI("HRDATAI"),
    HRESPI("HRESPI"),
    IFLUSH("IFLUSH"),
    HREADYD("HREADYD"),
    HRDATAD("HRDATAD"),
    HRESPD("HRESPD"),
    EXRESPD("EXRESPD"),
    SE("SE"),
    HREADYS("HREADYS"),
    HRDATAS("HRDATAS"),
    HRESPS("HRESPS"),
    EXRESPS("EXRESPS"),
    EDBGRQ("EDBGRQ"),
    DBGRESTART("DBGRESTART"),
    RXEV("RXEV"),
    SLEEPHOLDREQn("SLEEPHOLDREQn"),
    WICENREQ("WICENREQ"),
    FIXMASTERTYPE("FIXMASTERTYPE"),
    TSVALUEB("TSVALUEB"),
    MPUDISABLE("MPUDISABLE"),
    DBGEN("DBGEN"),
    NIDEN("NIDEN"),
    CDBGPWRUPACK("CDBGPWRUPACK"),
    DNOTITRANS("DNOTITRANS"),
    TDO("TDO"),
    nTDOEN("nTDOEN"),
    SWDOEN("SWDOEN"),
    SWDO("SWDO"),
    SWV("SWV"),
    JTAGNSW("JTAGNSW"),
    TRACECLK("TRACECLK"),
    TRACEDATA("TRACEDATA"),
    HTRANSI("HTRANSI"),
    HSIZEI("HSIZEI"),
    HADDRI("HADDRI"),
    HBURSTI("HBURSTI"),
    HPROTI("HPROTI"),
    MEMATTRI("MEMATTRI"),
    HTRANSD("HTRANSD"),
    HSIZED("HSIZED"),
    HADDRD("HADDRD"),
    HBURSTD("HBURSTD"),
    HPROTD("HPROTD"),
    MEMATTRD("MEMATTRD"),
    HMASTERD("HMASTERD"),
    EXREQD("EXREQD"),
    HWRITED("HWRITED"),
    HWDATAD("HWDATAD"),
    HTRANSS("HTRANSS"),
    HSIZES("HSIZES"),
    HADDRS("HADDRS"),
    HBURSTS("HBURSTS"),
    HPROTS("HPROTS"),
    MEMATTRS("MEMATTRS"),
    HMASTERS("HMASTERS"),
    EXREQS("EXREQS"),
    HWRITES("HWRITES"),
    HWDATAS("HWDATAS"),
    HMASTLOCKS("HMASTLOCKS"),
    BRCHSTAT("BRCHSTAT"),
    HALTED("HALTED"),
    LOCKUP("LOCKUP"),
    SLEEPING("SLEEPING"),
    SLEEPDEEP("SLEEPDEEP"),
    ETMINTNUM("ETMINTNUM"),
    ETMINTSTAT("ETMINTSTAT"),
    SYSRESETREQ("SYSRESETREQ"),
    TXEV("TXEV"),
    TRCENA("TRCENA"),
    CURRPRI("CURRPRI"),
    DBGRESTARTED("DBGRESTARTED"),
    SLEEPHOLDACKn("SLEEPHOLDACKn"),
    GATEHCLK("GATEHCLK"),
    HTMDHADDR("HTMDHADDR"),
    HTMDHTRANS("HTMDHTRANS"),
    HTMDHSIZE("HTMDHSIZE"),
    HTMDHBURST("HTMDHBURST"),
    HTMDHPROT("HTMDHPROT"),
    HTMDHWDATA("HTMDHWDATA"),
    HTMDHWRITE("HTMDHWRITE"),
    HTMDHRDATA("HTMDHRDATA"),
    HTMDHREADY("HTMDHREADY"),
    HTMDHRESP("HTMDHRESP"),
    WICENACK("WICENACK"),
    WAKEUP("WAKEUP"),
    CDBGPWRUPREQ("CDBGPWRUPREQ"),
    utarmac_tarmac_enable("utarmac_tarmac_enable"),
    uCORTEXM3_dsm_ClkCount("uCORTEXM3_dsm_ClkCount"),
    uCORTEXM3_dsm_cpsr("uCORTEXM3_dsm_cpsr"),
    uCORTEXM3_dsm_mpu_ctrl("uCORTEXM3_dsm_mpu_ctrl"),
    uCORTEXM3_dsm_mpu_rasr("uCORTEXM3_dsm_mpu_rasr"),
    uCORTEXM3_dsm_mpu_rbar("uCORTEXM3_dsm_mpu_rbar"),
    uCORTEXM3_dsm_mpu_rnr("uCORTEXM3_dsm_mpu_rnr"),
    uCORTEXM3_dsm_nvic_iabr0("uCORTEXM3_dsm_nvic_iabr0"),
    uCORTEXM3_dsm_nvic_iabr1("uCORTEXM3_dsm_nvic_iabr1"),
    uCORTEXM3_dsm_nvic_iabr2("uCORTEXM3_dsm_nvic_iabr2"),
    uCORTEXM3_dsm_nvic_iabr3("uCORTEXM3_dsm_nvic_iabr3"),
    uCORTEXM3_dsm_nvic_iabr4("uCORTEXM3_dsm_nvic_iabr4"),
    uCORTEXM3_dsm_nvic_iabr5("uCORTEXM3_dsm_nvic_iabr5"),
    uCORTEXM3_dsm_nvic_iabr6("uCORTEXM3_dsm_nvic_iabr6"),
    uCORTEXM3_dsm_nvic_iabr7("uCORTEXM3_dsm_nvic_iabr7"),
    uCORTEXM3_dsm_nvic_icer0("uCORTEXM3_dsm_nvic_icer0"),
    uCORTEXM3_dsm_nvic_icer1("uCORTEXM3_dsm_nvic_icer1"),
    uCORTEXM3_dsm_nvic_icer2("uCORTEXM3_dsm_nvic_icer2"),
    uCORTEXM3_dsm_nvic_icer3("uCORTEXM3_dsm_nvic_icer3"),
    uCORTEXM3_dsm_nvic_icer4("uCORTEXM3_dsm_nvic_icer4"),
    uCORTEXM3_dsm_nvic_icer5("uCORTEXM3_dsm_nvic_icer5"),
    uCORTEXM3_dsm_nvic_icer6("uCORTEXM3_dsm_nvic_icer6"),
    uCORTEXM3_dsm_nvic_icer7("uCORTEXM3_dsm_nvic_icer7"),
    uCORTEXM3_dsm_nvic_icpr0("uCORTEXM3_dsm_nvic_icpr0"),
    uCORTEXM3_dsm_nvic_icpr1("uCORTEXM3_dsm_nvic_icpr1"),
    uCORTEXM3_dsm_nvic_icpr2("uCORTEXM3_dsm_nvic_icpr2"),
    uCORTEXM3_dsm_nvic_icpr3("uCORTEXM3_dsm_nvic_icpr3"),
    uCORTEXM3_dsm_nvic_icpr4("uCORTEXM3_dsm_nvic_icpr4"),
    uCORTEXM3_dsm_nvic_icpr5("uCORTEXM3_dsm_nvic_icpr5"),
    uCORTEXM3_dsm_nvic_icpr6("uCORTEXM3_dsm_nvic_icpr6"),
    uCORTEXM3_dsm_nvic_icpr7("uCORTEXM3_dsm_nvic_icpr7"),
    uCORTEXM3_dsm_nvic_ictr("uCORTEXM3_dsm_nvic_ictr"),
    uCORTEXM3_dsm_nvic_ipr0("uCORTEXM3_dsm_nvic_ipr0"),
    uCORTEXM3_dsm_nvic_ipr1("uCORTEXM3_dsm_nvic_ipr1"),
    uCORTEXM3_dsm_nvic_ipr10("uCORTEXM3_dsm_nvic_ipr10"),
    uCORTEXM3_dsm_nvic_ipr11("uCORTEXM3_dsm_nvic_ipr11"),
    uCORTEXM3_dsm_nvic_ipr12("uCORTEXM3_dsm_nvic_ipr12"),
    uCORTEXM3_dsm_nvic_ipr13("uCORTEXM3_dsm_nvic_ipr13"),
    uCORTEXM3_dsm_nvic_ipr14("uCORTEXM3_dsm_nvic_ipr14"),
    uCORTEXM3_dsm_nvic_ipr15("uCORTEXM3_dsm_nvic_ipr15"),
    uCORTEXM3_dsm_nvic_ipr16("uCORTEXM3_dsm_nvic_ipr16"),
    uCORTEXM3_dsm_nvic_ipr17("uCORTEXM3_dsm_nvic_ipr17"),
    uCORTEXM3_dsm_nvic_ipr18("uCORTEXM3_dsm_nvic_ipr18"),
    uCORTEXM3_dsm_nvic_ipr19("uCORTEXM3_dsm_nvic_ipr19"),
    uCORTEXM3_dsm_nvic_ipr2("uCORTEXM3_dsm_nvic_ipr2"),
    uCORTEXM3_dsm_nvic_ipr20("uCORTEXM3_dsm_nvic_ipr20"),
    uCORTEXM3_dsm_nvic_ipr21("uCORTEXM3_dsm_nvic_ipr21"),
    uCORTEXM3_dsm_nvic_ipr22("uCORTEXM3_dsm_nvic_ipr22"),
    uCORTEXM3_dsm_nvic_ipr23("uCORTEXM3_dsm_nvic_ipr23"),
    uCORTEXM3_dsm_nvic_ipr24("uCORTEXM3_dsm_nvic_ipr24"),
    uCORTEXM3_dsm_nvic_ipr25("uCORTEXM3_dsm_nvic_ipr25"),
    uCORTEXM3_dsm_nvic_ipr26("uCORTEXM3_dsm_nvic_ipr26"),
    uCORTEXM3_dsm_nvic_ipr27("uCORTEXM3_dsm_nvic_ipr27"),
    uCORTEXM3_dsm_nvic_ipr28("uCORTEXM3_dsm_nvic_ipr28"),
    uCORTEXM3_dsm_nvic_ipr29("uCORTEXM3_dsm_nvic_ipr29"),
    uCORTEXM3_dsm_nvic_ipr3("uCORTEXM3_dsm_nvic_ipr3"),
    uCORTEXM3_dsm_nvic_ipr30("uCORTEXM3_dsm_nvic_ipr30"),
    uCORTEXM3_dsm_nvic_ipr31("uCORTEXM3_dsm_nvic_ipr31"),
    uCORTEXM3_dsm_nvic_ipr32("uCORTEXM3_dsm_nvic_ipr32"),
    uCORTEXM3_dsm_nvic_ipr33("uCORTEXM3_dsm_nvic_ipr33"),
    uCORTEXM3_dsm_nvic_ipr34("uCORTEXM3_dsm_nvic_ipr34"),
    uCORTEXM3_dsm_nvic_ipr35("uCORTEXM3_dsm_nvic_ipr35"),
    uCORTEXM3_dsm_nvic_ipr36("uCORTEXM3_dsm_nvic_ipr36"),
    uCORTEXM3_dsm_nvic_ipr37("uCORTEXM3_dsm_nvic_ipr37"),
    uCORTEXM3_dsm_nvic_ipr38("uCORTEXM3_dsm_nvic_ipr38"),
    uCORTEXM3_dsm_nvic_ipr39("uCORTEXM3_dsm_nvic_ipr39"),
    uCORTEXM3_dsm_nvic_ipr4("uCORTEXM3_dsm_nvic_ipr4"),
    uCORTEXM3_dsm_nvic_ipr40("uCORTEXM3_dsm_nvic_ipr40"),
    uCORTEXM3_dsm_nvic_ipr41("uCORTEXM3_dsm_nvic_ipr41"),
    uCORTEXM3_dsm_nvic_ipr42("uCORTEXM3_dsm_nvic_ipr42"),
    uCORTEXM3_dsm_nvic_ipr43("uCORTEXM3_dsm_nvic_ipr43"),
    uCORTEXM3_dsm_nvic_ipr44("uCORTEXM3_dsm_nvic_ipr44"),
    uCORTEXM3_dsm_nvic_ipr45("uCORTEXM3_dsm_nvic_ipr45"),
    uCORTEXM3_dsm_nvic_ipr46("uCORTEXM3_dsm_nvic_ipr46"),
    uCORTEXM3_dsm_nvic_ipr47("uCORTEXM3_dsm_nvic_ipr47"),
    uCORTEXM3_dsm_nvic_ipr48("uCORTEXM3_dsm_nvic_ipr48"),
    uCORTEXM3_dsm_nvic_ipr49("uCORTEXM3_dsm_nvic_ipr49"),
    uCORTEXM3_dsm_nvic_ipr5("uCORTEXM3_dsm_nvic_ipr5"),
    uCORTEXM3_dsm_nvic_ipr50("uCORTEXM3_dsm_nvic_ipr50"),
    uCORTEXM3_dsm_nvic_ipr51("uCORTEXM3_dsm_nvic_ipr51"),
    uCORTEXM3_dsm_nvic_ipr52("uCORTEXM3_dsm_nvic_ipr52"),
    uCORTEXM3_dsm_nvic_ipr53("uCORTEXM3_dsm_nvic_ipr53"),
    uCORTEXM3_dsm_nvic_ipr54("uCORTEXM3_dsm_nvic_ipr54"),
    uCORTEXM3_dsm_nvic_ipr55("uCORTEXM3_dsm_nvic_ipr55"),
    uCORTEXM3_dsm_nvic_ipr56("uCORTEXM3_dsm_nvic_ipr56"),
    uCORTEXM3_dsm_nvic_ipr57("uCORTEXM3_dsm_nvic_ipr57"),
    uCORTEXM3_dsm_nvic_ipr58("uCORTEXM3_dsm_nvic_ipr58"),
    uCORTEXM3_dsm_nvic_ipr59("uCORTEXM3_dsm_nvic_ipr59"),
    uCORTEXM3_dsm_nvic_ipr6("uCORTEXM3_dsm_nvic_ipr6"),
    uCORTEXM3_dsm_nvic_ipr7("uCORTEXM3_dsm_nvic_ipr7"),
    uCORTEXM3_dsm_nvic_ipr8("uCORTEXM3_dsm_nvic_ipr8"),
    uCORTEXM3_dsm_nvic_ipr9("uCORTEXM3_dsm_nvic_ipr9"),
    uCORTEXM3_dsm_nvic_iser0("uCORTEXM3_dsm_nvic_iser0"),
    uCORTEXM3_dsm_nvic_iser1("uCORTEXM3_dsm_nvic_iser1"),
    uCORTEXM3_dsm_nvic_iser2("uCORTEXM3_dsm_nvic_iser2"),
    uCORTEXM3_dsm_nvic_iser3("uCORTEXM3_dsm_nvic_iser3"),
    uCORTEXM3_dsm_nvic_iser4("uCORTEXM3_dsm_nvic_iser4"),
    uCORTEXM3_dsm_nvic_iser5("uCORTEXM3_dsm_nvic_iser5"),
    uCORTEXM3_dsm_nvic_iser6("uCORTEXM3_dsm_nvic_iser6"),
    uCORTEXM3_dsm_nvic_iser7("uCORTEXM3_dsm_nvic_iser7"),
    uCORTEXM3_dsm_nvic_ispr0("uCORTEXM3_dsm_nvic_ispr0"),
    uCORTEXM3_dsm_nvic_ispr1("uCORTEXM3_dsm_nvic_ispr1"),
    uCORTEXM3_dsm_nvic_ispr2("uCORTEXM3_dsm_nvic_ispr2"),
    uCORTEXM3_dsm_nvic_ispr3("uCORTEXM3_dsm_nvic_ispr3"),
    uCORTEXM3_dsm_nvic_ispr4("uCORTEXM3_dsm_nvic_ispr4"),
    uCORTEXM3_dsm_nvic_ispr5("uCORTEXM3_dsm_nvic_ispr5"),
    uCORTEXM3_dsm_nvic_ispr6("uCORTEXM3_dsm_nvic_ispr6"),
    uCORTEXM3_dsm_nvic_ispr7("uCORTEXM3_dsm_nvic_ispr7"),
    uCORTEXM3_dsm_pc("uCORTEXM3_dsm_pc"),
    uCORTEXM3_dsm_r0("uCORTEXM3_dsm_r0"),
    uCORTEXM3_dsm_r1("uCORTEXM3_dsm_r1"),
    uCORTEXM3_dsm_r10("uCORTEXM3_dsm_r10"),
    uCORTEXM3_dsm_r11("uCORTEXM3_dsm_r11"),
    uCORTEXM3_dsm_r12("uCORTEXM3_dsm_r12"),
    uCORTEXM3_dsm_r13("uCORTEXM3_dsm_r13"),
    uCORTEXM3_dsm_r14("uCORTEXM3_dsm_r14"),
    uCORTEXM3_dsm_r2("uCORTEXM3_dsm_r2"),
    uCORTEXM3_dsm_r3("uCORTEXM3_dsm_r3"),
    uCORTEXM3_dsm_r4("uCORTEXM3_dsm_r4"),
    uCORTEXM3_dsm_r5("uCORTEXM3_dsm_r5"),
    uCORTEXM3_dsm_r6("uCORTEXM3_dsm_r6"),
    uCORTEXM3_dsm_r7("uCORTEXM3_dsm_r7"),
    uCORTEXM3_dsm_r8("uCORTEXM3_dsm_r8"),
    uCORTEXM3_dsm_r9("uCORTEXM3_dsm_r9"),
    uCORTEXM3_dsm_scs_actlr("uCORTEXM3_dsm_scs_actlr"),
    uCORTEXM3_dsm_scs_afsr("uCORTEXM3_dsm_scs_afsr"),
    uCORTEXM3_dsm_scs_aircr("uCORTEXM3_dsm_scs_aircr"),
    uCORTEXM3_dsm_scs_bfar("uCORTEXM3_dsm_scs_bfar"),
    uCORTEXM3_dsm_scs_ccr("uCORTEXM3_dsm_scs_ccr"),
    uCORTEXM3_dsm_scs_cfsr("uCORTEXM3_dsm_scs_cfsr"),
    uCORTEXM3_dsm_scs_cpacr("uCORTEXM3_dsm_scs_cpacr"),
    uCORTEXM3_dsm_scs_cpuid("uCORTEXM3_dsm_scs_cpuid"),
    uCORTEXM3_dsm_scs_dcrdr("uCORTEXM3_dsm_scs_dcrdr"),
    uCORTEXM3_dsm_scs_demcr("uCORTEXM3_dsm_scs_demcr"),
    uCORTEXM3_dsm_scs_dfsr("uCORTEXM3_dsm_scs_dfsr"),
    uCORTEXM3_dsm_scs_dhcsr("uCORTEXM3_dsm_scs_dhcsr"),
    uCORTEXM3_dsm_scs_hfsr("uCORTEXM3_dsm_scs_hfsr"),
    uCORTEXM3_dsm_scs_icsr("uCORTEXM3_dsm_scs_icsr"),
    uCORTEXM3_dsm_scs_mmfar("uCORTEXM3_dsm_scs_mmfar"),
    uCORTEXM3_dsm_scs_scr("uCORTEXM3_dsm_scs_scr"),
    uCORTEXM3_dsm_scs_shcsr("uCORTEXM3_dsm_scs_shcsr"),
    uCORTEXM3_dsm_scs_shpr1("uCORTEXM3_dsm_scs_shpr1"),
    uCORTEXM3_dsm_scs_shpr2("uCORTEXM3_dsm_scs_shpr2"),
    uCORTEXM3_dsm_scs_shpr3("uCORTEXM3_dsm_scs_shpr3"),
    uCORTEXM3_dsm_scs_vtor("uCORTEXM3_dsm_scs_vtor"),
    uCORTEXM3_dsm_syst_calib("uCORTEXM3_dsm_syst_calib"),
    uCORTEXM3_dsm_syst_csr("uCORTEXM3_dsm_syst_csr"),
    uCORTEXM3_dsm_syst_cvr("uCORTEXM3_dsm_syst_cvr"),
    uCORTEXM3_dsm_syst_rvr("uCORTEXM3_dsm_syst_rvr"),
    m_carbon_TDO(TDO),
    m_carbon_nTDOEN(nTDOEN),
    m_carbon_SWDOEN(SWDOEN),
    m_carbon_SWDO(SWDO),
    m_carbon_SWV(SWV),
    m_carbon_JTAGNSW(JTAGNSW),
    m_carbon_TRACECLK(TRACECLK),
    m_carbon_TRACEDATA(TRACEDATA),
    m_carbon_HTRANSI(HTRANSI),
    m_carbon_HSIZEI(HSIZEI),
    m_carbon_HADDRI(HADDRI),
    m_carbon_HBURSTI(HBURSTI),
    m_carbon_HPROTI(HPROTI),
    m_carbon_MEMATTRI(MEMATTRI),
    m_carbon_HTRANSD(HTRANSD),
    m_carbon_HSIZED(HSIZED),
    m_carbon_HADDRD(HADDRD),
    m_carbon_HBURSTD(HBURSTD),
    m_carbon_HPROTD(HPROTD),
    m_carbon_MEMATTRD(MEMATTRD),
    m_carbon_HMASTERD(HMASTERD),
    m_carbon_EXREQD(EXREQD),
    m_carbon_HWRITED(HWRITED),
    m_carbon_HWDATAD(HWDATAD),
    m_carbon_HTRANSS(HTRANSS),
    m_carbon_HSIZES(HSIZES),
    m_carbon_HADDRS(HADDRS),
    m_carbon_HBURSTS(HBURSTS),
    m_carbon_HPROTS(HPROTS),
    m_carbon_MEMATTRS(MEMATTRS),
    m_carbon_HMASTERS(HMASTERS),
    m_carbon_EXREQS(EXREQS),
    m_carbon_HWRITES(HWRITES),
    m_carbon_HWDATAS(HWDATAS),
    m_carbon_HMASTLOCKS(HMASTLOCKS),
    m_carbon_BRCHSTAT(BRCHSTAT),
    m_carbon_HALTED(HALTED),
    m_carbon_LOCKUP(LOCKUP),
    m_carbon_SLEEPING(SLEEPING),
    m_carbon_SLEEPDEEP(SLEEPDEEP),
    m_carbon_ETMINTNUM(ETMINTNUM),
    m_carbon_ETMINTSTAT(ETMINTSTAT),
    m_carbon_SYSRESETREQ(SYSRESETREQ),
    m_carbon_TXEV(TXEV),
    m_carbon_TRCENA(TRCENA),
    m_carbon_CURRPRI(CURRPRI),
    m_carbon_DBGRESTARTED(DBGRESTARTED),
    m_carbon_SLEEPHOLDACKn(SLEEPHOLDACKn),
    m_carbon_GATEHCLK(GATEHCLK),
    m_carbon_HTMDHADDR(HTMDHADDR),
    m_carbon_HTMDHTRANS(HTMDHTRANS),
    m_carbon_HTMDHSIZE(HTMDHSIZE),
    m_carbon_HTMDHBURST(HTMDHBURST),
    m_carbon_HTMDHPROT(HTMDHPROT),
    m_carbon_HTMDHWDATA(HTMDHWDATA),
    m_carbon_HTMDHWRITE(HTMDHWRITE),
    m_carbon_HTMDHRDATA(HTMDHRDATA),
    m_carbon_HTMDHREADY(HTMDHREADY),
    m_carbon_HTMDHRESP(HTMDHRESP),
    m_carbon_WICENACK(WICENACK),
    m_carbon_WAKEUP(WAKEUP),
    m_carbon_CDBGPWRUPREQ(CDBGPWRUPREQ),
    m_carbon_uCORTEXM3_dsm_ClkCount(uCORTEXM3_dsm_ClkCount),
    m_carbon_uCORTEXM3_dsm_cpsr(uCORTEXM3_dsm_cpsr),
    m_carbon_uCORTEXM3_dsm_mpu_ctrl(uCORTEXM3_dsm_mpu_ctrl),
    m_carbon_uCORTEXM3_dsm_mpu_rasr(uCORTEXM3_dsm_mpu_rasr),
    m_carbon_uCORTEXM3_dsm_mpu_rbar(uCORTEXM3_dsm_mpu_rbar),
    m_carbon_uCORTEXM3_dsm_mpu_rnr(uCORTEXM3_dsm_mpu_rnr),
    m_carbon_uCORTEXM3_dsm_nvic_iabr0(uCORTEXM3_dsm_nvic_iabr0),
    m_carbon_uCORTEXM3_dsm_nvic_iabr1(uCORTEXM3_dsm_nvic_iabr1),
    m_carbon_uCORTEXM3_dsm_nvic_iabr2(uCORTEXM3_dsm_nvic_iabr2),
    m_carbon_uCORTEXM3_dsm_nvic_iabr3(uCORTEXM3_dsm_nvic_iabr3),
    m_carbon_uCORTEXM3_dsm_nvic_iabr4(uCORTEXM3_dsm_nvic_iabr4),
    m_carbon_uCORTEXM3_dsm_nvic_iabr5(uCORTEXM3_dsm_nvic_iabr5),
    m_carbon_uCORTEXM3_dsm_nvic_iabr6(uCORTEXM3_dsm_nvic_iabr6),
    m_carbon_uCORTEXM3_dsm_nvic_iabr7(uCORTEXM3_dsm_nvic_iabr7),
    m_carbon_uCORTEXM3_dsm_nvic_icer0(uCORTEXM3_dsm_nvic_icer0),
    m_carbon_uCORTEXM3_dsm_nvic_icer1(uCORTEXM3_dsm_nvic_icer1),
    m_carbon_uCORTEXM3_dsm_nvic_icer2(uCORTEXM3_dsm_nvic_icer2),
    m_carbon_uCORTEXM3_dsm_nvic_icer3(uCORTEXM3_dsm_nvic_icer3),
    m_carbon_uCORTEXM3_dsm_nvic_icer4(uCORTEXM3_dsm_nvic_icer4),
    m_carbon_uCORTEXM3_dsm_nvic_icer5(uCORTEXM3_dsm_nvic_icer5),
    m_carbon_uCORTEXM3_dsm_nvic_icer6(uCORTEXM3_dsm_nvic_icer6),
    m_carbon_uCORTEXM3_dsm_nvic_icer7(uCORTEXM3_dsm_nvic_icer7),
    m_carbon_uCORTEXM3_dsm_nvic_icpr0(uCORTEXM3_dsm_nvic_icpr0),
    m_carbon_uCORTEXM3_dsm_nvic_icpr1(uCORTEXM3_dsm_nvic_icpr1),
    m_carbon_uCORTEXM3_dsm_nvic_icpr2(uCORTEXM3_dsm_nvic_icpr2),
    m_carbon_uCORTEXM3_dsm_nvic_icpr3(uCORTEXM3_dsm_nvic_icpr3),
    m_carbon_uCORTEXM3_dsm_nvic_icpr4(uCORTEXM3_dsm_nvic_icpr4),
    m_carbon_uCORTEXM3_dsm_nvic_icpr5(uCORTEXM3_dsm_nvic_icpr5),
    m_carbon_uCORTEXM3_dsm_nvic_icpr6(uCORTEXM3_dsm_nvic_icpr6),
    m_carbon_uCORTEXM3_dsm_nvic_icpr7(uCORTEXM3_dsm_nvic_icpr7),
    m_carbon_uCORTEXM3_dsm_nvic_ictr(uCORTEXM3_dsm_nvic_ictr),
    m_carbon_uCORTEXM3_dsm_nvic_ipr0(uCORTEXM3_dsm_nvic_ipr0),
    m_carbon_uCORTEXM3_dsm_nvic_ipr1(uCORTEXM3_dsm_nvic_ipr1),
    m_carbon_uCORTEXM3_dsm_nvic_ipr10(uCORTEXM3_dsm_nvic_ipr10),
    m_carbon_uCORTEXM3_dsm_nvic_ipr11(uCORTEXM3_dsm_nvic_ipr11),
    m_carbon_uCORTEXM3_dsm_nvic_ipr12(uCORTEXM3_dsm_nvic_ipr12),
    m_carbon_uCORTEXM3_dsm_nvic_ipr13(uCORTEXM3_dsm_nvic_ipr13),
    m_carbon_uCORTEXM3_dsm_nvic_ipr14(uCORTEXM3_dsm_nvic_ipr14),
    m_carbon_uCORTEXM3_dsm_nvic_ipr15(uCORTEXM3_dsm_nvic_ipr15),
    m_carbon_uCORTEXM3_dsm_nvic_ipr16(uCORTEXM3_dsm_nvic_ipr16),
    m_carbon_uCORTEXM3_dsm_nvic_ipr17(uCORTEXM3_dsm_nvic_ipr17),
    m_carbon_uCORTEXM3_dsm_nvic_ipr18(uCORTEXM3_dsm_nvic_ipr18),
    m_carbon_uCORTEXM3_dsm_nvic_ipr19(uCORTEXM3_dsm_nvic_ipr19),
    m_carbon_uCORTEXM3_dsm_nvic_ipr2(uCORTEXM3_dsm_nvic_ipr2),
    m_carbon_uCORTEXM3_dsm_nvic_ipr20(uCORTEXM3_dsm_nvic_ipr20),
    m_carbon_uCORTEXM3_dsm_nvic_ipr21(uCORTEXM3_dsm_nvic_ipr21),
    m_carbon_uCORTEXM3_dsm_nvic_ipr22(uCORTEXM3_dsm_nvic_ipr22),
    m_carbon_uCORTEXM3_dsm_nvic_ipr23(uCORTEXM3_dsm_nvic_ipr23),
    m_carbon_uCORTEXM3_dsm_nvic_ipr24(uCORTEXM3_dsm_nvic_ipr24),
    m_carbon_uCORTEXM3_dsm_nvic_ipr25(uCORTEXM3_dsm_nvic_ipr25),
    m_carbon_uCORTEXM3_dsm_nvic_ipr26(uCORTEXM3_dsm_nvic_ipr26),
    m_carbon_uCORTEXM3_dsm_nvic_ipr27(uCORTEXM3_dsm_nvic_ipr27),
    m_carbon_uCORTEXM3_dsm_nvic_ipr28(uCORTEXM3_dsm_nvic_ipr28),
    m_carbon_uCORTEXM3_dsm_nvic_ipr29(uCORTEXM3_dsm_nvic_ipr29),
    m_carbon_uCORTEXM3_dsm_nvic_ipr3(uCORTEXM3_dsm_nvic_ipr3),
    m_carbon_uCORTEXM3_dsm_nvic_ipr30(uCORTEXM3_dsm_nvic_ipr30),
    m_carbon_uCORTEXM3_dsm_nvic_ipr31(uCORTEXM3_dsm_nvic_ipr31),
    m_carbon_uCORTEXM3_dsm_nvic_ipr32(uCORTEXM3_dsm_nvic_ipr32),
    m_carbon_uCORTEXM3_dsm_nvic_ipr33(uCORTEXM3_dsm_nvic_ipr33),
    m_carbon_uCORTEXM3_dsm_nvic_ipr34(uCORTEXM3_dsm_nvic_ipr34),
    m_carbon_uCORTEXM3_dsm_nvic_ipr35(uCORTEXM3_dsm_nvic_ipr35),
    m_carbon_uCORTEXM3_dsm_nvic_ipr36(uCORTEXM3_dsm_nvic_ipr36),
    m_carbon_uCORTEXM3_dsm_nvic_ipr37(uCORTEXM3_dsm_nvic_ipr37),
    m_carbon_uCORTEXM3_dsm_nvic_ipr38(uCORTEXM3_dsm_nvic_ipr38),
    m_carbon_uCORTEXM3_dsm_nvic_ipr39(uCORTEXM3_dsm_nvic_ipr39),
    m_carbon_uCORTEXM3_dsm_nvic_ipr4(uCORTEXM3_dsm_nvic_ipr4),
    m_carbon_uCORTEXM3_dsm_nvic_ipr40(uCORTEXM3_dsm_nvic_ipr40),
    m_carbon_uCORTEXM3_dsm_nvic_ipr41(uCORTEXM3_dsm_nvic_ipr41),
    m_carbon_uCORTEXM3_dsm_nvic_ipr42(uCORTEXM3_dsm_nvic_ipr42),
    m_carbon_uCORTEXM3_dsm_nvic_ipr43(uCORTEXM3_dsm_nvic_ipr43),
    m_carbon_uCORTEXM3_dsm_nvic_ipr44(uCORTEXM3_dsm_nvic_ipr44),
    m_carbon_uCORTEXM3_dsm_nvic_ipr45(uCORTEXM3_dsm_nvic_ipr45),
    m_carbon_uCORTEXM3_dsm_nvic_ipr46(uCORTEXM3_dsm_nvic_ipr46),
    m_carbon_uCORTEXM3_dsm_nvic_ipr47(uCORTEXM3_dsm_nvic_ipr47),
    m_carbon_uCORTEXM3_dsm_nvic_ipr48(uCORTEXM3_dsm_nvic_ipr48),
    m_carbon_uCORTEXM3_dsm_nvic_ipr49(uCORTEXM3_dsm_nvic_ipr49),
    m_carbon_uCORTEXM3_dsm_nvic_ipr5(uCORTEXM3_dsm_nvic_ipr5),
    m_carbon_uCORTEXM3_dsm_nvic_ipr50(uCORTEXM3_dsm_nvic_ipr50),
    m_carbon_uCORTEXM3_dsm_nvic_ipr51(uCORTEXM3_dsm_nvic_ipr51),
    m_carbon_uCORTEXM3_dsm_nvic_ipr52(uCORTEXM3_dsm_nvic_ipr52),
    m_carbon_uCORTEXM3_dsm_nvic_ipr53(uCORTEXM3_dsm_nvic_ipr53),
    m_carbon_uCORTEXM3_dsm_nvic_ipr54(uCORTEXM3_dsm_nvic_ipr54),
    m_carbon_uCORTEXM3_dsm_nvic_ipr55(uCORTEXM3_dsm_nvic_ipr55),
    m_carbon_uCORTEXM3_dsm_nvic_ipr56(uCORTEXM3_dsm_nvic_ipr56),
    m_carbon_uCORTEXM3_dsm_nvic_ipr57(uCORTEXM3_dsm_nvic_ipr57),
    m_carbon_uCORTEXM3_dsm_nvic_ipr58(uCORTEXM3_dsm_nvic_ipr58),
    m_carbon_uCORTEXM3_dsm_nvic_ipr59(uCORTEXM3_dsm_nvic_ipr59),
    m_carbon_uCORTEXM3_dsm_nvic_ipr6(uCORTEXM3_dsm_nvic_ipr6),
    m_carbon_uCORTEXM3_dsm_nvic_ipr7(uCORTEXM3_dsm_nvic_ipr7),
    m_carbon_uCORTEXM3_dsm_nvic_ipr8(uCORTEXM3_dsm_nvic_ipr8),
    m_carbon_uCORTEXM3_dsm_nvic_ipr9(uCORTEXM3_dsm_nvic_ipr9),
    m_carbon_uCORTEXM3_dsm_nvic_iser0(uCORTEXM3_dsm_nvic_iser0),
    m_carbon_uCORTEXM3_dsm_nvic_iser1(uCORTEXM3_dsm_nvic_iser1),
    m_carbon_uCORTEXM3_dsm_nvic_iser2(uCORTEXM3_dsm_nvic_iser2),
    m_carbon_uCORTEXM3_dsm_nvic_iser3(uCORTEXM3_dsm_nvic_iser3),
    m_carbon_uCORTEXM3_dsm_nvic_iser4(uCORTEXM3_dsm_nvic_iser4),
    m_carbon_uCORTEXM3_dsm_nvic_iser5(uCORTEXM3_dsm_nvic_iser5),
    m_carbon_uCORTEXM3_dsm_nvic_iser6(uCORTEXM3_dsm_nvic_iser6),
    m_carbon_uCORTEXM3_dsm_nvic_iser7(uCORTEXM3_dsm_nvic_iser7),
    m_carbon_uCORTEXM3_dsm_nvic_ispr0(uCORTEXM3_dsm_nvic_ispr0),
    m_carbon_uCORTEXM3_dsm_nvic_ispr1(uCORTEXM3_dsm_nvic_ispr1),
    m_carbon_uCORTEXM3_dsm_nvic_ispr2(uCORTEXM3_dsm_nvic_ispr2),
    m_carbon_uCORTEXM3_dsm_nvic_ispr3(uCORTEXM3_dsm_nvic_ispr3),
    m_carbon_uCORTEXM3_dsm_nvic_ispr4(uCORTEXM3_dsm_nvic_ispr4),
    m_carbon_uCORTEXM3_dsm_nvic_ispr5(uCORTEXM3_dsm_nvic_ispr5),
    m_carbon_uCORTEXM3_dsm_nvic_ispr6(uCORTEXM3_dsm_nvic_ispr6),
    m_carbon_uCORTEXM3_dsm_nvic_ispr7(uCORTEXM3_dsm_nvic_ispr7),
    m_carbon_uCORTEXM3_dsm_pc(uCORTEXM3_dsm_pc),
    m_carbon_uCORTEXM3_dsm_r0(uCORTEXM3_dsm_r0),
    m_carbon_uCORTEXM3_dsm_r1(uCORTEXM3_dsm_r1),
    m_carbon_uCORTEXM3_dsm_r10(uCORTEXM3_dsm_r10),
    m_carbon_uCORTEXM3_dsm_r11(uCORTEXM3_dsm_r11),
    m_carbon_uCORTEXM3_dsm_r12(uCORTEXM3_dsm_r12),
    m_carbon_uCORTEXM3_dsm_r13(uCORTEXM3_dsm_r13),
    m_carbon_uCORTEXM3_dsm_r14(uCORTEXM3_dsm_r14),
    m_carbon_uCORTEXM3_dsm_r2(uCORTEXM3_dsm_r2),
    m_carbon_uCORTEXM3_dsm_r3(uCORTEXM3_dsm_r3),
    m_carbon_uCORTEXM3_dsm_r4(uCORTEXM3_dsm_r4),
    m_carbon_uCORTEXM3_dsm_r5(uCORTEXM3_dsm_r5),
    m_carbon_uCORTEXM3_dsm_r6(uCORTEXM3_dsm_r6),
    m_carbon_uCORTEXM3_dsm_r7(uCORTEXM3_dsm_r7),
    m_carbon_uCORTEXM3_dsm_r8(uCORTEXM3_dsm_r8),
    m_carbon_uCORTEXM3_dsm_r9(uCORTEXM3_dsm_r9),
    m_carbon_uCORTEXM3_dsm_scs_actlr(uCORTEXM3_dsm_scs_actlr),
    m_carbon_uCORTEXM3_dsm_scs_afsr(uCORTEXM3_dsm_scs_afsr),
    m_carbon_uCORTEXM3_dsm_scs_aircr(uCORTEXM3_dsm_scs_aircr),
    m_carbon_uCORTEXM3_dsm_scs_bfar(uCORTEXM3_dsm_scs_bfar),
    m_carbon_uCORTEXM3_dsm_scs_ccr(uCORTEXM3_dsm_scs_ccr),
    m_carbon_uCORTEXM3_dsm_scs_cfsr(uCORTEXM3_dsm_scs_cfsr),
    m_carbon_uCORTEXM3_dsm_scs_cpacr(uCORTEXM3_dsm_scs_cpacr),
    m_carbon_uCORTEXM3_dsm_scs_cpuid(uCORTEXM3_dsm_scs_cpuid),
    m_carbon_uCORTEXM3_dsm_scs_dcrdr(uCORTEXM3_dsm_scs_dcrdr),
    m_carbon_uCORTEXM3_dsm_scs_demcr(uCORTEXM3_dsm_scs_demcr),
    m_carbon_uCORTEXM3_dsm_scs_dfsr(uCORTEXM3_dsm_scs_dfsr),
    m_carbon_uCORTEXM3_dsm_scs_dhcsr(uCORTEXM3_dsm_scs_dhcsr),
    m_carbon_uCORTEXM3_dsm_scs_hfsr(uCORTEXM3_dsm_scs_hfsr),
    m_carbon_uCORTEXM3_dsm_scs_icsr(uCORTEXM3_dsm_scs_icsr),
    m_carbon_uCORTEXM3_dsm_scs_mmfar(uCORTEXM3_dsm_scs_mmfar),
    m_carbon_uCORTEXM3_dsm_scs_scr(uCORTEXM3_dsm_scs_scr),
    m_carbon_uCORTEXM3_dsm_scs_shcsr(uCORTEXM3_dsm_scs_shcsr),
    m_carbon_uCORTEXM3_dsm_scs_shpr1(uCORTEXM3_dsm_scs_shpr1),
    m_carbon_uCORTEXM3_dsm_scs_shpr2(uCORTEXM3_dsm_scs_shpr2),
    m_carbon_uCORTEXM3_dsm_scs_shpr3(uCORTEXM3_dsm_scs_shpr3),
    m_carbon_uCORTEXM3_dsm_scs_vtor(uCORTEXM3_dsm_scs_vtor),
    m_carbon_uCORTEXM3_dsm_syst_calib(uCORTEXM3_dsm_syst_calib),
    m_carbon_uCORTEXM3_dsm_syst_csr(uCORTEXM3_dsm_syst_csr),
    m_carbon_uCORTEXM3_dsm_syst_cvr(uCORTEXM3_dsm_syst_cvr),
    m_carbon_uCORTEXM3_dsm_syst_rvr(uCORTEXM3_dsm_syst_rvr)
  {
    sc_logic scheduleAllClockEdges;
    (void)scheduleAllClockEdges; // we don't always generate code that uses this, block warnings about unused
#if CARBON_DUMP_VCD
    dumpWaves = true;
    waveType = eWaveFileTypeVCD;
#endif

#if CARBON_DUMP_FSDB
    dumpWaves = true;
    waveType = eWaveFileTypeFSDB;
#endif

#if CARBON_SCHED_ALL_CLKEDGES
    scheduleAllClockEdges = true;
#else
    scheduleAllClockEdges = dumpWaves;
#endif

    carbonModelName = "CORTEXM3INTEGRATIONDS_dsm";
    carbonWaveHandle = NULL; // No wave file yet defined.

    // set these to NULL, since there are not yet any writes queued up
    mCarbonWriteData = NULL;
    mCarbonWriteFuncs = NULL;
    mCarbonDelayedWriteData = NULL;
    mCarbonDelayedWriteFuncs = NULL;

#ifndef CARBON_SC_USE_2_0
    // register a handler for generic ARM CycleModels messages
    carbonAddMsgCB(NULL, sCarbonMessage, NULL);
#endif

    // Create an instance of the ARM CycleModels Model.
       carbonModelHandle = carbon_cortexm3_integrationds_dsm_create(eCarbonAutoDB, CarbonInitFlags(eCarbon_NoInit));
    if (carbonModelHandle == NULL) {
#ifdef CARBON_SC_USE_2_0
      cerr << "Unable to create instance of ARM CycleModels model " << carbonModelName;
      exit(1);
#else
      SC_REPORT_FATAL("Carbon", "Unable to create instance of ARM CycleModels model.");
#endif
    }
    else {

  // CARBON USER CODE [PRE CORTEXM3INTEGRATIONDS_dsm INIT] BEGIN
  // CARBON USER CODE END

#ifndef CARBON_SC_USE_2_0
      // register a handler for ARM CycleModels Model-specific ARM CycleModels messages
      carbonAddMsgCB(carbonModelHandle, sCarbonMessage, NULL);
#endif

      if (initialize) {
        carbonInitialize(carbonModelHandle, NULL, NULL, NULL);

        if (dumpWaves) {
          if (waveType == eWaveFileTypeFSDB) {
            carbonSCWaveInitFSDB();
          }
          else {
            carbonSCWaveInitVCD();
          }
          carbonSCDumpVars();
        }
      }

      // a method to write the values of all outputs from the model to SystemC
      SC_METHOD( carbon_write_outputs );
      sensitive << carbon_schedule_channel.carbon_write_outputs_event;
      dont_initialize();

  // Delayed Outputs
    SC_METHOD( carbon_write_delayed_outputs );
    sensitive << carbon_schedule_channel.carbon_write_delayed_outputs_event;
    dont_initialize();

  // Register Input Change Methods
          SC_METHOD(carbon_input_change_ISOLATEn);
      sensitive << ISOLATEn;
      dont_initialize();
          SC_METHOD(carbon_input_change_RETAINn);
      sensitive << RETAINn;
      dont_initialize();
          SC_METHOD(carbon_input_change_nTRST);
      sensitive << nTRST;
      dont_initialize();
          SC_METHOD(carbon_input_change_SWCLKTCK);
      sensitive << SWCLKTCK;
      dont_initialize();
          SC_METHOD(carbon_input_change_SWDITMS);
      sensitive << SWDITMS;
      dont_initialize();
          SC_METHOD(carbon_input_change_TDI);
      sensitive << TDI;
      dont_initialize();
          SC_METHOD(carbon_input_change_PORESETn);
      sensitive << PORESETn;
      dont_initialize();
          SC_METHOD(carbon_input_change_SYSRESETn);
      sensitive << SYSRESETn;
      dont_initialize();
          SC_METHOD(carbon_input_change_RSTBYPASS);
      sensitive << RSTBYPASS;
      dont_initialize();
          SC_METHOD(carbon_input_change_CGBYPASS);
      sensitive << CGBYPASS;
      dont_initialize();
          SC_METHOD(carbon_input_change_FCLK);
      sensitive << FCLK;
      dont_initialize();
          SC_METHOD(carbon_input_change_HCLK);
      sensitive << HCLK;
      dont_initialize();
          SC_METHOD(carbon_input_change_TRACECLKIN);
      sensitive << TRACECLKIN;
      dont_initialize();
          SC_METHOD(carbon_input_change_STCLK);
      sensitive << STCLK;
      dont_initialize();
          SC_METHOD(carbon_input_change_STCALIB);
      sensitive << STCALIB;
      dont_initialize();
          SC_METHOD(carbon_input_change_AUXFAULT);
      sensitive << AUXFAULT;
      dont_initialize();
          SC_METHOD(carbon_input_change_BIGEND);
      sensitive << BIGEND;
      dont_initialize();
          SC_METHOD(carbon_input_change_INTISR);
      sensitive << INTISR;
      dont_initialize();
          SC_METHOD(carbon_input_change_INTNMI);
      sensitive << INTNMI;
      dont_initialize();
          SC_METHOD(carbon_input_change_HREADYI);
      sensitive << HREADYI;
      dont_initialize();
          SC_METHOD(carbon_input_change_HRDATAI);
      sensitive << HRDATAI;
      dont_initialize();
          SC_METHOD(carbon_input_change_HRESPI);
      sensitive << HRESPI;
      dont_initialize();
          SC_METHOD(carbon_input_change_IFLUSH);
      sensitive << IFLUSH;
      dont_initialize();
          SC_METHOD(carbon_input_change_HREADYD);
      sensitive << HREADYD;
      dont_initialize();
          SC_METHOD(carbon_input_change_HRDATAD);
      sensitive << HRDATAD;
      dont_initialize();
          SC_METHOD(carbon_input_change_HRESPD);
      sensitive << HRESPD;
      dont_initialize();
          SC_METHOD(carbon_input_change_EXRESPD);
      sensitive << EXRESPD;
      dont_initialize();
          SC_METHOD(carbon_input_change_SE);
      sensitive << SE;
      dont_initialize();
          SC_METHOD(carbon_input_change_HREADYS);
      sensitive << HREADYS;
      dont_initialize();
          SC_METHOD(carbon_input_change_HRDATAS);
      sensitive << HRDATAS;
      dont_initialize();
          SC_METHOD(carbon_input_change_HRESPS);
      sensitive << HRESPS;
      dont_initialize();
          SC_METHOD(carbon_input_change_EXRESPS);
      sensitive << EXRESPS;
      dont_initialize();
          SC_METHOD(carbon_input_change_EDBGRQ);
      sensitive << EDBGRQ;
      dont_initialize();
          SC_METHOD(carbon_input_change_DBGRESTART);
      sensitive << DBGRESTART;
      dont_initialize();
          SC_METHOD(carbon_input_change_RXEV);
      sensitive << RXEV;
      dont_initialize();
          SC_METHOD(carbon_input_change_SLEEPHOLDREQn);
      sensitive << SLEEPHOLDREQn;
      dont_initialize();
          SC_METHOD(carbon_input_change_WICENREQ);
      sensitive << WICENREQ;
      dont_initialize();
          SC_METHOD(carbon_input_change_FIXMASTERTYPE);
      sensitive << FIXMASTERTYPE;
      dont_initialize();
          SC_METHOD(carbon_input_change_TSVALUEB);
      sensitive << TSVALUEB;
      dont_initialize();
          SC_METHOD(carbon_input_change_MPUDISABLE);
      sensitive << MPUDISABLE;
      dont_initialize();
          SC_METHOD(carbon_input_change_DBGEN);
      sensitive << DBGEN;
      dont_initialize();
          SC_METHOD(carbon_input_change_NIDEN);
      sensitive << NIDEN;
      dont_initialize();
          SC_METHOD(carbon_input_change_CDBGPWRUPACK);
      sensitive << CDBGPWRUPACK;
      dont_initialize();
          SC_METHOD(carbon_input_change_DNOTITRANS);
      sensitive << DNOTITRANS;
      dont_initialize();
          SC_METHOD(carbon_input_change_utarmac_tarmac_enable);
      sensitive << utarmac_tarmac_enable;
      dont_initialize();

  // Initialize CarbonNetIDs
    m_carbon_ISOLATEn.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.ISOLATEn");
    m_carbon_RETAINn.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.RETAINn");
    m_carbon_nTRST.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.nTRST");
    m_carbon_SWCLKTCK.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SWCLKTCK");
    m_carbon_SWDITMS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SWDITMS");
    m_carbon_TDI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.TDI");
    m_carbon_PORESETn.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.PORESETn");
    m_carbon_SYSRESETn.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SYSRESETn");
    m_carbon_RSTBYPASS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.RSTBYPASS");
    m_carbon_CGBYPASS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.CGBYPASS");
    m_carbon_FCLK.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.FCLK");
    m_carbon_HCLK.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HCLK");
    m_carbon_TRACECLKIN.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.TRACECLKIN");
    m_carbon_STCLK.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.STCLK");
    m_carbon_STCALIB.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.STCALIB");
    m_carbon_AUXFAULT.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.AUXFAULT");
    m_carbon_BIGEND.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.BIGEND");
    m_carbon_INTISR.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.INTISR");
    m_carbon_INTNMI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.INTNMI");
    m_carbon_HREADYI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HREADYI");
    m_carbon_HRDATAI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HRDATAI");
    m_carbon_HRESPI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HRESPI");
    m_carbon_IFLUSH.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.IFLUSH");
    m_carbon_HREADYD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HREADYD");
    m_carbon_HRDATAD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HRDATAD");
    m_carbon_HRESPD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HRESPD");
    m_carbon_EXRESPD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.EXRESPD");
    m_carbon_SE.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SE");
    m_carbon_HREADYS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HREADYS");
    m_carbon_HRDATAS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HRDATAS");
    m_carbon_HRESPS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HRESPS");
    m_carbon_EXRESPS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.EXRESPS");
    m_carbon_EDBGRQ.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.EDBGRQ");
    m_carbon_DBGRESTART.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.DBGRESTART");
    m_carbon_RXEV.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.RXEV");
    m_carbon_SLEEPHOLDREQn.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SLEEPHOLDREQn");
    m_carbon_WICENREQ.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.WICENREQ");
    m_carbon_FIXMASTERTYPE.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.FIXMASTERTYPE");
    m_carbon_TSVALUEB.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.TSVALUEB");
    m_carbon_MPUDISABLE.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.MPUDISABLE");
    m_carbon_DBGEN.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.DBGEN");
    m_carbon_NIDEN.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.NIDEN");
    m_carbon_CDBGPWRUPACK.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.CDBGPWRUPACK");
    m_carbon_DNOTITRANS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.DNOTITRANS");
    m_carbon_TDO.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.TDO", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_nTDOEN.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.nTDOEN", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_SWDOEN.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SWDOEN", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_SWDO.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SWDO", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_SWV.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SWV", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_JTAGNSW.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.JTAGNSW", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_TRACECLK.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.TRACECLK", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_TRACEDATA.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.TRACEDATA", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTRANSI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTRANSI", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HSIZEI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HSIZEI", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HADDRI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HADDRI", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HBURSTI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HBURSTI", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HPROTI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HPROTI", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_MEMATTRI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.MEMATTRI", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTRANSD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTRANSD", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HSIZED.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HSIZED", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HADDRD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HADDRD", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HBURSTD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HBURSTD", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HPROTD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HPROTD", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_MEMATTRD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.MEMATTRD", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HMASTERD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HMASTERD", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_EXREQD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.EXREQD", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HWRITED.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HWRITED", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HWDATAD.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HWDATAD", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTRANSS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTRANSS", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HSIZES.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HSIZES", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HADDRS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HADDRS", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HBURSTS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HBURSTS", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HPROTS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HPROTS", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_MEMATTRS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.MEMATTRS", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HMASTERS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HMASTERS", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_EXREQS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.EXREQS", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HWRITES.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HWRITES", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HWDATAS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HWDATAS", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HMASTLOCKS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HMASTLOCKS", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_BRCHSTAT.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.BRCHSTAT", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HALTED.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HALTED", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_LOCKUP.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.LOCKUP", &mCarbonWriteData, &mCarbonWriteFuncs);
    m_carbon_SLEEPING.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SLEEPING", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_SLEEPDEEP.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SLEEPDEEP", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_ETMINTNUM.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.ETMINTNUM", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_ETMINTSTAT.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.ETMINTSTAT", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_SYSRESETREQ.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SYSRESETREQ", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_TXEV.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.TXEV", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_TRCENA.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.TRCENA", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_CURRPRI.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.CURRPRI", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_DBGRESTARTED.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.DBGRESTARTED", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_SLEEPHOLDACKn.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.SLEEPHOLDACKn", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_GATEHCLK.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.GATEHCLK", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTMDHADDR.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTMDHADDR", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTMDHTRANS.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTMDHTRANS", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTMDHSIZE.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTMDHSIZE", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTMDHBURST.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTMDHBURST", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTMDHPROT.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTMDHPROT", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTMDHWDATA.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTMDHWDATA", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTMDHWRITE.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTMDHWRITE", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTMDHRDATA.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTMDHRDATA", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTMDHREADY.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTMDHREADY", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_HTMDHRESP.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.HTMDHRESP", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_WICENACK.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.WICENACK", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_WAKEUP.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.WAKEUP", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_CDBGPWRUPREQ.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.CDBGPWRUPREQ", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_utarmac_tarmac_enable.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.utarmac.tarmac_enable");
    m_carbon_uCORTEXM3_dsm_ClkCount.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_ClkCount", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_cpsr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_cpsr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_mpu_ctrl.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_mpu_ctrl", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_mpu_rasr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_mpu_rasr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_mpu_rbar.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_mpu_rbar", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_mpu_rnr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_mpu_rnr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iabr0.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr0", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iabr1.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr1", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iabr2.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr2", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iabr3.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr3", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iabr4.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr4", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iabr5.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr5", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iabr6.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr6", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iabr7.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr7", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icer0.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer0", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icer1.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer1", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icer2.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer2", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icer3.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer3", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icer4.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer4", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icer5.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer5", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icer6.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer6", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icer7.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer7", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icpr0.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr0", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icpr1.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr1", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icpr2.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr2", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icpr3.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr3", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icpr4.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr4", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icpr5.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr5", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icpr6.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr6", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_icpr7.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr7", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ictr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ictr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr0.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr0", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr1.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr1", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr10.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr10", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr11.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr11", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr12.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr12", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr13.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr13", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr14.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr14", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr15.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr15", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr16.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr16", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr17.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr17", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr18.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr18", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr19.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr19", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr2.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr2", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr20.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr20", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr21.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr21", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr22.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr22", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr23.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr23", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr24.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr24", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr25.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr25", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr26.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr26", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr27.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr27", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr28.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr28", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr29.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr29", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr3.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr3", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr30.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr30", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr31.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr31", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr32.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr32", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr33.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr33", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr34.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr34", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr35.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr35", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr36.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr36", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr37.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr37", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr38.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr38", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr39.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr39", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr4.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr4", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr40.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr40", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr41.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr41", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr42.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr42", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr43.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr43", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr44.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr44", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr45.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr45", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr46.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr46", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr47.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr47", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr48.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr48", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr49.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr49", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr5.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr5", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr50.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr50", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr51.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr51", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr52.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr52", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr53.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr53", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr54.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr54", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr55.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr55", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr56.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr56", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr57.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr57", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr58.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr58", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr59.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr59", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr6.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr6", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr7.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr7", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr8.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr8", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ipr9.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr9", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iser0.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser0", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iser1.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser1", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iser2.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser2", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iser3.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser3", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iser4.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser4", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iser5.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser5", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iser6.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser6", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_iser7.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser7", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ispr0.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr0", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ispr1.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr1", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ispr2.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr2", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ispr3.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr3", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ispr4.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr4", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ispr5.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr5", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ispr6.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr6", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_nvic_ispr7.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr7", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_pc.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_pc", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r0.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r0", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r1.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r1", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r10.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r10", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r11.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r11", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r12.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r12", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r13.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r13", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r14.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r14", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r2.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r2", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r3.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r3", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r4.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r4", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r5.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r5", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r6.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r6", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r7.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r7", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r8.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r8", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_r9.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r9", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_actlr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_actlr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_afsr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_afsr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_aircr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_aircr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_bfar.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_bfar", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_ccr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_ccr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_cfsr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_cfsr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_cpacr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_cpacr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_cpuid.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_cpuid", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_dcrdr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_dcrdr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_demcr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_demcr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_dfsr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_dfsr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_dhcsr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_dhcsr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_hfsr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_hfsr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_icsr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_icsr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_mmfar.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_mmfar", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_scr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_scr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_shcsr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_shcsr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_shpr1.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_shpr1", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_shpr2.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_shpr2", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_shpr3.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_shpr3", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_scs_vtor.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_vtor", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_syst_calib.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_syst_calib", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_syst_csr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_syst_csr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_syst_cvr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_syst_cvr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);
    m_carbon_uCORTEXM3_dsm_syst_rvr.initialize(carbonModelHandle, "CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_syst_rvr", &mCarbonDelayedWriteData, &mCarbonDelayedWriteFuncs);




  // CARBON USER CODE [POST CORTEXM3INTEGRATIONDS_dsm INIT] BEGIN

  // Check to ensure running in an RTL Simulator
  dsm_carbon_arm_if_init();

  // CARBON USER CODE END

#ifdef CM_SYSC_IO_UNIVENT_TARMAC
    univent_tarmac_initialize(this->carbonModelHandle);
#endif
    }
  }

  // Release the net handles and ARM CycleModels Model when the
  // module instance is deleted.
  ~CORTEXM3INTEGRATIONDS_dsm()
  {
#ifdef CM_SYSC_IO_UNIVENT_TARMAC
    univent_tarmac_terminate();
#endif

    if (carbonModelHandle != NULL) {
      carbonDestroy(&carbonModelHandle);
    }

  }




private:


  // request_update/update object used to call carbon_schedule() once per
  // delta cycle.
  class CarbonScheduleChannel: public sc_prim_channel
  {
    CORTEXM3INTEGRATIONDS_dsm* mParent;
    CarbonObjectID *mCarbonModelHandle;
    public:
    sc_event carbon_write_outputs_event;
    sc_event carbon_write_delayed_outputs_event;
    void setCarbonModel( CarbonObjectID *cm_handle ) { mCarbonModelHandle = cm_handle; }
    void setParent(CORTEXM3INTEGRATIONDS_dsm* parent) { mParent = parent; }
    void requestSchedule()
    {
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: carbonSchedule requested." << endl;
#endif

  // CARBON USER CODE [PRE CORTEXM3INTEGRATIONDS_dsm REQUEST SCHEDULE] BEGIN
  // CARBON USER CODE END
      request_update();

  // CARBON USER CODE [POST CORTEXM3INTEGRATIONDS_dsm REQUEST SCHEDULE] BEGIN
  // CARBON USER CODE END
    }
    virtual void update() {
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: calling carbonSchedule" << endl;
#endif

  // CARBON USER CODE [PRE CORTEXM3INTEGRATIONDS_dsm SCHEDULE UPDATE] BEGIN
  // CARBON USER CODE END
            carbonSchedule( mCarbonModelHandle, sc_time_stamp().value() );
      carbon_write_outputs_event.notify( SC_ZERO_TIME );

  // CARBON USER CODE [POST CORTEXM3INTEGRATIONDS_dsm SCHEDULE UPDATE] BEGIN
  // CARBON USER CODE END
    }
  };
  void carbon_write_outputs();

  void carbon_write_delayed_outputs();
  CarbonScheduleChannel carbon_schedule_channel;

  // lists of data and functions for writing outputs and delayed outputs
  void *mCarbonWriteData;
  void *mCarbonWriteFuncs;
  void *mCarbonDelayedWriteData;
  void *mCarbonDelayedWriteFuncs;

  // interface data
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_ISOLATEn;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_RETAINn;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_nTRST;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_SWCLKTCK;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_SWDITMS;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_TDI;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_PORESETn;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_SYSRESETn;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_RSTBYPASS;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_CGBYPASS;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_FCLK;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_HCLK;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_TRACECLKIN;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_STCLK;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_STCALIB;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_AUXFAULT;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_BIGEND;
  CarbonVhmNet<Carbon2StateBuffer<8> >	m_carbon_INTISR;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_INTNMI;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_HREADYI;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_HRDATAI;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_HRESPI;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_IFLUSH;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_HREADYD;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_HRDATAD;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_HRESPD;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_EXRESPD;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_SE;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_HREADYS;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_HRDATAS;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_HRESPS;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_EXRESPS;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_EDBGRQ;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_DBGRESTART;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_RXEV;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_SLEEPHOLDREQn;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_WICENREQ;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_FIXMASTERTYPE;
  CarbonVhmNet<Carbon2StateBuffer<2> >	m_carbon_TSVALUEB;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_MPUDISABLE;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_DBGEN;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_NIDEN;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_CDBGPWRUPACK;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_DNOTITRANS;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_TDO;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_nTDOEN;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_SWDOEN;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_SWDO;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_SWV;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_JTAGNSW;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_TRACECLK;
  CarbonScOutputPort<sc_lv<4>, sc_out<sc_lv<4> >, Carbon2StateBuffer<1>, 1, 4>  m_carbon_TRACEDATA;
  CarbonScOutputPort<sc_lv<2>, sc_out<sc_lv<2> >, Carbon2StateBuffer<1>, 1, 2>  m_carbon_HTRANSI;
  CarbonScOutputPort<sc_lv<3>, sc_out<sc_lv<3> >, Carbon2StateBuffer<1>, 1, 3>  m_carbon_HSIZEI;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_HADDRI;
  CarbonScOutputPort<sc_lv<3>, sc_out<sc_lv<3> >, Carbon2StateBuffer<1>, 1, 3>  m_carbon_HBURSTI;
  CarbonScOutputPort<sc_lv<4>, sc_out<sc_lv<4> >, Carbon2StateBuffer<1>, 1, 4>  m_carbon_HPROTI;
  CarbonScOutputPort<sc_lv<2>, sc_out<sc_lv<2> >, Carbon2StateBuffer<1>, 1, 2>  m_carbon_MEMATTRI;
  CarbonScOutputPort<sc_lv<2>, sc_out<sc_lv<2> >, Carbon2StateBuffer<1>, 1, 2>  m_carbon_HTRANSD;
  CarbonScOutputPort<sc_lv<3>, sc_out<sc_lv<3> >, Carbon2StateBuffer<1>, 1, 3>  m_carbon_HSIZED;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_HADDRD;
  CarbonScOutputPort<sc_lv<3>, sc_out<sc_lv<3> >, Carbon2StateBuffer<1>, 1, 3>  m_carbon_HBURSTD;
  CarbonScOutputPort<sc_lv<4>, sc_out<sc_lv<4> >, Carbon2StateBuffer<1>, 1, 4>  m_carbon_HPROTD;
  CarbonScOutputPort<sc_lv<2>, sc_out<sc_lv<2> >, Carbon2StateBuffer<1>, 1, 2>  m_carbon_MEMATTRD;
  CarbonScOutputPort<sc_lv<2>, sc_out<sc_lv<2> >, Carbon2StateBuffer<1>, 1, 2>  m_carbon_HMASTERD;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_EXREQD;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_HWRITED;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_HWDATAD;
  CarbonScOutputPort<sc_lv<2>, sc_out<sc_lv<2> >, Carbon2StateBuffer<1>, 1, 2>  m_carbon_HTRANSS;
  CarbonScOutputPort<sc_lv<3>, sc_out<sc_lv<3> >, Carbon2StateBuffer<1>, 1, 3>  m_carbon_HSIZES;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_HADDRS;
  CarbonScOutputPort<sc_lv<3>, sc_out<sc_lv<3> >, Carbon2StateBuffer<1>, 1, 3>  m_carbon_HBURSTS;
  CarbonScOutputPort<sc_lv<4>, sc_out<sc_lv<4> >, Carbon2StateBuffer<1>, 1, 4>  m_carbon_HPROTS;
  CarbonScOutputPort<sc_lv<2>, sc_out<sc_lv<2> >, Carbon2StateBuffer<1>, 1, 2>  m_carbon_MEMATTRS;
  CarbonScOutputPort<sc_lv<2>, sc_out<sc_lv<2> >, Carbon2StateBuffer<1>, 1, 2>  m_carbon_HMASTERS;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_EXREQS;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_HWRITES;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_HWDATAS;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_HMASTLOCKS;
  CarbonScOutputPort<sc_lv<4>, sc_out<sc_lv<4> >, Carbon2StateBuffer<1>, 1, 4>  m_carbon_BRCHSTAT;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_HALTED;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_LOCKUP;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_SLEEPING;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_SLEEPDEEP;
  CarbonScOutputPort<sc_lv<9>, sc_out<sc_lv<9> >, Carbon2StateBuffer<1>, 1, 9>  m_carbon_ETMINTNUM;
  CarbonScOutputPort<sc_lv<3>, sc_out<sc_lv<3> >, Carbon2StateBuffer<1>, 1, 3>  m_carbon_ETMINTSTAT;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_SYSRESETREQ;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_TXEV;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_TRCENA;
  CarbonScOutputPort<sc_lv<8>, sc_out<sc_lv<8> >, Carbon2StateBuffer<1>, 1, 8>  m_carbon_CURRPRI;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_DBGRESTARTED;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_SLEEPHOLDACKn;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_GATEHCLK;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_HTMDHADDR;
  CarbonScOutputPort<sc_lv<2>, sc_out<sc_lv<2> >, Carbon2StateBuffer<1>, 1, 2>  m_carbon_HTMDHTRANS;
  CarbonScOutputPort<sc_lv<3>, sc_out<sc_lv<3> >, Carbon2StateBuffer<1>, 1, 3>  m_carbon_HTMDHSIZE;
  CarbonScOutputPort<sc_lv<3>, sc_out<sc_lv<3> >, Carbon2StateBuffer<1>, 1, 3>  m_carbon_HTMDHBURST;
  CarbonScOutputPort<sc_lv<4>, sc_out<sc_lv<4> >, Carbon2StateBuffer<1>, 1, 4>  m_carbon_HTMDHPROT;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_HTMDHWDATA;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_HTMDHWRITE;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_HTMDHRDATA;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_HTMDHREADY;
  CarbonScOutputPort<sc_lv<2>, sc_out<sc_lv<2> >, Carbon2StateBuffer<1>, 1, 2>  m_carbon_HTMDHRESP;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_WICENACK;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_WAKEUP;
  CarbonScOutputPort<sc_logic, sc_out<sc_logic >, Carbon2StateBuffer<1>, 1, 1>  m_carbon_CDBGPWRUPREQ;
  CarbonVhmNet<Carbon2StateBuffer<1> >	m_carbon_utarmac_tarmac_enable;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_ClkCount;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_cpsr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_mpu_ctrl;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_mpu_rasr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_mpu_rbar;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_mpu_rnr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iabr0;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iabr1;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iabr2;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iabr3;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iabr4;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iabr5;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iabr6;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iabr7;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icer0;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icer1;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icer2;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icer3;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icer4;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icer5;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icer6;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icer7;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icpr0;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icpr1;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icpr2;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icpr3;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icpr4;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icpr5;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icpr6;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_icpr7;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ictr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr0;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr1;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr10;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr11;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr12;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr13;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr14;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr15;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr16;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr17;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr18;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr19;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr2;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr20;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr21;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr22;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr23;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr24;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr25;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr26;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr27;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr28;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr29;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr3;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr30;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr31;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr32;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr33;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr34;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr35;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr36;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr37;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr38;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr39;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr4;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr40;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr41;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr42;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr43;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr44;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr45;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr46;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr47;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr48;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr49;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr5;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr50;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr51;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr52;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr53;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr54;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr55;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr56;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr57;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr58;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr59;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr6;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr7;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr8;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ipr9;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iser0;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iser1;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iser2;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iser3;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iser4;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iser5;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iser6;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_iser7;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ispr0;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ispr1;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ispr2;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ispr3;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ispr4;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ispr5;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ispr6;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_nvic_ispr7;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_pc;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r0;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r1;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r10;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r11;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r12;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r13;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r14;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r2;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r3;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r4;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r5;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r6;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r7;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r8;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_r9;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_actlr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_afsr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_aircr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_bfar;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_ccr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_cfsr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_cpacr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_cpuid;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_dcrdr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_demcr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_dfsr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_dhcsr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_hfsr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_icsr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_mmfar;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_scr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_shcsr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_shpr1;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_shpr2;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_shpr3;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_scs_vtor;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_syst_calib;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_syst_csr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_syst_cvr;
  CarbonScOutputPort<sc_lv<32>, sc_out<sc_lv<32> >, Carbon2StateBuffer<1>, 1, 32>  m_carbon_uCORTEXM3_dsm_syst_rvr;

  /* The next 2 defines control waveform dumping. See carbon_scmodule.h
   * for details about carbonSCDumpVars.
   * define CARBON_DUMP_FSDB to be 1 if you want to dump fsdb waves.
   * define CARBON_DUMP_VCD to be 1 if you want to dump vcd.
   * FSDB takes precedence over VCD.
   * The name of the file is the instance name + .vcd or .fsdb appropriately
   * Note that you can define these on the gcc compile line with -D.
   * E.g., -DCARBON_DUMP_FSDB=1

   * Beware that defining this on the gcc compile line will dump waves
   * for all ARM CycleModels wrapped designs.
   * All instances of a design can be dumped by manually changing the wrapper
   * to define one of the dump options.
   */

#ifndef CARBON_DUMP_FSDB
#define CARBON_DUMP_FSDB 0
#endif
#ifndef CARBON_DUMP_VCD
#define CARBON_DUMP_VCD 0
#endif

  /* This define allows waveforms to be updated on every clock edge.
   * But, it can be used generally without waveforms. Note that use of
   * this define impacts performance, as normally an irrelevant
   * edge of a clock is ignored.
   *
   * define CARBON_SCHED_ALL_CLKEDGES to be 1 if you want the schedule
   * function to be called on every clock edge.
   * Note that you can define this on the gcc compile line with -D.
   * E.g., -DCARBON_SCHED_ALL_CLKEDGES=1
   *
   * Be aware that defining this on the gcc compile line will cause all
   * wrapped ARM CycleModels designs to schedule on every clock edge.
   * Note also that if either CARBON_DUMP_FSDB or CARBON_DUMP_VCD are
   * defined this is automatically set to 1.
   */

#ifndef CARBON_SCHED_ALL_CLKEDGES
#define CARBON_SCHED_ALL_CLKEDGES 0
#endif

#if CARBON_DUMP_VCD || CARBON_DUMP_FSDB
#undef CARBON_SCHED_ALL_CLKEDGES
#define CARBON_SCHED_ALL_CLKEDGES 1
#endif


  void carbon_input_change_ISOLATEn()
  {

  // CARBON USER CODE [PRE INPUT ISOLATEn] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] ISOLATEn input change: value = " << ISOLATEn.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(ISOLATEn.read(), m_carbon_ISOLATEn.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_ISOLATEn.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT ISOLATEn] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_RETAINn()
  {

  // CARBON USER CODE [PRE INPUT RETAINn] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] RETAINn input change: value = " << RETAINn.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(RETAINn.read(), m_carbon_RETAINn.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_RETAINn.deposit();
;


  // CARBON USER CODE [POST INPUT RETAINn] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_nTRST()
  {

  // CARBON USER CODE [PRE INPUT nTRST] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] nTRST input change: value = " << nTRST.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(nTRST.read(), m_carbon_nTRST.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_nTRST.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT nTRST] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_SWCLKTCK()
  {

  // CARBON USER CODE [PRE INPUT SWCLKTCK] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] SWCLKTCK input change: value = " << SWCLKTCK.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(SWCLKTCK.read(), m_carbon_SWCLKTCK.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_SWCLKTCK.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT SWCLKTCK] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_SWDITMS()
  {

  // CARBON USER CODE [PRE INPUT SWDITMS] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] SWDITMS input change: value = " << SWDITMS.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(SWDITMS.read(), m_carbon_SWDITMS.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_SWDITMS.deposit();
;


  // CARBON USER CODE [POST INPUT SWDITMS] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_TDI()
  {

  // CARBON USER CODE [PRE INPUT TDI] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] TDI input change: value = " << TDI.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(TDI.read(), m_carbon_TDI.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_TDI.deposit();
;


  // CARBON USER CODE [POST INPUT TDI] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_PORESETn()
  {

  // CARBON USER CODE [PRE INPUT PORESETn] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] PORESETn input change: value = " << PORESETn.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(PORESETn.read(), m_carbon_PORESETn.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_PORESETn.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT PORESETn] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_SYSRESETn()
  {

  // CARBON USER CODE [PRE INPUT SYSRESETn] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] SYSRESETn input change: value = " << SYSRESETn.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(SYSRESETn.read(), m_carbon_SYSRESETn.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_SYSRESETn.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT SYSRESETn] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_RSTBYPASS()
  {

  // CARBON USER CODE [PRE INPUT RSTBYPASS] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] RSTBYPASS input change: value = " << RSTBYPASS.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(RSTBYPASS.read(), m_carbon_RSTBYPASS.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_RSTBYPASS.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT RSTBYPASS] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_CGBYPASS()
  {

  // CARBON USER CODE [PRE INPUT CGBYPASS] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] CGBYPASS input change: value = " << CGBYPASS.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(CGBYPASS.read(), m_carbon_CGBYPASS.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_CGBYPASS.deposit();
;


  // CARBON USER CODE [POST INPUT CGBYPASS] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_FCLK()
  {

  // CARBON USER CODE [PRE INPUT FCLK] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] FCLK input change: value = " << FCLK.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(FCLK.read(), m_carbon_FCLK.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_FCLK.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT FCLK] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_HCLK()
  {

  // CARBON USER CODE [PRE INPUT HCLK] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] HCLK input change: value = " << HCLK.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(HCLK.read(), m_carbon_HCLK.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_HCLK.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT HCLK] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_TRACECLKIN()
  {

  // CARBON USER CODE [PRE INPUT TRACECLKIN] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] TRACECLKIN input change: value = " << TRACECLKIN.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(TRACECLKIN.read(), m_carbon_TRACECLKIN.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_TRACECLKIN.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT TRACECLKIN] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_STCLK()
  {

  // CARBON USER CODE [PRE INPUT STCLK] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] STCLK input change: value = " << STCLK.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(STCLK.read(), m_carbon_STCLK.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_STCLK.deposit();
;


  // CARBON USER CODE [POST INPUT STCLK] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_STCALIB()
  {

  // CARBON USER CODE [PRE INPUT STCALIB] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] STCALIB input change: value = " << STCALIB.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 26>(STCALIB.read(), m_carbon_STCALIB.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_STCALIB.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT STCALIB] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_AUXFAULT()
  {

  // CARBON USER CODE [PRE INPUT AUXFAULT] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] AUXFAULT input change: value = " << AUXFAULT.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 32>(AUXFAULT.read(), m_carbon_AUXFAULT.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_AUXFAULT.deposit();
;


  // CARBON USER CODE [POST INPUT AUXFAULT] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_BIGEND()
  {

  // CARBON USER CODE [PRE INPUT BIGEND] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] BIGEND input change: value = " << BIGEND.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(BIGEND.read(), m_carbon_BIGEND.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_BIGEND.deposit();
;


  // CARBON USER CODE [POST INPUT BIGEND] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_INTISR()
  {

  // CARBON USER CODE [PRE INPUT INTISR] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] INTISR input change: value = " << INTISR.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<8>, 8, 240>(INTISR.read(), m_carbon_INTISR.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_INTISR.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT INTISR] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_INTNMI()
  {

  // CARBON USER CODE [PRE INPUT INTNMI] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] INTNMI input change: value = " << INTNMI.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(INTNMI.read(), m_carbon_INTNMI.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_INTNMI.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT INTNMI] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_HREADYI()
  {

  // CARBON USER CODE [PRE INPUT HREADYI] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] HREADYI input change: value = " << HREADYI.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(HREADYI.read(), m_carbon_HREADYI.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_HREADYI.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT HREADYI] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_HRDATAI()
  {

  // CARBON USER CODE [PRE INPUT HRDATAI] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] HRDATAI input change: value = " << HRDATAI.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 32>(HRDATAI.read(), m_carbon_HRDATAI.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_HRDATAI.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT HRDATAI] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_HRESPI()
  {

  // CARBON USER CODE [PRE INPUT HRESPI] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] HRESPI input change: value = " << HRESPI.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 2>(HRESPI.read(), m_carbon_HRESPI.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_HRESPI.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT HRESPI] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_IFLUSH()
  {

  // CARBON USER CODE [PRE INPUT IFLUSH] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] IFLUSH input change: value = " << IFLUSH.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(IFLUSH.read(), m_carbon_IFLUSH.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_IFLUSH.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT IFLUSH] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_HREADYD()
  {

  // CARBON USER CODE [PRE INPUT HREADYD] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] HREADYD input change: value = " << HREADYD.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(HREADYD.read(), m_carbon_HREADYD.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_HREADYD.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT HREADYD] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_HRDATAD()
  {

  // CARBON USER CODE [PRE INPUT HRDATAD] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] HRDATAD input change: value = " << HRDATAD.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 32>(HRDATAD.read(), m_carbon_HRDATAD.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_HRDATAD.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT HRDATAD] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_HRESPD()
  {

  // CARBON USER CODE [PRE INPUT HRESPD] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] HRESPD input change: value = " << HRESPD.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 2>(HRESPD.read(), m_carbon_HRESPD.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_HRESPD.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT HRESPD] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_EXRESPD()
  {

  // CARBON USER CODE [PRE INPUT EXRESPD] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] EXRESPD input change: value = " << EXRESPD.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(EXRESPD.read(), m_carbon_EXRESPD.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_EXRESPD.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT EXRESPD] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_SE()
  {

  // CARBON USER CODE [PRE INPUT SE] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] SE input change: value = " << SE.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(SE.read(), m_carbon_SE.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_SE.deposit();
;


  // CARBON USER CODE [POST INPUT SE] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_HREADYS()
  {

  // CARBON USER CODE [PRE INPUT HREADYS] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] HREADYS input change: value = " << HREADYS.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(HREADYS.read(), m_carbon_HREADYS.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_HREADYS.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT HREADYS] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_HRDATAS()
  {

  // CARBON USER CODE [PRE INPUT HRDATAS] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] HRDATAS input change: value = " << HRDATAS.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 32>(HRDATAS.read(), m_carbon_HRDATAS.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_HRDATAS.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT HRDATAS] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_HRESPS()
  {

  // CARBON USER CODE [PRE INPUT HRESPS] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] HRESPS input change: value = " << HRESPS.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 2>(HRESPS.read(), m_carbon_HRESPS.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_HRESPS.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT HRESPS] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_EXRESPS()
  {

  // CARBON USER CODE [PRE INPUT EXRESPS] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] EXRESPS input change: value = " << EXRESPS.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(EXRESPS.read(), m_carbon_EXRESPS.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_EXRESPS.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT EXRESPS] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_EDBGRQ()
  {

  // CARBON USER CODE [PRE INPUT EDBGRQ] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] EDBGRQ input change: value = " << EDBGRQ.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(EDBGRQ.read(), m_carbon_EDBGRQ.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_EDBGRQ.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT EDBGRQ] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_DBGRESTART()
  {

  // CARBON USER CODE [PRE INPUT DBGRESTART] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] DBGRESTART input change: value = " << DBGRESTART.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(DBGRESTART.read(), m_carbon_DBGRESTART.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_DBGRESTART.deposit();
;


  // CARBON USER CODE [POST INPUT DBGRESTART] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_RXEV()
  {

  // CARBON USER CODE [PRE INPUT RXEV] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] RXEV input change: value = " << RXEV.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(RXEV.read(), m_carbon_RXEV.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_RXEV.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT RXEV] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_SLEEPHOLDREQn()
  {

  // CARBON USER CODE [PRE INPUT SLEEPHOLDREQn] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] SLEEPHOLDREQn input change: value = " << SLEEPHOLDREQn.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(SLEEPHOLDREQn.read(), m_carbon_SLEEPHOLDREQn.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_SLEEPHOLDREQn.deposit();
;


  // CARBON USER CODE [POST INPUT SLEEPHOLDREQn] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_WICENREQ()
  {

  // CARBON USER CODE [PRE INPUT WICENREQ] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] WICENREQ input change: value = " << WICENREQ.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(WICENREQ.read(), m_carbon_WICENREQ.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_WICENREQ.deposit();
;


  // CARBON USER CODE [POST INPUT WICENREQ] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_FIXMASTERTYPE()
  {

  // CARBON USER CODE [PRE INPUT FIXMASTERTYPE] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] FIXMASTERTYPE input change: value = " << FIXMASTERTYPE.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(FIXMASTERTYPE.read(), m_carbon_FIXMASTERTYPE.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_FIXMASTERTYPE.deposit();
;


  // CARBON USER CODE [POST INPUT FIXMASTERTYPE] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_TSVALUEB()
  {

  // CARBON USER CODE [PRE INPUT TSVALUEB] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] TSVALUEB input change: value = " << TSVALUEB.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<2>, 2, 48>(TSVALUEB.read(), m_carbon_TSVALUEB.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_TSVALUEB.deposit();
;


  // CARBON USER CODE [POST INPUT TSVALUEB] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_MPUDISABLE()
  {

  // CARBON USER CODE [PRE INPUT MPUDISABLE] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] MPUDISABLE input change: value = " << MPUDISABLE.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(MPUDISABLE.read(), m_carbon_MPUDISABLE.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_MPUDISABLE.deposit();
;


  // CARBON USER CODE [POST INPUT MPUDISABLE] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_DBGEN()
  {

  // CARBON USER CODE [PRE INPUT DBGEN] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] DBGEN input change: value = " << DBGEN.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(DBGEN.read(), m_carbon_DBGEN.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_DBGEN.deposit();
;


  // CARBON USER CODE [POST INPUT DBGEN] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_NIDEN()
  {

  // CARBON USER CODE [PRE INPUT NIDEN] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] NIDEN input change: value = " << NIDEN.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(NIDEN.read(), m_carbon_NIDEN.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_NIDEN.deposit();
;


  // CARBON USER CODE [POST INPUT NIDEN] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_CDBGPWRUPACK()
  {

  // CARBON USER CODE [PRE INPUT CDBGPWRUPACK] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] CDBGPWRUPACK input change: value = " << CDBGPWRUPACK.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(CDBGPWRUPACK.read(), m_carbon_CDBGPWRUPACK.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_CDBGPWRUPACK.deposit();
;


  // CARBON USER CODE [POST INPUT CDBGPWRUPACK] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_DNOTITRANS()
  {

  // CARBON USER CODE [PRE INPUT DNOTITRANS] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] DNOTITRANS input change: value = " << DNOTITRANS.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(DNOTITRANS.read(), m_carbon_DNOTITRANS.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_DNOTITRANS.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT DNOTITRANS] BEGIN
  // CARBON USER CODE END
  }


  void carbon_input_change_utarmac_tarmac_enable()
  {

  // CARBON USER CODE [PRE INPUT utarmac_tarmac_enable] BEGIN
  // CARBON USER CODE END
#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] utarmac_tarmac_enable input change: value = " << utarmac_tarmac_enable.read() << endl;
#endif

    // read the new port value into the buffer for the Carbon net
    carbon_sc_to_uint32<Carbon2StateBuffer<1>, 1, 1>(utarmac_tarmac_enable.read(), m_carbon_utarmac_tarmac_enable.buffer());

    // transfer the new value of the signal to the ARM CycleModels Model
    m_carbon_utarmac_tarmac_enable.deposit();
;

    // request a call to carbonSchedule to update the ARM CycleModels Model state
    carbon_schedule_channel.requestSchedule();


  // CARBON USER CODE [POST INPUT utarmac_tarmac_enable] BEGIN
  // CARBON USER CODE END
  }


#ifndef CARBON_SC_USE_2_0
  // this function will be registered to forward any ARM CycleModels messages to the
  // SystemC report handler.
  static eCarbonMsgCBStatus sCarbonMessage(void *data, CarbonMsgSeverity sev, int, const char *text, unsigned int)
  {
    switch (sev) {
      case eCarbonMsgSuppress:
        // do nothing - message has been supressed
        break;
      case eCarbonMsgStatus:
      case eCarbonMsgNote:
        SC_REPORT_INFO("Carbon", text);
        break;
      case eCarbonMsgWarning:
        SC_REPORT_WARNING("Carbon", text);
        break;
      case eCarbonMsgError:     // Error message
      case eCarbonMsgAlert:     // Demotable Error message
        SC_REPORT_ERROR("Carbon", text);
        break;
      case eCarbonMsgFatal:     // Fatal error message
        SC_REPORT_FATAL("Carbon", text);
        break;
      default:
        SC_REPORT_ERROR("Carbon", text);
        break;
    }
    // this message has been handled; do not call any other handlers.
    return eCarbonMsgStop;
  }
#endif


  // CARBON USER CODE [POST CORTEXM3INTEGRATIONDS_dsm DECLARATIONS] BEGIN
  // CARBON USER CODE END
};



#endif  // _libcortexm3_integrationds_dsm_systemc_h_
