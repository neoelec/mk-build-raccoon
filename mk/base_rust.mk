# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

BASE_RUST_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
BASE_RUST_MK_DIR	:= $(patsubst %/,%,$(dir $(BASE_RUST_MK_FILE)))

CARGO			?= cargo

RSSRCS			+=

BUILDFLAGS		+=
RUNFLAGS		+=
CLEANFLAGS		+=

ifeq ($(RELEASE),y)
BUILDFLAGS		+= --release
OUTPUT			:= $(addprefix target/release/, $(TARGET))
else
OUTPUT			:= $(addprefix target/debug/, $(TARGET))
endif

ELF_FILE		:= $(OUTPUT).elf

DEBUG_SYMBOL		:= $(ELF_FILE)

# Define programs and commands.
REMOVE			:= rm -rf
COPY			:= cp

# Define Messages
# English
MSG_BUILDING		:= Building:
MSG_CLEANING		:= Cleaning project:

# Default target.
all: build

build: cargoversion output

cargoversion:
	@$(CARGO) --version

output: exec elf

run: $(OUTPUT)
	$(CARGO) run $(BUILDFLAGS) $(TESTFLAGS)

elf: $(ELF_FILE)

$(ELF_FILE): $(OUTPUT)
	$(COPY) $< $@

exec: $(OUTPUT)

$(OUTPUT): $(RSSRCS) | cargoversion
	@echo
	@echo $(MSG_BUILDING) $@
	$(CARGO) build $(BUILDFLAGS)

clean: clean_list

clean_list:
	@echo
	@echo $(MSG_CLEANING)
	$(REMOVE) $(OUTPUT).elf
	$(CARGO) clean $(CLEANFLAGS)

# Listing of phony targets.
.PHONY : all cargoversion \
		build run \
		clean clean_list
