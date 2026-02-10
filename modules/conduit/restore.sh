#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]
then
	printf "Not running as root, quitting early.\n"
	exit 1
fi

if [ -z "${DVBK_CONF_CONDUIT_PATH:-}" ]
then
	printf "DVBK_CONF_CONDUIT_PATH env not set, edit config.sh and try again.\n"
	exit 1
fi

if [ -z "${DVBK_CONF_CONDUIT_VAR_PATH:-}" ]
then
	printf "DVBK_CONF_CONDUIT_PATH env not set, edit config.sh and try again.\n"
	exit 1
fi

set -e
exec 2>&1

BACKUP_PATH="$ARTIFACT/conduit"

cp "$BACKUP_PATH/conduit.toml" "$DVBK_CONF_CONDUIT_PATH/"

find "$BACKUP_PATH/var/" -type f |
while IFS= read -r files; do
	cp "$files" "$DVBK_CONF_CONDUIT_VAR_PATH" 
done
