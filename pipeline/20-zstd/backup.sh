#!/usr/bin/env sh

set -e

OUTPUT="$ARTIFACT.zst"

zstd -T0 --compress --rm -o "$OUTPUT" "$ARTIFACT"
zstd --test "$OUTPUT"

printf '%s\n' "$OUTPUT"
