//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//        (C) COPYRIGHT 2015 ARM Limited or its affiliates.
//            ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
//      SVN Information
//
//      Checked In          :  2015-09-17 13:43:40 +0100 (Thu, 17 Sep 2015)
//
//      Revision            :  2354
//
//      Release Information : CM3DesignStart-r0p0-02rel0
//
// -----------------------------------------------------------------------------
//  Purpose : p_beid_interconnect_f0 module top level
// -----------------------------------------------------------------------------

module p_beid_interconnect_f0 (
  MTXHCLK, MTXHRESETn, AHB2APBHCLK,                                                          // Common AHB signals
  MTXREMAP, APBQACTIVE,                                                                      // Controll port - I/O
  HADDRI, HTRANSI, HSIZEI, HBURSTI, HPROTI, MEMATTRI,                                        // CPU I-Code    - Input
  HRDATAI, HREADYI, HRESPI,                                                                  //               - Output
  HADDRD, HTRANSD, HMASTERD, HSIZED, HBURSTD, HPROTD, MEMATTRD, HWDATAD, HWRITED, EXREQD,    // CPU D-Code    - Input
  HRDATAD, HREADYD, HRESPD, EXRESPD,                                                         //               - Output
  HAUSERINITCM3DI, HWUSERINITCM3DI, HRUSERINITCM3DI,                                         //               - I/O ID User
  HADDRS, HTRANSS, HMASTERS, HWRITES, HSIZES, HMASTLOCKS, HWDATAS, HBURSTS, HPROTS,          // CPU S-Code    - Input
  MEMATTRS, EXREQS,                                                                          //               - Input
  HAUSERINITCM3S, HWUSERINITCM3S, HRUSERINITCM3S,                                            //               - I/O S User
  HREADYS, HRDATAS, HRESPS, EXRESPS,                                                         //               - Output
  INITEXP0HSEL, INITEXP0HADDR, INITEXP0HTRANS, INITEXP0HMASTER, INITEXP0HWRITE,              // INITEXP0      - Input
  INITEXP0HSIZE, INITEXP0HMASTLOCK, INITEXP0HWDATA, INITEXP0HBURST, INITEXP0HPROT,           //               - Input
  INITEXP0MEMATTR, INITEXP0EXREQ,                                                            //               - Input
  INITEXP0HREADY, INITEXP0HRDATA, INITEXP0HRESP, INITEXP0EXRESP,                             //               - Output
  INITEXP0HAUSER, INITEXP0HWUSER, INITEXP0HRUSER,                                            //               - I/O User
  INITEXP1HSEL, INITEXP1HADDR, INITEXP1HTRANS, INITEXP1HMASTER, INITEXP1HWRITE,              // INITEXP1      - Input
  INITEXP1HSIZE, INITEXP1HMASTLOCK, INITEXP1HWDATA, INITEXP1HBURST, INITEXP1HPROT,           //               - Input
  INITEXP1MEMATTR, INITEXP1EXREQ,                                                            //               - Input
  INITEXP1HREADY, INITEXP1HRDATA, INITEXP1HRESP, INITEXP1EXRESP,                             //               - Output
  INITEXP1HAUSER, INITEXP1HWUSER, INITEXP1HRUSER,                                            //               - I/O User
  TARGEXP0HSEL, TARGEXP0HADDR, TARGEXP0HTRANS, TARGEXP0HMASTER, TARGEXP0HWRITE,              // TARGEXP0      - Output
  TARGEXP0HSIZE, TARGEXP0HMASTLOCK, TARGEXP0HWDATA, TARGEXP0HBURST, TARGEXP0HPROT,           //               - Output
  TARGEXP0MEMATTR, TARGEXP0EXREQ, TARGEXP0HREADYMUX,                                         //               - Output
  TARGEXP0HREADYOUT, TARGEXP0HRDATA, TARGEXP0HRESP, TARGEXP0EXRESP,                          //               - Input
  TARGEXP0HAUSER, TARGEXP0HWUSER, TARGEXP0HRUSER,                                            //               - I/O User
  TARGEXP1HSEL, TARGEXP1HADDR, TARGEXP1HTRANS, TARGEXP1HMASTER, TARGEXP1HWRITE,              // TARGEXP1      - Output
  TARGEXP1HSIZE, TARGEXP1HMASTLOCK, TARGEXP1HWDATA, TARGEXP1HBURST, TARGEXP1HPROT,           //               - Output
  TARGEXP1MEMATTR, TARGEXP1EXREQ, TARGEXP1HREADYMUX,                                         //               - Output
  TARGEXP1HREADYOUT, TARGEXP1HRDATA, TARGEXP1HRESP, TARGEXP1EXRESP,                          //               - Input
  TARGEXP1HAUSER, TARGEXP1HWUSER, TARGEXP1HRUSER,                                            //               - I/O User
  TARGFLASH0HSEL, TARGFLASH0HADDR, TARGFLASH0HTRANS, TARGFLASH0HMASTER, TARGFLASH0HWRITE,    // TARGFLASH0    - Output
  TARGFLASH0HSIZE, TARGFLASH0HMASTLOCK, TARGFLASH0HWDATA, TARGFLASH0HBURST, TARGFLASH0HPROT, //               - Output
  TARGFLASH0MEMATTR, TARGFLASH0EXREQ, TARGFLASH0HREADYMUX,                                   //               - Output
  TARGFLASH0HREADYOUT, TARGFLASH0HRDATA, TARGFLASH0HRESP, TARGFLASH0EXRESP,                  //               - Input
  TARGFLASH0HAUSER, TARGFLASH0HWUSER, TARGFLASH0HRUSER,                                      //               - I/O User
  TARGSRAM0HSEL, TARGSRAM0HADDR, TARGSRAM0HTRANS, TARGSRAM0HMASTER, TARGSRAM0HWRITE,         // TARGSRAM0     - Output
  TARGSRAM0HSIZE, TARGSRAM0HMASTLOCK, TARGSRAM0HWDATA, TARGSRAM0HBURST, TARGSRAM0HPROT,      //               - Output
  TARGSRAM0MEMATTR, TARGSRAM0EXREQ, TARGSRAM0HREADYMUX,                                      //               - Output
  TARGSRAM0HREADYOUT, TARGSRAM0HRDATA, TARGSRAM0HRESP, TARGSRAM0EXRESP,                      //               - Input
  TARGSRAM0HAUSER, TARGSRAM0HWUSER, TARGSRAM0HRUSER,                                         //               - I/O User
  TARGSRAM1HSEL, TARGSRAM1HADDR, TARGSRAM1HTRANS, TARGSRAM1HMASTER, TARGSRAM1HWRITE,         // TARGSRAM1     - Output
  TARGSRAM1HSIZE, TARGSRAM1HMASTLOCK, TARGSRAM1HWDATA, TARGSRAM1HBURST, TARGSRAM1HPROT,      //               - Output
  TARGSRAM1MEMATTR, TARGSRAM1EXREQ, TARGSRAM1HREADYMUX,                                      //               - Output
  TARGSRAM1HREADYOUT, TARGSRAM1HRDATA, TARGSRAM1HRESP, TARGSRAM1EXRESP,                      //               - Input
  TARGSRAM1HAUSER, TARGSRAM1HWUSER, TARGSRAM1HRUSER,                                         //               - I/O User
  TARGSRAM2HSEL, TARGSRAM2HADDR, TARGSRAM2HTRANS, TARGSRAM2HMASTER, TARGSRAM2HWRITE,         // TARGSRAM2     - Output
  TARGSRAM2HSIZE, TARGSRAM2HMASTLOCK, TARGSRAM2HWDATA, TARGSRAM2HBURST, TARGSRAM2HPROT,      //               - Output
  TARGSRAM2MEMATTR, TARGSRAM2EXREQ, TARGSRAM2HREADYMUX,                                      //               - Output
  TARGSRAM2HREADYOUT, TARGSRAM2HRDATA, TARGSRAM2HRESP, TARGSRAM2EXRESP,                      //               - Input
  TARGSRAM2HAUSER, TARGSRAM2HWUSER, TARGSRAM2HRUSER,                                         //               - I/O User
  TARGSRAM3HSEL, TARGSRAM3HADDR, TARGSRAM3HTRANS, TARGSRAM3HMASTER, TARGSRAM3HWRITE,         // TARGSRAM3     - Output
  TARGSRAM3HSIZE, TARGSRAM3HMASTLOCK, TARGSRAM3HWDATA, TARGSRAM3HBURST, TARGSRAM3HPROT,      //               - Output
  TARGSRAM3MEMATTR, TARGSRAM3EXREQ, TARGSRAM3HREADYMUX,                                      //               - Output
  TARGSRAM3HREADYOUT, TARGSRAM3HRDATA, TARGSRAM3HRESP, TARGSRAM3EXRESP,                      //               - Input
  TARGSRAM3HAUSER, TARGSRAM3HWUSER, TARGSRAM3HRUSER,                                         //               - I/O User
  SCANENABLE, SCANINHCLK, SCANOUTHCLK,                                                       // MTX SCAN      - I/O
  APBTARGEXP0PADDR, APBTARGEXP0PENABLE, APBTARGEXP0PWRITE, APBTARGEXP0PSTRB,                 // APBTARGEXP0   - Input
  APBTARGEXP0PPROT, APBTARGEXP0PWDATA, APBTARGEXP0PSEL,                                      //               - Input
  APBTARGEXP0PRDATA, APBTARGEXP0PREADY, APBTARGEXP0PSLVERR,                                  //               - Output
  APBTARGEXP1PADDR, APBTARGEXP1PENABLE, APBTARGEXP1PWRITE, APBTARGEXP1PSTRB,                 // APBTARGEXP1   - Input
  APBTARGEXP1PPROT, APBTARGEXP1PWDATA, APBTARGEXP1PSEL,                                      //               - Input
  APBTARGEXP1PRDATA, APBTARGEXP1PREADY, APBTARGEXP1PSLVERR,                                  //               - Output
  APBTARGEXP2PADDR, APBTARGEXP2PENABLE, APBTARGEXP2PWRITE, APBTARGEXP2PSTRB,                 // APBTARGEXP2   - Input
  APBTARGEXP2PPROT, APBTARGEXP2PWDATA, APBTARGEXP2PSEL,                                      //               - Input
  APBTARGEXP2PRDATA, APBTARGEXP2PREADY, APBTARGEXP2PSLVERR,                                  //               - Output
  APBTARGEXP3PADDR, APBTARGEXP3PENABLE, APBTARGEXP3PWRITE, APBTARGEXP3PSTRB,                 // APBTARGEXP3   - Input
  APBTARGEXP3PPROT, APBTARGEXP3PWDATA, APBTARGEXP3PSEL,                                      //               - Input
  APBTARGEXP3PRDATA, APBTARGEXP3PREADY, APBTARGEXP3PSLVERR,                                  //               - Output
  APBTARGEXP4PADDR, APBTARGEXP4PENABLE, APBTARGEXP4PWRITE, APBTARGEXP4PSTRB,                 // APBTARGEXP4   - Input
  APBTARGEXP4PPROT, APBTARGEXP4PWDATA, APBTARGEXP4PSEL,                                      //               - Input
  APBTARGEXP4PRDATA, APBTARGEXP4PREADY, APBTARGEXP4PSLVERR,                                  //               - Output
  APBTARGEXP5PADDR, APBTARGEXP5PENABLE, APBTARGEXP5PWRITE, APBTARGEXP5PSTRB,                 // APBTARGEXP5   - Input
  APBTARGEXP5PPROT, APBTARGEXP5PWDATA, APBTARGEXP5PSEL,                                      //               - Input
  APBTARGEXP5PRDATA, APBTARGEXP5PREADY, APBTARGEXP5PSLVERR,                                  //               - Output
  APBTARGEXP6PADDR, APBTARGEXP6PENABLE, APBTARGEXP6PWRITE, APBTARGEXP6PSTRB,                 // APBTARGEXP6   - Input
  APBTARGEXP6PPROT, APBTARGEXP6PWDATA, APBTARGEXP6PSEL,                                      //               - Input
  APBTARGEXP6PRDATA, APBTARGEXP6PREADY, APBTARGEXP6PSLVERR,                                  //               - Output
  APBTARGEXP7PADDR, APBTARGEXP7PENABLE, APBTARGEXP7PWRITE, APBTARGEXP7PSTRB,                 // APBTARGEXP7   - Input
  APBTARGEXP7PPROT, APBTARGEXP7PWDATA, APBTARGEXP7PSEL,                                      //               - Input
  APBTARGEXP7PRDATA, APBTARGEXP7PREADY, APBTARGEXP7PSLVERR,                                  //               - Output
  APBTARGEXP8PADDR, APBTARGEXP8PENABLE, APBTARGEXP8PWRITE, APBTARGEXP8PSTRB,                 // APBTARGEXP8   - Input
  APBTARGEXP8PPROT, APBTARGEXP8PWDATA, APBTARGEXP8PSEL,                                      //               - Input
  APBTARGEXP8PRDATA, APBTARGEXP8PREADY, APBTARGEXP8PSLVERR,                                  //               - Output
  APBTARGEXP9PADDR, APBTARGEXP9PENABLE, APBTARGEXP9PWRITE, APBTARGEXP9PSTRB,                 // APBTARGEXP9   - Input
  APBTARGEXP9PPROT, APBTARGEXP9PWDATA, APBTARGEXP9PSEL,                                      //               - Input
  APBTARGEXP9PRDATA, APBTARGEXP9PREADY, APBTARGEXP9PSLVERR,                                  //               - Output
  APBTARGEXP10PADDR, APBTARGEXP10PENABLE, APBTARGEXP10PWRITE, APBTARGEXP10PSTRB,             // APBTARGEXP10  - Input
  APBTARGEXP10PPROT, APBTARGEXP10PWDATA, APBTARGEXP10PSEL,                                   //               - Input
  APBTARGEXP10PRDATA, APBTARGEXP10PREADY, APBTARGEXP10PSLVERR,                               //               - Output
  APBTARGEXP11PADDR, APBTARGEXP11PENABLE, APBTARGEXP11PWRITE, APBTARGEXP11PSTRB,             // APBTARGEXP11  - Input
  APBTARGEXP11PPROT, APBTARGEXP11PWDATA, APBTARGEXP11PSEL,                                   //               - Input
  APBTARGEXP11PRDATA, APBTARGEXP11PREADY, APBTARGEXP11PSLVERR,                               //               - Output
  APBTARGEXP12PADDR, APBTARGEXP12PENABLE, APBTARGEXP12PWRITE, APBTARGEXP12PSTRB,             // APBTARGEXP12  - Input
  APBTARGEXP12PPROT, APBTARGEXP12PWDATA, APBTARGEXP12PSEL,                                   //               - Input
  APBTARGEXP12PRDATA, APBTARGEXP12PREADY, APBTARGEXP12PSLVERR,                               //               - Output
  APBTARGEXP13PADDR, APBTARGEXP13PENABLE, APBTARGEXP13PWRITE, APBTARGEXP13PSTRB,             // APBTARGEXP13  - Input
  APBTARGEXP13PPROT, APBTARGEXP13PWDATA, APBTARGEXP13PSEL,                                   //               - Input
  APBTARGEXP13PRDATA, APBTARGEXP13PREADY, APBTARGEXP13PSLVERR,                               //               - Output
  APBTARGEXP14PADDR, APBTARGEXP14PENABLE, APBTARGEXP14PWRITE, APBTARGEXP14PSTRB,             // APBTARGEXP14  - Input
  APBTARGEXP14PPROT, APBTARGEXP14PWDATA, APBTARGEXP14PSEL,                                   //               - Input
  APBTARGEXP14PRDATA, APBTARGEXP14PREADY, APBTARGEXP14PSLVERR,                               //               - Output
  APBTARGEXP15PADDR, APBTARGEXP15PENABLE, APBTARGEXP15PWRITE, APBTARGEXP15PSTRB,             // APBTARGEXP15  - Input
  APBTARGEXP15PPROT, APBTARGEXP15PWDATA, APBTARGEXP15PSEL,                                   //               - Input
  APBTARGEXP15PRDATA, APBTARGEXP15PREADY, APBTARGEXP15PSLVERR                                //               - Output
);

  // ----------------------------------------------------------------------------
  // Port declarations
  // ----------------------------------------------------------------------------
  // Common AHB signals
  input         MTXHCLK;            // Interconnect AHB system clock
  input         MTXHRESETn;         // Interconnect AHB system reset
  input         AHB2APBHCLK;        // AHB to APB Bridge clock

  // Controll port
  input   [3:0] MTXREMAP;           // REMAP input
  output        APBQACTIVE;         // APB bus is active, for clock gating of APB bus

  // CPU I-Code (<-> Code Mux)
  input  [31:0] HADDRI;             // ICode address
  input   [1:0] HTRANSI;            // ICode transfer type
  input   [2:0] HSIZEI;             // ICode transfer size
  input   [2:0] HBURSTI;            // ICode burst type
  input   [3:0] HPROTI;             // ICode protection control
  input   [1:0] MEMATTRI;           // ICode memory attributes
  output [31:0] HRDATAI;            // ICode read data
  output        HREADYI;            // ICode transfer completed
  output  [1:0] HRESPI;             // ICode response status

  // CPU D-Code (<-> Code Mux)
  input  [31:0] HADDRD;             // DCode address
  input   [1:0] HTRANSD;            // DCode transfer type
  input   [1:0] HMASTERD;           // DCode master (-> Bus MTX)
  input   [2:0] HSIZED;             // DCode transfer size
  input   [2:0] HBURSTD;            // DCode burst type
  input   [3:0] HPROTD;             // DCode protection control
  input   [1:0] MEMATTRD;           // DCode memory attributes (-> logic -> Bus MTX)
  input  [31:0] HWDATAD;            // DCode write data
  input         HWRITED;            // DCode write not read
  input         EXREQD;             // DCode exclusive request
  output [31:0] HRDATAD;            // DCode read data
  output        HREADYD;            // DCode transfer completed
  output  [1:0] HRESPD;             // DCode response status
  output        EXRESPD;            // DCode exclusive response

  // CPU DI common port
  input         HAUSERINITCM3DI;    // DICode HAUSER
  input   [3:0] HWUSERINITCM3DI;    // DICode HWUSER
  output  [2:0] HRUSERINITCM3DI;    // DICode HRUSER

  // CPU System bus (<-> AHB MTX)
  input  [31:0] HADDRS;             // System address
  input   [1:0] HTRANSS;            // System transfer type
  input   [1:0] HMASTERS;           // System master
  input         HWRITES;            // System write not read
  input   [2:0] HSIZES;             // System transfer size
  input         HMASTLOCKS;         // System lock
  input  [31:0] HWDATAS;            // System write data
  input   [2:0] HBURSTS;            // System burst length
  input   [3:0] HPROTS;             // System protection
  input   [1:0] MEMATTRS;           // System memory attributes
  input         EXREQS;             // System exclusive request
  output        HREADYS;            // System ready
  output [31:0] HRDATAS;            // System read data
  output  [1:0] HRESPS;             // System transfer response
  output        EXRESPS;            // System exclusive response

  input         HAUSERINITCM3S;     // System HAUSER
  input   [3:0] HWUSERINITCM3S;     // System HWUSER
  output  [2:0] HRUSERINITCM3S;     // System HRUSER

  // Radio (<-> AHB MTX)
  input         INITEXP0HSEL;       // select
  input  [31:0] INITEXP0HADDR;      // address
  input   [1:0] INITEXP0HTRANS;     // transfer type
  input   [3:0] INITEXP0HMASTER;    // master
  input         INITEXP0HWRITE;     // write not read
  input   [2:0] INITEXP0HSIZE;      // transfer size
  input         INITEXP0HMASTLOCK;  // lock
  input  [31:0] INITEXP0HWDATA;     // write data
  input   [2:0] INITEXP0HBURST;     // burst length
  input   [3:0] INITEXP0HPROT;      // protection
  input   [1:0] INITEXP0MEMATTR;    // memory attributes
  input         INITEXP0EXREQ;      // exclusive request
  output        INITEXP0HREADY;     // transfer done
  output [31:0] INITEXP0HRDATA;     // read data
  output        INITEXP0HRESP;      // transfer response
  output        INITEXP0EXRESP;     // exclusive response

  input         INITEXP0HAUSER;     // HAUSER
  input   [3:0] INITEXP0HWUSER;     // HWUSER
  output  [2:0] INITEXP0HRUSER;     // HRUSER

  // External Master (<-> AHB MTX)
  input         INITEXP1HSEL;       // select
  input  [31:0] INITEXP1HADDR;      // address
  input   [1:0] INITEXP1HTRANS;     // transfer type
  input   [3:0] INITEXP1HMASTER;    // master
  input         INITEXP1HWRITE;     // write not read
  input   [2:0] INITEXP1HSIZE;      // transfer size
  input         INITEXP1HMASTLOCK;  // lock
  input  [31:0] INITEXP1HWDATA;     // write data
  input   [2:0] INITEXP1HBURST;     // burst length
  input   [3:0] INITEXP1HPROT;      // protection
  input   [1:0] INITEXP1MEMATTR;    // memory attributes
  input         INITEXP1EXREQ;      // exclusive request
  output        INITEXP1HREADY;     // transfer done
  output [31:0] INITEXP1HRDATA;     // read data
  output        INITEXP1HRESP;      // transfer response
  output        INITEXP1EXRESP;     // exclusive response

  input         INITEXP1HAUSER;     // HAUSER
  input   [3:0] INITEXP1HWUSER;     // HWUSER
  output  [2:0] INITEXP1HRUSER;     // HRUSER

  // AHB MTX (<-> Radio)
  output        TARGEXP0HSEL;       // select
  output [31:0] TARGEXP0HADDR;      // address
  output  [1:0] TARGEXP0HTRANS;     // transfer type
  output  [3:0] TARGEXP0HMASTER;    // master
  output        TARGEXP0HWRITE;     // write not read
  output  [2:0] TARGEXP0HSIZE;      // transfer size
  output        TARGEXP0HMASTLOCK;  // lock
  output [31:0] TARGEXP0HWDATA;     // write data
  output  [2:0] TARGEXP0HBURST;     // burst length
  output  [3:0] TARGEXP0HPROT;      // protection
  output  [1:0] TARGEXP0MEMATTR;    // memory attributes
  output        TARGEXP0EXREQ;      // exclusive request
  output        TARGEXP0HREADYMUX;  // ready

  input         TARGEXP0HREADYOUT;  // ready feedback
  input  [31:0] TARGEXP0HRDATA;     // read data
  input         TARGEXP0HRESP;      // transfer response
  input         TARGEXP0EXRESP;     // exclusive response

  output        TARGEXP0HAUSER;     // HAUSER
  output  [3:0] TARGEXP0HWUSER;     // HWUSER
  input   [2:0] TARGEXP0HRUSER;     // HRUSER

  // AHB MTX (<-> External Master)
  output        TARGEXP1HSEL;       // select
  output [31:0] TARGEXP1HADDR;      // address
  output  [1:0] TARGEXP1HTRANS;     // transfer type
  output  [3:0] TARGEXP1HMASTER;    // master
  output        TARGEXP1HWRITE;     // write not read
  output  [2:0] TARGEXP1HSIZE;      // transfer size
  output        TARGEXP1HMASTLOCK;  // lock
  output [31:0] TARGEXP1HWDATA;     // write data
  output  [2:0] TARGEXP1HBURST;     // burst length
  output  [3:0] TARGEXP1HPROT;      // protection
  output  [1:0] TARGEXP1MEMATTR;    // memory attributes
  output        TARGEXP1EXREQ;      // exclusive request
  output        TARGEXP1HREADYMUX;  // ready

  input         TARGEXP1HREADYOUT;  // ready feedback
  input  [31:0] TARGEXP1HRDATA;     // read data
  input         TARGEXP1HRESP;      // transfer response
  input         TARGEXP1EXRESP;     // exclusive response

  output        TARGEXP1HAUSER;     // HAUSER
  output  [3:0] TARGEXP1HWUSER;     // HWUSER
  input   [2:0] TARGEXP1HRUSER;     // HRUSER

  // AHB MTX (<-> Flash Cache)
  output        TARGFLASH0HSEL;      // select
  output [31:0] TARGFLASH0HADDR;     // address
  output  [1:0] TARGFLASH0HTRANS;    // transfer type
  output  [3:0] TARGFLASH0HMASTER;   // master
  output        TARGFLASH0HWRITE;    // write not read
  output  [2:0] TARGFLASH0HSIZE;     // transfer size
  output        TARGFLASH0HMASTLOCK; // lock
  output [31:0] TARGFLASH0HWDATA;    // write data
  output  [2:0] TARGFLASH0HBURST;    // burst length
  output  [3:0] TARGFLASH0HPROT;     // protection
  output  [1:0] TARGFLASH0MEMATTR;   // memory attributes
  output        TARGFLASH0EXREQ;     // exclusive request
  output        TARGFLASH0HREADYMUX; // ready

  input         TARGFLASH0HREADYOUT; // ready feedback
  input  [31:0] TARGFLASH0HRDATA;    // read data
  input         TARGFLASH0HRESP;     // transfer response
  input         TARGFLASH0EXRESP;    // exclusive response

  output        TARGFLASH0HAUSER;    // HAUSER
  output  [3:0] TARGFLASH0HWUSER;    // HWUSER
  input   [2:0] TARGFLASH0HRUSER;    // HRUSER

  // AHB MTX (<-> SRAM0)
  output        TARGSRAM0HSEL;      // select
  output [31:0] TARGSRAM0HADDR;     // address
  output  [1:0] TARGSRAM0HTRANS;    // transfer type
  output  [3:0] TARGSRAM0HMASTER;   // master
  output        TARGSRAM0HWRITE;    // write not read
  output  [2:0] TARGSRAM0HSIZE;     // transfer size
  output        TARGSRAM0HMASTLOCK; // lock
  output [31:0] TARGSRAM0HWDATA;    // write data
  output  [2:0] TARGSRAM0HBURST;    // burst length
  output  [3:0] TARGSRAM0HPROT;     // protection
  output  [1:0] TARGSRAM0MEMATTR;   // memory attributes
  output        TARGSRAM0EXREQ;     // exclusive request
  output        TARGSRAM0HREADYMUX; // ready

  input         TARGSRAM0HREADYOUT; // ready feedback
  input  [31:0] TARGSRAM0HRDATA;    // read data
  input         TARGSRAM0HRESP;     // transfer response
  input         TARGSRAM0EXRESP;    // exclusive response

  output        TARGSRAM0HAUSER;    // HAUSER
  output  [3:0] TARGSRAM0HWUSER;    // HWUSER
  input   [2:0] TARGSRAM0HRUSER;    // HRUSER

  // AHB MTX (<-> SRAM1)
  output        TARGSRAM1HSEL;      // select
  output [31:0] TARGSRAM1HADDR;     // address
  output  [1:0] TARGSRAM1HTRANS;    // transfer type
  output  [3:0] TARGSRAM1HMASTER;   // master
  output        TARGSRAM1HWRITE;    // write not read
  output  [2:0] TARGSRAM1HSIZE;     // transfer size
  output        TARGSRAM1HMASTLOCK; // lock
  output [31:0] TARGSRAM1HWDATA;    // write data
  output  [2:0] TARGSRAM1HBURST;    // burst length
  output  [3:0] TARGSRAM1HPROT;     // protection
  output  [1:0] TARGSRAM1MEMATTR;   // memory attributes
  output        TARGSRAM1EXREQ;     // exclusive request
  output        TARGSRAM1HREADYMUX; // ready

  input         TARGSRAM1HREADYOUT; // ready feedback
  input  [31:0] TARGSRAM1HRDATA;    // read data
  input         TARGSRAM1HRESP;     // transfer response
  input         TARGSRAM1EXRESP;    // exclusive response

  output        TARGSRAM1HAUSER;    // HAUSER
  output  [3:0] TARGSRAM1HWUSER;    // HWUSER
  input   [2:0] TARGSRAM1HRUSER;    // HRUSER

  // AHB MTX (<-> SRAM2)
  output        TARGSRAM2HSEL;      // select
  output [31:0] TARGSRAM2HADDR;     // address
  output  [1:0] TARGSRAM2HTRANS;    // transfer type
  output  [3:0] TARGSRAM2HMASTER;   // master
  output        TARGSRAM2HWRITE;    // write not read
  output  [2:0] TARGSRAM2HSIZE;     // transfer size
  output        TARGSRAM2HMASTLOCK; // lock
  output [31:0] TARGSRAM2HWDATA;    // write data
  output  [2:0] TARGSRAM2HBURST;    // burst length
  output  [3:0] TARGSRAM2HPROT;     // protection
  output  [1:0] TARGSRAM2MEMATTR;   // memory attributes
  output        TARGSRAM2EXREQ;     // exclusive request
  output        TARGSRAM2HREADYMUX; // ready

  input         TARGSRAM2HREADYOUT; // ready feedback
  input  [31:0] TARGSRAM2HRDATA;    // read data
  input         TARGSRAM2HRESP;     // transfer response
  input         TARGSRAM2EXRESP;    // exclusive response

  output        TARGSRAM2HAUSER;    // HAUSER
  output  [3:0] TARGSRAM2HWUSER;    // HWUSER
  input   [2:0] TARGSRAM2HRUSER;    // HRUSER

  // AHB MTX (<-> SRAM3)
  output        TARGSRAM3HSEL;      // select
  output [31:0] TARGSRAM3HADDR;     // address
  output  [1:0] TARGSRAM3HTRANS;    // transfer type
  output  [3:0] TARGSRAM3HMASTER;   // master
  output        TARGSRAM3HWRITE;    // write not read
  output  [2:0] TARGSRAM3HSIZE;     // transfer size
  output        TARGSRAM3HMASTLOCK; // lock
  output [31:0] TARGSRAM3HWDATA;    // write data
  output  [2:0] TARGSRAM3HBURST;    // burst length
  output  [3:0] TARGSRAM3HPROT;     // protection
  output  [1:0] TARGSRAM3MEMATTR;   // memory attributes
  output        TARGSRAM3EXREQ;     // exclusive request
  output        TARGSRAM3HREADYMUX; // ready

  input         TARGSRAM3HREADYOUT; // ready feedback
  input  [31:0] TARGSRAM3HRDATA;    // read data
  input         TARGSRAM3HRESP;     // transfer response
  input         TARGSRAM3EXRESP;    // exclusive response

  output        TARGSRAM3HAUSER;    // HAUSER
  output  [3:0] TARGSRAM3HWUSER;    // HWUSER
  input   [2:0] TARGSRAM3HRUSER;    // HRUSER

  // MTX Scan test dummy signals; not connected until scan insertion
  input         SCANENABLE;         // Scan Test Mode Enable
  input         SCANINHCLK;         // Scan Chain Input
  output        SCANOUTHCLK;        // Scan Chain Output

  // APBTARGEXP0
  output [11:0] APBTARGEXP0PADDR;   // APB Address
  output        APBTARGEXP0PENABLE; // APB Enable
  output        APBTARGEXP0PWRITE;  // APB Write
  output  [3:0] APBTARGEXP0PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP0PPROT;   // APB Prot
  output [31:0] APBTARGEXP0PWDATA;  // APB write data
  output        APBTARGEXP0PSEL;    // APB Select
  input  [31:0] APBTARGEXP0PRDATA;  // APB Read data
  input         APBTARGEXP0PREADY;  // APB ready
  input         APBTARGEXP0PSLVERR; // APB Slave Error

  // APBTARGEXP1
  output [11:0] APBTARGEXP1PADDR;   // APB Address
  output        APBTARGEXP1PENABLE; // APB Enable
  output        APBTARGEXP1PWRITE;  // APB Write
  output  [3:0] APBTARGEXP1PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP1PPROT;   // APB Prot
  output [31:0] APBTARGEXP1PWDATA;  // APB write data
  output        APBTARGEXP1PSEL;    // APB Select
  input  [31:0] APBTARGEXP1PRDATA;  // APB Read data
  input         APBTARGEXP1PREADY;  // APB ready
  input         APBTARGEXP1PSLVERR; // APB Slave Error

  // APBTARGEXP2
  output [11:0] APBTARGEXP2PADDR;   // APB Address
  output        APBTARGEXP2PENABLE; // APB Enable
  output        APBTARGEXP2PWRITE;  // APB Write
  output  [3:0] APBTARGEXP2PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP2PPROT;   // APB Prot
  output [31:0] APBTARGEXP2PWDATA;  // APB write data
  output        APBTARGEXP2PSEL;    // APB Select
  input  [31:0] APBTARGEXP2PRDATA;  // APB Read data
  input         APBTARGEXP2PREADY;  // APB ready
  input         APBTARGEXP2PSLVERR; // APB Slave Error

  // APBTARGEXP3
  output [11:0] APBTARGEXP3PADDR;   // APB Address
  output        APBTARGEXP3PENABLE; // APB Enable
  output        APBTARGEXP3PWRITE;  // APB Write
  output  [3:0] APBTARGEXP3PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP3PPROT;   // APB Prot
  output [31:0] APBTARGEXP3PWDATA;  // APB write data
  output        APBTARGEXP3PSEL;    // APB Select
  input  [31:0] APBTARGEXP3PRDATA;  // APB Read data
  input         APBTARGEXP3PREADY;  // APB ready
  input         APBTARGEXP3PSLVERR; // APB Slave Error

  // APBTARGEXP4
  output [11:0] APBTARGEXP4PADDR;   // APB Address
  output        APBTARGEXP4PENABLE; // APB Enable
  output        APBTARGEXP4PWRITE;  // APB Write
  output  [3:0] APBTARGEXP4PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP4PPROT;   // APB Prot
  output [31:0] APBTARGEXP4PWDATA;  // APB write data
  output        APBTARGEXP4PSEL;    // APB Select
  input  [31:0] APBTARGEXP4PRDATA;  // APB Read data
  input         APBTARGEXP4PREADY;  // APB ready
  input         APBTARGEXP4PSLVERR; // APB Slave Error

  // APBTARGEXP5
  output [11:0] APBTARGEXP5PADDR;   // APB Address
  output        APBTARGEXP5PENABLE; // APB Enable
  output        APBTARGEXP5PWRITE;  // APB Write
  output  [3:0] APBTARGEXP5PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP5PPROT;   // APB Prot
  output [31:0] APBTARGEXP5PWDATA;  // APB write data
  output        APBTARGEXP5PSEL;    // APB Select
  input  [31:0] APBTARGEXP5PRDATA;  // APB Read data
  input         APBTARGEXP5PREADY;  // APB ready
  input         APBTARGEXP5PSLVERR; // APB Slave Error

  // APBTARGEXP6
  output [11:0] APBTARGEXP6PADDR;   // APB Address
  output        APBTARGEXP6PENABLE; // APB Enable
  output        APBTARGEXP6PWRITE;  // APB Write
  output  [3:0] APBTARGEXP6PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP6PPROT;   // APB Prot
  output [31:0] APBTARGEXP6PWDATA;  // APB write data
  output        APBTARGEXP6PSEL;    // APB Select
  input  [31:0] APBTARGEXP6PRDATA;  // APB Read data
  input         APBTARGEXP6PREADY;  // APB ready
  input         APBTARGEXP6PSLVERR; // APB Slave Error

  // APBTARGEXP7
  output [11:0] APBTARGEXP7PADDR;   // APB Address
  output        APBTARGEXP7PENABLE; // APB Enable
  output        APBTARGEXP7PWRITE;  // APB Write
  output  [3:0] APBTARGEXP7PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP7PPROT;   // APB Prot
  output [31:0] APBTARGEXP7PWDATA;  // APB write data
  output        APBTARGEXP7PSEL;    // APB Select
  input  [31:0] APBTARGEXP7PRDATA;  // APB Read data
  input         APBTARGEXP7PREADY;  // APB ready
  input         APBTARGEXP7PSLVERR; // APB Slave Error

  // APBTARGEXP8
  output [11:0] APBTARGEXP8PADDR;   // APB Address
  output        APBTARGEXP8PENABLE; // APB Enable
  output        APBTARGEXP8PWRITE;  // APB Write
  output  [3:0] APBTARGEXP8PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP8PPROT;   // APB Prot
  output [31:0] APBTARGEXP8PWDATA;  // APB write data
  output        APBTARGEXP8PSEL;    // APB Select
  input  [31:0] APBTARGEXP8PRDATA;  // APB Read data
  input         APBTARGEXP8PREADY;  // APB ready
  input         APBTARGEXP8PSLVERR; // APB Slave Error

  // APBTARGEXP9
  output [11:0] APBTARGEXP9PADDR;   // APB Address
  output        APBTARGEXP9PENABLE; // APB Enable
  output        APBTARGEXP9PWRITE;  // APB Write
  output  [3:0] APBTARGEXP9PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP9PPROT;   // APB Prot
  output [31:0] APBTARGEXP9PWDATA;  // APB write data
  output        APBTARGEXP9PSEL;    // APB Select
  input  [31:0] APBTARGEXP9PRDATA;  // APB Read data
  input         APBTARGEXP9PREADY;  // APB ready
  input         APBTARGEXP9PSLVERR; // APB Slave Error

  // APBTARGEXP10
  output [11:0] APBTARGEXP10PADDR;   // APB Address
  output        APBTARGEXP10PENABLE; // APB Enable
  output        APBTARGEXP10PWRITE;  // APB Write
  output  [3:0] APBTARGEXP10PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP10PPROT;   // APB Prot
  output [31:0] APBTARGEXP10PWDATA;  // APB write data
  output        APBTARGEXP10PSEL;    // APB Select
  input  [31:0] APBTARGEXP10PRDATA;  // APB Read data
  input         APBTARGEXP10PREADY;  // APB ready
  input         APBTARGEXP10PSLVERR; // APB Slave Error

  // APBTARGEXP11
  output [11:0] APBTARGEXP11PADDR;   // APB Address
  output        APBTARGEXP11PENABLE; // APB Enable
  output        APBTARGEXP11PWRITE;  // APB Write
  output  [3:0] APBTARGEXP11PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP11PPROT;   // APB Prot
  output [31:0] APBTARGEXP11PWDATA;  // APB write data
  output        APBTARGEXP11PSEL;    // APB Select
  input  [31:0] APBTARGEXP11PRDATA;  // APB Read data
  input         APBTARGEXP11PREADY;  // APB ready
  input         APBTARGEXP11PSLVERR; // APB Slave Error

  // APBTARGEXP12
  output [11:0] APBTARGEXP12PADDR;   // APB Address
  output        APBTARGEXP12PENABLE; // APB Enable
  output        APBTARGEXP12PWRITE;  // APB Write
  output  [3:0] APBTARGEXP12PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP12PPROT;   // APB Prot
  output [31:0] APBTARGEXP12PWDATA;  // APB write data
  output        APBTARGEXP12PSEL;    // APB Select
  input  [31:0] APBTARGEXP12PRDATA;  // APB Read data
  input         APBTARGEXP12PREADY;  // APB ready
  input         APBTARGEXP12PSLVERR; // APB Slave Error

  // APBTARGEXP13
  output [11:0] APBTARGEXP13PADDR;   // APB Address
  output        APBTARGEXP13PENABLE; // APB Enable
  output        APBTARGEXP13PWRITE;  // APB Write
  output  [3:0] APBTARGEXP13PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP13PPROT;   // APB Prot
  output [31:0] APBTARGEXP13PWDATA;  // APB write data
  output        APBTARGEXP13PSEL;    // APB Select
  input  [31:0] APBTARGEXP13PRDATA;  // APB Read data
  input         APBTARGEXP13PREADY;  // APB ready
  input         APBTARGEXP13PSLVERR; // APB Slave Error

  // APBTARGEXP14
  output [11:0] APBTARGEXP14PADDR;   // APB Address
  output        APBTARGEXP14PENABLE; // APB Enable
  output        APBTARGEXP14PWRITE;  // APB Write
  output  [3:0] APBTARGEXP14PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP14PPROT;   // APB Prot
  output [31:0] APBTARGEXP14PWDATA;  // APB write data
  output        APBTARGEXP14PSEL;    // APB Select
  input  [31:0] APBTARGEXP14PRDATA;  // APB Read data
  input         APBTARGEXP14PREADY;  // APB ready
  input         APBTARGEXP14PSLVERR; // APB Slave Error

  // APBTARGEXP15
  output [11:0] APBTARGEXP15PADDR;   // APB Address
  output        APBTARGEXP15PENABLE; // APB Enable
  output        APBTARGEXP15PWRITE;  // APB Write
  output  [3:0] APBTARGEXP15PSTRB;   // APB Byte Strobe
  output  [2:0] APBTARGEXP15PPROT;   // APB Prot
  output [31:0] APBTARGEXP15PWDATA;  // APB write data
  output        APBTARGEXP15PSEL;    // APB Select
  input  [31:0] APBTARGEXP15PRDATA;  // APB Read data
  input         APBTARGEXP15PREADY;  // APB ready
  input         APBTARGEXP15PSLVERR; // APB Slave Error


  // ----------------------------------------------------------------------------
  // Port wire/reg declarsations
  // ----------------------------------------------------------------------------
  // Common AHB signals
  wire          MTXHCLK;           // Interconnect AHB system clock
  wire          MTXHRESETn;        // Interconnect AHB system reset
  wire          AHB2APBHCLK;       // AHB to APB Bridge clock

  // Controll port
  wire    [3:0] MTXREMAP;          // REMAP input

  // CPU I-Code (<-> Code Mux)
  wire   [31:0] HADDRI;            // ICode address
  wire    [1:0] HTRANSI;           // ICode transfer type
  wire    [2:0] HSIZEI;            // ICode transfer size
  wire    [2:0] HBURSTI;           // ICode burst type
  wire    [3:0] HPROTI;            // ICode protection control
  wire    [1:0] MEMATTRI;          // ICode memory attributes
  wire   [31:0] HRDATAI;           // ICode read data
  wire          HREADYI;           // ICode transfer completed
  wire    [1:0] HRESPI;            // ICode response status

  // CPU D-Code (<-> Code Mux)
  wire   [31:0] HADDRD;            // DCode address
  wire    [1:0] HTRANSD;           // DCode transfer type
  wire    [1:0] HMASTERD;          // DCode master (-> Bus MTX)
  wire    [2:0] HSIZED;            // DCode transfer size
  wire    [2:0] HBURSTD;           // DCode burst type
  wire    [3:0] HPROTD;            // DCode protection control
  wire    [1:0] MEMATTRD;          // DCode memory attributes (-> logic -> Bus MTX)
  wire   [31:0] HWDATAD;           // DCode write data
  wire          HWRITED;           // DCode write not read
  wire          EXREQD;            // DCode exclusive request
  wire   [31:0] HRDATAD;           // DCode read data
  wire          HREADYD;           // DCode transfer completed
  wire    [1:0] HRESPD;            // DCode response status
  wire          EXRESPD;           // DCode exclusive response

  // CPU System bus (<-> AHB MTX)
  wire   [31:0] HADDRS;            // System address
  wire    [1:0] HTRANSS;           // System transfer type
  wire    [1:0] HMASTERS;          // System master
  wire          HWRITES;           // System write not read
  wire    [2:0] HSIZES;            // System transfer size
  wire          HMASTLOCKS;        // System lock
  wire   [31:0] HWDATAS;           // System write data
  wire    [2:0] HBURSTS;           // System burst length
  wire    [3:0] HPROTS;            // System protection
  wire    [1:0] MEMATTRS;          // System memory attributes
  wire          EXREQS;            // System exclusive request
  wire          HREADYS;           // System ready
  wire   [31:0] HRDATAS;           // System read data
  wire    [1:0] HRESPS;            // System transfer response
  wire          EXRESPS;           // System exclusive response

  wire          HAUSERINITCM3S;     // System HAUSER
  wire    [3:0] HWUSERINITCM3S;     // System HWUSER
  wire    [2:0] HRUSERINITCM3S;     // System HRUSER


  // Radio (<-> AHB MTX)
  wire          INITEXP0HSEL;      // select
  wire   [31:0] INITEXP0HADDR;     // address
  wire    [1:0] INITEXP0HTRANS;    // transfer type
  wire    [3:0] INITEXP0HMASTER;   // master
  wire          INITEXP0HWRITE;    // write not read
  wire    [2:0] INITEXP0HSIZE;     // transfer size
  wire          INITEXP0HMASTLOCK; // lock
  wire   [31:0] INITEXP0HWDATA;    // write data
  wire    [2:0] INITEXP0HBURST;    // burst length
  wire    [3:0] INITEXP0HPROT;     // protection
  wire    [1:0] INITEXP0MEMATTR;   // memory attributes
  wire          INITEXP0EXREQ;     // exclusive request
  wire          INITEXP0HREADY;    // transfer done
  wire   [31:0] INITEXP0HRDATA;    // read data
  wire          INITEXP0HRESP;     // transfer response
  wire          INITEXP0EXRESP;    // exclusive response

  wire          INITEXP0HAUSER;    // HAUSER
  wire    [3:0] INITEXP0HWUSER;    // HWUSER
  wire    [2:0] INITEXP0HRUSER;    // HRUSER

  // External Master (<-> AHB MTX)
  wire          INITEXP1HSEL;      // select
  wire   [31:0] INITEXP1HADDR;     // address
  wire    [1:0] INITEXP1HTRANS;    // transfer type
  wire    [3:0] INITEXP1HMASTER;   // master
  wire          INITEXP1HWRITE;    // write not read
  wire    [2:0] INITEXP1HSIZE;     // transfer size
  wire          INITEXP1HMASTLOCK; // lock
  wire   [31:0] INITEXP1HWDATA;    // write data
  wire    [2:0] INITEXP1HBURST;    // burst length
  wire    [3:0] INITEXP1HPROT;     // protection
  wire    [1:0] INITEXP1MEMATTR;   // memory attributes
  wire          INITEXP1EXREQ;     // exclusive request
  wire          INITEXP1HREADY;    // transfer done
  wire   [31:0] INITEXP1HRDATA;    // read data
  wire          INITEXP1HRESP;     // transfer response
  wire          INITEXP1EXRESP;    // exclusive response

  wire          INITEXP1HAUSER;    // HAUSER
  wire    [3:0] INITEXP1HWUSER;    // HWUSER
  wire    [2:0] INITEXP1HRUSER;    // HRUSER

  // AHB MTX (<-> Radio)
  wire          TARGEXP0HSEL;      // select
  wire   [31:0] TARGEXP0HADDR;     // address
  wire    [1:0] TARGEXP0HTRANS;    // transfer type
  wire    [3:0] TARGEXP0HMASTER;   // master
  wire          TARGEXP0HWRITE;    // write not read
  wire    [2:0] TARGEXP0HSIZE;     // transfer size
  wire          TARGEXP0HMASTLOCK; // lock
  wire   [31:0] TARGEXP0HWDATA;    // write data
  wire    [2:0] TARGEXP0HBURST;    // burst length
  wire    [3:0] TARGEXP0HPROT;     // protection
  wire    [1:0] TARGEXP0MEMATTR;   // memory attributes
  wire          TARGEXP0EXREQ;     // exclusive request
  wire          TARGEXP0HREADYMUX; // ready
  wire          TARGEXP0HREADYOUT; // ready feedback
  wire   [31:0] TARGEXP0HRDATA;    // read data
  wire          TARGEXP0HRESP;     // transfer response
  wire          TARGEXP0EXRESP;    // exclusive response

  wire          TARGEXP0HAUSER;    // HAUSER
  wire    [3:0] TARGEXP0HWUSER;    // HWUSER
  wire    [2:0] TARGEXP0HRUSER;    // HRUSER

  // AHB MTX (<-> Radio)
  wire          TARGEXP1HSEL;      // select
  wire   [31:0] TARGEXP1HADDR;     // address
  wire    [1:0] TARGEXP1HTRANS;    // transfer type
  wire    [3:0] TARGEXP1HMASTER;   // master
  wire          TARGEXP1HWRITE;    // write not read
  wire    [2:0] TARGEXP1HSIZE;     // transfer size
  wire          TARGEXP1HMASTLOCK; // lock
  wire   [31:0] TARGEXP1HWDATA;    // write data
  wire    [2:0] TARGEXP1HBURST;    // burst length
  wire    [3:0] TARGEXP1HPROT;     // protection
  wire    [1:0] TARGEXP1MEMATTR;   // memory attributes
  wire          TARGEXP1EXREQ;     // exclusive request
  wire          TARGEXP1HREADYMUX; // ready
  wire          TARGEXP1HREADYOUT; // ready feedback
  wire   [31:0] TARGEXP1HRDATA;    // read data
  wire          TARGEXP1HRESP;     // transfer response
  wire          TARGEXP1EXRESP;    // exclusive response

  wire          TARGEXP1HAUSER;    // HAUSER
  wire    [3:0] TARGEXP1HWUSER;    // HWUSER
  wire    [2:0] TARGEXP1HRUSER;    // HRUSER

  // AHB MTX (<-> Flash Cache)
  wire          TARGFLASH0HSEL;      // select
  wire   [31:0] TARGFLASH0HADDR;     // address
  wire    [1:0] TARGFLASH0HTRANS;    // transfer type
  wire    [3:0] TARGFLASH0HMASTER;   // master
  wire          TARGFLASH0HWRITE;    // write not read
  wire    [2:0] TARGFLASH0HSIZE;     // transfer size
  wire          TARGFLASH0HMASTLOCK; // lock
  wire   [31:0] TARGFLASH0HWDATA;    // write data
  wire    [2:0] TARGFLASH0HBURST;    // burst length
  wire    [3:0] TARGFLASH0HPROT;     // protection
  wire    [1:0] TARGFLASH0MEMATTR;   // memory attributes
  wire          TARGFLASH0EXREQ;     // exclusive request
  wire          TARGFLASH0HREADYMUX; // ready
  wire          TARGFLASH0HREADYOUT; // ready feedback
  wire   [31:0] TARGFLASH0HRDATA;    // read data
  wire          TARGFLASH0HRESP;     // transfer response
  wire          TARGFLASH0EXRESP;    // exclusive response

  wire          TARGFLASH0HAUSER;    // HAUSER
  wire    [3:0] TARGFLASH0HWUSER;    // HWUSER
  wire    [2:0] TARGFLASH0HRUSER;    // HRUSER

  // AHB MTX (<-> SRAM0)
  wire          TARGSRAM0HSEL;      // select
  wire   [31:0] TARGSRAM0HADDR;     // address
  wire    [1:0] TARGSRAM0HTRANS;    // transfer type
  wire    [3:0] TARGSRAM0HMASTER;   // master
  wire          TARGSRAM0HWRITE;    // write not read
  wire    [2:0] TARGSRAM0HSIZE;     // transfer size
  wire          TARGSRAM0HMASTLOCK; // lock
  wire   [31:0] TARGSRAM0HWDATA;    // write data
  wire    [2:0] TARGSRAM0HBURST;    // burst length
  wire    [3:0] TARGSRAM0HPROT;     // protection
  wire    [1:0] TARGSRAM0MEMATTR;   // memory attributes
  wire          TARGSRAM0EXREQ;     // exclusive request
  wire          TARGSRAM0HREADYMUX; // ready
  wire          TARGSRAM0HREADYOUT; // ready feedback
  wire   [31:0] TARGSRAM0HRDATA;    // read data
  wire          TARGSRAM0HRESP;     // transfer response
  wire          TARGSRAM0EXRESP;    // exclusive response

  wire          TARGSRAM0HAUSER;    // HAUSER
  wire    [3:0] TARGSRAM0HWUSER;    // HWUSER
  wire    [2:0] TARGSRAM0HRUSER;    // HRUSER

  // AHB MTX (<-> SRAM1)
  wire          TARGSRAM1HSEL;      // select
  wire   [31:0] TARGSRAM1HADDR;     // address
  wire    [1:0] TARGSRAM1HTRANS;    // transfer type
  wire    [3:0] TARGSRAM1HMASTER;   // master
  wire          TARGSRAM1HWRITE;    // write not read
  wire    [2:0] TARGSRAM1HSIZE;     // transfer size
  wire          TARGSRAM1HMASTLOCK; // lock
  wire   [31:0] TARGSRAM1HWDATA;    // write data
  wire    [2:0] TARGSRAM1HBURST;    // burst length
  wire    [3:0] TARGSRAM1HPROT;     // protection
  wire    [1:0] TARGSRAM1MEMATTR;   // memory attributes
  wire          TARGSRAM1EXREQ;     // exclusive request
  wire          TARGSRAM1HREADYMUX; // ready
  wire          TARGSRAM1HREADYOUT; // ready feedback
  wire   [31:0] TARGSRAM1HRDATA;    // read data
  wire          TARGSRAM1HRESP;     // transfer response
  wire          TARGSRAM1EXRESP;    // exclusive response

  wire          TARGSRAM1HAUSER;    // HAUSER
  wire    [3:0] TARGSRAM1HWUSER;    // HWUSER
  wire    [2:0] TARGSRAM1HRUSER;    // HRUSER

  // AHB MTX (<-> SRAM2)
  wire          TARGSRAM2HSEL;      // select
  wire   [31:0] TARGSRAM2HADDR;     // address
  wire    [1:0] TARGSRAM2HTRANS;    // transfer type
  wire    [3:0] TARGSRAM2HMASTER;   // master
  wire          TARGSRAM2HWRITE;    // write not read
  wire    [2:0] TARGSRAM2HSIZE;     // transfer size
  wire          TARGSRAM2HMASTLOCK; // lock
  wire   [31:0] TARGSRAM2HWDATA;    // write data
  wire    [2:0] TARGSRAM2HBURST;    // burst length
  wire    [3:0] TARGSRAM2HPROT;     // protection
  wire    [1:0] TARGSRAM2MEMATTR;   // memory attributes
  wire          TARGSRAM2EXREQ;     // exclusive request
  wire          TARGSRAM2HREADYMUX; // ready
  wire          TARGSRAM2HREADYOUT; // ready feedback
  wire   [31:0] TARGSRAM2HRDATA;    // read data
  wire          TARGSRAM2HRESP;     // transfer response
  wire          TARGSRAM2EXRESP;    // exclusive response

  wire          TARGSRAM2HAUSER;    // HAUSER
  wire    [3:0] TARGSRAM2HWUSER;    // HWUSER
  wire    [2:0] TARGSRAM2HRUSER;    // HRUSER

  // AHB MTX (<-> SRAM3)
  wire          TARGSRAM3HSEL;      // select
  wire   [31:0] TARGSRAM3HADDR;     // address
  wire    [1:0] TARGSRAM3HTRANS;    // transfer type
  wire    [3:0] TARGSRAM3HMASTER;   // master
  wire          TARGSRAM3HWRITE;    // write not read
  wire    [2:0] TARGSRAM3HSIZE;     // transfer size
  wire          TARGSRAM3HMASTLOCK; // lock
  wire   [31:0] TARGSRAM3HWDATA;    // write data
  wire    [2:0] TARGSRAM3HBURST;    // burst length
  wire    [3:0] TARGSRAM3HPROT;     // protection
  wire    [1:0] TARGSRAM3MEMATTR;   // memory attributes
  wire          TARGSRAM3EXREQ;     // exclusive request
  wire          TARGSRAM3HREADYMUX; // ready
  wire          TARGSRAM3HREADYOUT; // ready feedback
  wire   [31:0] TARGSRAM3HRDATA;    // read data
  wire          TARGSRAM3HRESP;     // transfer response
  wire          TARGSRAM3EXRESP;    // exclusive response

  wire          TARGSRAM3HAUSER;    // HAUSER
  wire    [3:0] TARGSRAM3HWUSER;    // HWUSER
  wire    [2:0] TARGSRAM3HRUSER;    // HRUSER

  // AHB MTX (<-> AHB2APB)
  wire          targapb0hsel;       // select
  wire   [31:0] targapb0haddr;      // address
  wire    [1:0] targapb0htrans;     // transfer type
  wire          targapb0hwrite;     // write not read
  wire    [2:0] targapb0hsize;      // transfer size
  wire   [31:0] targapb0hwdata;     // write data
  wire    [3:0] targapb0hprot;      // protection
  wire          targapb0hreadymux;  // ready
  wire          targapb0hreadyout;  // ready feedback
  wire   [31:0] targapb0hrdata;     // read data
  wire          targapb0hresp;      // transfer response

  // MTX Scan test dummy signals; not connected until scan insertion
  wire          SCANENABLE;         // Scan Test Mode Enable
  wire          SCANINHCLK;         // Scan Chain Input
  wire          SCANOUTHCLK;        // Scan Chain Output

  // APBTARGEXP0
  wire   [11:0] APBTARGEXP0PADDR;   // APB Address
  wire          APBTARGEXP0PENABLE; // APB Enable
  wire          APBTARGEXP0PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP0PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP0PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP0PWDATA;  // APB write data
  wire          APBTARGEXP0PSEL;    // APB Select
  wire   [31:0] APBTARGEXP0PRDATA;  // APB Read data
  wire          APBTARGEXP0PREADY;  // APB ready
  wire          APBTARGEXP0PSLVERR; // APB Slave Error

  // APBTARGEXP1
  wire   [11:0] APBTARGEXP1PADDR;   // APB Address
  wire          APBTARGEXP1PENABLE; // APB Enable
  wire          APBTARGEXP1PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP1PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP1PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP1PWDATA;  // APB write data
  wire          APBTARGEXP1PSEL;    // APB Select
  wire   [31:0] APBTARGEXP1PRDATA;  // APB Read data
  wire          APBTARGEXP1PREADY;  // APB ready
  wire          APBTARGEXP1PSLVERR; // APB Slave Error

  // APBTARGEXP2
  wire   [11:0] APBTARGEXP2PADDR;   // APB Address
  wire          APBTARGEXP2PENABLE; // APB Enable
  wire          APBTARGEXP2PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP2PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP2PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP2PWDATA;  // APB write data
  wire          APBTARGEXP2PSEL;    // APB Select
  wire   [31:0] APBTARGEXP2PRDATA;  // APB Read data
  wire          APBTARGEXP2PREADY;  // APB ready
  wire          APBTARGEXP2PSLVERR; // APB Slave Error

  // APBTARGEXP3
  wire   [11:0] APBTARGEXP3PADDR;   // APB Address
  wire          APBTARGEXP3PENABLE; // APB Enable
  wire          APBTARGEXP3PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP3PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP3PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP3PWDATA;  // APB write data
  wire          APBTARGEXP3PSEL;    // APB Select
  wire   [31:0] APBTARGEXP3PRDATA;  // APB Read data
  wire          APBTARGEXP3PREADY;  // APB ready
  wire          APBTARGEXP3PSLVERR; // APB Slave Error

  // APBTARGEXP4
  wire   [11:0] APBTARGEXP4PADDR;   // APB Address
  wire          APBTARGEXP4PENABLE; // APB Enable
  wire          APBTARGEXP4PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP4PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP4PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP4PWDATA;  // APB write data
  wire          APBTARGEXP4PSEL;    // APB Select
  wire   [31:0] APBTARGEXP4PRDATA;  // APB Read data
  wire          APBTARGEXP4PREADY;  // APB ready
  wire          APBTARGEXP4PSLVERR; // APB Slave Error

  // APBTARGEXP5
  wire   [11:0] APBTARGEXP5PADDR;   // APB Address
  wire          APBTARGEXP5PENABLE; // APB Enable
  wire          APBTARGEXP5PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP5PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP5PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP5PWDATA;  // APB write data
  wire          APBTARGEXP5PSEL;    // APB Select
  wire   [31:0] APBTARGEXP5PRDATA;  // APB Read data
  wire          APBTARGEXP5PREADY;  // APB ready
  wire          APBTARGEXP5PSLVERR; // APB Slave Error

  // APBTARGEXP6
  wire   [11:0] APBTARGEXP6PADDR;   // APB Address
  wire          APBTARGEXP6PENABLE; // APB Enable
  wire          APBTARGEXP6PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP6PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP6PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP6PWDATA;  // APB write data
  wire          APBTARGEXP6PSEL;    // APB Select
  wire   [31:0] APBTARGEXP6PRDATA;  // APB Read data
  wire          APBTARGEXP6PREADY;  // APB ready
  wire          APBTARGEXP6PSLVERR; // APB Slave Error

  // APBTARGEXP7
  wire   [11:0] APBTARGEXP7PADDR;   // APB Address
  wire          APBTARGEXP7PENABLE; // APB Enable
  wire          APBTARGEXP7PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP7PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP7PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP7PWDATA;  // APB write data
  wire          APBTARGEXP7PSEL;    // APB Select
  wire   [31:0] APBTARGEXP7PRDATA;  // APB Read data
  wire          APBTARGEXP7PREADY;  // APB ready
  wire          APBTARGEXP7PSLVERR; // APB Slave Error

  // APBTARGEXP8
  wire   [11:0] APBTARGEXP8PADDR;   // APB Address
  wire          APBTARGEXP8PENABLE; // APB Enable
  wire          APBTARGEXP8PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP8PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP8PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP8PWDATA;  // APB write data
  wire          APBTARGEXP8PSEL;    // APB Select
  wire   [31:0] APBTARGEXP8PRDATA;  // APB Read data
  wire          APBTARGEXP8PREADY;  // APB ready
  wire          APBTARGEXP8PSLVERR; // APB Slave Error

  // APBTARGEXP9
  wire   [11:0] APBTARGEXP9PADDR;   // APB Address
  wire          APBTARGEXP9PENABLE; // APB Enable
  wire          APBTARGEXP9PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP9PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP9PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP9PWDATA;  // APB write data
  wire          APBTARGEXP9PSEL;    // APB Select
  wire   [31:0] APBTARGEXP9PRDATA;  // APB Read data
  wire          APBTARGEXP9PREADY;  // APB ready
  wire          APBTARGEXP9PSLVERR; // APB Slave Error

  // APBTARGEXP10
  wire   [11:0] APBTARGEXP10PADDR;   // APB Address
  wire          APBTARGEXP10PENABLE; // APB Enable
  wire          APBTARGEXP10PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP10PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP10PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP10PWDATA;  // APB write data
  wire          APBTARGEXP10PSEL;    // APB Select
  wire   [31:0] APBTARGEXP10PRDATA;  // APB Read data
  wire          APBTARGEXP10PREADY;  // APB ready
  wire          APBTARGEXP10PSLVERR; // APB Slave Error

  // APBTARGEXP11
  wire   [11:0] APBTARGEXP11PADDR;   // APB Address
  wire          APBTARGEXP11PENABLE; // APB Enable
  wire          APBTARGEXP11PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP11PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP11PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP11PWDATA;  // APB write data
  wire          APBTARGEXP11PSEL;    // APB Select
  wire   [31:0] APBTARGEXP11PRDATA;  // APB Read data
  wire          APBTARGEXP11PREADY;  // APB ready
  wire          APBTARGEXP11PSLVERR; // APB Slave Error

  // APBTARGEXP12
  wire   [11:0] APBTARGEXP12PADDR;   // APB Address
  wire          APBTARGEXP12PENABLE; // APB Enable
  wire          APBTARGEXP12PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP12PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP12PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP12PWDATA;  // APB write data
  wire          APBTARGEXP12PSEL;    // APB Select
  wire   [31:0] APBTARGEXP12PRDATA;  // APB Read data
  wire          APBTARGEXP12PREADY;  // APB ready
  wire          APBTARGEXP12PSLVERR; // APB Slave Error

  // APBTARGEXP13
  wire   [11:0] APBTARGEXP13PADDR;   // APB Address
  wire          APBTARGEXP13PENABLE; // APB Enable
  wire          APBTARGEXP13PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP13PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP13PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP13PWDATA;  // APB write data
  wire          APBTARGEXP13PSEL;    // APB Select
  wire   [31:0] APBTARGEXP13PRDATA;  // APB Read data
  wire          APBTARGEXP13PREADY;  // APB ready
  wire          APBTARGEXP13PSLVERR; // APB Slave Error

  // APBTARGEXP14
  wire   [11:0] APBTARGEXP14PADDR;   // APB Address
  wire          APBTARGEXP14PENABLE; // APB Enable
  wire          APBTARGEXP14PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP14PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP14PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP14PWDATA;  // APB write data
  wire          APBTARGEXP14PSEL;    // APB Select
  wire   [31:0] APBTARGEXP14PRDATA;  // APB Read data
  wire          APBTARGEXP14PREADY;  // APB ready
  wire          APBTARGEXP14PSLVERR; // APB Slave Error

  // APBTARGEXP15
  wire   [11:0] APBTARGEXP15PADDR;   // APB Address
  wire          APBTARGEXP15PENABLE; // APB Enable
  wire          APBTARGEXP15PWRITE;  // APB Write
  wire    [3:0] APBTARGEXP15PSTRB;   // APB Byte Strobe
  wire    [2:0] APBTARGEXP15PPROT;   // APB Prot
  wire   [31:0] APBTARGEXP15PWDATA;  // APB write data
  wire          APBTARGEXP15PSEL;    // APB Select
  wire   [31:0] APBTARGEXP15PRDATA;  // APB Read data
  wire          APBTARGEXP15PREADY;  // APB ready
  wire          APBTARGEXP15PSLVERR; // APB Slave Error


  //------------------------------------------------
  // Internal wires
  //------------------------------------------------
  // Bus matrix -> Code Mux
  wire   [31:0] hrdatac;           // Code bus read data
  wire          hreadyc;           // Code bus transfer completed
  wire    [1:0] hrespc;            // Code bus response status (AHB-Lite)
  wire          exrespc;           // Code bus exclusive response

  // Code Mux -> bus matrix
  wire   [31:0] haddrc;            // Code bus address
  wire   [31:0] hwdatac;           // Code bus write data
  wire    [1:0] htransc;           // Code bus transfer type
  wire          hwritec;           // Code bus write not read
  wire    [2:0] hsizec;            // Code bus transfer size
  wire    [2:0] hburstc;           // Code bus burst type
  wire    [3:0] hprotc;            // Code bus protection control
  wire          exreqc;            // Code bus exclusive request
  wire    [1:0] memattrc;          // Code bus memory attributes (logic -> Bus MTX)

  // Response signals
  wire    [1:0] i_initexp0hresp;   // Internaly used HRESP
  wire    [1:0] i_initexp1hresp;   // Internaly used HRESP
  wire    [1:0] i_targexp0hresp;   // Internaly used HRESP
  wire    [1:0] i_targexp1hresp;   // Internaly used HRESP
  wire    [1:0] i_targflash0hresp; // Internaly used HRESP
  wire    [1:0] i_targsram0hresp;  // Internaly used HRESP
  wire    [1:0] i_targsram1hresp;  // Internaly used HRESP
  wire    [1:0] i_targsram2hresp;  // Internaly used HRESP
  wire    [1:0] i_targsram3hresp;  // Internaly used HRESP
  wire    [1:0] i_targapb0hresp;   // Internaly used HRESP

  // AHB2APB wires
  wire   [15:0] ahb2apb_paddr;     // APB Address
  wire          ahb2apb_penable;   // APB Enable
  wire          ahb2apb_pwrite;    // APB Write
  wire    [3:0] ahb2apb_pstrb;     // APB Byte Strobe
  wire    [2:0] ahb2apb_pprot;     // APB Prot
  wire   [31:0] ahb2apb_pwdata;    // APB write data
  wire          ahb2apb_psel;      // APB Select
  wire   [31:0] ahb2apb_prdata;    // Read data for each APB slave
  wire          ahb2apb_pready;    // Ready for each APB slave
  wire          ahb2apb_pslverr;   // Error state for each APB slave


  wire          hreadyoutinitcm3s;  // System ready
  wire          hreadyoutinitexp0;  // transfer done
  wire          hreadyoutinitexp1;  // transfer done

  // ------------------------------------------------------------
  // Support Logic
  // ------------------------------------------------------------

  assign HREADYS           = hreadyoutinitcm3s;     // System ready
  assign INITEXP0HREADY    = hreadyoutinitexp0;     // transfer done
  assign INITEXP1HREADY    = hreadyoutinitexp1;     // transfer done

  //Codemux extension for MEMATTR
  assign memattrc          = HTRANSD[1] ? MEMATTRD  : MEMATTRI;

  //AHB lite protoll only uses HRESP[0]
  assign INITEXP0HRESP     = i_initexp0hresp[0];
  assign INITEXP1HRESP     = i_initexp1hresp[0];

  assign i_targexp0hresp   = {1'b0,TARGEXP0HRESP};
  assign i_targexp1hresp   = {1'b0,TARGEXP1HRESP};
  assign i_targflash0hresp = {1'b0,TARGFLASH0HRESP};
  assign i_targsram0hresp  = {1'b0,TARGSRAM0HRESP};
  assign i_targsram1hresp  = {1'b0,TARGSRAM1HRESP};
  assign i_targsram2hresp  = {1'b0,TARGSRAM2HRESP};
  assign i_targsram3hresp  = {1'b0,TARGSRAM3HRESP};
  assign i_targapb0hresp   = {1'b0,targapb0hresp};

  // APBTARGEXP0
  assign APBTARGEXP0PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP0PENABLE = ahb2apb_penable;
  assign APBTARGEXP0PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP0PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP0PPROT   = ahb2apb_pprot;
  assign APBTARGEXP0PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP1
  assign APBTARGEXP1PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP1PENABLE = ahb2apb_penable;
  assign APBTARGEXP1PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP1PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP1PPROT   = ahb2apb_pprot;
  assign APBTARGEXP1PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP2
  assign APBTARGEXP2PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP2PENABLE = ahb2apb_penable;
  assign APBTARGEXP2PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP2PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP2PPROT   = ahb2apb_pprot;
  assign APBTARGEXP2PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP3
  assign APBTARGEXP3PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP3PENABLE = ahb2apb_penable;
  assign APBTARGEXP3PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP3PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP3PPROT   = ahb2apb_pprot;
  assign APBTARGEXP3PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP4
  assign APBTARGEXP4PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP4PENABLE = ahb2apb_penable;
  assign APBTARGEXP4PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP4PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP4PPROT   = ahb2apb_pprot;
  assign APBTARGEXP4PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP5
  assign APBTARGEXP5PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP5PENABLE = ahb2apb_penable;
  assign APBTARGEXP5PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP5PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP5PPROT   = ahb2apb_pprot;
  assign APBTARGEXP5PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP6
  assign APBTARGEXP6PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP6PENABLE = ahb2apb_penable;
  assign APBTARGEXP6PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP6PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP6PPROT   = ahb2apb_pprot;
  assign APBTARGEXP6PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP7
  assign APBTARGEXP7PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP7PENABLE = ahb2apb_penable;
  assign APBTARGEXP7PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP7PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP7PPROT   = ahb2apb_pprot;
  assign APBTARGEXP7PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP8
  assign APBTARGEXP8PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP8PENABLE = ahb2apb_penable;
  assign APBTARGEXP8PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP8PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP8PPROT   = ahb2apb_pprot;
  assign APBTARGEXP8PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP9
  assign APBTARGEXP9PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP9PENABLE = ahb2apb_penable;
  assign APBTARGEXP9PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP9PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP9PPROT   = ahb2apb_pprot;
  assign APBTARGEXP9PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP10
  assign APBTARGEXP10PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP10PENABLE = ahb2apb_penable;
  assign APBTARGEXP10PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP10PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP10PPROT   = ahb2apb_pprot;
  assign APBTARGEXP10PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP11
  assign APBTARGEXP11PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP11PENABLE = ahb2apb_penable;
  assign APBTARGEXP11PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP11PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP11PPROT   = ahb2apb_pprot;
  assign APBTARGEXP11PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP12
  assign APBTARGEXP12PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP12PENABLE = ahb2apb_penable;
  assign APBTARGEXP12PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP12PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP12PPROT   = ahb2apb_pprot;
  assign APBTARGEXP12PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP13
  assign APBTARGEXP13PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP13PENABLE = ahb2apb_penable;
  assign APBTARGEXP13PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP13PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP13PPROT   = ahb2apb_pprot;
  assign APBTARGEXP13PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP14
  assign APBTARGEXP14PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP14PENABLE = ahb2apb_penable;
  assign APBTARGEXP14PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP14PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP14PPROT   = ahb2apb_pprot;
  assign APBTARGEXP14PWDATA  = ahb2apb_pwdata;

  // APBTARGEXP15
  assign APBTARGEXP15PADDR   = ahb2apb_paddr[11:0];
  assign APBTARGEXP15PENABLE = ahb2apb_penable;
  assign APBTARGEXP15PWRITE  = ahb2apb_pwrite;
  assign APBTARGEXP15PSTRB   = ahb2apb_pstrb;
  assign APBTARGEXP15PPROT   = ahb2apb_pprot;
  assign APBTARGEXP15PWDATA  = ahb2apb_pwdata;


  // ------------------------------------------------------------
  // Code Multiplexer instance
  // ------------------------------------------------------------
  p_beid_interconnect_f0_ahb_code_mux u_p_beid_interconnect_f0_ahb_code_mux (
     // Common AHB signals
     .HCLK(       MTXHCLK          ),   // AHB system clock
     .HRESETn(    MTXHRESETn       ),   // AHB system reset

     // CPU side inputs
     .HADDRI(     HADDRI           ),   // ICode address
     .HTRANSI(    HTRANSI          ),   // ICode transfer type
     .HSIZEI(     HSIZEI           ),   // ICode transfer size
     .HBURSTI(    HBURSTI          ),   // ICode burst type
     .HPROTI(     HPROTI           ),   // ICode protection control
     .HADDRD(     HADDRD           ),   // DCode address
     .HTRANSD(    HTRANSD          ),   // DCode transfer type
     .HSIZED(     HSIZED           ),   // DCode transfer size
     .HBURSTD(    HBURSTD          ),   // DCode burst type
     .HPROTD(     HPROTD           ),   // DCode protection control
     .HWDATAD(    HWDATAD          ),   // DCode write data
     .HWRITED(    HWRITED          ),   // DCode write not read
     .EXREQD(     EXREQD           ),   // DCode exclusive request

     // Code side inputs
     .HRDATAC(    hrdatac          ),   // Code bus read data
     .HREADYC(    hreadyc          ),   // Code bus transfer completed
     .HRESPC(     hrespc           ),   // Code bus response status
     .EXRESPC(    exrespc          ),   // Code bus exclusive response

     // CPU side outputs
     .HRDATAI(    HRDATAI          ),   // ICode read data
     .HREADYI(    HREADYI          ),   // ICode transfer completed
     .HRESPI(     HRESPI           ),   // ICode response status
     .HRDATAD(    HRDATAD          ),   // DCode read data
     .HREADYD(    HREADYD          ),   // DCode transfer completed
     .HRESPD(     HRESPD           ),   // DCode response status
     .EXRESPD(    EXRESPD          ),   // DCode exclusive response

     // Code side outputs
     .HADDRC(     haddrc           ),   // Code bus address
     .HWDATAC(    hwdatac          ),   // Code bus write data
     .HTRANSC(    htransc          ),   // Code bus transfer type
     .HWRITEC(    hwritec          ),   // Code bus write not read
     .HSIZEC(     hsizec           ),   // Code bus transfer size
     .HBURSTC(    hburstc          ),   // Code bus burst type
     .HPROTC(     hprotc           ),   // Code bus protection control
     .EXREQC(     exreqc           )    // Code bus exclusive request
  );


  // ------------------------------------------------------------
  // AHB Bus Matrix instance
  // ------------------------------------------------------------
  p_beid_interconnect_f0_ahb_mtx u_p_beid_interconnect_f0_ahb_mtx (
     // Common AHB signals
     .HCLK(                 MTXHCLK                  ),      // AHB system clock
     .HRESETn(              MTXHRESETn               ),      // AHB system reset

     // System address remapping control
     .REMAP(                MTXREMAP                 ),

     // Input port SI0 (inputs from master 0)
     .HSELINITCM3DI(        1'b1                     ),
     .HADDRINITCM3DI(       haddrc                   ),
     .HTRANSINITCM3DI(      htransc                  ),
     .HWRITEINITCM3DI(      hwritec                  ),
     .HSIZEINITCM3DI(       hsizec                   ),
     .HBURSTINITCM3DI(      hburstc                  ),
     .HPROTINITCM3DI(       hprotc                   ),
     .HMASTERINITCM3DI(     {2'b00,HMASTERD}         ),
     .HWDATAINITCM3DI(      hwdatac                  ),
     .HMASTLOCKINITCM3DI(   1'b0                     ),
     .HREADYINITCM3DI(       hreadyc                 ),
     .HAUSERINITCM3DI(      {HAUSERINITCM3DI,memattrc,exreqc} ),
     .HWUSERINITCM3DI(      {HWUSERINITCM3DI}        ),

     // Input port SI0 (outputs to master 0)
     .HRDATAINITCM3DI(      hrdatac                  ),
     .HREADYOUTINITCM3DI(   hreadyc                  ),
     .HRESPINITCM3DI(       hrespc                   ),
     .HRUSERINITCM3DI(      {HRUSERINITCM3DI,exrespc}),

     // Input port SI1 (inputs from master 1)
     .HSELINITCM3S(         1'b1                     ),
     .HADDRINITCM3S(        HADDRS                   ),
     .HTRANSINITCM3S(       HTRANSS                  ),
     .HWRITEINITCM3S(       HWRITES                  ),
     .HSIZEINITCM3S(        HSIZES                   ),
     .HBURSTINITCM3S(       HBURSTS                  ),
     .HPROTINITCM3S(        HPROTS                   ),
     .HMASTERINITCM3S(      {2'b00,HMASTERS}         ),
     .HWDATAINITCM3S(       HWDATAS                  ),
     .HMASTLOCKINITCM3S(    HMASTLOCKS               ),
     .HREADYINITCM3S(       hreadyoutinitcm3s        ),
     .HAUSERINITCM3S(       {HAUSERINITCM3S,MEMATTRS,EXREQS}),
     .HWUSERINITCM3S(       HWUSERINITCM3S           ),

     // Input port SI1 (outputs to master 1)
     .HRDATAINITCM3S(       HRDATAS                  ),
     .HREADYOUTINITCM3S(    hreadyoutinitcm3s        ),
     .HRESPINITCM3S(        HRESPS                   ),
     .HRUSERINITCM3S(       {HRUSERINITCM3S,EXRESPS} ),

     // Input port SI2 (inputs from master 2)
     .HSELINITEXP0(         INITEXP0HSEL             ),
     .HADDRINITEXP0(        INITEXP0HADDR            ),
     .HTRANSINITEXP0(       INITEXP0HTRANS           ),
     .HWRITEINITEXP0(       INITEXP0HWRITE           ),
     .HSIZEINITEXP0(        INITEXP0HSIZE            ),
     .HBURSTINITEXP0(       INITEXP0HBURST           ),
     .HPROTINITEXP0(        INITEXP0HPROT            ),
     .HMASTERINITEXP0(      INITEXP0HMASTER          ),
     .HWDATAINITEXP0(       INITEXP0HWDATA           ),
     .HMASTLOCKINITEXP0(    INITEXP0HMASTLOCK        ),
     .HREADYINITEXP0(       hreadyoutinitexp0        ),
     .HAUSERINITEXP0(       {INITEXP0HAUSER,INITEXP0MEMATTR,INITEXP0EXREQ} ),
     .HWUSERINITEXP0(       INITEXP0HWUSER           ),

     // Input port SI2 (outputs to master 2)
     .HRDATAINITEXP0(       INITEXP0HRDATA           ),
     .HREADYOUTINITEXP0(    hreadyoutinitexp0        ),
     .HRESPINITEXP0(        i_initexp0hresp          ),
     .HRUSERINITEXP0(       {INITEXP0HRUSER,INITEXP0EXRESP} ),

     // Input port SI3 (inputs from master 3)
     .HSELINITEXP1(         INITEXP1HSEL             ),
     .HADDRINITEXP1(        INITEXP1HADDR            ),
     .HTRANSINITEXP1(       INITEXP1HTRANS           ),
     .HWRITEINITEXP1(       INITEXP1HWRITE           ),
     .HSIZEINITEXP1(        INITEXP1HSIZE            ),
     .HBURSTINITEXP1(       INITEXP1HBURST           ),
     .HPROTINITEXP1(        INITEXP1HPROT            ),
     .HMASTERINITEXP1(      INITEXP1HMASTER          ),
     .HWDATAINITEXP1(       INITEXP1HWDATA           ),
     .HMASTLOCKINITEXP1(    INITEXP1HMASTLOCK        ),
     .HREADYINITEXP1(       hreadyoutinitexp1        ),
     .HAUSERINITEXP1(       {INITEXP1HAUSER,INITEXP1MEMATTR,INITEXP1EXREQ} ),
     .HWUSERINITEXP1(       INITEXP1HWUSER           ),

     // Input port SI3 (outputs to master 3)
     .HRDATAINITEXP1(       INITEXP1HRDATA           ),
     .HREADYOUTINITEXP1(    hreadyoutinitexp1        ),
     .HRESPINITEXP1(        i_initexp1hresp          ),
     .HRUSERINITEXP1(       {INITEXP1HRUSER,INITEXP1EXRESP} ),

     // Output port MI0 (outputs to slave 0)
     .HSELTARGFLASH0(       TARGFLASH0HSEL             ),
     .HADDRTARGFLASH0(      TARGFLASH0HADDR            ),
     .HTRANSTARGFLASH0(     TARGFLASH0HTRANS           ),
     .HWRITETARGFLASH0(     TARGFLASH0HWRITE           ),
     .HSIZETARGFLASH0(      TARGFLASH0HSIZE            ),
     .HBURSTTARGFLASH0(     TARGFLASH0HBURST           ),
     .HPROTTARGFLASH0(      TARGFLASH0HPROT            ),
     .HMASTERTARGFLASH0(    TARGFLASH0HMASTER          ),
     .HWDATATARGFLASH0(     TARGFLASH0HWDATA           ),
     .HMASTLOCKTARGFLASH0(  TARGFLASH0HMASTLOCK        ),
     .HREADYMUXTARGFLASH0(  TARGFLASH0HREADYMUX        ),
     .HAUSERTARGFLASH0(     {TARGFLASH0HAUSER,TARGFLASH0MEMATTR,TARGFLASH0EXREQ} ),
     .HWUSERTARGFLASH0(     TARGFLASH0HWUSER           ),

     // Output port MI0 (inputs from slave 0)
     .HRDATATARGFLASH0(     TARGFLASH0HRDATA           ),
     .HREADYOUTTARGFLASH0(  TARGFLASH0HREADYOUT        ),
     .HRESPTARGFLASH0(      i_targflash0hresp          ),
     .HRUSERTARGFLASH0(     {TARGFLASH0HRUSER,TARGFLASH0EXRESP} ),

     // Output port MI1 (outputs to slave 1)
     .HSELTARGSRAM0(        TARGSRAM0HSEL             ),
     .HADDRTARGSRAM0(       TARGSRAM0HADDR            ),
     .HTRANSTARGSRAM0(      TARGSRAM0HTRANS           ),
     .HWRITETARGSRAM0(      TARGSRAM0HWRITE           ),
     .HSIZETARGSRAM0(       TARGSRAM0HSIZE            ),
     .HBURSTTARGSRAM0(      TARGSRAM0HBURST           ),
     .HPROTTARGSRAM0(       TARGSRAM0HPROT            ),
     .HMASTERTARGSRAM0(     TARGSRAM0HMASTER          ),
     .HWDATATARGSRAM0(      TARGSRAM0HWDATA           ),
     .HMASTLOCKTARGSRAM0(   TARGSRAM0HMASTLOCK        ),
     .HREADYMUXTARGSRAM0(   TARGSRAM0HREADYMUX        ),
     .HAUSERTARGSRAM0(      {TARGSRAM0HAUSER,TARGSRAM0MEMATTR,TARGSRAM0EXREQ} ),
     .HWUSERTARGSRAM0(      TARGSRAM0HWUSER           ),

     // Output port MI1 (inputs from slave 1)
     .HRDATATARGSRAM0(      TARGSRAM0HRDATA           ),
     .HREADYOUTTARGSRAM0(   TARGSRAM0HREADYOUT        ),
     .HRESPTARGSRAM0(       i_targsram0hresp          ),
     .HRUSERTARGSRAM0(      {TARGSRAM0HRUSER,TARGSRAM0EXRESP} ),

     // Output port MI2 (outputs to slave 2)
     .HSELTARGSRAM1(        TARGSRAM1HSEL             ),
     .HADDRTARGSRAM1(       TARGSRAM1HADDR            ),
     .HTRANSTARGSRAM1(      TARGSRAM1HTRANS           ),
     .HWRITETARGSRAM1(      TARGSRAM1HWRITE           ),
     .HSIZETARGSRAM1(       TARGSRAM1HSIZE            ),
     .HBURSTTARGSRAM1(      TARGSRAM1HBURST           ),
     .HPROTTARGSRAM1(       TARGSRAM1HPROT            ),
     .HMASTERTARGSRAM1(     TARGSRAM1HMASTER          ),
     .HWDATATARGSRAM1(      TARGSRAM1HWDATA           ),
     .HMASTLOCKTARGSRAM1(   TARGSRAM1HMASTLOCK        ),
     .HREADYMUXTARGSRAM1(   TARGSRAM1HREADYMUX        ),
     .HAUSERTARGSRAM1(      {TARGSRAM1HAUSER,TARGSRAM1MEMATTR,TARGSRAM1EXREQ} ),
     .HWUSERTARGSRAM1(      TARGSRAM1HWUSER           ),

     // Output port MI2 (inputs from slave 2)
     .HRDATATARGSRAM1(      TARGSRAM1HRDATA           ),
     .HREADYOUTTARGSRAM1(   TARGSRAM1HREADYOUT        ),
     .HRESPTARGSRAM1(       i_targsram1hresp          ),
     .HRUSERTARGSRAM1(      {TARGSRAM1HRUSER,TARGSRAM1EXRESP} ),

     // Output port MI3 (outputs to slave 3)
     .HSELTARGSRAM2(        TARGSRAM2HSEL             ),
     .HADDRTARGSRAM2(       TARGSRAM2HADDR            ),
     .HTRANSTARGSRAM2(      TARGSRAM2HTRANS           ),
     .HWRITETARGSRAM2(      TARGSRAM2HWRITE           ),
     .HSIZETARGSRAM2(       TARGSRAM2HSIZE            ),
     .HBURSTTARGSRAM2(      TARGSRAM2HBURST           ),
     .HPROTTARGSRAM2(       TARGSRAM2HPROT            ),
     .HMASTERTARGSRAM2(     TARGSRAM2HMASTER          ),
     .HWDATATARGSRAM2(      TARGSRAM2HWDATA           ),
     .HMASTLOCKTARGSRAM2(   TARGSRAM2HMASTLOCK        ),
     .HREADYMUXTARGSRAM2(   TARGSRAM2HREADYMUX        ),
     .HAUSERTARGSRAM2(      {TARGSRAM2HAUSER,TARGSRAM2MEMATTR,TARGSRAM2EXREQ} ),
     .HWUSERTARGSRAM2(      TARGSRAM2HWUSER           ),

     // Output port MI3 (inputs from slave 3)
     .HRDATATARGSRAM2(      TARGSRAM2HRDATA           ),
     .HREADYOUTTARGSRAM2(   TARGSRAM2HREADYOUT        ),
     .HRESPTARGSRAM2(       i_targsram2hresp          ),
     .HRUSERTARGSRAM2(      {TARGSRAM2HRUSER,TARGSRAM2EXRESP} ),

     // Output port MI4 (outputs to slave 4)
     .HSELTARGSRAM3(        TARGSRAM3HSEL             ),
     .HADDRTARGSRAM3(       TARGSRAM3HADDR            ),
     .HTRANSTARGSRAM3(      TARGSRAM3HTRANS           ),
     .HWRITETARGSRAM3(      TARGSRAM3HWRITE           ),
     .HSIZETARGSRAM3(       TARGSRAM3HSIZE            ),
     .HBURSTTARGSRAM3(      TARGSRAM3HBURST           ),
     .HPROTTARGSRAM3(       TARGSRAM3HPROT            ),
     .HMASTERTARGSRAM3(     TARGSRAM3HMASTER          ),
     .HWDATATARGSRAM3(      TARGSRAM3HWDATA           ),
     .HMASTLOCKTARGSRAM3(   TARGSRAM3HMASTLOCK        ),
     .HREADYMUXTARGSRAM3(   TARGSRAM3HREADYMUX        ),
     .HAUSERTARGSRAM3(      {TARGSRAM3HAUSER,TARGSRAM3MEMATTR,TARGSRAM3EXREQ} ),
     .HWUSERTARGSRAM3(      TARGSRAM3HWUSER           ),

     // Output port MI4 (inputs from slave 4)
     .HRDATATARGSRAM3(      TARGSRAM3HRDATA           ),
     .HREADYOUTTARGSRAM3(   TARGSRAM3HREADYOUT        ),
     .HRESPTARGSRAM3(       i_targsram3hresp          ),
     .HRUSERTARGSRAM3(      {TARGSRAM3HRUSER,TARGSRAM3EXRESP} ),

     // Output port MI5 (outputs to slave 5)
     .HSELTARGAPB0(         targapb0hsel             ),
     .HADDRTARGAPB0(        targapb0haddr            ),
     .HTRANSTARGAPB0(       targapb0htrans           ),
     .HWRITETARGAPB0(       targapb0hwrite           ),
     .HSIZETARGAPB0(        targapb0hsize            ),
     .HBURSTTARGAPB0(       /*Not used by AHB2APB*/  ),
     .HPROTTARGAPB0(        targapb0hprot            ),
     .HMASTERTARGAPB0(      /*Not used by AHB2APB*/  ),
     .HWDATATARGAPB0(       targapb0hwdata           ),
     .HMASTLOCKTARGAPB0(    /*Not used by AHB2APB*/  ),
     .HREADYMUXTARGAPB0(    targapb0hreadymux        ),
     .HAUSERTARGAPB0(       /*Not used by AHB2APB*/  ),
     .HWUSERTARGAPB0(       /*Not used by AHB2APB*/  ),

     // Output port MI5 (inputs from slave 5)
     .HRDATATARGAPB0(       targapb0hrdata           ),
     .HREADYOUTTARGAPB0(    targapb0hreadyout        ),
     .HRESPTARGAPB0(        i_targapb0hresp          ),
     .HRUSERTARGAPB0(       4'b0000                  ), // LSB bit corresponds to EXRESP,which shall be set to 1'b0,
                                                        // meaning that exresp is returned but it is SW
                                                        // responsibility to guarantee exclusivity no HW exclusive
                                                        // Monitor present

     // Output port MI6 (outputs to slave 6)
     .HSELTARGEXP0(         TARGEXP0HSEL             ),
     .HADDRTARGEXP0(        TARGEXP0HADDR            ),
     .HTRANSTARGEXP0(       TARGEXP0HTRANS           ),
     .HWRITETARGEXP0(       TARGEXP0HWRITE           ),
     .HSIZETARGEXP0(        TARGEXP0HSIZE            ),
     .HBURSTTARGEXP0(       TARGEXP0HBURST           ),
     .HPROTTARGEXP0(        TARGEXP0HPROT            ),
     .HMASTERTARGEXP0(      TARGEXP0HMASTER          ),
     .HWDATATARGEXP0(       TARGEXP0HWDATA           ),
     .HMASTLOCKTARGEXP0(    TARGEXP0HMASTLOCK        ),
     .HREADYMUXTARGEXP0(    TARGEXP0HREADYMUX        ),
     .HAUSERTARGEXP0(       {TARGEXP0HAUSER,TARGEXP0MEMATTR,TARGEXP0EXREQ} ),
     .HWUSERTARGEXP0(       TARGEXP0HWUSER           ),

     // Output port MI6 (inputs from slave 6)
     .HRDATATARGEXP0(       TARGEXP0HRDATA           ),
     .HREADYOUTTARGEXP0(    TARGEXP0HREADYOUT        ),
     .HRESPTARGEXP0(        i_targexp0hresp          ),
     .HRUSERTARGEXP0(       {TARGEXP0HRUSER,TARGEXP0EXRESP} ),

     // Output port MI7 (outputs to slave 7)
     .HSELTARGEXP1(         TARGEXP1HSEL             ),
     .HADDRTARGEXP1(        TARGEXP1HADDR            ),
     .HTRANSTARGEXP1(       TARGEXP1HTRANS           ),
     .HWRITETARGEXP1(       TARGEXP1HWRITE           ),
     .HSIZETARGEXP1(        TARGEXP1HSIZE            ),
     .HBURSTTARGEXP1(       TARGEXP1HBURST           ),
     .HPROTTARGEXP1(        TARGEXP1HPROT            ),
     .HMASTERTARGEXP1(      TARGEXP1HMASTER          ),
     .HWDATATARGEXP1(       TARGEXP1HWDATA           ),
     .HMASTLOCKTARGEXP1(    TARGEXP1HMASTLOCK        ),
     .HREADYMUXTARGEXP1(    TARGEXP1HREADYMUX        ),
     .HAUSERTARGEXP1(       {TARGEXP1HAUSER,TARGEXP1MEMATTR,TARGEXP1EXREQ} ),
     .HWUSERTARGEXP1(       TARGEXP1HWUSER           ),

     // Output port MI7 (inputs from slave 7)
     .HRDATATARGEXP1(       TARGEXP1HRDATA           ),
     .HREADYOUTTARGEXP1(    TARGEXP1HREADYOUT        ),
     .HRESPTARGEXP1(        i_targexp1hresp          ),
     .HRUSERTARGEXP1(       {TARGEXP1HRUSER,TARGEXP1EXRESP} ),

     // Scan test dummy signals; not connected until scan insertion
     .SCANENABLE(           SCANENABLE               ),   // Scan Test Mode Enable
     .SCANINHCLK(           SCANINHCLK               ),   // Scan Chain Input

     // Scan test dummy signals; not connected until scan insertion
     .SCANOUTHCLK(          SCANOUTHCLK              )    // Scan Chain Output

     );

  // ------------------------------------------------------------
  // AHB to APB bridge
  // ------------------------------------------------------------
  p_beid_interconnect_f0_ahb_to_apb #(16,1,1)
  u_p_beid_interconnect_f0_ahb_to_apb (
     .HCLK(       AHB2APBHCLK       ),
     .HRESETn(    MTXHRESETn        ),
     .PCLKEN(     1'b1              ),

     .HSEL(       targapb0hsel      ),
     .HADDR(      targapb0haddr[15:0]),
     .HTRANS(     targapb0htrans    ),
     .HSIZE(      targapb0hsize     ),
     .HPROT(      targapb0hprot     ),
     .HWRITE(     targapb0hwrite    ),
     .HREADY(     targapb0hreadymux ),
     .HWDATA(     targapb0hwdata    ),

     .HREADYOUT(  targapb0hreadyout ),
     .HRDATA(     targapb0hrdata    ),
     .HRESP(      targapb0hresp     ),

     .PADDR(      ahb2apb_paddr     ),
     .PENABLE(    ahb2apb_penable   ),
     .PWRITE(     ahb2apb_pwrite    ),
     .PSTRB(      ahb2apb_pstrb     ),
     .PPROT(      ahb2apb_pprot     ),
     .PWDATA(     ahb2apb_pwdata    ),
     .PSEL(       ahb2apb_psel      ),

     .APBACTIVE(  APBQACTIVE        ),

     .PRDATA(     ahb2apb_prdata    ),
     .PREADY(     ahb2apb_pready    ),
     .PSLVERR(    ahb2apb_pslverr   )
  );

  // ------------------------------------------------------------
  // APB Multiplexer
  // ------------------------------------------------------------
  p_beid_interconnect_f0_apb_slave_mux #(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
  u_p_beid_interconnect_f0_apb_slave_mux (
     .DECODE4BIT( ahb2apb_paddr[15:12] ),
     .PSEL(       ahb2apb_psel         ),

     .PSEL0(      APBTARGEXP0PSEL      ),
     .PREADY0(    APBTARGEXP0PREADY    ),
     .PRDATA0(    APBTARGEXP0PRDATA    ),
     .PSLVERR0(   APBTARGEXP0PSLVERR   ),

     .PSEL1(      APBTARGEXP1PSEL      ),
     .PREADY1(    APBTARGEXP1PREADY    ),
     .PRDATA1(    APBTARGEXP1PRDATA    ),
     .PSLVERR1(   APBTARGEXP1PSLVERR   ),

     .PSEL2(      APBTARGEXP2PSEL      ),
     .PREADY2(    APBTARGEXP2PREADY    ),
     .PRDATA2(    APBTARGEXP2PRDATA    ),
     .PSLVERR2(   APBTARGEXP2PSLVERR   ),

     .PSEL3(      APBTARGEXP3PSEL      ),
     .PREADY3(    APBTARGEXP3PREADY    ),
     .PRDATA3(    APBTARGEXP3PRDATA    ),
     .PSLVERR3(   APBTARGEXP3PSLVERR   ),

     .PSEL4(      APBTARGEXP4PSEL      ),
     .PREADY4(    APBTARGEXP4PREADY    ),
     .PRDATA4(    APBTARGEXP4PRDATA    ),
     .PSLVERR4(   APBTARGEXP4PSLVERR   ),

     .PSEL5(      APBTARGEXP5PSEL      ),
     .PREADY5(    APBTARGEXP5PREADY    ),
     .PRDATA5(    APBTARGEXP5PRDATA    ),
     .PSLVERR5(   APBTARGEXP5PSLVERR   ),

     .PSEL6(      APBTARGEXP6PSEL      ),
     .PREADY6(    APBTARGEXP6PREADY    ),
     .PRDATA6(    APBTARGEXP6PRDATA    ),
     .PSLVERR6(   APBTARGEXP6PSLVERR   ),

     .PSEL7(      APBTARGEXP7PSEL      ),
     .PREADY7(    APBTARGEXP7PREADY    ),
     .PRDATA7(    APBTARGEXP7PRDATA    ),
     .PSLVERR7(   APBTARGEXP7PSLVERR   ),

     .PSEL8(      APBTARGEXP8PSEL      ),
     .PREADY8(    APBTARGEXP8PREADY    ),
     .PRDATA8(    APBTARGEXP8PRDATA    ),
     .PSLVERR8(   APBTARGEXP8PSLVERR   ),

     .PSEL9(      APBTARGEXP9PSEL      ),
     .PREADY9(    APBTARGEXP9PREADY    ),
     .PRDATA9(    APBTARGEXP9PRDATA    ),
     .PSLVERR9(   APBTARGEXP9PSLVERR   ),

     .PSEL10(     APBTARGEXP10PSEL      ),
     .PREADY10(   APBTARGEXP10PREADY    ),
     .PRDATA10(   APBTARGEXP10PRDATA    ),
     .PSLVERR10(  APBTARGEXP10PSLVERR   ),

     .PSEL11(     APBTARGEXP11PSEL      ),
     .PREADY11(   APBTARGEXP11PREADY    ),
     .PRDATA11(   APBTARGEXP11PRDATA    ),
     .PSLVERR11(  APBTARGEXP11PSLVERR   ),

     .PSEL12(     APBTARGEXP12PSEL      ),
     .PREADY12(   APBTARGEXP12PREADY    ),
     .PRDATA12(   APBTARGEXP12PRDATA    ),
     .PSLVERR12(  APBTARGEXP12PSLVERR   ),

     .PSEL13(     APBTARGEXP13PSEL      ),
     .PREADY13(   APBTARGEXP13PREADY    ),
     .PRDATA13(   APBTARGEXP13PRDATA    ),
     .PSLVERR13(  APBTARGEXP13PSLVERR   ),

     .PSEL14(     APBTARGEXP14PSEL      ),
     .PREADY14(   APBTARGEXP14PREADY    ),
     .PRDATA14(   APBTARGEXP14PRDATA    ),
     .PSLVERR14(  APBTARGEXP14PSLVERR   ),

     .PSEL15(     APBTARGEXP15PSEL      ),
     .PREADY15(   APBTARGEXP15PREADY    ),
     .PRDATA15(   APBTARGEXP15PRDATA    ),
     .PSLVERR15(  APBTARGEXP15PSLVERR   ),

     .PREADY(     ahb2apb_pready        ),
     .PRDATA(     ahb2apb_prdata        ),
     .PSLVERR(    ahb2apb_pslverr       )
  );

endmodule
