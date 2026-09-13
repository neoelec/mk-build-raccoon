# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

INODBG_MK_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
INODBG_MK_DIR		:= $(patsubst %/,%,$(dir $(INODBG_MK_FILE)))

TRACE32_MODE		:= arduino

# forcley disable jflash
USE_JFLASH		:= n

include $(INODBG_MK_DIR)/jlink.mk

# forcely disable openocdflash
USE_OPENOCDFLASH	:= n

include $(INODBG_MK_DIR)/openocd.mk

debug_mk.arduino.renesas_uno.minima	:= $(INODBG_MK_DIR)/inodbg/renesas_uno.mk
debug_mk.arduino.renesas_uno.unor4wifi	:= $(INODBG_MK_DIR)/inodbg/renesas_uno.mk

debug_mk.arduino.sam.arduino_due_x	:= $(INODBG_MK_DIR)/inodbg/sam.mk
debug_mk.arduino.sam.arduino_due_x_dbg	:= $(INODBG_MK_DIR)/inodbg/sam.mk

debug_mk.arduino.samd.arduino_zero_native	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mkrvidor4000	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mzero_bl		:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mzero_pro_bl_dbg	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.adafruit_circuitplayground_m0	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mkrwifi1010	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.arduino_zero_edbg	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mzero_pro_bl	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.tian		:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mkrnb1500		:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mkr1000		:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.nano_33_iot	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mkrgsm1400	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mkrwan1310	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mkrwan1300	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mkrfox1200	:= $(INODBG_MK_DIR)/inodbg/samd.mk
debug_mk.arduino.samd.mkrzero		:= $(INODBG_MK_DIR)/inodbg/samd.mk

include $(debug_mk.$(BOARD))
