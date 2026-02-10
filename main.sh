#!/usr/bin/env sh
set -e # be safe

MODE="$1"
export TARGET="$2"

if [ -z "$MODE" ]
then
	printf "Usage: main.sh backup /path/to/backup/\n"
	printf "Usage: main.sh restore /path/to/archive/\n"
	exit 1
fi

DATE_FMT="$(date +%Y-%m-%d)"

if [ -z "$TARGET" ]
then
	printf "No directory set, defaulting to backup_$DATE_FMT.\n"
	export TARGET="backup_$DATE_FMT"
fi

. ./config.sh

SCRIPT_DIR="$(pwd)/modules"
PIPELINE_DIR="$(pwd)/pipeline"

export ARTIFACT="$TARGET"

run_modules() {
	printf '*** RUNNING MODULES ***\n'

	find "$SCRIPT_DIR" -type f -name "$MODE.sh" -perm -u=x |
	while IFS= read -r module; do
		module_fmt=$(basename "$(dirname "$module")")
		printf "Running module: %s\n" "$module_fmt"

		if ! "$module"; then
			printf "Module failed, skipping.\n\n" >&2
			continue
		fi

		printf "Module succeeded.\n\n"
	done
}

run_pipeline() {
	SORT_FLAG=""

	if [ "$MODE" = "restore" ]; then
		SORT_FLAG="--reverse"
		export ARTIFACT="$TARGET"
	fi

	printf '*** RUNNING PIPELINE ***\n'

	find "$PIPELINE_DIR" -type f -name "$MODE.sh" -perm -u=x |
	sort $SORT_FLAG |
	while IFS= read -r module; do
		module_fmt=$(basename "$(dirname "$module")")
		printf "Running module: %s\n" "$module_fmt"

		new_artifact="$("$module")" || {
			printf "Module failed, exiting.\n\n" >&2
			exit 1
		}

		export ARTIFACT="$new_artifact"
	echo $ARTIFACT > /tmp/devobackup_temp
		printf "Module succeeded.\n\n"
	done
}

case "$MODE" in
	backup)
		run_modules
		run_pipeline
		;;
	restore)
		run_pipeline
	ARTIFACT=$(cat /tmp/devobackup_temp)
		run_modules
	rm -rf $ARTIFACT
	rm -rf /tmp/devobackup_temp
		;;
	*)
		printf "Unknown mode: %s\n" "$MODE" >&2
		exit 1
		;;
esac

printf "%s finished.\n" "$MODE"
