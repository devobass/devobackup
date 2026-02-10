#!/usr/bin/env sh

set -e # be safe

exec 2>&1
logger -t backup "Backup started"

BACKUP_DIR="$1"
if [ -z $BACKUP_DIR ]
then
	printf "No backup directory specified, defaults to '.'\n\n"
	export BACKUP_DIR="."
fi

. ./config.sh

SCRIPT_DIR="$(pwd)/modules"
DATE_FMT="$(date +%Y-%m-%d)"
export DIR_NAME="$BACKUP_DIR/backup_$DATE_FMT"

mkdir -p "$DIR_NAME"

find "$SCRIPT_DIR" -type f -perm -u=x | sort | while IFS= read -r module; do
	module_fmt=$(printf $module | awk -F '/' '{print $NF}')
	printf "Running module: $module_fmt\n"

	if ! "$module" "$DIR_NAME"; then
	printf "Module failed, skipping.\n\n" >&2
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

printf "b3sum not found, skipping."
