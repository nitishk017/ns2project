################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CC_SRCS += \
../puma/puma.cc 

O_SRCS += \
../puma/puma.o 

CC_DEPS += \
./puma/puma.d 

OBJS += \
./puma/puma.o 


# Each subdirectory must supply rules for building sources it contributes
puma/%.o: ../puma/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


