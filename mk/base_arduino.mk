# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

BASE_ARDUINO_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
BASE_ARDUINO_MK_DIR	:= $(patsubst %/,%,$(dir $(BASE_ARDUINO_MK_FILE)))

ifeq ($(origin ARDUINO_CLI),default)
ARDUINO_CLI		:= arduino-cli
endif
ARDUINO_CLI		?= arduino-cli

REMOVE			:= rm -rf
COPY			:= cp

PROJECT			?= $(notdir $(CURDIR))
SKETCH			?= $(PROJECT).ino

FQBN			?= $(shell $(ARDUINO_CLI) board list 2>/dev/null |\
			sed -e '/FQBN/d' | perl -pe 's/^.+ (\S+:\S+:\S+) .+$$/$$1/')
UPLOAD_PORT		?= $(shell $(ARDUINO_CLI) board list 2>/dev/null |\
			sed -e '/FQBN/d' | perl -pe 's/ .+$$//')

SRCS			?= $(wildcard *.ino)

BOARD			:= $(subst :,.,$(FQBN))
FQBN_FLAGS		:= --fqbn $(FQBN)

COMPILE_FLAGS		+= $(FQBN_FLAGS) --export-binaries
COMPILE_FLAGS		+= --clean

UPLOAD_FLAGS		+= $(FQBN_FLAGS) --port $(UPLOAD_PORT)
UPLOAD_FLAGS		+= --verify

BUILD_PATH		:= build/$(BOARD)
OUTPUT			:= $(BUILD_PATH)/$(SKETCH)
ELF_FILE		:= $(OUTPUT).elf
BIN_FILE		:= $(ELF_FILE:.elf=.bin)
HEX_FILE		:= $(ELF_FILE:.elf=.hex)
MAP_FILE		:= $(ELF_FILE:.elf=.map)

DEBUG_SYMBOL		:= $(ELF_FILE)

all: info $(ELF_FILE)

info:
	@if [ -z "$(FQBN)" ]; then \
		echo "[ERROR] No Arduino board (FQBN) detected or specified."; \
		exit 1; \
	fi
	@echo "[INFO] FQBN: $(FQBN), Port: $(UPLOAD_PORT)"

upload: $(ELF_FILE)
	@$(ARDUINO_CLI) upload $(UPLOAD_FLAGS)

clean:
	$(REMOVE) build

$(ELF_FILE): $(SRCS)
	@mkdir -p $(BUILD_PATH)
	$(ARDUINO_CLI) compile $(COMPILE_FLAGS)

.PHONY: all info upload clean
