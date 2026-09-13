# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

GCC_LIBRARY_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
GCC_LIBRARY_MK_DIR	:= $(patsubst %/,%,$(dir $(GCC_LIBRARY_MK_FILE)))

OUT_MK			?= $(GCC_LIBRARY_MK_DIR)/mk/out_lib.mk

include $(GCC_LIBRARY_MK_DIR)/mk/base_cc.mk

.PHONY: all exec run clean
