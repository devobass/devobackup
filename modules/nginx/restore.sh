#!/usr/bin/env sh

if [ -z "${DVBK_CONF_NGINX_CONF_PATH:-}" ]
then
	printf "DVBK_CONF_NGINX_CONF_PATH env not set, edit config.sh and try again.\n"
	exit 1
fi

set -e
exec 2>&1

BACKUP_PATH="$ARTIFACT/nginx"

find "$BACKUP_PATH" -type f |
while IFS= read -r files; do
	cp "$files" "$DVBK_CONF_NGINX_CONF_PATH" 
done
