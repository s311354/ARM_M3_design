################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := clean

# All of the sources participating in the build are defined here
-include sources.mk
-include v2m_mps2/subdir.mk
-include cmsis/Device/Source/CMSDK_CM3/subdir.mk
-include cmsis/Device/Source/subdir.mk
-include apuart/subdir.mk
-include aptsc/subdir.mk
-include aptimer/subdir.mk
-include apssp/subdir.mk
-include apmem/subdir.mk
-include apmain/subdir.mk
-include apleds/subdir.mk
-include aplan/subdir.mk
-include apclcd/subdir.mk
-include apaaci/subdir.mk
-include subdir.mk
-include objects.mk

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: Selftest.axf

# Tool invocations
Selftest.axf: $(OBJS) ../selftest.sct $(USER_OBJS) $(LIBS)
	@echo 'Building target: $@'
	@echo 'Invoking: ARM Linker 5'
	armlink --entry=Reset_Handler --scatter="../selftest.sct" --no_debug -o "Selftest.axf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS) $(EXECUTABLES) Selftest.axf 
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
