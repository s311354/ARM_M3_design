//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2010-2017 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2013-04-17 14:39:57 +0100 (Wed, 17 Apr 2013) $
//
//      Revision            : $Revision: 365823 $
//
//      Release Information : CM3DesignStart-r0p0-02rel0
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : System configurations for Cortex-M example system
//-----------------------------------------------------------------------------
`include "fpga_options_defs.v"

//-----------------------------------------------------------------------------
// Abstract : System configurations for Cortex-M example system
//-----------------------------------------------------------------------------

// CPU selection
// Note : No need to set this for simulation. The Verilog command file (.vc)
//        set this up
//
//        **IMPORTANT**  You need to set up this for synthesis.

//`define CORTEX_M3
//`define CORTEX_M4
`define CORTEX_M3DESIGNSTART

//------------------------------------------------------------------------------
// Define to state if FPU has been licensed. Comment out define if it has not
// been licensed.
//------------------------------------------------------------------------------
// Note : No need to set this for simulation. The Verilog command file (.vc) set
//        this up
//
//        **IMPORTANT**  You need to set up this for synthesis.

//`define ARM_CM4_FPU_LICENSE

//------------------------------------------------------------------------------
// Option to define if Floating Point Unit is included.
//------------------------------------------------------------------------------
// ARM_CM4_INCLUDE_FPU can only be set if FPU license is available
//`ifdef ARM_CM4_FPU_LICENSE
//`define ARM_CM4_INCLUDE_FPU
//`endif

// ============= MCU System options ===========

//------------------------------------------------------------------------------
// Option for debug protocol
// It can either be SWD (Serial Wire Debug protocol) or JTAG
// This option cannot be controlled purely by parameters
// due to impact on I/O ports of the MCU design
//
//`define ARM_CMSDK_INCLUDE_JTAG

