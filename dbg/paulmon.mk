# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

PAULMON_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
PAULMON_MK_DIR		:= $(patsubst %/,%,$(dir $(PAULMON_MK_FILE)))

# Define TTY Device.
TTY_DEV				?= /dev/ttyUSB0

MSG_PAULMON			:= Upload to PAULMON v2.1:

paulmon: build
	@echo
	@echo $(MSG_PAULMON) $(HEX_FILE)
	@ascii-xfr -s -l 1 -c 1 $(HEX_FILE) > $(TTY_DEV)

# Listing of phony targets.
.PHONY : paulmon
