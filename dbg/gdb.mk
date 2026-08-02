# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GDB_MK_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
GDB_PATH		:= $(patsubst %/,%,$(dir $(GDB_MK_FILE)))

ifeq ($(origin GDB),default)
GDB			:= gdb
endif
GDB			?= gdb

GDB_FLAGS		?=
GDB_REMOTE_PORT		?= 2331

ifeq ($(origin GDBSERVER),default)
GDBSERVER		:= gdbserver
endif
GDBSERVER		?= gdbserver

GDBSERVER_PORT		?= 2331
GDBSERVER_FLAGS		?= localhost:$(GDBSERVER_PORT) $(DEBUG_SYMBOL)

TRACE32_MODE		?= native

MSG_GDB_LOCALHOST	:= GDB Local Host:
MSG_GDB_REMOTE		:= GDB Remote:
MSG_GDBSERVER		:= GDB Server:
MSG_TRACE32_CMM		:= Trace32 CMM:

gdb_localhost: $(OUTPUT) $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_GDB_LOCALHOST) $(DEBUG_SYMBOL)
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else : > .gdbinit; fi
	@$(GDB_PATH)/gdb.sh localhost $(DEBUG_SYMBOL) "$(TESTFLAGS)" >> .gdbinit
	@$(GDB) $(GDB_FLAGS)

gdb_remote:
	@echo
	@echo $(MSG_GDB_REMOTE) $(DEBUG_SYMBOL)
	@if [ -f gdbinit ]; then cat gdbinit > .gdbinit; else : > .gdbinit; fi
	@$(GDB_PATH)/gdb.sh remote $(DEBUG_SYMBOL) $(GDB_REMOTE_PORT) >> .gdbinit
	@$(GDB) $(GDB_FLAGS)

gdbserver: $(OUTPUT) $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_GDBSERVER) $(DEBUG_SYMBOL)
	@$(GDB_PATH)/trace32.sh $(TRACE32_MODE) $(DEBUG_SYMBOL) > target.cmm
	@$(GDBSERVER) $(GDBSERVER_FLAGS) $(TESTFLAGS)

trace32_cmm: $(OUTPUT) $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_TRACE32_CMM) $(DEBUG_SYMBOL)
	@$(GDB_PATH)/trace32.sh $(TRACE32_MODE) $(DEBUG_SYMBOL) > target.cmm

clean: clean_gdb

clean_gdb:
	$(REMOVE) .gdbinit
	$(REMOVE) target.cmm

.PHONY: gdb_localhost gdb_remote gdbserver trace32_cmm clean clean_gdb
