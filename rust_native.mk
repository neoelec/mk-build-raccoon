# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

RUST_NATIVE_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
RUST_NATIVE_MK_DIR	:= $(patsubst %/,%,$(dir $(RUST_NATIVE_MK_FILE)))

GDB			?= rust-gdb

include $(RUST_NATIVE_MK_DIR)/mk/base_rust.mk
include $(RUST_NATIVE_MK_DIR)/dbg/gdb.mk
