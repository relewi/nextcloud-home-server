#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

# Example Nextcloud backup script.
# Based on my home server backup setup.
# Review and test before using on a real server.

NEXTCLOUD_DIR="/var/www/nextcloud"
DATA_DIR="/srv/nextcloud-data"
BACKUP_ROOT="/var/backups/nextcloud"
DB_NAME="nextcloud"
KEEP_BACKUPS=4

DATE=$(date +%Y-%m-%d_%H-%M-%S)
TEMP_DIR="$BACKUP_ROOT/.incomplete-$DATE"
BACKUP_DIR="$BACKUP_ROOT/$DATE"

MAINTENANCE_ON=false

cleanup() {
    local status=$?
    trap - EXIT

    if [ "$MAINTENANCE_ON" = true ]; then
        if ! sudo -u www-data php "$NEXTCLOUD_DIR/occ" \
            maintenance:mode --off; then
            echo "ERROR: Could not disable maintenance mode." >&2
            status=1
        fi
    fi

    if [ "$status" -ne 0 ]; then
        echo "Backup failed. Check: $TEMP_DIR" >&2
    fi

    exit "$status"
}

trap cleanup EXIT

mkdir -p "$TEMP_DIR"

echo "Starting Nextcloud backup..."

# Enable maintenance mode
sudo -u www-data php "$NEXTCLOUD_DIR/occ" \
    maintenance:mode --on
MAINTENANCE_ON=true

# Export MariaDB database
mariadb-dump --single-transaction --quick "$DB_NAME" \
    > "$TEMP_DIR/database.sql"

# Archive application files and user data
tar -czf "$TEMP_DIR/nextcloud-files.tar.gz" \
    -C / "${NEXTCLOUD_DIR#/}" "${DATA_DIR#/}"

# Verify the archive can be read
tar -tzf "$TEMP_DIR/nextcloud-files.tar.gz" > /dev/null

# Disable maintenance mode
sudo -u www-data php "$NEXTCLOUD_DIR/occ" \
    maintenance:mode --off
MAINTENANCE_ON=false

# Mark the backup as complete
mv "$TEMP_DIR" "$BACKUP_DIR"

echo "Backup completed: $BACKUP_DIR"

# Keep the four newest completed backups
find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 \
    -type d -name '20??-??-??_??-??-??' \
    | sort -r | tail -n +"$((KEEP_BACKUPS + 1))" \
    | while IFS= read -r old_backup; do
        rm -rf -- "$old_backup"
    done

echo "Backup rotation completed."
