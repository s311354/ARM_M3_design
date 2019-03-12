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
#ifndef __carbon_capi_h_
#define __carbon_capi_h_

/*!
  \file
  File containing the API for the ARM Cycle Models model.
*/

#ifdef __cplusplus
extern "C" {
#endif

#ifndef __carbon_shelltypes_h_
#include "carbon/carbon_shelltypes.h"
#endif

  /*!
    \defgroup CarbonAdmin Administrative Functions
  */

  /*!
    \addtogroup CarbonAdmin
    \brief The following are administrative functions.
    @{
  */

  /*!
    \brief Get the version of the ARM CycleModels C api.
    \returns The version string of the ARM CycleModels C api.
  */
  const char* carbonGetVersion();

  /*!
    \brief Sets the directory to search for shell files.

    Shell files are output by \c cbuild and used by the ARM CycleModels shell.
    Currently, the only shell files that exist are the database files,
    libdesign.symtab.db and libdesign.io.db. By default, the current
    working directory is searched; this function overrides this default.

    \verbatim
    On Unix:
      carbonSetFilePath("/myhome/ARM_CM:/usr/tools/ARM_CM");
      CarbonObjectID* object = carbon_design_create(eCarbonIODB, eCarbon_NoFlags);
    On Windows:
      carbonSetFilePath("\\myhome\\ARM_CM;\\usr\\tools\\ARM_CM");
      CarbonObjectID* object = carbon_design_create(eCarbonIODB, eCarbon_NoFlags);

    *OR*

      carbonSetFilePath("/myhome/ARM_CM;/usr/tools/ARM_CM");
      CarbonObjectID* object = carbon_design_create(eCarbonIODB, eCarbon_NoFlags);
    \endverbatim

    Both forward and backslashed directories are supported on
    Windows. However, the ';' is necessary on Windows in order to
    recognize drive letters, e.g., 'C:\\myhome\\ARM_CM'

    This function will be effective only if it is called prior to the
    carbon_\<design\>_create function.

    \param dirList String representing a directory path(s) to search for
    ARM CycleModels shell files. This can be in list format where each directory
    is separated by a colon (:) with no whitespace on unix. For
    windows applications, each directory is separated by a semicolon
    (;) with no whitespace.. The total size of the string cannot
    exceed 2047 characters.

    \retval eCarbon_ERROR If dirList is too long.
  */
  CarbonStatus carbonSetFilePath(const char* dirList);

  /*!
    \brief Initiates the ARM Cycle Models model license queuing.

    By default, license checkout is immediate when the object is created.
    If no licenses are available, the checkout fails and the process exits.
    Call this function \e before carbon_\<design\>_create to initiate license
    queuing--the process will wait for the next available license and then
    run. This affects all checkouts within the same process.
  */
  void carbonLicenseWait();

  /*!
    \brief Initializes the ARM Cycle Models model.

    This function runs the initialization sequence for the model, which
    includes running the HDL initial logic.

    This routine may only be called if the eCarbon_NoInit flag was passed
    to the carbon_\<design\>_create function. It may be called only once
    to initialize the model. If any case conditions are not met, the
    routine returns a failure status.

    In general, use the simpler methodology of allowing carbon_\<design\>_create
    to run the model initialization. This more complex methodology is
    available if:

    \li work needs to be done between the construction and initialization
    of the model, or
    \li data needs to be passed to the model (currently only to C models).

    \param context A valid object ID.
    \param cmodelData Data to be passed to all C models in the design.
    \param reserved1 Reserved for future use.
    \param reserved2 Reserved for future use.
  */
  CarbonStatus carbonInitialize(CarbonObjectID* context,
				void* cmodelData,
				void* reserved1,
				void* reserved2);

  /*!
    \brief Destroys the ARM Cycle Models model.

    This function flushes any waveforms and profiling information,
    frees up memory used by ARM CycleModels structures, and invalidates the
    object.

    \param contextPtr Pointer to the ARM Cycle Models model. The pointer will be
    NULL after this function is called.
  */
  void carbonDestroy(CarbonObjectID** contextPtr);

  /*!
    \brief Use this function to change the severity of the specified message.

    The ARM CycleModels severity levels are (from most severe to least severe):

    \li eCarbonMsgFatal
    \li eCarbonMsgError
    \li eCarbonMsgAlert
    \li eCarbonMsgWarning
    \li eCarbonMsgNote
    \li eCarbonMsgStatus
    \li eCarbonMsgSuppress

    See the ARM CycleModels Compiler Directives chapter in the <em>ARM Cycle Model Compiler User Manual</em> for a
    description of these levels.

    You can increase the severity of any message. You can decrease the
    severity of any message except those messages at the Fatal or Error level.

    To suppress a message, pass in eCarbonMsgSuppress as the severity.
    Note that fatal messages cannot be changed or suppressed.

    \warning If you increase the severity of a message to Fatal or Error,
    it cannot be decreased on a subsequent call.

    \param context A valid object ID or NULL. Either will change the
    message severity for all contexts.
    \param msgNumber The number of the message to change. When a message is
    printed, \a msgNumber is listed immediately after the severity keyword.
    For example 1234 is the \a msgNumber in the message: <tt>design.v:20: Error 1234:</tt>.
    \param severity The new severity level.
    \retval eCarbon_OK If the change was successful.
    \retval eCarbon_ERROR If the message number doesn't exist, or if
    the requested change was invalid (for example attempting to suppress a
    fatal message).
  */
  CarbonStatus carbonChangeMsgSeverity(CarbonObjectID* context,
                                       CarbonUInt32 msgNumber,
                                       CarbonMsgSeverity severity);

  /*!
    \brief Registers a function to be called whenever message is output
    by the model.

    The provided function must return one of eCarbonMsgStop or eCarbonMsgContinue.
    If eCarbonMsgContinue is returned, the next registered function is
    called with the message. If eCarbonMsgStop is returned, then no more message
    callbacks are invoked for the message (including the default system handler).

    Functions are called in reverse order of registration (last registered,
    first called).  This enables registration of a temporary handler (removed
    by calling carbonRemoveMsgCB()).

    \param context A valid object ID, or NULL for global messages.
    \param cbFun The function to be called when a message is output by
           the model.
    \param userData This pointer will be passed to the callback function.
    \return Returns a pointer to ID that may be used to unregister the
    callback, or NULL if there is an error.
  */
  CarbonMsgCBDataID* carbonAddMsgCB(CarbonObjectID *context,
                                    CarbonMsgCB cbFun,
                                    CarbonClientData userData);

  /*!
    \brief Unregisters a message callback function previously registered
    via carbonAddMsgCB.

    \param context A valid object ID.
    \param cbDataPtr Address of the value returned by carbonAddMsgCB().
  */
  void carbonRemoveMsgCB(CarbonObjectID *context, CarbonMsgCBDataID **cbDataPtr);

  /*! @} */

  /*!
    \defgroup CarbonCtrl Control Functions
  */

  /*!
    \addtogroup CarbonCtrl
    \brief The following functions can be used for general object control.
    @{
  */

  /*!
    \brief Saves the state of the current simulation to a checkpoint file.

    This function saves the current state of the run to the specified
    file. All of the underlying values of the nets and the current
    time are saved. The state of waveforms is \e not saved.

    \param context A valid object ID.
    \param filename Name of the file in which to save the state.
    \retval eCarbon_OK If the operation was successful.
    \sa carbonRestore, carbonStreamSave, carbonCheckpointWrite, carbonAdminAddControlCB
  */
  CarbonStatus carbonSave(CarbonObjectID * context, const char * filename);

  /*!
    \brief Restores a previously saved checkpoint of the simulation.

    This function restores the saved state from the specified
    checkpoint file that was created using carbonSave. All the
    design values and the time will be restored. The waveform dump
    is \e not restored.

    Since the waveform dump is not restored, the waveform will not
    update until the simulation time passes the time at which
    carbonRestore was issued. For example, if you are 100 time units
    into the simulation and call carbonSchedule, the current
    waveform time is 100. If you issue a carbonRestore that changes
    the time to 50, the waveform will not update until the simulation
    time is past 100.

    \param context A valid object ID.
    \param filename Name of the file from which to retrieve the state.
    \retval eCarbon_ERROR If the specified file cannot be found.
    \sa carbonSave, carbonStreamRestore, carbonCheckpointRead, carbonAdminAddControlCB
  */
  CarbonStatus carbonRestore(CarbonObjectID * context, const char * filename);

  /*!
    \brief Saves the state of the current simulation to a stream.

    This function saves the current state of the run to the specified
    stream. This is useful for SoC Designer and SystemC wrappers
    because additional data, in addition to the simulation, may be in
    the stream. All of the underlying values of the nets and the
    current time are saved. The state of waveforms is \e not saved.

    \param context A valid object ID.
    \param writeFunc A function to call to write data to the stream.
    \param userData A pointer to data that will be passed to the streamFunc function on each write.
    \param streamName Can be NULL, this is the name of the stream to use when reporting errors.
    \retval eCarbon_OK If the operation was successful.
    \sa carbonSave, carbonRestore, carbonStreamRestore, carbonCheckpointWrite, carbonAdminAddControlCB
  */
  CarbonStatus carbonStreamSave(CarbonObjectID * context,
                                CarbonStreamWriteFunc writeFunc,
                                void * userData, const char * streamName);

  /*!
    \brief Restores a previously saved checkpoint of the simulation from a stream.

    This function restores the saved state from the specified
    checkpoint stream that was created using carbonStreamSave.
    All the design values and the time will be restored. The
    waveform dump is \e not restored.

    \param context A valid object ID.
    \param readFunc A function to call to read data from the stream.
    \param userData A pointer to data that will be passed to the streamFunc function on each read.
    \param streamName Can be NULL, this is the name of the stream to use when reporting errors.
    \retval eCarbon_ERROR if the operation is not successful.
    \sa carbonSave, carbonRestore, carbonStreamSave, carbonCheckpointRead, carbonAdminAddControlCB
  */
  CarbonStatus carbonStreamRestore(CarbonObjectID * context,
                                   CarbonStreamReadFunc readFunc,
                                   void * userData, const char * streamName);

  /*!
    \brief Writes data to the checkpoint file being generated by a carbonSave.

    This function is used by callbacks and C-Models to save their data in
    the same checkpoint file used by the model.

    \note This function may only be called while a carbonSave is in
    progress.

    \param context A valid object ID.
    \param data A pointer to the data to be written.
    \param numBytes The number of bytes of data to write to the checkpoint file.
    \retval eCarbon_ERROR If the parameters are invalid or there is an error writing to the file.
    \sa carbonCheckpointRead, carbonSave, carbonRestore, carbonAdminAddControlCB
  */
  CarbonStatus carbonCheckpointWrite(CarbonObjectID * context,
                                     const void * data, CarbonUInt32 numBytes);

  /*!
    \brief Reads data from the checkpoint file being restored by a carbonRestore.

    This function is used by callbacks and C-Models to read their data from
    the checkpoint file used by the model.

    \note The number of bytes read must be the same as the number of
    bytes that were written by calling carbonCheckpointWrite when the
    checkpoint file was created.

    \note This function may only be called while a carbonRestore is in
    progress.

    \param context A valid object ID.
    \param data A pointer to a buffer large enough to hold the requested number of bytes.
    \param numBytes The number of bytes of data to read from the checkpoint file.
    \retval eCarbon_ERROR If the parameters are invalid or there is an error reading from the file.
    \sa carbonCheckpointWrite, carbonSave, carbonRestore, carbonAdminAddControlCB
  */
  CarbonStatus carbonCheckpointRead(CarbonObjectID * context,
                                    void * data, CarbonUInt32 numBytes);

  /*!
    \brief Adds a net change callback to the scheduling mechanism.

    This function registers a callback that will be executed whenever the
    specified net changes after a schedule run. The new value is
    passed into the callback function. The value that is passed in is
    valid until the end of the function call. If you modify the value
    it will have no effect on the actual net in the design.

    \note The order in which callbacks are executed is not
    guaranteed. In other words, callbacks are not called in the order
    they are added.

    \param context A valid object ID.
    \param fn The function that is called whenever the specified net
    changes.
    \param userData User-supplied data that gets passed into the
    callback function.
    \param handle The valid ID of the net to monitor. Whenever the value
    changes, the callback function is executed.
    \retval NON-NULL A unique id for the call back structure.
    \retval NULL If an error occurs.
    \sa carbonDisableNetCB, carbonEnableNetCB
  */
  CarbonNetValueCBDataID* carbonAddNetValueChangeCB(CarbonObjectID* context,
                                                    CarbonNetValueCB fn,
                                                    CarbonClientData userData,
                                                    CarbonNetID* handle);


  /*!
    \brief Adds a net value/drive change callback to the scheduling mechanism.

    This function registers a callback that will be executed whenever
    the specified net value or drive changes after a schedule run. The
    new value and drive is passed into the callback function. The
    value and drive that are passed in are valid until the end of the
    function call. If you modify the value or drive it will have no
    effect on the actual net in the design.

    \note The order in which callbacks are executed is not
    guaranteed. In other words, callbacks are not called in the order
    they are added.

    \note If this net is driven both externally and internally it
    results in a drive conflict. This callback will have undefined
    behavior -- it may or may not register a change.

    \param context A valid object ID.
    \param fn The function that is called whenever the specified net
    changes.
    \param userData User-supplied data that gets passed into the
    callback function.
    \param handle The valid ID of the net to monitor. Whenever the value
    changes, the callback function is executed.
    \retval NON-NULL A unique id for the call back structure.
    \retval NULL If an error occurs.
    \sa carbonDisableNetCB, carbonEnableNetCB
  */
  CarbonNetValueCBDataID* carbonAddNetValueDriveChangeCB(CarbonObjectID* context,
                                                         CarbonNetValueCB fn,
                                                         CarbonClientData userData,
                                                         CarbonNetID* handle);
  /*!
    \brief Disables a net callback from the scheduling mechanism.

    This function unregisters a net callback. Once a callback is
    disabled, it will not be called again unless the callback is
    enabled and the value is different from the last time the callback
    was called.

    For example,

    \code
    CarbonUInt32 netVal;
    carbonExamine(hdl, net, &netVal, 0);
    if (netVal != 0)
      exit(1);

    CarbonNetValueChangeCB* cb = carbonAddNetValueChangeCB(hdl, myFn, NULL, net);

    netVal = 1;
    carbonDeposit(hdl, net, &netVal, 0);

    carbonSchedule(hdl, simTime);
    // myFn fired

    ++simTime;

    // disable the callback
    carbonDisableNetCB(hdl, cb);


    netVal = 0;
    carbonDeposit(hdl, net, &netVal, 0);
    carbonSchedule(hdl,simTime);
    // myFn does NOT fire, cb disabled

    ++simTime;

    // enable the callback
    carbonEnableNetCB(hdl, cb);

    netVal = 1;
    carbonDeposit(hdl, net, &netVal, 0);
    carbonSchedule(hdl, simTime);
    // myFn does NOT fire, the value is 1, the same as
    // it was when the callback fired last time.

    ++simTime;

    netVal = 0;
    carbonDeposit(hdl, net, &netVal, 0);
    carbonSchedule(hdl, simTime);
    // myFn fires. The value is now 0.

    \endcode

    \param context A valid object ID.
    \param cbData A valid CarbonNetValueCBDataID created by
    carbonAddNetValueChangeCB().

    \sa carbonAddNetValueChangeCB
  */
  void carbonDisableNetCB(CarbonObjectID* context,
                          CarbonNetValueCBDataID* cbData);

  /*!
    \brief Re-enables a net callback from the scheduling mechanism
    that was disabled using carbonDisableNetCB(). Note that the
    callback will not be called until the value is different than what
    it was when the callback was last called.

    \param context A valid object ID.
    \param cbData A valid CarbonNetValueCBDataID created by
    carbonAddNetValueChangeCB().

    \sa carbonAddNetValueChangeCB, carbonDisableNetCB
  */
  void carbonEnableNetCB(CarbonObjectID* context,
                         CarbonNetValueCBDataID* cbData);

  /*! \brief Adds a callback function for the specified model and
    control type ($stop, $finish, save, restore) combination.

      You may add one or more callback functions that trigger when
      $stop or $finish are run, or when the simulation is saved or
      restored by calling carbonSave or carbonRestore.

      The registered callback functions are called in the order in
      which they were registered.

      If a $stop or $finish statement is encountered with no
      user-defined callbacks, a default callback function is called.
      There is no default callback function for save or restore.

      \note ARM CycleModels does not check for duplicate registration of
      callbacks.  Registering a function more than once will result in
      multiple callbacks.

      \note Currently, only examine operations are supported during the execution
      of any callback function (carbonExamine(), carbonExamineMemory(), etc.).
      If you would like to perform a deposit operation, the callback can
      set a flag that can be examined once carbonSchedule() returns.

      The return from the last registered callback function associated
      with a $stop statement will cause carbonSchedule() to resume. With
      properly defined callbacks for $stop, execution will continue as if
      the $stop had not been encountered. However, if any of the callback
      functions executed a deposit operation, the operation after its
      return is undefined.

      The return from the last $finish callback function associated with
      a $finish statement will cause an immediate return from carbonSchedule().
      At that point, no additional calls to carbonSchedule() are allowed.

      \param carbonObject The ARM Cycle Models model that contains the $stop or $finish.
      \param fn A pointer to the callback function.
      \param userData User defined data that will be passed to the callback
      function when it is called.
      \param controlType The type of control operation for this registration
      ($stop, $finish, save, or restore).

      \return The ID for the registered function, this ID will be used
      for the un-registration of the callback function.
      \return NULL if there was an error.

      \sa carbonAdminRemoveControlCB
  */
  CarbonRegisteredControlCBDataID* carbonAdminAddControlCB(CarbonObjectID* carbonObject,
                                                           CarbonControlCBFunction fn,
                                                           CarbonClientData  userData,
                                                           CarbonControlType controlType);


  /*! Removes a previously registered control callback function (\a registeredID).

      \param carbonObject The ARM Cycle Models model used when the callback function was
      registered.
      \param registeredID Pointer to the ID for a registered function,
      previously returned by carbonAdminAddControlCB.

      \sa carbonAdminAddControlCB
  */
  void carbonAdminRemoveControlCB(CarbonObjectID* carbonObject,
                                  CarbonRegisteredControlCBDataID** registeredID);

  /*!
    \brief Schedules the model.

    This function runs the model's schedule and sets the time.

    \note For performance reasons, no checks are done on the
    ARM Cycle Models model passed in--it is assumed to be valid.

    \param context A valid object ID.
    \param time The time to which the specified model will be set. This
    should be monotonically increasing, although it is not checked
    explicitly. If you do not set this parameter, waveforms may skip time
    points.

    \retval eCarbon_OK If the execution of the schedule was successful.
    \retval eCarbon_STOP If the execution of the schedule was successful,
            and a $stop was encountered during this call.
    \retval eCarbon_FINISH If the execution of the schedule was successful,
            and a $finish was encountered during this call. Once this is
	    returned, any additional calls to carbonSchedule() will fail.
    \retval eCarbon_ERROR If an error was encountered during this call.
*/
  CarbonStatus carbonSchedule(CarbonObjectID* context, CarbonTime time);

  /*!
    \brief Get the total number of schedule calls made since the ARM Cycle Models model
    was created.

    \note If the ARM Cycle Models model is destroyed (carbonDestroy()) and then created
    again, the total number of schedule calls is reset to 0.

    Returns 0 if context is NULL.
  */
  CarbonUInt64 carbonGetTotalNumberOfScheduleCalls(CarbonObjectID* context);

  /*!
    \brief Get the current simulation time.

    This returns the time of the last carbonSchedule() call. This is
    \e not the same as carbonGetWaveTime(), which returns the last dump
    time.

    \param context A valid object ID.
    \returns The time of the last carbonSchedule() call.
  */
  CarbonTime carbonGetSimulationTime(CarbonObjectID* context);

  /*! @} */

  /*!
    \defgroup CarbonWave Wave Functions
  */

  /*!
    \addtogroup CarbonWave
    \brief The following functions may be used to generate signal waveforms.
    @{
  */

  /*!
    \brief Initializes the wave dumper to dump in standard Verilog VCD
    format.

    This function may be called only once--multiple waveform files for a
    single run is not currently supported.

    This function cannot be used in conjunction with carbonWaveInitFSDB()
    or carbonWaveInitFSDBAutoSwitch().

    \param context A valid object ID.
    \param fileName Name of file to which to dump the waveform.
    \param timescale User-specified timescale. This timescale is just
    the units given to the waveform dumper and can be applied to the
    data time points.
    \retval NON-NULL A unique ID for the waveform dump.
    \retval NULL If the operation failed.
  */
  CarbonWaveID* carbonWaveInitVCD(CarbonObjectID* context,
                                  const char* fileName,
                                  CarbonTimescale timescale);


  /*!
    \brief Initializes the wave dumper to dump in Debussy's FSDB format.

    This function may be called only once--multiple waveform files for a
    single run is not currently supported.

    By default, the fsdb writer uses file synchronization. If you
    encounter a runtime error or warning with fsdb writing indicating
    a problem with file syncing, set the Novas environment variable,
    FSDB_ENV_SYNC_CONTROL to 'off'. For example, in csh:
    setenv FSDB_ENV_SYNC_CONTROL off

    This function cannot be used in conjunction with carbonWaveInitVCD()
    or carbonWaveInitFSDBAutoSwitch().

    The dumping of FSDB waveforms is not supported in a multi-threaded
    environment.

    \param context A valid object ID.
    \param fileName Name of file to which to dump the waveform.
    \param timescale User-specified timescale. This timescale is just
    the units given to the waveform dumper and can be applied to the
    data time points.
    \retval NON-NULL A unique ID for the waveform dump.
    \retval NULL If the operation failed.
  */
  CarbonWaveID* carbonWaveInitFSDB(CarbonObjectID* context,
                                   const char* fileName,
                                   CarbonTimescale timescale);

  /*!
    \brief Initializes the wave dumper to dump in Debussy's FSDB
    format, and to automatically open a new FSDB dump file when a
    specified size limit has been reached.

    For long simulations, it may be necessary to stop writing waveform
    data to one file and open another to continue. When this function
    initiates, it opens an FSDB file \<string\>_0.fsdb. When the specified file
    limit is reached, this file will be closed and \<string\>_1.fsdb will be
    opened. This process will continue until the specified maximum number of
    files is reached, at which point the file index is returned to 0
    and \<string\>_0.fsdb is overwritten.

    This function may be called only once--multiple sets of waveform files
    for a single run is not currently supported.

    By default, the fsdb writer uses file synchronization. If you
    encounter a runtime error or warning with fsdb writing indicating
    a problem with file syncing, set the Novas environment variable,
    FSDB_ENV_SYNC_CONTROL to 'off'. For example, in csh:
    setenv FSDB_ENV_SYNC_CONTROL off

    This function cannot be used in conjunction with carbonWaveInitFSDB()
    or carbonWaveInitVCD().

    The dumping of FSDB waveforms is not supported in a multi-threaded
    environment.

    \param context A valid object ID.
    \param fileNamePrefix The waveforms will be dumped to files
    beginning with this string followed by _\<num\>.fsdb, where num is the
    current file index. Num begins at 0 and increases by one when an
    FSDB file reaches its megabyte limit. If the maximum number of
    files has been reached, the file index is reset to 0, and the file
    is overwritten.
    \param timescale User-specified timescale. This timescale is the
    units given to the waveform dumper and can be applied to the data
    time points.
    \param limitMegs The size limit in megabytes for an FSDB file.
    Once the limit is reached, the file index is increased, and a new
    file is opened. Must be at least 2. A specification of 0 or 1 will
    automatically be upgraded to 2 and a warning will be issued.
    \param maxFiles The maximum number of FSDB files to create during the
    simulation. If 0 then always increase the file index through
    the entire simulation, never overwritting a file. (Specify 0 if you
    do not want to overwrite any FSDB file created during the simulation.)
    If 2 or greater the  maximum number of files is allowed to be written.
    In this case, the file index is reset to 0 once the maximum number of
    files has been reached causing files to be overwritten. Setting this to
    1 is not permitted.

    \retval NON-NULL A unique ID for the waveform dump.
    \retval NULL If the operation failed.
  */
  CarbonWaveID* carbonWaveInitFSDBAutoSwitch(CarbonObjectID* context,
                                             const char* fileNamePrefix,
                                             CarbonTimescale timescale,
                                             unsigned int limitMegs,
                                             unsigned int maxFiles);

  /*!
    \brief Add user data to an FSDB waveform.

    carbonDumpVars() and carbonDumpVar() dump only design nets that
    can be found in the design compiled by the ARM CycleModels compiler. Use this function
    to incorporate data into the waveform and represent your environment
    more completely. This allows you to correlate the extraneous data in
    time with the ARM Cycle Models model. Unlike carbonDumpVars() and carbonDumpVar(),
    which cannot be called a second time once a carbonSchehdule() has been called,
    this function can be called at any time after the FSDB waveform has been
    initialized.

    Note that the lbitnum and rbitnum are used to calculate the number
    of elements of the data type that is specified. So for scalars,
    integers, and reals, lbitnum and rbitnum should be equal.

    For logic value arrays (01xz, etc.), CarbonLogicByteType is used
    to represent FSDB logic values. Therefore, create an array of
    CarbonLogicByteTypes and set the value of the logic array with
    CarbonBitType.

    For example:
    \code
    // 2 bit vector
    CarbonLogicByteType* vec2 = new CarbonLogicByteType[2];
    vec2[0] = eCARBON_BT_VCD_0;
    vec2[1] = eCARBON_BT_VCD_Z;
    // pass vec2 as the CarbonClientData for carbonAddUserData
    carbonAddUserData(waveContext,
                      eCARBON_VT_VCD_REG,
                      eCarbonVarDirectionImplicit,
                      eCARBON_DT_VERILOG_STANDARD,
                      1, 0,
                      vec2,
                      "myreg",
                      eCARBON_BYTES_PER_BIT_1B,
                      "top.data",
                      ".");

    // ...
    \endcode

    Example of an integer as user data:
    \code
    int myInt;
    carbonAddUserData(waveContext,
                      eCARBON_VT_VCD_INTEGER,
                      eCarbonVarDirectionImplicit,
                      eCARBON_DT_VERILOG_INTEGER,
                      0, 0, // msb and lsb are the same
                      &myInt,
                      "myInt",
                      eCARBON_BYTES_PER_BIT_4B,
                      "top.data",
                      ".");
    \endcode

    Example of a real number as user data:
    \code
    CarbonReal myDouble; // a 'double' is fine, too
    carbonAddUserData(waveContext,
                      eCARBON_VT_VCD_REAL,
                      eCarbonVarDirectionImplicit,
                      eCARBON_DT_VERILOG_REAL,
                      0, 0, // msb and lsb are the same
                      &myDouble,
                      "myDouble",
                      eCARBON_BYTES_PER_BIT_8B,
                      "top.data",
                      ".");
    \endcode

    The data wave ID should be freed with carbonFreeWaveUserData()
    if the data becomes invalid.

    \warning This function is valid only if carbonWaveInitFSDB() has
    been called. This function does not work with the VCD format.

    The dumping of FSDB waveforms is not supported in a multi-threaded
    environment.

    \param waveContext An initialized wave object.
    \param netType The variable type.
    \param direction Direction of the signal. If unknown use
    eCarbonVarDirectionImplicit.
    \param dataType The datatype used to represent the value.
    \param lbitnum The left side of the range of the vector. If a
    scalar, integer, or real lbitnum and rbitnum should be equal.
    \param rbitnum The right side of the range of the vector. If a
    scalar, integer, or real lbitnum and rbitnum should be equal.
    \param data The virtual address of the data to add to the
    waveform. If this function is called more than once with the same
    data but different hierarchical paths, the paths are aliased
    together. The data type and value representation must conform to
    FSDB data types. For example, if the data type is a logic data
    type, it must use CarbonBitType to represent the 0/1/x/z
    value. The CarbonBitType will be translated to the appropriate
    fsdb bit type.
    \param varName The name of the variable. This will be placed in
    the given scope name.
    \param bpb Bytes per bit represented by the datatype. You must
    correctly specify the bytes per bit of all datatypes including any
    non-portable datatypes (such as float, long, and any user-defined
    types).
    \param fullPathScopeName The full hierarchical path to scope that
    contains varName.
    \param scopeSeparator String representing the scope separator,
    used to parse fullPathScopeName.

    \returns A valid user data wave ID if successful, NULL if it
    is not. If this is an alias (the CarbonClientData was already
    passed in a previous call), this will return the same
    CarbonWaveUserID pointer.

    \sa carbonFreeWaveUserData()
*/
  CarbonWaveUserDataID*
  carbonAddUserData(CarbonWaveID* waveContext,
                    CarbonVarType netType,
                    CarbonVarDirection direction,
                    CarbonDataType dataType,
                    int lbitnum, int rbitnum,
                    CarbonClientData data,
                    const char* varName,
                    CarbonBytesPerBit bpb,
                    const char* fullPathScopeName,
                    const char* scopeSeparator);



  /*!
    \brief Mark a CarbonWaveUserDataID* as no longer needed.

    This will free the buffer that mirrors the value of the original
    data given in carbonAddUserData().

    \warning This invalidates the CarbonWaveUserID pointer for all
    aliases as well. Aliases share the same CarbonWaveUserDataID.

    The dumping of FSDB waveforms is not supported in a multi-threaded
    environment.

    \param dataIDPtr A pointer to a CarbonWaveUserDataID*. The
    de-referenced object (*dataIDPtr) will become NULL. No action is
    taken if dataIDPtr is NULL, or if *dataIDPtr is NULL.
  */
  void carbonFreeWaveUserData(CarbonWaveUserDataID** dataIDPtr);

  /*!
    \brief Mark a user data variable as changed.

    On the next carbonSchedule() call, the value will be propagated to
    the waveform file at the time the carbonSchedule() is called.

    \param dataID The user data that has changed. If this is NULL, no
    action is taken.
  */
  void carbonWaveUserDataChange(CarbonWaveUserDataID* dataID);

  /*!
    \brief Update the waveform at the current time.

    Normally, waveform updates happen automatically at the end of the
    carbonSchedule() call. However, if you are depositing to signals
    within net change callbacks, and want to see the updated
    value of that deposit and any combinational logic that it drives
    at the \e current time, then this function should be called prior
    to the next carbonSchedule() call. You should \e not call
    carbonSchedule() within a net change callback. This can cause
    undefined behavior.

    Ideally, this should only be called once before the next
    carbonSchedule() call to minimize the impact on waveform dumping
    performance.

    If carbonSchedule() has not yet been called or if dumping has been
    turned off with carbonDumpOff() this function has no effect.

    \note Deposits, in general, do not take effect until the next
    carbonSchedule() call. Depositing to a clock or async signal and
    calling this function prior to carbonSchedule() may result in
    inconsistent waveform data as compared to the actual ARM CycleModels
    Model.

    \param waveContext Waveform to update.

    \retval eCarbon_OK If the waveContext is valid.
    \retval eCarbon_ERROR If the waveContext is invalid.
   */
  CarbonStatus carbonWaveSchedule(CarbonWaveID* waveContext);


  /*!
    \brief Prefixes a hierarchical path to the net names in the waveform dump.

    This function places the specified path before all net names in the waveform
    dump. You do not need to add the path delimiter, it  will be added automatically.
    For example:

    \verbatim
    carbonPutPrefixHierarchy(waveObj, "top.mymodule", 0);
    \endverbatim

    will pre-pend all net names in the waveform with "top.mymodule".

    To replace the compiled design root with a different root, specify
    a non-zero value for 'replaceDesignRoot'.
    For example:

    \verbatim
    carbonPutPrefixHierarchy(waveObj, "top.mymodule", 1);
    \endverbatim

    will replace the name of the top level module with 'mymodule' in
    the waveform.

    \param waveContext A valid waveform ID.
    \param hierPath The path to pre-pend to net names.
    \param replaceDesignRoot If non-zero this will replace the
    compiled design root in the waveform dump with the last identifier
    specified in hierPath.
    \retval eCarbon_OK If the path is accepted.
    \retval eCarbon_ERROR If the specified path cannot be found, or if the
    specified waveform cannot be found.
  */
  CarbonStatus carbonPutPrefixHierarchy(CarbonWaveID* waveContext,
					const char* hierPath,
                                        int replaceDesignRoot);

  /*!
    \brief Dumps waveforms of scopes and/or nets recursively.

    This function dumps the values of \e all specified nets and/or all nets
    within the specified scopes that have changed. The dump executes on
    each call of carbonSchedule(). If a scope is specified and the depth
    is non zero, all nets encountered "depth" number of scopes downward
    in the design are dumped. This function essentially registers the
    list of nets and scopes to be monitored and dumped into a waveform file.

    \note To dump the full hierarchy of the design, call
    carbon_\<design\>_create with eCarbonFullDB. To dump primary i/os
    and signals specified in directives, call carbon_\<design\>_create
    with eCarbonIODB.

    \param waveContext A valid waveform ID.
    \param depth The number of levels to traverse downward beginning
    from each specified scope. If 0, all underlying scopes are traversed.
    \param listOfScopesNets A comma separated and/or space separated
    list of scopes and/or nets to dump into a waveform file. At least one
    scope or net \e must be specified.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If any specified scopes/nets cannot be found, or
    if the specified waveform cannot be found.
    \sa carbonDumpVar(), carbonDumpSizeLimit()
  */
  CarbonStatus carbonDumpVars(CarbonWaveID* waveContext, unsigned int depth,
                              const char* listOfScopesNets);


  /*!
    \brief Dumps a waveform for a single net.

    This function dumps the values of \e only the specified net.
    This function may be called multiple times prior to running the
    first schedule.

    \param waveContext A valid waveform ID.
    \param handle The valid net ID for which to dump a waveform.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid.

    \sa carbonDumpVars(), carbonDumpSizeLimit()
  */
  CarbonStatus carbonDumpVar(CarbonWaveID* waveContext,
                             CarbonNetID* handle);

  /*!
    \brief Dumps waveforms for states and primary I/Os recursively.

    This function dumps the values of all states and primary
    I/Os within the specified scopes that have changed. The dump
    executes on each call of carbonSchedule(). If a scope is specified
    and the depth is non zero, all nets encountered "depth" number
    of scopes downward are dumped. This function essentially registers
    the list of states and primary I/Os to be monitored and dumped into
    a waveform file.

    \note This function will traverse the hierarchy of the design only
    if one exists, i.e., you must specify the use of the \e full design
    database when compiling the ARM Cycle Models model. See \ref refstructures for more
    information.

    \param waveContext A valid waveform ID.
    \param depth The number of levels to traverse downward beginning
    from each specified scope. If 0, all underlying scopes are traversed.
    \param listOfScopesNets A comma separated and/or space separated list
    of scopes or nets to dump into a waveform file. At least one scope
    or net \e must be specified.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If any specified scopes/nets cannot be found, or
    if the specified waveform cannot be found.

    \sa carbonDumpSizeLimit()
  */
  CarbonStatus carbonDumpStateIO(CarbonWaveID* waveContext,
                                 unsigned int depth,
                                 const char* listOfScopesNets);

  /*!
    \brief Dumps the current waveforms of all registered nets.

    This function dumps \e all scopes and nets that were registered with
    carbonDumpVars(), not only those that have changed. The dump includes
    the current time and values for all nets. The dump takes effect on the
    next carbonSchedule() call.

    In order for this function to work, either carbonWaveInitVCD()
    or carbonWaveInitFSDB() and carbonDumpVars()
    functions must already have been called.

    \param waveContext A valid waveform ID.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If if the carbonDumpVars() function has not yet
    been called, or if the specified waveform cannot be found.
    \sa carbonDumpVars(), carbonDumpOff(), carbonDumpOn(), carbonDumpSizeLimit()
  */
  CarbonStatus carbonDumpAll(CarbonWaveID* waveContext);


  /*!
    \brief Sets all values to x and stops dumping.

    This function dumps \e all scopes and nets that were registered
    with carbonDumpVars(), at the current time with their values as 'x'.
    This takes effect on the next carbonSchedule() call. Any further calls
    to carbonDumpAll() will be ignored, and there will be no more value
    dumping on each call of carbonSchedule() until carbonDumpOn() is called.

    In order for this function to work, the carbonDumpVars() function must
    already have been called.

    \param waveContext A valid waveform ID.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the carbonDumpVars() function has not yet
    been called, or if the specified waveform cannot be found.
    \sa carbonDumpVars, carbonDumpOn
  */
  CarbonStatus carbonDumpOff(CarbonWaveID* waveContext);


  /*!
    \brief Sets all nets to their current values, and resumes dumping.

    This function dumps \e all scopes and nets that were registered
    with carbonDumpVars() at the current time with their current values.
    This takes effect on the next carbonSchedule() call, and each
    successive call will dump any changed values.

    In order for  this function to work, the carbonDumpVars() function
    must already have been called.

    \param waveContext A valid waveform ID.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the carbonDumpVars() function has not yet been
    called, or if the specified waveform cannot be found.
    \sa carbonDumpVars, carbonDumpOff
  */
  CarbonStatus carbonDumpOn(CarbonWaveID* waveContext);

  /*!
    \brief Flushes the waveform file's buffer.

    \param waveContext A valid waveform ID.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified waveform cannot be found.
  */
  CarbonStatus carbonDumpFlush(CarbonWaveID* waveContext);

  /*!
    \brief Limits dumping waveforms by signal size.

    This function speeds up the process of waveform dumping by
    limiting the set of signals that will be included in the
    dump. Only those signals with a bit size that does not exceed
    the specified limit will be dumped.

    The size of waveforms is calculated in bits. The size of scalars is
    considered 1. The size of arrays with \a n elements is considered \a n
    times the size of one element. The size of structures is considered the
    summation of the size of the individual items.

    Setting the \a signalSize limit to 0 has the special meaning that
    ALL signals will be dumped.

    \param waveContext A valid waveform ID.
    \param signalSize The signal size limit (in bits), default: 1024.

    \returns eCarbon_OK if successful, eCarbon_ERROR otherwise.

    \sa carbonDumpVars(), carbonDumpVar(), carbonDumpStateIO(), carbonDumpAll()
  */
  CarbonStatus carbonDumpSizeLimit(CarbonWaveID* waveContext,
                                   CarbonUInt32  signalSize);

  /*!
    \brief Gets the current waveform time (i.e., the last dump time).

    Note that the waveform time can be different than the actual model
    run time.

    \param waveContext A valid waveform ID.

    \returns The last dump time.
    \retval 0 If no dump has yet been performed.
  */
  CarbonTime carbonGetWaveTime(CarbonWaveID* waveContext);

  /*!
    \brief Closes the current FSDB file and opens a new one.

    This function closes an existing FSDB file and opens a new one
    using the file name provided. If the file was originally opened
    with carbonWaveInitFSDB then it uses the file name as is. If the
    file was originally opened with carbonWaveInitFSDBAutoSwitch then
    it updates the name prefix and sets the file index back to 0.

    Note that if there are any failures, a message will be printed and
    wave dumping will be disabled.

    \param waveContext A valid waveform ID.

    \param fileName the new file name or file prefix.

    \returns eCarbon_OK if successful, eCarbon_ERROR otherwise.
  */
  CarbonStatus carbonWaveSwitchFSDBFile(CarbonWaveID* waveContext,
                                        const char* fileName);

  /*!
    \brief Closes the waveform hierarchy--does not allow more nets to be
    added.

    This function allocates the needed structures to dump the nets
    that were added via carbonDumpVars() and carbonDumpVar(). This does
    \e not normally need to be called.

    \param context A valid waveform ID.
  */
  void carbonWaveHierarchyClose(CarbonWaveID* context);

  /*!
    \brief Closes the waveform file.

    Closes the waveform file previously created from a model.  The
    CarbonWaveID pointer is invalidated, along with any
    CarbonWaveUserDataID pointers created with
    carbonWaveAddUserData().  After this function is called, a new
    waveform file can be created.

    This function has no effect if the model does not have an active
    waveform file.

    \param context A valid object ID.
  */
  void carbonWaveClose(CarbonObjectID* context);

  /*! @} */


  /*!
    \defgroup CarbonNet Net Functions
  */

  /*!
    \addtogroup CarbonNet
    \brief The following functions may be used to manipulate nets.
    @{
  */

  /*!
    \brief Detects whether or not the specified net has a drive conflict.

    In the case of bidirects, if the external drive is set and the
    circuit is in such a state that it can also be driven internally,
    then there is a conflict. This function should be called after a
    carbonSchedule() is executed.

    \param context A valid object ID.
    \param net A valid net ID on which the drive conflict detection
    will take place
    \retval 1 if there is a drive conflict (more than 1 driver
    driving the net) on any bit of the net.
    \retval 0 if the net is not a bidirect or if there is no drive conflict.
    \retval -1 if an error occurred.
  */
  int carbonHasDriveConflict(CarbonObjectID* context,
                             CarbonNetID* net);

  /*!
    \brief Gets the pull mode of the specified net.

    A net can be pulled up, pulled down, or not pulled at all. The
    pull mode is a static property of a net. This function will not
    indicate if the net is actually being pulled currently, only if it
    has the capability of being pulled.

    \param context A valid object ID.
    \param net A valid net ID.
    \returns The pull mode of the net.
  */
  CarbonPullMode carbonGetPullMode(const CarbonObjectID* context,
                                   const CarbonNetID* net);

  /*!
    \brief Gets a reference structure for the specified net.

    \param context A valid object ID.
    \param netName Full HDL pathname of the net for which to get the
    reference. Escaped identifiers require an extra \\ at the beginning of
    the identifier and whitespace that is not a newline at the end of the
    identifier. For example, in C code, an identifier with one \ must be
    specified with a second slash: "\\reg1 ".
        In general, the netName may be:
    \li full vector - bit references and ranges are ignored. Note
    that if a vector bit reference or sub range is specified, the entire
    vector reference will get passed back. In the future, bit references
    and sub ranges \e may be supported.
    \li scalar
    \retval NON-NULL A unique handle for the named net.
    \retval NULL If the specified net name cannot be found.

  */
  CarbonNetID* carbonFindNet(CarbonObjectID* context, const char* netName);

  /*!
    \brief Gets the name of a net in the specified model.

    \param context A valid object ID.
    \param handle A valid net ID for which to get the name.
    \param buffer The buffer in which to place the name.
    \param len The length of the buffer.
    \returns The name of the net in the supplied buffer.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the buffer is not large enough for the
    name, or if the specified handle is invalid.
  */
  CarbonStatus carbonGetNetName(const CarbonObjectID* context,
                                const CarbonNetID* handle,
                                char* buffer, int len);

  /*!
    \brief Frees a CarbonNetID reference structure from the memory heap.

    Generally, this function is not required. However, it is useful if
    you need to conserve space for performance (swapping) issues, and
    the net ID is no longer needed.

    However, freeing a net handle does not necessarily mean that the
    net has been freed in memory. It decrements a reference
    count. Once that reference count becomes 0, the net is freed in
    memory.

    Freeing a net has no effect on value change callbacks. A value
    change callback keeps a reference to the net. Therefore, change
    callbacks will continue to work and a valid net handle will be
    passed into the callback routine.

    The net ID will be set to NULL after being freed. This is to avoid
    reuse of an ID. If you try to use the ID after
    it has been set to NULL, the model will exhibit unpredictable
    behavior. If the specified ID is already set to NULL, then this
    function has no effect.

    \param context A valid object ID.
    \param refPtr A pointer to the net handle.
    \retval eCarbon_OK If the non-null net reference was found, or if
    refPtr or *refPtr is null.
    \retval eCarbon_ERROR If the non-null reference was not found, or the
    specified net cannot be found.
    \sa carbonFindNet
  */
  CarbonStatus carbonFreeHandle(CarbonObjectID* context, CarbonNetID** refPtr);

  /*!
    \brief Checks if the specified net is a tristate.

    \param handle A valid net ID.
    \retval 1 If the net is a tristate or bidirect.
    \retval 0 If the net is not a tristate or bidirect if the specified handle is invalid.
  */
  int carbonIsTristate(CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is fully constant.

    This only returns 1 if the entire net is constant. If only part of
    the net is constant this returns 0.

    \param handle A valid net ID.
    \retval 1 If the net is fully constant
    \retval 0 If the net is not fully constant or if the specified handle is invalid.
  */
  int carbonIsConstant(CarbonNetID* handle);

  /*!
    \brief Returns the number of CarbonUInt32s needed to represent the value
    of the specified net.

    \param handle A valid net ID.
    \returns The number of CarbonUInt32s needed to represent the value.
    \retval 0 If the specified handle is invalid.
  */
  int carbonGetNumUInt32s(CarbonNetID* handle);

  /*!
    \brief Returns the number of CarbonUInt32s needed to represent
    the specified range.

    \param range_msb The most significant bit of the range.
    \param range_lsb The least significant bit of the range.
  */
  int carbonGetRangeNumUInt32s(int range_msb, int range_lsb);

  /*!
    \brief Gets the current value of a net.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param value The return value of the net; may be NULL. Must be
    large enough to contain the entire net's value.
    \param drive The drive value; may be NULL. If not NULL and the
    net is a tristate or a bidirect, it will have 1s set in the bit
    positions where the net is not being driven. If the net is a
    non-tristate, the drive value is set to 0. The drive must be
    of the same width as the value. If drive is not NULL and the net
    is being forced, the drive value will be 0 for each bit that is
    forced even if the model is not driving the net.

    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified value is not large enough,
    or if the specified handle is invalid.

    \sa carbonExamineWord(), carbonExamineRange()
 */
  CarbonStatus carbonExamine(CarbonObjectID* context, CarbonNetID* handle,
			     CarbonUInt32* value, CarbonUInt32* drive);

  /*!
    \brief Gets a net's value at the specified word index

    \param context A valid object ID.
    \param handle A valid net ID.
    \param value The return word value of the net; may be NULL. If
    this is NULL this parameter is ignored.
    \param index The index of the word for which to return a value.
    \param drive The drive value; may be NULL. If not NULL and the net is a
    tristate or a bidirect, it will have 1s set in the bit positions where
    the net is not being driven. If the net is a non-tristate, the drive
    value is set to 0. The drive must be of the same width as the
    value.If drive is not NULL and the net is being forced, the drive
    value will be 0 for each bit that is forced even if the model is not
    driving the net.


    \retval eCarbon_OK If the operation succeeded.
    \retval eCarbon_ERROR If the index is greater than or equal to
    carbonGetNumUInt32s(), or if the specified handle is not valid.
  */
  CarbonStatus carbonExamineWord(CarbonObjectID* context, CarbonNetID* handle,
				 CarbonUInt32* value, int index, CarbonUInt32* drive);

  /*!
    \brief Gets the current value of the specified bit range.

    This function returns a value for the specified net.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param value The return value of the net; may be NULL. Must be large
    enough to hold the number of bits in the specified bit range.
    \param range_msb The most significant bit in the range.
    \param range_lsb The least significant bit in the range.
    \param  drive The drive value; may be NULL. If not NULL and the net is
     a tristate or a bidirect, it will have 1s set in the bit positions where
     the net is not being driven. If the net is a non-tristate, the drive value
     is set to 0. The drive must be of the same width as the value. If
     drive is not NULL and the net is being forced, the drive will be 0
     for each bit in the range that is forced even if the model is not
     driving the net.

    \retval eCarbon_OK If the operation succeeded.
    \retval eCarbon_ERROR If the range is out of bounds, if the specified value
    or drive value is less than carbonGetRangeNumUInt32s() or if the
    specified handle is invalid.
  */
  CarbonStatus carbonExamineRange(CarbonObjectID* context, CarbonNetID* handle,
				  CarbonUInt32* value, int range_msb, int range_lsb,
				  CarbonUInt32* drive);

  /*!
    \brief Sets the net to be completely undriven externally.

    This function allows you to change a bidi from being externally
    driven, without having to change the value of the signal.

    This is equivalent to
    \code
    carbonDeposit(context, handle, NULL, allones)
    \endcode
    where 'allones' is an array of CarbonUInt32s large enough for the
    handle, and all the bits of each CarbonUInt32 are ones.

    To completely drive a bidi net externally without changing the
    value:
    \code
    carbonDeposit(context, handle, NULL, NULL);
    \endcode

    \param context A valid object ID.
    \param handle A valid net ID which is a tristate.
    \retval eCarbon_OK If the operation succeeded.
    \retval eCarbon_ERROR If the net is a primary input but not a tristate.
  */
  CarbonStatus carbonDeAssertXdrive(CarbonObjectID* context, CarbonNetID* handle);

  /*!
    \brief Resolves the value of the external drive of the given bidi

    After running carbonSchedule(), a bidirect signal may be driven
    internally, but the external drive may still be active. This could
    cause an invalid initialization of that signal on the next
    carbonSchedule() call. In some cases, this is indicative of a bus
    conflict, but in most cases it is simply a matter of an enable
    becoming active. In such a case the external drive should be
    de-asserted in relation to the internal drive. This function simply
    de asserts any external drive bits that are being driven internally.

    This function only works on tristated primary inputs, which
    includes bidirects. Other net types are ignored.

    \param context A valid object ID.
    \param handle A valid net ID that is a tristate.
    \retval eCarbon_OK If the operation succeeded.
    \retval eCarbon_ERROR If the operation failed.
  */
  CarbonStatus carbonResolveBidi(CarbonObjectID* context, CarbonNetID* handle);

  /*!
    \brief Get the external drive value of a net

    This returns the current value of the external drive of a bidirect
    signal as seen by the ARM Cycle Models model. This does not include
    external values from other sources. For example, if the model is
    connected to a tristate bus, along with other components that are
    not part of this ARM Cycle Models model, we will not know the contributions
    of those components. The caller is responsible for resolving all
    the drive contributions on a signal.

    If you want to resolve an external conflict on a signal in favor
    of the ARM Cycle Models model, call carbonResolveBidi().

    Note that by calling this along with carbonExamine you will have
    the value, the internal drive and the external drive of a net.

    \param context A valid object ID.
    \param handle A valid net ID
    \param xdrive The external drive value; may be NULL. If not NULL
    and the net is a bidirect, it will have ones set in the bit
    positions where the net is not being driven externally. If the net
    is not a bidirect, the drive value is set to all ones for
    non-inputs. Inputs that are not bidirects and constants
    will always be externally driven and therefore the xdrive will be
    all zeros. Tristates that are not bidirects will always have the
    external drive set to all ones, even after a deposit.

    \retval eCarbon_OK If the operation succeeded.
    \retval eCarbon_ERROR If the operation failed.
  */
  CarbonStatus carbonGetExternalDrive(CarbonObjectID* context, CarbonNetID* handle, CarbonUInt32* xdrive);

  /*!
    \brief Deposits the current value on a net.

    This deposits both a value and a drive fully onto a net. For
    bidirects and tristate inputs, this can be used to assert the
    external drive bits. For example, consider the following
    tristate situation:

    <center>
    \image html vm-deposit.gif
    </center>

    \image latex vm-deposit.eps

    \code
    deposit (context, handle, value, drive)
    \endcode
    where value = D_IN and drive = C_TB

    is the equivalent to:
    \code
    bufif (D, D_IN, C_TB)
    \endcode

    If you want to assert all the drive bits without changing the
    value of the net:
    \code
    carbonDeposit(context, handle, NULL, NULL);
    \endcode

    If you want to assert or de-assert some of the drive bits without
    changing the value of the net:
    \code
    carbonDeposit(context, handle, NULL, driveValue);
    \endcode
    The value of driveValue will be assigned to the external drive as
    is.

    If you want to de-assert all of the external drive bits, use
    carbonDeAssertXdrive(). You can also achieve this result by
    assigning a drive value of all ones to carbonDeposit.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param value The deposit value. This may be NULL, in which case,
    only the drive is used.
    \param drive The drive (Z or non-Z) of the value; may be NULL
    implying a drive value of 0.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid.
    \retval eCarbon_ERROR If the net is a non-tristate, primary input
    and the drive value is non-zero. A warning will also be issued.
    \sa carbonDepositWord(), carbonDepositRange(), carbonDeAssertXdrive()
  */
  CarbonStatus carbonDeposit(CarbonObjectID* context, CarbonNetID* handle,
			     const CarbonUInt32* value, const CarbonUInt32* drive);

  /*!
    \brief Deposits the current value on a net without doing any
    sanity checks.

    This deposits both a value and a drive fully onto a net. For
    bidirects and tristate inputs, this can be used to assert the
    external drive bits. No sanity checks are done on any of the
    parameters, and thus no messaging will occur in most cases. In
    cases where the CarbonNetID implementation could not be optimized
    some messages will appear. The status returned will always be
    eCarbon_OK.

    This is meant to be a drop-in replacement for carbonDeposit;
    however, there is one significant difference:
    - The value can never be NULL.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param value The deposit value. This can never be NULL. If NULL,
    function behavior is undefined.
    \param drive The drive (Z or non-Z) of the value; may be NULL
    \returns eCarbon_OK

    \sa carbonDeposit()
  */
  CarbonStatus carbonDepositFast(CarbonObjectID* context, CarbonNetID* handle, const CarbonUInt32* value, const CarbonUInt32* drive);


  /*!
    \brief Deposits a value on one word of a net.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param value The deposit value.
    \param index Word index into value array to modify.
    \param drive The drive (Z or non-Z) of the value; may be NULL
    implying a drive value of 0.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If index is greater than or equal to
    carbonGetNumUInt32s(), or if the specified handle is invalid.
    \retval eCarbon_ERROR If the net is a non-tristate, primary input
    and the drive value is non-zero. A warning will also be issued.
  */
  CarbonStatus carbonDepositWord(CarbonObjectID* context, CarbonNetID* handle,
				 CarbonUInt32 value, int index, CarbonUInt32 drive);

  /*!
    \brief Deposits a value on the specified range of a net.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param value The deposit value. Can be NULL.
    \param range_msb The most significant bit of the range.
    \param range_lsb The least significant bit of the range.
    \param drive The drive (Z or non-Z) of the value; may be NULL implying
    a drive value of 0.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the range is out of bounds, or if the
    specified handle is invalid.
    \retval eCarbon_ERROR If the net is a non-tristate, primary input
    and the drive is non-zero.
  */
  CarbonStatus carbonDepositRange(CarbonObjectID* context, CarbonNetID* handle,
				  const CarbonUInt32* value, int range_msb,
				  int range_lsb, const CarbonUInt32* drive);

  /*!
    \brief Forces a net to a specified value.

    This function will force the net to a given value, overriding the
    value from whatever logic is driving it. This function works only if
    the net was marked as forcible during model compilation. Once you
    force a net to a specific value, it will remain at that value until
    you explicitly release it using the carbonRelease() function. This is
    a useful function when you are trying to isolate a problem in the design,
    or testing a potential solution to a problem.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param value The value to force on the net. This must be non-NULL.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the value specified is not large enough,
    if the value is NULL, or if the specified handle is invalid.
    \sa carbonRelease, carbonForceWord(), carbonForceRange()
  */
  CarbonStatus carbonForce(CarbonObjectID* context, CarbonNetID* handle,
			   const CarbonUInt32* value);

  /*!
    \brief Forces one word of a net to a specified value.

    This function will force \e only one word of the specified net
    to the given value. This function works only if the net was marked
    as forcible during model compilation. Once you force a word to a
    specific value, it will remain at that value until you explicitly
    release it using the carbonReleaseWord() function.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param value The value to force on the net.
    \param index Word index into value array to modify.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If index is greater than or equal to
    carbonGetNumUInt32s(), or if the specified handle is invalid
    \sa carbonReleaseWord
  */
  CarbonStatus carbonForceWord(CarbonObjectID* context, CarbonNetID* handle,
			       CarbonUInt32 value, int index);

  /*!
    \brief Forces a bit range to a specified value.

    This function will force a value onto the specified range of a
    net. This function works only if the net was marked as forcible
    during model compilation. Once you force a range to a specific
    value, it will remain at that value until you explicitly release
    it using the carbonReleaseRange() function.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param value The value to force on the net. This must be non-NULL.
    \param range_msb The most significant bit of the range.
    \param range_lsb The least significant bit of the range.
    \retval eCarbon_OK The operation was successful.
    \retval eCarbon_ERROR If the range is out of bounds, if the specified
    value is not large enough, if the value is NULL, or if the specified handle is invalid.
    \sa carbonReleaseRange
  */
  CarbonStatus carbonForceRange(CarbonObjectID* context, CarbonNetID* handle,
                                const CarbonUInt32* value,
                                int range_msb, int range_lsb);



  /*!
    \brief Releases a net from a forced value.

    This function will release the entire net from the current value,
    whether it was fully forced or not. If the specified net was not
    forced to a value, this function has no real effect.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid
    \sa carbonForce
   */
  CarbonStatus carbonRelease(CarbonObjectID* context, CarbonNetID* handle);

  /*!
    \brief Releases a word of a net from a forced value.

    This function will release the entire word of the net, whether the
    word is fully forced or not. If the specified word was not forced to
    a value, this function has no real effect.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param index Word index of value array to release.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid.
    \sa carbonForceWord
   */
  CarbonStatus carbonReleaseWord(CarbonObjectID* context, CarbonNetID* handle,
                                 int index);

  /*!
    \brief Releases a bit range from a forced value.

    This function will release the entire specified range, whether the
    range is fully forced or not. If the specified range of the net was
    not forced, this function has no real effect.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param range_msb The most significant bit of the range.
    \param range_lsb The least significant of the range.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the range is out of bounds for the net,
    or if the specified handle is invalid.
    \sa carbonForceRange
  */
  CarbonStatus carbonReleaseRange(CarbonObjectID* context, CarbonNetID* handle,
                                  int range_msb, int range_lsb);


  /*!
    \brief Formats the current value of a net into a string.

    Note that this function automatically adds the terminating
    null ('\\0') to the generated string. Therefore, the buffer size
    must include the terminating null.

    \note This function currently returns a broad answer for tristates
    when using hexadecimal and octal , instead of partial Z's and
    X's. For example, if 1 bit of a hex value is z, the entire value
    is returned to be z in 1 character, i.e., "z". This will be fixed
    in a future release.

    \param context A valid object ID.
    \param handle A valid net ID.
    \param buf Buffer in which to put the string.
    \param len The length of the buffer. For, binary, hexadecimal, and
    octal, this length must be at least the number of bits needed to
    represent the entire value including any leading zeros plus 1 for
    the terminating null. Therefore, if n = bitwidth of the net then
    for binary: len >= n + 1, for octal: len >= (n+2)/3 + 1, and for
    hexadecimal: len >= (n+3)/4 + 1. For decimal, the size of the
    buffer must follow octal rules, meaning, len >= (n+2)/3 + 1.
    \param format The radix for formatting the string (binary, octal,
    hexadecimal, decimal).
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR if the specified handle is invalid.
  */
  CarbonStatus carbonFormat(CarbonObjectID* context, CarbonNetID* handle, char* buf,
                            int len, CarbonRadix format);

  /*!
    \brief Checks if the specified net is a primary port.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is a primary port.
    \retval 0 If the net is \e not a primary port.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsPrimaryPort(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is an input.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is an input.
    \retval 0 If the net is \e not an input.
    \retval -1 If the specified handle is invalid
  */
  int carbonIsInput(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is an output.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is an output.
    \retval 0 If the net is \e not an output.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsOutput(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is a bidirect.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is a bidirect.
    \retval 0 If the net is \e not a bidirect.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsBidirect(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is a clock.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is a clock.
    \retval 0 If the net is \e not a clock.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsClock(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net drives a schedule on its positive edge.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net does drive a schedule on its positive edge.
    \retval 0 If the net does \e not drive a schedule on its positive edge.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsPosedgeClock(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net drives a schedule on its negative edge.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net does drive a schedule on its positive edge.
    \retval 0 If the net does \e not drive a schedule on its positive edge.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsNegedgeClock(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is a reset.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is a reset.
    \retval 0 If the net is \e not a reset.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsReset(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is a positive-edge reset.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is a positive-edge reset.
    \retval 0 If the net is \e not a positive-edge reset.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsPosedgeReset(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is a negative-edge reset.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is a negative-edge reset.
    \retval 0 If the net is \e not a negative-edge reset.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsNegedgeReset(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is internal to the design, i.e.,
    not a primary I/O.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is internal to the design.
    \retval 0 If the net is a primary I/O.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsInternal(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is asynchronous.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is asynchronous.
    \retval 0 If the net is \e not asynchronous.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsAsync(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is synchronous.

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is synchronous.
    \retval 0 If the net is \e not synchronous.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsSync(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is depositable

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is depositable.
    \retval 0 If the net is \e not depositable.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsDepositable(const CarbonObjectID* context, const CarbonNetID* handle);

  /*!
    \brief Checks if the specified net is forcible

    \param context A valid object ID.
    \param handle A valid net ID.
    \retval 1 If the net is forcible.
    \retval 0 If the net is \e not forcible.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsForcible(const CarbonObjectID* context, const CarbonNetID* handle);

  /*! @} */





  /*!
    \defgroup CarbonMem Memory Functions
  */

  /*!
    \addtogroup CarbonMem
    \brief The following functions can be used to manipulate memories.
    @{
  */

  /*!
    \brief Gets a reference structure for the specified memory.

    \param context A valid object ID.
    \param memName Full HDL pathname of the memory for which to get the
    reference.
    \retval NON-NULL A unique handle for the named memory.
    \retval NULL If the specified memory name cannot be found.
  */
  CarbonMemoryID* carbonFindMemory(CarbonObjectID* context, const char* memName);


  /*!
    \brief Gets the name of a memory in the specified model.

    \param context A valid object ID.
    \param handle A valid memory ID for which to get the name.
    \param buffer The buffer into which to place the name.
    \param len The length of the buffer.
    \returns The name of the memory in the supplied buffer.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the buffer is not large enough for the name,
    or if the specified handle is invalid.
  */
  CarbonStatus carbonGetMemName(const CarbonObjectID* context,
                                const CarbonMemoryID* handle,
                                char* buffer, int len);

  /*!
    \brief Frees a CarbonMemoryID reference structure from the memory heap.

    Generally, this function is not required. However, it is useful if you
    need to conserve space for performance (swapping) issues, and the
    memory ID is no longer needed.

    The memory ID will be set to NULL after being freed. This is to avoid
    reuse of an ID. If you try to use the ID after it
    has been set to NULL, the application will segv. If the specified ID
    is already set to NULL, then this function has no effect.

    \param context A valid object ID.
    \param refPtr A pointer to the memory handle.
    \retval eCarbon_OK If the non-null memory reference was found, or if
    refPtr or *refPtr is null.
    \retval eCarbon_ERROR If the non-null reference was not found, or if
    the specified memory cannot be found.
    \sa carbonFindMemory
  */
  CarbonStatus carbonFreeMemoryHandle(CarbonObjectID* context, CarbonMemoryID** refPtr);


  /*!
    \brief Returns the LSB of a memory row.

    This function returns the least significant bound of a memory row.

    For example, if a memory is declared as
    \verbatim
    reg [6:2] mem [20:0]
    \endverbatim

    Then, this will return 2 (the right side of the 6:2 array bounds).

    \param handle A valid memory ID.
    \retval -1 If the specified handle is invalid.
  */
  int carbonGetMemoryRowLSB(CarbonMemoryID* handle);

  /*!
    \brief Returns the MSB of a memory row.

    This function returns the most significant bound of a memory row.
    For example, if a memory is declared as

    \verbatim
    reg [6:2] mem [20:0]
    \endverbatim

    Then, this will return 6 (the left side of the 6:2 array bounds)

    \param handle A valid memory ID.
    \retval -1 If the specified handle is invalid.
  */
  int carbonGetMemoryRowMSB(CarbonMemoryID* handle);

  /*!
    \brief Returns the right address of a memory.

    For example, for the memory
    \verbatim
    reg [31:0] mem [1:255]
    \endverbatim

    this function will return 255.

    \param handle A valid memory ID.
    \returns The right address of the memory.
    \retval -1 If the specified handle is invalid.
  */
  CarbonSInt64 carbonGetRightAddr(CarbonMemoryID* handle);

  /*!
    \brief Returns the left address of a memory.

    For example, for the memory
    \verbatim
    reg [31:0] mem [1:255]
    \endverbatim

    this function will return 1.

    \param handle A valid memory ID.
    \returns The left address of a memory.
    \retval -1 If the specified handle is invalid.
  */
  CarbonSInt64 carbonGetLeftAddr(CarbonMemoryID* handle);


  /*!
    \brief Returns the number of CarbonUInt32s needed to represent
    the value of a row of the memory.

    \param handle A valid memory ID.
    \retval -1 If the specified handle is invalid.
  */
  int carbonMemoryRowNumUInt32s(CarbonMemoryID* handle);

  /*!
    \brief Returns the size of a row of the memory in bits.

    \param handle A valid memory ID.
    \retval -1 If the specified handle is invalid.
  */
  int carbonMemoryRowWidth(CarbonMemoryID* handle);

  /*!
    \brief Gets the current value of a memory row at an address.

    \param handle A valid memory ID.
    \param address A row index into the memory.
    \param buf The return value.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the address is not in range for the memory, or if the specified
    handle is a scalar or vector.
    \sa carbonExamineMemoryWord(), carbonExamineMemoryRange()
  */
  CarbonStatus carbonExamineMemory(CarbonMemoryID* handle, CarbonSInt64 address,
                                   CarbonUInt32* buf);

  /*!
    \brief Gets the current value of a single 32 bit chunk from a memory row at an address.

    This function returns \e only a single 32 bit value extracted from a memory
    row from the specified memory at the specified address.
    The index argument selects which of the 32 bit chunks is returned.

    \param handle A valid memory ID.
    \param address A row index into the memory. (the address of the memory word)
    \param index The index of the 32 bit chunk that is desired.
    \returns Specified word of address.
    \retval 0 If an error occurred (along with the error message).
    \sa carbonMemoryRowNumUInt32s()
  */
  CarbonUInt32 carbonExamineMemoryWord(CarbonMemoryID* handle, CarbonSInt64 address,
                                 int index);

  /*!
    \deprecated "This function will be removed in a future release. As a replacement please consider using the more general API functions: carbonExamineRange() and the necessary support functions: carbonDBGetCarbonNet(), carbonDBGetArrayElement() and carbonDBFindNode()."

    THIS FUNCTION IS DEPRECATED -- Original documentation:
    Gets the current value of the specified bit range for a
    memory row at an address.

    \param handle A valid memoryID.
    \param address A row index into the memory.
    \param buf The return value.
    \param range_msb The most significant bit of the range.
    \param range_lsb The least significant bit  of the range.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the address or range is out of bounds, if
    the specified buffer is less than carbonGetRangeNumUInt32s() or if
    the specified handle is invalid.
  */
  CarbonStatus carbonExamineMemoryRange(CarbonMemoryID* handle,
                                        CarbonSInt64 address, CarbonUInt32* buf,
                                        int range_msb, int range_lsb);


  /*!
    \brief Deposits the given value to a memory row at an address.

    \param handle A valid memory ID.
    \param address A row index into the memory.
    \param buf The value to deposit.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid.
    \sa carbonDepositMemoryWord(), carbonDepositMemoryRange()
  */
  CarbonStatus carbonDepositMemory(CarbonMemoryID* handle, CarbonSInt64 address,
                                   const CarbonUInt32* buf);

  /*!
    \brief Deposits the current value on one word of a memory row at
    an address.

    \param handle A valid memory ID.
    \param address A row index into the memory.
    \param buf The value to deposit.
    \param index The index of the word on which to set the value.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the index is greater than or equal to
    carbonMemoryRowNumUInt32s(), or if the specified handle is invalid.
  */
  CarbonStatus carbonDepositMemoryWord(CarbonMemoryID* handle, CarbonSInt64 address,
                                       CarbonUInt32 buf, int index);

  /*!
    \deprecated "This function will be removed in a future release. As a replacement please consider using the more general API functions: carbonDepositRange() and the necessary support functions: carbonDBGetCarbonNet(), carbonDBGetArrayElement() and carbonDBFindNode()."


    THIS FUNCTION IS DEPRECATED -- Original documentation:
    Deposits a value on the specified range of a row of memory
    at an address.

    \param handle A valid memory ID.
    \param address A row index into the memory.
    \param buf The value to deposit.
    \param range_msb The most significant bit of the range.
    \param range_lsb The least significant bit of the range.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the range or address is out of bounds, or if the
    specified handle is invalid.
  */
  CarbonStatus carbonDepositMemoryRange(CarbonMemoryID* handle,
                                        CarbonSInt64 address,
                                        const CarbonUInt32* buf,
                                        int range_msb, int range_lsb);

  /*!
    \brief Formats the current value of a memory address into a string.

    Note that this function does not automatically add the terminating
    null ('\\0') to the generated string. The string may be larger than
    the value, and may be used for other operations in addition to
    retrieving a value.

    \param handle A valid memory ID.
    \param buf The buffer in which to put the string.
    \param len The length of the buffer.
    \param format The radix for formatting (binary, octal, hexadecimal, decimal).
    \param address The address of the memory to format.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid.
  */
  CarbonStatus carbonFormatMemory(CarbonMemoryID* handle, char* buf,
                                  int len, CarbonRadix format, CarbonSInt64 address);

  /*!
    \brief Reads a file of hex data into a memory..

    The file is read from lowest value address to the highest value.
    For example, if the memory address range is specified as [127:0] or
    as [0:127], the beginning of the file is read into address 0 and
    the end of the file is read into address 127. Explicit addressing
    (\@addr) simply makes the reader jump to that address.

    \param handle A valid memory ID.
    \param filename File from which to load the values.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid.
    \sa carbonReadmemb
  */
  CarbonStatus carbonReadmemh(CarbonMemoryID* handle,
                              const char* filename);


  /*!
    \brief Reads a file of binary data into a memory.

    The file is read from lowest value address to the highest value.
    For example, if the memory address range is specified as [127:0] or
    as [0:127], the beginning of the file is read into address 0 and
    the end of the file is read into address 127. Explicit addressing
    (\@addr) simply makes the reader jump to that address.

    \param handle A valid memory ID.
    \param filename File from which to load the values.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid.
    \sa carbonReadmemh
  */
  CarbonStatus carbonReadmemb(CarbonMemoryID* handle,
                              const char* filename);

  /*!
    \brief Reads a file of hex data into a range of a memory.

    The file is read from the starting address to the ending address,
    inclusively.  The first word from the file is placed in the
    starting address of the memory, and successive words are written
    moving towards the ending address, regardless of the way in which
    the memory was declared.  For example, with a starting address of
    6 and an ending address of 3, the first word from the file is
    placed in address 6, the second in address 5, etc., regardless of
    whether the memory was declared as [0:N] or [N:0].

    Explicit addressing (\@addr) in the file makes the reader jump to
    that address, provided it's within the range of the starting and
    ending addresses.

    If fewer words than are required to fill the entire range exist in
    the file, the filling of the memory range will stop when the end
    of the file is reached.  If more words than are required exist,
    the extra words will be ignored.  In each case, a warning will be
    issued.

    \param handle A valid memory ID.
    \param filename File from which to load the values.
    \param startAddress The address at which to start dumping.
    \param endAddress The address at which to stop dumping.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid.
    \sa carbonReadmembRange
  */
  CarbonStatus carbonReadmemhRange(CarbonMemoryID* handle, const char* filename,
                                   CarbonSInt64 startAddress, CarbonSInt64 endAddress);

  /*!
    \brief Reads a file of binary data into a range of a memory.

    The file is read from the starting address to the ending address,
    inclusively.  The first word from the file is placed in the
    starting address of the memory, and successive words are written
    moving towards the ending address, regardless of the way in which
    the memory was declared.  For example, with a starting address of
    6 and an ending address of 3, the first word from the file is
    placed in address 6, the second in address 5, etc., regardless of
    whether the memory was declared as [0:N] or [N:0].

    Explicit addressing (\@addr) in the file makes the reader jump to
    that address, provided it's within the range of the starting and
    ending addresses.

    If fewer words than are required to fill the entire range exist in
    the file, the filling of the memory range will stop when the end
    of the file is reached.  If more words than are required exist,
    the extra words will be ignored.  In each case, a warning will be
    issued.

    \param handle A valid memory ID.
    \param filename File from which to load the values.
    \param startAddress The address at which to start dumping.
    \param endAddress The address at which to stop dumping.
    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid.
    \sa carbonReadmemhRange
  */
  CarbonStatus carbonReadmembRange(CarbonMemoryID* handle, const char* filename,
                                   CarbonSInt64 startAddress, CarbonSInt64 endAddress);

  /*!
    \brief Dumps the contents of the memory for the given address
    range to a file.

    The address range must be consistent with the declaration of the memory.
    That is, \a startAddress must be greater than or equal to \a endAddress if the
    most significant address (MSA) of the memory is greater than the least
    significant address (LSA). Conversely, the \a startAddress must be less than
    or equal to the \a endAddress if the MSA is less than the LSA.

    \param handle A valid memory ID.
    \param filename the output file name.
    \param startAddress The address at which to start dumping.
    \param endAddress The address at which to stop dumping.
    \param format The radix for formatting the string (binary, octal, hexadecimal,
    decimal).

    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the specified handle is invalid or there
    were file problems.
  */
  CarbonStatus carbonDumpAddressRange(CarbonMemoryID* handle, const char* filename,
                                      CarbonSInt64 startAddress,
                                      CarbonSInt64 endAddress,
                                      CarbonRadix format);

  /*!
    \brief Checks if the specified memory is depositable

    \param handle A valid memory ID.
    \retval 1 If the memory is depositable.
    \retval 0 If the memory is \e not depositable.
    \retval -1 If the specified handle is invalid.
  */
  int carbonIsMemDepositable(const CarbonMemoryID* handle);

  /*! @} */


  /*!
    \defgroup CarbonDB Database Functions
  */

  /*!
    \addtogroup CarbonDB
    \brief The following functions are used in conjunction with the ARM CycleModels DB API. See the ARM Cycle Model Database API Reference Manual for more information.
    @{
  */

  /*!
    \brief Returns a CarbonDB object that can be used with the ARM CycleModels DB API

    \param context A valid object ID.
  */
  CarbonDB* carbonGetDB(CarbonObjectID* context);

  /*!
    \brief Returns a CarbonDBNode object representing a CarbonNet.

    \param context A valid object ID.
    \param handle A valid CarbonNet.
  */
  const CarbonDBNode* carbonNetGetDBNode(CarbonObjectID* context, CarbonNetID* handle);

  /*!
    \brief Writes the contents of an array to a file

    This function writes the contents of an array to a file using the
    specified radix.  Elements of the array are ordered from lowest
    index to highest index within each dimension, and from the
    innermost dimension to the outermost.

    The innermost element type of the array must be a scalar, not a
    structure.  If the array has one dimension, each scalar element of
    the array will be written to the file individually.  If the array
    has two or more dimensions, the innermost dimension is interpreted
    as a vector, and its value as a whole is written to the file.
    Iteration of these vectors begins with the containing dimension.

    \param context A valid object ID.
    \param node A ARM CycleModels database node representing an array.
    \param format The radix to be used.
    \param filename The file to be written.

    \retval eCarbon_OK if the examine succeeds.
    \retval eCarbon_ERROR if an error occurs.
  */
  CarbonStatus carbonExamineArrayToFile(CarbonObjectID* context, const CarbonDBNode* node,
                                        CarbonRadix format, const char* filename);

  /*!
    \brief Loads the contents of an array from a file

    This function reads values from a file, using the specified radix,
    and stores those values in an array.  Elements of the array are
    ordered from lowest index to highest index within each dimension,
    and from the innermost dimension to the outermost.

    The innermost element type of the array must be a scalar, not a
    structure.  If the array has one dimension, each scalar element of
    the array will be read from the file individually.  If the array
    has two or more dimensions, the innermost dimension is interpreted
    as a vector, and its value as a whole is read from the file.
    Iteration of these vectors begins with the containing dimension.

    If a row of data in the file is too wide for the array, it will be
    truncated.  If the file contains fewer rows than are required to
    fill the array, the unspecified elements will not be set.  If the
    file contains more rows than are required, the extra rows will be
    ignored.

    \param context A valid object ID.
    \param node A ARM CycleModels database node representing an array.
    \param format The radix to be used.
    \param filename The file to be read.

    \retval eCarbon_OK if the deposit succeeds.
    \retval eCarbon_ERROR if an error occurs.
  */
  CarbonStatus carbonDepositArrayFromFile(CarbonObjectID* context, const CarbonDBNode* node,
                                          CarbonRadix format, const char* filename);

  /*! @} */


  /*!
    \defgroup CarbonReplayInfoID DEPRECATED: ARM CycleModels Replay Info Functions
  */

  /*!
    \addtogroup CarbonReplayInfoID
    \brief The following functions are DEPRECATED.
    @{
  */

  typedef struct CarbonReplayInfoID CarbonReplayInfoID; // DEPRECATED

  /*!
    \brief DEPRECATED
  */
  static INLINE
  const char* carbonGetVHMModeString(CarbonVHMMode mode) DEPRECATED;
  static INLINE
  const char* carbonGetVHMModeString(CarbonVHMMode mode UNUSED) { return "normal"; }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonReplayInfoID* carbonGetReplayInfo(CarbonObjectID* context) DEPRECATED;
  static INLINE
  CarbonReplayInfoID* carbonGetReplayInfo(CarbonObjectID* context UNUSED) { return 0 /*NULL*/; }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonStatus carbonReplayInfoPutDB(CarbonReplayInfoID* info,
				     const char* systemName,
				     const char* instanceName) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayInfoPutDB(CarbonReplayInfoID* info UNUSED,
				     const char* systemName UNUSED,
				     const char* instanceName UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonStatus carbonReplayInfoPutDirAction(CarbonReplayInfoID* info,
					    CarbonDirAction action) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayInfoPutDirAction(CarbonReplayInfoID* info UNUSED,
					    CarbonDirAction action UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonStatus carbonReplayInfoPutSaveFrequency(CarbonReplayInfoID* info,
                                                CarbonUInt32 recoverPercent,
                                                CarbonUInt64 minNumCalls) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayInfoPutSaveFrequency(CarbonReplayInfoID* info UNUSED,
                                                CarbonUInt32 recoverPercent UNUSED,
                                                CarbonUInt64 minNumCalls UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonReplayCBDataID* carbonReplayInfoAddModeChangeCB(CarbonReplayInfoID* info,
                                                        CarbonModeChangeCBFunc fn,
                                                        void* userData) DEPRECATED;
  static INLINE
  CarbonReplayCBDataID* carbonReplayInfoAddModeChangeCB(CarbonReplayInfoID* info UNUSED,
                                                        CarbonModeChangeCBFunc fn UNUSED,
                                                        void* userData UNUSED) {
    return 0 /* NULL */;
  }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonReplayCBDataID* carbonReplayInfoAddCheckpointCB(CarbonReplayInfoID* info,
							CarbonCheckpointCBFunc fn,
							void* userData) DEPRECATED;
  static INLINE
  CarbonReplayCBDataID* carbonReplayInfoAddCheckpointCB(CarbonReplayInfoID* info UNUSED,
							CarbonCheckpointCBFunc fn UNUSED,
							void* userData UNUSED) {
    return 0 /* NULL */;
  }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonReplayInfoEnableCB(CarbonReplayCBDataID* dataID) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayInfoEnableCB(CarbonReplayCBDataID* dataID UNUSED) { return eCarbon_ERROR; }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonReplayInfoDisableCB(CarbonReplayCBDataID* dataID) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayInfoDisableCB(CarbonReplayCBDataID* dataID UNUSED) { return eCarbon_ERROR; }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonStatus carbonReplayInfoPutWorkArea(CarbonReplayInfoID* info,
					   const char* workDirectory) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayInfoPutWorkArea(CarbonReplayInfoID* info UNUSED,
					   const char* workDirectory UNUSED) {
    return eCarbon_ERROR;
  }

  /*! @} */

  /*!
    \defgroup CarbonReplayAPI DEPRECATED: ARM CycleModels Replay Functions
  */

  /*!
    \addtogroup CarbonReplayAPI
    \brief The following functions are DEPRECATED.
    @{
  */

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonStatus carbonReplayRecordStart(CarbonObjectID* context) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayRecordStart(CarbonObjectID* context UNUSED) { return eCarbon_ERROR; }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonStatus carbonReplayScheduleCheckpoint(CarbonObjectID* context) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayScheduleCheckpoint(CarbonObjectID* context UNUSED) { return eCarbon_ERROR; }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonStatus carbonReplayRecordStop(CarbonObjectID* context) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayRecordStop(CarbonObjectID* context UNUSED) { return eCarbon_ERROR; }


  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonStatus carbonReplayPlaybackStart(CarbonObjectID* context) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayPlaybackStart(CarbonObjectID* context UNUSED) { return eCarbon_ERROR; }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonStatus carbonReplayPlaybackStop(CarbonObjectID* context) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplayPlaybackStop(CarbonObjectID* context UNUSED) { return eCarbon_ERROR; }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  CarbonStatus carbonReplaySetVerboseDivergence(CarbonObjectID* context,
						CarbonUInt32 verbose) DEPRECATED;
  static INLINE
  CarbonStatus carbonReplaySetVerboseDivergence(CarbonObjectID* context UNUSED,
						CarbonUInt32 verbose UNUSED) {
    return eCarbon_ERROR;
  }

  /*! @} */

  /*!
    \defgroup CarbonOnDemand DEPRECATED: OnDemand Functions
  */

  /*!
    \addtogroup CarbonOnDemand
    \brief The following functions are DEPRECATED.
    @{
  */

  /*!
    \brief DEPRECATED
   */
  static INLINE
  int carbonOnDemandIsEnabled(CarbonObjectID *context) DEPRECATED;
  static INLINE
  int carbonOnDemandIsEnabled(CarbonObjectID *context UNUSED) { return 0; }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonOnDemandSetMaxStates(CarbonObjectID *context,
					  CarbonUInt32 max_states) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandSetMaxStates(CarbonObjectID *context UNUSED,
					  CarbonUInt32 max_states UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonOnDemandSetBackoffStrategy(CarbonObjectID *context,
						CarbonOnDemandBackoffStrategy strategy) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandSetBackoffStrategy(CarbonObjectID *context UNUSED,
						CarbonOnDemandBackoffStrategy strategy UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonOnDemandSetBackoffCount(CarbonObjectID *context,
					     CarbonUInt32 count) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandSetBackoffCount(CarbonObjectID *context UNUSED,
					     CarbonUInt32 count UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonOnDemandSetBackoffDecayPercentage(CarbonObjectID *context,
						       CarbonUInt32 percentage) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandSetBackoffDecayPercentage(CarbonObjectID *context UNUSED,
						       CarbonUInt32 percentage UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
   */

  static INLINE
  CarbonStatus carbonOnDemandSetBackoffMaxDecay(CarbonObjectID *context,
						CarbonUInt32 max) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandSetBackoffMaxDecay(CarbonObjectID *context UNUSED,
						CarbonUInt32 max UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonOnDemandCBDataID* carbonOnDemandAddModeChangeCB(CarbonObjectID* context,
                                                        CarbonOnDemandModeChangeCBFunc fn,
                                                        void* userData) DEPRECATED;
  static INLINE
  CarbonOnDemandCBDataID* carbonOnDemandAddModeChangeCB(CarbonObjectID* context UNUSED,
                                                        CarbonOnDemandModeChangeCBFunc fn UNUSED,
                                                        void* userData UNUSED) {
    return 0 /* NULL */;
  }

  /*!
    \brief DEPRECATED
   */

  static INLINE
  CarbonStatus carbonOnDemandEnableStats(CarbonObjectID* context) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandEnableStats(CarbonObjectID* context UNUSED) { return eCarbon_ERROR; }

  /*!
    \brief DEPRECATED
   */

  static INLINE
  CarbonStatus carbonOnDemandStop(CarbonObjectID* context) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandStop(CarbonObjectID* context UNUSED) { return eCarbon_ERROR; }

  /*!
    \brief DEPRECATED
   */

  static INLINE
  CarbonStatus carbonOnDemandStart(CarbonObjectID* context) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandStart(CarbonObjectID* context UNUSED) { return eCarbon_ERROR; }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonOnDemandSetDebugLevel(CarbonObjectID* context,
                                           CarbonOnDemandDebugLevel level) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandSetDebugLevel(CarbonObjectID* context UNUSED,
                                           CarbonOnDemandDebugLevel level UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonOnDemandCBDataID* carbonOnDemandAddDebugCB(CarbonObjectID* context,
                                                   CarbonOnDemandDebugCBFunc fn,
                                                   void* userData) DEPRECATED;
  static INLINE
  CarbonOnDemandCBDataID* carbonOnDemandAddDebugCB(CarbonObjectID* context UNUSED,
                                                   CarbonOnDemandDebugCBFunc fn UNUSED,
                                                   void* userData UNUSED) {
    return 0 /* NULL */;
  }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonOnDemandEnableCB(CarbonObjectID* context,
                                      CarbonOnDemandCBDataID* dataID) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandEnableCB(CarbonObjectID* context UNUSED,
                                      CarbonOnDemandCBDataID* dataID UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonOnDemandDisableCB(CarbonObjectID* context,
                                       CarbonOnDemandCBDataID* dataID) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandDisableCB(CarbonObjectID* context UNUSED,
                                       CarbonOnDemandCBDataID* dataID UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonOnDemandMakeIdleDeposit(CarbonObjectID* context,
                                             CarbonNetID* net) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandMakeIdleDeposit(CarbonObjectID* context UNUSED,
                                             CarbonNetID* net UNUSED) {
    return eCarbon_ERROR;
  }

  /*!
    \brief DEPRECATED
   */
  static INLINE
  CarbonStatus carbonOnDemandExclude(CarbonObjectID* context,
                                     CarbonNetID* net) DEPRECATED;
  static INLINE
  CarbonStatus carbonOnDemandExclude(CarbonObjectID* context UNUSED,
                                     CarbonNetID* net UNUSED) {
    return eCarbon_ERROR;
  }

  /*! @} */


  /*!
    \defgroup CarbonMemFile Memory File Functions
  */

  /*!
    \addtogroup CarbonMemFile
    \brief The following functions can be used to manipulate memory
    file objects. Memory file objects are objects used to read and use
    Verilog memory (.dat) files.

    @{
  */
  /*!
    \brief Read a Verilog memory .dat file with known width but unknown
    depth.

    \param context This is needed for messaging if there are
    errors. This can be NULL. If NULL, error messages are sent to
    stderr. If it is non-null, the context-specific message context is
    used. The context does not own the CarbonMemFileID, and
    therefore, the caller must free the CarbonMemFileID by calling
    carbonFreeMemFileID().
    \param fileName The name of the .dat file to parse.
    \param format Format of the file to parse. It can be either
    eCarbonBin or eCarbonHex. No other formats are currently supported.
    \param rowWidth The width in bits of each row.
    \param decreasingAddresses If non-zero, the address counter will
    decrease by one as each row is parsed; otherwise the address
    counter increases by one as each row is parsed.

    \returns A CarbonMemFileID object pointer. NULL if there was an
    error. The object pointer must be freed using carbonFreeMemFileID().
  */
  CarbonMemFileID* carbonReadMemFile(CarbonObjectID* context, const char* fileName, CarbonRadix format,
                                     CarbonUInt32 rowWidth, int decreasingAddresses);


  /*!
    \brief Get the first and last addresses of the already parsed mem
    file.

    \param memFile The memfile object.
    \param firstAddress A pointer to a single CarbonSInt64 to store the
    first address.
    \param lastAddress A pointer to a single CarbonSInt64 to store the
    last address.

    \retval eCarbon_OK If the memFile is valid
    \retval eCarbon_ERROR If memFile is invalid.
  */
  CarbonStatus carbonMemFileGetFirstAndLastAddrs(CarbonMemFileID* memFile, CarbonSInt64* firstAddress, CarbonSInt64* lastAddress);

  /*!
    \brief Get the row of data at the specified address.

    If the row is never initialized NULL is returned.

    \param memFile The memfile object.
    \param address Address at which to get the data. This must be
    between the first and last address inclusive given by
    carbonMemFileGetFirstAndLastAddrs()

    \retval Pointer to a row of data.
    \retval NULL If memFile is invalid, the address is out of range,
    or the address is uninitialized
  */
  const CarbonUInt32* carbonMemFileGetRow(CarbonMemFileID* memFile, CarbonSInt64 address);

  /*!
    \brief Populate an array with a range of each row of the memory.

    Starting from the first address and continuing through the last
    address, a partition of each row will be placed in the specified
    array. Each row begins on a word boundary, so extra bits between
    the end of the row and the next row are 0. In other words, each
    row is contained within a contiguous chunk of CarbonUInt32s.

    For example, if the memory file that was loaded had 10 addresses
    and 35-bit rows, then the size of the supplied array must be at
    least (35 + 31)/32 * 10 = 2 * 10 = 20 words. The first address row
    would be in theArray[0] and theArray[1]. The second address row
    would be in theArray[2] and theArray[3], etc.

    \param memFile The memfile object.
    \param theArray The array to populate.
    \param numArrayWords The number of words allocated for theArray. This
    must be at least <tt>(numBits + 31)/32 * numRows</tt>. numRows can be
    obtained by <tt>abs(lastAddress - firstAddress) + 1</tt>. The first
    and last address can be obtained with carbonMemFileGetFirstAndLastAddrs().
    \param rowBitIndex The index of the bit at which to begin the copy
    Bit 0 is the rightmost bit of the row.
    \param numBits The number of bits to copy from each row.

    \retval eCarbon_OK If the copy was successful.
    \retval eCarbon_ERROR If the supplied array is not big enough or if the
    rowBitIndex + numBits is greater than the total row width.
  */
  CarbonStatus carbonMemFilePopulateArray(CarbonMemFileID* memFile, CarbonUInt32* theArray, CarbonUInt32 numArrayWords,
                                          CarbonUInt32 rowBitIndex, CarbonUInt32 numBits);

  /*!
    \brief Frees a carbonMemFileID object.

    This is the only method to free this type of object. carbonDestroy()
    does \e not destroy carbonMemFileID objects. The CarbonMemFileID will
    be set to NULL to mark it as freed.

    \param memFilePtr Pointer to a carbonMemFileID object. If the
    corresponding memFile has already been freed then this function
    has no effect.
  */
  void carbonFreeMemFileID(CarbonMemFileID** memFilePtr);

  /*! @} */


  /*!
    \defgroup CarbonMisc Miscellaneous Functions
  */

  /*!
    \addtogroup CarbonMisc
    \brief The following are miscellaneous functions that do not fall into other categories.
    @{
  */
  /*!
    \brief Converts any verilog data into a null terminated string, and puts the resulting string in \a buf.

    At most, \a bufferSize characters are placed in \a buf (including
    the trailing null char). If \a maxCharsToConvert is smaller than
    \a bufferSize, then only that many characters are written to \a buf.
    If a null character is encountered in \a source before reaching the
    lesser of \a charsToConvert or \a bufferSize, then \a buf will contain
    only the characters up to and including that null. If bufferSize is
    too short to contain the specified data, then it is truncated before
    the end of the string.

    \param destBuffer The destination buffer.
    \param bufferSize  The size of \a buf  (be sure to allocate enough
    space for a trailing null char).
    \param source Pointer to the data to be converted.
    \param maxCharsToConvert  The maximum number of characters to convert.

    \return A pointer to \a buf.
  */
  char* carbonVerilogDataToAscii(char * destBuffer, CarbonUInt32 bufferSize, const CarbonUInt32* source, CarbonUInt32 maxCharsToConvert);

  /*!
    \brief Formats a value of an array of words into a string.

    Note that this function automatically adds the terminating
    null ('\\0') to the generated string. Therefore, the buffer size
    must include the terminating null.

    \param buf Buffer in which to put the string.
    \param buflen The length of the buffer. For, binary, hexadecimal, and
    octal, this length must be at least the number of bits needed to
    represent the entire value including any leading zeros plus 1 for
    the terminating null. Therefore, if n = bitwidth of the net then
    for binary: len >= n + 1, for octal: len >= (n+2)/3 + 1, and for
    hexadecimal: len >= (n+3)/4 + 1. For decimal, the size of the
    buffer must follow octal rules, meaning, len >= (n+2)/3 + 1.

    \param src Source array to convert.
    \param numBitsToConvert The number of bits to convert.
    \param uppercase If non-zero, for hexadecimal this will print any
    non-numeral values in uppercase.
    \param format The radix for formatting the string (binary, octal,
    hexadecimal, decimal). If decimal and the last bit to convert is 1,
    then a negative value is printed out. Be sure to allocate space for
    the '-' sign.

    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If buf is not large enough to hold the value,
    the null terminator, and the possible '-' sign.
  */
  CarbonStatus carbonFormatGenericArray(char* buf, CarbonUInt32 buflen,
                                        const CarbonUInt32* src,
                                        CarbonUInt32 numBitsToConvert,
                                        int uppercase, CarbonRadix format);



  /*!
    \brief Converts a string into a ARM CycleModels UInt32 array.

    Note that this function currently only supports the binary and
    hexadecimal string formats.

    \param data The destination array of ARM CycleModels UInt32's.
    \param dataSize The size of the destination array.
    \param buf The source string to convert.
    \param format The format of the source string.

    \retval eCarbon_OK If the operation was successful.
    \retval eCarbon_ERROR If the data array was not large enough to
    hold the value, if the radix format is something other than
    hexadecimal or binary, or if there were invalid characters in the
    string.
  */
  CarbonStatus carbonStringToArray(CarbonUInt32* data, CarbonUInt32 dataSize,
                                   const char* buf, CarbonRadix format);


  /*!
    \brief Returns a string attribute stored in the database

    Returns the value of a string attribute from the database.

    The string is valid only until the next call to this function, so
    if you need to look up multiple attributes, you must copy the
    strings to user-owned storage first.

    \param context The database object for the design.
    \param attributeName The attribute name.
    \returns The value of the attribute, if it exists. If the attribute does not exist, NULL is returned.
  */

  const char* carbonGetStringAttribute(CarbonObjectID* context, const char* attributeName);

  /*!
    \brief Returns an integer attribute stored in the database

    Returns the value of an integer attribute from the database.

    \param context The database object for the design.
    \param attributeName The attribute name.
    \param attributeValue Pointer to storage for returning the attribute's value
    \retval eCarbon_OK if the attribute exists
    \retval eCarbon_ERROR if the attribute does not exist
  */

  CarbonStatus carbonGetIntAttribute(CarbonObjectID* context, const char* attributeName, CarbonUInt32* attributeValue);

  /*! @} */


/* Provide both a C and C++ friendly interface. */

  /* backward compatibility */
#ifndef CARBON_EXTERNAL_DOC
#define carbon_dumpInit carbonDumpInit
#define carbon_dumpvars carbonDumpVars
#define carbon_dumpStateIO carbonDumpStateIO
#define carbon_dumpall carbonDumpAll
#define carbon_dumpoff carbonDumpOff
#define carbon_dumpon carbonDumpOn
#define carbon_dumpflush carbonDumpFlush

#endif

#ifdef __cplusplus
}
#endif

  /*!
    \defgroup CarbonObsolete Obsolete Functions
  */

  /*!
    \addtogroup CarbonObsolete
    \brief The following obsolete functions are DEPRECATED beginning with v8.3.0.
    @{

    \li carbonGetReplayInfo
    \li carbonGetVHMModeString
    \li carbonOnDemandAddDebugCB
    \li carbonOnDemandAddModeChangeCB
    \li carbonOnDemandDisableCB
    \li carbonOnDemandEnableCB
    \li carbonOnDemandEnableStats
    \li carbonOnDemandExclude
    \li carbonOnDemandIsEnabled
    \li carbonOnDemandMakeIdleDeposit
    \li carbonOnDemandSetBackoffCount
    \li carbonOnDemandSetBackoffDecayPercentage
    \li carbonOnDemandSetBackoffMaxDecay
    \li carbonOnDemandSetBackoffStrategy
    \li carbonOnDemandSetDebugLevel
    \li carbonOnDemandSetMaxStates
    \li carbonOnDemandStart
    \li carbonOnDemandStop
    \li carbonReplayInfoAddCheckpointCB
    \li carbonReplayInfoAddModeChangeCB
    \li carbonReplayInfoDisableCB
    \li carbonReplayInfoEnableCB
    \li carbonReplayInfoPutDB
    \li carbonReplayInfoPutDirAction
    \li carbonReplayInfoPutSaveFrequency
    \li carbonReplayInfoPutWorkArea
    \li carbonReplayPlaybackStart
    \li carbonReplayPlaybackStop
    \li carbonReplayRecordStart
    \li carbonReplayRecordStop
    \li carbonReplayScheduleCheckpoint
    \li carbonReplaySetVerboseDivergence

    @} */

#endif
