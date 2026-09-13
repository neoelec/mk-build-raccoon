#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"

MODE="${1:-}"
DEBUG_SYMBOL="${2:-}"

__gdb_localhost() {
    local testflags="${1:-}"
    if [ -n "${DEBUG_SYMBOL}" ]; then
        echo "file ${DEBUG_SYMBOL}"
    fi
    echo "break _start"
    echo "run${testflags:+ ${testflags}}"

    if [ -f "${SCRIPT_DIR}/gdbinit" ]; then
        cat "${SCRIPT_DIR}/gdbinit"
    fi
}

__gdb_remote() {
    local port="${1:-2331}"
    echo "target remote :${port}"
    if [ -n "${DEBUG_SYMBOL}" ]; then
        echo "file ${DEBUG_SYMBOL}"
    fi
    echo "break _start"
    echo "continue"

    if [ -f "${SCRIPT_DIR}/gdbinit" ]; then
        cat "${SCRIPT_DIR}/gdbinit"
    fi
}

case "${MODE}" in
    localhost)
        __gdb_localhost "${3:-}"
        ;;
    remote)
        __gdb_remote "${3:-2331}"
        ;;
    *)
        echo "Usage: $0 {localhost|remote} [debug_symbol] [flags_or_port]" >&2
        exit 1
        ;;
esac
