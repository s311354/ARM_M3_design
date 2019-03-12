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
// Purpose: This is defines types used by ARM Cycle Model Studio in the generated code that implements  a stand alone simulation model
//------------------------------------------------------------------------------
#ifndef _CarbonStandAloneComponentIF_h_
#define _CarbonStandAloneComponentIF_h_

#include "carbon/carbon_shelltypes.h"
#include "carbon/CarbonDebugAccess.h"

#include "eslapi/CADI.h"

class CarbonDebugAccessIF {
public:
  // Read Debug Access
  virtual CarbonDebugAccessStatus debugMemRead(uint64_t addr, uint8_t* buf, uint32_t numBytes, uint32_t* ctrl = 0) = 0;

  // Write Debug Access
  virtual CarbonDebugAccessStatus debugMemWrite (uint64_t addr, const uint8_t* buf, uint32_t numBytes, uint32_t* ctrl = 0) = 0;

  // Base Address. These methods are implemented by Slave Ports, so that the environment can
  // specify a base address for the debug port that is used when acessing registers in the
  // model.

  // Sets base address for the port.
  virtual void setBaseAddress(uint64_t) {}

  // Returns current base address for the port.
  virtual uint64_t getBaseAddress() { return 0; }
};

//! Interface class for Standalone Carbonized IP
class CarbonStandAloneComponentIF {
public:
  //! Retreive ARM CycleModels Object
  virtual CarbonObjectID* getCarbonObject()=0;

  //! Returns number of supported CADI interfaces.
  virtual unsigned int numberOfCADIIfs()=0;

  //! Returns specified CADI object
  virtual eslapi::CADI* getCADI(unsigned int index)=0;

  //! Loads an application file
  virtual void loadFile(const char* filename)=0;

  // Tell the given core to stall the execution and flush
  // the pipeline.
  // core is the index of the core to stop. The index corresponds to
  // the index used with the getCADI method.
  // stop should be set to true when a stall is requestion and to
  // false when resuming simulation.
  virtual void stopAtDebuggablePoint(unsigned int core, bool stop)=0;

  // Returns true when the core is at a debuggable state.
  // core is the index of the core to stop. The index corresponds to
  // the index used with the getCADI method.
  virtual bool canStop(unsigned int core)=0;

  //! Register debug access callback object for the given port.
  virtual bool registerDebugAccessCB(const char* portName,
                                     CarbonDebugAccessIF* cbObj)=0;

  //! Retrieve debug access interface for the given port
  virtual CarbonDebugAccessIF* retrieveDebugAccessIF(const char* portName)=0;

  //! Simulation API's
  virtual void init()=0;
  virtual void reset()=0;
  virtual void update(CarbonTime time)=0;
  virtual void terminate()=0;

  //! Set Parameter
  //! \param name Name of parameter to set
  //! \param value String to hold value of parameter
  virtual void setComponentParameter(const char* name, const char* value)=0;

  //! Get Parameter
  //! \param name Name of parameter to get
  //! \param value String to return value of parameter
  //! \param maxLen Size of string pointed by \a value
  virtual void getComponentParameter(const char* name, char* value, uint32_t maxLen)=0;

  // Returns parent of component
  virtual CarbonStandAloneComponentIF* getParent(){ return 0;}  // For internal use

  // Sub Component Update
  virtual void subUpdate(int) {} // For internal use
};

#endif
