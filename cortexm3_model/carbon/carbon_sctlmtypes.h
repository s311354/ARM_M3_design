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
// Purpose: Contains helper classes to create SystemC models using GreenSocs based adapters
//------------------------------------------------------------------------------

#ifndef _CARBON_SCTLMTYPES_H_
#define _CARBON_SCTLMTYPES_H_

#include "systemc.h"
#include "greensocket/monitor/green_socket_observer_base.h"

//! Forward declaration of clock generator
template <unsigned int BUSWIDTH> class CarbonScGatedClock;

//! The following class redirects all activity on a single interface to a parent class
/*! A component may have more than one slave interface, and if there
 *  is activity on any of them, the component should be woken up. This
 *  class redirects the activity for a single interface to a common
 *  clock generator.
 *
 *  This class is based off the GreenSocs gs::socket::gp_observer_base
 *  class. That class requires that the four virtual callback
 *  functions nb_call_callback, nb_return_callback, b_call_callback,
 *  and b_return_callback get overloaded. Those are the four events
 *  that are monitored and when they occur, it results in calls to the
 *  CarbonScGatedClock functions: transactionStart() and
 *  transactionEnd().
 *
 *  Note that this is just one possible way to activate/deactivate the
 *  clock generator. Another possibility is to only activate the clock
 *  on transaction start events. In that case the code should call the
 *  CarbonScGatedClock::wakeup() function and the transaction count
 *  feature will not be used.
 *
 */
template <unsigned int BUSWIDTH>
class CarbonScInterfaceObserver : public gs::socket::gp_observer_base
{
public:
  //! Constructor
  /*! Uses the monitor/observer pair to redirect activity to the clock generator
   */
  CarbonScInterfaceObserver(const char* interfaceName,
                            gs::socket::monitor<BUSWIDTH, tlm::tlm_base_protocol_types>* mon,
                            CarbonScGatedClock<BUSWIDTH>* gatedClk) :
    gs::socket::gp_observer_base(mon),
    mInterfaceName(interfaceName),
    mGatedClk(gatedClk)
  {}

  //! Called when an nb_transport call happens
  virtual void nb_call_callback(bool fwNbw, tlm::tlm_generic_payload& txn, const tlm::tlm_phase& phase,
                                const sc_core::sc_time& time)
  {
    if (fwNbw) {
#ifdef CARBON_CLOCK_DEBUG
      std::cout << mInterfaceName << ": " << sc_time_stamp() << ": Traffic detected on nb_transport_fw. Waking up model.\n";
#endif
      mGatedClk->transactionStart();
    }
  }

  //! Called when an nb_transport has been delivered and is about to return
  virtual void nb_return_callback(bool fwNbw, tlm::tlm_generic_payload& txn, const tlm::tlm_phase& phase,
                                  const sc_core::sc_time& time, tlm::tlm_sync_enum retVal)
  {
    if (fwNbw) {
#ifdef CARBON_CLOCK_DEBUG
      std::cout << mInterfaceName << ": " << sc_time_stamp() << ": Transaction end detected on nb_transport_fw.\n";
#endif
      mGatedClk->transactionEnd();
    }
  }

  //! Called when a b_transport call has happened
  virtual void b_call_callback(tlm::tlm_generic_payload& txn, const sc_core::sc_time& time)
  {
#ifdef CARBON_CLOCK_DEBUG
    std::cout << mInterfaceName << ": " << sc_time_stamp() << ": Traffic detected on b_transport. Waking up model.\n";
#endif
    mGatedClk->transactionStart();
  }

  //! Called when a b_transport has been delivered and is about to return
  virtual void b_return_callback(tlm::tlm_generic_payload& txn, const sc_core::sc_time& time)
  {
#ifdef CARBON_CLOCK_DEBUG
      std::cout << mInterfaceName << ": " << sc_time_stamp() << ": Transaction end detected on b_transport.\n";
#endif
      mGatedClk->transactionEnd();
  }

private:
  //! The name of the interface being observed
  std::string mInterfaceName;

  //! The parent gated clock to notify
  CarbonScGatedClock<BUSWIDTH>* mGatedClk;
}; // class CarbonScInterfaceObserver : public gs::socket::gp_observer_base

//! Carbon gated SystemC clock
/*! This class generates a SystemC clock which can be gated when the model is inactive.
 *
 *  The clocks are enabled at the start and whenever either the
 *  wakeup() or transactionStart() function are called. Use the former
 *  if the idle timer should start immediately after the transaction
 *  starts and use the latter if the idle timer should start after the
 *  transaction completes.
 *
 *  The idle timer starts counting down whenever the transaction count
 *  is 0 and the clocks are active. The idle timer counts down once
 *  per clock posedge. Once the idle timer is 0, it checks the model
 *  idle signal. If it is high the clock is disabled.
 */
template<unsigned int BUSWIDTH>
class CarbonScGatedClock : public sc_core::sc_module
{
public:
  //! State for this clock generator
  enum State {
    eIdle,
    eActive,
    eStartup,
    eShutdown
  };

  //! Gated Output Clock
  sc_out<bool> clk_out;

  //! Idle input for the model to indicate its not doing work clocks can be turned off.
  sc_in<bool> model_idle;

  //! Constructor
  SC_HAS_PROCESS(CarbonScGatedClock);
  CarbonScGatedClock(sc_core::sc_module_name c,
                     int idle_timeout,
                     sc_core::sc_time start_phase,
                     sc_core::sc_time clock_period) :
    sc_module(c),
    mState(eStartup),
    mTimer(idle_timeout),
    mMaxTimer(idle_timeout),
    mStartPhase(start_phase),
    mClockPeriod(clock_period),
    mClockState(false),
    mTransactionCount(0)
  {
    // The clock method is handling its own triggers, so no sensitivity needed here
    SC_METHOD(clockMethod);

    SC_METHOD(activityTimer);
    sensitive << clk_out.pos();
    dont_initialize();
  }

  //! Public Method to indicate that the model needs to wake up
  void wakeup()
  {
    // We got triggered for some reason, so set the activity timer and (if needed) change state and
    // notify clockMethod to start driving the clocks. Once the clocks are running the
    // activityTimer method will count down the timer until it reaches 0. At that point if
    // the model still indicates its idle, clocks will be turned off again.
    if ((mState != eActive) && (mState != eStartup)) {
      // skip these if we are already running
      mState = eStartup;
      mWakeupEvent.notify();
    }
    mTimer = mMaxTimer;
  }

  //! Public method to indicate that the model had a transaction start event
  void transactionStart()
  {
    // Wake up if we haven't already
    wakeup();

    // Also increment the active transaction count. We don't start
    // checking for idle until the transaction count is 0. Use
    // transactionEnd() to indicate the end.
    ++mTransactionCount;
  }

  //! Public method to indicate that a model had a transaction complete event
  void transactionEnd()
  {
    // Indicate that we hit a transaction end. This will cause the
    // timer to start counting down. This must be paried with a
    // transactionStart() call.
    assert(mTransactionCount > 0);
    --mTransactionCount;
  }

  //! SC Method driving the clock
  void clockMethod()
  {
    switch(mState) {
    case eStartup:
      // We know that we stopped the clock low, so the next active state will drive the clock high.
      mState = eActive;

      // Trigger again after the startup phase
      next_trigger(mStartPhase);
#ifdef CARBON_CLOCK_DEBUG
      std::cout << name() << ": " << sc_time_stamp() << ": Starting up clocks in " << mStartPhase << endl;
#endif
      break;
    case eActive:
      // Toggle the clock
      mClockState = !mClockState;
      clk_out.write(mClockState);

      // Trigger again half clock period later
      next_trigger(mClockPeriod/2);
      break;
    case eShutdown:
      // Shutdown clock cleanly when its low.
      if (mClockState) {
        // Toggle the clock
	mClockState = !mClockState;
        clk_out.write(mClockState);

        // Trigger again half clock period later
        next_trigger(mClockPeriod/2);
      }
      else {
#ifdef CARBON_CLOCK_DEBUG
	std::cout << name() << ": " << sc_time_stamp() << ": Clocks shut down.\n" << endl;
#endif
        mState = eIdle;
        next_trigger(mWakeupEvent);
      }
      break;
    case eIdle:
      // We shouldn't be triggered when state is Idle, but in case we are...
      next_trigger(mWakeupEvent);
      break;
    }
  }

  //! Activity timer sc method, triggered by gated_clk
  void activityTimer()
  {
    // If there are active transsactions there is nothing to do;
    if (mTransactionCount > 0) {
      return;
    }

    // Decrement Activity timer until it reaches 0.
    if (mTimer) --mTimer;

    // If Activity Timer is 0 and core indicates that its idle, turn off the clocks.
    if (mTimer == 0 && model_idle.read()) {
#ifdef CARBON_CLOCK_DEBUG
      std::cout << name() << ": " << sc_time_stamp() << ": Idle Timer timed out: Shutting down clocks.\n";
#endif
      mState = eShutdown;
    }
  }

 private:
  // Clock generator state
  State mState;

  // Cycle Timer for checking if chip is waking up before timeout occurs
  int mTimer;

  // Number of cycles to drive the clock before going back to idle
  // If idle input still indicates so.
  int mMaxTimer;

  // Start phase of the clock when waking up. The phase is measured from current
  // Simulation time.
  sc_time mStartPhase;

  // Clock period of generated clock
  sc_time mClockPeriod;

  // Event for waking up the clock due to outside activity
  sc_event mWakeupEvent;

  //! The current value of the clock
  bool mClockState;

  //! Counts the number of active transactions
  int mTransactionCount;
};

#endif // _CARBON_SCTLMTYPES_H_
