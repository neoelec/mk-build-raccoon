# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

# Programming hardware: alf avr910 avrisp bascom bsd
# dt006 pavr picoweb pony-stk200 sp12 stk200 stk500
#
# Type: avrdude -c ?
# to get a full listing.
#
AVRDUDE_PROGRAMMER		?= usbtiny

# com1 = serial port. Use lpt1 to connect to parallel port.
#AVRDUDE_PORT			:= -P com1	# programmer connected to serial device
AVRDUDE_PORT			?=

AVRDUDE_WRITE_FLASH		:= -U flash:w:$(HEX_FILE)
AVRDUDE_WRITE_EEPROM		:= -U eeprom:w:$(EEP_FILE)

# Uncomment the following if you want avrdude's erase cycle counter.
# Note that this counter needs to be initialized first using -Yn,
# see avrdude manual.
#AVRDUDE_ERASE_COUNTER		:= -y
AVRDUDE_ERASE_COUNTER		?=

# Uncomment the following if you do /not/ wish a verification to be
# performed after programming the device.
#AVRDUDE_NO_VERIFY		:= -V
AVRDUDE_NO_VERIFY		?=

# Increase verbosity level.  Please use this when submitting bug
# reports about avrdude. See <http://savannah.nongnu.org/projects/avrdude>
# to submit bug reports.
#AVRDUDE_VERBOSE		:= -v -v
AVRDUDE_VERBOSE			?=

AVRDUDE_FLAGS			+= -p $(MCU)
AVRDUDE_FLAGS			+= -c $(AVRDUDE_PROGRAMMER)
AVRDUDE_FLAGS			+= $(AVRDUDE_PORT)
AVRDUDE_FLAGS			+= $(AVRDUDE_NO_VERIFY)
AVRDUDE_FLAGS			+= $(AVRDUDE_VERBOSE)
AVRDUDE_FLAGS			+= $(AVRDUDE_ERASE_COUNTER)

# Define programs and commands.
AVRDUDE				:= avrdude

MSG_AVRDUDE			:= Upload with AVRDUDE :

# Program the device.
avrdude: build
	@echo
	@echo $(MSG_AVRDUDE) $(HEX_FILE) $(EEP_FILE)
	@$(AVRDUDE) $(AVRDUDE_FLAGS) \
		`if [ -f $(HEX_FILE) ]; then echo "$(AVRDUDE_WRITE_FLASH)"; fi` \
		`if [ -f $(EEP_FILE) ]; then echo "$(AVRDUDE_WRITE_EEPROM)"; fi`

# Listing of phony targets.
.PHONY : avrdude
