################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../apmain/common.c \
../apmain/main.c \
../apmain/retarget.c \
../apmain/uart_stdout.c 

OBJS += \
./apmain/common.o \
./apmain/main.o \
./apmain/retarget.o \
./apmain/uart_stdout.o 


# Each subdirectory must supply rules for building sources it contributes
apmain/%.o: ../apmain/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM C Compiler 5'
	armcc -DCORTEX_M3 -D__CC_ARM -DFPGA_IMAGE -DCMSDK_CM3 -I"C:\Work\V2M_MPS2_projects\beid_selftest\cmsis\CMSIS\Include" -I"C:\Work\V2M_MPS2_projects\beid_selftest\cmsis\Device\Include" -I"C:\Work\V2M_MPS2_projects\beid_selftest\cmsis\Device\Include\CMSDK_CM3" -I"C:\Work\V2M_MPS2_projects\beid_selftest\v2m_mps2" -I"C:\Work\V2M_MPS2_projects\beid_selftest\apmain" -O0 --cpu=Cortex-M3 -g -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


