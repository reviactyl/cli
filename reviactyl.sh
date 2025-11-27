#!/bin/bash

CLI_VERSION="canary"

BASE_DIR="$(dirname "$(realpath "$0")")"
PRE_DIR="$BASE_DIR/pre"
SCRIPT_DIR="$BASE_DIR/scripts"

source "$BASE_DIR/lib/core.sh"

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
    echo ""
    if [ "$CLI_VERSION" != "canary" ]; then
    echo -e "      ${CYAN}${BOLD}Reviactyl CLI v$CLI_VERSION ${RESET}"
    else
    echo -e "      ${CYAN}${BOLD}Reviactyl CLI (Canary Release) ${RESET}"
    fi
    echo ""
    echo -e "${BOLD}${UNDERLINE}Usage:${RESET}"
    echo -e "${GREEN}$ ${RESET}reviactyl install"
    echo "Install Latest version of Reviactyl panel"
    echo ""
    echo -e "${GREEN}$ ${RESET}reviactyl upgrade"
    echo "Upgrade to Latest version of Reviactyl panel"
    echo ""
    echo -e "${GREEN}$ ${RESET}reviactyl uninstall"
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
        echo -e "${RED}Unknown command: ${RESET}$1"
        echo "Use: reviactyl help"
        exit 1
        ;;
esac