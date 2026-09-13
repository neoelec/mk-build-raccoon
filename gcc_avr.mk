# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GCC_AVR_MK_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
GCC_AVR_MK_DIR		:= $(patsubst %/,%,$(dir $(GCC_AVR_MK_FILE)))

CROSS_COMPILE		?= avr-

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

# MCU name
MCU			?= atmega128

# Processor frequency.
F_CPU			?= 16000000

# Output format. (can be srec, ihex, binary)
FORMAT			?= ihex

# Compiler flag to set the C Standard level.
CSTANDARD		?= -std=gnu17
CXXSTANDARD		?= -std=gnu++17

# Place -D or -U options here
CDEFS			+= -mmcu=$(MCU) -DF_CPU=$(F_CPU)UL

#---------------- Compiler Options ----------------
CPPFLAGS		+= -funsigned-char
CPPFLAGS		+= -funsigned-bitfields
CPPFLAGS		+= -fpack-struct
CPPFLAGS		+= -fshort-enums

#---------------- Assembler Options ----------------
ASFLAGS			+= -x assembler-with-cpp
ASFLAGS			+= -Wa,-gstabs,--listing-cont-lines=100

#---------------- External Memory Options ----------------
EXTMEMOPTS		?=

LDFLAGS			+= $(EXTMEMOPTS)
LDFLAGS			+= -Wl,--start-group -lc -lm -Wl,--end-group

OUT_MK			:= $(GCC_AVR_MK_DIR)/mk/out_avr.mk

include $(GCC_AVR_MK_DIR)/mk/base_cc.mk
include $(GCC_AVR_MK_DIR)/dbg/avrdude.mk
