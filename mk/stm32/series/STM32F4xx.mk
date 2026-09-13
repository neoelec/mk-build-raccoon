# SPDX-License-Identifier: MIT
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

CSRCS			+= syscalls.c
CSRCS			+= sysmem.c
CSRCS			+= system_stm32f4xx.c

CPPFLAGS		+= -mcpu=cortex-m4
CPPFLAGS		+= -mfpu=fpv4-sp-d16
CPPFLAGS		+= -mfloat-abi=hard
CPPFLAGS		+= -mthumb
