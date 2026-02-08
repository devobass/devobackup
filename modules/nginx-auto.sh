#!/bin/sh

set -e

if [ -z "${DVBK_CONF_NGINX_CONF_PATH:-}" ]
then
	echo "DVBK_CONF_NGINX_CONF_PATH env not set, edit config.sh and try again."
	exit 1
fi

echo "Warning, this module might not backup every site, or any at all."

SITES="$(grep -R '^[[:space:]]*root[[:space:]]' "$DVBK_CONF_NGINX_CONF_PATH" 2>/dev/null | sed 's/.*root[[:space:]]\+\([^;]*\);.*/\1/' | grep '^/' | sort -u | tr '\n' ' ')"

BACKUP_PATH="$DIR_NAME/nginx"
mkdir -p $BACKUP_PATH

for dir in $SITES
do
	echo $dir
	cp -a "$dir" "$BACKUP_PATH"
done
