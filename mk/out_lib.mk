# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

OUT_LIB_MK_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
OUT_LIB_MK_DIR		:= $(patsubst %/,%,$(dir $(OUT_LIB_MK_FILE)))

VERSION			?= 0
PATCHLEVEL		?= 0
SUBLEVEL		?= 0

ifeq ($(origin AR),default)
AR			:= $(CROSS_COMPILE)ar
endif
AR			?= $(CROSS_COMPILE)ar

STATIC_LIBRARY		?= $(BINDIR)/$(TARGET).a
DYNAMIC_LIBRARY		?= $(BINDIR)/$(TARGET).so.$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)

# Define Messages
MSG_ARCHIVING 		:= Archiving:

output: library

library: $(STATIC_LIBRARY) $(DYNAMIC_LIBRARY)

$(STATIC_LIBRARY): $(AOBJS) $(CXXOBJS) $(COBJS) | $(BINDIR)
	@echo
	@echo $(MSG_ARCHIVING) $@
	@mkdir -p $(dir $@)
	$(Q)$(AR) rcs $@ $^

$(DYNAMIC_LIBRARY): $(AOBJS) $(CXXOBJS) $(COBJS) | $(BINDIR)
	@echo
	@echo $(MSG_LINKING) $@
	@mkdir -p $(dir $@)
	$(Q)$(LD) -shared -fPIC -Wl,-soname,$(TARGET).so.$(VERSION) -o $@ $^
	$(Q)ln -fs $(notdir $@) $(dir $@)$(notdir $(TARGET)).so.$(VERSION)
	$(Q)ln -fs $(notdir $@) $(dir $@)$(notdir $(TARGET)).so

# Listing of phony targets.
.PHONY: output library
