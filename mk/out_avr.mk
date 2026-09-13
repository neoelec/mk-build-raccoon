# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

OUT_AVR_MK_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
OUT_AVR_MK_DIR		:= $(patsubst %/,%,$(dir $(OUT_AVR_MK_FILE)))

include $(OUT_AVR_MK_DIR)/out_elf.mk

# Define additional targets.
MSG_FLASH		:= Creating load file for Flash:
MSG_EEPROM		:= Creating load file for EEPROM:

HEX_FILE		?= $(ELF_FILE:.elf=.hex)
EEP_FILE		?= $(ELF_FILE:.elf=.eep)

output: hex eep

hex: $(HEX_FILE)
eep: $(EEP_FILE)

# Create final output files (.hex, .eep) from ELF output file.
%.hex: %.elf
	@echo
	@echo $(MSG_FLASH) $@
	@mkdir -p $(dir $@)
	$(Q)$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

%.eep: %.elf
	@echo
	@echo $(MSG_EEPROM) $@
	@mkdir -p $(dir $@)
	$(Q)$(OBJCOPY) -j .eeprom --set-section-flags .eeprom=alloc,load --change-section-lma .eeprom=0 -O $(FORMAT) $< $@

.PHONY: hex eep
