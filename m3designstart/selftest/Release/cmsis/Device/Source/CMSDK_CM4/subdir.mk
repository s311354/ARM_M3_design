################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../cmsis/Device/Source/CMSDK_CM4/system_CMSDK_CM4.c 

S_SRCS += \
../cmsis/Device/Source/CMSDK_CM4/startup_CMSDK_CM4.s 

OBJS += \
./cmsis/Device/Source/CMSDK_CM4/startup_CMSDK_CM4.o \
./cmsis/Device/Source/CMSDK_CM4/system_CMSDK_CM4.o 


# Each subdirectory must supply rules for building sources it contributes
cmsis/Device/Source/CMSDK_CM4/%.o: ../cmsis/Device/Source/CMSDK_CM4/%.s
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Assembler 5'
	armasm --cpu=Cortex-M4 -g -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

cmsis/Device/Source/CMSDK_CM4/%.o: ../cmsis/Device/Source/CMSDK_CM4/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM C Compiler 5'
	armcc -DCORTEX_M4 -D__CC_ARM -DFPGA_IMAGE -DCMSDK_CM4 -I"C:\Work\V2M_MPS2_projects\cmsis_selftest\cmsis\CMSIS\Include" -I"C:\Work\V2M_MPS2_projects\cmsis_selftest\cmsis\Device\Include" -I"C:\Work\V2M_MPS2_projects\cmsis_selftest\cmsis\Device\Include\CMSDK_CM4" -I"C:\Work\V2M_MPS2_projects\cmsis_selftest\v2m_mps2" -I"C:\Work\V2M_MPS2_projects\cmsis_selftest\apmain" -O0 --cpu=Cortex-M4 -g -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


