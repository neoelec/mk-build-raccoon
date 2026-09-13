# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

BASE_CMSIS_FREERTOS_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
BASE_CMSIS_FREERTOS_MK_DIR	:= $(patsubst %/,%,$(dir $(BASE_CMSIS_FREERTOS_MK_FILE)))

VPATH			+= $(CMSIS_FREERTOS_DIR)/CMSIS/RTOS2/FreeRTOS/Source
EXTRAINCDIRS		+= $(CMSIS_FREERTOS_DIR)/CMSIS/RTOS2/FreeRTOS/Include
