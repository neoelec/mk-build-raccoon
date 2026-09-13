# SPDX-License-Identifier: MIT
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

OPENOCD_MK_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
OPENOCD_MK_DIR		:= $(patsubst %/,%,$(dir $(OPENOCD_MK_FILE)))

OPENOCD			:= openocd

OPENOCD_PORT		?= 2331

OPENOCDFLASH_FLAGS	+= $(OPENOCDFLAGS)

OPENOCDGDB_FLAGS	+= $(OPENOCDFLAGS)
OPENOCDGDB_FLAGS	+= --command "gdb_port $(OPENOCD_PORT)"

TRACE32_MODE		?= embedded

MSG_OPENOCDFLASH	:= OpenOCD Flash:
MSG_OPENOCDGDB		:= OpenOCD GDB:

USE_OPENOCDFLASH	?= y

ifeq ($(USE_OPENOCDFLASH),y)
openocdflash: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_OPENOCDFLASH) $<
	$(OPENOCD) --file $(OPENOCD_CFG) $(OPENOCDFLASH_FLAGS) \
			--command "program $< verify reset exit"

.PHONY: openocdflash
endif

openocdgdb: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_OPENOCDGDB) $<
	@$(OPENOCD_MK_DIR)/trace32.sh $(TRACE32_MODE) $< > target.cmm
	$(OPENOCD) --file $(OPENOCD_CFG) $(OPENOCDGDB_FLAGS)

clean: clean_openocdgdb

clean_openocdgdb:
	$(REMOVE) .gdbinit
	$(REMOVE) target.cmm

.PHONY: openocdgdb clean_openocdgdb
