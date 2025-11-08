#!/bin/bash

CLI_VERSION="canary"

BASE_DIR="$(dirname "$(realpath "$0")")"
PRE_DIR="$BASE_DIR/pre"
SCRIPT_DIR="$BASE_DIR/scripts"

# Executed before all commands
run_prerun() {

    bash "$PRE_DIR/verify_dependencies.sh" || exit 1

    if [ "$CLI_VERSION" != "canary" ]; then
        bash "$PRE_DIR/update_checker.sh" "$CLI_VERSION" || exit 1
    fi

    bash "$PRE_DIR/verify_pterodactyl_directory.sh" || exit 1
}

# Help Panel
show_help() {
    if [ "$CLI_VERSION" != "canary" ]; then
    echo "Reviactyl CLI v$CLI_VERSION"
    else
    echo "Reviactyl CLI (Canary Release)"
    fi
    echo ""
    echo "Usage:"
    echo "$ reviactyl install"
    echo "Install Latest version of Reviactyl panel"
    echo ""
    echo "$ reviactyl upgrade"
    echo "Upgrade to Latest version of Reviactyl panel"
    echo ""
    echo "$ reviactyl uninstall"
    echo "Remove existing installation of Reviactyl panel"
    echo ""
    exit 0
}

case "$1" in
    install)
        run_prerun
        bash "$SCRIPT_DIR/install.sh"
        ;;
    upgrade)
        run_prerun
        bash "$SCRIPT_DIR/upgrade.sh"
        ;;
    uninstall)
        run_prerun
        bash "$SCRIPT_DIR/uninstall.sh"
        ;;
    ""|help|-h|--help)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use: reviactyl help"
        exit 1
        ;;
esac