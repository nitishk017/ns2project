################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CC_SRCS += \
../tmix/tmix.cc \
../tmix/tmixAgent.cc \
../tmix/tmix_delaybox.cc 

O_SRCS += \
../tmix/tmix.o \
../tmix/tmixAgent.o \
../tmix/tmix_delaybox.o 

CC_DEPS += \
./tmix/tmix.d \
./tmix/tmixAgent.d \
./tmix/tmix_delaybox.d 

OBJS += \
./tmix/tmix.o \
./tmix/tmixAgent.o \
./tmix/tmix_delaybox.o 


# Each subdirectory must supply rules for building sources it contributes
tmix/%.o: ../tmix/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


