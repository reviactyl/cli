#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

LICENSE_FILE="$BASE_DIR/.rcyl2"
API_URL="https://auth.reviactyl.dev/public/api/license/check"

source "$BASE_DIR/lib/core.sh"

validate_license() {
    local KEY="$1"

    RESPONSE=$(curl -s --fail -X POST "$API_URL" \
        -H 'Content-Type: application/json' \
        -d "{\"key\":\"$KEY\"}") || return 1

    VALID=$(echo "$RESPONSE" | grep -o '"valid":[ ]*true')

    if [ -n "$VALID" ]; then
        return 0
    fi

    return 1
}

if [ ! -f "$LICENSE_FILE" ]; then
    echo -e "$WARN License not found. Proceed to Add License."
    reviactyl license
    exit 0
fi

KEY=$(cat "$LICENSE_FILE" | tr -d '[:space:]')

echo -e "$INFO Connecting to auth.reviactyl.dev..."

if validate_license "$KEY"; then
    exit 0
else
    echo -e "$ERROR Your License is not valid. Please contact Reviactyl team."
    exit 1
fi