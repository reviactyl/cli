#!/bin/bash

CLI_DIR="/opt/reviactyl"
SYMLINK="/usr/local/bin/reviactyl"
CLI_URL="https://github.com/reviactyl/cli/releases/latest/download/cli.tar.gz"

VERBOSE=0
if [[ "$1" == "-v" || "$1" == "--verbose" ]]; then
    VERBOSE=1
fi

run_cmd() {
    local CMD="$1"
    local MSG="$2"

    echo "[INFO] $MSG"
    if [ $VERBOSE -eq 1 ]; then
        eval "$CMD"
    else
        eval "$CMD" &>/dev/null
    fi

    if [ $? -ne 0 ]; then
        echo "[ERROR] Command failed: $CMD"
        exit 1
    fi
}

run_cmd "sudo rm -rf $CLI_DIR" "Removing existing installation..."

if [ ! -d "$CLI_DIR" ]; then
    run_cmd "sudo mkdir -p $CLI_DIR" "Creating CLI directory at $CLI_DIR"
fi

cd "$CLI_DIR" || { echo "[ERROR] Cannot access $CLI_DIR"; exit 1; }

run_cmd "curl -Lo cli.tar.gz $CLI_URL" "Downloading latest Reviactyl CLI..."

run_cmd "tar -xzvf cli.tar.gz" "Extracting CLI files..."
run_cmd "rm -f cli.tar.gz" "Removing downloaded archive..."

run_cmd "sudo chmod -R 755 $CLI_DIR" "Setting execute permissions for CLI files..."

if [ -L "$SYMLINK" ] || [ -f "$SYMLINK" ]; then
    run_cmd "sudo rm -f $SYMLINK" "Removing old symlink or file at $SYMLINK"
fi

run_cmd "sudo ln -s $CLI_DIR/reviactyl.sh $SYMLINK" "Creating global command 'reviactyl'"

echo "[SUCCESS] Reviactyl CLI upgraded successfully!"
echo "You can now run: reviactyl"
