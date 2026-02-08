#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]
then
	printf "\tNot running as root, quitting early.\n"
	exit 1
fi

if [ -z "${DVBK_CONF_CONDUIT_PATH:-}" ]
then
	printf "\tDVBK_CONF_CONDUIT_PATH env not set, edit config.sh and try again.\n"
	exit 1
fi

if [ -z "${DVBK_CONF_CONDUIT_VAR_PATH:-}" ]
then
	printf "\tDVBK_CONF_CONDUIT_PATH env not set, edit config.sh and try again.\n"
	exit 1
fi

set -e
exec 2>&1

mkdir -p $DIR_NAME/conduit

cp -a "$DVBK_CONF_CONDUIT_PATH/conduit.toml" "$DIR_NAME/conduit/"
cp -a "$DVBK_CONF_CONDUIT_VAR_PATH" "$DIR_NAME/conduit/"
