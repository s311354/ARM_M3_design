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
#ifndef __cortexm3_integrationds_dsm_H_
#define __cortexm3_integrationds_dsm_H_

#ifndef __carbon_capi_h_
#include "carbon/carbon_capi.h"
#endif
#ifndef __carbon_db_h_
#include "carbon/carbon_dbapi.h"
#endif

#ifdef __cplusplus
#define EXTERNDEF extern "C"
#else
#define EXTERNDEF
#endif
EXTERNDEF CarbonObjectID* carbon_cortexm3_integrationds_dsm_create(CarbonDBType dbType, CarbonInitFlags flags);
#endif

#ifndef _dsm_carbon_arm_if_h_
#define _dsm_carbon_arm_if_h_

#ifdef __cplusplus
extern "C" {
#endif

extern void dsm_carbon_arm_if_init();

#ifdef __cplusplus
}
#endif
#endif
