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
#ifndef __carbon_system_h_
#define __carbon_system_h_

/*!
  \file
  File containing the API for the ARM CycleModels System which includes functions to manage multiple ARM CycleModels Models in a system simulation and communicate with the ARM Cycle Model Studio GUI.
*/

#ifndef __carbon_shelltypes_h_
#include "carbon/carbon_shelltypes.h"
#endif

/*!
  \defgroup CarbonSystem ARM Cycle Model System Functions
*/

/*!
  \addtogroup CarbonSystem
  \brief The following are the ARM Cycle Model System functions.
  @{
*/


#ifdef __cplusplus
#define STRUCT class
extern "C" {
#else
/*!
  \brief Macro to allow both C and C++ compilers to use this include file in
  a type-safe manner.
  \hideinitializer
*/
#define STRUCT struct
#endif

  /*!
    \brief ARM Cycle Model System reference structure

    The CarbonSys provides the context for managing a number of ARM CycleModels
    components in a system.
  */
  typedef STRUCT CarbonSystemSim CarbonSys;

  /*!
    \brief ARM CycleModels Component handle

    The CarbonComp provides the context for managing a ARM CycleModels
    component in a ARM Cycle Model System.
  */
  typedef STRUCT CarbonSystemComponent CarbonSC;

  /*!
    \brief ARM CycleModels Component iterator
   */
  typedef STRUCT CarbonSystemComponentIter CarbonSCIter;

  /*!
    \brief Cycle-count callback handle

    In order to annotate cycles-per-second estimates in ARM Cycle
    Model Studio, the integrator of the CarbonSys must supply a
    callback to get the current cycle-count.  If this is not supplied,
    then speed must be estimated on the basis of schedule-calls.
  */
  typedef CarbonUInt64 (*CarbonSystemCycleCountFn)(void *clientData);

  /*!
    \brief Sim-time callback handle

    In order to annotate simulation-time progress in ARM Cycle Model
    Studio, the integrator of the CarbonSys must supply a callback
    to get the current simulation time.  If this is not supplied,
    then speed must be estimated on the basis of schedule-calls.
  */
  typedef double (*CarbonSystemSimTimeFn)(void *clientData);

  /*!
    \brief Gets the current system

    For components that are somewhat indepdendent of each other, this
    function gets a shared ARM Cycle Model System that can be used to manage
    the system simulation.

    \returns The ARM Cycle Model System handle.

  */
  CarbonSys* carbonGetSystem(int* firstCall);

  /*!
    \brief Sets the system name

    The system name should be the same for all participating
    components.

    \param sys The ARM Cycle Model System handle
    \param name The name to give to the system
   */
  void carbonSystemPutName(CarbonSys* sys, const char* name);

  /*!
    \brief Adds a new component to the ARM Cycle Model System

    \param sys The ARM Cycle Model System handle
    \param componentName A unique name for the new system component
    \param modelPtr A pointer to the ARM CycleModels Model for the new
    component. The variable representing *modelPtr must be the same as
    the one that will be passed to carbonDestroy(). This extra
    pointer reference is needed to detect if carbonDestroy() was called
    on the CarbonObjectID.
    \returns A handle to the ARM Cycle Model System component

  */
  CarbonSC* carbonSystemAddComponent(CarbonSys* sys, const char* componentName,
                                     CarbonObjectID** modelPtr);

  /*!
    \brief Looks up a component by its component name

    \param sys The ARM Cycle Model System handle

    \param componentName The unique component name specified in
    carbonSystemAddComponent().

    \returns A handle to the ARM Cycle Model System component or NULL
   */
  CarbonSC* carbonSystemFindComponent(CarbonSys* sys, const char* componentName);

  /*!
    \brief Returns an iterator to visit all the components in the system.

    Use the function carbonSystemComponentNext() to retrieve the
    components in a loop. Once complete, free the iterator memory with
    carbonSystemFreeComponentIter().

    \param sys The ARM Cycle Model System handle

    \returns A handle to a component iterator.
   */
  CarbonSCIter* carbonSystemLoopComponents(CarbonSys* sys);

  /*!
    \brief Returns the current component in a loop and moves to the next one

    \param iter The iterator returned by carbonSystemLoopComponents().

    \returns The CarbonSC* or NULL if we are at the end of the components.
   */
  CarbonSC* carbonSystemComponentNext(CarbonSCIter* iter);

  /*!
    \brief Frees the component iterator created by carbonSystemLoopComponents().

    \param iter The iterator returned by carbonSystemLoopComponents().
   */
  void carbonSystemFreeComponentIter(CarbonSCIter* iter);

  /*!
    \brief Updates the runtime GUI data file associated with this system.

    The ARM Cycle Model System file is created by the simulation running
    system.  When running multiple ARM CycleModels Models with ARM Cycle Model
    Studio, the GUI polls the ARM CycleModels system file to display the correct
    information.  This function should be called periodically by the
    simulation to update the file.

    Calling this function too often can slow the simulation. It is
    best to call it infrequently either by number of carbonSchedule()
    calls or when the simulation status changes (running vs debugging,
    for example).

    \param sys The ARM CycleModels system handle
   */
  void carbonSystemUpdateGUI(CarbonSys* sys);

  /*!
    \brief Gets the number of components.

    This is useful in determining if a new component is the first
    component.

    \param sys The ARM CycleModels system handle
    \returns The current number of components in the system.
   */
  int carbonSystemNumComponents(CarbonSys* sys);

  /*
    \brief DEPRECATED
   */
  static INLINE
  int carbonSystemNumReplayableComponents(CarbonSys* sys) DEPRECATED;
  static INLINE
  int carbonSystemNumReplayableComponents(CarbonSys* sys UNUSED) { return 0; }

  /*!
    \brief Notifies the ARM CycleModels system that it should re-read data from the
    ARM Cycle Model Studio GUI

    A system simulation should call this routine periodically to cause
    the system to update data from ARM Cycle Model Studio. The best time
    to do this is when the simulation status changes.

    This function is faster if the onlyIfChanged parameter is set to
    1. In that case the system only reads the command line if the file
    has changed since the last read.

    If the eCarbonCmdError is returned, use carbonSystemGetErrmsg() to
    get an error message string.

    \param sys The ARM CycleModels system handle
    \param onlyIfChanged Set if the file status should be checked
    \returns one of eCarbonChanged, eCarbonUnchanged, or
    eCarbonCmdError.
   */
  CarbonSystemReadCmdlineStatus carbonSystemReadFromGUI(CarbonSys* sys,
                                                        int onlyIfChanged);

  /*!
    \brief Gets an error message string associated with the last failed API call.

    \param sys The ARM CycleModels system handle
    \returns An error message string.
   */
  const char* carbonSystemGetErrmsg(CarbonSys* sys);

  /*
    \brief DEPRECATED
  */
  static INLINE
  void carbonSystemSetVerboseReplay(CarbonSys* sys, int verbose) DEPRECATED;
  static INLINE
  void carbonSystemSetVerboseReplay(CarbonSys* sys UNUSED, int verbose UNUSED) {
    /* nothing */
  }

  /*
    \brief DEPRECATED
   */
  static INLINE
  int carbonSystemComponentReplayable(CarbonSC* comp) DEPRECATED;
  static INLINE
  int carbonSystemComponentReplayable(CarbonSC* comp UNUSED) { return 0; }

  /*!
    \brief Returns the ARM CycleModels Model associated with a given component

    \param comp The ARM CycleModels design component returned by either
    carbonSystemAddComponent(), carbonSystemFindComponent(), or
    carbonSystemComponentNext().

    \returns A pointer to the ARM CycleModels Model, or NULL if it was already destroyed.

   */
  CarbonObjectID* carbonSystemComponentGetModel(CarbonSC* comp);

  /*!
    \brief Returns the registered name for this component

    \param comp The ARM CycleModels design component returned by either
    carbonSystemAddComponent(), carbonSystemFindComponent(), or
    carbonSystemComponentNext().

    \returns A string name for this component

   */
  const char* carbonSystemComponentGetName(CarbonSC* comp);

  /*!
    \brief Returns the user data provided when adding the component

    \param comp The ARM CycleModels design component returned by either
    carbonSystemAddComponent(), carbonSystemFindComponent(), or
    carbonSystemComponentNext().

    \returns The user data
   */
  void* carbonSystemComponentGetUserData(CarbonSC* comp);

  /*!
    \brief Stores the user data provided in the component structure

    The field is initialized with NULL at construction. This function
    overwrites the existing value whether it is NULL (uninitialized)
    or contains a value from a previous call to this function.

    Use the carbonSystemComponentGetUserData() to retreive the data.

    \param comp The ARM CycleModels design component returned by either
    carbonSystemAddComponent(), carbonSystemFindComponent(), or
    carbonSystemComponentNext().

    \param userData The user data to store
   */
  void carbonSystemComponentPutUserData(CarbonSC* comp, void* userData);

  /*!
    \brief Tells ARM Cycle Model Studio that the system simulation has shut down

    Calling this function when the simulation has shut down updates the
    status line of ARM Cycle Model Studio.

    \param sys The ARM CycleModels system handle
  */
  void carbonSystemShutdown(CarbonSys* sys);

  /*!
    \brief Establish a callback to tell ARM Cycle Model Studio how many cycles
    have been run so far.

    \param sys The ARM CycleModels system handle
    \param fn Function to call to get the current number of cycles
    \param clientData Context to pass to fn
  */
  void carbonSystemPutCycleCountCB(CarbonSys* sys,
                                   CarbonSystemCycleCountFn fn,
                                   void *clientData);

  /*!
    \brief Remove the cycle-count callback

    When a simulation is being terminated, no more cycles will
    occur, so there is no need to call the callback anymore.  Note
    that we will still consider this a "cycle-counted" simulation,
    and not a "schedule-call-counted" simulation.

    It is necessary to do this to avoid calling the callback using data
    that is no longer valid memory.

    \param sys The ARM CycleModels system handle
  */
  void carbonSystemClearCycleCountCB(CarbonSys* sys);

  /*!
    \brief Establish a callback to tell ARM Cycle Model Studio how much
    simulation time has been run so far.

    \param sys The ARM CycleModels system handle
    \param fn Function to call to get the current simulation time
    \param clientData Context to pass to fn
  */
  void carbonSystemPutSimTimeCB(CarbonSys* sys,
                                CarbonSystemSimTimeFn fn,
                                void *clientData);

  /*!
    \brief Remove the sim-time callback

      When a simulation is being terminated, no more simulation time will
      occur, so there is no need to call the callback anymore.

      It is necessary to do this to avoid calling the callback using data
      that is no longer valid memory.

    \param sys The ARM CycleModels system handle
  */
  void carbonSystemClearSimTimeCB(CarbonSys* sys);

  /*!
    \brief Establish a callback to tell ARM Cycle Model Studio the simulation
    time units.

    \param rss The ARM CycleModels system handle
    \param units The simulation time units to display (e.g. "ps")

    \sa carbonSystemPutSimTimeCB
  */
  void carbonSystemPutSimTimeUnits(CarbonSys* rss, const char* units);

  /*!
    \brief Checks whether the system has been shut down

    The system can be shut down expliticly with the
    carbonSystemShutdown function.  This function returns the current
    status of the system.

    If the system has been created, but no updates to it have occurred,
    it is considered to be shut down.

    \param comp The ARM CycleModels system handle
    \retval 1 if the system is shut down
    \retval 0 if the system is not shut down
   */
  int carbonSystemIsShutdown(CarbonSys* sys);

#ifdef __cplusplus
}
#endif

/*! @} */

  /*!
    \defgroup CarbonObsolete Obsolete Functions
  */

  /*!
    \addtogroup CarbonObsolete
    \brief The following obsolete functions are DEPRECATED beginning with v8.3.0.
    @{

    \li carbonSystemComponentReplayable
    \li carbonSystemNumReplayableComponents
    \li carbonSystemSetVerboseReplay

    @} */

#endif

