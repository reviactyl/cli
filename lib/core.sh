#!/bin/bash

# CLI - Colours
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[97m"

# CLI - Styles
BOLD="\e[1m"
UNDERLINE="\e[4m"
RESET="\e[0m"

# CLI - Tags
INFO="${CYAN}[INFO]${RESET}"
WARN="${YELLOW}[WARN]${RESET}"
ERROR="${RED}[ERROR]${RESET}"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
INSTALL="${BLUE}[INSTALL]${RESET}"

# CLI - Progress Bar
PRIMARY_COLOR="\x1b[34;1m"
SECONDARY_COLOR="\033[0;2m"

cursor_up() { echo -en "\033[1A"; }

clear_line() { echo -en "\033[K"; }

cursor_start() { echo -en "\r"; }

draw_progress() {
  local progress=$1
  local total=$2
  local width=$(( $(tput cols) - 6 ))
  local percentage=$(( progress * 100 / total ))
  local filled=$(( width * progress / total ))
  local empty=$(( width - filled ))

  local bar="${PRIMARY_COLOR}"
  for ((i=0;i<filled;i++)); do bar+="─"; done
  bar+="${SECONDARY_COLOR}"
  for ((i=0;i<empty;i++)); do bar+="─"; done

  cursor_start
  clear_line
  echo -n -e "${bar} ${percentage}%\x1b[0m"
}