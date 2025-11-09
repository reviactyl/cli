#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

source "$BASE_DIR/lib/core.sh"

VERBOSE=0
if [[ "$1" == "-v" || "$1" == "--verbose" ]]; then
    VERBOSE=1
fi

PROGRESS_TOTAL=9
PROGRESS_NOW=0
draw_progress "$PROGRESS_NOW" "$PROGRESS_TOTAL"

run_cmd() {
    local CMD="$1"
    local MSG="$2"

    echo -e "\n$INSTALL $MSG"

    if [ $VERBOSE -eq 1 ]; then
        eval "$CMD"
    else
        eval "$CMD" &>/dev/null
    fi

    if [ $? -ne 0 ]; then
        echo -e "$ERROR Command failed: $CMD"
        exit 1
    fi

    PROGRESS_NOW=$((PROGRESS_NOW + 1))
    draw_progress "$PROGRESS_NOW" "$PROGRESS_TOTAL"
}

echo -e "\n$INFO Uninstalling Reviactyl..."

run_cmd "cp -rf .env ../rcyl2.env.bak" "Backing up existing .env to ../rcyl2.env.bak"
run_cmd "rm -rf *" "Cleaning current directory..."
run_cmd "curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz" "Downloading latest panel release..."
run_cmd "tar -xzvf panel.tar.gz" "Extracting panel.tar.gz..."
run_cmd "chmod -R 755 storage/* bootstrap/cache/" "Setting permissions for storage/ and bootstrap/cache/..."
run_cmd "COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader" "Installing composer dependencies..."
run_cmd "php artisan migrate --seed --force" "Running database migrations..."

WEBUSER_LIST=("www-data" "nginx" "apache")
for USER in "${WEBUSER_LIST[@]}"; do
    if id "$USER" &>/dev/null; then
        run_cmd "chown -R $USER:$USER /var/www/pterodactyl/*" "Setting ownership to $USER..."
    fi
done

run_cmd "sudo systemctl restart pteroq.service" "Restarting pteroq service..."

PROGRESS_NOW=$PROGRESS_TOTAL
draw_progress "$PROGRESS_NOW" "$PROGRESS_TOTAL"
echo -e "\n$SUCCESS Reviactyl Panel uninstallation completed successfully!"
