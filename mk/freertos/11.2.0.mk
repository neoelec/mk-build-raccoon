# SPDX-License-Identifier: MIT
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

CSRCS			+= croutine.c
CSRCS			+= event_groups.c
CSRCS			+= list.c
CSRCS			+= queue.c
CSRCS			+= stream_buffer.c
CSRCS			+= tasks.c
CSRCS			+= timers.c

CSRCS			+= heap_$(FREERTOS_HEAP_TYPE).c
