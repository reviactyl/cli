#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

source "$BASE_DIR/lib/core.sh"

LOCAL_VERSION="$1"
API_URL="https://reviactyl.dev/api/v2/get-version"

JSON=$(curl -s --max-time 3 "$API_URL")
STATUS=$?

if [ $STATUS -ne 0 ] || [ -z "$JSON" ]; then
    echo "$WARN Failed to connect to reviactyl servers"
    exit 1
fi

REMOTE_VERSION=$(echo "$JSON" | grep -oP '"cli"\s*:\s*"\K[0-9]+\.[0-9]+\.[0-9]+')

if [ -z "$REMOTE_VERSION" ]; then
    echo "$WARN Invalid response from API"
    exit 1
fi

if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]; then
    echo "$INFO A new CLI version is available: $REMOTE_VERSION"
    echo "Please update before continuing."
    exit 1
fi

exit 0