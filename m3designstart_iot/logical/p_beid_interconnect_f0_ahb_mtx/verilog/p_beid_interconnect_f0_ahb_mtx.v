//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//        (C) COPYRIGHT 2001-2015 ARM Limited or its affiliates.
//            ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
//      SVN Information
//
//      Checked In          : 2012-10-15 18:01:36 +0100 (Mon, 15 Oct 2012)
//
//      Revision            : 225465
//
//      Release Information : CM3DesignStart-r0p0-02rel0
//
//-----------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
//  Abstract            : BusMatrix is the top-level which connects together
//                        the required Input Stages, MatrixDecodes, Output
//                        Stages and Output Arbitration blocks.
//
//                        Supports the following configured options:
//
//                         - Architecture type 'ahb2',
//                         - 4 slave ports (connecting to masters),
//                         - 8 master ports (connecting to slaves),
//                         - Routing address width of 32 bits,
//                         - Routing data width of 32 bits,
//                         - xUSER signal width of 4 bits,
//                         - Arbiter type 'round',
//                         - Connectivity mapping:
//                             INITCM3DI -> TARGFLASH0, TARGEXP1,
//                             INITCM3S -> TARGSRAM0, TARGSRAM1, TARGSRAM2, TARGSRAM3, TARGAPB0, TARGEXP0, TARGEXP1,
//                             INITEXP0 -> TARGFLASH0, TARGSRAM0, TARGSRAM1, TARGSRAM2, TARGSRAM3, TARGAPB0, TARGEXP0, TARGEXP1,
//                             INITEXP1 -> TARGFLASH0, TARGSRAM0, TARGSRAM1, TARGSRAM2, TARGSRAM3, TARGAPB0, TARGEXP0, TARGEXP1,
//                         - Connectivity type 'sparse'.
//
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module p_beid_interconnect_f0_ahb_mtx (

    // Common AHB signals
    HCLK,
    HRESETn,

    // System address remapping control
    REMAP,

    // Input port SI0 (inputs from master 0)
    HSELINITCM3DI,
    HADDRINITCM3DI,
    HTRANSINITCM3DI,
    HWRITEINITCM3DI,
    HSIZEINITCM3DI,
    HBURSTINITCM3DI,
    HPROTINITCM3DI,
    HMASTERINITCM3DI,
    HWDATAINITCM3DI,
    HMASTLOCKINITCM3DI,
    HREADYINITCM3DI,
    HAUSERINITCM3DI,
    HWUSERINITCM3DI,

    // Input port SI1 (inputs from master 1)
    HSELINITCM3S,
    HADDRINITCM3S,
    HTRANSINITCM3S,
    HWRITEINITCM3S,
    HSIZEINITCM3S,
    HBURSTINITCM3S,
    HPROTINITCM3S,
    HMASTERINITCM3S,
    HWDATAINITCM3S,
    HMASTLOCKINITCM3S,
    HREADYINITCM3S,
    HAUSERINITCM3S,
    HWUSERINITCM3S,

    // Input port SI2 (inputs from master 2)
    HSELINITEXP0,
    HADDRINITEXP0,
    HTRANSINITEXP0,
    HWRITEINITEXP0,
    HSIZEINITEXP0,
    HBURSTINITEXP0,
    HPROTINITEXP0,
    HMASTERINITEXP0,
    HWDATAINITEXP0,
    HMASTLOCKINITEXP0,
    HREADYINITEXP0,
    HAUSERINITEXP0,
    HWUSERINITEXP0,

    // Input port SI3 (inputs from master 3)
    HSELINITEXP1,
    HADDRINITEXP1,
    HTRANSINITEXP1,
    HWRITEINITEXP1,
    HSIZEINITEXP1,
    HBURSTINITEXP1,
    HPROTINITEXP1,
    HMASTERINITEXP1,
    HWDATAINITEXP1,
    HMASTLOCKINITEXP1,
    HREADYINITEXP1,
    HAUSERINITEXP1,
    HWUSERINITEXP1,

    // Output port MI0 (inputs from slave 0)
    HRDATATARGFLASH0,
    HREADYOUTTARGFLASH0,
    HRESPTARGFLASH0,
    HRUSERTARGFLASH0,

    // Output port MI1 (inputs from slave 1)
    HRDATATARGSRAM0,
    HREADYOUTTARGSRAM0,
    HRESPTARGSRAM0,
    HRUSERTARGSRAM0,

    // Output port MI2 (inputs from slave 2)
    HRDATATARGSRAM1,
    HREADYOUTTARGSRAM1,
    HRESPTARGSRAM1,
    HRUSERTARGSRAM1,

    // Output port MI3 (inputs from slave 3)
    HRDATATARGSRAM2,
    HREADYOUTTARGSRAM2,
    HRESPTARGSRAM2,
    HRUSERTARGSRAM2,

    // Output port MI4 (inputs from slave 4)
    HRDATATARGSRAM3,
    HREADYOUTTARGSRAM3,
    HRESPTARGSRAM3,
    HRUSERTARGSRAM3,

    // Output port MI5 (inputs from slave 5)
    HRDATATARGAPB0,
    HREADYOUTTARGAPB0,
    HRESPTARGAPB0,
    HRUSERTARGAPB0,

    // Output port MI6 (inputs from slave 6)
    HRDATATARGEXP0,
    HREADYOUTTARGEXP0,
    HRESPTARGEXP0,
    HRUSERTARGEXP0,

    // Output port MI7 (inputs from slave 7)
    HRDATATARGEXP1,
    HREADYOUTTARGEXP1,
    HRESPTARGEXP1,
    HRUSERTARGEXP1,

    // Scan test dummy signals; not connected until scan insertion
    SCANENABLE,   // Scan Test Mode Enable
    SCANINHCLK,   // Scan Chain Input


    // Output port MI0 (outputs to slave 0)
    HSELTARGFLASH0,
    HADDRTARGFLASH0,
    HTRANSTARGFLASH0,
    HWRITETARGFLASH0,
    HSIZETARGFLASH0,
    HBURSTTARGFLASH0,
    HPROTTARGFLASH0,
    HMASTERTARGFLASH0,
    HWDATATARGFLASH0,
    HMASTLOCKTARGFLASH0,
    HREADYMUXTARGFLASH0,
    HAUSERTARGFLASH0,
    HWUSERTARGFLASH0,

    // Output port MI1 (outputs to slave 1)
    HSELTARGSRAM0,
    HADDRTARGSRAM0,
    HTRANSTARGSRAM0,
    HWRITETARGSRAM0,
    HSIZETARGSRAM0,
    HBURSTTARGSRAM0,
    HPROTTARGSRAM0,
    HMASTERTARGSRAM0,
    HWDATATARGSRAM0,
    HMASTLOCKTARGSRAM0,
    HREADYMUXTARGSRAM0,
    HAUSERTARGSRAM0,
    HWUSERTARGSRAM0,

    // Output port MI2 (outputs to slave 2)
    HSELTARGSRAM1,
    HADDRTARGSRAM1,
    HTRANSTARGSRAM1,
    HWRITETARGSRAM1,
    HSIZETARGSRAM1,
    HBURSTTARGSRAM1,
    HPROTTARGSRAM1,
    HMASTERTARGSRAM1,
    HWDATATARGSRAM1,
    HMASTLOCKTARGSRAM1,
    HREADYMUXTARGSRAM1,
    HAUSERTARGSRAM1,
    HWUSERTARGSRAM1,

    // Output port MI3 (outputs to slave 3)
    HSELTARGSRAM2,
    HADDRTARGSRAM2,
    HTRANSTARGSRAM2,
    HWRITETARGSRAM2,
    HSIZETARGSRAM2,
    HBURSTTARGSRAM2,
    HPROTTARGSRAM2,
    HMASTERTARGSRAM2,
    HWDATATARGSRAM2,
    HMASTLOCKTARGSRAM2,
    HREADYMUXTARGSRAM2,
    HAUSERTARGSRAM2,
    HWUSERTARGSRAM2,

    // Output port MI4 (outputs to slave 4)
    HSELTARGSRAM3,
    HADDRTARGSRAM3,
    HTRANSTARGSRAM3,
    HWRITETARGSRAM3,
    HSIZETARGSRAM3,
    HBURSTTARGSRAM3,
    HPROTTARGSRAM3,
    HMASTERTARGSRAM3,
    HWDATATARGSRAM3,
    HMASTLOCKTARGSRAM3,
    HREADYMUXTARGSRAM3,
    HAUSERTARGSRAM3,
    HWUSERTARGSRAM3,

    // Output port MI5 (outputs to slave 5)
    HSELTARGAPB0,
    HADDRTARGAPB0,
    HTRANSTARGAPB0,
    HWRITETARGAPB0,
    HSIZETARGAPB0,
    HBURSTTARGAPB0,
    HPROTTARGAPB0,
    HMASTERTARGAPB0,
    HWDATATARGAPB0,
    HMASTLOCKTARGAPB0,
    HREADYMUXTARGAPB0,
    HAUSERTARGAPB0,
    HWUSERTARGAPB0,

    // Output port MI6 (outputs to slave 6)
    HSELTARGEXP0,
    HADDRTARGEXP0,
    HTRANSTARGEXP0,
    HWRITETARGEXP0,
    HSIZETARGEXP0,
    HBURSTTARGEXP0,
    HPROTTARGEXP0,
    HMASTERTARGEXP0,
    HWDATATARGEXP0,
    HMASTLOCKTARGEXP0,
    HREADYMUXTARGEXP0,
    HAUSERTARGEXP0,
    HWUSERTARGEXP0,

    // Output port MI7 (outputs to slave 7)
    HSELTARGEXP1,
    HADDRTARGEXP1,
    HTRANSTARGEXP1,
    HWRITETARGEXP1,
    HSIZETARGEXP1,
    HBURSTTARGEXP1,
    HPROTTARGEXP1,
    HMASTERTARGEXP1,
    HWDATATARGEXP1,
    HMASTLOCKTARGEXP1,
    HREADYMUXTARGEXP1,
    HAUSERTARGEXP1,
    HWUSERTARGEXP1,

    // Input port SI0 (outputs to master 0)
    HRDATAINITCM3DI,
    HREADYOUTINITCM3DI,
    HRESPINITCM3DI,
    HRUSERINITCM3DI,

    // Input port SI1 (outputs to master 1)
    HRDATAINITCM3S,
    HREADYOUTINITCM3S,
    HRESPINITCM3S,
    HRUSERINITCM3S,

    // Input port SI2 (outputs to master 2)
    HRDATAINITEXP0,
    HREADYOUTINITEXP0,
    HRESPINITEXP0,
    HRUSERINITEXP0,

    // Input port SI3 (outputs to master 3)
    HRDATAINITEXP1,
    HREADYOUTINITEXP1,
    HRESPINITEXP1,
    HRUSERINITEXP1,

    // Scan test dummy signals; not connected until scan insertion
    SCANOUTHCLK   // Scan Chain Output

    );


// -----------------------------------------------------------------------------
// Input and Output declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    input         HCLK;            // AHB System Clock
    input         HRESETn;         // AHB System Reset

    // System address remapping control
    input   [3:0] REMAP;           // REMAP input

    // Input port SI0 (inputs from master 0)
    input         HSELINITCM3DI;          // Slave Select
    input  [31:0] HADDRINITCM3DI;         // Address bus
    input   [1:0] HTRANSINITCM3DI;        // Transfer type
    input         HWRITEINITCM3DI;        // Transfer direction
    input   [2:0] HSIZEINITCM3DI;         // Transfer size
    input   [2:0] HBURSTINITCM3DI;        // Burst type
    input   [3:0] HPROTINITCM3DI;         // Protection control
    input   [3:0] HMASTERINITCM3DI;       // Master select
    input  [31:0] HWDATAINITCM3DI;        // Write data
    input         HMASTLOCKINITCM3DI;     // Locked Sequence
    input         HREADYINITCM3DI;        // Transfer done
    input  [3:0] HAUSERINITCM3DI;        // Address USER signals
    input  [3:0] HWUSERINITCM3DI;        // Write-data USER signals

    // Input port SI1 (inputs from master 1)
    input         HSELINITCM3S;          // Slave Select
    input  [31:0] HADDRINITCM3S;         // Address bus
    input   [1:0] HTRANSINITCM3S;        // Transfer type
    input         HWRITEINITCM3S;        // Transfer direction
    input   [2:0] HSIZEINITCM3S;         // Transfer size
    input   [2:0] HBURSTINITCM3S;        // Burst type
    input   [3:0] HPROTINITCM3S;         // Protection control
    input   [3:0] HMASTERINITCM3S;       // Master select
    input  [31:0] HWDATAINITCM3S;        // Write data
    input         HMASTLOCKINITCM3S;     // Locked Sequence
    input         HREADYINITCM3S;        // Transfer done
    input  [3:0] HAUSERINITCM3S;        // Address USER signals
    input  [3:0] HWUSERINITCM3S;        // Write-data USER signals

    // Input port SI2 (inputs from master 2)
    input         HSELINITEXP0;          // Slave Select
    input  [31:0] HADDRINITEXP0;         // Address bus
    input   [1:0] HTRANSINITEXP0;        // Transfer type
    input         HWRITEINITEXP0;        // Transfer direction
    input   [2:0] HSIZEINITEXP0;         // Transfer size
    input   [2:0] HBURSTINITEXP0;        // Burst type
    input   [3:0] HPROTINITEXP0;         // Protection control
    input   [3:0] HMASTERINITEXP0;       // Master select
    input  [31:0] HWDATAINITEXP0;        // Write data
    input         HMASTLOCKINITEXP0;     // Locked Sequence
    input         HREADYINITEXP0;        // Transfer done
    input  [3:0] HAUSERINITEXP0;        // Address USER signals
    input  [3:0] HWUSERINITEXP0;        // Write-data USER signals

    // Input port SI3 (inputs from master 3)
    input         HSELINITEXP1;          // Slave Select
    input  [31:0] HADDRINITEXP1;         // Address bus
    input   [1:0] HTRANSINITEXP1;        // Transfer type
    input         HWRITEINITEXP1;        // Transfer direction
    input   [2:0] HSIZEINITEXP1;         // Transfer size
    input   [2:0] HBURSTINITEXP1;        // Burst type
    input   [3:0] HPROTINITEXP1;         // Protection control
    input   [3:0] HMASTERINITEXP1;       // Master select
    input  [31:0] HWDATAINITEXP1;        // Write data
    input         HMASTLOCKINITEXP1;     // Locked Sequence
    input         HREADYINITEXP1;        // Transfer done
    input  [3:0] HAUSERINITEXP1;        // Address USER signals
    input  [3:0] HWUSERINITEXP1;        // Write-data USER signals

    // Output port MI0 (inputs from slave 0)
    input  [31:0] HRDATATARGFLASH0;        // Read data bus
    input         HREADYOUTTARGFLASH0;     // HREADY feedback
    input   [1:0] HRESPTARGFLASH0;         // Transfer response
    input  [3:0] HRUSERTARGFLASH0;        // Read-data USER signals

    // Output port MI1 (inputs from slave 1)
    input  [31:0] HRDATATARGSRAM0;        // Read data bus
    input         HREADYOUTTARGSRAM0;     // HREADY feedback
    input   [1:0] HRESPTARGSRAM0;         // Transfer response
    input  [3:0] HRUSERTARGSRAM0;        // Read-data USER signals

    // Output port MI2 (inputs from slave 2)
    input  [31:0] HRDATATARGSRAM1;        // Read data bus
    input         HREADYOUTTARGSRAM1;     // HREADY feedback
    input   [1:0] HRESPTARGSRAM1;         // Transfer response
    input  [3:0] HRUSERTARGSRAM1;        // Read-data USER signals

    // Output port MI3 (inputs from slave 3)
    input  [31:0] HRDATATARGSRAM2;        // Read data bus
    input         HREADYOUTTARGSRAM2;     // HREADY feedback
    input   [1:0] HRESPTARGSRAM2;         // Transfer response
    input  [3:0] HRUSERTARGSRAM2;        // Read-data USER signals

    // Output port MI4 (inputs from slave 4)
    input  [31:0] HRDATATARGSRAM3;        // Read data bus
    input         HREADYOUTTARGSRAM3;     // HREADY feedback
    input   [1:0] HRESPTARGSRAM3;         // Transfer response
    input  [3:0] HRUSERTARGSRAM3;        // Read-data USER signals

    // Output port MI5 (inputs from slave 5)
    input  [31:0] HRDATATARGAPB0;        // Read data bus
    input         HREADYOUTTARGAPB0;     // HREADY feedback
    input   [1:0] HRESPTARGAPB0;         // Transfer response
    input  [3:0] HRUSERTARGAPB0;        // Read-data USER signals

    // Output port MI6 (inputs from slave 6)
    input  [31:0] HRDATATARGEXP0;        // Read data bus
    input         HREADYOUTTARGEXP0;     // HREADY feedback
    input   [1:0] HRESPTARGEXP0;         // Transfer response
    input  [3:0] HRUSERTARGEXP0;        // Read-data USER signals

    // Output port MI7 (inputs from slave 7)
    input  [31:0] HRDATATARGEXP1;        // Read data bus
    input         HREADYOUTTARGEXP1;     // HREADY feedback
    input   [1:0] HRESPTARGEXP1;         // Transfer response
    input  [3:0] HRUSERTARGEXP1;        // Read-data USER signals

    // Scan test dummy signals; not connected until scan insertion
    input         SCANENABLE;      // Scan enable signal
    input         SCANINHCLK;      // HCLK scan input


    // Output port MI0 (outputs to slave 0)
    output        HSELTARGFLASH0;          // Slave Select
    output [31:0] HADDRTARGFLASH0;         // Address bus
    output  [1:0] HTRANSTARGFLASH0;        // Transfer type
    output        HWRITETARGFLASH0;        // Transfer direction
    output  [2:0] HSIZETARGFLASH0;         // Transfer size
    output  [2:0] HBURSTTARGFLASH0;        // Burst type
    output  [3:0] HPROTTARGFLASH0;         // Protection control
    output  [3:0] HMASTERTARGFLASH0;       // Master select
    output [31:0] HWDATATARGFLASH0;        // Write data
    output        HMASTLOCKTARGFLASH0;     // Locked Sequence
    output        HREADYMUXTARGFLASH0;     // Transfer done
    output [3:0] HAUSERTARGFLASH0;        // Address USER signals
    output [3:0] HWUSERTARGFLASH0;        // Write-data USER signals

    // Output port MI1 (outputs to slave 1)
    output        HSELTARGSRAM0;          // Slave Select
    output [31:0] HADDRTARGSRAM0;         // Address bus
    output  [1:0] HTRANSTARGSRAM0;        // Transfer type
    output        HWRITETARGSRAM0;        // Transfer direction
    output  [2:0] HSIZETARGSRAM0;         // Transfer size
    output  [2:0] HBURSTTARGSRAM0;        // Burst type
    output  [3:0] HPROTTARGSRAM0;         // Protection control
    output  [3:0] HMASTERTARGSRAM0;       // Master select
    output [31:0] HWDATATARGSRAM0;        // Write data
    output        HMASTLOCKTARGSRAM0;     // Locked Sequence
    output        HREADYMUXTARGSRAM0;     // Transfer done
    output [3:0] HAUSERTARGSRAM0;        // Address USER signals
    output [3:0] HWUSERTARGSRAM0;        // Write-data USER signals

    // Output port MI2 (outputs to slave 2)
    output        HSELTARGSRAM1;          // Slave Select
    output [31:0] HADDRTARGSRAM1;         // Address bus
    output  [1:0] HTRANSTARGSRAM1;        // Transfer type
    output        HWRITETARGSRAM1;        // Transfer direction
    output  [2:0] HSIZETARGSRAM1;         // Transfer size
    output  [2:0] HBURSTTARGSRAM1;        // Burst type
    output  [3:0] HPROTTARGSRAM1;         // Protection control
    output  [3:0] HMASTERTARGSRAM1;       // Master select
    output [31:0] HWDATATARGSRAM1;        // Write data
    output        HMASTLOCKTARGSRAM1;     // Locked Sequence
    output        HREADYMUXTARGSRAM1;     // Transfer done
    output [3:0] HAUSERTARGSRAM1;        // Address USER signals
    output [3:0] HWUSERTARGSRAM1;        // Write-data USER signals

    // Output port MI3 (outputs to slave 3)
    output        HSELTARGSRAM2;          // Slave Select
    output [31:0] HADDRTARGSRAM2;         // Address bus
    output  [1:0] HTRANSTARGSRAM2;        // Transfer type
    output        HWRITETARGSRAM2;        // Transfer direction
    output  [2:0] HSIZETARGSRAM2;         // Transfer size
    output  [2:0] HBURSTTARGSRAM2;        // Burst type
    output  [3:0] HPROTTARGSRAM2;         // Protection control
    output  [3:0] HMASTERTARGSRAM2;       // Master select
    output [31:0] HWDATATARGSRAM2;        // Write data
    output        HMASTLOCKTARGSRAM2;     // Locked Sequence
    output        HREADYMUXTARGSRAM2;     // Transfer done
    output [3:0] HAUSERTARGSRAM2;        // Address USER signals
    output [3:0] HWUSERTARGSRAM2;        // Write-data USER signals

    // Output port MI4 (outputs to slave 4)
    output        HSELTARGSRAM3;          // Slave Select
    output [31:0] HADDRTARGSRAM3;         // Address bus
    output  [1:0] HTRANSTARGSRAM3;        // Transfer type
    output        HWRITETARGSRAM3;        // Transfer direction
    output  [2:0] HSIZETARGSRAM3;         // Transfer size
    output  [2:0] HBURSTTARGSRAM3;        // Burst type
    output  [3:0] HPROTTARGSRAM3;         // Protection control
    output  [3:0] HMASTERTARGSRAM3;       // Master select
    output [31:0] HWDATATARGSRAM3;        // Write data
    output        HMASTLOCKTARGSRAM3;     // Locked Sequence
    output        HREADYMUXTARGSRAM3;     // Transfer done
    output [3:0] HAUSERTARGSRAM3;        // Address USER signals
    output [3:0] HWUSERTARGSRAM3;        // Write-data USER signals

    // Output port MI5 (outputs to slave 5)
    output        HSELTARGAPB0;          // Slave Select
    output [31:0] HADDRTARGAPB0;         // Address bus
    output  [1:0] HTRANSTARGAPB0;        // Transfer type
    output        HWRITETARGAPB0;        // Transfer direction
    output  [2:0] HSIZETARGAPB0;         // Transfer size
    output  [2:0] HBURSTTARGAPB0;        // Burst type
    output  [3:0] HPROTTARGAPB0;         // Protection control
    output  [3:0] HMASTERTARGAPB0;       // Master select
    output [31:0] HWDATATARGAPB0;        // Write data
    output        HMASTLOCKTARGAPB0;     // Locked Sequence
    output        HREADYMUXTARGAPB0;     // Transfer done
    output [3:0] HAUSERTARGAPB0;        // Address USER signals
    output [3:0] HWUSERTARGAPB0;        // Write-data USER signals

    // Output port MI6 (outputs to slave 6)
    output        HSELTARGEXP0;          // Slave Select
    output [31:0] HADDRTARGEXP0;         // Address bus
    output  [1:0] HTRANSTARGEXP0;        // Transfer type
    output        HWRITETARGEXP0;        // Transfer direction
    output  [2:0] HSIZETARGEXP0;         // Transfer size
    output  [2:0] HBURSTTARGEXP0;        // Burst type
    output  [3:0] HPROTTARGEXP0;         // Protection control
    output  [3:0] HMASTERTARGEXP0;       // Master select
    output [31:0] HWDATATARGEXP0;        // Write data
    output        HMASTLOCKTARGEXP0;     // Locked Sequence
    output        HREADYMUXTARGEXP0;     // Transfer done
    output [3:0] HAUSERTARGEXP0;        // Address USER signals
    output [3:0] HWUSERTARGEXP0;        // Write-data USER signals

    // Output port MI7 (outputs to slave 7)
    output        HSELTARGEXP1;          // Slave Select
    output [31:0] HADDRTARGEXP1;         // Address bus
    output  [1:0] HTRANSTARGEXP1;        // Transfer type
    output        HWRITETARGEXP1;        // Transfer direction
    output  [2:0] HSIZETARGEXP1;         // Transfer size
    output  [2:0] HBURSTTARGEXP1;        // Burst type
    output  [3:0] HPROTTARGEXP1;         // Protection control
    output  [3:0] HMASTERTARGEXP1;       // Master select
    output [31:0] HWDATATARGEXP1;        // Write data
    output        HMASTLOCKTARGEXP1;     // Locked Sequence
    output        HREADYMUXTARGEXP1;     // Transfer done
    output [3:0] HAUSERTARGEXP1;        // Address USER signals
    output [3:0] HWUSERTARGEXP1;        // Write-data USER signals

    // Input port SI0 (outputs to master 0)
    output [31:0] HRDATAINITCM3DI;        // Read data bus
    output        HREADYOUTINITCM3DI;     // HREADY feedback
    output  [1:0] HRESPINITCM3DI;         // Transfer response
    output [3:0] HRUSERINITCM3DI;        // Read-data USER signals

    // Input port SI1 (outputs to master 1)
    output [31:0] HRDATAINITCM3S;        // Read data bus
    output        HREADYOUTINITCM3S;     // HREADY feedback
    output  [1:0] HRESPINITCM3S;         // Transfer response
    output [3:0] HRUSERINITCM3S;        // Read-data USER signals

    // Input port SI2 (outputs to master 2)
    output [31:0] HRDATAINITEXP0;        // Read data bus
    output        HREADYOUTINITEXP0;     // HREADY feedback
    output  [1:0] HRESPINITEXP0;         // Transfer response
    output [3:0] HRUSERINITEXP0;        // Read-data USER signals

    // Input port SI3 (outputs to master 3)
    output [31:0] HRDATAINITEXP1;        // Read data bus
    output        HREADYOUTINITEXP1;     // HREADY feedback
    output  [1:0] HRESPINITEXP1;         // Transfer response
    output [3:0] HRUSERINITEXP1;        // Read-data USER signals

    // Scan test dummy signals; not connected until scan insertion
    output        SCANOUTHCLK;     // Scan Chain Output


// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    wire         HCLK;            // AHB System Clock
    wire         HRESETn;         // AHB System Reset

    // System address remapping control
    wire   [3:0] REMAP;           // REMAP signal

    // Input Port SI0
    wire         HSELINITCM3DI;          // Slave Select
    wire  [31:0] HADDRINITCM3DI;         // Address bus
    wire   [1:0] HTRANSINITCM3DI;        // Transfer type
    wire         HWRITEINITCM3DI;        // Transfer direction
    wire   [2:0] HSIZEINITCM3DI;         // Transfer size
    wire   [2:0] HBURSTINITCM3DI;        // Burst type
    wire   [3:0] HPROTINITCM3DI;         // Protection control
    wire   [3:0] HMASTERINITCM3DI;       // Master select
    wire  [31:0] HWDATAINITCM3DI;        // Write data
    wire         HMASTLOCKINITCM3DI;     // Locked Sequence
    wire         HREADYINITCM3DI;        // Transfer done

    wire  [31:0] HRDATAINITCM3DI;        // Read data bus
    wire         HREADYOUTINITCM3DI;     // HREADY feedback
    wire   [1:0] HRESPINITCM3DI;         // Transfer response
    wire  [3:0] HAUSERINITCM3DI;        // Address USER signals
    wire  [3:0] HWUSERINITCM3DI;        // Write-data USER signals
    wire  [3:0] HRUSERINITCM3DI;        // Read-data USER signals

    // Input Port SI1
    wire         HSELINITCM3S;          // Slave Select
    wire  [31:0] HADDRINITCM3S;         // Address bus
    wire   [1:0] HTRANSINITCM3S;        // Transfer type
    wire         HWRITEINITCM3S;        // Transfer direction
    wire   [2:0] HSIZEINITCM3S;         // Transfer size
    wire   [2:0] HBURSTINITCM3S;        // Burst type
    wire   [3:0] HPROTINITCM3S;         // Protection control
    wire   [3:0] HMASTERINITCM3S;       // Master select
    wire  [31:0] HWDATAINITCM3S;        // Write data
    wire         HMASTLOCKINITCM3S;     // Locked Sequence
    wire         HREADYINITCM3S;        // Transfer done

    wire  [31:0] HRDATAINITCM3S;        // Read data bus
    wire         HREADYOUTINITCM3S;     // HREADY feedback
    wire   [1:0] HRESPINITCM3S;         // Transfer response
    wire  [3:0] HAUSERINITCM3S;        // Address USER signals
    wire  [3:0] HWUSERINITCM3S;        // Write-data USER signals
    wire  [3:0] HRUSERINITCM3S;        // Read-data USER signals

    // Input Port SI2
    wire         HSELINITEXP0;          // Slave Select
    wire  [31:0] HADDRINITEXP0;         // Address bus
    wire   [1:0] HTRANSINITEXP0;        // Transfer type
    wire         HWRITEINITEXP0;        // Transfer direction
    wire   [2:0] HSIZEINITEXP0;         // Transfer size
    wire   [2:0] HBURSTINITEXP0;        // Burst type
    wire   [3:0] HPROTINITEXP0;         // Protection control
    wire   [3:0] HMASTERINITEXP0;       // Master select
    wire  [31:0] HWDATAINITEXP0;        // Write data
    wire         HMASTLOCKINITEXP0;     // Locked Sequence
    wire         HREADYINITEXP0;        // Transfer done

    wire  [31:0] HRDATAINITEXP0;        // Read data bus
    wire         HREADYOUTINITEXP0;     // HREADY feedback
    wire   [1:0] HRESPINITEXP0;         // Transfer response
    wire  [3:0] HAUSERINITEXP0;        // Address USER signals
    wire  [3:0] HWUSERINITEXP0;        // Write-data USER signals
    wire  [3:0] HRUSERINITEXP0;        // Read-data USER signals

    // Input Port SI3
    wire         HSELINITEXP1;          // Slave Select
    wire  [31:0] HADDRINITEXP1;         // Address bus
    wire   [1:0] HTRANSINITEXP1;        // Transfer type
    wire         HWRITEINITEXP1;        // Transfer direction
    wire   [2:0] HSIZEINITEXP1;         // Transfer size
    wire   [2:0] HBURSTINITEXP1;        // Burst type
    wire   [3:0] HPROTINITEXP1;         // Protection control
    wire   [3:0] HMASTERINITEXP1;       // Master select
    wire  [31:0] HWDATAINITEXP1;        // Write data
    wire         HMASTLOCKINITEXP1;     // Locked Sequence
    wire         HREADYINITEXP1;        // Transfer done

    wire  [31:0] HRDATAINITEXP1;        // Read data bus
    wire         HREADYOUTINITEXP1;     // HREADY feedback
    wire   [1:0] HRESPINITEXP1;         // Transfer response
    wire  [3:0] HAUSERINITEXP1;        // Address USER signals
    wire  [3:0] HWUSERINITEXP1;        // Write-data USER signals
    wire  [3:0] HRUSERINITEXP1;        // Read-data USER signals

    // Output Port MI0
    wire         HSELTARGFLASH0;          // Slave Select
    wire  [31:0] HADDRTARGFLASH0;         // Address bus
    wire   [1:0] HTRANSTARGFLASH0;        // Transfer type
    wire         HWRITETARGFLASH0;        // Transfer direction
    wire   [2:0] HSIZETARGFLASH0;         // Transfer size
    wire   [2:0] HBURSTTARGFLASH0;        // Burst type
    wire   [3:0] HPROTTARGFLASH0;         // Protection control
    wire   [3:0] HMASTERTARGFLASH0;       // Master select
    wire  [31:0] HWDATATARGFLASH0;        // Write data
    wire         HMASTLOCKTARGFLASH0;     // Locked Sequence
    wire         HREADYMUXTARGFLASH0;     // Transfer done

    wire  [31:0] HRDATATARGFLASH0;        // Read data bus
    wire         HREADYOUTTARGFLASH0;     // HREADY feedback
    wire   [1:0] HRESPTARGFLASH0;         // Transfer response
    wire  [3:0] HAUSERTARGFLASH0;        // Address USER signals
    wire  [3:0] HWUSERTARGFLASH0;        // Write-data USER signals
    wire  [3:0] HRUSERTARGFLASH0;        // Read-data USER signals

    // Output Port MI1
    wire         HSELTARGSRAM0;          // Slave Select
    wire  [31:0] HADDRTARGSRAM0;         // Address bus
    wire   [1:0] HTRANSTARGSRAM0;        // Transfer type
    wire         HWRITETARGSRAM0;        // Transfer direction
    wire   [2:0] HSIZETARGSRAM0;         // Transfer size
    wire   [2:0] HBURSTTARGSRAM0;        // Burst type
    wire   [3:0] HPROTTARGSRAM0;         // Protection control
    wire   [3:0] HMASTERTARGSRAM0;       // Master select
    wire  [31:0] HWDATATARGSRAM0;        // Write data
    wire         HMASTLOCKTARGSRAM0;     // Locked Sequence
    wire         HREADYMUXTARGSRAM0;     // Transfer done

    wire  [31:0] HRDATATARGSRAM0;        // Read data bus
    wire         HREADYOUTTARGSRAM0;     // HREADY feedback
    wire   [1:0] HRESPTARGSRAM0;         // Transfer response
    wire  [3:0] HAUSERTARGSRAM0;        // Address USER signals
    wire  [3:0] HWUSERTARGSRAM0;        // Write-data USER signals
    wire  [3:0] HRUSERTARGSRAM0;        // Read-data USER signals

    // Output Port MI2
    wire         HSELTARGSRAM1;          // Slave Select
    wire  [31:0] HADDRTARGSRAM1;         // Address bus
    wire   [1:0] HTRANSTARGSRAM1;        // Transfer type
    wire         HWRITETARGSRAM1;        // Transfer direction
    wire   [2:0] HSIZETARGSRAM1;         // Transfer size
    wire   [2:0] HBURSTTARGSRAM1;        // Burst type
    wire   [3:0] HPROTTARGSRAM1;         // Protection control
    wire   [3:0] HMASTERTARGSRAM1;       // Master select
    wire  [31:0] HWDATATARGSRAM1;        // Write data
    wire         HMASTLOCKTARGSRAM1;     // Locked Sequence
    wire         HREADYMUXTARGSRAM1;     // Transfer done

    wire  [31:0] HRDATATARGSRAM1;        // Read data bus
    wire         HREADYOUTTARGSRAM1;     // HREADY feedback
    wire   [1:0] HRESPTARGSRAM1;         // Transfer response
    wire  [3:0] HAUSERTARGSRAM1;        // Address USER signals
    wire  [3:0] HWUSERTARGSRAM1;        // Write-data USER signals
    wire  [3:0] HRUSERTARGSRAM1;        // Read-data USER signals

    // Output Port MI3
    wire         HSELTARGSRAM2;          // Slave Select
    wire  [31:0] HADDRTARGSRAM2;         // Address bus
    wire   [1:0] HTRANSTARGSRAM2;        // Transfer type
    wire         HWRITETARGSRAM2;        // Transfer direction
    wire   [2:0] HSIZETARGSRAM2;         // Transfer size
    wire   [2:0] HBURSTTARGSRAM2;        // Burst type
    wire   [3:0] HPROTTARGSRAM2;         // Protection control
    wire   [3:0] HMASTERTARGSRAM2;       // Master select
    wire  [31:0] HWDATATARGSRAM2;        // Write data
    wire         HMASTLOCKTARGSRAM2;     // Locked Sequence
    wire         HREADYMUXTARGSRAM2;     // Transfer done

    wire  [31:0] HRDATATARGSRAM2;        // Read data bus
    wire         HREADYOUTTARGSRAM2;     // HREADY feedback
    wire   [1:0] HRESPTARGSRAM2;         // Transfer response
    wire  [3:0] HAUSERTARGSRAM2;        // Address USER signals
    wire  [3:0] HWUSERTARGSRAM2;        // Write-data USER signals
    wire  [3:0] HRUSERTARGSRAM2;        // Read-data USER signals

    // Output Port MI4
    wire         HSELTARGSRAM3;          // Slave Select
    wire  [31:0] HADDRTARGSRAM3;         // Address bus
    wire   [1:0] HTRANSTARGSRAM3;        // Transfer type
    wire         HWRITETARGSRAM3;        // Transfer direction
    wire   [2:0] HSIZETARGSRAM3;         // Transfer size
    wire   [2:0] HBURSTTARGSRAM3;        // Burst type
    wire   [3:0] HPROTTARGSRAM3;         // Protection control
    wire   [3:0] HMASTERTARGSRAM3;       // Master select
    wire  [31:0] HWDATATARGSRAM3;        // Write data
    wire         HMASTLOCKTARGSRAM3;     // Locked Sequence
    wire         HREADYMUXTARGSRAM3;     // Transfer done

    wire  [31:0] HRDATATARGSRAM3;        // Read data bus
    wire         HREADYOUTTARGSRAM3;     // HREADY feedback
    wire   [1:0] HRESPTARGSRAM3;         // Transfer response
    wire  [3:0] HAUSERTARGSRAM3;        // Address USER signals
    wire  [3:0] HWUSERTARGSRAM3;        // Write-data USER signals
    wire  [3:0] HRUSERTARGSRAM3;        // Read-data USER signals

    // Output Port MI5
    wire         HSELTARGAPB0;          // Slave Select
    wire  [31:0] HADDRTARGAPB0;         // Address bus
    wire   [1:0] HTRANSTARGAPB0;        // Transfer type
    wire         HWRITETARGAPB0;        // Transfer direction
    wire   [2:0] HSIZETARGAPB0;         // Transfer size
    wire   [2:0] HBURSTTARGAPB0;        // Burst type
    wire   [3:0] HPROTTARGAPB0;         // Protection control
    wire   [3:0] HMASTERTARGAPB0;       // Master select
    wire  [31:0] HWDATATARGAPB0;        // Write data
    wire         HMASTLOCKTARGAPB0;     // Locked Sequence
    wire         HREADYMUXTARGAPB0;     // Transfer done

    wire  [31:0] HRDATATARGAPB0;        // Read data bus
    wire         HREADYOUTTARGAPB0;     // HREADY feedback
    wire   [1:0] HRESPTARGAPB0;         // Transfer response
    wire  [3:0] HAUSERTARGAPB0;        // Address USER signals
    wire  [3:0] HWUSERTARGAPB0;        // Write-data USER signals
    wire  [3:0] HRUSERTARGAPB0;        // Read-data USER signals

    // Output Port MI6
    wire         HSELTARGEXP0;          // Slave Select
    wire  [31:0] HADDRTARGEXP0;         // Address bus
    wire   [1:0] HTRANSTARGEXP0;        // Transfer type
    wire         HWRITETARGEXP0;        // Transfer direction
    wire   [2:0] HSIZETARGEXP0;         // Transfer size
    wire   [2:0] HBURSTTARGEXP0;        // Burst type
    wire   [3:0] HPROTTARGEXP0;         // Protection control
    wire   [3:0] HMASTERTARGEXP0;       // Master select
    wire  [31:0] HWDATATARGEXP0;        // Write data
    wire         HMASTLOCKTARGEXP0;     // Locked Sequence
    wire         HREADYMUXTARGEXP0;     // Transfer done

    wire  [31:0] HRDATATARGEXP0;        // Read data bus
    wire         HREADYOUTTARGEXP0;     // HREADY feedback
    wire   [1:0] HRESPTARGEXP0;         // Transfer response
    wire  [3:0] HAUSERTARGEXP0;        // Address USER signals
    wire  [3:0] HWUSERTARGEXP0;        // Write-data USER signals
    wire  [3:0] HRUSERTARGEXP0;        // Read-data USER signals

    // Output Port MI7
    wire         HSELTARGEXP1;          // Slave Select
    wire  [31:0] HADDRTARGEXP1;         // Address bus
    wire   [1:0] HTRANSTARGEXP1;        // Transfer type
    wire         HWRITETARGEXP1;        // Transfer direction
    wire   [2:0] HSIZETARGEXP1;         // Transfer size
    wire   [2:0] HBURSTTARGEXP1;        // Burst type
    wire   [3:0] HPROTTARGEXP1;         // Protection control
    wire   [3:0] HMASTERTARGEXP1;       // Master select
    wire  [31:0] HWDATATARGEXP1;        // Write data
    wire         HMASTLOCKTARGEXP1;     // Locked Sequence
    wire         HREADYMUXTARGEXP1;     // Transfer done

    wire  [31:0] HRDATATARGEXP1;        // Read data bus
    wire         HREADYOUTTARGEXP1;     // HREADY feedback
    wire   [1:0] HRESPTARGEXP1;         // Transfer response
    wire  [3:0] HAUSERTARGEXP1;        // Address USER signals
    wire  [3:0] HWUSERTARGEXP1;        // Write-data USER signals
    wire  [3:0] HRUSERTARGEXP1;        // Read-data USER signals


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------

    // Bus-switch input SI0
    wire         i_sel0;            // HSEL signal
    wire  [31:0] i_addr0;           // HADDR signal
    wire   [1:0] i_trans0;          // HTRANS signal
    wire         i_write0;          // HWRITE signal
    wire   [2:0] i_size0;           // HSIZE signal
    wire   [2:0] i_burst0;          // HBURST signal
    wire   [3:0] i_prot0;           // HPROTS signal
    wire   [3:0] i_master0;         // HMASTER signal
    wire         i_mastlock0;       // HMASTLOCK signal
    wire         i_active0;         // Active signal
    wire         i_held_tran0;       // HeldTran signal
    wire         i_readyout0;       // Readyout signal
    wire   [1:0] i_resp0;           // Response signal
    wire  [3:0] i_auser0;          // HAUSER signal

    // Bus-switch input SI1
    wire         i_sel1;            // HSEL signal
    wire  [31:0] i_addr1;           // HADDR signal
    wire   [1:0] i_trans1;          // HTRANS signal
    wire         i_write1;          // HWRITE signal
    wire   [2:0] i_size1;           // HSIZE signal
    wire   [2:0] i_burst1;          // HBURST signal
    wire   [3:0] i_prot1;           // HPROTS signal
    wire   [3:0] i_master1;         // HMASTER signal
    wire         i_mastlock1;       // HMASTLOCK signal
    wire         i_active1;         // Active signal
    wire         i_held_tran1;       // HeldTran signal
    wire         i_readyout1;       // Readyout signal
    wire   [1:0] i_resp1;           // Response signal
    wire  [3:0] i_auser1;          // HAUSER signal

    // Bus-switch input SI2
    wire         i_sel2;            // HSEL signal
    wire  [31:0] i_addr2;           // HADDR signal
    wire   [1:0] i_trans2;          // HTRANS signal
    wire         i_write2;          // HWRITE signal
    wire   [2:0] i_size2;           // HSIZE signal
    wire   [2:0] i_burst2;          // HBURST signal
    wire   [3:0] i_prot2;           // HPROTS signal
    wire   [3:0] i_master2;         // HMASTER signal
    wire         i_mastlock2;       // HMASTLOCK signal
    wire         i_active2;         // Active signal
    wire         i_held_tran2;       // HeldTran signal
    wire         i_readyout2;       // Readyout signal
    wire   [1:0] i_resp2;           // Response signal
    wire  [3:0] i_auser2;          // HAUSER signal

    // Bus-switch input SI3
    wire         i_sel3;            // HSEL signal
    wire  [31:0] i_addr3;           // HADDR signal
    wire   [1:0] i_trans3;          // HTRANS signal
    wire         i_write3;          // HWRITE signal
    wire   [2:0] i_size3;           // HSIZE signal
    wire   [2:0] i_burst3;          // HBURST signal
    wire   [3:0] i_prot3;           // HPROTS signal
    wire   [3:0] i_master3;         // HMASTER signal
    wire         i_mastlock3;       // HMASTLOCK signal
    wire         i_active3;         // Active signal
    wire         i_held_tran3;       // HeldTran signal
    wire         i_readyout3;       // Readyout signal
    wire   [1:0] i_resp3;           // Response signal
    wire  [3:0] i_auser3;          // HAUSER signal

    // Bus-switch SI0 to MI0 signals
    wire         i_sel0to0;         // Routing selection signal
    wire         i_active0to0;      // Active signal

    // Bus-switch SI0 to MI7 signals
    wire         i_sel0to7;         // Routing selection signal
    wire         i_active0to7;      // Active signal

    // Bus-switch SI1 to MI1 signals
    wire         i_sel1to1;         // Routing selection signal
    wire         i_active1to1;      // Active signal

    // Bus-switch SI1 to MI2 signals
    wire         i_sel1to2;         // Routing selection signal
    wire         i_active1to2;      // Active signal

    // Bus-switch SI1 to MI3 signals
    wire         i_sel1to3;         // Routing selection signal
    wire         i_active1to3;      // Active signal

    // Bus-switch SI1 to MI4 signals
    wire         i_sel1to4;         // Routing selection signal
    wire         i_active1to4;      // Active signal

    // Bus-switch SI1 to MI5 signals
    wire         i_sel1to5;         // Routing selection signal
    wire         i_active1to5;      // Active signal

    // Bus-switch SI1 to MI6 signals
    wire         i_sel1to6;         // Routing selection signal
    wire         i_active1to6;      // Active signal

    // Bus-switch SI1 to MI7 signals
    wire         i_sel1to7;         // Routing selection signal
    wire         i_active1to7;      // Active signal

    // Bus-switch SI2 to MI0 signals
    wire         i_sel2to0;         // Routing selection signal
    wire         i_active2to0;      // Active signal

    // Bus-switch SI2 to MI1 signals
    wire         i_sel2to1;         // Routing selection signal
    wire         i_active2to1;      // Active signal

    // Bus-switch SI2 to MI2 signals
    wire         i_sel2to2;         // Routing selection signal
    wire         i_active2to2;      // Active signal

    // Bus-switch SI2 to MI3 signals
    wire         i_sel2to3;         // Routing selection signal
    wire         i_active2to3;      // Active signal

    // Bus-switch SI2 to MI4 signals
    wire         i_sel2to4;         // Routing selection signal
    wire         i_active2to4;      // Active signal

    // Bus-switch SI2 to MI5 signals
    wire         i_sel2to5;         // Routing selection signal
    wire         i_active2to5;      // Active signal

    // Bus-switch SI2 to MI6 signals
    wire         i_sel2to6;         // Routing selection signal
    wire         i_active2to6;      // Active signal

    // Bus-switch SI2 to MI7 signals
    wire         i_sel2to7;         // Routing selection signal
    wire         i_active2to7;      // Active signal

    // Bus-switch SI3 to MI0 signals
    wire         i_sel3to0;         // Routing selection signal
    wire         i_active3to0;      // Active signal

    // Bus-switch SI3 to MI1 signals
    wire         i_sel3to1;         // Routing selection signal
    wire         i_active3to1;      // Active signal

    // Bus-switch SI3 to MI2 signals
    wire         i_sel3to2;         // Routing selection signal
    wire         i_active3to2;      // Active signal

    // Bus-switch SI3 to MI3 signals
    wire         i_sel3to3;         // Routing selection signal
    wire         i_active3to3;      // Active signal

    // Bus-switch SI3 to MI4 signals
    wire         i_sel3to4;         // Routing selection signal
    wire         i_active3to4;      // Active signal

    // Bus-switch SI3 to MI5 signals
    wire         i_sel3to5;         // Routing selection signal
    wire         i_active3to5;      // Active signal

    // Bus-switch SI3 to MI6 signals
    wire         i_sel3to6;         // Routing selection signal
    wire         i_active3to6;      // Active signal

    // Bus-switch SI3 to MI7 signals
    wire         i_sel3to7;         // Routing selection signal
    wire         i_active3to7;      // Active signal

    wire         i_hready_mux_targflash0;    // Internal HREADYMUXM for MI0
    wire         i_hready_mux_targsram0;    // Internal HREADYMUXM for MI1
    wire         i_hready_mux_targsram1;    // Internal HREADYMUXM for MI2
    wire         i_hready_mux_targsram2;    // Internal HREADYMUXM for MI3
    wire         i_hready_mux_targsram3;    // Internal HREADYMUXM for MI4
    wire         i_hready_mux_targapb0;    // Internal HREADYMUXM for MI5
    wire         i_hready_mux_targexp0;    // Internal HREADYMUXM for MI6
    wire         i_hready_mux_targexp1;    // Internal HREADYMUXM for MI7


// -----------------------------------------------------------------------------
// Beginning of main code
// -----------------------------------------------------------------------------

  // Input stage for SI0
  p_beid_interconnect_f0_ahb_mtx_input_stage u_p_beid_interconnect_f0_ahb_mtx_input_stage_0 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELINITCM3DI),
    .HADDRS     (HADDRINITCM3DI),
    .HTRANSS    (HTRANSINITCM3DI),
    .HWRITES    (HWRITEINITCM3DI),
    .HSIZES     (HSIZEINITCM3DI),
    .HBURSTS    (HBURSTINITCM3DI),
    .HPROTS     (HPROTINITCM3DI),
    .HMASTERS   (HMASTERINITCM3DI),
    .HMASTLOCKS (HMASTLOCKINITCM3DI),
    .HREADYS    (HREADYINITCM3DI),
    .HAUSERS    (HAUSERINITCM3DI),

    // Internal Response
    .active_ip     (i_active0),
    .readyout_ip   (i_readyout0),
    .resp_ip       (i_resp0),

    // Input Port Response
    .HREADYOUTS (HREADYOUTINITCM3DI),
    .HRESPS     (HRESPINITCM3DI),

    // Internal Address/Control Signals
    .sel_ip        (i_sel0),
    .addr_ip       (i_addr0),
    .auser_ip      (i_auser0),
    .trans_ip      (i_trans0),
    .write_ip      (i_write0),
    .size_ip       (i_size0),
    .burst_ip      (i_burst0),
    .prot_ip       (i_prot0),
    .master_ip     (i_master0),
    .mastlock_ip   (i_mastlock0),
    .held_tran_ip   (i_held_tran0)

    );


  // Input stage for SI1
  p_beid_interconnect_f0_ahb_mtx_input_stage u_p_beid_interconnect_f0_ahb_mtx_input_stage_1 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELINITCM3S),
    .HADDRS     (HADDRINITCM3S),
    .HTRANSS    (HTRANSINITCM3S),
    .HWRITES    (HWRITEINITCM3S),
    .HSIZES     (HSIZEINITCM3S),
    .HBURSTS    (HBURSTINITCM3S),
    .HPROTS     (HPROTINITCM3S),
    .HMASTERS   (HMASTERINITCM3S),
    .HMASTLOCKS (HMASTLOCKINITCM3S),
    .HREADYS    (HREADYINITCM3S),
    .HAUSERS    (HAUSERINITCM3S),

    // Internal Response
    .active_ip     (i_active1),
    .readyout_ip   (i_readyout1),
    .resp_ip       (i_resp1),

    // Input Port Response
    .HREADYOUTS (HREADYOUTINITCM3S),
    .HRESPS     (HRESPINITCM3S),

    // Internal Address/Control Signals
    .sel_ip        (i_sel1),
    .addr_ip       (i_addr1),
    .auser_ip      (i_auser1),
    .trans_ip      (i_trans1),
    .write_ip      (i_write1),
    .size_ip       (i_size1),
    .burst_ip      (i_burst1),
    .prot_ip       (i_prot1),
    .master_ip     (i_master1),
    .mastlock_ip   (i_mastlock1),
    .held_tran_ip   (i_held_tran1)

    );


  // Input stage for SI2
  p_beid_interconnect_f0_ahb_mtx_input_stage u_p_beid_interconnect_f0_ahb_mtx_input_stage_2 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELINITEXP0),
    .HADDRS     (HADDRINITEXP0),
    .HTRANSS    (HTRANSINITEXP0),
    .HWRITES    (HWRITEINITEXP0),
    .HSIZES     (HSIZEINITEXP0),
    .HBURSTS    (HBURSTINITEXP0),
    .HPROTS     (HPROTINITEXP0),
    .HMASTERS   (HMASTERINITEXP0),
    .HMASTLOCKS (HMASTLOCKINITEXP0),
    .HREADYS    (HREADYINITEXP0),
    .HAUSERS    (HAUSERINITEXP0),

    // Internal Response
    .active_ip     (i_active2),
    .readyout_ip   (i_readyout2),
    .resp_ip       (i_resp2),

    // Input Port Response
    .HREADYOUTS (HREADYOUTINITEXP0),
    .HRESPS     (HRESPINITEXP0),

    // Internal Address/Control Signals
    .sel_ip        (i_sel2),
    .addr_ip       (i_addr2),
    .auser_ip      (i_auser2),
    .trans_ip      (i_trans2),
    .write_ip      (i_write2),
    .size_ip       (i_size2),
    .burst_ip      (i_burst2),
    .prot_ip       (i_prot2),
    .master_ip     (i_master2),
    .mastlock_ip   (i_mastlock2),
    .held_tran_ip   (i_held_tran2)

    );


  // Input stage for SI3
  p_beid_interconnect_f0_ahb_mtx_input_stage u_p_beid_interconnect_f0_ahb_mtx_input_stage_3 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELINITEXP1),
    .HADDRS     (HADDRINITEXP1),
    .HTRANSS    (HTRANSINITEXP1),
    .HWRITES    (HWRITEINITEXP1),
    .HSIZES     (HSIZEINITEXP1),
    .HBURSTS    (HBURSTINITEXP1),
    .HPROTS     (HPROTINITEXP1),
    .HMASTERS   (HMASTERINITEXP1),
    .HMASTLOCKS (HMASTLOCKINITEXP1),
    .HREADYS    (HREADYINITEXP1),
    .HAUSERS    (HAUSERINITEXP1),

    // Internal Response
    .active_ip     (i_active3),
    .readyout_ip   (i_readyout3),
    .resp_ip       (i_resp3),

    // Input Port Response
    .HREADYOUTS (HREADYOUTINITEXP1),
    .HRESPS     (HRESPINITEXP1),

    // Internal Address/Control Signals
    .sel_ip        (i_sel3),
    .addr_ip       (i_addr3),
    .auser_ip      (i_auser3),
    .trans_ip      (i_trans3),
    .write_ip      (i_write3),
    .size_ip       (i_size3),
    .burst_ip      (i_burst3),
    .prot_ip       (i_prot3),
    .master_ip     (i_master3),
    .mastlock_ip   (i_mastlock3),
    .held_tran_ip   (i_held_tran3)

    );


  // Matrix decoder for SI0
  p_beid_interconnect_f0_ahb_mtx_decoderINITCM3DI u_p_beid_interconnect_f0_ahb_mtx_decoderinitcm3di (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Internal address remapping control
    .remapping_dec  ( REMAP[0] ),

    // Signals from Input stage SI0
    .HREADYS    (HREADYINITCM3DI),
    .sel_dec        (i_sel0),
    .decode_addr_dec (i_addr0[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans0),

    // Control/Response for Output Stage MI0
    .active_dec0    (i_active0to0),
    .readyout_dec0  (i_hready_mux_targflash0),
    .resp_dec0      (HRESPTARGFLASH0),
    .rdata_dec0     (HRDATATARGFLASH0),
    .ruser_dec0     (HRUSERTARGFLASH0),

    // Control/Response for Output Stage MI7
    .active_dec7    (i_active0to7),
    .readyout_dec7  (i_hready_mux_targexp1),
    .resp_dec7      (HRESPTARGEXP1),
    .rdata_dec7     (HRDATATARGEXP1),
    .ruser_dec7     (HRUSERTARGEXP1),

    .sel_dec0       (i_sel0to0),
    .sel_dec7       (i_sel0to7),

    .active_dec     (i_active0),
    .HREADYOUTS (i_readyout0),
    .HRESPS     (i_resp0),
    .HRUSERS    (HRUSERINITCM3DI),
    .HRDATAS    (HRDATAINITCM3DI)

    );


  // Matrix decoder for SI1
  p_beid_interconnect_f0_ahb_mtx_decoderINITCM3S u_p_beid_interconnect_f0_ahb_mtx_decoderinitcm3s (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Internal address remapping control
    .remapping_dec  ( { REMAP[3], REMAP[2], REMAP[1] } ),

    // Signals from Input stage SI1
    .HREADYS    (HREADYINITCM3S),
    .sel_dec        (i_sel1),
    .decode_addr_dec (i_addr1[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans1),

    // Control/Response for Output Stage MI1
    .active_dec1    (i_active1to1),
    .readyout_dec1  (i_hready_mux_targsram0),
    .resp_dec1      (HRESPTARGSRAM0),
    .rdata_dec1     (HRDATATARGSRAM0),
    .ruser_dec1     (HRUSERTARGSRAM0),

    // Control/Response for Output Stage MI2
    .active_dec2    (i_active1to2),
    .readyout_dec2  (i_hready_mux_targsram1),
    .resp_dec2      (HRESPTARGSRAM1),
    .rdata_dec2     (HRDATATARGSRAM1),
    .ruser_dec2     (HRUSERTARGSRAM1),

    // Control/Response for Output Stage MI3
    .active_dec3    (i_active1to3),
    .readyout_dec3  (i_hready_mux_targsram2),
    .resp_dec3      (HRESPTARGSRAM2),
    .rdata_dec3     (HRDATATARGSRAM2),
    .ruser_dec3     (HRUSERTARGSRAM2),

    // Control/Response for Output Stage MI4
    .active_dec4    (i_active1to4),
    .readyout_dec4  (i_hready_mux_targsram3),
    .resp_dec4      (HRESPTARGSRAM3),
    .rdata_dec4     (HRDATATARGSRAM3),
    .ruser_dec4     (HRUSERTARGSRAM3),

    // Control/Response for Output Stage MI5
    .active_dec5    (i_active1to5),
    .readyout_dec5  (i_hready_mux_targapb0),
    .resp_dec5      (HRESPTARGAPB0),
    .rdata_dec5     (HRDATATARGAPB0),
    .ruser_dec5     (HRUSERTARGAPB0),

    // Control/Response for Output Stage MI6
    .active_dec6    (i_active1to6),
    .readyout_dec6  (i_hready_mux_targexp0),
    .resp_dec6      (HRESPTARGEXP0),
    .rdata_dec6     (HRDATATARGEXP0),
    .ruser_dec6     (HRUSERTARGEXP0),

    // Control/Response for Output Stage MI7
    .active_dec7    (i_active1to7),
    .readyout_dec7  (i_hready_mux_targexp1),
    .resp_dec7      (HRESPTARGEXP1),
    .rdata_dec7     (HRDATATARGEXP1),
    .ruser_dec7     (HRUSERTARGEXP1),

    .sel_dec1       (i_sel1to1),
    .sel_dec2       (i_sel1to2),
    .sel_dec3       (i_sel1to3),
    .sel_dec4       (i_sel1to4),
    .sel_dec5       (i_sel1to5),
    .sel_dec6       (i_sel1to6),
    .sel_dec7       (i_sel1to7),

    .active_dec     (i_active1),
    .HREADYOUTS (i_readyout1),
    .HRESPS     (i_resp1),
    .HRUSERS    (HRUSERINITCM3S),
    .HRDATAS    (HRDATAINITCM3S)

    );


  // Matrix decoder for SI2
  p_beid_interconnect_f0_ahb_mtx_decoderINITEXP0 u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp0 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Internal address remapping control
    .remapping_dec  ( { REMAP[3], REMAP[2], REMAP[1], REMAP[0] } ),

    // Signals from Input stage SI2
    .HREADYS    (HREADYINITEXP0),
    .sel_dec        (i_sel2),
    .decode_addr_dec (i_addr2[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans2),

    // Control/Response for Output Stage MI0
    .active_dec0    (i_active2to0),
    .readyout_dec0  (i_hready_mux_targflash0),
    .resp_dec0      (HRESPTARGFLASH0),
    .rdata_dec0     (HRDATATARGFLASH0),
    .ruser_dec0     (HRUSERTARGFLASH0),

    // Control/Response for Output Stage MI1
    .active_dec1    (i_active2to1),
    .readyout_dec1  (i_hready_mux_targsram0),
    .resp_dec1      (HRESPTARGSRAM0),
    .rdata_dec1     (HRDATATARGSRAM0),
    .ruser_dec1     (HRUSERTARGSRAM0),

    // Control/Response for Output Stage MI2
    .active_dec2    (i_active2to2),
    .readyout_dec2  (i_hready_mux_targsram1),
    .resp_dec2      (HRESPTARGSRAM1),
    .rdata_dec2     (HRDATATARGSRAM1),
    .ruser_dec2     (HRUSERTARGSRAM1),

    // Control/Response for Output Stage MI3
    .active_dec3    (i_active2to3),
    .readyout_dec3  (i_hready_mux_targsram2),
    .resp_dec3      (HRESPTARGSRAM2),
    .rdata_dec3     (HRDATATARGSRAM2),
    .ruser_dec3     (HRUSERTARGSRAM2),

    // Control/Response for Output Stage MI4
    .active_dec4    (i_active2to4),
    .readyout_dec4  (i_hready_mux_targsram3),
    .resp_dec4      (HRESPTARGSRAM3),
    .rdata_dec4     (HRDATATARGSRAM3),
    .ruser_dec4     (HRUSERTARGSRAM3),

    // Control/Response for Output Stage MI5
    .active_dec5    (i_active2to5),
    .readyout_dec5  (i_hready_mux_targapb0),
    .resp_dec5      (HRESPTARGAPB0),
    .rdata_dec5     (HRDATATARGAPB0),
    .ruser_dec5     (HRUSERTARGAPB0),

    // Control/Response for Output Stage MI6
    .active_dec6    (i_active2to6),
    .readyout_dec6  (i_hready_mux_targexp0),
    .resp_dec6      (HRESPTARGEXP0),
    .rdata_dec6     (HRDATATARGEXP0),
    .ruser_dec6     (HRUSERTARGEXP0),

    // Control/Response for Output Stage MI7
    .active_dec7    (i_active2to7),
    .readyout_dec7  (i_hready_mux_targexp1),
    .resp_dec7      (HRESPTARGEXP1),
    .rdata_dec7     (HRDATATARGEXP1),
    .ruser_dec7     (HRUSERTARGEXP1),

    .sel_dec0       (i_sel2to0),
    .sel_dec1       (i_sel2to1),
    .sel_dec2       (i_sel2to2),
    .sel_dec3       (i_sel2to3),
    .sel_dec4       (i_sel2to4),
    .sel_dec5       (i_sel2to5),
    .sel_dec6       (i_sel2to6),
    .sel_dec7       (i_sel2to7),

    .active_dec     (i_active2),
    .HREADYOUTS (i_readyout2),
    .HRESPS     (i_resp2),
    .HRUSERS    (HRUSERINITEXP0),
    .HRDATAS    (HRDATAINITEXP0)

    );


  // Matrix decoder for SI3
  p_beid_interconnect_f0_ahb_mtx_decoderINITEXP1 u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Internal address remapping control
    .remapping_dec  ( { REMAP[3], REMAP[2], REMAP[1], REMAP[0] } ),

    // Signals from Input stage SI3
    .HREADYS    (HREADYINITEXP1),
    .sel_dec        (i_sel3),
    .decode_addr_dec (i_addr3[31:10]),   // HADDR[9:0] is not decoded
    .trans_dec      (i_trans3),

    // Control/Response for Output Stage MI0
    .active_dec0    (i_active3to0),
    .readyout_dec0  (i_hready_mux_targflash0),
    .resp_dec0      (HRESPTARGFLASH0),
    .rdata_dec0     (HRDATATARGFLASH0),
    .ruser_dec0     (HRUSERTARGFLASH0),

    // Control/Response for Output Stage MI1
    .active_dec1    (i_active3to1),
    .readyout_dec1  (i_hready_mux_targsram0),
    .resp_dec1      (HRESPTARGSRAM0),
    .rdata_dec1     (HRDATATARGSRAM0),
    .ruser_dec1     (HRUSERTARGSRAM0),

    // Control/Response for Output Stage MI2
    .active_dec2    (i_active3to2),
    .readyout_dec2  (i_hready_mux_targsram1),
    .resp_dec2      (HRESPTARGSRAM1),
    .rdata_dec2     (HRDATATARGSRAM1),
    .ruser_dec2     (HRUSERTARGSRAM1),

    // Control/Response for Output Stage MI3
    .active_dec3    (i_active3to3),
    .readyout_dec3  (i_hready_mux_targsram2),
    .resp_dec3      (HRESPTARGSRAM2),
    .rdata_dec3     (HRDATATARGSRAM2),
    .ruser_dec3     (HRUSERTARGSRAM2),

    // Control/Response for Output Stage MI4
    .active_dec4    (i_active3to4),
    .readyout_dec4  (i_hready_mux_targsram3),
    .resp_dec4      (HRESPTARGSRAM3),
    .rdata_dec4     (HRDATATARGSRAM3),
    .ruser_dec4     (HRUSERTARGSRAM3),

    // Control/Response for Output Stage MI5
    .active_dec5    (i_active3to5),
    .readyout_dec5  (i_hready_mux_targapb0),
    .resp_dec5      (HRESPTARGAPB0),
    .rdata_dec5     (HRDATATARGAPB0),
    .ruser_dec5     (HRUSERTARGAPB0),

    // Control/Response for Output Stage MI6
    .active_dec6    (i_active3to6),
    .readyout_dec6  (i_hready_mux_targexp0),
    .resp_dec6      (HRESPTARGEXP0),
    .rdata_dec6     (HRDATATARGEXP0),
    .ruser_dec6     (HRUSERTARGEXP0),

    // Control/Response for Output Stage MI7
    .active_dec7    (i_active3to7),
    .readyout_dec7  (i_hready_mux_targexp1),
    .resp_dec7      (HRESPTARGEXP1),
    .rdata_dec7     (HRDATATARGEXP1),
    .ruser_dec7     (HRUSERTARGEXP1),

    .sel_dec0       (i_sel3to0),
    .sel_dec1       (i_sel3to1),
    .sel_dec2       (i_sel3to2),
    .sel_dec3       (i_sel3to3),
    .sel_dec4       (i_sel3to4),
    .sel_dec5       (i_sel3to5),
    .sel_dec6       (i_sel3to6),
    .sel_dec7       (i_sel3to7),

    .active_dec     (i_active3),
    .HREADYOUTS (i_readyout3),
    .HRESPS     (i_resp3),
    .HRUSERS    (HRUSERINITEXP1),
    .HRDATAS    (HRDATAINITEXP1)

    );


  // Output stage for MI0
  p_beid_interconnect_f0_ahb_mtx_output_stageTARGFLASH0 u_p_beid_interconnect_f0_ahb_mtx_output_stagetargflash0_0 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .sel_op0       (i_sel0to0),
    .addr_op0      (i_addr0),
    .auser_op0     (i_auser0),
    .trans_op0     (i_trans0),
    .write_op0     (i_write0),
    .size_op0      (i_size0),
    .burst_op0     (i_burst0),
    .prot_op0      (i_prot0),
    .master_op0    (i_master0),
    .mastlock_op0  (i_mastlock0),
    .wdata_op0     (HWDATAINITCM3DI),
    .wuser_op0     (HWUSERINITCM3DI),
    .held_tran_op0  (i_held_tran0),

    // Port 2 Signals
    .sel_op2       (i_sel2to0),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAINITEXP0),
    .wuser_op2     (HWUSERINITEXP0),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to0),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAINITEXP1),
    .wuser_op3     (HWUSERINITEXP1),
    .held_tran_op3  (i_held_tran3),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTTARGFLASH0),

    .active_op0    (i_active0to0),
    .active_op2    (i_active2to0),
    .active_op3    (i_active3to0),

    // Slave Address/Control Signals
    .HSELM      (HSELTARGFLASH0),
    .HADDRM     (HADDRTARGFLASH0),
    .HAUSERM    (HAUSERTARGFLASH0),
    .HTRANSM    (HTRANSTARGFLASH0),
    .HWRITEM    (HWRITETARGFLASH0),
    .HSIZEM     (HSIZETARGFLASH0),
    .HBURSTM    (HBURSTTARGFLASH0),
    .HPROTM     (HPROTTARGFLASH0),
    .HMASTERM   (HMASTERTARGFLASH0),
    .HMASTLOCKM (HMASTLOCKTARGFLASH0),
    .HREADYMUXM (i_hready_mux_targflash0),
    .HWUSERM    (HWUSERTARGFLASH0),
    .HWDATAM    (HWDATATARGFLASH0)

    );

  // Drive output with internal version
  assign HREADYMUXTARGFLASH0 = i_hready_mux_targflash0;


  // Output stage for MI1
  p_beid_interconnect_f0_ahb_mtx_output_stageTARGSRAM0 u_p_beid_interconnect_f0_ahb_mtx_output_stagetargsram0_1 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 1 Signals
    .sel_op1       (i_sel1to1),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATAINITCM3S),
    .wuser_op1     (HWUSERINITCM3S),
    .held_tran_op1  (i_held_tran1),

    // Port 2 Signals
    .sel_op2       (i_sel2to1),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAINITEXP0),
    .wuser_op2     (HWUSERINITEXP0),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to1),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAINITEXP1),
    .wuser_op3     (HWUSERINITEXP1),
    .held_tran_op3  (i_held_tran3),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTTARGSRAM0),

    .active_op1    (i_active1to1),
    .active_op2    (i_active2to1),
    .active_op3    (i_active3to1),

    // Slave Address/Control Signals
    .HSELM      (HSELTARGSRAM0),
    .HADDRM     (HADDRTARGSRAM0),
    .HAUSERM    (HAUSERTARGSRAM0),
    .HTRANSM    (HTRANSTARGSRAM0),
    .HWRITEM    (HWRITETARGSRAM0),
    .HSIZEM     (HSIZETARGSRAM0),
    .HBURSTM    (HBURSTTARGSRAM0),
    .HPROTM     (HPROTTARGSRAM0),
    .HMASTERM   (HMASTERTARGSRAM0),
    .HMASTLOCKM (HMASTLOCKTARGSRAM0),
    .HREADYMUXM (i_hready_mux_targsram0),
    .HWUSERM    (HWUSERTARGSRAM0),
    .HWDATAM    (HWDATATARGSRAM0)

    );

  // Drive output with internal version
  assign HREADYMUXTARGSRAM0 = i_hready_mux_targsram0;


  // Output stage for MI2
  p_beid_interconnect_f0_ahb_mtx_output_stageTARGSRAM1 u_p_beid_interconnect_f0_ahb_mtx_output_stagetargsram1_2 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 1 Signals
    .sel_op1       (i_sel1to2),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATAINITCM3S),
    .wuser_op1     (HWUSERINITCM3S),
    .held_tran_op1  (i_held_tran1),

    // Port 2 Signals
    .sel_op2       (i_sel2to2),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAINITEXP0),
    .wuser_op2     (HWUSERINITEXP0),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to2),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAINITEXP1),
    .wuser_op3     (HWUSERINITEXP1),
    .held_tran_op3  (i_held_tran3),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTTARGSRAM1),

    .active_op1    (i_active1to2),
    .active_op2    (i_active2to2),
    .active_op3    (i_active3to2),

    // Slave Address/Control Signals
    .HSELM      (HSELTARGSRAM1),
    .HADDRM     (HADDRTARGSRAM1),
    .HAUSERM    (HAUSERTARGSRAM1),
    .HTRANSM    (HTRANSTARGSRAM1),
    .HWRITEM    (HWRITETARGSRAM1),
    .HSIZEM     (HSIZETARGSRAM1),
    .HBURSTM    (HBURSTTARGSRAM1),
    .HPROTM     (HPROTTARGSRAM1),
    .HMASTERM   (HMASTERTARGSRAM1),
    .HMASTLOCKM (HMASTLOCKTARGSRAM1),
    .HREADYMUXM (i_hready_mux_targsram1),
    .HWUSERM    (HWUSERTARGSRAM1),
    .HWDATAM    (HWDATATARGSRAM1)

    );

  // Drive output with internal version
  assign HREADYMUXTARGSRAM1 = i_hready_mux_targsram1;


  // Output stage for MI3
  p_beid_interconnect_f0_ahb_mtx_output_stageTARGSRAM2 u_p_beid_interconnect_f0_ahb_mtx_output_stagetargsram2_3 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 1 Signals
    .sel_op1       (i_sel1to3),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATAINITCM3S),
    .wuser_op1     (HWUSERINITCM3S),
    .held_tran_op1  (i_held_tran1),

    // Port 2 Signals
    .sel_op2       (i_sel2to3),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAINITEXP0),
    .wuser_op2     (HWUSERINITEXP0),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to3),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAINITEXP1),
    .wuser_op3     (HWUSERINITEXP1),
    .held_tran_op3  (i_held_tran3),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTTARGSRAM2),

    .active_op1    (i_active1to3),
    .active_op2    (i_active2to3),
    .active_op3    (i_active3to3),

    // Slave Address/Control Signals
    .HSELM      (HSELTARGSRAM2),
    .HADDRM     (HADDRTARGSRAM2),
    .HAUSERM    (HAUSERTARGSRAM2),
    .HTRANSM    (HTRANSTARGSRAM2),
    .HWRITEM    (HWRITETARGSRAM2),
    .HSIZEM     (HSIZETARGSRAM2),
    .HBURSTM    (HBURSTTARGSRAM2),
    .HPROTM     (HPROTTARGSRAM2),
    .HMASTERM   (HMASTERTARGSRAM2),
    .HMASTLOCKM (HMASTLOCKTARGSRAM2),
    .HREADYMUXM (i_hready_mux_targsram2),
    .HWUSERM    (HWUSERTARGSRAM2),
    .HWDATAM    (HWDATATARGSRAM2)

    );

  // Drive output with internal version
  assign HREADYMUXTARGSRAM2 = i_hready_mux_targsram2;


  // Output stage for MI4
  p_beid_interconnect_f0_ahb_mtx_output_stageTARGSRAM3 u_p_beid_interconnect_f0_ahb_mtx_output_stagetargsram3_4 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 1 Signals
    .sel_op1       (i_sel1to4),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATAINITCM3S),
    .wuser_op1     (HWUSERINITCM3S),
    .held_tran_op1  (i_held_tran1),

    // Port 2 Signals
    .sel_op2       (i_sel2to4),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAINITEXP0),
    .wuser_op2     (HWUSERINITEXP0),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to4),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAINITEXP1),
    .wuser_op3     (HWUSERINITEXP1),
    .held_tran_op3  (i_held_tran3),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTTARGSRAM3),

    .active_op1    (i_active1to4),
    .active_op2    (i_active2to4),
    .active_op3    (i_active3to4),

    // Slave Address/Control Signals
    .HSELM      (HSELTARGSRAM3),
    .HADDRM     (HADDRTARGSRAM3),
    .HAUSERM    (HAUSERTARGSRAM3),
    .HTRANSM    (HTRANSTARGSRAM3),
    .HWRITEM    (HWRITETARGSRAM3),
    .HSIZEM     (HSIZETARGSRAM3),
    .HBURSTM    (HBURSTTARGSRAM3),
    .HPROTM     (HPROTTARGSRAM3),
    .HMASTERM   (HMASTERTARGSRAM3),
    .HMASTLOCKM (HMASTLOCKTARGSRAM3),
    .HREADYMUXM (i_hready_mux_targsram3),
    .HWUSERM    (HWUSERTARGSRAM3),
    .HWDATAM    (HWDATATARGSRAM3)

    );

  // Drive output with internal version
  assign HREADYMUXTARGSRAM3 = i_hready_mux_targsram3;


  // Output stage for MI5
  p_beid_interconnect_f0_ahb_mtx_output_stageTARGAPB0 u_p_beid_interconnect_f0_ahb_mtx_output_stagetargapb0_5 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 1 Signals
    .sel_op1       (i_sel1to5),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATAINITCM3S),
    .wuser_op1     (HWUSERINITCM3S),
    .held_tran_op1  (i_held_tran1),

    // Port 2 Signals
    .sel_op2       (i_sel2to5),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAINITEXP0),
    .wuser_op2     (HWUSERINITEXP0),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to5),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAINITEXP1),
    .wuser_op3     (HWUSERINITEXP1),
    .held_tran_op3  (i_held_tran3),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTTARGAPB0),

    .active_op1    (i_active1to5),
    .active_op2    (i_active2to5),
    .active_op3    (i_active3to5),

    // Slave Address/Control Signals
    .HSELM      (HSELTARGAPB0),
    .HADDRM     (HADDRTARGAPB0),
    .HAUSERM    (HAUSERTARGAPB0),
    .HTRANSM    (HTRANSTARGAPB0),
    .HWRITEM    (HWRITETARGAPB0),
    .HSIZEM     (HSIZETARGAPB0),
    .HBURSTM    (HBURSTTARGAPB0),
    .HPROTM     (HPROTTARGAPB0),
    .HMASTERM   (HMASTERTARGAPB0),
    .HMASTLOCKM (HMASTLOCKTARGAPB0),
    .HREADYMUXM (i_hready_mux_targapb0),
    .HWUSERM    (HWUSERTARGAPB0),
    .HWDATAM    (HWDATATARGAPB0)

    );

  // Drive output with internal version
  assign HREADYMUXTARGAPB0 = i_hready_mux_targapb0;


  // Output stage for MI6
  p_beid_interconnect_f0_ahb_mtx_output_stageTARGEXP0 u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 1 Signals
    .sel_op1       (i_sel1to6),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATAINITCM3S),
    .wuser_op1     (HWUSERINITCM3S),
    .held_tran_op1  (i_held_tran1),

    // Port 2 Signals
    .sel_op2       (i_sel2to6),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAINITEXP0),
    .wuser_op2     (HWUSERINITEXP0),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to6),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAINITEXP1),
    .wuser_op3     (HWUSERINITEXP1),
    .held_tran_op3  (i_held_tran3),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTTARGEXP0),

    .active_op1    (i_active1to6),
    .active_op2    (i_active2to6),
    .active_op3    (i_active3to6),

    // Slave Address/Control Signals
    .HSELM      (HSELTARGEXP0),
    .HADDRM     (HADDRTARGEXP0),
    .HAUSERM    (HAUSERTARGEXP0),
    .HTRANSM    (HTRANSTARGEXP0),
    .HWRITEM    (HWRITETARGEXP0),
    .HSIZEM     (HSIZETARGEXP0),
    .HBURSTM    (HBURSTTARGEXP0),
    .HPROTM     (HPROTTARGEXP0),
    .HMASTERM   (HMASTERTARGEXP0),
    .HMASTLOCKM (HMASTLOCKTARGEXP0),
    .HREADYMUXM (i_hready_mux_targexp0),
    .HWUSERM    (HWUSERTARGEXP0),
    .HWDATAM    (HWDATATARGEXP0)

    );

  // Drive output with internal version
  assign HREADYMUXTARGEXP0 = i_hready_mux_targexp0;


  // Output stage for MI7
  p_beid_interconnect_f0_ahb_mtx_output_stageTARGEXP1 u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7 (

    // Common AHB signals
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .sel_op0       (i_sel0to7),
    .addr_op0      (i_addr0),
    .auser_op0     (i_auser0),
    .trans_op0     (i_trans0),
    .write_op0     (i_write0),
    .size_op0      (i_size0),
    .burst_op0     (i_burst0),
    .prot_op0      (i_prot0),
    .master_op0    (i_master0),
    .mastlock_op0  (i_mastlock0),
    .wdata_op0     (HWDATAINITCM3DI),
    .wuser_op0     (HWUSERINITCM3DI),
    .held_tran_op0  (i_held_tran0),

    // Port 1 Signals
    .sel_op1       (i_sel1to7),
    .addr_op1      (i_addr1),
    .auser_op1     (i_auser1),
    .trans_op1     (i_trans1),
    .write_op1     (i_write1),
    .size_op1      (i_size1),
    .burst_op1     (i_burst1),
    .prot_op1      (i_prot1),
    .master_op1    (i_master1),
    .mastlock_op1  (i_mastlock1),
    .wdata_op1     (HWDATAINITCM3S),
    .wuser_op1     (HWUSERINITCM3S),
    .held_tran_op1  (i_held_tran1),

    // Port 2 Signals
    .sel_op2       (i_sel2to7),
    .addr_op2      (i_addr2),
    .auser_op2     (i_auser2),
    .trans_op2     (i_trans2),
    .write_op2     (i_write2),
    .size_op2      (i_size2),
    .burst_op2     (i_burst2),
    .prot_op2      (i_prot2),
    .master_op2    (i_master2),
    .mastlock_op2  (i_mastlock2),
    .wdata_op2     (HWDATAINITEXP0),
    .wuser_op2     (HWUSERINITEXP0),
    .held_tran_op2  (i_held_tran2),

    // Port 3 Signals
    .sel_op3       (i_sel3to7),
    .addr_op3      (i_addr3),
    .auser_op3     (i_auser3),
    .trans_op3     (i_trans3),
    .write_op3     (i_write3),
    .size_op3      (i_size3),
    .burst_op3     (i_burst3),
    .prot_op3      (i_prot3),
    .master_op3    (i_master3),
    .mastlock_op3  (i_mastlock3),
    .wdata_op3     (HWDATAINITEXP1),
    .wuser_op3     (HWUSERINITEXP1),
    .held_tran_op3  (i_held_tran3),

    // Slave read data and response
    .HREADYOUTM (HREADYOUTTARGEXP1),

    .active_op0    (i_active0to7),
    .active_op1    (i_active1to7),
    .active_op2    (i_active2to7),
    .active_op3    (i_active3to7),

    // Slave Address/Control Signals
    .HSELM      (HSELTARGEXP1),
    .HADDRM     (HADDRTARGEXP1),
    .HAUSERM    (HAUSERTARGEXP1),
    .HTRANSM    (HTRANSTARGEXP1),
    .HWRITEM    (HWRITETARGEXP1),
    .HSIZEM     (HSIZETARGEXP1),
    .HBURSTM    (HBURSTTARGEXP1),
    .HPROTM     (HPROTTARGEXP1),
    .HMASTERM   (HMASTERTARGEXP1),
    .HMASTLOCKM (HMASTLOCKTARGEXP1),
    .HREADYMUXM (i_hready_mux_targexp1),
    .HWUSERM    (HWUSERTARGEXP1),
    .HWDATAM    (HWDATATARGEXP1)

    );

  // Drive output with internal version
  assign HREADYMUXTARGEXP1 = i_hready_mux_targexp1;


endmodule

// --================================= End ===================================--
