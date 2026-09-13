# SPDX-License-Identifier: MIT
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

ASRCS			+= startup_stm32f439xx.s

# Linker Script
LD_SCRIPT		?= $(STM32CUBE_TEMPLATE)/STM32F439NIHx_FLASH.ld
