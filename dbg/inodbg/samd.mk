# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

arduino.samd.adafruit_circuitplayground_m0.debug	:= jlink
arduino.samd.mzero_bl.debug		:= jlink
arduino.samd.mzero_pro_bl.debug		:= jlink
arduino.samd.mzero_pro_bl_dbg.debug	:= jlink
arduino.samd.mkr1000.debug		:= jlink
arduino.samd.mkrfox1200.debug		:= jlink
arduino.samd.mkrgsm1400.debug		:= jlink
arduino.samd.mkrnb1500.debug		:= jlink
arduino.samd.mkrvidor4000.debug		:= jlink
arduino.samd.mkrwan1300.debug		:= jlink
arduino.samd.mkrwan1310.debug		:= jlink
arduino.samd.mkrwifi1010.debug		:= jlink
arduino.samd.mkrzero.debug		:= jlink
arduino.samd.nano_33_iot.debug		:= jlink
arduino.samd.tian.debug			:= jlink
arduino.samd.arduino_zero_native.debug	:= jlink
arduino.samd.arduino_zero_edbg.debug	:= jlink

debug: $($(BOARD).debug)

.PHONY: debug
.PHONY: arduino.samd.adafruit_circuitplayground_m0.debug
.PHONY: arduino.samd.mzero_bl.debug
.PHONY: arduino.samd.mzero_pro_bl.debug
.PHONY: arduino.samd.mzero_pro_bl_dbg.debug
.PHONY: arduino.samd.mkr1000.debug
.PHONY: arduino.samd.mkrfox1200.debug
.PHONY: arduino.samd.mkrgsm1400.debug
.PHONY: arduino.samd.mkrnb1500.debug
.PHONY: arduino.samd.mkrvidor4000.debug
.PHONY: arduino.samd.mkrwan1300.debug
.PHONY: arduino.samd.mkrwan1310.debug
.PHONY: arduino.samd.mkrwifi1010.debug
.PHONY: arduino.samd.mkrzero.debug
.PHONY: arduino.samd.nano_33_iot.debug
.PHONY: arduino.samd.tian.debug
.PHONY: arduino.samd.arduino_zero_native.debug
.PHONY: arduino.samd.arduino_zero_edbg.debug
