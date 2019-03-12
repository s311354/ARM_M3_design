#-----------------------------------------------------------------------------
# The confidential and proprietary information contained in this file may
# only be used by a person authorised under and to the extent permitted
# by a subsisting licensing agreement from ARM Limited.
#
#            (C) COPYRIGHT 2010-2017  ARM Limited or its affiliates.
#                ALL RIGHTS RESERVED
#
# This entire notice must be reproduced on all copies of this file
# and copies of this file may only be made by a person if such person is
# permitted to do so under the terms of a subsisting license agreement
# from ARM Limited.
#
#      SVN Information
#
#      Checked In          : $Date: 2013-03-05 15:59:45 +0000 (Tue, 05 Mar 2013) $
#
#      Revision            : $Revision: 240230 $
#
#      Release Information : CM3DesignStart-r0p0-02rel0
#-----------------------------------------------------------------------------
#
# Cortex-M3 DesignStart software compilation make file
#
#-----------------------------------------------------------------------------
#
#  Configurations
#

# Tool chain : ds5 / gcc / keil
TOOL_CHAIN      = gcc
TESTNAME        = rtx_demo

CPU_PRODUCT     = CORTEX_M3

# ---------------------------------------------------------------------------------------
all: all_$(TOOL_CHAIN)

# ---------------------------------------------------------------------------------------
# DS-5
all_ds5:
	@if [ -e $(TESTNAME).bin ] ; then \
	  echo "Found rtx_demo.bin ... use existing bin file. Continue ..." ; \
	else \
	  echo "RTX demo compilation not available for DS-5." ; \
	  echo "Please compile RTX demo in Keil MDK and press ENTER when ready" ; \
	  read dummy ; \
	fi

# ---------------------------------------------------------------------------------------
# gcc
#
all_gcc:
	@if [ -e $(TESTNAME).bin ] ; then \
	  echo "Found rtx_demo.bin ... use existing bin file. Continue ..." ; \
	else \
	  echo "RTX demo compilation not available for gcc." ;\
	  echo "Please compile RTX demo in Keil MDK and press ENTER when ready" ; \
	  read dummy ; \
	fi

# ---------------------------------------------------------------------------------------
# Keil MDK

all_keil:
	@echo "Please ensure all files from Keil MDK test compilation are in the <test> directory before pressing ENTER"
	@read dummy

# ---------------------------------------------------------------------------------------
# Clean
clean :
	@rm -rf *.o
	@rm -rf *.crf
	@rm -rf *.plg
	@rm -rf *.tra
	@rm -rf *.htm
	@rm -rf *.map
	@rm -rf *.dep
	@rm -rf *.d
	@rm -rf *.lnp
	@rm -rf *.bak
	@rm -rf *.lst
	@rm -rf *.axf
	@rm -rf *.sct
	@rm -rf *.uvgui.*

