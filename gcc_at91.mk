# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GCC_AT91_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
GCC_AT91_MK_DIR		:= $(patsubst %/,%,$(dir $(GCC_AT91_MK_FILE)))

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
BOARD			?= at91sam7s-ek
PLATFORM		?= at91sam7s-ek

include $(GCC_AT91_MK_DIR)/mk/at91/platform/$(PLATFORM).mk

# Trace level used for compilation
# (can be overriden by adding TRACE_LEVEL=#number to the command-line)
# TRACE_LEVEL_DEBUG      5
# TRACE_LEVEL_INFO       4
# TRACE_LEVEL_WARNING    3
# TRACE_LEVEL_ERROR      2
# TRACE_LEVEL_FATAL      1
# TRACE_LEVEL_NO_TRACE   0
TRACE_LEVEL		?= 0

# Output directories
BINDIR			?= bin
OBJDIR			?= obj

# Append OBJ and BIN directories to output filename
OUTPUT			?= $(addprefix $(BINDIR)/, $(TARGET)-$(BOARD)-$(CHIP))

VPATH			+= $(AT91LIB)/utility

EXTRAINCDIRS		+= $(AT91LIB)

CSRCS			?=
ASRCS			?=

#---------------- Compiler Options ----------------
CPPFLAGS		+= -D$(CHIP)
CPPFLAGS		+= -DTRACE_LEVEL=$(TRACE_LEVEL)
CPPFLAGS		+= -mlong-calls
CPPFLAGS		+= -ffunction-sections
CPPFLAGS		+= --param=min-pagesize=0

#---------------- Assembler Options ----------------
ASFLAGS			+= -D__ASSEMBLY__

#---------------- Linker Options ----------------
LDFLAGS			+= -T"$(LD_SCRIPT)"
LDFLAGS			+= -nostartfiles
LDFLAGS			+= -Wl,--gc-sections
LDFLAGS			+= -static
LDFLAGS			+= -Wl,--start-group -lc -lm -Wl,--end-group

include $(GCC_AT91_MK_DIR)/mk/base_cc.mk

ifneq ($(strip $(CHIP)),)
JLINK_CHIP		:= $(call uc,$(CHIP))
JFLASH_PRJ		:= $(GCC_AT91_MK_DIR)/mk/at91/jflash/$(CHIP).jflash
endif

include $(GCC_AT91_MK_DIR)/dbg/jlink.mk
