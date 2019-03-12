#-----------------------------------------------------------------------------
# The confidential and proprietary information contained in this file may
# only be used by a person authorised under and to the extent permitted
# by a subsisting licensing agreement from ARM Limited.
#
#            (C) COPYRIGHT 2013-2017 ARM Limited.
#                ALL RIGHTS RESERVED
#
# This entire notice must be reproduced on all copies of this file
# and copies of this file may only be made by a person if such person is
# permitted to do so under the terms of a subsisting license agreement
# from ARM Limited.
#
#      SVN Information
#
#      Checked In          : $Date: 2014-07-02 16:52:21 +0100 (Wed, 02 Jul 2014) $
#
#      Revision            : $Revision: 283836 $
#
#      Release Information : CM3DesignStart-r0p0-02rel0
#
#-----------------------------------------------------------------------------
################################################################################
# Option passing and checking
################################################################################

# If the TESTNAME variable is used is must be of the form "<test>" where
# <test> is the name of a test.
ifdef TESTNAME

  TESTPATH = $(TESTCODES_PATH)/$(TESTNAME)

  # Check that test exists (the wildcard function returns an empty
  # string if it does not)
  ifeq ($(wildcard $(TESTPATH)),)
    $(error "The test $(TESTPATH) does not exist")
  endif

endif

# Check that simulator specified is supported
ifneq ($(strip $(SIMULATOR)), vcs)
  ifneq ($(strip $(SIMULATOR)), ius)
    ifneq ($(strip $(SIMULATOR)), mti)
      $(error "Simulator $(SIMULATOR) is not supported")
    endif
  endif
endif

# Check that tool chain specified is supported
ifneq ($(strip $(TOOL_CHAIN)), ds5)
  ifneq ($(strip $(TOOL_CHAIN)), gcc)
    ifneq ($(strip $(TOOL_CHAIN)), keil)
      $(error "Tool chain $(TOOL_CHAIN) is not supported")
    endif
  endif
endif

# Check that DSM variable value is valid
ifneq ($(strip $(DSM)), yes)
  ifneq ($(strip $(DSM)), no)
    $(error "Variable DSM value $(DSM) is not valid")
  endif
endif

# Check that TARMAC variable value is valid
ifneq ($(strip $(TARMAC)), yes)
  ifneq ($(strip $(TARMAC)), no)
    $(error "Variable TARMAC value $(TARMAC) is not valid")
  endif
endif

# Check that SIM_64BIT variable value is valid
ifneq ($(strip $(SIM_64BIT)), yes)
  ifneq ($(strip $(SIM_64BIT)), no)
    $(error "Variable SIM_64BIT value $(SIM_64BIT) is not valid")

  endif
endif

# Check that SIM_VCD variable value is valid
ifneq ($(strip $(SIM_VCD)), yes)
  ifneq ($(strip $(SIM_VCD)), no)
    $(error "Variable SIM_VCD value $(SIM_VCD) is not valid")
  endif
endif

# Check that GUI variable value is valid
ifneq ($(strip $(GUI)), yes)
  ifneq ($(strip $(GUI)), no)
    $(error "Variable GUI value $(GUI) is not valid")
  endif
endif

# Check that FSDB variable value is valid
ifneq ($(strip $(FSDB)), yes)
  ifneq ($(strip $(FSDB)), no)
    $(error "Variable FSDB value $(FSDB) is not valid")
  endif
endif

# Check non supported combination of values
ifeq ($(MAKECMDGOALS), run)
ifeq ($(strip $(TARMAC)), yes)
  ifeq ($(strip $(DSM)), no)
    $(warning "Warning: TARMAC trace would not be generated for obfuscated RTL")
  endif
endif
endif

ifeq ($(strip $(DSM)), yes)
  ifeq ($(strip $(SIM_64BIT)), no)
    $(error "Combination of variable DSM=yes and SIM_64BIT=no is not supported")
  endif
endif

# Warn if TARMAC_ENABLE environment variable is set and TARMAC=no
ifeq ($(MAKECMDGOALS), run)
  ifeq ($(strip $(TARMAC)), no)
    ifdef TARMAC_ENABLE
      $(warning "Warning: Unset environment variable TARMAC_ENABLE to turn off TARMAC trace")
    endif
endif
endif

