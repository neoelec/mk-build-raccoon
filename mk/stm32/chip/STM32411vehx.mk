# SPDX-License-Identifier: MIT
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

ASRCS			+= startup_stm32f411vehx.s

# Linker Script
LD_SCRIPT		?= $(STM32CUBE_TEMPLATE)/STM32F411VEHX_FLASH.ld
