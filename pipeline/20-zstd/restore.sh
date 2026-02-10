#!/usr/bin/env sh

set -e

OUTPUT="$(echo $ARTIFACT | sed 's/.\{4\}$//')"

zstd -T0 --decompress -o "$OUTPUT" "$ARTIFACT" >&2

printf '%s\n' "$OUTPUT"
