#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]
then
	echo "Not running as root, quitting early."
	exit 1
fi

set -e

exec 2>&1

if command -v mcrcon > /dev/null
then
	echo "MCRCON not found."
	exit 1;
fi

if [ -z $MCRCON_PASS ]
then
	echo "MCRCON_PASS env not set, quitting."
	exit 1
fi

BACKUP_PATH="$1/minecraft"
MC_PATH="/var/www/minecraft"

mkdir -p "$BACKUP_PATH"

cleanup() {
	echo "Re-enabling world saves"
	mcrcon -p "$MCRCON_PASS" save-on || true
}
trap cleanup EXIT

mcrcon -p "$MCRCON_PASS" save-off
mcrcon -p "$MCRCON_PASS" "save-all flush"

cp -a "$MC_PATH/world" "$BACKUP_PATH/"
cp -a "$MC_PATH/mods" "$BACKUP_PATH/"
cp -a "$MC_PATH/EasyAuth" "$BACKUP_PATH/"
cp -a "$MC_PATH/config" "$BACKUP_PATH/"
cp -a "$MC_PATH/ops.json" "$BACKUP_PATH/"
cp -a "$MC_PATH/server.properties" "$BACKUP_PATH/"
