# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

JLINK_MK_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
JLINK_MK_DIR		:= $(patsubst %/,%,$(dir $(JLINK_MK_FILE)))

JLINK_DIR		:= /opt/SEGGER/JLink

JFLASH			:= $(JLINK_DIR)/JFlashExe
JLINKGDB		:= $(JLINK_DIR)/JLinkGDBServerCLExe

JLINK_CHIP		?= AT91SAM7S256
JLINK_PORT		?= 2331

JFLASH_FLAGS		+= -auto
JFLASH_FLAGS		+= -startapp
JFLASH_FLAGS		+= -exit
JFLASH_FLAGS		+= -hide

JLINKGDB_FLAGS		+= -device $(JLINK_CHIP)
JLINKGDB_FLAGS		+= -noir
JLINKGDB_FLAGS		+= -noLocalhostOnly
JLINKGDB_FLAGS		+= -nologtofile
JLINKGDB_FLAGS		+= -port $(JLINK_PORT)

TRACE32_MODE		?= embedded

MSG_JFLASH		:= J-Flash:
MSG_JLINKGDB		:= J-Link GDB:

USE_JFLASH		?= y

ifeq ($(USE_JFLASH),y)
jflash: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_JFLASH) $<
	$(JFLASH) -open $< -openprj $(JFLASH_PRJ) $(JFLASH_FLAGS)

.PHONY: jflash
endif

jlinkgdb: $(DEBUG_SYMBOL)
	@echo
	@echo $(MSG_JLINKGDB) $<
	@$(JLINK_MK_DIR)/trace32.sh $(TRACE32_MODE) $< > target.cmm
	$(JLINKGDB) $(JLINKGDB_FLAGS)

clean: clean_jlinkgdb

clean_jlinkgdb:
	$(REMOVE) .gdbinit
	$(REMOVE) target.cmm

.PHONY: jlinkgdb clean_jlinkgdb
