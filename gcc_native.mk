# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GCC_NATIVE_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
GCC_NATIVE_MK_DIR	:= $(patsubst %/,%,$(dir $(GCC_NATIVE_MK_FILE)))

include $(GCC_NATIVE_MK_DIR)/mk/base_cc.mk
include $(GCC_NATIVE_MK_DIR)/dbg/gdb.mk

all: $(OUTPUT)

$(OUTPUT): $(ELF_FILE)
	@mkdir -p $(dir $@)
	@$(COPY) $< $@
	@$(STRIP) $@

run: $(OUTPUT)
	$< $(TESTFLAGS)

clean: clean_native

clean_native:
	$(REMOVE) $(OUTPUT)

.PHONY: all run clean clean_native
