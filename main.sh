#!/usr/bin/env sh

set -e # be safe

exec 2>&1
logger -t backup "Backup started"

export BACKUP_DIR="$1"
if [ -z $BACKUP_DIR ]
then
	echo "No backup directory specified, defaults to '.'"
	export BACKUP_DIR="."
fi

. ./config.sh

SCRIPT_DIR="$(pwd)/modules"
DATE_FMT="$(date +%Y-%m-%d)"
DIR_NAME="$BACKUP_DIR/backup_$DATE_FMT"

mkdir -p "$DIR_NAME"

find "$SCRIPT_DIR" -type f -perm -u=x | sort | while IFS= read -r module; do
	module_fmt=$(echo $module | awk -F '/' '{print $NF}')
	echo "Running module: $module_fmt"

	if ! "$module" "$DIR_NAME"; then
	echo "Module failed, skipping.\n" >&2
	fi
done


tar -cf "$DIR_NAME.tar" "$DIR_NAME"
rm -r "$DIR_NAME"

zstd -T0 --compress --rm "$DIR_NAME.tar"
zstd --test "$DIR_NAME.tar.zst"

if command -v b3sum > /dev/null
then
	b3sum "$DIR_NAME.tar.zst" > "$DIR_NAME.tar.zst.b3sum"
	exit 0
fi

echo "b3sum not found, skipping."
