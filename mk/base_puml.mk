# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

BASE_PUML_MK_FILE	:= $(abspath $(lastword $(MAKEFILE_LIST)))
BASE_PUML_MK_DIR	:= $(patsubst %/,%,$(dir $(BASE_PUML_MK_FILE)))

PLANTUML_JAR		?= $(BASE_PUML_MK_DIR)/plantuml.jar

PUMLS			+=

SVGS			:= $(PUMLS:%.puml=%.svg)

MSG_DRAWING_SVG		:= Drawing SVG:

.SUFFIX: .puml .svg

all: svg

svg: $(SVGS)

$(SVGS): %.svg : %.puml
	@echo
	@echo $(MSG_DRAWING_SVG) $@
	@if [ ! -f $(PLANTUML_JAR) ]; then \
		$(BASE_PUML_MK_DIR)/down_puml.sh $(PLANTUML_JAR); \
	fi
	@java -jar $(PLANTUML_JAR) -tsvg $<

clean: clean_puml

clean_puml:
	@rm -f $(SVGS)

.PHONY: all svg
