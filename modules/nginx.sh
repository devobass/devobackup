#!/usr/bin/env sh

if [ -z "${DVBK_CONF_NGINX_CONF_PATH:-}" ]
then
	printf "\tDVBK_CONF_NGINX_CONF_PATH env not set, edit config.sh and try again.\n"
	exit 1
fi

set -e
exec 2>&1

BACKUP_PATH="$DIR_NAME/nginx"
mkdir -p $BACKUP_PATH

cp -a "/etc/nginx/nginx.conf" "$BACKUP_PATH/"
