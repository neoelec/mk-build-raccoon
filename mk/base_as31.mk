# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

BASE_AS31_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
BASE_AS31_MK_DIR	:= $(patsubst %/,%,$(dir $(BASE_AS31_MK_FILE)))

# Target file name
TARGET			?=

# Output directories
BINDIR			?= bin
OBJDIR			?= obj

# Define output file
OUTPUT			?= $(addprefix $(BINDIR)/, $(TARGET))

# Source extension names
EXT_AS			?= asm s S

# VPATH variable
VPATH			?=

# Define all Assembler source files.
ASRCS			?=

# Assembler Options
ASFLAGS			+= -Fhex
ASFLAGS			+= -l

# Define programs and commands.
ifeq ($(origin AS),default)
AS			:= as31
endif
AS			?= as31

REMOVE			:= rm -rf
COPY			:= cp

# Define Messages
MSG_FLASH		:= Creating load file for Flash:
MSG_LINKING		:= Linking:
MSG_ASSEMBLING		:= Assembling:
MSG_CLEANING		:= Cleaning project:

# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_ASFLAGS		:= $(ASFLAGS)

all: build

build: as31version output

$(BINDIR) $(OBJDIR):
	@mkdir -p $@

as31version:
	@echo -n "$(AS) : "
	@echo `$(AS) -v`

# Assemble: create object files from assembler source files
define RULES_AS
AOBJS_$(1)		:= $(addprefix $(OBJDIR)/,\
	$(patsubst %.$(1),%.ihx,$(filter %.$(1),$(ASRCS))))
AOBJS			+= $$(AOBJS_$(1))
$$(AOBJS_$(1)): $(OBJDIR)/%.ihx: %.$(1) | $(OBJDIR)
	@echo
	@echo $(MSG_ASSEMBLING) $$<
	@mkdir -p $$(dir $$@)
	$(AS) $(ALL_ASFLAGS) -O$$@ $$<
	@if [ -f $$(patsubst %.$(1),%.lst,$$<) ]; then mv $$(patsubst %.$(1),%.lst,$$<) $$(dir $$@); fi
endef

$(foreach EXT, $(EXT_AS), $(eval $(call RULES_AS,$(EXT))))

HEX_FILE		:= $(OUTPUT).hex

$(HEX_FILE): $(AOBJS) | $(BINDIR)
	@echo
	@echo $(MSG_LINKING) $@
	srec_cat $(patsubst %.ihx,%.ihx -Intel,$^) -o $@ -Intel

output: hex

hex: $(HEX_FILE)

# Target: clean project.
clean: clean_list

clean_list:
	@echo
	@echo $(MSG_CLEANING)
	$(REMOVE) $(BINDIR)
	$(REMOVE) $(OBJDIR)

# Listing of phony targets.
.PHONY: all as31version \
		build hex output \
		clean clean_list
