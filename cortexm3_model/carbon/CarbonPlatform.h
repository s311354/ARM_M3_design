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
#ifndef __CarbonPlatform_h_
#define __CarbonPlatform_h_

/*
 * autoconf tells us some things
 */
/* #include "config.h" */
/*!
  \file
  ARM CycleModels platform/arch definitions. This enables defs for certain
  platforms that ARM CycleModels supports.
*/

/* Initialization of OS type defines */
/*!
  \brief Defined true if using a LINUX machine
*/
#define pfLINUX 0
/*!
  \brief Defined true if using a LINUX64 machine
*/
#define pfLINUX64 0

/* initialization of compilers */
/*!
  \brief Defined true if using gcc
*/
#define pfGCC 0
/*!
  \brief Defined true if using gcc 3.x
*/
#define pfGCC_3 0

/*!
  \brief Defined true if using gcc 3.3
*/
#define pfGCC_3_3 0

/*!
  \brief Defined true if using gcc 3.4
*/
#define pfGCC_3_4 0
#define pfGCC_3_4_3 0
#define pfGCC_3_4_4 0
#define pfGCC_3_4_5 0
#define pfGCC_3_4_6 0
/*!
  \brief Defined true if using gcc 4
*/
#define pfGCC_4 0

/*!
  \brief Defined true if using gcc 4.0
*/
#define pfGCC_4_0 0

/*!
  \brief Defined true if using gcc 4.1
*/
#define pfGCC_4_1 0

/*!
  \brief Defined true if using gcc 4.2
*/
#define pfGCC_4_2 0

/*!
  \brief Defined true if using gcc 4.1.0
*/
#define pfGCC_4_1_0 0

/*!
  \brief Defined true if using gcc 4.2.0
*/
#define pfGCC_4_2_0 0

/*!
  \brief Defined true if using gcc 4.2.4
*/
#define pfGCC_4_2_4 0

/*!
  \brief Defined true if using gcc 4.3
*/
#define pfGCC_4_3 0

/*!
  \brief Defined true if using gcc 4.3.2
*/
#define pfGCC_4_3_2 0

/*!
  \brief Defined true if using gcc 4.3
*/
#define pfGCC_4_7 0

/*!
  \brief Defined true if using gcc 4.3.2
*/
#define pfGCC_4_7_2 0

/*!
  \brief Defined true if using the intel compiler
*/
#define pfICC 0
#define pfICC_7 0
#define pfICC_8 0
#define pfICC_9 0

/*!
  \brief Defined true if using SparcWorks compiler
*/
#define pfSPARCWORKS 0

/*!
  \brief Defined true if SparcWorks 11 in use
*/
#define pfSPARCWORKS_11 0

/*!
  \brief Defined true if using Microsoft Visual C++ compiler
*/
#define pfMSVC 0
/*!
  \brief Defined true if using CoWare EDG front end.
*/
#define pfCOWARE 0

/*!
  \brief Defined true if compiling for Windows
*/
#define pfWINDOWS 0

/*!
  \brief Defined true if compiling for Windows in Cygwin
*/
#define pfCYGWIN 0

/*!
  \brief Defined true if using MMX
*/
#define pfMMX 0

/*!
  \brief Defined true if using SSE
*/
#define pfSSE 0

/*!
  \brief Defined true if using x86 instruction set
*/
#define pfX86 0

/*!
  \brief Defined true if using SPARC instruction set
*/
#define pfSPARC 0

/*!
  \brief Defined true if the compiler supports variadic macros
*/
#define pfHAS_VARIADIC_MACROS 0

/*!
  \brief Defined true if using X86_64 instruction set
*/
#define pfX86_64 0

#ifdef linux
#if defined (__x86_64__)
#  undef pfLINUX64
#  define pfLINUX64 1
#else
#  error "Unsupported Platform"
#endif
#endif

/* SPARCWORKS is available on x86, x86_64 and SPARC now. */
#if defined(__SUNPRO_CC)
#  undef pfSPARCWORKS
#  define pfSPARCWORKS 1
#  if (__SUNPRO_CC == 0x580) || (__SUNPRO_CC == 0x590)
#    undef pfSPARCWORKS_11
#    define pfSPARCWORKS_11 1
#  endif
#endif

#if defined(__SUNPRO_C)
#  undef pfSPARCWORKS
#  define pfSPARCWORKS 1
#  if (__SUNPRO_C == 0x580) || (__SUNPRO_C == 590)
#    undef pfSPARCWORKS_11
#    define pfSPARCWORKS_11 1
#  endif
#endif


/* ICC 8.0 claims to be GCC, don't be fooled! */
#if defined(__GNUC__) && !defined(__ICC)
#  undef pfGCC
#  define pfGCC 1
#  if (__GNUC__ == 4)
#    undef pfGCC_4
#    define pfGCC_4 1
#    if (__GNUC_MINOR__ == 0)
#      undef pfGCC_4_0
#      define pfGCC_4_0 1
#    endif
#    if (__GNUC_MINOR__ == 1)
#      undef pfGCC_4_1
#      define pfGCC_4_1 1
#      if (__GNUC_PATCHLEVEL__ == 0)
#        undef pfGCC_4_1_0
#        define pfGCC_4_1_0 1
#      endif
#    endif
#    if (__GNUC_MINOR__ == 2)
#      undef pfGCC_4_2
#      define pfGCC_4_2 1
#      if (__GNUC_PATCHLEVEL__ == 0)
#        undef pfGCC_4_2_0
#        define pfGCC_4_2_0 1
#      endif
#      if (__GNUC_PATCHLEVEL__ == 4)
#        undef pfGCC_4_2_4
#        define pfGCC_4_2_4 1
#      endif
#    endif
#    if (__GNUC_MINOR__ == 3)
#      undef pfGCC_4_3
#      define pfGCC_4_3 1
#      if (__GNUC_PATCHLEVEL__ == 2)
#        undef pfGCC_4_3_2
#        define pfGCC_4_3_2 1
#      endif
#    endif
#    if (__GNUC_MINOR__ == 7)
#      undef pfGCC_4_7
#      define pfGCC_4_7 1
#      if (__GNUC_PATCHLEVEL__ == 2)
#        undef pfGCC_4_7_2
#        define pfGCC_4_7_2 1
#      endif
#    endif
#  endif
#  if (__GNUC__ == 3)
#    undef pfGCC_3
#    define pfGCC_3 1
#    if (__GNUC_MINOR__ == 3)
#      undef pfGCC_3_3
#      define pfGCC_3_3 1
#    endif
#    if (__GNUC_MINOR__ == 4)
#      undef pfGCC_3_4
#      define pfGCC_3_4 1
#      if (__GNUC_PATCHLEVEL__ == 3)
#        undef pfGCC_3_4_3
#        define pfGCC_3_4_3 1
#      endif
#      if (__GNUC_PATCHLEVEL__ == 4)
#        undef pfGCC_3_4_4
#        define pfGCC_3_4_4 1
#      endif
#      if (__GNUC_PATCHLEVEL__ == 5)
#        undef pfGCC_3_4_5
#        define pfGCC_3_4_5 1
#      endif
#      if (__GNUC_PATCHLEVEL__ == 6)
#        undef pfGCC_3_4_6
#        define pfGCC_3_4_6 1
#      endif
#    endif
#  endif
#endif

#if defined(__ICC) || defined(__INTEL_COMPILER) || defined(__ICC__)
#  undef pfICC
#  define pfICC 1
#  if (__INTEL_COMPILER < 800) && (__INTEL_COMPILER >= 700)
#    undef pfICC_7
#    define pfICC_7 1
#  endif
#  if (__INTEL_COMPILER >= 800) && (__INTEL_COMPILER < 900)
#    undef pfICC_8
#    define pfICC_8 1
#  endif
#  if (__INTEL_COMPILER >= 900)
#    undef pfICC_9
#    define pfICC_9 1
#  endif
#endif

#if defined(_MSC_VER)
#  undef pfMSVC
#  define pfMSVC 1
#  undef pfGCC
#  undef pfGCC_3
#  define pfGCC 0
#  define pfGCC_3 0

#  define strcasecmp _stricmp
#  define strncasecmp _strnicmp
#  define strtoull _strtoui64
#  if (_MSC_VER < 1500)
#    define snprintf _snprintf
#    define vsnprintf _vsnprintf
#  endif
#  define PATH_MAX _MAX_PATH
#  include <iso646.h>           /* for and/or/not keywords */

#ifdef __cplusplus
#ifdef CARBON_DISABLE_ASSERTIONS
#include "util/VCSystem.h"
#endif
#endif

#endif

/* Visual C++ .NET 2003 does not support variadic macros.*/
/* 1400 corresponds to Visual C++ 2005. */
#if ! defined(_MSC_VER) || _MSC_VER >= 1400
#undef pfHAS_VARIADIC_MACROS
#define pfHAS_VARIADIC_MACROS 1
#endif

/* detect CoWare EDG front end */
#if defined(__EDG__) && !defined(__ICC) && !defined(__GNUC__)
#  undef pfCOWARE
#  define pfCOWARE 1
#endif

#if  defined(__win32) || defined(__WIN32__) || defined(WIN32) || defined(__CYGWIN__)
#  undef pfWINDOWS
#  define pfWINDOWS 1
#endif

#if defined(__CYGWIN__)
#  undef pfCYGWIN
#  define pfCYGWIN 1
#endif


#if  defined(__MMX__)
#  undef pfMMX
#  define pfMMX 1
#endif

#if defined(__SSE__)
#  undef pfSSE
#  define pfSSE 1
#endif

/* Utility defines */
/*!
  \brief Defined true if a unix OS is being used
*/
#define pfUNIX (pfLINUX || pfLINUX64)
/*!
  \brief Defined true if this machine has tms structure
*/
#define pfHAS_TMS (pfLINUX || pfLINUX64)

/*!
 \brief Defined true if this machine lacks support for forward declarations of
 template classes with default arguments based on previous args
*/
#define pfTEMPLATE_NO_FORWARD_ARGS (pfMSVC)
#define pfTEMPLATE_FORWARD_ARGS (!pfTEMPLATE_NO_FORWARD_ARGS)

/*!
 \brief Defined true if this compiler supports precompiled headers.
 */
#define pfPRECOMPILED_HEADERS (pfGCC_3_4 || pfGCC_4)

#if defined(__sparc__)
#  undef pfSPARC
#  define pfSPARC 1
#endif

#if defined(__i386__) || defined(__x86_64__)
#  undef pfX86
#  define pfX86 1
#endif

#if defined(__x86_64__)
#  undef pfX86_64
#  define pfX86_64 1
#endif

/*!
 \brief 64-bit native integer support
 */
#define pf64BIT (pfLINUX64)

#ifdef __cplusplus
#define pfEXTERN_C extern "C"
#else
#define pfEXTERN_C
#endif

#endif
