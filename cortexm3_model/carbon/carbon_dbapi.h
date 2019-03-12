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
#ifndef __carbon_db_h_
#define __carbon_db_h_


/*!
  \file
  File containing the C API for the ARM CycleModels runtime database.
*/

#ifndef __carbon_shelltypes_h_
#include "carbon/carbon_shelltypes.h"
#endif

/*!
  \defgroup CarbonDBCAPI ARM CycleModels Database C API Functions
*/

/*!
  \addtogroup CarbonDBCAPI
  \brief The following are ARM CycleModels database API functions.
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
    \brief Get the version of the carbonDB API.
    \returns The version string of the ARM CycleModels DB API.
  */
  const char* carbonDBGetVersion();

  /*!
    \brief Registers a function to be called whenever message is output
    by the model.

    The provided function must return one of eCarbonDBMsgStop or eCarbonDBMsgContinue.
    If eCarbonDBMsgContinue is returned, the next registered function is
    called with the message. If eCarbonDBMsgStop is returned, then no more message
    callbacks are invoked for the message (including the default system handler).

    Functions are called in reverse order of registration (last registered,
    first called).  This enables registration of a temporary handler (removed
    by calling carbonDBRemoveMsgCB()).

    \param cbFun The function to be called when a message is output by
    the model.
    \param userData This pointer will be passed to the callback function.
    \return Returns a pointer to ID that may be used to unregister the
    callback, or NULL if there is an error.
  */
  CarbonMsgCBDataID* carbonDBAddMsgCB(CarbonMsgCB cbFun,
                                      CarbonClientData userData);

  /*!
    \brief Unregisters a message callback function previously registered
    via carbonDBAddMsgCB.


    \param cbDataPtr Address of the value returned by carbonDBAddMsgCB().
  */
  void carbonDBRemoveMsgCB(CarbonMsgCBDataID **cbDataPtr);


  /*!
    \brief Open the ARM CycleModels database file and return the reader object

    The caller is responsible for freeing this object by calling
    carbonDBFree().

    \param fileName The name of the ARM CycleModels database file to open. The
    ARM CycleModels compiler outputs two different database files that are
    valid here:
    -# libdesign.io.db
    -# libdesign.symtab.db
    The same information is contained in both, except that symtab
    database has information about the entire design in it.

    \param waitForLicense If non-zero and no licenses are available
    the licensing mechanism will block until it is available. Note
    that this API requires the same licenses as a ARM CycleModels Model. See
    carbon_capi.h for more details.

    \retval NON-NULL ARM CycleModels database object if no problems were
    encountered.
    \retval NULL if there was a problem reading the database or with
    licensing.
  */
  CarbonDB* carbonDBCreate(const char* fileName, int waitForLicense);

  /*!
    \brief Get the version of the software that created the database.

    \param dbContext The database object created from carbonDBCreate.
    \returns The version string of the ARM CycleModels software that created
    the database. If the database was created with an older compiler
    that did not add the compiler version to the database an empty
    string is returned.
  */
  const char* carbonDBGetSoftwareVersion(CarbonDB* dbContext);

  /*!
    \brief Get the identification string for a database.

    Each ARM CycleModels database has a unique identification string,
    reflecting its creation timestamp and the software version used to
    create it.

    \param dbContext The database object created from carbonDBCreate.
    \returns The identification string.
  */
  const char* carbonDBGetIdString(CarbonDB* dbContext);


  /*!
    \brief Free the CarbonDB object

    \param dbObj The object to free. The object will no longer be
    valid and should not be used again.
  */
  void carbonDBFree(CarbonDB* dbObj);

  /*!
    \brief Get the interface name of the compiled design.

    The interface name is the name of the design that was supplied to
    the ARM CycleModels compiler with the -o option. For example, if the design
    was compiled with -o libmyflop.a, this will return 'myflop'.
    The ARM CycleModels compiler defaults the name to 'design'.

    \param dbContext The database object created from carbonDBCreate.
    \returns The interface name
  */
  const char* carbonDBGetInterfaceName(CarbonDB* dbContext);

  /*!
    \brief Get the name of the top-level module

    \param dbContext The database object created from carbonDBCreate.
    \returns The top-level module name
  */
  const char* carbonDBGetTopLevelModuleName(CarbonDB* dbContext);

  /*!
    \brief Get the name of the SystemC Wrapper module name

    This is specified in the ARM CycleModels compiler by using the
    -systemCModuleName switch. If that wasn't specified, this returns
    the top-level module name

    \param dbContext The database object created from carbonDBCreate.
    \returns The top-level module name
  */
  const char* carbonDBGetSystemCModuleName(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's primary ports in the order
    they were declared.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopPrimaryPorts(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's primary inputs.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopPrimaryInputs(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's primary outputs.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopPrimaryOutputs(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's primary bidirectional nets.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopPrimaryBidis(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's primary clock nets.

    Primary clocks are nets that directly drive sequential blocks.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopPrimaryClks(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's clock tree nets.

    Clock tree nets are either primary inputs or depositable nets
    indirectly clock sequential blocks.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopClkTree(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's primary asynchronous input nets.

    Asynchronous nets are primary inputs nets that directly drive primary
    outputs through combinational logic.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopAsyncs(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's primary asynchronous output nets.

    Asynchronous nets are primary outputs nets that directly driven by
    primary inputs through combinational logic.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopAsyncOutputs(CarbonDB* dbContext);

  /*!
    \brief Iterate through the a primary asynchronous output's fanin nets.

    Asynchronous nets are primary outputs nets that directly driven by
    primary inputs through combinational logic. This function returns the
    set of fanins for any given primary output

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopAsyncFanin(CarbonDB* dbContext, const CarbonDBNode* output);

  /*!
    \brief Iterate through the design's deposits that feed async outputs

    Asynchronous deposits are depositable nets that feed a primary
    output or observable point through combinational logic. Some
    deposits are treated as primary inputs if the compiler believes
    they are frequently depositable. That is also the case if the
    depositSignalFrequent directive is used. These are not included in
    this set.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopAsyncDeposits(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's primary posedge asynchronous resets.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopAsyncPosResets(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's primary negedge asynchronous resets.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopAsyncNegResets(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's observable nets.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopObservable(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's depositable nets.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopDepositable(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's systemc observable nets.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopScObservable(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's systemc depositable nets.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopScDepositable(CarbonDB* dbContext);

  /*!
    \brief Iterate over posedge-only schedule triggers

    A schedule trigger that fires on both edges will not appear in
    this loop. Only triggers that run schedules on their positive
    edges will be present in the loop.

    \param dbContext The database object created from carbonDBCreate
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopPosedgeOnlyTriggers(CarbonDB* dbContext);

  /*!
    \brief Iterate over negedge-only schedule triggers

    A schedule trigger that fires on both edges will not appear in
    this loop. Only triggers that run schedules on their negative
    edges will be present in the loop.

    \param dbContext The database object created from carbonDBCreate
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopNegedgeOnlyTriggers(CarbonDB* dbContext);

  /*!
    \brief Iterate over all posedge schedule triggers

    A schedule trigger that fires on both edges as well as triggers
    that fire only on their positive edge will appear in
    this loop.

    \param dbContext The database object created from carbonDBCreate
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopPosedgeTriggers(CarbonDB* dbContext);

  /*!
    \brief Iterate over all negedge schedule triggers

    A schedule trigger that fires on both edges as well as triggers
    that fire only on their negative edge will appear in
    this loop.

    \param dbContext The database object created from carbonDBCreate
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopNegedgeTriggers(CarbonDB* dbContext);

  /*!
    \brief Iterate over all dual-edge schedule triggers

    Only schedule triggers that fire on both edges
    will appear in this loop.

    \param dbContext The database object created from carbonDBCreate
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopBothEdgeTriggers(CarbonDB* dbContext);

  /*!
    \brief Iterate over all Triggers that also appear in the data
    path.

    The data path does not trigger schedules, but triggers that also
    feed the data path may require special handling within a
    simulation system so that the data path is always updated on a
    trigger change.

    \param dbContext The database object created from carbonDBCreate
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopTriggersUsedAsData(CarbonDB* dbContext);

  /*!
    \brief Iterate through the design's root modules

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopDesignRoots(CarbonDB* dbContext);

  /*!
    \brief Iterate through the node's children

    If the node represents an array, its children are the elements of
    its first dimension, iterated from leftmost to rightmost.

    If the node represents a structure, its children are its fields,
    iterated in the order in which they are declared.

    In other cases (for example, a module instance), the node's
    children are its nets and instances, sorted alphabetically.

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopChildren(CarbonDB* dbContext, const CarbonDBNode*);

  /*!
    \brief Iterate through the node's alias ring

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopAliases(CarbonDB* dbContext,
                                        const CarbonDBNode*);

  /*!
    \brief Iterate through the nodes matching a string, including wildcards

    The caller is responsible for freeing this object with
    carbonDBFreeNodeIter().

    \param dbContext The database object created from carbonDBCreate.
    \param matchString The string to match.
    \returns A new looper instance.
  */
  CarbonDBNodeIter* carbonDBLoopMatching(CarbonDB* dbContext,
                                         const char* matchString);

  /*!
    \brief Retrieve the next database node in the iterator.
    \param nodeIterObj The node iterator.

    \retval NULL If there are no more nodes to iterate through.
    \retval NON-NULL If there are still nodes to iterate through.
  */
  const CarbonDBNode* carbonDBNodeIterNext(CarbonDBNodeIter* nodeIterObj);

  /*!
    \brief Free a node iterator.

    \param dbNodeIter The iterator to free. The node iterator will no
    longer valid.
  */
  void carbonDBFreeNodeIter(CarbonDBNodeIter* dbNodeIter);

  /*!
    \brief Get the fully qualified name of the signal represented by the node

    For a signal named, "a.b.c", this will return "a.b.c".

    The string is valid until the next call to the DB API, so if you
    need to print two of them, you must copy one of the strings to user-owned
    storage first.

    \param dbContext The database object created from
    carbonDBCreate. This is needed to compose special signal names
    (for example, a split port) and to cache the name in a string cache.
    \param node The CarbonDBNode from which to get the name

    \returns The name of the signal represented by the node.
  */
  const char* carbonDBNodeGetFullName(CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Get the leaf name of the signal represented by the node

    For a signal named, "a.b.c", this will return "c".

    The string is cached internally, so the user does not have to
    memory manage it.

    \param dbContext The database object created from
    carbonDBCreate. This is needed to compose special signal names
    (for example, a split port) and to cache the name in a string cache.
    \param node The CarbonDBNode from which to get the name

    \returns The name of the signal represented by the node.
  */
  const char* carbonDBNodeGetLeafName(CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Is this node a primary input?

    \sa carbonDBLoopPrimaryInput

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a primary input
    \retval 0 If the node is not a primary input
  */
  int carbonDBIsPrimaryInput(const CarbonDB* dbContext,
                             const CarbonDBNode* node);

  /*!
    \brief Is this node a primary output?

    \sa carbonDBLoopPrimaryOutput

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a primary output
    \retval 0 If the node is not a primary output
  */
  int carbonDBIsPrimaryOutput(const CarbonDB* dbContext,
                              const CarbonDBNode* node);

  /*!
    \brief Is this node a primary bidirect?

    \sa carbonDBLoopPrimaryBidis

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a primary bidirect
    \retval 0 If the node is not a primary bidirect
  */
  int carbonDBIsPrimaryBidi(const CarbonDB* dbContext,
                            const CarbonDBNode* node);

  /*!
    \brief Is this node a module input?

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is an input
    \retval 0 If the node is not an input
  */
  int carbonDBIsInput(const CarbonDB* dbContext,
                      const CarbonDBNode* node);

  /*!
    \brief Is this node an output?

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is an output
    \retval 0 If the node is not an output
  */
  int carbonDBIsOutput(const CarbonDB* dbContext,
                              const CarbonDBNode* node);

  /*!
    \brief Is this node a bidirect?

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a bidirect
    \retval 0 If the node is not a bidirect
  */
  int carbonDBIsBidi(const CarbonDB* dbContext,
                     const CarbonDBNode* node);

  /*!
    \brief Is this node a 1 bit scalar?

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a scalar
    \retval 0 If the node is not a scalar
  */
  int carbonDBIsScalar(const CarbonDB* dbContext,
                       const CarbonDBNode* node);

  /*!
    \brief Is this node a tristate?

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a tristate
    \retval 0 If the node is not a tristate
  */
  int carbonDBIsTristate(const CarbonDB* dbContext,
                         const CarbonDBNode* node);

  /*!
    \brief Does this node have a constant value?

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node has a constant value
    \retval 0 If the node does not have a constant value
  */
  int carbonDBIsConstant(const CarbonDB* dbContext,
                         const CarbonDBNode* node);

  /*!
    \brief Is this node a one dimensional array of bits?

    \note An array of bits can have a size of 1 just like a scalar.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a vector
    \retval 0 If the node is not a vector
  */
  int carbonDBIsVector(const CarbonDB* dbContext,
                       const CarbonDBNode* node);

  /*!
    \brief Is this node a depositable or observable 2-D array?

    Two-dimensional arrays can only be seen in the database if they
    are marked depositable or observable.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a 2-D array
    \retval 0 If the node is not a 2-D array
  */
  int carbonDBIs2DArray(const CarbonDB* dbContext,
                        const CarbonDBNode* node);

  /*!
    \brief Is this node a clock?

    This will return true if the input is a primary clock or a
    depositable signal that clocks a sequential block.

    \sa carbonDBLoopPrimaryClks, carbonDBLoopDepositable, carbonDBLoopScDepositable

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a clock
    \retval 0 If the node is not a clock
  */
  int carbonDBIsClk(const CarbonDB* dbContext,
                    const CarbonDBNode* node);

  /*!
    \brief Is this node a clocktree node?

    \sa carbonDBLoopClkTree

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a clock tree node
    \retval 0 If the node is not a clock tree node
  */
  int carbonDBIsClkTree(const CarbonDB* dbContext,
                        const CarbonDBNode* node);

  /*!
    \brief Is this node an asynchronous input?

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is an async
    \retval 0 If the node is not a async
  */
  int carbonDBIsAsync(const CarbonDB* dbContext,
                      const CarbonDBNode* node);

  /*!
    \brief Is this node an asynchronous output?

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is an async output
    \retval 0 If the node is not a async output
  */
  int carbonDBIsAsyncOutput(const CarbonDB* dbContext,
                            const CarbonDBNode* node);

  /*!
    \brief Is this node an asynchronous deposit?

    An asynchronous deposit is one that feeds a primary output or
    observe net through combinational logic.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is an async deposit
    \retval 0 If the node is not a async deposit
  */
  int carbonDBIsAsyncDeposit(const CarbonDB* dbContext,
                             const CarbonDBNode* node);

  /*!
    \brief Is this node an asynchronous posedge reset?

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is an async posedge reset
    \retval 0 If the node is not an async posedge reset
  */
  int carbonDBIsAsyncPosReset(const CarbonDB* dbContext,
                              const CarbonDBNode* node);

  /*!
    \brief Is this node an asynchronous negedge reset?

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is an async negedge reset
    \retval 0 If the node is not an async negedge reset
  */
  int carbonDBIsAsyncNegReset(const CarbonDB* dbContext,
                              const CarbonDBNode* node);

  /*!
    \brief Is this node compiled forcible in the model?
    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is compiled forcible
    \retval 0 If the node is not compiled forcible
  */
  int carbonDBIsForcible(const CarbonDB* dbContext,
                         const CarbonDBNode* node);

  /*!
    \brief Is this node compiled depositable in the model?
    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is compiled depositable
    \retval 0 If the node is not compiled depositable
  */
  int carbonDBIsDepositable(const CarbonDB* dbContext,
                            const CarbonDBNode* node);

   /*!
    \brief Is this node compiled depositable in the model?
    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is compiled scDepositable
    \retval 0 If the node is not compiled scDepositable
  */
  int carbonDBIsScDepositable(const CarbonDB* dbContext,
                            const CarbonDBNode* node);

  /*!
    \brief Is this node compiled observable in the model?
    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is compiled observable
    \retval 0 If the node is not compiled observable
  */
  int carbonDBIsObservable(const CarbonDB* dbContext,
                           const CarbonDBNode* node);
  /*!
    \brief Is this node compiled observable in the model?
    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is compiled scObservable
    \retval 0 If the node is not compiled scObservable
  */
  int carbonDBIsScObservable(const CarbonDB* dbContext,
                           const CarbonDBNode* node);

  /*!
    \brief Is this node visible (waveforms available) in the model?
    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is visible
    \retval 0 If the node is not visible
  */
  int carbonDBIsVisible(const CarbonDB* dbContext,
                        const CarbonDBNode* node);

   /*!
     \brief Is this node tied to a constant value?

     This function returns whether the specified net was marked with a
     tieNet directive during compilation.

     \param dbContext The database object created from carbonDBCreate.
     \param node The design net of interest.
     \retval 1 If the node is tied
     \retval 0 If the node is not tied
   */
   int carbonDBIsTied(const CarbonDB* dbContext,
                      const CarbonDBNode* node);

  /*!
    \brief Get the width of a signal

    For scalars, this returns 1. For vectors, this returns the size of
    the vector in bits. For memories, this returns the size of the row
    in bits.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.

  */
  int carbonDBGetWidth(const CarbonDB* dbContext,
                       const CarbonDBNode* node);

  /*!
    \brief Get the msb of a vector

    For scalars, this returns 0. For vectors, this returns the index
    of the msb of the vector. For memories, this returns the index of
    the msb of the row.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
  */
  int carbonDBGetMSB(const CarbonDB* dbContext,
                     const CarbonDBNode* node);

  /*!
    \brief Get the lsb of a vector

    For scalars, this returns 0. For vectors, this returns the index
    of the msb of the vector. For memories, this returns the index of
    the msb of the row.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
  */
  int carbonDBGetLSB(const CarbonDB* dbContext,
                     const CarbonDBNode* node);

  /*!
    \brief Get the left address of a two-dimensional array

    For scalars and vectors, this returns 0. For two-dimensional
    arrays, this returns the leftmost address. For example, for a
    memory that has an address range of [0:100] this will return 0.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
  */
  int carbonDBGet2DArrayLeftAddr(const CarbonDB* dbContext,
                                 const CarbonDBNode* node);

  /*!
    \brief Get the right address of a two-dimensional array

    For scalars and vectors, this returns 0. For two-dimensional
    arrays, this returns the rightmost address. For example, for a
    memory that has an address range of [0:100] this will return 100.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
  */
  int carbonDBGet2DArrayRightAddr(const CarbonDB* dbContext,
                                  const CarbonDBNode* node);

  /*!
    \brief Find a DB node by path, return NULL if on failure
  */
  const CarbonDBNode* carbonDBFindNode(CarbonDB* dbContext,
                                       const char* hierPath);

  /*!
    \brief Get a DB Node's parent, return NULL if this is a root object
  */
  const CarbonDBNode* carbonDBNodeGetParent(const CarbonDB* dbContext,
                                            const CarbonDBNode* node);


  /*!
    \brief Find a DB node's child, return NULL if on failure
  */
  const CarbonDBNode* carbonDBFindChild(CarbonDB* dbContext,
                                        const CarbonDBNode* parent,
                                        const char* childName);

  /*!
    \brief Gets the intrinsic declaration type for the net

    The intrinsic type is one of the types defined in the STD or IEEE
    libraries. These include bit, std_logic, std_ulogic, character,
    integer, natural and positive. It also includes array types like
    bit_vector (array of bits), std_logic_vector (array of std_logic),
    std_ulogic_vector (array of std_ulogic) and string (array of chars).
    For arrays of other VHDL types, and for multidimensional arrays
    this method will return "VhdlUnknown".

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.

   */
  const char* carbonDBIntrinsicType(const CarbonDB* dbContext,
				    const CarbonDBNode* node);


  /*!
    \brief Gets the declaration type for the net.

    The declaration type is as close as possible to the original HDL
    declaration type. This is reasonably accurate for Verilog, but it
    is much simplified for VHDL.
   */
  const char* carbonDBdeclarationType(const CarbonDB* dbContext,
                                      const CarbonDBNode* node);

  /*!
    \brief Gets the Library Name where the type is compiled.
   */
  const char* carbonDBtypeLibraryName(const CarbonDB* dbContext,
                                      const CarbonDBNode* node);

  /*!
    \brief Gets the Package Name where the type is compiled.
   */
  const char* carbonDBtypePackageName(const CarbonDB* dbContext,
                                      const CarbonDBNode* node);


  /*!
    \brief Gets the component name for a branch node in the symbol table

    The component name is either the module or architecture name for
    the given instance. If this routine is called on a leaf node NULL
    is returned.
   */
  const char* carbonDBComponentName(const CarbonDB* dbContext,
                                    const CarbonDBNode* node);

  /*!
    \brief Gets the source language for the given symbol table node

    The source language is stored in all the branch nodes in the
    symbol table. This represents the HDL for that given architecture
    or module. A net gets its language from its parent scope.

    This function returns one of either "VHDL" or "Verilog"
  */
  const char* carbonDBSourceLanguage(const CarbonDB* dbContext,
                                     const CarbonDBNode* node);
  /*!
    \brief Get the pull mode for a an HDL signal

    The pull mode indicates whether the given bidirect is pulled down,
    up or not pulled at all. This information is needed to resolve the
    value of a bidirect.

    This functions returns one of either "pullup", "pulldown", or "none"
   */
  const char* carbonDBGetPullMode(const CarbonDB* dbContext,
                                  const CarbonDBNode* node);
  /*!
    \brief Get the database type

    The ARM CycleModels model comes with both a full database and a smaller I/O
    database. This function returns which database is currently loaded.

    This functions returns one of: "FullDB", "IODB", "GuiDB".
   */
  const char* carbonDBGetType(const CarbonDB* dbContext);

  /*!
    \brief Is this node a temp net

    The compiler sometimes creates temporary nets to store persistent
    values. In general these should not appear in a database. However,
    some may appear due to primary port splitting. This routine can
    confirm one of those cases.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest.
    \retval 1 If the node is a temp
    \retval 0 If the node is not a temp
  */
  int carbonDBIsTemp(const CarbonDB* dbContext,
                     const CarbonDBNode* node);


  // SWIG doesn't follow the #includes
#ifndef UNUSED
#define UNUSED /*nothing*/
#endif
#ifndef DEPRECATED
#define DEPRECATED /*nothing*/
#endif
#ifndef INLINE
#define INLINE inline
#endif

  /*!
    \brief DEPRECATED
  */
  static INLINE
  int carbonDBIsReplayable(const CarbonDB* dbContext) DEPRECATED;
  static INLINE
  int carbonDBIsReplayable(const CarbonDB* dbContext UNUSED) {
    return 0;
  }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  int carbonDBSupportsOnDemand(const CarbonDB* dbContext) DEPRECATED;
  static INLINE
  int carbonDBSupportsOnDemand(const CarbonDB* dbContext UNUSED) {
    return 0;
  }

  /*!
    \brief Does this node trigger a schedule on its positive edge?

    \note Only primary inputs or nets marked depositable
    can return non-zero. Their aliases cannot.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest
    \retval 1 If a 0->1 transition causes a schedule to run.
    \retval 0 If a 0->1 transition does not a cause a schedule to run.
  */
  int carbonDBIsPosedgeTrigger(const CarbonDB* dbContext,
                               const CarbonDBNode* node);

  /*!
    \brief Does this node trigger a schedule on its negative edge?

    \note Only primary inputs or nets marked depositable
    can return non-zero. Their aliases cannot.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest
    \retval 1 If a 1->0 transition causes a schedule to run.
    \retval 0 If a 1->0 transition does not a cause a schedule to run.
  */
  int carbonDBIsNegedgeTrigger(const CarbonDB* dbContext,
                               const CarbonDBNode* node);

  /*!
    \brief Does this node trigger a schedule on any edge?

    \note Only primary inputs or nets marked depositable
    can return non-zero. Their aliases cannot.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest
    \retval 1 If any transition causes a schedule to run.
    \retval 0 If any transition does not a cause a schedule to run.
  */
  int carbonDBIsBothEdgeTrigger(const CarbonDB* dbContext,
                                const CarbonDBNode* node);

  /*!
    \brief Does this node trigger a schedule and feed a data path?

    A node that feeds a data path must always be kept up to date so
    that async paths always have the correct value.

    \note Only primary inputs or nets marked depositable
    can return non-zero. Their aliases cannot.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest
    \retval 1 If this is a schedule trigger and feeds a data path.
    \retval 0 If this is not a schedule trigger or does not feed a
    data path.
  */
  int carbonDBIsTriggerUsedAsData(const CarbonDB* dbContext,
                                  const CarbonDBNode* node);

  /*!
    \brief Is this node a primary input, bidi, or depositable that feeds live
    logic?

    \note A primary bidi is considered both a primary input and a
    primary output.

    If a logical path beginning at a primary input or depositable was
    found to be dead logic then the fanout of this node is not
    live. If the node is a trigger it is considered live.

    \note Only primary inputs or nets marked depositable
    can return non-zero. Their aliases cannot.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest
    \retval 1 If this is a depositable or primary input that feeds
    live logic.
    \retval 0 If this not a primary input or depositable, or if it is
    does not feed live logic.
  */
  int carbonDBIsLiveInput(const CarbonDB* dbContext,
                          const CarbonDBNode* node);

  /*!
    \brief Is this node a primary output, bidi or observable driven by live
    logic?

    \note A primary bidi is considered both a primary input and a
    primary output.

    If a logical path ending at a primary output or observable was
    found to be dead logic then the fanin to this node is not live.

    \note Only primary outputs or nets marked observable
    can return non-zero. Their aliases cannot.

    \param dbContext The database object created from carbonDBCreate.
    \param node The design net of interest
    \retval 1 If this is an observable or primary outputs that is driven
    by live logic.
    \retval 0 If this not a primary output or observable, or if it is
    it is not driven
  */

  int carbonDBIsLiveOutput(const CarbonDB* dbContext,
                           const CarbonDBNode* node);


  /*!
    \brief DEPRECATED
  */
  static INLINE
  int carbonDBIsOnDemandIdleDeposit(const CarbonDB* dbContext,
                                    const CarbonDBNode* node) DEPRECATED;
  static INLINE
  int carbonDBIsOnDemandIdleDeposit(const CarbonDB* dbContext UNUSED,
                                    const CarbonDBNode* node UNUSED) {
    return 0;
  }

  /*!
    \brief DEPRECATED
  */
  static INLINE
  int carbonDBIsOnDemandExcluded(const CarbonDB* dbContext,
                                 const CarbonDBNode* node) DEPRECATED;
  static INLINE
  int carbonDBIsOnDemandExcluded(const CarbonDB* dbContext UNUSED,
                                 const CarbonDBNode* node UNUSED) {
    return 0;
  }

  /*!
    \brief Is this node a structure?

    Returns whether the node represents a structure (e.g. a VHDL record)
    as defined in the RTL.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \retval 1 If the node is a structure
    \retval 0 If the node is not a structure
  */

  int carbonDBIsStruct(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Is this node an array?

    Returns whether the node represents an array as defined in the
    RTL.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \retval 1 If the node is an array
    \retval 0 If the node is not an array
  */

  int carbonDBIsArray(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Is this node an enumeration?

    Returns whether the node represents an enumeration as defined in the
    RTL.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \retval 1 If the node is an enumeration
    \retval 0 If the node is not an enumeration
  */

  int carbonDBIsEnum(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns Number of elements in custom enumerarion

    Returns Number of elements in custom enumerarion as defined in the RTL.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \retval Number of elements in the enumeration
    \retval 0 If the node is not an enumeration
  */

  int carbonDBGetNumberElemInEnum(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns element of custom enumerarion

    Returns element index of custom enumeration as defined in the RTL.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \param index The index of enumeration element to be returned..
    \retval The enumeration element.
    \retval NULL If the node is not an enumeration, or the index is out of range
  */

  const char* carbonDBGetEnumElem(const CarbonDB* dbContext, const CarbonDBNode* node, int index);

  /*!
    \brief Returns the number of fields in a structure.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The number of fields, if the node is a structure. If the node is not a structure, then -1 is returned.
  */

  int carbonDBGetNumStructFields(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns a field of a structure.

    Returns a node representing a field of a structure.  The name is
    only the name of the field itself, excluding its parent hierarchy.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \param name The name of the field.
    \returns The node representing the field, if it exists. If the field does not exist, then NULL is returned.
  */

  const CarbonDBNode* carbonDBGetStructFieldByName(CarbonDB* dbContext, const CarbonDBNode* node, const char* name);

  /*!
    \brief Returns the left bound of an array.

    Returns the left bound of an array's range as declared in the RTL.
    For multi-dimensional arrays, the range of the outermost dimension
    is used.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The left array bound, if the node is an array. If the node is not an array, then -1 is returned.
  */

  int carbonDBGetArrayLeftBound(const CarbonDB* dbContext, const CarbonDBNode* node);


  /*!
    \brief Returns the right bound of an array.

    Returns the right bound of an array's range as declared in the
    RTL.  For multi-dimensional arrays, the range of the outermost
    dimension is used.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The right array bound, if the node is an array. If the node is not an array, then -1 is returned.
  */

  int carbonDBGetArrayRightBound(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns the number of dimensions of an array.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The number of dimensions, if the node is an array. If the node is not an array, then -1 is returned.
  */

  int carbonDBGetArrayDims(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns an element of an array.

    Returns a node representing an element of an array.  Multiple
    indices can be specified at once for easier navigation of
    multi-dimensional arrays.  If the number of dimensions provided is
    less than the number of dimensions in the array, the element
    returned will represent the remaining dimensions.  For example, if
    two dimensions are specified for a three-dimensional array, the
    element will represent the inner one-dimensional array after the
    two specified dimensions are applied.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \param indices A pointer to an array of indexes, with the outermost dimension at offset 0.
    \param dims The number of dimensions specified in the the index array.
    \returns The node representing the element, if it exists. If the element does not exist, then NULL is returned.
  */

  const CarbonDBNode* carbonDBGetArrayElement(CarbonDB* dbContext, const CarbonDBNode* node, const int* indices, int dims);


  /*!
    \brief Returns the left bound of an array.

    Returns the left bound of an array's range for the dimension dim as declared in the RTL.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \param dim is the dimension for which it returns the left bound.
    \returns The left array bound, if the node is an array. If the node is not an array, or dim is out of
     the range, then -1 is returned.
  */

  int carbonDBGetArrayDimLeftBound(const CarbonDB* dbContext, const CarbonDBNode* node, int dim);

  /*!
    \brief Returns the right bound of an array.

    Returns the right bound of an array's range for the dimension dim as declared in the RTL.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \param dim is the dimension for which it returns the right bound.
    \returns The right array bound, if the node is an array. If the node is not an array, or dim is out of
     the range, then -1 is returned.
  */
  int carbonDBGetArrayDimRightBound(const CarbonDB* dbContext, const CarbonDBNode* node, int dim);


  /*!
    \brief Returns the number of dimensions of a declared array. It could be an array of nets or structures.
    There is difference between this function and the function carbonDBGetArrayDims. For example, for vhdl type
    of array of arrays of bit, this function returns 1, but the function carbonDBGetArrayDims returns 2.
    For multirange arrays, like array(range1, range2) of bit. This function returns 2, as the other one.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The number of dimensions, if the node is an array. If the node is not an array, then -1 is returned.
  */
  int carbonDBGetArrayNumDeclaredDims(const CarbonDB* dbContext, const CarbonDBNode* node);


  /*!
    \brief Returns a net handle for a database node.

    Returns a CarbonNetID for a database node.  This can be done only
    if the database corresponds to an existing ARM CycleModels Model.  Calling
    this function on a standalone database (i.e. one created with
    carbonDBCreate) will result in an error.

    The node must represent either a scalar or a one-dimensional array
    in order for a net to be returned.  Also, a net may not be returned
    if the specified node is not represented in the design due to
    optimization.  Refer to the documentation on ARM CycleModels compiler
    directives to ensure the API availability of design nodes.

    \sa carbonDBCanBeCarbonNet

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The net handle for the node, if it exists. If the node does not exist, then NULL is returned.
  */

  CarbonNetID* carbonDBGetCarbonNet(CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns if a node can be a CarbonNetID.

    Returns whether a CarbonNetID can be created for the specified
    CarbonDBNode.  Unlike carbonDBGetCarbonNet, this can be called
    with a standalone database (one created with carbonDBCreate).

    \sa carbonDBGetCarbonNet

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \retval 1 If the node can be a CarbonNetID
    \retval 0 If the node can not be a CarbonNetID
  */

  int carbonDBCanBeCarbonNet(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns the bit size of a CarbonDBNode.

    Returns the aggregate bit size of a CarbonDBNode.  If the node is
    a scalar, its size is the number of bits required to represent it.
    For example, a bit has a size of 1, and an integer has a size of
    32.  If the node is a structure, the size is the sum of the sizes
    of each of its fields.  If the node is an array, the size is the
    product of the number of elements and a single element's size.

    The size of any other type of node (for example, a module
    instance) is 0.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The bit size of the node.
  */

  int carbonDBGetBitSize(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns the left bound of a range constraint of a CarbonDBNode.

    Return the left bound of a range constraint of a scalar type. It's only used for
    subtypes of integer in vhdl.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The left bound of a range constraint of a node.
  */

  int carbonDBGetRangeConstraintLeftBound(const CarbonDB* dbContext, const CarbonDBNode* node);


  /*!
    \brief Returns the right bound of a range constraint of a CarbonDBNode.

    Return the right bound of a range constraint of a scalar type. It's only used for
    subtypes of integer in vhdl.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The right bound of a range constraint of a node.
  */

  int carbonDBGetRangeConstraintRightBound(const CarbonDB* dbContext, const CarbonDBNode* node);


  /*!
    \brief Returns 1 when initial declaration of this array requires range declaration, otherwise 0.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns 1 when initial declaration of this array requires range declaration.

  */
  int carbonDBIsRangeRequiredInDeclaration(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns the name of the source file in which a node is defined.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The source file name.
  */

  const char* carbonDBGetSourceFile(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns the source file line on which a node is defined.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \returns The source file line number.
  */

  int carbonDBGetSourceLine(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns whether a node is contained by a composite.

    Returns whether a node is contained by a composite node type,
    for example, an array or a structure.

    \param dbContext The database object for the design.
    \param node The design node of interest.
    \retval 1 If the node is contained by a composite
    \retval 0 If the node is not contained by a composite
  */

  int carbonDBIsContainedByComposite(const CarbonDB* dbContext, const CarbonDBNode* node);

  /*!
    \brief Returns a string attribute stored in the database

    Returns the value of a string attribute from the database.

    The string is valid only until the next call to this function, so
    if you need to look up multiple attributes, you must copy the
    strings to user-owned storage first.

    \param dbContext The database object for the design.
    \param attributeName The attribute name.
    \returns The value of the attribute, if it exists. If the attribute does not exist, NULL is returned.
  */

  const char* carbonDBGetStringAttribute(const CarbonDB* dbContext, const char* attributeName);

  /*!
    \brief Returns an integer attribute stored in the database

    Returns the value of an integer attribute from the database.

    \param dbContext The database object for the design.
    \param attributeName The attribute name.
    \param attributeValue Pointer to storage for returning the attribute's value
    \retval eCarbon_OK if the attribute exists
    \retval eCarbon_Error if the attribute does not exist
  */

  int carbonDBGetIntAttribute(const CarbonDB* dbContext, const char* attributeName, CarbonUInt32* attributeValue);

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

    \li carbonDBIsReplayable
    \li carbonDBSupportsOnDemand
    \li carbonDBIsOnDemandIdleDeposit
    \li carbonDBIsOnDemandExcluded

    @} */

#endif
