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
#include <stdint.h>

#ifndef __carbon_shelltypes_h_
#define __carbon_shelltypes_h_

#ifndef __CarbonPlatform_h_
#include "carbon/CarbonPlatform.h"
#endif

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

#ifndef __carbon_model_h_
struct carbon_model_descr;            // external definition
#endif

/*!
  \file
  The most basic types used by the ARM CycleModels API.
*/

/*!
  \defgroup ShellTypes Shell Types
  \brief All shell types are \e automatically included when libdesign.h
  is referenced in your testbench.
*/
/*!
  \defgroup Typed Typedefs
  \ingroup ShellTypes
  \brief Typedefs that can be used by any interface function.
*/

/*!
  \defgroup Enums Enumerations
  \ingroup ShellTypes
  \brief Enumerations that can be used by any interface function.
*/



/*!
  \brief Types of simulation control callbacks that can be registered

  \ingroup Enums

  This enumeration is used with CarbonControlCBFunction to
  identify the reason a particular callback was called.
*/
typedef enum {
  eCarbonStop,     /*!< for verilog $stop */
  eCarbonFinish,   /*!< for verilog $finish */
  eCarbonSave,     /*!< for call to carbonSave */
  eCarbonRestore   /*!< for call to carbonRestore */
} CarbonControlType;



/*!
  \addtogroup Typed
  @{
*/

/*! \brief 1 byte signed */
typedef char CarbonSInt8;
/*! \brief 1 byte unsigned */
typedef unsigned char CarbonUInt8;
/*! \brief 2 bytes signed */
typedef short CarbonSInt16;
/*! \brief 2 bytes unsigned */
typedef unsigned short CarbonUInt16;
/*! \brief 4 bytes signed */
typedef int CarbonSInt32;
/*! \brief 4 bytes unsigned */
typedef unsigned int CarbonUInt32;

typedef uint64_t CarbonUInt64;
typedef int64_t CarbonSInt64;

typedef CarbonUInt64 CarbonUIntPtr;
typedef CarbonSInt64 CarbonSIntPtr;

#ifndef CARBON_EXTERNAL_DOC
typedef CarbonUInt8  CarbonUInt1;
typedef CarbonUInt8  CarbonUInt2;
typedef CarbonUInt8  CarbonUInt3;
typedef CarbonUInt8  CarbonUInt4;
typedef CarbonUInt8  CarbonUInt5;
typedef CarbonUInt8  CarbonUInt6;
typedef CarbonUInt8  CarbonUInt7;

typedef CarbonUInt16  CarbonUInt9;
typedef CarbonUInt16  CarbonUInt10;
typedef CarbonUInt16  CarbonUInt11;
typedef CarbonUInt16  CarbonUInt12;
typedef CarbonUInt16  CarbonUInt13;
typedef CarbonUInt16  CarbonUInt14;
typedef CarbonUInt16  CarbonUInt15;

typedef CarbonUInt32  CarbonUInt17;
typedef CarbonUInt32  CarbonUInt18;
typedef CarbonUInt32  CarbonUInt19;
typedef CarbonUInt32  CarbonUInt20;
typedef CarbonUInt32  CarbonUInt21;
typedef CarbonUInt32  CarbonUInt22;
typedef CarbonUInt32  CarbonUInt23;
typedef CarbonUInt32  CarbonUInt24;
typedef CarbonUInt32  CarbonUInt25;
typedef CarbonUInt32  CarbonUInt26;
typedef CarbonUInt32  CarbonUInt27;
typedef CarbonUInt32  CarbonUInt28;
typedef CarbonUInt32  CarbonUInt29;
typedef CarbonUInt32  CarbonUInt30;
typedef CarbonUInt32  CarbonUInt31;

typedef CarbonUInt64  CarbonUInt33;
typedef CarbonUInt64  CarbonUInt34;
typedef CarbonUInt64  CarbonUInt35;
typedef CarbonUInt64  CarbonUInt36;
typedef CarbonUInt64  CarbonUInt37;
typedef CarbonUInt64  CarbonUInt38;
typedef CarbonUInt64  CarbonUInt39;
typedef CarbonUInt64  CarbonUInt40;
typedef CarbonUInt64  CarbonUInt41;
typedef CarbonUInt64  CarbonUInt42;
typedef CarbonUInt64  CarbonUInt43;
typedef CarbonUInt64  CarbonUInt44;
typedef CarbonUInt64  CarbonUInt45;
typedef CarbonUInt64  CarbonUInt46;
typedef CarbonUInt64  CarbonUInt47;
typedef CarbonUInt64  CarbonUInt48;
typedef CarbonUInt64  CarbonUInt49;
typedef CarbonUInt64  CarbonUInt50;
typedef CarbonUInt64  CarbonUInt51;
typedef CarbonUInt64  CarbonUInt52;
typedef CarbonUInt64  CarbonUInt53;
typedef CarbonUInt64  CarbonUInt54;
typedef CarbonUInt64  CarbonUInt55;
typedef CarbonUInt64  CarbonUInt56;
typedef CarbonUInt64  CarbonUInt57;
typedef CarbonUInt64  CarbonUInt58;
typedef CarbonUInt64  CarbonUInt59;
typedef CarbonUInt64  CarbonUInt60;
typedef CarbonUInt64  CarbonUInt61;
typedef CarbonUInt64  CarbonUInt62;
typedef CarbonUInt64  CarbonUInt63;
#endif

/*! \brief Type used to specify time. */
typedef CarbonUInt64 CarbonTime;

/*! \brief Type used for real numbers */
typedef double CarbonReal;

/*! \brief union used to for Verilog $realtobits and $bitstoreal conversion  */
union CarbonRealToBitsUnion {
  CarbonReal r;
  CarbonUInt64     i64;
};

/*!
  \brief CarbonObject reference structure.

  The CarbonObjectID provides the context for a design and is used to
  to run the design's core function(s). The CarbonObjectID is created
  by calling the external C function:

  <tt>CarbonObjectID* hdl carbon_<design>_create (CarbonDBType{}, CarbonInitFlags{})</tt>

  where design is the name of the original design name (as compiled by
  the ARM CycleModels compiler). The CarbonObjectID may be used in conjunction with other
  reference structures.
*/
typedef struct carbon_model_descr CarbonObjectID;

#ifndef CARBON_EXTERNAL_DOC
/*!
  \brief For backwards compatibility.
  \internal
*/
typedef CarbonObjectID CarbonObject;
#endif

/*!
  \brief CarbonNet reference structure.

  The CarbonNetID contains only intrinsic information about a net, and
  therefore must be used in conjunction with CarbonObjectID in order to
  access extrinsic properties.
*/
typedef STRUCT CarbonNet CarbonNetID;

/*!
  \brief Type to pass user-supplied data to interface.
*/
typedef void* CarbonClientData;

/*!
  \brief User function for net-related callbacks.

  The first CarbonUInt32* is the new value.
  The second CarbonUInt32* is the new drive.
*/
typedef void (*CarbonNetValueCB)(CarbonObjectID*, CarbonNetID*, CarbonClientData, CarbonUInt32*, CarbonUInt32*);

/*!
  \brief CarbonNet callback reference structure.

  This type is used with control functions to provide easy access to
  defined callbacks.
*/
typedef STRUCT CarbonNetValueCBData CarbonNetValueCBDataID;


/*! Prototype for a simulation control callback function

  If registered, this user defined function is called when a $stop or
  $finish is simulated.

  \param clientData user defined data specified when this function is registered.

  The remainder of the arguments are used to identify the reason the
  CarbonControlCBFunction was called.
  \param carbonObject the ARM Cycle Models model that was being simulated when the
  callback function was called.
  \param callbackType the type of sim control function that was being
  simulated when the callback function was called. (provided so a
  single function can be used for both stop and finish)
  \param verilogFilename  source filename for the $stop or $finish that
  caused the callback function to be called.
  \param verilogLineNumber source linenumber for the $stop or $finish.

  \note carbonTime is not provided as an argument to the callback, the time is
  available via carbonGetSimulationTime.

  \sa carbonGetSimulationTime
*/
typedef void (*CarbonControlCBFunction)(CarbonObjectID* carbonObject,
                                        CarbonControlType callbackType,
                                        CarbonClientData clientData,
                                        const char* verilogFilename,
                                        int verilogLineNumber);




/*! \brief Reference to a registered callback function.
 *
 * This is returned by the registration function, and must be
 * specified when removing a registered function.
 */
typedef STRUCT RegisteredControlCBData CarbonRegisteredControlCBDataID;


/*!
  \brief Enumeration for message severities

  \ingroup Enums

  This enumeration corresponds to the severities of messages issued by
  ARM CycleModels products.
*/
typedef enum {
  eCarbonMsgStatus,    /*!< status message */
  eCarbonMsgNote,      /*!< Note message */
  eCarbonMsgWarning,   /*!< Warning message */
  eCarbonMsgError,     /*!< Error message */
  eCarbonMsgFatal,     /*!< Fatal error message */
  eCarbonMsgSuppress,  /*!< Suppressed message */
  eCarbonMsgAlert      /*!< Demotable Error message */
} CarbonMsgSeverity;

/*!
  \brief Enumeration for message callback function return values.

  \ingroup Enums

  This value is returned by the callback function to indicate whether any
  more message handler callbacks should be invoked.
*/
typedef enum {
  eCarbonMsgContinue, /*!< Invoke the next registered callback. */
  eCarbonMsgStop      /*!< Do not invoke any more callbacks. */
} eCarbonMsgCBStatus;


/*!
  \brief Enumeration for behavior given different directory
  scenarios.

  Some API functions may need to read/write to directories. In the
  case where a directory needs to be written, this helps specify how
  the ARM Cycle Models model should behave -- whether or not to overwrite the existing
  directory.
*/
typedef enum {
  eCarbonDirOverwrite, /*!< Overwrite an existing directory */
  eCarbonDirNoOverwrite /*!< Do not overwrite an existing directory */
} CarbonDirAction;

/*!
  \brief DEPRECATED
*/
typedef enum {
  eCarbonRunNormal, /*!< Normal operation */
  eCarbonRunRecord, /*!< Now unused: Record mode */
  eCarbonRunPlayback, /*!< Now unused: Playback mode */
  eCarbonRunRecover /*!< Now unused: Recover mode */
} CarbonVHMMode;

/*!
  \brief Enumeration for the system read command line function result

  The carbonSystemReadCmdline function can return three values, data
  has changed, data has not changed, and an error if the data was
  invalid. This enum describes those return values.
*/
typedef enum {
  eCarbonSystemChanged,   /*!< The command file changed and was read in */
  eCarbonSystemUnchanged, /*!< The command file was not changed and not read in */
  eCarbonSystemCmdError   /*!< An invalid command was found during parsing */
} CarbonSystemReadCmdlineStatus;

/*!
  \brief Enumeration for the replay read command line function result

  \deprecated{ Please use the Carbon System API which uses the type
  CarbonSystemReadCmdlineStatus }

  The carbonSystemReadCmdline function can return three values, data
  has changed, data has not changed, and an error if the data was
  invalid. This enum describes those return values.
*/
typedef enum {
  eCarbonReplayChanged = eCarbonSystemChanged,
  eCarbonReplayUnchanged = eCarbonSystemUnchanged,
  eCarbonReplayCmdError = eCarbonSystemCmdError
} CarbonReplayReadCmdlineStatus;

/*!
  \brief DEPRECATED
*/
typedef enum {
  eCarbonOnDemandLooking,       //!< Looking for an idle repeating state
  eCarbonOnDemandIdle,          //!< In an idle repeating state
  eCarbonOnDemandBackoff,       //!< In a backoff state after a failed attempt
  eCarbonOnDemandStopped        //!< Temporarily stopped
} CarbonOnDemandMode;

/*!
  \brief DEPRECATED
*/
typedef enum {
  eCarbonOnDemandBackoffConstant        = 0x0,    //!< Constant backoff count
  eCarbonOnDemandBackoffDecay           = 0x1,    //!< Decaying backoff count
  eCarbonOnDemandBackoffModeMask        = 0x3,    //!< Mask for mode flags
  eCarbonOnDemandBackoffNonIdleRestart  = 0x4     //!< Flag to restart counter on all non idle events
} CarbonOnDemandBackoffStrategy;

/*!
  \brief DEPRECATED
*/
typedef enum {
  eCarbonOnDemandDebugNone,             //!< No debug events are reported
  eCarbonOnDemandDebugIdle,             //!< Debug events during idle and looking modes are reported
  eCarbonOnDemandDebugAll               //!< All debug events are reported
} CarbonOnDemandDebugLevel;

/*!
  \brief DEPRECATED
*/
typedef enum {
  eCarbonOnDemandDebugNonIdleNet,       //!< Deposit to a net that is not in the idle set
  eCarbonOnDemandDebugNonIdleChange,    //!< Model state change that is not allowed when idle
  eCarbonOnDemandDebugRestore,          //!< Model state restore
  eCarbonOnDemandDebugDiverge,          //!< Divergence from expected stimulus
  eCarbonOnDemandDebugFail              //!< Failed idle state detection
} CarbonOnDemandDebugType;

/*!
  \brief DEPRECATED
*/
typedef enum {
  eCarbonOnDemandDebugAPI,              //!< API call
  eCarbonOnDemandDebugInternal,         //!< Internal model exection
  eCarbonOnDemandDebugCModel            //!< Cmodel implementation
} CarbonOnDemandDebugAction;

/*!
  \brief CarbonMsg callback reference structure.

  An instance of this data is returned by carbonAddMsgCB, and used to
  identify the callback to unregister when calling carbonRemoveMsgCB.
*/
typedef STRUCT CarbonMsgCBData CarbonMsgCBDataID;

/*!
  \brief Prototype for a message callback function

  If registered, this user-defined function is called when a message is
  reported by the model.

  \param clientData User-defined data specified when this function is registered.
  \param severity The severity of the message.
  \param number The unique message number for the message being reported.
  \param text The text of the message.
  \param len The length (in bytes) of the message text.
*/
typedef eCarbonMsgCBStatus (*CarbonMsgCB)(CarbonClientData clientData,
                                          CarbonMsgSeverity severity,
                                          int number,
                                          const char* text,
                                          unsigned int len);

/*!
  \brief Prototype for a stream read callback function.

  Stream read callbacks are used by carbonStreamRestore to allow
  the model state to be restored from a user-supplied stream.

  \param userContext A pointer to user-provided information that will
  be used by the callback function to read the data. For example, this
  might be a the FILE pointer of the input stream.

  \param data A buffer into which to store the data from the input
  stream.  This buffer will be numBytes in size.

  \param numBytes The number of bytes to read.

  \retval The number of bytes actually read.
*/
typedef CarbonUInt32 (*CarbonStreamReadFunc)(void *userContext,
                                       void *data,
                                       CarbonUInt32 numBytes);

/*!
  \brief Prototype for a stream write callback function.

  Stream write callbacks are used by carbonStreamSave to allow the
  model state to be saved to a user-supplied stream.

  \param userContext A pointer to user-provided information that will
  be used by the callback function to write the data. For example,
  this might be a the FILE pointer of the output stream.

  \param data A pointer to the data to be written.
  \param numBytes The number of bytes to write.

  \retval The number of bytes actually written.
*/
typedef CarbonUInt32 (*CarbonStreamWriteFunc)(void *userContext,
                                        const void *data,
                                        CarbonUInt32 numBytes);

/*!
  \brief DEPRECATED
*/
typedef void (*CarbonModeChangeCBFunc)(CarbonObjectID* context,
                                     void* userContext,
                                     CarbonVHMMode current,
                                     CarbonVHMMode changingTo);

/*!
  \brief DEPRECATED
*/
typedef void (*CarbonCheckpointCBFunc)(CarbonObjectID* context,
                                       void* userContext,
                                       CarbonUInt64 totalScheduleCalls,
                                       CarbonUInt32 checkpointNumber);

  /*!
    \brief DEPRECATED
   */
typedef void (*CarbonOnDemandModeChangeCBFunc)(CarbonObjectID* context,
                                               void* userContext,
                                               CarbonOnDemandMode from,
                                               CarbonOnDemandMode to,
                                               CarbonTime simTime);

  /*!
    \brief DEPRECATED
   */
typedef void (*CarbonOnDemandDebugCBFunc)(CarbonObjectID* context,
                                          void* userContext,
                                          CarbonTime simTime,
                                          CarbonOnDemandDebugType type,
                                          CarbonOnDemandDebugAction action,
                                          const char *path,
                                          CarbonUInt32 length);

/*!
  \brief DEPRECATED
*/
typedef STRUCT CarbonOnDemandCBData CarbonOnDemandCBDataID;

/*!
  \brief DEPRECATED
*/
typedef STRUCT CarbonReplayCBData CarbonReplayCBDataID;

/*!
  \brief CarbonMemory reference structure.

  CarbonMemoryIDs hold data and therefore may be used without
  context, i.e., CarbonObjectID.
*/
typedef STRUCT CarbonMemory CarbonMemoryID;

/*!
  \brief CarbonWave reference structure.

  This type is used to provide context for signal waveform dumping.
*/
typedef STRUCT CarbonWave CarbonWaveID;

/*!
  \brief CarbonMemFileID reference structure.

  This type is used to provide encapsulation for reading and using a
  memory data file.
*/
typedef STRUCT CarbonMemFile CarbonMemFileID;

/*!
  \brief CarbonWaveUserDataID reference structure

  This type is used for adding user-defined data to fsdb waveforms.
*/
typedef STRUCT CarbonWaveUserData CarbonWaveUserDataID;

/*!
  \brief Logic value array type

  This type is used for logic value types fro user-defined data added
  to fsdb waveforms.
*/
typedef unsigned char CarbonLogicByteType;

  /*!
    \brief ARM CycleModels database object reference structure

    The CarbonDB provides the context for accessing design
    information that was compiled by the ARM CycleModels compiler.
  */
  typedef STRUCT CarbonDatabase CarbonDB;

  /*!
    \brief ARM CycleModels database node object

    Object representing a ARM CycleModels database node. It represents a signal
    and associated data.
  */
  typedef STRUCT CarbonDatabaseNode CarbonDBNode;

  /*!
    \brief ARM CycleModels database node iterator

    The database contains nodes, which are objects that represent the
    signal and related information.. This object iterates through
    sets of nodes.
  */
  typedef STRUCT CarbonDatabaseNodeIter CarbonDBNodeIter;

/*! @} */ /*  end of addtogroup Typed  */

/*!
  \addtogroup Deprecated_Types
  @{
*/

/*!
  \brief DEPRECATED User function for net-related callbacks.

  Use CarbonNetValueCB
*/
typedef void (*CarbonNetCB)(CarbonObjectID*, CarbonNetID*, CarbonClientData);

/*!
  \brief DEPRECATED CarbonNet callback reference structure.

  Use CarbonNetValueCBDataID
*/
typedef STRUCT CarbonNetCBData CarbonNetCBDataID;

/*! @} */ /*  end of addtogroup Deprecated_Types  */


/*!
  \addtogroup Enums
  @{
*/

/*!
  \brief General return status of ARM CycleModels API functions.
*/
typedef enum {
  eCarbon_OK,    /*!< The function successfully completed. */
  eCarbon_ERROR, /*!< An error occured during the function's operation. */
  eCarbon_STOP,  /*!< A $stop system task has interrupted execution. */
  eCarbon_FINISH /*!< A $finish system task has interrupted execution. */
} CarbonStatus;

/*!
  \brief Enumeration for defining ARM Cycle Models model database usage.

  This enumeration is used when a CarbonObjectID is created with the
  external C function: <tt>carbon_<design>_create()</tt>. You may
  access the model's entire database, or a subset of the database that
  includes only those I/Os marked as observable (deposit and examine).

  \note If you intend to dump signal waveforms recursively for the
  design, you \e must specify eCarbonFullDB when creating the
  CarbonObjectID.
*/
typedef enum {
  eCarbonFullDB,                        /*!< The model's complete database. */
  eCarbonIODB,                          /*!< Only the primary I/Os and observables of the model */
  eCarbonGuiDB,                         /*!< The early-dumped database for the GUI */
  eCarbonAutoDB                         /*!< The full database, if available, otherwise the IO database */
} CarbonDBType;


/*!
  \brief Enumeration for selecting signal waveform output format.

  This enumeration is used with wave functions to define the format
  of the generated waveforms--standard Verilog VCD and Debussy's FSDB
  format are supported.
*/
typedef enum {
  eWaveFileTypeVCD, /*!< Verilog VCD format. */
  eWaveFileTypeFSDB  /*!< Debussy's FSDB format. */
} CarbonWaveFileType;


/*!
  \brief Enumeration for pull modes on a net
*/
typedef enum {
  eCarbonPullUp, /*!< Net is pulled up. */
  eCarbonPullDown, /*!< Net is pulled down. */
  eCarbonNoPull /*!< Net is not pulled */
} CarbonPullMode;

/*!
  \brief Enumeration for signal/variable directions.
*/
typedef enum {
  eCarbonVarDirectionImplicit, /*!< Direction is unknown */
  eCarbonVarDirectionInput, /*!< Input direction*/
  eCarbonVarDirectionOutput, /*!< Output direction*/
  eCarbonVarDirectionInout, /*!< Inout direction */
  eCarbonVarDirectionBuffer, /*!< Buffer */
  eCarbonVarDirectionLinkage /*!< Linkage */
} CarbonVarDirection;

/*!
  \brief Bit values used to represent FSDB values.

  These are directly translated to fsdbBitType and are used for
  user-defined wave data.
*/
typedef enum {
  eCARBON_BT_VCD_0 = 0, /*!< VCD 0 */
  eCARBON_BT_VCD_1 = 1, /*!< VCD 1 */
  eCARBON_BT_VCD_X = 2, /*!< VCD X */
  eCARBON_BT_VCD_Z = 3, /*!< VCD Z */

  /* for extended vcd format */
  eCARBON_BT_EVCD_L = 0, /*!< EVCD L */
  eCARBON_BT_EVCD_l = 1, /*!< EVCD l */
  eCARBON_BT_EVCD_H = 2, /*!< EVCD H */
  eCARBON_BT_EVCD_h = 3, /*!< EVCD h */
  eCARBON_BT_EVCD_X = 4, /*!< EVCD X */
  eCARBON_BT_EVCD_x = 5, /*!< EVCD x */
  eCARBON_BT_EVCD_T = 6, /*!< EVCD T */
  eCARBON_BT_EVCD_D = 7, /*!< EVCD D */
  eCARBON_BT_EVCD_d = 8, /*!< EVCD d */
  eCARBON_BT_EVCD_U = 9, /*!< EVCD U */
  eCARBON_BT_EVCD_u = 10, /*!< EVCD u */
  eCARBON_BT_EVCD_N = 11, /*!< EVCD N */
  eCARBON_BT_EVCD_n = 12, /*!< EVCD n */
  eCARBON_BT_EVCD_Z = 13, /*!< EVCD Z */
  eCARBON_BT_EVCD_QSTN = 14, /*!< EVCD QSTN */
  eCARBON_BT_EVCD_0 = 15, /*!< EVCD 0 */
  eCARBON_BT_EVCD_1 = 16, /*!< EVCD 1 */
  eCARBON_BT_EVCD_A = 17, /*!< EVCD A */
  eCARBON_BT_EVCD_a = 18, /*!< EVCD a */
  eCARBON_BT_EVCD_B = 19, /*!< EVCD B */
  eCARBON_BT_EVCD_b = 20, /*!< EVCD b */
  eCARBON_BT_EVCD_C = 21, /*!< EVCD C */
  eCARBON_BT_EVCD_c = 22, /*!< EVCD c */
  eCARBON_BT_EVCD_F = 23, /*!< EVCD F */
  eCARBON_BT_EVCD_f = 24, /*!< EVCD f */

  /* vhdl bit types */
  eCARBON_BT_VHDL_BOOLEAN_FALSE = 0, /*!< VHDL_BOOLEAN FALSE */
  eCARBON_BT_VHDL_BOOLEAN_TRUE = 1, /*!< VHDL BOOLEAN TRUE */

  eCARBON_BT_VHDL_BIT_0 = 0, /*!< VHDL BIT 0 */
  eCARBON_BT_VHDL_BIT_1 = 1, /*!< VHDL BIT 1 */

  eCARBON_BT_VHDL_SEVERITY_LEVEL_NOTE = 0, /*!< VHDL SEVERITY LEVEL NOTE */
  eCARBON_BT_VHDL_SEVERITY_LEVEL_WARNING = 1, /*!< VHDL SEVERITY LEVEL WARNING */
  eCARBON_BT_VHDL_SEVERITY_LEVEL_ERROR = 2, /*!< VHDL SEVERITY LEVEL ERROR */
  eCARBON_BT_VHDL_SEVERITY_LEVEL_FAILURE = 3, /*!< VHDL SEVERITY LEVEL FAILURE */

  eCARBON_BT_VHDL_STD_ULOGIC_U = 0, /*!< VHDL STD ULOGIC U */
  eCARBON_BT_VHDL_STD_ULOGIC_X = 1, /*!< VHDL STD ULOGIC X */
  eCARBON_BT_VHDL_STD_ULOGIC_0 = 2, /*!< VHDL STD ULOGIC 0 */
  eCARBON_BT_VHDL_STD_ULOGIC_1 = 3, /*!< VHDL STD ULOGIC 1 */
  eCARBON_BT_VHDL_STD_ULOGIC_Z = 4, /*!< VHDL STD ULOGIC Z */
  eCARBON_BT_VHDL_STD_ULOGIC_W = 5, /*!< VHDL STD ULOGIC W */
  eCARBON_BT_VHDL_STD_ULOGIC_L = 6, /*!< VHDL STD ULOGIC L */
  eCARBON_BT_VHDL_STD_ULOGIC_H = 7, /*!< VHDL STD ULOGIC H */
  eCARBON_BT_VHDL_STD_ULOGIC_DASH = 8, /*!< VHDL STD ULOGIC DASH */

  eCARBON_BT_VHDL_STD_LOGIC_U = 0, /*!< VHDL STD LOGIC U */
  eCARBON_BT_VHDL_STD_LOGIC_X = 1, /*!< VHDL STD LOGIC X */
  eCARBON_BT_VHDL_STD_LOGIC_0 = 2, /*!< VHDL STD LOGIC 0 */
  eCARBON_BT_VHDL_STD_LOGIC_1 = 3, /*!< VHDL STD LOGIC 1 */
  eCARBON_BT_VHDL_STD_LOGIC_Z = 4, /*!< VHDL STD LOGIC Z */
  eCARBON_BT_VHDL_STD_LOGIC_W = 5, /*!< VHDL STD LOGIC W */
  eCARBON_BT_VHDL_STD_LOGIC_L = 6, /*!< VHDL STD LOGIC L */
  eCARBON_BT_VHDL_STD_LOGIC_H = 7, /*!< VHDL STD LOGIC H */
  eCARBON_BT_VHDL_STD_LOGIC_DASH = 8, /*!< VHDL STD LOGIC DASH */

  eCARBON_BT_VHDL_FILE_OPEN_KIND_READ_MODE = 0, /*!< VHDL FILE OPEN KIND READ MODE */
  eCARBON_BT_VHDL_FILE_OPEN_KIND_WRITE_MODE = 1, /*!< VHDL FILE OPEN KIND WRITE MODE */
  eCARBON_BT_VHDL_FILE_OPEN_KIND_APPEND_MODE = 2, /*!< VHDL FILE OPEN KIND APPEND MODE */

  eCARBON_BT_VHDL_FILE_OPEN_STATUS_OPEN_OK = 0, /*!< VHDL FILE STATUS OPEN OK */
  eCARBON_BT_VHDL_FILE_OPEN_STATUS_STATUS_ERROR = 1, /*!< VHDL FILE STATUS OPEN ERROR */
  eCARBON_BT_VHDL_FILE_OPEN_STATUS_NAME_ERROR = 2, /*!< VHDL FILE STATUS NAME ERROR */
  eCARBON_BT_VHDL_FILE_OPEN_STATUS_MODE_ERROR = 3, /*!< VHDL FILE STATUS MODE ERROR */

  /* transistor value types */
  eCARBON_BT_TRANS_LOGIC_0 = 0, /*!< TRANS LOGIC 0 */
  eCARBON_BT_TRANS_LOGIC_1 = 1, /*!< TRANS LOGIC 1 */
  eCARBON_BT_TRANS_LOGIC_X = 2, /*!< TRANS LOGIC X */
  eCARBON_BT_TRANS_LOGIC_Z = 3, /*!< TRANS LOGIC Z */

  eCARBON_BT_TRANS_BOOL_FALSE = 0, /*!< TRANS BOOL FALSE */
  eCARBON_BT_TRANS_BOOL_TRUE = 1 /*!< TRANS BOOL TRUE */
} CarbonBitType;

/*!
  \brief Enumeration for FSDB data types.

  These get translated to the FSDB data type when creating an FSDB handle,
  and are provided mainly to guard against changes in the FSDB writer's
  header file.
*/
typedef enum {
  eCARBON_DT_BYTE, /*!< 1 byte integer */
  eCARBON_DT_SHORT, /*!< 2 byte integer */
  eCARBON_DT_INT, /*!< integer type */
  eCARBON_DT_FLOAT, /*!< float type */
  eCARBON_DT_HL_INT, /*!< High/Low integer */
  eCARBON_DT_LONG, /*!< long type */
  eCARBON_DT_DOUBLE, /*!< double type */

  eCARBON_DT_VERILOG_STANDARD, /*!< logic type */
  eCARBON_DT_VERILOG_REAL, /*!< double type */
  eCARBON_DT_VERILOG_INTEGER, /*!< 32 bit integer type */

  eCARBON_DT_EPIC_DIGITAL, /*!< Epic digital type */
  eCARBON_DT_EPIC_ANALOG, /*!< Epic analog type */

  eCARBON_DT_HSPICE, /*!< hspice type */
  eCARBON_DT_XP, /*!< XP type */
  eCARBON_DT_RAWFILE, /*!< rawfile */
  eCARBON_DT_WFM, /*!< wfm */

  eCARBON_DT_VHDL_BOOLEAN, /*!< VHDL BOOLEAN */
  eCARBON_DT_VHDL_BIT, /*!< VHDL BIT */
  eCARBON_DT_VHDL_BIT_VECTOR, /*!< VHDL BIT VECTOR */
  eCARBON_DT_VHDL_STD_ULOGIC, /*!< VHDL STD_ULOGIC scalar */
  eCARBON_DT_VHDL_STD_ULOGIC_VECTOR, /*!< VHDL STD ULOGIC VECTOR */
  eCARBON_DT_VHDL_STD_LOGIC, /*!< VHDL STD LOGIC scalar */
  eCARBON_DT_VHDL_STD_LOGIC_VECTOR, /*!< VHDL STD LOGIC VECTOR */
  eCARBON_DT_VHDL_UNSIGNED, /*!< VHDL STD UNSIGNED */
  eCARBON_DT_VHDL_SIGNED, /*!< VHDL STD SIGNED */
  eCARBON_DT_VHDL_INTEGER, /*!< VHDL STD INTEGER */
  eCARBON_DT_VHDL_REAL, /*!< VHDL REAL */
  eCARBON_DT_VHDL_NATURAL, /*!< VHDL NATURAL */
  eCARBON_DT_VHDL_POSITIVE, /*!< VHDL POSITIVE */
  eCARBON_DT_VHDL_TIME, /*!< VHDL TIME */
  eCARBON_DT_VHDL_CHARACTER, /*!< VHDL CHARACTER */
  eCARBON_DT_VHDL_STRING, /*!< VHDL_STRING */
  eCARBON_DT_VHDL_STDLOGIC_1D, /*!< VHDL STD LOGIC 1D */
  eCARBON_DT_VHDL_STDLOGIC_TABLE, /*!< VHDL STD LOGIC TABLE */
  eCARBON_DT_VHDL_LOGIC_X01_TABLE, /*!< VHDL X01 LOGIC TABLE */
  eCARBON_DT_VHDL_LOGIC_X01Z_TABLE, /*!< VHDL X01Z LOGIC TABLE */
  eCARBON_DT_VHDL_LOGIC_UX01_TABLE, /*!< VHDL UX01 LOGIC TABLE */
  eCARBON_DT_VHDL_X01, /*!< VHDL X01 */
  eCARBON_DT_VHDL_X01Z, /*!< VHDL X01Z */
  eCARBON_DT_VHDL_UX01, /*!< VHDL UX01 */
  eCARBON_DT_VHDL_UX01Z, /*!< VHDL UX01Z */
  eCARBON_DT_VHDL_SEVERITY_LEVEL, /*!< VHDL SEVERITY LEVEL */
  eCARBON_DT_VHDL_DELAY_LENGTH, /*!< VHDL DELAY LENGTH */
  eCARBON_DT_VHDL_LINE, /*!< VHDL LINE */
  eCARBON_DT_VHDL_TEXT, /*!< VHDL TEXT */
  eCARBON_DT_VHDL_SIDE, /*!< VHDL SIDE */
  eCARBON_DT_VHDL_WIDTH, /*!< VHDL WIDTH */
  eCARBON_DT_VHDL_FILE_OPEN_KIND, /*!< VHDL FILE OPEN KIND */
  eCARBON_DT_VHDL_FILE_OPEN_STATUS /*!< VHDL FILE OPEN STATUS */
} CarbonDataType;

/*!
  \brief Enumeration for FSDB variable types.

  This is required for FSDB to annotate the net appropriately. These are
  converted to the FSDB variable type, and are provided to guard against
  FSDB header file changes.
*/
typedef enum {
  eCARBON_VT_VCD_EVENT, /*!< VCD EVENT */
  eCARBON_VT_VCD_INTEGER, /*!< VCD INTEGER */
  eCARBON_VT_VCD_PARAMETER, /*!< VCD PARAMETER */
  eCARBON_VT_VCD_REAL, /*!< VCD REAL */
  eCARBON_VT_VCD_REG, /*!< VCD REG */
  eCARBON_VT_VCD_SUPPLY0, /*!< VCD SUPPLY0 */
  eCARBON_VT_VCD_SUPPLY1, /*!< VCD SUPPLY1 */
  eCARBON_VT_VCD_TIME, /*!< VCD TIME */
  eCARBON_VT_VCD_TRI, /*!< VCD TRI */
  eCARBON_VT_VCD_TRIAND, /*!< VCD TRIAND */
  eCARBON_VT_VCD_TRIOR, /*!< VCD TRIOR */
  eCARBON_VT_VCD_TRIREG, /*!< VCD TRIREG */
  eCARBON_VT_VCD_TRI0, /*!< VCD TRI0 */
  eCARBON_VT_VCD_TRI1, /*!< VCD TRI1 */
  eCARBON_VT_VCD_WAND, /*!< VCD WAND */
  eCARBON_VT_VCD_WIRE, /*!< VCD WIRE */
  eCARBON_VT_VCD_WOR, /*!< VCD WOR */
  eCARBON_VT_VCD_MEMORY, /*!< VCD MEMORY */
  eCARBON_VT_VCD_MEMORY_DEPTH, /*!< VCD MEMORY DEPTH */
  eCARBON_VT_VCD_MEMORY_RANGE, /*!< VCD MEMORY RANGE */
  eCARBON_VT_VCD_PORT, /*!< VCD PORT */

  eCARBON_VT_VHDL_SIGNAL, /*!< VHDL SIGNAL */
  eCARBON_VT_VHDL_VARIABLE, /*!< VHDL VARIABLE */
  eCARBON_VT_VHDL_CONSTANT, /*!< VHDL CONSTANT */
  eCARBON_VT_VHDL_FILE, /*!< VHDL FILE */
  eCARBON_VT_VHDL_MEMORY, /*!< VHDL MEMORY */
  eCARBON_VT_VHDL_MEMORY_DEPTH, /*!< VHDL MEMORY DEPTH */
  eCARBON_VT_VHDL_MEMORY_RANGE, /*!< VHDL MEMORY RANGE */

  eCARBON_VT_STREAM, /*!< STREAM */
  eCARBON_VT_LOOP_MARKER, /*!< LOOP MARKER */

  /* Property var types */
  eCARBON_VT_PROP_MIN, /*!< PROP MIN */
  eCARBON_VT_PROP_COVER, /*!< PROP COVER */
  eCARBON_VT_PROP_LOCAL_MEMORY, /*!< PROP LOCAL MEMORY */
  eCARBON_VT_PROP_LOCAL, /*!< PROP LOCAL */
  eCARBON_VT_PROP_EVENT, /*!< PROP EVENT */
  eCARBON_VT_PROP_BOOL, /*!< PROP BOOL */
  eCARBON_VT_PROP_ASSERT_FORBID, /*!< PROP ASSERT FORBID */
  eCARBON_VT_PROP_ASSERT_CHECK, /*!< PROP ASSERT CHECK */
  eCARBON_VT_PROP_ASSERT, /*!< PROP ASSERT */
  eCARBON_VT_PROP_MAX, /*!< PROP MAX */

  eCARBON_VT_STRING, /*!< STRING */

  /* epic var types */
  eCARBON_VT_EPIC_LOGIC, /*!< EPIC LOGIC */
  eCARBON_VT_EPIC_VOLTAGE, /*!< EPIC VOLTAGE */
  eCARBON_VT_EPIC_INSTANTANEOUS_CURRENT, /*!< EPIC INSTANTANEOUS CURRENT */
  eCARBON_VT_EPIC_AVERAGE_RMS_CURRENT, /*!< EPIC AVERAGE RMS CURRENT */
  eCARBON_VT_EPIC_DI_DT, /*!< EPIC DI DT */
  eCARBON_VT_EPIC_MATHEMATICS, /*!< EPIC MATHEMATICS */
  eCARBON_VT_EPIC_POWER, /*!< EPIC POWER */

  /* Nanosim var types */
  eCARBON_VT_NANOSIM_LOGIC, /*!< NANOSIM LOGIC */
  eCARBON_VT_NANOSIM_VOLTAGE, /*!< NANOSIM VOLTAGE */
  eCARBON_VT_NANOSIM_INSTANTANEOUS_CURRENT, /*!< NANOSIM INSTANTANEOUS CURRENT */
  eCARBON_VT_NANOSIM_AVERAGE_RMS_CURRENT, /*!< NANOSIM AVERAGE_RMS CURRENT */
  eCARBON_VT_NANOSIM_DI_DT, /*!< NANOSIM DI DT */
  eCARBON_VT_NANOSIM_MATHEMATICS, /*!< NANOSIM MATHEMATICS */
  eCARBON_VT_NANOSIM_POWER, /*!< NANOSIM POWER */

  /* HSPICE var types */
  eCARBON_VT_HSPICE_VOLTAGE, /*!< HSPICE VOLTAGE */
  eCARBON_VT_HSPICE_VOLTS_MAG, /*!< HSPICE VOLTS MAG */
  eCARBON_VT_HSPICE_VOLTS_REAL, /*!< HSPICE VOLTS REAL */
  eCARBON_VT_HSPICE_VOLTS_IMAG, /*!< HSPICE VOLTS IMAG */
  eCARBON_VT_HSPICE_PHASE, /*!< HSPICE PHASE */
  eCARBON_VT_HSPICE_VOLTS_DB, /*!< HSPICE VOLTS DB */
  eCARBON_VT_HSPICE_VOLTS_TDLY, /*!< HSPICE_VOLTS TDLY */
  eCARBON_VT_HSPICE_CURRENT, /*!< HSPICE CURRENT */
  eCARBON_VT_HSPICE_I_MAG, /*!< HSPICE I MAG */
  eCARBON_VT_HSPICE_I_REAL, /*!< HSPICE I REAL */
  eCARBON_VT_HSPICE_I_IMAG, /*!< HSPICE I IMAG */
  eCARBON_VT_HSPICE_I_PHASE, /*!< HSPICE I PHASE */
  eCARBON_VT_HSPICE_I_DECIBEL, /*!< HSPICE I DECIBEL */
  eCARBON_VT_HSPICE_I_TDLY, /*!< HSPICE I TDLY */
  eCARBON_VT_HSPICE_CURRENT_1, /*!< HSPICE_CURRENT 1 */
  eCARBON_VT_HSPICE_I_MAG_1, /*!< HSPICE I MAG 1 */
  eCARBON_VT_HSPICE_I_REAL_1, /*!< HSPICE I REAL 1 */
  eCARBON_VT_HSPICE_I_IMAG_1, /*!< HSPICE I IMAG 1 */
  eCARBON_VT_HSPICE_I_PHASE_1, /*!< HSPICE I PHASE 1 */
  eCARBON_VT_HSPICE_I_DECIBEL_1, /*!< HSPICE I DECIBEL 1 */
  eCARBON_VT_HSPICE_I_TDLY_1, /*!< HSPICE I TDLY 1 */
  eCARBON_VT_HSPICE_CURRENT_2, /*!< HSPICE CURRENT 2 */
  eCARBON_VT_HSPICE_I_MAG_2, /*!< HSPICE I MAG 2 */
  eCARBON_VT_HSPICE_I_REAL_2, /*!< HSPICE I REAL 2 */
  eCARBON_VT_HSPICE_I_IMAG_2, /*!< HSPICE I IMAG 2 */
  eCARBON_VT_HSPICE_I_PHASE_2, /*!< HSPICE I PHASE 2 */
  eCARBON_VT_HSPICE_I_DECIBEL_2, /*!< HSPICE I DECIBEL 2 */
  eCARBON_VT_HSPICE_I_TDLY_2, /*!< HSPICE I TDLY 2 */
  eCARBON_VT_HSPICE_CURRENT_3, /*!< HSPICE CURRENT 3 */
  eCARBON_VT_HSPICE_I_MAG_3, /*!< HSPICE I MAG 3 */
  eCARBON_VT_HSPICE_I_REAL_3, /*!< HSPICE I REAL 3 */
  eCARBON_VT_HSPICE_I_IMAG_3, /*!< HSPICE I IMAG 3 */
  eCARBON_VT_HSPICE_I_PHASE_3, /*!< HSPICE I PHASE 3 */
  eCARBON_VT_HSPICE_I_DECIBEL_3, /*!< HSPICE I DECIBEL 3 */
  eCARBON_VT_HSPICE_I_TDLY_3, /*!< HSPICE I TDLY 3 */
  eCARBON_VT_HSPICE_CURRENT_4, /*!< HSPICE CURRENT 4 */
  eCARBON_VT_HSPICE_I_MAG_4, /*!< HSPICE I MAG 4 */
  eCARBON_VT_HSPICE_I_REAL_4, /*!< HSPICE I REAL 4 */
  eCARBON_VT_HSPICE_I_IMAG_4, /*!< HSPICE I IMAG 4 */
  eCARBON_VT_HSPICE_I_PHASE_4, /*!< HSPICE I PHASE 4 */
  eCARBON_VT_HSPICE_I_DECIBEL_4, /*!< HSPICE I DECIBEL 4 */
  eCARBON_VT_HSPICE_I_TDLY_4, /*!< HSPICE I TDLY 4 */
  eCARBON_VT_HSPICE_POWER, /*!< HSPICE POWER */
  eCARBON_VT_HSPICE_P_M, /*!< HSPICE P M */
  eCARBON_VT_HSPICE_P_REAL, /*!< HSPICE P REAL */
  eCARBON_VT_HSPICE_P_IMAG, /*!< HSPICE P IMAG */
  eCARBON_VT_HSPICE_P_PHASE, /*!< HSPICE P PHASE */
  eCARBON_VT_HSPICE_P_DB, /*!< HSPICE P DB */
  eCARBON_VT_HSPICE_P_TDLY, /*!< HSPICE P TDLY */
  eCARBON_VT_HSPICE_TPOWRD, /*!< HSPICE TPOWRD */
  eCARBON_VT_HSPICE_NOI_V_SQ_HZ, /*!< HSPICE NOI V SQ HZ */
  eCARBON_VT_HSPICE_INOISE, /*!< HSPICE INOISE */
  eCARBON_VT_HSPICE_HD2, /*!< HSPICE HD2 */
  eCARBON_VT_HSPICE_HD3, /*!< HSPICE HD3 */
  eCARBON_VT_HSPICE_DIM2, /*!< HSPICE DIM2 */
  eCARBON_VT_HSPICE_SIM2, /*!< HSPICE SIM2 */
  eCARBON_VT_HSPICE_DIM3, /*!< HSPICE DIM3 */
  eCARBON_VT_HSPICE_Z11, /*!< HSPICE Z11 */
  eCARBON_VT_HSPICE_Z21, /*!< HSPICE Z21 */
  eCARBON_VT_HSPICE_Z12, /*!< HSPICE Z12 */
  eCARBON_VT_HSPICE_Z22, /*!< HSPICE Z22 */
  eCARBON_VT_HSPICE_ZIN, /*!< HSPICE ZIN */
  eCARBON_VT_HSPICE_ZOUT, /*!< HSPICE ZOUT */
  eCARBON_VT_HSPICE_Y11, /*!< HSPICE Y11 */
  eCARBON_VT_HSPICE_Y21, /*!< HSPICE Y21 */
  eCARBON_VT_HSPICE_Y12, /*!< HSPICE Y12 */
  eCARBON_VT_HSPICE_Y22, /*!< HSPICE Y22 */
  eCARBON_VT_HSPICE_YIN, /*!< HSPICE YIN */
  eCARBON_VT_HSPICE_YOUT, /*!< HSPICE YOUT */
  eCARBON_VT_HSPICE_H11, /*!< HSPICE H11 */
  eCARBON_VT_HSPICE_H21, /*!< HSPICE H21 */
  eCARBON_VT_HSPICE_H12, /*!< HSPICE H12 */
  eCARBON_VT_HSPICE_H22, /*!< HSPICE H22 */
  eCARBON_VT_HSPICE_S11, /*!< HSPICE S11 */
  eCARBON_VT_HSPICE_S21, /*!< HSPICE S21 */
  eCARBON_VT_HSPICE_S12, /*!< HSPICE S12 */
  eCARBON_VT_HSPICE_S22, /*!< HSPICE S22 */
  eCARBON_VT_HSPICE_PARAM, /*!< HSPICE PARAM */
  eCARBON_VT_HSPICE_LX, /*!< HSPICE LX */
  eCARBON_VT_HSPICE_LV /*!< HSPICE LV */
} CarbonVarType;

/*!
  \brief Enumeration for number of bytes per bit of a variable.

  This is used to help the FSDB writer calculate the size of the
  buffer needed to represent a variable.
*/
typedef enum {
  eCARBON_BYTES_PER_BIT_1B, /*!< 1 byte per bit */
  eCARBON_BYTES_PER_BIT_2B, /*!< 2 bytes per bit */
  eCARBON_BYTES_PER_BIT_4B, /*!< 4 bytes per bit */
  eCARBON_BYTES_PER_BIT_8B /*!< 8 bytes per bit */
} CarbonBytesPerBit;

/*!
  \brief Enumeration to define radix for formatting data.
*/
typedef enum {
  eCarbonBin, /*!< binary */
  eCarbonOct, /*!< octal */
  eCarbonHex, /*!< hexadecimal */
  eCarbonDec, /*!< decimal */
  eCarbonUDec /*!< unsigned dec */
} CarbonRadix;

/*!
  \brief Timescale enumeration - time unit per time point.
*/
typedef enum {
  e1fs = -15, /*!< 1 femtosecond */
  e10fs,      /*!< 10 femtoseconds */
  e100fs,     /*!< 100 femtoseconds */
  e1ps,       /*!< 1 picosecond */
  e10ps,      /*!< 10 picoseconds */
  e100ps,     /*!< 100 picoseconds */
  e1ns,       /*!< 1 nanosecond */
  e10ns,      /*!< 10 nanoseconds */
  e100ns,     /*!< 100 nanoseconds */
  e1us,       /*!< 1 microsecond */
  e10us,      /*!< 10 microseconds */
  e100us,     /*!< 100 microseconds */
  e1ms,       /*!< 1 millisecond */
  e10ms,      /*!< 10 milliseconds */
  e100ms,     /*!< 100 milliseconds */
  e1s,        /*!< 1 second */
  e10s,       /*!< 10 seconds */
  e100s       /*!< 100 seconds */
} CarbonTimescale;

/*!
  \brief Initialization flags for creating CarbonObjectID.

  This enumeration is used when a CarbonObjectID is created
  with the external C function: <tt>carbon_<design>_create()</tt>.
*/
typedef enum {
  eCarbon_NoFlags = 0x0, /*!< No flags. */
  eCarbon_EnableStats = 0x1, /*!< Print time/memory statistics to stdout for the model. */
  eCarbon_NoInit = 0x2, /*!< Do not run the initialization code for the model. */
  eCarbon_ClockGlitchDetect = 0x4, /*!< Test whether clocks glitch in a call. */
} CarbonInitFlags;

/*!
  \brief Reason for calling the C-model function: <tt>cds_<cmodel>_misc()</tt>.
*/
typedef enum {
  eCarbonCModelStart,   /*!< Initialize C-model. */
  eCarbonCModelID,      /*!< Pass CarbonObjectID to C-model. */
  eCarbonCModelSave,    /*!< Save C-model.state. */
  eCarbonCModelRestore  /*!< Restore C-model state. */
} CarbonCModelReason;

/*! @} */ /*  end of addtogroup Enums */

/*!
  \brief A structure to pass parameter information to c-models.
  \internal
*/
typedef struct _CModelParam
{
  /*!
    \brief Parameter Name.
  */
  const char* paramName;
  /*!
    \brief Parameter Value.
  */
  const char* paramValue;
} CModelParam;


  /*!
    \brief Enum for bit offsets in the change array
    \internal
  */
typedef enum {
  eCarbonChangeFall,  /*!< A scalar transitioned from 1 -> 0 */
  eCarbonChangeRise,  /*!< A scalar transitioned from 0 -> 1 */
  eCarbonChange       /*!< Some change (unknown or vector) */
} CarbonChangeOffset;

  /* Definitions for various change array values*/
  /*!
    \brief Mask for no change
    \internal
  */
#define CARBON_CHANGE_NONE_MASK   0
  /*!
    \brief Mask for no falling edge
    \internal
  */
#define CARBON_CHANGE_FALL_MASK   (1 << eCarbonChangeFall)
  /*!
    \brief Mask for no rising edge
    \internal
  */
#define CARBON_CHANGE_RISE_MASK   (1 << eCarbonChangeRise)
  /*!
    \brief Mask for glitch
    \internal
  */
#define CARBON_CHANGE_GLITCH_MASK (CARBON_CHANGE_FALL_MASK|CARBON_CHANGE_RISE_MASK)
  /*!
    \brief Mask for change detection
    \internal
  */
#define CARBON_CHANGE_MASK        (1 << eCarbonChange)

  /*!
    \brief The type for the change array
    \internal
  */
typedef unsigned char CarbonChangeType;

#ifndef CARBON_NO_UINT_TYPES
typedef CarbonUInt8  UInt8;
typedef CarbonUInt16 UInt16;
typedef CarbonUInt32 UInt32;
typedef CarbonUInt64 UInt64;
typedef CarbonSInt8  SInt8;
typedef CarbonSInt16 SInt16;
typedef CarbonSInt32 SInt32;
typedef CarbonSInt64 SInt64;

#ifndef CARBON_EXTERNAL_DOC
typedef CarbonUInt8 UInt1;
typedef CarbonUInt8 UInt2;
typedef CarbonUInt8 UInt3;
typedef CarbonUInt8 UInt4;
typedef CarbonUInt8 UInt5;
typedef CarbonUInt8 UInt6;
typedef CarbonUInt8 UInt7;

typedef CarbonUInt16 UInt9;
typedef CarbonUInt16 UInt10;
typedef CarbonUInt16 UInt11;
typedef CarbonUInt16 UInt12;
typedef CarbonUInt16 UInt13;
typedef CarbonUInt16 UInt14;
typedef CarbonUInt16 UInt15;

typedef CarbonUInt32 UInt17;
typedef CarbonUInt32 UInt18;
typedef CarbonUInt32 UInt19;
typedef CarbonUInt32 UInt20;
typedef CarbonUInt32 UInt21;
typedef CarbonUInt32 UInt22;
typedef CarbonUInt32 UInt23;
typedef CarbonUInt32 UInt24;
typedef CarbonUInt32 UInt25;
typedef CarbonUInt32 UInt26;
typedef CarbonUInt32 UInt27;
typedef CarbonUInt32 UInt28;
typedef CarbonUInt32 UInt29;
typedef CarbonUInt32 UInt30;
typedef CarbonUInt32 UInt31;

typedef CarbonUInt64 UInt33;
typedef CarbonUInt64 UInt34;
typedef CarbonUInt64 UInt35;
typedef CarbonUInt64 UInt36;
typedef CarbonUInt64 UInt37;
typedef CarbonUInt64 UInt38;
typedef CarbonUInt64 UInt39;
typedef CarbonUInt64 UInt40;
typedef CarbonUInt64 UInt41;
typedef CarbonUInt64 UInt42;
typedef CarbonUInt64 UInt43;
typedef CarbonUInt64 UInt44;
typedef CarbonUInt64 UInt45;
typedef CarbonUInt64 UInt46;
typedef CarbonUInt64 UInt47;
typedef CarbonUInt64 UInt48;
typedef CarbonUInt64 UInt49;
typedef CarbonUInt64 UInt50;
typedef CarbonUInt64 UInt51;
typedef CarbonUInt64 UInt52;
typedef CarbonUInt64 UInt53;
typedef CarbonUInt64 UInt54;
typedef CarbonUInt64 UInt55;
typedef CarbonUInt64 UInt56;
typedef CarbonUInt64 UInt57;
typedef CarbonUInt64 UInt58;
typedef CarbonUInt64 UInt59;
typedef CarbonUInt64 UInt60;
typedef CarbonUInt64 UInt61;
typedef CarbonUInt64 UInt62;
typedef CarbonUInt64 UInt63;


#endif /* CARBON_EXTERNAL_DOC */

#endif /* CARBON_NO_UINT_TYPES */

#ifdef __cplusplus
} /* extern "C" */
#define __C__ "C"
#else /* cplusplus */
/*!
  \brief define for C compiler
  \hideinitializer
  \internal
*/
#define __C__
#endif /* !cplusplus */

#undef STRUCT

#ifndef UNUSED
#ifdef __GNUC__
#define UNUSED __attribute__((unused))
#else
#define UNUSED /*nothing*/
#endif
#endif

#ifndef DEPRECATED
#ifdef __GNUC__
#define DEPRECATED __attribute__((deprecated))
#else
#define DEPRECATED /*nothing*/
#endif
#endif

// C++ has 'inline', but C before C99 does not and the SWIG wrappers are
// built in pre-C99 C on Windows.  The C compilers we support have '__inline'
// but SWIG itself only has 'inline'..
#ifndef INLINE
#if defined(__cplusplus) || defined(SWIG)
#define INLINE inline
#else
#define INLINE __inline
#endif
#endif // ndef INLINE



  /*!
    \defgroup CarbonObsolete Obsolete Types
  */

  /*!
    \addtogroup CarbonObsolete
    \brief The following obsolete types are DEPRECATED beginning with v8.3.0.
    @{

    \li CarbonModeChangeCBFunc
    \li CarbonOnDemandBackoffStrategy
    \li CarbonOnDemandCBDataID
    \li CarbonOnDemandDebugAction
    \li CarbonOnDemandDebugCBFunc
    \li CarbonOnDemandDebugLevel
    \li CarbonOnDemandDebugType
    \li CarbonOnDemandMode
    \li CarbonOnDemandModeChangeCBFunc
    \li CarbonReplayCBDataID
    \li CarbonReplayInfoID
    \li CarbonReplayReadCmdlineStatus
    \li CarbonVHMMode

    @} */

#endif
