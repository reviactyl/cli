#!/bin/bash

REQUIRED_DIRS=("app" "public" "routes")
REQUIRED_FILES=("tailwind.config.js")

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "[WARN] You cannot run this command outside of Pterodactyl directory."
        exit 1
    fi
done

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "[WARN] You cannot run this command outside of Pterodactyl directory."
        exit 1
    fi
done

exit 0