#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]
then
	printf "\tNot running as root, quitting early.\n"
	exit 1
fi

if [ -z "${DVBK_CONF_MC_PATH:-}" ]
then
	printf "\tDVBK_CONF_MC_PATH env not set, edit config.sh and try again.\n"
	exit 1
fi


if ! command -v mcrcon > /dev/null
then
	printf "\tMCRCON not found.\n"
	exit 1;
fi

if [ -z "${MCRCON_PASS:-}" ]
then
	printf "\tMCRCON_PASS env not set, quitting.\n"
	exit 1
fi

set -e
exec 2>&1

BACKUP_PATH="$DIR_NAME/minecraft"

mkdir -p "$BACKUP_PATH"

cleanup() {
	printf "\tRe-enabling world saves\n"
	mcrcon -p "$MCRCON_PASS" save-on || true
}
trap cleanup EXIT

mcrcon -p "$MCRCON_PASS" save-off
mcrcon -p "$MCRCON_PASS" "save-all flush"

cp -a "$DVBK_CONF_MC_PATH/world" "$BACKUP_PATH/"
cp -a "$DVBK_CONF_MC_PATH/mods" "$BACKUP_PATH/"
cp -a "$DVBK_CONF_MC_PATH/EasyAuth" "$BACKUP_PATH/"
cp -a "$DVBK_CONF_MC_PATH/config" "$BACKUP_PATH/"
cp -a "$DVBK_CONF_MC_PATH/ops.json" "$BACKUP_PATH/"
cp -a "$DVBK_CONF_MC_PATH/server.properties" "$BACKUP_PATH/"
