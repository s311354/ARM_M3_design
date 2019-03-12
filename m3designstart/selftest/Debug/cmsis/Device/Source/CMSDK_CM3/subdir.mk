################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../cmsis/Device/Source/CMSDK_CM3/system_CMSDK_CM3.c 

S_SRCS += \
../cmsis/Device/Source/CMSDK_CM3/startup_CMSDK_CM3.s 

OBJS += \
./cmsis/Device/Source/CMSDK_CM3/startup_CMSDK_CM3.o \
./cmsis/Device/Source/CMSDK_CM3/system_CMSDK_CM3.o 


# Each subdirectory must supply rules for building sources it contributes
cmsis/Device/Source/CMSDK_CM3/%.o: ../cmsis/Device/Source/CMSDK_CM3/%.s
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Assembler 5'
	armasm --cpu=Cortex-M3 -g -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

cmsis/Device/Source/CMSDK_CM3/%.o: ../cmsis/Device/Source/CMSDK_CM3/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM C Compiler 5'
	armcc -DCORTEX_M3 -D__CC_ARM -DFPGA_IMAGE -DCMSDK_CM3 -I"C:\Work\V2M_MPS2_projects\beid_selftest\cmsis\CMSIS\Include" -I"C:\Work\V2M_MPS2_projects\beid_selftest\cmsis\Device\Include" -I"C:\Work\V2M_MPS2_projects\beid_selftest\cmsis\Device\Include\CMSDK_CM3" -I"C:\Work\V2M_MPS2_projects\beid_selftest\v2m_mps2" -I"C:\Work\V2M_MPS2_projects\beid_selftest\apmain" -O0 --cpu=Cortex-M3 -g -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


