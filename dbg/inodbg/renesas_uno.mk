# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

OPENOCD_CFG		:= $(shell find $(ARDUINO_DIR) -name 'openocd.cfg' |\
			grep UNOWIFIR4)

arduino.renesas_uno.minima.debug	:= jlinkgdb
arduino.renesas_uno.unor4wifi.debug	:= openocdgdb

debug: $($(BOARD).debug)

.PHONY: debug
.PHONY: arduino.renesas_uno.minima.debug
.PHONY: arduino.renesas_uno.unor4wifi.debug
