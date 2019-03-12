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

#ifndef _CarbonDebugAccess_h_
#define _CarbonDebugAccess_h_

enum CarbonDebugAccessStatus {
  eCarbonDebugAccessStatusOk,        // Access was successfully completed for entire transaction
  eCarbonDebugAccessStatusPartial,   // Access was Partially completed
  eCarbonDebugAccessStatusOutRange,  // Access was out of range, no access was completed
  eCarbonDebugAccessStatusError      // Some error occured, no access was completed
};

enum CarbonDebugAccessDirection {
  eCarbonDebugAccessRead,
  eCarbonDebugAccessWrite
};

#endif

