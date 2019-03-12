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

EXE_TB_DIR := ${CURDIR}
CMS_PATH := $(EXE_TB_DIR)/../../../../cortexm3_model

# Include user options from separate file
include make.cfg
include options.mk

#########################################################################################################
# default test list
TEST_LIST   := apb_mux_tests cxdt default_slaves_tests designtest_m3 \
               dhry dualtimer_demo gpio_driver_tests gpio_tests hello \
               interrupt_demo memory_tests self_reset_demo \
               sleep_demo timer_driver_tests timer_tests uart_driver_tests \
               uart_tests watchdog_demo rtx_demo

TIMESCALE := -timescale=1ns/10ps

CFLAGS32    := "-fPIC -std=gnu++11 -D__x86_64__ -DCARBON_SC_USE_2_0 -I${CMS_PATH} -I. "
CFLAGS64    := "-fPIC -std=gnu++11 -D__x86_64__ -DCARBON_SC_USE_2_0 -I${CMS_PATH} -I. -m64"
CFLAGS32VCD := "-fPIC -std=gnu++11 -D__x86_64__ -DCARBON_SC_USE_2_0 -I${CMS_PATH} -I. "
CFLAGS64VCD := "-fPIC -std=gnu++11 -D__x86_64__ -DCARBON_SC_USE_2_0 -I${CMS_PATH} -I. -m64"
CFLAGS      := ${CFLAGS32}
LDFLAGS     := "-L${CMS_PATH} -lcarbon5"

VLOG_MODEL_PATH     = ./
VLOG_MODEL_NAME     = CORTEXM3INTEGRATIONDS
VLOG_TESTBENCH_PATH = ../verilog
VLOG_TESTBENCH_NAME = tb_fpga_shield

CM_MODEL_LIB_NAME  = cortexm3_integrationds_dsm
CM_MODEL_NAME      = CORTEXM3INTEGRATIONDS_dsm
CM_TESTBENCH_PATH  = ../verilog
CM_TESTBENCH_NAME  = tb_fpga_shield
CM_MODEL_LIB       = lib${CM_MODEL_LIB_NAME}

#########################################################################################################
SW_MAKE_OPTIONS = TOOL_CHAIN=$(TOOL_CHAIN)

# Files
vcfiles     := tbench.vc
cm_vcfiles  := tbench_cm.vc

# Discovery image
ifeq ($(TESTNAME),cxdt)
	CXDT = discovery-CXDT-1-CPU-NONE
else
	CXDT = discovery-CXDT-0-CPU-0
endif

# Construct sequence of '-f <vcfile>' for every VC file used. This is a
# recursively-expanded variable so that any additional VC files will be
# represented when the variable is used.
VC_OPTS = $(patsubst %,-f %,$(vcfiles))
VC_CM_OPTS = $(patsubst %,-f %,$(cm_vcfiles))


# CFLAGS
ifeq ($(strip $(SIM_VCD)), yes)

  # Set CFLAGS for VCD dmp
  ifeq ($(strip $(SIM_64BIT)), yes)
    CFLAGS := ${CFLAGS64VCD}
  else
    CFLAGS := ${CFLAGS32VCD}
  endif

else
  # Set CFLAGS for VCD dmp
  ifeq ($(strip $(SIM_64BIT)), yes)
    CFLAGS := ${CFLAGS64}
  else
    CFLAGS := ${CFLAGS32}
  endif

endif

################################################################################
# Simulator-specific setup
#
#   Construct simulator compile-time and run-time arguments based on the
#   configuration options
################################################################################

# Basic options
MTI_INCPATHS          := -I${CMS_PATH}
MTI_SCCOM_OPTS        := -g  -suppress 6102 -suppress 6172 -fPIC -D__x86_64__ ${MTI_INCPATHS}

ifeq ($(strip $(FSDB)), yes)
  ifeq ($(strip $(SIM_64BIT)), yes)
    MTI_NOVAS_OPTS    := -pli $$VERDI_HOME/share/PLI/MODELSIM/LINUX64/novas_fli.so
  else
    MTI_NOVAS_OPTS    := -pli $$VERDI_HOME/share/PLI/MODELSIM/LINUX/novas_fli.so
  endif
endif
MTI_DO_RUN_SCRIPT     := "radix hex; run ${MAX_SIMULATION_TIME};quit -f"
MTI_VLOG_COMPILE_OPTS := +define+MTI_BUILD +acc=blnr -noincr
MTI_VLOG_RUN_OPTS     := -quiet -assertdebug -voptargs="+acc=blnr" ${MTI_NOVAS_OPTS} ${VLOG_TESTBENCH_NAME}
MTI_CM_COMPILE_OPTS   := ${MTI_VLOG_COMPILE_OPTS} -ccflags ${CFLAGS}
MTI_CM_RUN_OPTS       := ${MTI_VLOG_RUN_OPTS}


VCS_VLOGAN_OPTS       := +v2k
VCS_SYSCAN_OPTS       := -cpp g++ -sysc=230 -cflags ${CFLAGS}

# NOTE: Removing -gui stops dve from coming up and removing -sysc removes dependency on systemc modules
ifeq ($(strip $(FSDB)), yes)
  ifeq ($(strip $(SIM_64BIT)), yes)
    VCS_NOVAS_OPTS    := -P $$VERDI_HOME/share/PLI/VCS/LINUX64/verdi.tab $$VERDI_HOME/share/PLI/VCS/LINUX64/pli.a
  else
    VCS_NOVAS_OPTS    := -P $$VERDI_HOME/share/PLI/VCS/LINUX/verdi.tab $$VERDI_HOME/share/PLI/VCS/LINUX/pli.a
  endif
endif
VCS_VLOG_COMPILE_OPTS := +vcs+lic+wait +define+VCS_BUILD +v2k ${VCS_NOVAS_OPTS} -noIncrComp -debug_all +lint=TFIPC-L
VCS_VLOG_RUN_OPTS     := +vcs+lic+wait +vcs+flush+log +vcs+finish+${MAX_SIMULATION_TIME} -assert nopostproc
VCS_CM_COMPILE_OPTS   := ${VCS_VLOG_COMPILE_OPTS} -cpp g++ -cc gcc -Xrerolloff ${TIMESCALE} -sysc=230 -LDFLAGS ${LDFLAGS} ${CMS_PATH}/${CM_MODEL_LIB}.a
VCS_CM_RUN_OPTS       := ${VCS_VLOG_RUN_OPTS}

IUS_VLOG_COMPILE_OPTS := +define+IUS_BUILD -elaborate -nospecify +access+r
IUS_VLOG_RUN_OPTS     := -R -unbuffered
IUS_CM_COMPILE_OPTS   := ${IUS_VLOG_COMPILE_OPTS} -scautoshell systemc -sysc ${CMS_PATH}/${CM_MODEL_LIB}.a -D__x86_64__ ${CMS_PATH}/${CM_MODEL_NAME}.cpp -I${CMS_PATH} -L${CMS_PATH} -lcarbon5
IUS_CM_RUN_OPTS       := ${IUS_VLOG_RUN_OPTS}

# Add cycle model compilation definitions
MTI_CM_COMPILE_OPTS   += +define+ARM_CM +define+ARM_DSM
VCS_CM_COMPILE_OPTS   += +define+ARM_CM +define+ARM_DSM
IUS_CM_COMPILE_OPTS   += +define+ARM_CM +define+ARM_DSM

# CFLAGS
ifeq ($(strip $(SIM_VCD)), yes)
  MTI_VLOG_COMPILE_OPTS   	+=  +define+VCD_ON
  MTI_CM_COMPILE_OPTS  		+=  +define+VCD_ON
  VCS_VLOG_COMPILE_OPTS   	+=  +define+VCD_ON
  VCS_CM_COMPILE_OPTS     	+=  +define+VCD_ON
  IUS_VLOG_COMPILE_OPTS   	+=  +define+VCD_ON
  IUS_CM_COMPILE_OPTS     	+=  +define+VCD_ON
endif

# Check to see if fsdb dump is required
ifeq ($(strip $(FSDB)), yes)
  MTI_VLOG_COMPILE_OPTS   	+=  +define+DUMPFSDB
  MTI_CM_COMPILE_OPTS   	+=  +define+DUMPFSDB
  VCS_VLOG_COMPILE_OPTS   	+=  +define+DUMPFSDB
  VCS_CM_COMPILE_OPTS     	+=  +define+DUMPFSDB
  IUS_VLOG_COMPILE_OPTS   	+=  +define+DUMPFSDB
  IUS_CM_COMPILE_OPTS     	+=  +define+DUMPFSDB
  ifeq ($(strip $(SIMULATOR)), mti)
    ifeq ($(strip $(SIM_64BIT)), yes)
      VERDI_LD_PATH += $$VERDI_HOME/share/PLI/MODELSIM/linux64
    else
      VERDI_LD_PATH += $$VERDI_HOME/share/PLI/MODELSIM/linux
    endif
  endif
  ifeq ($(strip $(SIMULATOR)), vcs)
    ifeq ($(strip $(SIM_64BIT)), yes)
      VERDI_LD_PATH += $$VERDI_HOME/share/PLI/VCS/linux64
    else
      VERDI_LD_PATH += $$VERDI_HOME/share/PLI/VCS/linux
    endif
  endif
  ifeq ($(strip $(SIMULATOR)), ius)
    ifeq ($(strip $(SIM_64BIT)), yes)
      VERDI_LD_PATH += $$VERDI_HOME/share/PLI/IUS/linux64
    else
      VERDI_LD_PATH += $$VERDI_HOME/share/PLI/IUS/linux
    endif
  endif
endif

# 64-bit simulation
ifeq ($(strip $(SIM_64BIT)), yes)
  MTI_SCCOM_OPTS        += -64
  MTI_VLOG_COMPILE_OPTS += -64
  MTI_VLOG_RUN_OPTS     += -64
  MTI_CM_COMPILE_OPTS   += -64
  MTI_CM_RUN_OPTS       += -64

  VCS_VLOGAN_OPTS       += -full64
  VCS_SYSCAN_OPTS       += -full64
  VCS_VLOG_COMPILE_OPTS += -full64
  VCS_CM_COMPILE_OPTS   += -full64

  IUS_NCSC_OPTS         += -64bit
  IUS_NCVLOG_OPTS       += -64bit
  IUS_VLOG_COMPILE_OPTS += -64bit
  IUS_VLOG_RUN_OPTS     += -64bit
  IUS_CM_COMPILE_OPTS   += -64bit
  IUS_CM_RUN_OPTS       += -64bit
endif

# Check to see if interactive simulation run is required
ifeq ($(strip $(GUI)), yes)
  MTI_VLOG_RUN_OPTS   	+=  -gui &
  MTI_CM_RUN_OPTS       +=  -gui &
  VCS_VLOG_RUN_OPTS   	+=  -gui &
  VCS_CM_RUN_OPTS     	+=  -gui &
  IUS_VLOG_RUN_OPTS   	+=  -gui &
  IUS_CM_RUN_OPTS     	+=  -gui &
else
  RUN_LOG               +=  "$(strip $(SIMULATOR))_$(TESTNAME)_run.log"
  MTI_VLOG_RUN_OPTS   	+=  -c -do ${MTI_DO_RUN_SCRIPT}  | tee $(RUN_LOG)
  MTI_CM_RUN_OPTS       +=  -c -do ${MTI_DO_RUN_SCRIPT} | tee $(RUN_LOG)
  VCS_VLOG_RUN_OPTS   	+=  < quit.do | tee $(RUN_LOG)
  VCS_CM_RUN_OPTS     	+=  < quit.do | tee $(RUN_LOG)
  IUS_VLOG_RUN_OPTS   	+=  -input run.tcl < quit.do | tee $(RUN_LOG)
  IUS_CM_RUN_OPTS     	+=  -input run.tcl < quit.do | tee $(RUN_LOG)
endif

################################################################################
# Phony targets
################################################################################

.PHONY: clean clean_tests clean_all tests testcode compile run runall


################################################################################
# User help menu
################################################################################
help:
	@echo "################################################################### "; \
	echo "This is the top Makefile for the execution testbench"; \
	echo "make or make help shows this extra information"; \
	echo ""; \
	echo "See make.cfg for additional build configuration settings"; \
	echo ""; \
	echo "Usage: make target [options]"; \
	echo "target is one of:"; \
	echo "compile                     : compile the testbench (simulator can be vcs, mti, ius)"; \
	echo "run                         : run a test (simulator can be vcs, mti, ius)"; \
	echo "runall                      : run all tests (simulator can be vcs, mti, ius)"; \
	echo "tests                       : compile all tests"; \
	echo "testcode                    : compile a specific test"; \
	echo "clean                       : clean the compiled testbench"; \
	echo "clean_tests                 : clean all compiled test code"; \
	echo "clean_all                   : clean the compiled testbench and all compiled test code"; \
	echo "options can be:"; \
	echo "TESTNAME=<test>             : specify the test name "; \
	echo "PLUSARGS=<plusargs_list>    : run time options"; \
	echo "BUILDOPTS=<buildopts_list>  : build time options"; \
	echo "SIMULATOR=<ius,mti,vcs>     : choose simulator tool"; \
	echo "TOOL_CHAIN=<ds5,gcc,keil>   : choose C compiler tool"; \
	echo "DSM=no                      : used with compile and run time. Setting DSM=yes will pick Carbon model";

################################################################################
# MTI targets
################################################################################

# CM Compile
ifeq ($(strip $(SIMULATOR)), mti)
  ifeq ($(strip $(DSM)), yes)
    COMPILE_LINE	:= vlib work; vlog $(VC_CM_OPTS) $(MTI_CM_COMPILE_OPTS) $(BUILDOPTS);sccom $(MTI_SCCOM_OPTS) ${CMS_PATH}/${CM_MODEL_NAME}.cpp; sccom $(MTI_SCCOM_OPTS) -link ${CMS_PATH}/libcarbon5.so ${CMS_PATH}/${CM_MODEL_LIB}.a
    RUN_LINE        := vsim $(PLUSARGS) $(MTI_CM_RUN_OPTS)
  else
    COMPILE_LINE    := vlib work; vlog $(VC_OPTS) $(MTI_VLOG_COMPILE_OPTS) $(BUILDOPTS)
    RUN_LINE        := vsim $(PLUSARGS) $(MTI_VLOG_RUN_OPTS)
  endif
endif

ifeq ($(strip $(SIMULATOR)), vcs)
  ifeq ($(strip $(DSM)), yes)
    COMPILE_LINE	:= syscan $(VCS_SYSCAN_OPTS) ${CMS_PATH}/${CM_MODEL_NAME}.cpp:${CM_MODEL_NAME}; vcs $(VC_CM_OPTS) $(VCS_CM_COMPILE_OPTS) $(BUILDOPTS)
    RUN_LINE        := ./simv $(PLUSARGS) $(VCS_CM_RUN_OPTS)
  else
    COMPILE_LINE	:= vcs $(VC_OPTS) $(VCS_VLOG_COMPILE_OPTS) $(BUILDOPTS)
    RUN_LINE        := ./simv $(PLUSARGS) $(VCS_VLOG_RUN_OPTS)
  endif
endif

ifeq ($(strip $(SIMULATOR)), ius)
  ifeq ($(strip $(DSM)), yes)
    COMPILE_LINE	:=  irun $(VC_CM_OPTS) $(IUS_CM_COMPILE_OPTS) $(BUILDOPTS)
    RUN_LINE        :=  irun $(PLUSARGS) $(IUS_CM_RUN_OPTS)
  else
    COMPILE_LINE	:=  irun $(VC_OPTS) $(IUS_VLOG_COMPILE_OPTS) $(BUILDOPTS)
    RUN_LINE        :=  irun $(PLUSARGS) $(IUS_VLOG_RUN_OPTS)
  endif
endif

# set TARMAC_ENABLE environmental variable for TARMAC trace
ifeq ($(strip $(TARMAC)), yes)
  RUN_LINE :=  export TARMAC_ENABLE=1; $(RUN_LINE)
endif

# add DSM model and Verdi path to LD_LIBRARY_PATH environmental variable
ifeq ($(strip $(DSM)), yes)
  RUN_LINE :=  export LD_LIBRARY_PATH=${VERDI_LD_PATH}:${CMS_PATH}:${LD_LIBRARY_PATH}; $(RUN_LINE)
else
  RUN_LINE :=  export LD_LIBRARY_PATH=${VERDI_LD_PATH}:${LD_LIBRARY_PATH}; $(RUN_LINE)
endif

################################################################################
# Rebuild tests
################################################################################
# Compile all test codes
tests:
	for thistest in $(TEST_LIST) ; do \
    if [ -d ../testcodes/$$thistest ] ; then \
      echo Building $$thistest ...  ; \
      cd ../testcodes/$$thistest ; \
      make all $(SW_MAKE_OPTIONS) ; \
      cd $(EXE_TB_DIR); \
    fi \
  done

# Compile specific test
testcode:
ifeq ($(TESTNAME),)
	$(error Please specify TESTNAME on the make command line)
endif
	@echo Building $(TESTNAME) ...  ; \
  cd ../testcodes/$(TESTNAME) ; \
  make all $(SW_MAKE_OPTIONS) ; \
  cd $(EXE_TB_DIR); \

################################################################################
# Compile testbench and run simulation
################################################################################
compile:
	@echo " >> Compiling testbench with $(SIMULATOR) and DSM=$(DSM)"
	-($(COMPILE_LINE)) > $(strip $(SIMULATOR))_compile.log
	@(if [ ! -e $(strip $(SIMULATOR))_compile.log ] ; then \
	    echo " >> ERROR: Testbench compile failed, no $(strip $(SIMULATOR))_compile.log" ;\
	    exit 1 ;\
  fi)
	@(if grep -q "^\*\* Error: \|^Error-\[\|: \*E,\|[Ee]rrors: [1-9]\|Error \|error: " $(strip $(SIMULATOR))_compile.log ; then \
	    echo " >> ERROR: Testbench compile failed, check $(strip $(SIMULATOR))_compile.log" ;\
      exit 1 ;\
  fi)
	@echo " >> Testbench compile with $(SIMULATOR) and DSM=$(DSM) completed successfully, log in $(strip $(SIMULATOR))_compile.log"

run:
ifeq ($(TESTNAME),)
	$(error Please specify TESTNAME on the make command line)
endif
	@(if [ ! -e ../testcodes/$(TESTNAME)/$(TESTNAME).bin ] ; then \
	    echo " >> ERROR: Test $(TESTNAME) has not been built" ;\
	  exit 1 ;\
  fi)
	@(if [ -e CXDT.bin ] ; then rm -f CXDT.bin; fi) ; \
  cp -f ../integration_cssoc/validation/bin/$(CXDT)/CXDT.bin . ; \
  od -v -A n -t x8 --width=16 ../testcodes/$(TESTNAME)/$(TESTNAME).bin | awk '{print $$2$$1}' > $(EXE_TB_DIR)/flash_main.ini ; \
  echo "run ${MAX_SIMULATION_TIME}" > run.tcl ; \
	touch image.hex
	@echo " >> Running testbench with $(SIMULATOR) and DSM=$(DSM)"
	$(RUN_LINE)

# run all tests
runall:
	@(for test in $(TEST_LIST) ; do \
	  make run TESTNAME=$$test; \
  done)
	@echo "---------------- SUMMARY OF RESULTS ------------------"
	@(for test in $(TEST_LIST) ; do \
    if grep -q "\*\* TEST PASSED \*\*" $(strip $(SIMULATOR))_$$test\_run.log ; then \
	    echo "    $$test PASSED" ;\
    else \
	    echo "    $$test FAILED" ;\
    fi \
  done)

################################################################################
# Clean
################################################################################
# Clean all test code
clean_tests:
	for test in $(TEST_LIST) ; do \
    if [ -d ../testcodes/$$test ] ; then \
      echo Cleaning $$test ...  ; \
      cd ../testcodes/$$test ; \
	    make clean; \
	    cd $(EXE_TB_DIR); \
    fi \
  done

# Clean compiled testbench
clean:
	@rm -rf work
	@rm -f simv
	@rm -rf csrc
	@rm -rf simv.daidir
	@rm -f ucli.key
	@rm -rf INCA_libs
	@rm -rf AN.DB
	@rm -f *.log
	@rm -f .vlogansetup.*
	@rm -f *.vcd
	@rm -f irun.key
	@rm -f comp.history
	@rm -f transcript
	@rm -f *.hex
	@rm -f *.bin
	@rm -rf CoreSightSystem.dot
	@rm -rf DVEfiles
	@rm -f run.tcl
	@rm -f *.vpd
	@rm -f *.err
	@rm -f *.ini
	@rm -rf dump.fsdb
	@rm -rf dump.vcd
	@rm -rf verdiLog

# Clean all test code and compile testbench
clean_all: clean_tests clean

