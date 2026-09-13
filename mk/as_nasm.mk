# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

AS_NASM_FILE		:= $(abspath $(lastword $(MAKEFILE_LIST)))
AS_NASM_DIR		:= $(patsubst %/,%,$(dir $(AS_NASM_FILE)))

# select output file format
#  bin                  Flat raw binary (MS-DOS, embedded, ...) [default]
#  ith                  Intel Hex encoded flat binary
#  srec                 Motorola S-records encoded flat binary
#  aout                 Linux a.out
#  aoutb                NetBSD/FreeBSD a.out
#  coff                 COFF (i386) (DJGPP, some Unix variants)
#  elf32                ELF32 (i386) (Linux, most Unix variants)
#  elf64                ELF64 (x86-64) (Linux, most Unix variants)
#  elfx32               ELFx32 (ELF32 for x86-64) (Linux)
#  as86                 as86 (bin86/dev86 toolchain)
#  obj                  Intel/Microsoft OMF (MS-DOS, OS/2, Win16)
#  win32                Microsoft extended COFF for Win32 (i386)
#  win64                Microsoft extended COFF for Win64 (x86-64)
#  ieee                 IEEE-695 (LADsoft variant) object file format
#  macho32              Mach-O i386 (Mach, including MacOS X and variants)
#  macho64              Mach-O x86-64 (Mach, including MacOS X and variants)
#  dbg                  Trace of all info passed to output stage
#  elf                  Legacy alias for "elf32"
#  macho                Legacy alias for "macho32"
#  win                  Legacy alias for "win32"
NASMFMT			?= elf64

# select a debugging format (output format dependent)
#  elf32:     dwarf     ELF32 (i386) dwarf (newer) [default]
#             stabs     ELF32 (i386) stabs (older)
#  elf64:     dwarf     ELF64 (x86-64) dwarf (newer) [default]
#             stabs     ELF64 (x86-64) stabs (older)
#  elfx32:    dwarf     ELFx32 (x86-64) dwarf (newer) [default]
#             stabs     ELFx32 (x86-64) stabs (older)
#  obj:       borland   Borland Debug Records [default]
#  win32:     cv8       Codeview 8+ [default]
#  win64:     cv8       Codeview 8+ [default]
#  ieee:      ladsoft   LADsoft Debug Records [default]
#  macho32:   dwarf     Mach-O i386 dwarf for Darwin/MacOS [default]
#  macho64:   dwarf     Mach-O x86-64 dwarf for Darwin/MacOS [default]
#  dbg:       debug     Trace of all info passed to debug stage [default]
NASMDEBUG		?= dwarf

# optimize opcodes, immediates and branch offsets
#  0        no optimization
#  1        minimal optimization
#  x        multipass optimization (default)
NASMOPT			?= x

# Assembly Options
NASMFLAGS		+= -g -F $(NASMDEBUG)
NASMFLAGS		+= -f $(NASMFMT)
NASMFLAGS		+= -O$(NASMOPT) -Ov
NASMFLAGS		+= $(if $(ALL_INCLUDES),$(ALL_INCLUDES),$(patsubst %,-I%,$(EXTRAINCDIRS)))

ifeq ($(origin NASM),default)
NASM			:= nasm
endif
NASM			?= nasm

ALL_NASMFLAGS		:= $(NASMFLAGS)

sizebefore: | nasmversion

# Display assembler version information.
nasmversion:
	@$(NASM) -v

# Assemble: create object files from assembler source files
define RULES_NASM
AOBJS_$(1)		:= $(addprefix $(OBJDIR)/,\
	$(patsubst %.$(1),%.o,$(filter %.$(1),$(ASRCS))))
AOBJS			+= $$(AOBJS_$(1))
$$(AOBJS_$(1)): $(OBJDIR)/%.o : %.$(1) | $(OBJDIR)
	@echo
	@echo $(MSG_ASSEMBLING) $$<
	@mkdir -p $$(dir $$@)
	$(Q)$(NASM) $(ALL_NASMFLAGS) -l $$(@:.o=.lst) -o $$@ $$<
endef

$(foreach EXT, $(EXT_AS), $(eval $(call RULES_NASM,$(EXT))))

.PHONY: nasmversion
