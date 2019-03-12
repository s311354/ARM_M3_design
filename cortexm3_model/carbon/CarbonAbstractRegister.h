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
   // Purpose : File containing the API for the ARM CycleModels AbstractRegister manipulation api.
//------------------------------------------------------------------------------
#ifndef __carbon_abstract_register_h_
#define __carbon_abstract_register_h_


#ifdef __cplusplus
extern "C" {
#endif

#ifndef __carbon_shelltypes_h_
#include "carbon/carbon_shelltypes.h"
#endif

  /*!
    \brief ARM CycleModels Abstract Register structure

    The CarbonAbstractRegisterID provides the context for accessing abstract
    registers.
  */
typedef struct CarbonAbstractRegister *CarbonAbstractRegisterID;

  /*!
    \brief Create ARM CycleModels AbstractRegister Context

    \param srcStart The starting bit position from the src array
    to bein extraction from.

    \param numBits The number of bits to extract beginning at srcStart

    \param dstStart The starting bit position in the dst array to begin
    insertion of numBits starting from srcStart
  */
CarbonAbstractRegisterID carbonAbstractRegisterCreate(CarbonUInt32 srcStart, CarbonUInt32 numBits, CarbonUInt32 dstStart);

  /*!
    \brief Frees the memory allocated via carbonAbstractRegisterCreate
  */
void carbonAbstractRegisterDestroy(CarbonAbstractRegisterID ctx);

  /*!
    \brief Extract and transfer bits from src to dst

    \param src The array of CarbonUInt32s used to source the bits

    \param dst The destination array of CarbonUInt32s to receive
    the extracted bits.
  */
void CarbonAbstractRegisterXfer(CarbonAbstractRegisterID ctx, const CarbonUInt32* src, CarbonUInt32* dst);

#ifdef __cplusplus
}
#endif

#endif


