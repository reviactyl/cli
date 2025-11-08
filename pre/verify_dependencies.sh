#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

source "$BASE_DIR/lib/core.sh"

REQUIRED=("unzip" "git" "curl")

for cmd in "${REQUIRED[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$WARN Missing dependency: $cmd"
        exit 1
    fi
done

exit 0