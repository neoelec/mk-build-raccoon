# SPDX-License-Identifier: MIT
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

BASE_CC_MK_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
BASE_CC_MK_DIR		:= $(patsubst %/,%,$(dir $(BASE_CC_MK_FILE)))

include $(BASE_CC_MK_DIR)/utils.mk

# Cross compile
CROSS_COMPILE		?=

# Target file name (without extension).
TARGET			?=

# Output directories
BINDIR			?= bin
OBJDIR			?= obj

# Define output file
OUTPUT			?= $(addprefix $(BINDIR)/, $(TARGET))

# Optimization level, can be [0, 1, 2, 3, s].
#     0 = turn off optimization. s = optimize for size.
#     (Note: 3 is not always the best optimization level.)
OPT			?= s

# Debugging format.
DEBUG			?=

# Compiler flag to set the C Standard level.
CSTANDARD		?= -std=c17
CXXSTANDARD		?= -std=c++17

# Makefile for assembler
AS_MK			?= $(BASE_CC_MK_DIR)/as_cc.mk

# Makefile for output
OUT_MK			?= $(BASE_CC_MK_DIR)/out_elf.mk

# Source extension names
EXT_CC			?= c
EXT_CXX			?= cc cpp cxx
EXT_AS			?= asm s S

# VPATH variable
VPATH			?=

# List C source files here.
CSRCS			?=

# List C++ source files here.
CXXSRCS			?=

# List Assembler source files here.
ASRCS			?=

# List include directories here (ChibiOS / Kbuild style: INCDIRS and EXTRAINCDIRS supported).
INCDIRS			?=
EXTRAINCDIRS		?=

# Place -D or -U options here
CDEFS			?=

# Place -I options here
CINCS			?=

# Deduplicate include directories and source files (preserving order)
ALL_INCDIRS		:= $(call uniq,$(INCDIRS) $(EXTRAINCDIRS))
ALL_INCLUDES		:= $(patsubst %,-I%,$(ALL_INCDIRS))
CSRCS			:= $(call uniq,$(CSRCS))
CXXSRCS			:= $(call uniq,$(CXXSRCS))
ASRCS			:= $(call uniq,$(ASRCS))
VPATH			:= $(call uniq,$(VPATH))

#---------------- C Preprocessor Options ----------------
CPPFLAGS		+= -Wall
CPPFLAGS		+= -g$(DEBUG)
CPPFLAGS		+= $(CDEFS) $(CINCS)
CPPFLAGS		+= -O$(OPT)
CPPFLAGS		+= $(ALL_INCLUDES)

#---------------- Compiler Options ----------------
CFLAGS			+= $(CSTANDARD)

#---------------- C++ Compiler Options ----------------
CXXFLAGS		+= $(CXXSTANDARD)

#---------------- Assembler Options ----------------
ASFLAGS			+=

#---------------- Linker Options ----------------
LDFLAGS			+= -Wl,-Map=$(OUTPUT).map,--cref

#============================================================================

# Define programs and commands.
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

ifeq ($(origin LD),default)
LD			:= $(CXX)
endif
LD			?= $(CXX)

REMOVE			:= rm -rf
COPY			:= cp

# Define Messages
# English
MSG_SIZE_BEFORE		:= Size before:
MSG_SIZE_AFTER		:= Size after:
MSG_EXTENDED_LISTING	:= Creating Extended Listing:
MSG_SYMBOL_TABLE	:= Creating Symbol Table:
MSG_LINKING		:= Linking:
MSG_COMPILING		:= Compiling:
MSG_ASSEMBLING		:= Assembling:
MSG_CLEANING		:= Cleaning project:

# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_CFLAGS		:= $(CPPFLAGS) $(CFLAGS)
ALL_CXXFLAGS		:= $(CPPFLAGS) $(CXXFLAGS)
ALL_ASFLAGS		:= $(CPPFLAGS) $(ASFLAGS)
ALL_LDFLAGS		:= $(CPPFLAGS) $(LDFLAGS)

# Validate mandatory TARGET variable (except for clean targets)
ifeq ($(filter clean% %clean,$(MAKECMDGOALS)),)
  ifeq ($(strip $(TARGET)),)
    $(call assert-not-empty,TARGET,Target name without extension)
  endif
endif

# Default target.
all: build

build: ccversion sizebefore output sizeafter

$(BINDIR) $(OBJDIR):
	@mkdir -p $@

ELF_TARGET		:= $(if $(ELF_FILE),$(ELF_FILE),$(OUTPUT).elf)

# Display size of file.
sizebefore: | ccversion
	@if [ -f $(ELF_TARGET) ]; then \
		echo; \
		echo $(MSG_SIZE_BEFORE); \
		$(SIZE) --format=berkeley --radix=10 $(ELF_TARGET) 2>/dev/null; \
		echo; \
	fi

# Ensure sizebefore finishes before output compilation/linking starts in parallel builds (-j)
output: | sizebefore

sizeafter: | output
	@if [ -f $(ELF_TARGET) ]; then \
		echo; \
		echo $(MSG_SIZE_AFTER); \
		$(SIZE) --format=berkeley --radix=10 $(ELF_TARGET) 2>/dev/null; \
		echo; \
	fi

# Display compiler version information.
ccversion:
	@$(CC) --version

# Compile: create object files from C source files.
define RULES_CC
COBJS_$(1)		:= $(addprefix $(OBJDIR)/,\
	$(patsubst %.$(1),%.o,$(filter %.$(1),$(CSRCS))))
COBJS			+= $$(COBJS_$(1))
$$(COBJS_$(1)): $(OBJDIR)/%.o : %.$(1) | $(OBJDIR)
	@echo
	@echo $(MSG_COMPILING) $$<
	@mkdir -p $$(dir $$@)
	$(Q)$(CC) -c -MMD -MP -MF$$(@:.o=.d) -MT$$@ $(ALL_CFLAGS) $$< -o $$@
endef

$(foreach EXT, $(EXT_CC), $(eval $(call RULES_CC,$(EXT))))

# Compile: create object files from C++ source files.
define RULES_CXX
CXXOBJS_$(1)		:= $(addprefix $(OBJDIR)/,\
	$(patsubst %.$(1),%.o,$(filter %.$(1),$(CXXSRCS))))
CXXOBJS			+= $$(CXXOBJS_$(1))
$$(CXXOBJS_$(1)): $(OBJDIR)/%.o : %.$(1) | $(OBJDIR)
	@echo
	@echo $(MSG_COMPILING) $$<
	@mkdir -p $$(dir $$@)
	$(Q)$(CXX) -c -MMD -MP -MF$$(@:.o=.d) -MT$$@ $(ALL_CXXFLAGS) $$< -o $$@
endef

$(foreach EXT, $(EXT_CXX), $(eval $(call RULES_CXX,$(EXT))))

-include $(AS_MK)
-include $(OUT_MK)

# Include dependency files generated by compiler (.d)
ALL_OBJS		:= $(COBJS) $(CXXOBJS) $(AOBJS)
-include $(ALL_OBJS:.o=.d)

# Target: clean project.
clean: clean_list

clean_list:
	@echo
	@echo $(MSG_CLEANING)
	$(Q)$(REMOVE) $(OBJDIR)
	$(Q)$(REMOVE) $(BINDIR)

# Listing of phony targets.
.PHONY: all sizebefore sizeafter ccversion \
		build elf lss sym \
		clean clean_list
