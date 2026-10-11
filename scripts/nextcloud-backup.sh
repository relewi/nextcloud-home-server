
#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

# Nextcloud backup example
# Run as root on a properly configured Linux server.

NEXTCLOUD_DIR="/var/www/nextcloud"
DATA_DIR="/srv/nextcloud-data"
BACKUP_ROOT="/var/backups/nextcloud"
DB_NAME="nextcloud"

DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="$BACKUP_ROOT/$DATE"

MAINTENANCE_ON=false

cleanup() {
    if [ "$MAINTENANCE_ON" = true ]; then
        sudo -u www-data php "$NEXTCLOUD_DIR/occ" \
            maintenance:mode --off || true
    fi
}

trap cleanup EXIT

mkdir -p "$BACKUP_DIR"

echo "Starting Nextcloud backup..."

# Enable maintenance mode
sudo -u www-data php "$NEXTCLOUD_DIR/occ" \
    maintenance:mode --on
MAINTENANCE_ON=true

# Backup the database
mariadb-dump --single-transaction "$DB_NAME" \
    > "$BACKUP_DIR/database.sql"

# Backup Nextcloud files and user data
tar -czf "$BACKUP_DIR/nextcloud-files.tar.gz" \
    -C / "${NEXTCLOUD_DIR#/}" "${DATA_DIR#/}"

# Disable maintenance mode
sudo -u www-data php "$NEXTCLOUD_DIR/occ" \
    maintenance:mode --off
MAINTENANCE_ON=false

echo "Backup completed: $BACKUP_DIR"
