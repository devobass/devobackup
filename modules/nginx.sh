#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]
then
	echo "Not running as root, quitting early."
	exit 1
fi

set -e

exec 2>&1

BACKUP_PATH="$1/nginx"
mkdir -p $BACKUP_PATH

cp -a "/etc/nginx/nginx.conf"	"$BACKUP_PATH/"
cp -a "/var/www/pages" "$BACKUP_PATH/"
cp -a "/var/www/profile" "$BACKUP_PATH/"
cp -a "/var/www/librespeed" "$BACKUP_PATH/"
