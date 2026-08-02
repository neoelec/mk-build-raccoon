#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2024 YOUNGJIN JOO (neoelec@gmail.com)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"

MODE="${1:-}"
DEBUG_SYMBOL="${2:-}"
TESTFLAGS="${3:-}"
GDBSERVER_PORT="${3:-2331}"

__gdb_localhost() {
    cat <<EOF
file ${DEBUG_SYMBOL}
break _start
run ${TESTFLAGS}
EOF

    if [ -f "${SCRIPT_DIR}/gdbinit" ]; then
        cat "${SCRIPT_DIR}/gdbinit"
    fi
}

__gdb_remote() {
    cat <<EOF
target remote :${GDBSERVER_PORT}
file ${DEBUG_SYMBOL}
break _start
continue
EOF

    if [ -f "${SCRIPT_DIR}/gdbinit" ]; then
        cat "${SCRIPT_DIR}/gdbinit"
    fi
}

case "${MODE}" in
    localhost)
        __gdb_localhost
        ;;
    remote)
        __gdb_remote
        ;;
    *)
        echo "Usage: $0 {localhost|remote} [debug_symbol] [flags_or_port]" >&2
        exit 1
        ;;
esac
