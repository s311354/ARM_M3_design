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
// Type of parameter to get_packed_rep() changed in OSCI 2.2.
#if defined(SYSTEMC_VERSION) && SYSTEMC_VERSION < 20070314
typedef unsigned long carbon_sc_packed_rep_type;
#else
typedef unsigned int carbon_sc_packed_rep_type;
#endif

/*
  A helper function to print debug trace information.
 */
#ifdef CARBON_SC_TRACE
static void sCarbonScTrace(const char *label, const char *name, CarbonUInt32 numWords, CarbonUInt32 *value, CarbonUInt32 *drive)
{
  cout << "CARBON_SC_TRACE: [" << sc_time_stamp() << "] " << label << " " << name << endl;
  cout << "CARBON_SC_TRACE:     drive (hex) =";
  for (int i = numWords - 1; i >= 0; i--) {
    if (drive) {
      cout << " " << setw(8) << hex << drive[i];
    }
    else {
      cout << " " << setw(8) << hex << 0x00000000;
    }
  }
  cout << dec << endl;

  cout << "CARBON_SC_TRACE:     value (hex) =" << hex;
  for (int i = numWords - 1; i >= 0; i--) {
    cout << " " << setw(8) << hex << value[i];
  }
  cout << dec << endl;
}
#endif


/*
  Simple wrapper over the CarbonUInt32 representation of a tristate value.
 */
template<CarbonUInt32 WORDS>
class Carbon3StateBuffer {
public:
  Carbon3StateBuffer() {
    memset(mValue, 0, sizeof(mValue));
    memset(mDrive, 0, sizeof(mDrive));
  }

  CarbonUInt32 *value() { return mValue; }
  CarbonUInt32 *drive() { return mDrive; }

  void setBuffer(CarbonUInt32 *value, CarbonUInt32 *drive) {
    memcpy(mValue, value, sizeof(mValue));
    if (drive != 0)
    memcpy(mDrive, drive, sizeof(mDrive));
  }

private:
  CarbonUInt32 mValue[WORDS];
  CarbonUInt32 mDrive[WORDS];
};

/*
  Simple wrapper over the CarbonUInt32 representation of a 2-state value.
 */
template<CarbonUInt32 WORDS>
class Carbon2StateBuffer {
public:
  Carbon2StateBuffer() {
    memset(mValue, 0, sizeof(mValue));
  }

  CarbonUInt32 *value() { return mValue; }
  CarbonUInt32 *drive() { return NULL; }

  void setBuffer(CarbonUInt32 *value, CarbonUInt32 *drive) {
    memcpy(mValue, value, sizeof(mValue));
  }

private:
  CarbonUInt32 mValue[WORDS];
};


/*
  A wrapper over a CarbonNetID that includes a CarbonUInt32 buffer
  to hold the current value.
 */
template<typename BUF_TYPE>
class CarbonVhmNet {
public:
  CarbonVhmNet() {}

  void initialize(CarbonObjectID *vhm, const char *hierarchicalName) {
    mVhmId = vhm;
    mNetId = carbonFindNet(vhm, hierarchicalName);
#ifdef CARBON_SC_TRACE
    mNetName = hierarchicalName;
#endif
  }

  BUF_TYPE &buffer() { return mBuffer; }

  void deposit() {
#ifdef CARBON_SC_TRACE
    sCarbonScTrace("deposit to net", mNetName, carbonGetNumUInt32s(mNetId), buffer().value(), buffer().drive());
#endif
    carbonDepositFast(mVhmId, mNetId, mBuffer.value(), mBuffer.drive());
  }

  void examine() {
    carbonExamine(mVhmId, mNetId, buffer().value(), buffer().drive());
  }

  CarbonUInt32 getBuffer32(void) {
    CarbonUInt32 *tempBuffer32 = mBuffer.value();
    return *tempBuffer32;
  }

  CarbonUInt64 getBuffer64(void) {
    CarbonUInt32 *tempBuffer32 = mBuffer.value();
    CarbonUInt64 tempValue;
    memcpy(&tempValue,tempBuffer32,sizeof(tempValue));
    return tempValue;
  }

  void setBuffer32(CarbonUInt32 newValue) {
     setBuffer(&newValue,0);
  }

  void setBuffer64(CarbonUInt64 newValue) {
     CarbonUInt32 tempValue[2];
     memcpy(tempValue,&newValue,sizeof(newValue));
     setBuffer(tempValue,0);
  }

  void setBuffer(CarbonUInt32 *value, CarbonUInt32 *drive) {
    mBuffer.setBuffer(value, drive);
  }

  CarbonNetID *netId() { return mNetId; }

private:
  BUF_TYPE        mBuffer;
  CarbonObjectID *mVhmId;
  CarbonNetID    *mNetId;
#ifdef CARBON_SC_TRACE
  const char     *mNetName;
#endif
};


/*
  A wrapper class for Carbon nets that are connected to SystemC output ports.

  The main use is to provide a net value change callback function and
  a simple mechanism for writing queued value changes in the eval phase
  of the delta cycle after carbonSchedule has been run.
 */
template<class SC_TYPE, class SC_PORT, typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
class CarbonScOutputPort {
public:
  CarbonScOutputPort(SC_PORT &scPort)
    : mScPort(scPort), mNextData(NULL), mNextFunc(NULL) {}

  void initialize(CarbonObjectID *vhm, const char *hierarchicalName, void **dataQueue, void **funcQueue) {
    mpDataList = dataQueue;
    mpFuncList = funcQueue;
    mVhmNet.initialize(vhm, hierarchicalName);
    if (!carbonIsConstant(mVhmNet.netId())) {
      carbonAddNetValueChangeCB(vhm, vhmOutputPortChange, this, mVhmNet.netId());
    }
  }

  void setBuffer(CarbonUInt32 *value, CarbonUInt32 *drive) {
    mVhmNet.setBuffer(value, drive);
  }

  BUF_TYPE &buffer() { return mVhmNet.buffer(); }
  SC_PORT &port() { return mScPort; }
  CarbonVhmNet<BUF_TYPE> &net() { return mVhmNet; }

  void enqueueWrite() {
    // Don't queue us again if we're already in the queue
    if (mNextFunc == NULL) {
      mNextData = *mpDataList;
      mNextFunc = *mpFuncList;
      *mpDataList = this;
      *mpFuncList = (void *) performWrite;
    }
  }

  void dequeueWrite() {
    // Remove self from the queue.
    // This is done when the output change has been written back to SystemC
    *mpDataList = mNextData;
    *mpFuncList = mNextFunc;
    mNextData = NULL;
    mNextFunc = NULL;
  }

  // This function is registered with the ARM Cycle Models model to be called when the CarbonNet changes value.
  static void vhmOutputPortChange(CarbonObjectID*, CarbonNetID*, CarbonClientData data, CarbonUInt32 *value, CarbonUInt32 *drive) {
    CarbonScOutputPort<SC_TYPE, SC_PORT, BUF_TYPE, WORDS, BITS> *self = (CarbonScOutputPort<SC_TYPE, SC_PORT, BUF_TYPE, WORDS, BITS> *) data;

    // update the current value buffer with the new value
    self->setBuffer(value, drive);

    // add self to the queue of values to be written
    self->enqueueWrite();
  }


  // this function is called to actually write a value to SystemC from the queue
  static void performWrite(void *data) {
    CarbonScOutputPort<SC_TYPE, SC_PORT, BUF_TYPE, WORDS, BITS> *self = (CarbonScOutputPort<SC_TYPE, SC_PORT, BUF_TYPE, WORDS, BITS> *) data;

#ifdef CARBON_SC_TRACE
    sCarbonScTrace("performWrite of port", self->port().name(), WORDS, self->buffer().value(), self->buffer().drive());
#endif

    // convert the CarbonUInt32 representation of the value to the SystemC type
    SC_TYPE scValue;
    carbon_uint32_to_sc<BUF_TYPE, WORDS, BITS>(scValue, self->buffer());

#ifdef CARBON_SC_TRACE
    cout << "CARBON_SC_TRACE:     scValue = " << scValue << "\n";
#endif

    // write the new value to the SystemC port
    self->port().write(scValue);

    // remove from the queue
    self->dequeueWrite();
  }

private:
  CarbonVhmNet<BUF_TYPE>  mVhmNet;
  SC_PORT                &mScPort;
  void                   **mpDataList;
  void                   **mpFuncList;
  void                   *mNextData;
  void                   *mNextFunc;
};


/*
  A class that wraps Carbon nets that are used as inout ports.
 */
template<class SC_TYPE, class SC_PORT, typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
class CarbonScInoutPort {
public:
  CarbonScInoutPort(SC_PORT &scPort)
    : mScPort(scPort) {}

  void initialize(CarbonObjectID *vhm, const char *hierarchicalName) {
    mVhmNet.initialize(vhm, hierarchicalName);
  }

  CarbonVhmNet<BUF_TYPE> &net() { return mVhmNet; }
  SC_TYPE &scValueBuffer() { return mScValueBuffer; }

  // called during end_of_elaboration to set the initial output value
  void initializeSystemCValue() {
    // initialize our SystemC value buffer with the current SystemC value
    mScValueBuffer = mScPort.read();

    // The initial value will be pushed to SystemC by the
    // carbon_write_outputs method.  We must do it there, because the
    // implementation of sc_signal_rv tracks drivers by SystemC
    // process handle.  If we drive the value from here, it will be
    // seen as a different driver than carbon_write_outputs, and the
    // initial value will be driven for the duration of the
    // simulation, causing conflicts.
    }

  // called after carbonSchedule to write the current value of the net to SystemC
  void updateSystemCValue() {

    // read current value and drive from ARM Cycle Models model
    mVhmNet.examine();

    // convert the CarbonUInt32 representation of the value to the SystemC type
    SC_TYPE newScValue;
    carbon_uint32_to_sc<BUF_TYPE, WORDS, BITS>(newScValue, mVhmNet.buffer());

    // if the value has changed, write it to SystemC
    if (newScValue != mScValueBuffer) {
      mScValueBuffer = newScValue;
      mScPort.write(newScValue);

#ifdef CARBON_SC_TRACE
      sCarbonScTrace("updateSystemCValue of port", mScPort.name(), WORDS, mVhmNet.buffer().value(), mVhmNet.buffer().drive());
      cout << "CARBON_SC_TRACE:     scValue = " << newScValue << "\n";
#endif
    }
  }

private:
  CarbonVhmNet<BUF_TYPE>  mVhmNet;
  SC_PORT                &mScPort;
  SC_TYPE                 mScValueBuffer;
};


///////////////////////////////////////////////////////////////////////////////
// bool
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const bool &scValue, BUF_TYPE &buf) {
  buf.value()[0] = scValue;
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(bool &scValue, BUF_TYPE &buf) {
  scValue = buf.value()[0] != 0;
}

///////////////////////////////////////////////////////////////////////////////
// sc_uint
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const sc_uint<BITS> &scValue, BUF_TYPE &buf) {
  const CarbonUInt32 bitsPerWord = sizeof(CarbonUInt32) * 8;

  if (WORDS == 1) {
    buf.value()[0] = scValue;
  }
  else {
    CarbonUInt64 u64 = scValue;
    buf.value()[0] = u64 & 0xffffffff;
    buf.value()[1] = (u64 >> bitsPerWord) & 0xffffffff;
  }
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(sc_uint<BITS> &scValue, BUF_TYPE &buf) {
  const CarbonUInt32 bitsPerWord = sizeof(CarbonUInt32) * 8;

  if (WORDS == 1) {
    scValue = buf.value()[0];
  }
  else {
    scValue = (((CarbonUInt64)buf.value()[1]) << bitsPerWord) + buf.value()[0];
  }
}

///////////////////////////////////////////////////////////////////////////////
// sc_int
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const sc_int<BITS> &scValue, BUF_TYPE &buf) {
  const CarbonUInt32 bitsPerWord = sizeof(CarbonUInt32) * 8;

  if (WORDS == 1) {
    buf.value()[0] = scValue;
  }
  else {
    CarbonUInt64 u64 = scValue;
    buf.value()[0] = u64 & 0xffffffff;
    buf.value()[1] = (u64 >> bitsPerWord) & 0xffffffff;
  }
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(sc_int<BITS> &scValue, BUF_TYPE &buf) {
  const CarbonUInt32 bitsPerWord = sizeof(CarbonUInt32) * 8;

  if (WORDS == 1) {
    scValue = buf.value()[0];
  }
  else {
    scValue = (((CarbonUInt64)buf.value()[1]) << bitsPerWord) + buf.value()[0];
  }
}

///////////////////////////////////////////////////////////////////////////////
// sc_biguint
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const sc_biguint<BITS> &scValue, BUF_TYPE &buf) {
  carbon_sc_packed_rep_type buf64[WORDS];
  scValue.get_packed_rep(buf64);
  memcpy(buf.value(), buf64, sizeof(CarbonUInt32) * WORDS);
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(sc_biguint<BITS> &scValue, BUF_TYPE &buf) {
  scValue.set_packed_rep((carbon_sc_packed_rep_type *) buf.value());
}

///////////////////////////////////////////////////////////////////////////////
// sc_bigint
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const sc_bigint<BITS> &scValue, BUF_TYPE &buf) {
  carbon_sc_packed_rep_type buf64[WORDS];
  scValue.get_packed_rep(buf64);
  memcpy(buf.value(), buf64, sizeof(CarbonUInt32) * WORDS);
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(sc_bigint<BITS> &scValue, BUF_TYPE &buf) {
  scValue.set_packed_rep((carbon_sc_packed_rep_type *) buf.value());
}

///////////////////////////////////////////////////////////////////////////////
// sc_logic
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const sc_logic &scValue, Carbon2StateBuffer<WORDS> &buf) {
  buf.value()[0] = static_cast<CarbonUInt32>(scValue == sc_dt::Log_1);
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(sc_logic &scValue, Carbon2StateBuffer<WORDS> &buf) {
  scValue = sc_logic(buf.value()[0] == 1);
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const sc_logic &scValue, Carbon3StateBuffer<WORDS> &buf) {
  switch(scValue.value()) {
  case sc_dt::Log_1:
    buf.value()[0] = 1;  // drive a 1
    buf.drive()[0] = 0;
    break;
  case sc_dt::Log_0:
  case sc_dt::Log_X:
    buf.value()[0] = 0;  // drive a 0
    buf.drive()[0] = 0;
    break;
  case sc_dt::Log_Z:
    buf.value()[0] = 1;
    buf.drive()[0] = 1;  // value is not driven
    break;
  }
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(sc_logic &scValue, Carbon3StateBuffer<WORDS> &buf) {
  // if ARM Cycle Models model is driving the signal
  if ((buf.drive()[0] & 0x00000001) == 0) {
    scValue = sc_logic(buf.value()[0] == 1);
  }
  else {
    scValue = sc_dt::Log_Z;
  }
}

///////////////////////////////////////////////////////////////////////////////
// sc_lv
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const sc_lv<BITS> &scValue, Carbon2StateBuffer<WORDS> &buf) {
  carbon_lv_to_uint(scValue, buf.value());
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(sc_lv<BITS> &scValue, Carbon2StateBuffer<WORDS> &buf) {
  carbon_uint_to_lv(buf.value(), scValue);
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const sc_lv<BITS> &scValue, Carbon3StateBuffer<WORDS> &buf) {
  const CarbonUInt32 nbits = scValue.length();
  const CarbonUInt32 primSize = sizeof(CarbonUInt32) * 8;
  const CarbonUInt32 numPrims = (nbits + primSize - 1)/primSize;

  CarbonUInt32 curBit = 0;
  for (CarbonUInt32 j = 0; j < numPrims; ++j)
  {
    CarbonUInt32 mask = 1;
    for (CarbonUInt32 i = 0; (i < primSize) && (curBit < nbits); ++i, mask <<= 1, ++curBit)
    {
      switch(scValue.get_bit(curBit)) {
      case sc_dt::Log_1:
        buf.value()[j] |= mask;  // drive a 1
        buf.drive()[j] &= ~mask;
        break;
      case sc_dt::Log_0:
      case sc_dt::Log_X:
        buf.value()[j] &= ~mask; // drive a 0
        buf.drive()[j] &= ~mask;
        break;
      case sc_dt::Log_Z:
        buf.value()[j] |= mask; // value is not driven
        buf.drive()[j] |= mask;
        break;
      }
    }
  }
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(sc_lv<BITS> &scValue, Carbon3StateBuffer<WORDS> &buf) {
  const CarbonUInt32 nbits = scValue.length();
  const CarbonUInt32 primSize = sizeof(CarbonUInt32) * 8;
  const CarbonUInt32 numPrims = (nbits + primSize - 1)/primSize;

  CarbonUInt32 curBit = 0;
  for (CarbonUInt32 j = 0; j < numPrims; ++j)
  {
    CarbonUInt32 mask = 1;
    for (CarbonUInt32 i = 0; (i < primSize) && (curBit < nbits); ++i, mask <<= 1, ++curBit)
    {
      // if ARM Cycle Models model is driving the signal, set to 0 or 1
      if ((buf.drive()[j] & mask) == 0) {
        scValue.set_bit(curBit, (buf.value()[j] & mask) ? sc_dt::Log_1 : sc_dt::Log_0);
      }
      else {
        // not driving - set to Z
        scValue.set_bit(curBit, sc_dt::Log_Z);
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////
// sc_bv
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const sc_bv<BITS> &scValue, BUF_TYPE &buf) {
  const CarbonUInt32 bitsPerWord = sizeof(CarbonUInt32) * 8;
  for (int i = 0; i < WORDS; i++) {
    int low = i * bitsPerWord;
    int high = low + (bitsPerWord -1);
    if (high >= BITS) {
      high = BITS -1;
    }
    buf.value()[i] = scValue.range(high, low).to_uint();
  }
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(sc_bv<BITS> &scValue, BUF_TYPE &buf) {
  const CarbonUInt32 bitsPerWord = sizeof(CarbonUInt32) * 8;
  for (int i = 0; i < WORDS; i++) {
    int low = i * bitsPerWord;
    int high = low + (bitsPerWord -1);
    if (high >= BITS) {
      high = BITS -1;
    }
    scValue.range(high, low) = buf.value()[i];
  }
}

///////////////////////////////////////////////////////////////////////////////
// unsigned long
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const unsigned long &scValue, BUF_TYPE &buf) {
  const CarbonUInt32 bitsPerWord = sizeof(CarbonUInt32) * 8;
  for (int i = 0; i < WORDS; i++) {
    buf.value()[i] = scValue >> (i * bitsPerWord);
  }
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(unsigned long &scValue, BUF_TYPE &buf) {
  const CarbonUInt32 bitsPerWord = sizeof(CarbonUInt32) * 8;
  scValue = 0UL;
  for (int i = WORDS -1; i >= 0; i--) {
    scValue = (scValue << (i * bitsPerWord)) | buf.value()[i];
  }
}

///////////////////////////////////////////////////////////////////////////////
// long
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const long &scValue, BUF_TYPE &buf) {
  const CarbonUInt32 bitsPerWord = sizeof(CarbonUInt32) * 8;
  for (int i = 0; i < WORDS; i++) {
    buf.value()[i] = scValue >> (i * bitsPerWord);
  }
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(long &scValue, BUF_TYPE &buf) {
  const CarbonUInt32 bitsPerWord = sizeof(CarbonUInt32) * 8;
  scValue = 0L;
  for (int i = WORDS -1; i >= 0; i--) {
    scValue = (scValue << (i * bitsPerWord)) | buf.value()[i];
  }
}

///////////////////////////////////////////////////////////////////////////////
// unsigned int
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const unsigned int &scValue, BUF_TYPE &buf) {
  buf.value()[0] = scValue;
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(unsigned int &scValue, BUF_TYPE &buf) {
  scValue = buf.value()[0];
}

///////////////////////////////////////////////////////////////////////////////
// int
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const int &scValue, BUF_TYPE &buf) {
  buf.value()[0] = scValue;
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(int &scValue, BUF_TYPE &buf) {
  scValue = buf.value()[0];
}

///////////////////////////////////////////////////////////////////////////////
// unsigned char
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const unsigned char &scValue, BUF_TYPE &buf) {
  buf.value()[0] = scValue;
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(unsigned char &scValue, BUF_TYPE &buf) {
  scValue = buf.value()[0];
}

///////////////////////////////////////////////////////////////////////////////
// char
///////////////////////////////////////////////////////////////////////////////
template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_sc_to_uint32(const char &scValue, BUF_TYPE &buf) {
  buf.value()[0] = scValue;
}

template<typename BUF_TYPE, CarbonUInt32 WORDS, CarbonUInt32 BITS>
static void carbon_uint32_to_sc(char &scValue, BUF_TYPE &buf) {
  scValue = buf.value()[0];
}
