#!/bin/sh

set -e

printf "Warning, this module might not backup every site, or any at all.\n"

BACKUP_PATH="$ARTIFACT/nginx/site"
SITES="$(grep -R '^[[:space:]]*root[[:space:]]' "$BACKUP_PATH/nginx.conf" 2>/dev/null | sed 's/.*root[[:space:]]\+\([^;]*\);.*/\1/' | grep '^/' | sort -u | tr '\n' ' ')"

for dir in $SITES
do
	corresponding_site="$(basename "$dir")"
	cp "$BACKUP_PATH/$corresponding_site" "$dir"
done
