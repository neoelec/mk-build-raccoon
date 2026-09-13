# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

OUT_ELF_MK_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
OUT_ELF_MK_DIR		:= $(patsubst %/,%,$(dir $(OUT_ELF_MK_FILE)))

output: elf lss sym

ELF_FILE		?= $(OUTPUT).elf
LSS_FILE		?= $(ELF_FILE:.elf=.lss)
SYM_FILE		?= $(ELF_FILE:.elf=.sym)

DEBUG_SYMBOL		?= $(ELF_FILE)

elf: $(ELF_FILE)
lss: $(LSS_FILE)
sym: $(SYM_FILE)

# Create extended listing file from ELF output file.
%.lss: %.elf
	@echo
	@echo $(MSG_EXTENDED_LISTING) $@
	@mkdir -p $(dir $@)
	$(Q)$(OBJDUMP) -h -S $< > $@

# Create a symbol table from ELF output file.
%.sym: %.elf
	@echo
	@echo $(MSG_SYMBOL_TABLE) $@
	@mkdir -p $(dir $@)
	$(Q)$(NM) -n $< > $@

# Link: create ELF output file from object files.
$(ELF_FILE): $(AOBJS) $(CXXOBJS) $(COBJS) | $(BINDIR)
	@echo
	@echo $(MSG_LINKING) $@
	@mkdir -p $(dir $@)
	$(Q)$(LD) $^ -o $@ $(ALL_LDFLAGS)

# Listing of phony targets.
.PHONY: output elf lss sym
