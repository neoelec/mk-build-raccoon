# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

arduino.sam.arduino_due_x.debug		:= jlink
arduino.sam.arduino_due_x_dbg.debug	:= jlink

debug: $($(BOARD).debug)

.PHONY: debug
.PHONY: arduino.sam.arduino_due_x.debug
.PHONY: arduino.sam.arduino_due_x_dbg.debug
