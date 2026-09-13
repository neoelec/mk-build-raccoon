# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

BASE_FREERTOS_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
BASE_FREERTOS_MK_DIR	:= $(patsubst %/,%,$(dir $(BASE_FREERTOS_MK_FILE)))

VPATH			+= $(FREERTOS_KERNEL_DIR)
VPATH			+= $(FREERTOS_KERNEL_DIR)/portable/$(FREERTOS_PORT)
VPATH			+= $(FREERTOS_KERNEL_DIR)/portable/MemMang
EXTRAINCDIRS		+= $(FREERTOS_KERNEL_DIR)/include
EXTRAINCDIRS		+= $(FREERTOS_KERNEL_DIR)/portable/$(FREERTOS_PORT)

include $(BASE_FREERTOS_MK_DIR)/freertos/$(FREERTOS_VERSION).mk
