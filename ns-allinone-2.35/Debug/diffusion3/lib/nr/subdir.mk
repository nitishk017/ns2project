################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CC_SRCS += \
../diffusion3/lib/nr/nr.cc 

O_SRCS += \
../diffusion3/lib/nr/nr.o 

CC_DEPS += \
./diffusion3/lib/nr/nr.d 

OBJS += \
./diffusion3/lib/nr/nr.o 


# Each subdirectory must supply rules for building sources it contributes
diffusion3/lib/nr/%.o: ../diffusion3/lib/nr/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


