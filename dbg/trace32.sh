#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2025 YOUNGJIN JOO (neoelec@gmail.com)

set -euo pipefail

MODE="${1:-native}"
DEBUG_SYMBOL="${2:-}"

cat <<EOF
B::
PRIVATE &E_Func &E_Args
ENTRY &E_Func %LINE &E_Args
PRIVATE &ret
&G_RCN_PWD=OS.PresentPracticeDirectory()
ChDir &G_RCN_PWD
&G_RCN_Baremetal_Elf_File="${DEBUG_SYMBOL}"
DoRcn gdbserver/${MODE}.cmm &E_Func &E_Args
ENTRY &ret
ENDDO &ret
EOF
