#!/usr/bin/env sh

set -e

OUTPUT="$ARTIFACT.tar"

tar -C "$(dirname "$ARTIFACT")" -cf "$OUTPUT" "$(basename "$ARTIFACT")"
rm -r "$ARTIFACT"

printf '%s\n' "$OUTPUT"
