# Start blockfrost-backend-ryo with the DB credentials from the Docker secrets.
# The image has no /bin/sh, so compose runs this file with the bash from the image.
set -euo pipefail
export PGPASSWORD="$(< "$PGPASSWORD_FILE")"
export BLOCKFROST_CONFIG_DBSYNC_USER="$(< "$BLOCKFROST_CONFIG_DBSYNC_USER_FILE")"
export BLOCKFROST_CONFIG_DBSYNC_DATABASE="$(< "$BLOCKFROST_CONFIG_DBSYNC_DATABASE_FILE")"
backend=(/nix/store/*-blockfrost-backend-ryo*/bin/blockfrost-backend-ryo)
exec "${backend[0]}"
