#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]
then
	echo "Not running as root, quitting early."
	exit 1
fi

if [ -z "${DVBK_CONF_NGINX_CONF_PATH:-}" ]
	echo "DVBK_CONF_NGINX_CONF_PATH env not set, edit config.sh and try again."
	exit 1
then

set -e
exec 2>&1

BACKUP_PATH="$BACKUP_DIR/nginx"
mkdir -p $BACKUP_PATH

cp -a "/etc/nginx/nginx.conf" "$BACKUP_PATH/"
