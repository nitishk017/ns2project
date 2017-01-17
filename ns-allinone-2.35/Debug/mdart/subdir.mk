################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CC_SRCS += \
../mdart/mdart.cc \
../mdart/mdart_adp.cc \
../mdart/mdart_dht.cc \
../mdart/mdart_ndp.cc \
../mdart/mdart_neighbor.cc \
../mdart/mdart_queue.cc \
../mdart/mdart_table.cc 

O_SRCS += \
../mdart/mdart.o \
../mdart/mdart_adp.o \
../mdart/mdart_dht.o \
../mdart/mdart_ndp.o \
../mdart/mdart_neighbor.o \
../mdart/mdart_queue.o \
../mdart/mdart_table.o 

CC_DEPS += \
./mdart/mdart.d \
./mdart/mdart_adp.d \
./mdart/mdart_dht.d \
./mdart/mdart_ndp.d \
./mdart/mdart_neighbor.d \
./mdart/mdart_queue.d \
./mdart/mdart_table.d 

OBJS += \
./mdart/mdart.o \
./mdart/mdart_adp.o \
./mdart/mdart_dht.o \
./mdart/mdart_ndp.o \
./mdart/mdart_neighbor.o \
./mdart/mdart_queue.o \
./mdart/mdart_table.o 


# Each subdirectory must supply rules for building sources it contributes
mdart/%.o: ../mdart/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


