# SPDX-License-Identifier: MIT
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

GCC_STM32_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
GCC_STM32_MK_DIR	:= $(patsubst %/,%,$(dir $(GCC_STM32_MK_FILE)))

CROSS_COMPILE		?= arm-none-eabi-

ifeq ($(origin CC),default)
CC			:= $(CROSS_COMPILE)gcc
endif
CC			?= $(CROSS_COMPILE)gcc

ifeq ($(origin CXX),default)
CXX			:= $(CROSS_COMPILE)g++
endif
CXX			?= $(CROSS_COMPILE)g++

OBJCOPY			?= $(CROSS_COMPILE)objcopy
OBJDUMP			?= $(CROSS_COMPILE)objdump
SIZE			?= $(CROSS_COMPILE)size
STRIP			?= $(CROSS_COMPILE)strip
NM			?= $(CROSS_COMPILE)nm

# Chip & board used for compilation
# (can be overriden by adding CHIP=chip and BOARD=board to the command-line)
BOARD			?= nucleo-f439zi
PLATFORM		?= nucleo-f439zi

include $(GCC_STM32_MK_DIR)/mk/stm32/platform/$(PLATFORM).mk
include $(GCC_STM32_MK_DIR)/mk/stm32/series/$(SERIES).mk
include $(GCC_STM32_MK_DIR)/mk/stm32/chip/$(CHIP).mk

# Output directories
BINDIR			?= bin
OBJDIR			?= obj

# Append OBJ and BIN directories to output filename
OUTPUT			?= $(addprefix $(BINDIR)/, $(TARGET)-$(BOARD)-$(CHIP))

STM32DRIVERS_DIR	:= $(STM32CUBE_DIR)/Drivers

VPATH			+= $(STM32DRIVERS_DIR)/$(SERIES)_HAL_Driver/Src
EXTRAINCDIRS		+= $(STM32DRIVERS_DIR)/$(SERIES)_HAL_Driver/Inc

VPATH			+= $(STM32DRIVERS_DIR)/CMSIS/Device/ST/$(SERIES)/Source/Templates
EXTRAINCDIRS		+= $(STM32DRIVERS_DIR)/CMSIS/Device/ST/$(SERIES)/Include

CSRCS			?=
ASRCS			?=

#---------------- Compiler Options ----------------
CPPFLAGS		+= -DUSE_HAL_DRIVER
CPPFLAGS		+= -D$(SERIES)
CPPFLAGS		+= -D$(FAMILY)
CPPFLAGS		+= -ffunction-sections
CPPFLAGS		+= -fdata-sections
CPPFLAGS		+= -fstack-usage
CPPFLAGS		+= --specs=nano.specs

#---------------- Assembler Options ----------------
ASFLAGS			+= -D__ASSEMBLY__

#---------------- Linker Options ----------------
LDFLAGS			+= -T"$(LD_SCRIPT)"
LDFLAGS			+= -Wl,--gc-sections
LDFLAGS			+= -static
LDFLAGS			+= -Wl,--start-group -lc -lm -Wl,--end-group

include $(GCC_STM32_MK_DIR)/mk/base_cc.mk

ifneq ($(strip $(CHIP)),)
OPENOCD_CFG		:= $(GCC_STM32_MK_DIR)/mk/stm32/openocd/$(CHIP).cfg
endif

include $(GCC_STM32_MK_DIR)/dbg/openocd.mk
