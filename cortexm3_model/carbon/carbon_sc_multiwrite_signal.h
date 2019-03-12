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
#ifndef __carbon_sc_multiwrite_signal_h_
#define __carbon_sc_multiwrite_signal_h_

//
// Create a version of sc_signal that changes policy to allow multiple writers
//
template<class T>
class carbon_sc_multiwrite_signal : public sc_core::sc_signal<T, SC_UNCHECKED_WRITERS>
{
public:
  typedef sc_core::sc_signal<T, SC_UNCHECKED_WRITERS> base;
  carbon_sc_multiwrite_signal() : base() {}
  explicit carbon_sc_multiwrite_signal(const char*n) : base(n) {}
};

#endif
