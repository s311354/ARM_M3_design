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

#include "CORTEXM3INTEGRATIONDS_dsm.h"

#ifdef MTI_SYSTEMC
  SC_MODULE_EXPORT(CORTEXM3INTEGRATIONDS_dsm);
#endif

#ifdef NC_SYSTEMC
  NCSC_MODULE_EXPORT(CORTEXM3INTEGRATIONDS_dsm);
#endif

void CORTEXM3INTEGRATIONDS_dsm::start_of_simulation()
{

  // CARBON USER CODE [PRE CORTEXM3INTEGRATIONDS_dsmStart Of Simulation] BEGIN
  if (getenv("TARMAC_ENABLE"))
  {
    utarmac_tarmac_enable = sc_logic('1');
  }
  // CARBON USER CODE END

  // CARBON USER CODE [POST CORTEXM3INTEGRATIONDS_dsmStart Of Simulation] BEGIN
  // CARBON USER CODE END
}

void CORTEXM3INTEGRATIONDS_dsm::end_of_simulation()
{

  // CARBON USER CODE [PRE CORTEXM3INTEGRATIONDS_dsmEnd Of Simulation] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST CORTEXM3INTEGRATIONDS_dsmEnd Of Simulation] BEGIN
  // CARBON USER CODE END
}

void CORTEXM3INTEGRATIONDS_dsm::end_of_elaboration()
{

  // CARBON USER CODE [PRE CORTEXM3INTEGRATIONDS_dsmEnd Of Elaboration] BEGIN
  // CARBON USER CODE END
  carbon_schedule_channel.setCarbonModel( carbonModelHandle );
  carbon_schedule_channel.setParent( this );



  // Setup initial values for testing for changes also for SystemC
      { // port TDO, Carbon net CORTEXM3INTEGRATIONDS_dsm.TDO

  // CARBON USER CODE [PRE INIT OUT PORT TDO] BEGIN
  // CARBON USER CODE END
      m_carbon_TDO.net().examine();
;
       m_carbon_TDO.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT TDO] BEGIN
  // CARBON USER CODE END
    }
    { // port nTDOEN, Carbon net CORTEXM3INTEGRATIONDS_dsm.nTDOEN

  // CARBON USER CODE [PRE INIT OUT PORT nTDOEN] BEGIN
  // CARBON USER CODE END
      m_carbon_nTDOEN.net().examine();
;
       m_carbon_nTDOEN.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT nTDOEN] BEGIN
  // CARBON USER CODE END
    }
    { // port SWDOEN, Carbon net CORTEXM3INTEGRATIONDS_dsm.SWDOEN

  // CARBON USER CODE [PRE INIT OUT PORT SWDOEN] BEGIN
  // CARBON USER CODE END
      m_carbon_SWDOEN.net().examine();
;
       m_carbon_SWDOEN.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT SWDOEN] BEGIN
  // CARBON USER CODE END
    }
    { // port SWDO, Carbon net CORTEXM3INTEGRATIONDS_dsm.SWDO

  // CARBON USER CODE [PRE INIT OUT PORT SWDO] BEGIN
  // CARBON USER CODE END
      m_carbon_SWDO.net().examine();
;
       m_carbon_SWDO.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT SWDO] BEGIN
  // CARBON USER CODE END
    }
    { // port SWV, Carbon net CORTEXM3INTEGRATIONDS_dsm.SWV

  // CARBON USER CODE [PRE INIT OUT PORT SWV] BEGIN
  // CARBON USER CODE END
      m_carbon_SWV.net().examine();
;
       m_carbon_SWV.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT SWV] BEGIN
  // CARBON USER CODE END
    }
    { // port JTAGNSW, Carbon net CORTEXM3INTEGRATIONDS_dsm.JTAGNSW

  // CARBON USER CODE [PRE INIT OUT PORT JTAGNSW] BEGIN
  // CARBON USER CODE END
      m_carbon_JTAGNSW.net().examine();
;
       m_carbon_JTAGNSW.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT JTAGNSW] BEGIN
  // CARBON USER CODE END
    }
    { // port TRACECLK, Carbon net CORTEXM3INTEGRATIONDS_dsm.TRACECLK

  // CARBON USER CODE [PRE INIT OUT PORT TRACECLK] BEGIN
  // CARBON USER CODE END
      m_carbon_TRACECLK.net().examine();
;
       m_carbon_TRACECLK.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT TRACECLK] BEGIN
  // CARBON USER CODE END
    }
    { // port TRACEDATA, Carbon net CORTEXM3INTEGRATIONDS_dsm.TRACEDATA

  // CARBON USER CODE [PRE INIT OUT PORT TRACEDATA] BEGIN
  // CARBON USER CODE END
      m_carbon_TRACEDATA.net().examine();
;
       m_carbon_TRACEDATA.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT TRACEDATA] BEGIN
  // CARBON USER CODE END
    }
    { // port HTRANSI, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTRANSI

  // CARBON USER CODE [PRE INIT OUT PORT HTRANSI] BEGIN
  // CARBON USER CODE END
      m_carbon_HTRANSI.net().examine();
;
       m_carbon_HTRANSI.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTRANSI] BEGIN
  // CARBON USER CODE END
    }
    { // port HSIZEI, Carbon net CORTEXM3INTEGRATIONDS_dsm.HSIZEI

  // CARBON USER CODE [PRE INIT OUT PORT HSIZEI] BEGIN
  // CARBON USER CODE END
      m_carbon_HSIZEI.net().examine();
;
       m_carbon_HSIZEI.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HSIZEI] BEGIN
  // CARBON USER CODE END
    }
    { // port HADDRI, Carbon net CORTEXM3INTEGRATIONDS_dsm.HADDRI

  // CARBON USER CODE [PRE INIT OUT PORT HADDRI] BEGIN
  // CARBON USER CODE END
      m_carbon_HADDRI.net().examine();
;
       m_carbon_HADDRI.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HADDRI] BEGIN
  // CARBON USER CODE END
    }
    { // port HBURSTI, Carbon net CORTEXM3INTEGRATIONDS_dsm.HBURSTI

  // CARBON USER CODE [PRE INIT OUT PORT HBURSTI] BEGIN
  // CARBON USER CODE END
      m_carbon_HBURSTI.net().examine();
;
       m_carbon_HBURSTI.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HBURSTI] BEGIN
  // CARBON USER CODE END
    }
    { // port HPROTI, Carbon net CORTEXM3INTEGRATIONDS_dsm.HPROTI

  // CARBON USER CODE [PRE INIT OUT PORT HPROTI] BEGIN
  // CARBON USER CODE END
      m_carbon_HPROTI.net().examine();
;
       m_carbon_HPROTI.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HPROTI] BEGIN
  // CARBON USER CODE END
    }
    { // port MEMATTRI, Carbon net CORTEXM3INTEGRATIONDS_dsm.MEMATTRI

  // CARBON USER CODE [PRE INIT OUT PORT MEMATTRI] BEGIN
  // CARBON USER CODE END
      m_carbon_MEMATTRI.net().examine();
;
       m_carbon_MEMATTRI.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT MEMATTRI] BEGIN
  // CARBON USER CODE END
    }
    { // port HTRANSD, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTRANSD

  // CARBON USER CODE [PRE INIT OUT PORT HTRANSD] BEGIN
  // CARBON USER CODE END
      m_carbon_HTRANSD.net().examine();
;
       m_carbon_HTRANSD.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTRANSD] BEGIN
  // CARBON USER CODE END
    }
    { // port HSIZED, Carbon net CORTEXM3INTEGRATIONDS_dsm.HSIZED

  // CARBON USER CODE [PRE INIT OUT PORT HSIZED] BEGIN
  // CARBON USER CODE END
      m_carbon_HSIZED.net().examine();
;
       m_carbon_HSIZED.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HSIZED] BEGIN
  // CARBON USER CODE END
    }
    { // port HADDRD, Carbon net CORTEXM3INTEGRATIONDS_dsm.HADDRD

  // CARBON USER CODE [PRE INIT OUT PORT HADDRD] BEGIN
  // CARBON USER CODE END
      m_carbon_HADDRD.net().examine();
;
       m_carbon_HADDRD.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HADDRD] BEGIN
  // CARBON USER CODE END
    }
    { // port HBURSTD, Carbon net CORTEXM3INTEGRATIONDS_dsm.HBURSTD

  // CARBON USER CODE [PRE INIT OUT PORT HBURSTD] BEGIN
  // CARBON USER CODE END
      m_carbon_HBURSTD.net().examine();
;
       m_carbon_HBURSTD.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HBURSTD] BEGIN
  // CARBON USER CODE END
    }
    { // port HPROTD, Carbon net CORTEXM3INTEGRATIONDS_dsm.HPROTD

  // CARBON USER CODE [PRE INIT OUT PORT HPROTD] BEGIN
  // CARBON USER CODE END
      m_carbon_HPROTD.net().examine();
;
       m_carbon_HPROTD.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HPROTD] BEGIN
  // CARBON USER CODE END
    }
    { // port MEMATTRD, Carbon net CORTEXM3INTEGRATIONDS_dsm.MEMATTRD

  // CARBON USER CODE [PRE INIT OUT PORT MEMATTRD] BEGIN
  // CARBON USER CODE END
      m_carbon_MEMATTRD.net().examine();
;
       m_carbon_MEMATTRD.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT MEMATTRD] BEGIN
  // CARBON USER CODE END
    }
    { // port HMASTERD, Carbon net CORTEXM3INTEGRATIONDS_dsm.HMASTERD

  // CARBON USER CODE [PRE INIT OUT PORT HMASTERD] BEGIN
  // CARBON USER CODE END
      m_carbon_HMASTERD.net().examine();
;
       m_carbon_HMASTERD.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HMASTERD] BEGIN
  // CARBON USER CODE END
    }
    { // port EXREQD, Carbon net CORTEXM3INTEGRATIONDS_dsm.EXREQD

  // CARBON USER CODE [PRE INIT OUT PORT EXREQD] BEGIN
  // CARBON USER CODE END
      m_carbon_EXREQD.net().examine();
;
       m_carbon_EXREQD.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT EXREQD] BEGIN
  // CARBON USER CODE END
    }
    { // port HWRITED, Carbon net CORTEXM3INTEGRATIONDS_dsm.HWRITED

  // CARBON USER CODE [PRE INIT OUT PORT HWRITED] BEGIN
  // CARBON USER CODE END
      m_carbon_HWRITED.net().examine();
;
       m_carbon_HWRITED.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HWRITED] BEGIN
  // CARBON USER CODE END
    }
    { // port HWDATAD, Carbon net CORTEXM3INTEGRATIONDS_dsm.HWDATAD

  // CARBON USER CODE [PRE INIT OUT PORT HWDATAD] BEGIN
  // CARBON USER CODE END
      m_carbon_HWDATAD.net().examine();
;
       m_carbon_HWDATAD.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HWDATAD] BEGIN
  // CARBON USER CODE END
    }
    { // port HTRANSS, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTRANSS

  // CARBON USER CODE [PRE INIT OUT PORT HTRANSS] BEGIN
  // CARBON USER CODE END
      m_carbon_HTRANSS.net().examine();
;
       m_carbon_HTRANSS.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTRANSS] BEGIN
  // CARBON USER CODE END
    }
    { // port HSIZES, Carbon net CORTEXM3INTEGRATIONDS_dsm.HSIZES

  // CARBON USER CODE [PRE INIT OUT PORT HSIZES] BEGIN
  // CARBON USER CODE END
      m_carbon_HSIZES.net().examine();
;
       m_carbon_HSIZES.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HSIZES] BEGIN
  // CARBON USER CODE END
    }
    { // port HADDRS, Carbon net CORTEXM3INTEGRATIONDS_dsm.HADDRS

  // CARBON USER CODE [PRE INIT OUT PORT HADDRS] BEGIN
  // CARBON USER CODE END
      m_carbon_HADDRS.net().examine();
;
       m_carbon_HADDRS.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HADDRS] BEGIN
  // CARBON USER CODE END
    }
    { // port HBURSTS, Carbon net CORTEXM3INTEGRATIONDS_dsm.HBURSTS

  // CARBON USER CODE [PRE INIT OUT PORT HBURSTS] BEGIN
  // CARBON USER CODE END
      m_carbon_HBURSTS.net().examine();
;
       m_carbon_HBURSTS.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HBURSTS] BEGIN
  // CARBON USER CODE END
    }
    { // port HPROTS, Carbon net CORTEXM3INTEGRATIONDS_dsm.HPROTS

  // CARBON USER CODE [PRE INIT OUT PORT HPROTS] BEGIN
  // CARBON USER CODE END
      m_carbon_HPROTS.net().examine();
;
       m_carbon_HPROTS.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HPROTS] BEGIN
  // CARBON USER CODE END
    }
    { // port MEMATTRS, Carbon net CORTEXM3INTEGRATIONDS_dsm.MEMATTRS

  // CARBON USER CODE [PRE INIT OUT PORT MEMATTRS] BEGIN
  // CARBON USER CODE END
      m_carbon_MEMATTRS.net().examine();
;
       m_carbon_MEMATTRS.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT MEMATTRS] BEGIN
  // CARBON USER CODE END
    }
    { // port HMASTERS, Carbon net CORTEXM3INTEGRATIONDS_dsm.HMASTERS

  // CARBON USER CODE [PRE INIT OUT PORT HMASTERS] BEGIN
  // CARBON USER CODE END
      m_carbon_HMASTERS.net().examine();
;
       m_carbon_HMASTERS.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HMASTERS] BEGIN
  // CARBON USER CODE END
    }
    { // port EXREQS, Carbon net CORTEXM3INTEGRATIONDS_dsm.EXREQS

  // CARBON USER CODE [PRE INIT OUT PORT EXREQS] BEGIN
  // CARBON USER CODE END
      m_carbon_EXREQS.net().examine();
;
       m_carbon_EXREQS.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT EXREQS] BEGIN
  // CARBON USER CODE END
    }
    { // port HWRITES, Carbon net CORTEXM3INTEGRATIONDS_dsm.HWRITES

  // CARBON USER CODE [PRE INIT OUT PORT HWRITES] BEGIN
  // CARBON USER CODE END
      m_carbon_HWRITES.net().examine();
;
       m_carbon_HWRITES.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HWRITES] BEGIN
  // CARBON USER CODE END
    }
    { // port HWDATAS, Carbon net CORTEXM3INTEGRATIONDS_dsm.HWDATAS

  // CARBON USER CODE [PRE INIT OUT PORT HWDATAS] BEGIN
  // CARBON USER CODE END
      m_carbon_HWDATAS.net().examine();
;
       m_carbon_HWDATAS.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HWDATAS] BEGIN
  // CARBON USER CODE END
    }
    { // port HMASTLOCKS, Carbon net CORTEXM3INTEGRATIONDS_dsm.HMASTLOCKS

  // CARBON USER CODE [PRE INIT OUT PORT HMASTLOCKS] BEGIN
  // CARBON USER CODE END
      m_carbon_HMASTLOCKS.net().examine();
;
       m_carbon_HMASTLOCKS.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HMASTLOCKS] BEGIN
  // CARBON USER CODE END
    }
    { // port BRCHSTAT, Carbon net CORTEXM3INTEGRATIONDS_dsm.BRCHSTAT

  // CARBON USER CODE [PRE INIT OUT PORT BRCHSTAT] BEGIN
  // CARBON USER CODE END
      m_carbon_BRCHSTAT.net().examine();
;
       m_carbon_BRCHSTAT.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT BRCHSTAT] BEGIN
  // CARBON USER CODE END
    }
    { // port HALTED, Carbon net CORTEXM3INTEGRATIONDS_dsm.HALTED

  // CARBON USER CODE [PRE INIT OUT PORT HALTED] BEGIN
  // CARBON USER CODE END
      m_carbon_HALTED.net().examine();
;
       m_carbon_HALTED.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HALTED] BEGIN
  // CARBON USER CODE END
    }
    { // port SLEEPING, Carbon net CORTEXM3INTEGRATIONDS_dsm.SLEEPING

  // CARBON USER CODE [PRE INIT OUT PORT SLEEPING] BEGIN
  // CARBON USER CODE END
      m_carbon_SLEEPING.net().examine();
;
       m_carbon_SLEEPING.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT SLEEPING] BEGIN
  // CARBON USER CODE END
    }
    { // port SLEEPDEEP, Carbon net CORTEXM3INTEGRATIONDS_dsm.SLEEPDEEP

  // CARBON USER CODE [PRE INIT OUT PORT SLEEPDEEP] BEGIN
  // CARBON USER CODE END
      m_carbon_SLEEPDEEP.net().examine();
;
       m_carbon_SLEEPDEEP.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT SLEEPDEEP] BEGIN
  // CARBON USER CODE END
    }
    { // port ETMINTNUM, Carbon net CORTEXM3INTEGRATIONDS_dsm.ETMINTNUM

  // CARBON USER CODE [PRE INIT OUT PORT ETMINTNUM] BEGIN
  // CARBON USER CODE END
      m_carbon_ETMINTNUM.net().examine();
;
       m_carbon_ETMINTNUM.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT ETMINTNUM] BEGIN
  // CARBON USER CODE END
    }
    { // port ETMINTSTAT, Carbon net CORTEXM3INTEGRATIONDS_dsm.ETMINTSTAT

  // CARBON USER CODE [PRE INIT OUT PORT ETMINTSTAT] BEGIN
  // CARBON USER CODE END
      m_carbon_ETMINTSTAT.net().examine();
;
       m_carbon_ETMINTSTAT.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT ETMINTSTAT] BEGIN
  // CARBON USER CODE END
    }
    { // port SYSRESETREQ, Carbon net CORTEXM3INTEGRATIONDS_dsm.SYSRESETREQ

  // CARBON USER CODE [PRE INIT OUT PORT SYSRESETREQ] BEGIN
  // CARBON USER CODE END
      m_carbon_SYSRESETREQ.net().examine();
;
       m_carbon_SYSRESETREQ.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT SYSRESETREQ] BEGIN
  // CARBON USER CODE END
    }
    { // port TXEV, Carbon net CORTEXM3INTEGRATIONDS_dsm.TXEV

  // CARBON USER CODE [PRE INIT OUT PORT TXEV] BEGIN
  // CARBON USER CODE END
      m_carbon_TXEV.net().examine();
;
       m_carbon_TXEV.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT TXEV] BEGIN
  // CARBON USER CODE END
    }
    { // port TRCENA, Carbon net CORTEXM3INTEGRATIONDS_dsm.TRCENA

  // CARBON USER CODE [PRE INIT OUT PORT TRCENA] BEGIN
  // CARBON USER CODE END
      m_carbon_TRCENA.net().examine();
;
       m_carbon_TRCENA.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT TRCENA] BEGIN
  // CARBON USER CODE END
    }
    { // port CURRPRI, Carbon net CORTEXM3INTEGRATIONDS_dsm.CURRPRI

  // CARBON USER CODE [PRE INIT OUT PORT CURRPRI] BEGIN
  // CARBON USER CODE END
      m_carbon_CURRPRI.net().examine();
;
       m_carbon_CURRPRI.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT CURRPRI] BEGIN
  // CARBON USER CODE END
    }
    { // port DBGRESTARTED, Carbon net CORTEXM3INTEGRATIONDS_dsm.DBGRESTARTED

  // CARBON USER CODE [PRE INIT OUT PORT DBGRESTARTED] BEGIN
  // CARBON USER CODE END
      m_carbon_DBGRESTARTED.net().examine();
;
       m_carbon_DBGRESTARTED.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT DBGRESTARTED] BEGIN
  // CARBON USER CODE END
    }
    { // port SLEEPHOLDACKn, Carbon net CORTEXM3INTEGRATIONDS_dsm.SLEEPHOLDACKn

  // CARBON USER CODE [PRE INIT OUT PORT SLEEPHOLDACKn] BEGIN
  // CARBON USER CODE END
      m_carbon_SLEEPHOLDACKn.net().examine();
;
       m_carbon_SLEEPHOLDACKn.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT SLEEPHOLDACKn] BEGIN
  // CARBON USER CODE END
    }
    { // port GATEHCLK, Carbon net CORTEXM3INTEGRATIONDS_dsm.GATEHCLK

  // CARBON USER CODE [PRE INIT OUT PORT GATEHCLK] BEGIN
  // CARBON USER CODE END
      m_carbon_GATEHCLK.net().examine();
;
       m_carbon_GATEHCLK.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT GATEHCLK] BEGIN
  // CARBON USER CODE END
    }
    { // port HTMDHADDR, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTMDHADDR

  // CARBON USER CODE [PRE INIT OUT PORT HTMDHADDR] BEGIN
  // CARBON USER CODE END
      m_carbon_HTMDHADDR.net().examine();
;
       m_carbon_HTMDHADDR.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTMDHADDR] BEGIN
  // CARBON USER CODE END
    }
    { // port HTMDHTRANS, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTMDHTRANS

  // CARBON USER CODE [PRE INIT OUT PORT HTMDHTRANS] BEGIN
  // CARBON USER CODE END
      m_carbon_HTMDHTRANS.net().examine();
;
       m_carbon_HTMDHTRANS.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTMDHTRANS] BEGIN
  // CARBON USER CODE END
    }
    { // port HTMDHSIZE, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTMDHSIZE

  // CARBON USER CODE [PRE INIT OUT PORT HTMDHSIZE] BEGIN
  // CARBON USER CODE END
      m_carbon_HTMDHSIZE.net().examine();
;
       m_carbon_HTMDHSIZE.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTMDHSIZE] BEGIN
  // CARBON USER CODE END
    }
    { // port HTMDHBURST, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTMDHBURST

  // CARBON USER CODE [PRE INIT OUT PORT HTMDHBURST] BEGIN
  // CARBON USER CODE END
      m_carbon_HTMDHBURST.net().examine();
;
       m_carbon_HTMDHBURST.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTMDHBURST] BEGIN
  // CARBON USER CODE END
    }
    { // port HTMDHPROT, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTMDHPROT

  // CARBON USER CODE [PRE INIT OUT PORT HTMDHPROT] BEGIN
  // CARBON USER CODE END
      m_carbon_HTMDHPROT.net().examine();
;
       m_carbon_HTMDHPROT.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTMDHPROT] BEGIN
  // CARBON USER CODE END
    }
    { // port HTMDHWDATA, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTMDHWDATA

  // CARBON USER CODE [PRE INIT OUT PORT HTMDHWDATA] BEGIN
  // CARBON USER CODE END
      m_carbon_HTMDHWDATA.net().examine();
;
       m_carbon_HTMDHWDATA.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTMDHWDATA] BEGIN
  // CARBON USER CODE END
    }
    { // port HTMDHWRITE, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTMDHWRITE

  // CARBON USER CODE [PRE INIT OUT PORT HTMDHWRITE] BEGIN
  // CARBON USER CODE END
      m_carbon_HTMDHWRITE.net().examine();
;
       m_carbon_HTMDHWRITE.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTMDHWRITE] BEGIN
  // CARBON USER CODE END
    }
    { // port HTMDHRDATA, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTMDHRDATA

  // CARBON USER CODE [PRE INIT OUT PORT HTMDHRDATA] BEGIN
  // CARBON USER CODE END
      m_carbon_HTMDHRDATA.net().examine();
;
       m_carbon_HTMDHRDATA.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTMDHRDATA] BEGIN
  // CARBON USER CODE END
    }
    { // port HTMDHREADY, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTMDHREADY

  // CARBON USER CODE [PRE INIT OUT PORT HTMDHREADY] BEGIN
  // CARBON USER CODE END
      m_carbon_HTMDHREADY.net().examine();
;
       m_carbon_HTMDHREADY.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTMDHREADY] BEGIN
  // CARBON USER CODE END
    }
    { // port HTMDHRESP, Carbon net CORTEXM3INTEGRATIONDS_dsm.HTMDHRESP

  // CARBON USER CODE [PRE INIT OUT PORT HTMDHRESP] BEGIN
  // CARBON USER CODE END
      m_carbon_HTMDHRESP.net().examine();
;
       m_carbon_HTMDHRESP.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT HTMDHRESP] BEGIN
  // CARBON USER CODE END
    }
    { // port WICENACK, Carbon net CORTEXM3INTEGRATIONDS_dsm.WICENACK

  // CARBON USER CODE [PRE INIT OUT PORT WICENACK] BEGIN
  // CARBON USER CODE END
      m_carbon_WICENACK.net().examine();
;
       m_carbon_WICENACK.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT WICENACK] BEGIN
  // CARBON USER CODE END
    }
    { // port WAKEUP, Carbon net CORTEXM3INTEGRATIONDS_dsm.WAKEUP

  // CARBON USER CODE [PRE INIT OUT PORT WAKEUP] BEGIN
  // CARBON USER CODE END
      m_carbon_WAKEUP.net().examine();
;
       m_carbon_WAKEUP.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT WAKEUP] BEGIN
  // CARBON USER CODE END
    }
    { // port CDBGPWRUPREQ, Carbon net CORTEXM3INTEGRATIONDS_dsm.CDBGPWRUPREQ

  // CARBON USER CODE [PRE INIT OUT PORT CDBGPWRUPREQ] BEGIN
  // CARBON USER CODE END
      m_carbon_CDBGPWRUPREQ.net().examine();
;
       m_carbon_CDBGPWRUPREQ.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT CDBGPWRUPREQ] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_ClkCount, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_ClkCount

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_ClkCount] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_ClkCount.net().examine();
;
       m_carbon_uCORTEXM3_dsm_ClkCount.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_ClkCount] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_cpsr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_cpsr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_cpsr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_cpsr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_cpsr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_cpsr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_mpu_ctrl, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_mpu_ctrl

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_mpu_ctrl] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_mpu_ctrl.net().examine();
;
       m_carbon_uCORTEXM3_dsm_mpu_ctrl.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_mpu_ctrl] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_mpu_rasr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_mpu_rasr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_mpu_rasr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_mpu_rasr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_mpu_rasr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_mpu_rasr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_mpu_rbar, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_mpu_rbar

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_mpu_rbar] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_mpu_rbar.net().examine();
;
       m_carbon_uCORTEXM3_dsm_mpu_rbar.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_mpu_rbar] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_mpu_rnr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_mpu_rnr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_mpu_rnr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_mpu_rnr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_mpu_rnr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_mpu_rnr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iabr0, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr0

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iabr0] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iabr0.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iabr0.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iabr0] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iabr1, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr1

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iabr1] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iabr1.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iabr1.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iabr1] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iabr2, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr2

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iabr2] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iabr2.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iabr2.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iabr2] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iabr3, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr3

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iabr3] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iabr3.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iabr3.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iabr3] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iabr4, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr4

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iabr4] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iabr4.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iabr4.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iabr4] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iabr5, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr5

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iabr5] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iabr5.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iabr5.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iabr5] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iabr6, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr6

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iabr6] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iabr6.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iabr6.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iabr6] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iabr7, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iabr7

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iabr7] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iabr7.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iabr7.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iabr7] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icer0, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer0

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icer0] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icer0.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icer0.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icer0] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icer1, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer1

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icer1] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icer1.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icer1.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icer1] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icer2, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer2

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icer2] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icer2.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icer2.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icer2] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icer3, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer3

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icer3] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icer3.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icer3.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icer3] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icer4, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer4

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icer4] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icer4.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icer4.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icer4] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icer5, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer5

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icer5] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icer5.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icer5.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icer5] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icer6, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer6

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icer6] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icer6.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icer6.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icer6] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icer7, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icer7

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icer7] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icer7.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icer7.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icer7] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icpr0, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr0

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icpr0] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icpr0.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icpr0.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icpr0] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icpr1, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr1

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icpr1] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icpr1.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icpr1.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icpr1] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icpr2, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr2

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icpr2] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icpr2.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icpr2.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icpr2] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icpr3, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr3

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icpr3] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icpr3.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icpr3.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icpr3] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icpr4, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr4

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icpr4] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icpr4.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icpr4.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icpr4] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icpr5, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr5

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icpr5] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icpr5.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icpr5.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icpr5] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icpr6, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr6

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icpr6] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icpr6.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icpr6.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icpr6] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_icpr7, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_icpr7

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_icpr7] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_icpr7.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_icpr7.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_icpr7] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ictr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ictr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ictr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ictr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ictr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ictr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr0, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr0

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr0] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr0.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr0.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr0] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr1, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr1

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr1] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr1.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr1.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr1] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr10, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr10

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr10] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr10.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr10.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr10] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr11, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr11

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr11] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr11.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr11.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr11] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr12, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr12

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr12] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr12.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr12.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr12] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr13, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr13

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr13] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr13.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr13.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr13] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr14, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr14

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr14] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr14.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr14.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr14] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr15, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr15

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr15] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr15.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr15.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr15] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr16, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr16

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr16] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr16.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr16.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr16] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr17, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr17

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr17] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr17.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr17.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr17] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr18, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr18

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr18] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr18.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr18.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr18] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr19, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr19

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr19] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr19.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr19.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr19] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr2, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr2

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr2] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr2.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr2.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr2] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr20, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr20

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr20] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr20.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr20.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr20] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr21, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr21

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr21] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr21.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr21.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr21] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr22, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr22

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr22] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr22.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr22.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr22] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr23, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr23

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr23] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr23.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr23.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr23] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr24, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr24

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr24] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr24.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr24.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr24] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr25, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr25

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr25] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr25.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr25.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr25] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr26, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr26

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr26] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr26.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr26.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr26] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr27, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr27

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr27] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr27.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr27.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr27] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr28, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr28

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr28] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr28.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr28.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr28] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr29, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr29

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr29] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr29.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr29.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr29] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr3, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr3

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr3] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr3.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr3.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr3] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr30, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr30

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr30] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr30.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr30.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr30] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr31, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr31

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr31] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr31.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr31.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr31] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr32, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr32

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr32] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr32.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr32.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr32] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr33, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr33

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr33] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr33.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr33.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr33] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr34, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr34

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr34] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr34.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr34.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr34] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr35, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr35

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr35] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr35.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr35.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr35] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr36, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr36

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr36] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr36.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr36.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr36] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr37, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr37

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr37] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr37.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr37.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr37] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr38, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr38

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr38] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr38.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr38.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr38] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr39, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr39

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr39] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr39.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr39.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr39] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr4, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr4

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr4] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr4.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr4.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr4] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr40, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr40

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr40] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr40.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr40.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr40] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr41, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr41

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr41] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr41.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr41.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr41] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr42, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr42

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr42] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr42.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr42.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr42] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr43, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr43

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr43] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr43.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr43.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr43] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr44, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr44

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr44] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr44.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr44.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr44] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr45, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr45

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr45] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr45.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr45.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr45] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr46, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr46

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr46] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr46.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr46.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr46] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr47, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr47

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr47] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr47.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr47.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr47] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr48, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr48

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr48] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr48.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr48.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr48] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr49, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr49

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr49] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr49.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr49.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr49] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr5, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr5

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr5] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr5.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr5.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr5] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr50, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr50

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr50] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr50.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr50.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr50] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr51, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr51

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr51] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr51.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr51.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr51] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr52, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr52

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr52] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr52.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr52.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr52] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr53, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr53

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr53] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr53.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr53.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr53] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr54, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr54

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr54] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr54.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr54.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr54] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr55, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr55

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr55] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr55.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr55.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr55] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr56, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr56

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr56] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr56.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr56.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr56] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr57, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr57

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr57] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr57.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr57.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr57] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr58, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr58

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr58] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr58.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr58.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr58] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr59, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr59

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr59] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr59.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr59.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr59] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr6, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr6

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr6] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr6.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr6.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr6] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr7, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr7

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr7] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr7.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr7.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr7] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr8, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr8

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr8] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr8.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr8.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr8] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ipr9, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ipr9

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ipr9] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ipr9.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ipr9.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ipr9] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iser0, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser0

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iser0] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iser0.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iser0.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iser0] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iser1, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser1

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iser1] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iser1.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iser1.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iser1] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iser2, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser2

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iser2] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iser2.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iser2.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iser2] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iser3, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser3

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iser3] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iser3.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iser3.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iser3] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iser4, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser4

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iser4] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iser4.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iser4.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iser4] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iser5, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser5

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iser5] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iser5.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iser5.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iser5] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iser6, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser6

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iser6] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iser6.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iser6.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iser6] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_iser7, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_iser7

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_iser7] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_iser7.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_iser7.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_iser7] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ispr0, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr0

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ispr0] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ispr0.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ispr0.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ispr0] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ispr1, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr1

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ispr1] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ispr1.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ispr1.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ispr1] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ispr2, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr2

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ispr2] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ispr2.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ispr2.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ispr2] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ispr3, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr3

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ispr3] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ispr3.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ispr3.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ispr3] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ispr4, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr4

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ispr4] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ispr4.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ispr4.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ispr4] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ispr5, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr5

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ispr5] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ispr5.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ispr5.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ispr5] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ispr6, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr6

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ispr6] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ispr6.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ispr6.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ispr6] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_nvic_ispr7, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_nvic_ispr7

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_nvic_ispr7] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_nvic_ispr7.net().examine();
;
       m_carbon_uCORTEXM3_dsm_nvic_ispr7.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_nvic_ispr7] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_pc, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_pc

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_pc] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_pc.net().examine();
;
       m_carbon_uCORTEXM3_dsm_pc.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_pc] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r0, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r0

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r0] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r0.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r0.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r0] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r1, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r1

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r1] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r1.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r1.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r1] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r10, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r10

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r10] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r10.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r10.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r10] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r11, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r11

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r11] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r11.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r11.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r11] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r12, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r12

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r12] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r12.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r12.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r12] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r13, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r13

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r13] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r13.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r13.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r13] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r14, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r14

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r14] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r14.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r14.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r14] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r2, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r2

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r2] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r2.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r2.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r2] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r3, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r3

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r3] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r3.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r3.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r3] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r4, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r4

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r4] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r4.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r4.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r4] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r5, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r5

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r5] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r5.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r5.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r5] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r6, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r6

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r6] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r6.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r6.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r6] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r7, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r7

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r7] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r7.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r7.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r7] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r8, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r8

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r8] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r8.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r8.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r8] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_r9, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_r9

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_r9] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_r9.net().examine();
;
       m_carbon_uCORTEXM3_dsm_r9.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_r9] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_actlr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_actlr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_actlr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_actlr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_actlr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_actlr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_afsr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_afsr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_afsr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_afsr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_afsr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_afsr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_aircr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_aircr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_aircr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_aircr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_aircr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_aircr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_bfar, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_bfar

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_bfar] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_bfar.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_bfar.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_bfar] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_ccr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_ccr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_ccr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_ccr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_ccr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_ccr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_cfsr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_cfsr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_cfsr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_cfsr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_cfsr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_cfsr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_cpacr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_cpacr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_cpacr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_cpacr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_cpacr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_cpacr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_cpuid, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_cpuid

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_cpuid] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_cpuid.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_cpuid.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_cpuid] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_dcrdr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_dcrdr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_dcrdr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_dcrdr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_dcrdr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_dcrdr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_demcr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_demcr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_demcr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_demcr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_demcr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_demcr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_dfsr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_dfsr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_dfsr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_dfsr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_dfsr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_dfsr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_dhcsr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_dhcsr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_dhcsr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_dhcsr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_dhcsr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_dhcsr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_hfsr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_hfsr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_hfsr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_hfsr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_hfsr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_hfsr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_icsr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_icsr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_icsr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_icsr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_icsr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_icsr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_mmfar, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_mmfar

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_mmfar] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_mmfar.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_mmfar.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_mmfar] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_scr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_scr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_scr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_scr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_scr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_scr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_shcsr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_shcsr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_shcsr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_shcsr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_shcsr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_shcsr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_shpr1, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_shpr1

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_shpr1] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_shpr1.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_shpr1.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_shpr1] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_shpr2, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_shpr2

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_shpr2] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_shpr2.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_shpr2.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_shpr2] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_shpr3, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_shpr3

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_shpr3] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_shpr3.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_shpr3.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_shpr3] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_scs_vtor, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_scs_vtor

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_scs_vtor] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_scs_vtor.net().examine();
;
       m_carbon_uCORTEXM3_dsm_scs_vtor.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_scs_vtor] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_syst_calib, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_syst_calib

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_syst_calib] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_syst_calib.net().examine();
;
       m_carbon_uCORTEXM3_dsm_syst_calib.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_syst_calib] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_syst_csr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_syst_csr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_syst_csr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_syst_csr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_syst_csr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_syst_csr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_syst_cvr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_syst_cvr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_syst_cvr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_syst_cvr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_syst_cvr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_syst_cvr] BEGIN
  // CARBON USER CODE END
    }
    { // port uCORTEXM3_dsm_syst_rvr, Carbon net CORTEXM3INTEGRATIONDS_dsm.uCORTEXM3.dsm_syst_rvr

  // CARBON USER CODE [PRE INIT OUT PORT uCORTEXM3_dsm_syst_rvr] BEGIN
  // CARBON USER CODE END
      m_carbon_uCORTEXM3_dsm_syst_rvr.net().examine();
;
       m_carbon_uCORTEXM3_dsm_syst_rvr.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT uCORTEXM3_dsm_syst_rvr] BEGIN
  // CARBON USER CODE END
    }
    { // port LOCKUP, Carbon net CORTEXM3INTEGRATIONDS_dsm.LOCKUP

  // CARBON USER CODE [PRE INIT OUT PORT LOCKUP] BEGIN
  // CARBON USER CODE END
      m_carbon_LOCKUP.net().examine();
;
       m_carbon_LOCKUP.enqueueWrite();

  // CARBON USER CODE [POST INIT OUT PORT LOCKUP] BEGIN
  // CARBON USER CODE END
    }


  // schedule a write of the initial values to SystemC
  carbon_schedule_channel.carbon_write_outputs_event.notify(SC_ZERO_TIME);


  // CARBON USER CODE [POST CORTEXM3INTEGRATIONDS_dsmEnd Of Elaboration] BEGIN
  // CARBON USER CODE END
}

void CORTEXM3INTEGRATIONDS_dsm::carbon_write_outputs()
{
    // perform any writes queued up by net change callbacks
  while (mCarbonWriteFuncs != NULL) {
    void (*func)(void *) = (void (*)(void *)) mCarbonWriteFuncs;
    func(mCarbonWriteData);
  }


    carbon_schedule_channel.carbon_write_delayed_outputs_event.notify(SC_ZERO_TIME);

}

void CORTEXM3INTEGRATIONDS_dsm::carbon_write_delayed_outputs()
{
    // perform any writes queued up by net change callbacks
  while (mCarbonDelayedWriteFuncs != NULL) {
    void (*func)(void *) = (void (*)(void *)) mCarbonDelayedWriteFuncs;
    func(mCarbonDelayedWriteData);
  }



  // CARBON USER CODE [PRE WRITE PORT TDO] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT TDO] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT nTDOEN] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT nTDOEN] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT SWDOEN] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT SWDOEN] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT SWDO] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT SWDO] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT SWV] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT SWV] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT JTAGNSW] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT JTAGNSW] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT TRACECLK] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT TRACECLK] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT TRACEDATA] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT TRACEDATA] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTRANSI] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTRANSI] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HSIZEI] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HSIZEI] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HADDRI] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HADDRI] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HBURSTI] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HBURSTI] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HPROTI] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HPROTI] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT MEMATTRI] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT MEMATTRI] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTRANSD] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTRANSD] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HSIZED] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HSIZED] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HADDRD] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HADDRD] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HBURSTD] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HBURSTD] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HPROTD] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HPROTD] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT MEMATTRD] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT MEMATTRD] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HMASTERD] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HMASTERD] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT EXREQD] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT EXREQD] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HWRITED] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HWRITED] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HWDATAD] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HWDATAD] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTRANSS] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTRANSS] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HSIZES] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HSIZES] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HADDRS] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HADDRS] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HBURSTS] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HBURSTS] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HPROTS] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HPROTS] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT MEMATTRS] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT MEMATTRS] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HMASTERS] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HMASTERS] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT EXREQS] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT EXREQS] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HWRITES] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HWRITES] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HWDATAS] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HWDATAS] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HMASTLOCKS] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HMASTLOCKS] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT BRCHSTAT] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT BRCHSTAT] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HALTED] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HALTED] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT SLEEPING] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT SLEEPING] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT SLEEPDEEP] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT SLEEPDEEP] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT ETMINTNUM] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT ETMINTNUM] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT ETMINTSTAT] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT ETMINTSTAT] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT SYSRESETREQ] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT SYSRESETREQ] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT TXEV] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT TXEV] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT TRCENA] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT TRCENA] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT CURRPRI] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT CURRPRI] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT DBGRESTARTED] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT DBGRESTARTED] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT SLEEPHOLDACKn] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT SLEEPHOLDACKn] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT GATEHCLK] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT GATEHCLK] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTMDHADDR] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTMDHADDR] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTMDHTRANS] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTMDHTRANS] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTMDHSIZE] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTMDHSIZE] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTMDHBURST] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTMDHBURST] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTMDHPROT] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTMDHPROT] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTMDHWDATA] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTMDHWDATA] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTMDHWRITE] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTMDHWRITE] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTMDHRDATA] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTMDHRDATA] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTMDHREADY] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTMDHREADY] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT HTMDHRESP] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT HTMDHRESP] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT WICENACK] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT WICENACK] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT WAKEUP] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT WAKEUP] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT CDBGPWRUPREQ] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT CDBGPWRUPREQ] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_ClkCount] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_ClkCount] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_cpsr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_cpsr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_mpu_ctrl] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_mpu_ctrl] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_mpu_rasr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_mpu_rasr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_mpu_rbar] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_mpu_rbar] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_mpu_rnr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_mpu_rnr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iabr0] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iabr0] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iabr1] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iabr1] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iabr2] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iabr2] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iabr3] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iabr3] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iabr4] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iabr4] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iabr5] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iabr5] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iabr6] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iabr6] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iabr7] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iabr7] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icer0] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icer0] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icer1] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icer1] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icer2] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icer2] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icer3] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icer3] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icer4] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icer4] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icer5] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icer5] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icer6] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icer6] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icer7] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icer7] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icpr0] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icpr0] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icpr1] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icpr1] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icpr2] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icpr2] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icpr3] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icpr3] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icpr4] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icpr4] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icpr5] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icpr5] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icpr6] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icpr6] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_icpr7] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_icpr7] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ictr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ictr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr0] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr0] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr1] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr1] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr10] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr10] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr11] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr11] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr12] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr12] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr13] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr13] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr14] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr14] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr15] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr15] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr16] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr16] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr17] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr17] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr18] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr18] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr19] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr19] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr2] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr2] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr20] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr20] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr21] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr21] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr22] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr22] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr23] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr23] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr24] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr24] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr25] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr25] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr26] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr26] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr27] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr27] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr28] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr28] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr29] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr29] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr3] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr3] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr30] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr30] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr31] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr31] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr32] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr32] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr33] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr33] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr34] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr34] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr35] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr35] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr36] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr36] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr37] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr37] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr38] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr38] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr39] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr39] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr4] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr4] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr40] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr40] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr41] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr41] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr42] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr42] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr43] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr43] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr44] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr44] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr45] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr45] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr46] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr46] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr47] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr47] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr48] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr48] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr49] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr49] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr5] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr5] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr50] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr50] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr51] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr51] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr52] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr52] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr53] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr53] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr54] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr54] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr55] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr55] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr56] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr56] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr57] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr57] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr58] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr58] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr59] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr59] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr6] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr6] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr7] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr7] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr8] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr8] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ipr9] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ipr9] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iser0] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iser0] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iser1] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iser1] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iser2] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iser2] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iser3] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iser3] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iser4] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iser4] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iser5] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iser5] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iser6] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iser6] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_iser7] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_iser7] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ispr0] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ispr0] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ispr1] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ispr1] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ispr2] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ispr2] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ispr3] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ispr3] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ispr4] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ispr4] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ispr5] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ispr5] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ispr6] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ispr6] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_nvic_ispr7] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_nvic_ispr7] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_pc] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_pc] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r0] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r0] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r1] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r1] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r10] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r10] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r11] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r11] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r12] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r12] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r13] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r13] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r14] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r14] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r2] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r2] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r3] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r3] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r4] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r4] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r5] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r5] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r6] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r6] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r7] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r7] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r8] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r8] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_r9] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_r9] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_actlr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_actlr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_afsr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_afsr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_aircr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_aircr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_bfar] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_bfar] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_ccr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_ccr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_cfsr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_cfsr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_cpacr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_cpacr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_cpuid] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_cpuid] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_dcrdr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_dcrdr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_demcr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_demcr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_dfsr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_dfsr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_dhcsr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_dhcsr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_hfsr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_hfsr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_icsr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_icsr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_mmfar] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_mmfar] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_scr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_scr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_shcsr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_shcsr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_shpr1] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_shpr1] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_shpr2] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_shpr2] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_shpr3] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_shpr3] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_scs_vtor] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_scs_vtor] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_syst_calib] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_syst_calib] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_syst_csr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_syst_csr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_syst_cvr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_syst_cvr] BEGIN
  // CARBON USER CODE END


  // CARBON USER CODE [PRE WRITE PORT uCORTEXM3_dsm_syst_rvr] BEGIN
  // CARBON USER CODE END

  // CARBON USER CODE [POST WRITE PORT uCORTEXM3_dsm_syst_rvr] BEGIN
  // CARBON USER CODE END

}


double CORTEXM3INTEGRATIONDS_dsm::getSimTime(void* /* clientdata*/)
{
  return sc_time_stamp().to_seconds() * 1e9; // Convert to ns
}
