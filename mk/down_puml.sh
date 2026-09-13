#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0+
# Copyright (c) 2026 YOUNGJIN JOO (neoelec@gmail.com)

set -euo pipefail

PLANTUML_JAR="${1:-}"

if [ -z "${PLANTUML_JAR}" ]; then
    echo "Usage: $0 <target_jar_path>" >&2
    exit 1
fi

mkdir -p "$(dirname "${PLANTUML_JAR}")"

echo "Resolving latest PlantUML release URL..."
URL=$(wget -q -O - https://plantuml.com/download |
    perl -pe 's/</\n</g' |
    grep -E "plantuml-bsd.+Compiled jar" |
    perl -pe 's/^.+"(https[^"]+\.jar)".+$/$1/' || true)

if [ -z "${URL}" ]; then
    echo "Error: Failed to find PlantUML download URL." >&2
    exit 1
fi

echo "Downloading ${URL}..."
TMP_JAR="${PLANTUML_JAR}.tmp.$$"
trap 'rm -f "${TMP_JAR}"' EXIT INT TERM
wget -q --show-progress -O "${TMP_JAR}" "${URL}"
mv -f "${TMP_JAR}" "${PLANTUML_JAR}"
trap - EXIT INT TERM
echo "Successfully installed PlantUML to ${PLANTUML_JAR}"
