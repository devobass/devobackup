#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]
then
	echo "Not running as root, quitting early."
	exit 1
fi

set -e

exec 2>&1

BACKUP_PATH="$1"
mkdir -p $BACKUP_PATH/conduit

cp -a "/etc/conduit/conduit.toml" "$BACKUP_PATH/conduit/"
cp -a "/var/lib/conduit" "$BACKUP_PATH/conduit/"
