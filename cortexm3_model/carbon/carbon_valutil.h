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
#include "carbon/carbon_shelltypes.h"

template <typename Pod>
void carbon_smallval_to_strNoNull(char* valStr, Pod srcVal, Pod srcDrv, bool isPulled, CarbonUInt32 width)
{
  Pod mask = 1;
  {
    Pod widthMask = ~Pod(0);
    if (width != sizeof(Pod) * 8)
    {
      widthMask <<= width;
      widthMask = ~widthMask;
    }
    srcDrv = ~srcDrv & widthMask;
  }
  if (isPulled || (srcDrv == 0))
    for (CarbonUInt32 i = 0; i < width; ++i, mask <<= 1)
      valStr[width - 1 - i] = ((srcVal & mask) != 0) ? '1' : '0';
  else
    for (CarbonUInt32 i = 0; i < width; ++i, mask <<= 1)
      if ((srcDrv & mask) != 0)
        valStr[width - 1 - i] = 'Z';
      else
        valStr[width - 1 - i] = ((srcVal & mask) != 0) ? '1' : '0';
}

template <typename Pod>
void carbon_smallval_to_str(char* valStr, Pod srcVal, Pod srcDrv, bool isPulled, CarbonUInt32 width)
{
  valStr[width] = '\0';
  carbon_smallval_to_strNoNull(valStr, srcVal, srcDrv, isPulled, width);
}

inline void carbon_largeval_to_str(char* valStr, CarbonUInt32* srcVal, CarbonUInt32* srcDrv, bool isPulled, CarbonUInt32 width)
{
  valStr[width] = '\0';
  CarbonUInt32 numWords = (width + 31)/32;
  CarbonUInt32 tail = width % 32;
  if (tail == 0) tail = 32;
  for (CarbonUInt32 j = 0; j < numWords - 1; ++j) {
    CarbonUInt32 mask = 1;
    if (isPulled || (srcDrv == NULL) || (~srcDrv[j] == 0))
      for (CarbonUInt32 i = 0; i < 32; ++i, mask <<= 1)
        valStr[width - (j * 32) - 1 - i] = ((srcVal[j] & mask) != 0) ? '1' : '0';
    else
      for (CarbonUInt32 i = 0; i < 32; ++i, mask <<= 1)
        if ((~srcDrv[j] & mask) != 0)
          valStr[width - (j * 32) - 1 - i] = 'Z';
        else
          valStr[width - (j * 32) - 1 - i] = ((srcVal[j] & mask) != 0) ? '1' : '0';
  }
  CarbonUInt32 mask = 1;
  CarbonUInt32 srcDrvLastWord = 0;
  if (srcDrv)
  {
    CarbonUInt32 widthMask = ~CarbonUInt32(0);
    if (tail != 32)
    {
      widthMask <<= tail;
      widthMask = ~widthMask;
    }
    srcDrvLastWord = srcDrv[numWords - 1];
    srcDrvLastWord = ~srcDrvLastWord & widthMask;
  }
  if (isPulled || (srcDrv == NULL) || (srcDrvLastWord == 0))
    for (CarbonUInt32 i = 0; i < tail; ++i, mask <<= 1)
      valStr[width - ((numWords - 1) * 32) - 1 - i] = ((srcVal[numWords - 1] & mask) != 0) ? '1' : '0';
  else
  {
    for (CarbonUInt32 i = 0; i < tail; ++i, mask <<= 1)
      if ((srcDrvLastWord & mask) != 0)
        valStr[width - ((numWords - 1) * 32) - 1 - i] = 'Z';
      else
        valStr[width - ((numWords - 1) * 32) - 1 - i] = ((srcVal[numWords - 1] & mask) != 0) ? '1' : '0';
  }
}

template <typename Pod> void carbon_calcBidi_smallval(char* valStr, Pod srcIData, Pod srcXDrv, Pod srcIDrv, bool isPulled, CarbonUInt32 width)
{
  int curPos = width;
  valStr[curPos] = '\0';
  --curPos;

  Pod calcDrive = srcXDrv & ~srcIDrv;
  if (calcDrive == 0)
  {
    Pod mask = 1;
    for (CarbonUInt32 i = 0; i < width; ++i)
    {
      valStr[curPos] = ((srcIData & mask) != 0) ? '1' : '0';
      --curPos;
      mask <<= 1;
    }
  }
  else
    carbon_smallval_to_strNoNull(valStr, srcIData, Pod(~calcDrive), isPulled, width);
}

void carbon_calcBidi_largeval(char* valStr, const CarbonUInt32* srcIData, const CarbonUInt32* srcXDrv,
                              const CarbonUInt32* srcIDrv, bool isPulled, CarbonUInt32 width)
{
  CarbonUInt32 numWords = (width + 31)/32;
  CarbonUInt32 tail = width % 32;
  if (tail == 0) tail = 32;

  int curPos = width;
  valStr[curPos] = '\0';
  --curPos;

  for (CarbonUInt32 j = 0; j < numWords - 1; ++j)
  {
    CarbonUInt32 calcDrive = srcXDrv[j] & ~srcIDrv[j];
    if (calcDrive == 0)
    {
      CarbonUInt32 mask = 1;
      for (CarbonUInt32 i = 0; i < 32; ++i)
      {
        valStr[curPos] = ((srcIData[j] & mask) != 0) ? '1' : '0';
        --curPos;
        mask <<= 1;
      }
    }
    else
    {
      carbon_smallval_to_strNoNull(&valStr[curPos - 31], srcIData[j], CarbonUInt32(~calcDrive), isPulled, 32);
      curPos -= 32;
    }
  }

  // lastword
  CarbonUInt32 calcDrive = srcXDrv[numWords - 1] & ~srcIDrv[numWords - 1];
  if (calcDrive == 0)
  {
    CarbonUInt32 mask = 1;
    for (CarbonUInt32 i = 0; i < tail; ++i)
    {
      valStr[curPos] = ((srcIData[numWords - 1] & mask) != 0) ? '1' : '0';
      --curPos;
      mask <<= 1;
    }
  }
  else
    carbon_smallval_to_strNoNull(&valStr[curPos - tail + 1], srcIData[numWords - 1], CarbonUInt32(~calcDrive), isPulled, tail);
}

template <typename T> void carbon_setbidi_smallxdrive(T* xdrivePtr, T idrive, CarbonUInt32 bitwidth)
{
  if (idrive != 0)
  {
    T mask = 1;
    for (CarbonUInt32 i = 0; i < bitwidth; ++i)
    {
      if ((idrive & mask) != 0)
        // internally driven. Turn off external drive
        *xdrivePtr |= mask;
      mask <<= 1;
    }
  }

}

void carbon_setbidi_largexdrive(CarbonUInt32* xdrivePtr, const CarbonUInt32* idrive, CarbonUInt32 width)
{
  CarbonUInt32 numWords = (width + 31)/32;
  CarbonUInt32 tail = width % 32;
  if (tail == 0) tail = 32;

  CarbonUInt32 srcDriveWord;

  for (CarbonUInt32 j = 0; j < numWords - 1; ++j)
  {
    srcDriveWord = idrive[j];
    if (srcDriveWord != 0)
    {
      CarbonUInt32 mask = 1;
      for (CarbonUInt32 i = 0; i < 32; ++i)
      {
        if ((srcDriveWord & mask) != 0)
          // internally driven. Turn off external drive
          xdrivePtr[j] |= mask;
        mask <<= 1;
      }
    }
  }

  // last word
  srcDriveWord = idrive[numWords - 1];
  if (idrive[numWords - 1] != 0)
  {
    CarbonUInt32 mask = 1;
    for (CarbonUInt32 i = 0; i < tail; ++i)
    {
      if ((srcDriveWord & mask) != 0)
        // internally driven. Turn off external drive
        xdrivePtr[numWords - 1] |= mask;
      mask <<= 1;
    }
  }
}

void carbon_toupper(char* str, CarbonUInt32 len)
{
  for (CarbonUInt32 i = 0; i < len; ++i)
  {
    char p = str[i];
    str[i] = toupper(p);
  }
}

template <typename T>
void carbon_setbidi_bitvalue(sc_logic shadow, T* xdata, T* idata, T* xdrive)
{
  switch(shadow.value())
  {
  case sc_dt::Log_1:
    *xdata = 1;
    *idata = 1;
    *xdrive = 0;
    break;
  case sc_dt::Log_0:
  case sc_dt::Log_X:
    *xdata = 0;
    *idata = 0;
    *xdrive = 0;
    break;
  case sc_dt::Log_Z:
    *xdata = 1;
    *idata = 1;
    *xdrive = 1;
    break;
  }
}

CarbonChangeType carbon_compute_change_type(sc_logic shadow)
{
  CarbonChangeType changeType;
  switch (shadow.value()) {
    case sc_dt::Log_1:
      changeType = CARBON_CHANGE_RISE_MASK;
      break;

    case sc_dt::Log_0:
      changeType = CARBON_CHANGE_FALL_MASK;
      break;

    default:
      changeType = CARBON_CHANGE_MASK;
      break;
  }
  return changeType;
}

CarbonChangeType carbon_compute_change_type(const bool& value)
{
  CarbonChangeType changeType;
  if (value) {
    changeType = CARBON_CHANGE_RISE_MASK;
  } else {
    changeType = CARBON_CHANGE_FALL_MASK;
  }
  return changeType;
}

template <typename S, typename T>
void carbon_setbidi_value(const S& shadow, T* xdata, T* idata, T* xdrive)
{
  const CarbonUInt32 nbits = shadow.length();
  const CarbonUInt32 primSize = sizeof(T) * 8;
  const CarbonUInt32 numPrims = (nbits + primSize - 1)/primSize;

  CarbonUInt32 curBit = 0;
  for (CarbonUInt32 j = 0; j < numPrims; ++j)
  {
    T mask = 1;
    for (CarbonUInt32 i = 0; (i < primSize) && (curBit < nbits); ++i, mask <<= 1, ++curBit)
    {
      switch(shadow.get_bit(curBit))
      {
      case sc_dt::Log_1:
        xdata[j] |= mask;
        xdrive[j] &= ~mask;
        break;
      case sc_dt::Log_0:
      case sc_dt::Log_X:
        xdata[j] &= ~mask;
        xdrive[j] &= ~mask;
        break;
      case sc_dt::Log_Z:
        xdata[j] |= mask;
        xdrive[j] |= mask;
        break;
      }
    }
  }

  // can't use memcpy. Not portable
  for (CarbonUInt32 j = 0; j < numPrims; ++j)
    idata[j] = xdata[j];
}

template <typename L, typename U>
static void carbon_uint_to_lv(const U* uint, L& logic)
{
  const CarbonUInt32 nbits = logic.length();
  const CarbonUInt32 primSize = sizeof(U) * 8;
  const CarbonUInt32 numPrims = (nbits + primSize - 1)/primSize;

  CarbonUInt32 curBit = 0;
  for (CarbonUInt32 j = 0; j < numPrims; ++j)
  {
    U mask = 1;
    for (CarbonUInt32 i = 0; (i < primSize) && (curBit < nbits); ++i, mask <<= 1, ++curBit)
    {
      if ((uint[j] & mask) == 0)
        logic.set_bit(curBit, sc_dt::Log_0);
      else
        logic.set_bit(curBit, sc_dt::Log_1);
    }
  }
}

template <typename L, typename U>
static void carbon_lv_to_uint(const L& logic, U* uint)
{
  const CarbonUInt32 nbits = logic.length();
  const CarbonUInt32 primSize = sizeof(U) * 8;
  const CarbonUInt32 numPrims = (nbits + primSize - 1)/primSize;

  CarbonUInt32 curBit = 0;
  for (CarbonUInt32 j = 0; j < numPrims; ++j)
  {
    U mask = 1;
    for (CarbonUInt32 i = 0; (i < primSize) && (curBit < nbits); ++i, mask <<= 1, ++curBit)
    {
      if (logic.get_bit(curBit) == sc_dt::Log_1)
        uint[j] |= mask;
      else
        uint[j] &= ~mask;
    }
  }
}
