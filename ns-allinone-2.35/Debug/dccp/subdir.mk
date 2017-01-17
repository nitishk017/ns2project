################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CC_SRCS += \
../dccp/dccp.cc \
../dccp/dccp_ackv.cc \
../dccp/dccp_opt.cc \
../dccp/dccp_packets.cc \
../dccp/dccp_sb.cc \
../dccp/dccp_tcplike.cc \
../dccp/dccp_tfrc.cc 

O_SRCS += \
../dccp/dccp.o \
../dccp/dccp_ackv.o \
../dccp/dccp_opt.o \
../dccp/dccp_packets.o \
../dccp/dccp_sb.o \
../dccp/dccp_tcplike.o \
../dccp/dccp_tfrc.o 

CC_DEPS += \
./dccp/dccp.d \
./dccp/dccp_ackv.d \
./dccp/dccp_opt.d \
./dccp/dccp_packets.d \
./dccp/dccp_sb.d \
./dccp/dccp_tcplike.d \
./dccp/dccp_tfrc.d 

OBJS += \
./dccp/dccp.o \
./dccp/dccp_ackv.o \
./dccp/dccp_opt.o \
./dccp/dccp_packets.o \
./dccp/dccp_sb.o \
./dccp/dccp_tcplike.o \
./dccp/dccp_tfrc.o 


# Each subdirectory must supply rules for building sources it contributes
dccp/%.o: ../dccp/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


