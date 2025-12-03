#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

source "$BASE_DIR/lib/core.sh"

LICENSE_FILE="$BASE_DIR/.rcyl2"
API_URL="https://auth.reviactyl.dev/public/api/license/check"

trim_license() {
    local RAW_KEY="$1"
    echo "$RAW_KEY" | tr -d '[:space:]'
}

validate_license() {
    local KEY
    KEY=$(trim_license "$1")

    RESPONSE=$(curl -s -X POST "$API_URL" \
        -H 'Content-Type: application/json' \
        -d "{\"key\":\"$KEY\"}"
    )

    VALID=$(echo "$RESPONSE" | grep -o '"valid":[ ]*true')

    if [ -z "$VALID" ]; then
        return 1
    else
        echo "$RESPONSE"
        return 0
    fi
}

prompt_for_license() {
    echo -e "$WARN License key not found or invalid."
    echo -ne "Enter your License Key: "
    read -r NEWKEY

    NEWKEY=$(trim_license "$NEWKEY")

    VALID_RESPONSE="$(validate_license "$NEWKEY")"
    if [ $? -ne 0 ]; then
        echo -e "$ERROR Invalid license key entered."
        exit 1
    fi

    echo "$NEWKEY" > "$LICENSE_FILE"
    echo -e "$SUCCESS License has been saved."

    show_license_info "$VALID_RESPONSE"
}

show_license_info() {
    JSON="$1"

    KEY=$(echo "$JSON" | grep -oP '"key":"\K[^"]+')
    DOMAIN=$(echo "$JSON" | grep -oP '"panel_url":"\K[^"]+')

    echo -e "$SUCCESS Your License '$KEY' is Active."
    echo "Product Edition: Community"
    echo "Product Domain: $DOMAIN"
}

if [ "$1" == "--update" ]; then
    echo -e "$INFO Updating License Key..."
    prompt_for_license
    exit 0
fi

if [ -f "$LICENSE_FILE" ]; then
    KEY=$(cat "$LICENSE_FILE")
    KEY=$(trim_license "$KEY")

    echo -e "$INFO Validating license..."

    VALID_RESPONSE="$(validate_license "$KEY")"
    if [ $? -eq 0 ]; then
        show_license_info "$VALID_RESPONSE"
    else
        echo -e "$WARN Saved license is invalid or expired."
        prompt_for_license
    fi

else
    prompt_for_license
fi

exit 0