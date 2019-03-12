################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../cmsis/Device/Source/CMSDK_CM0/system_CMSDK_CM0.c 

S_SRCS += \
../cmsis/Device/Source/CMSDK_CM0/startup_CMSDK_CM0.s 

OBJS += \
./cmsis/Device/Source/CMSDK_CM0/startup_CMSDK_CM0.o \
./cmsis/Device/Source/CMSDK_CM0/system_CMSDK_CM0.o 


# Each subdirectory must supply rules for building sources it contributes
cmsis/Device/Source/CMSDK_CM0/%.o: ../cmsis/Device/Source/CMSDK_CM0/%.s
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Assembler 5'
	armasm --cpu=Cortex-M0 -g -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

cmsis/Device/Source/CMSDK_CM0/%.o: ../cmsis/Device/Source/CMSDK_CM0/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM C Compiler 5'
	armcc -DCORTEX_M0 -D__CC_ARM -DFPGA_IMAGE -DCMSDK_CM0 -I"C:\Work\V2M_MPS2_projects\cmsis_selftest\cmsis\CMSIS\Include" -I"C:\Work\V2M_MPS2_projects\cmsis_selftest\cmsis\Device\Include" -I"C:\Work\V2M_MPS2_projects\cmsis_selftest\cmsis\Device\Include\CMSDK_CM0" -I"C:\Work\V2M_MPS2_projects\cmsis_selftest\v2m_mps2" -I"C:\Work\V2M_MPS2_projects\cmsis_selftest\apmain" -O0 --cpu=Cortex-M0 -g -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


