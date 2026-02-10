#!/usr/bin/env sh

set -e

OUTPUT="$(echo $ARTIFACT | sed 's/.\{4\}$//')"

tar -xf "$ARTIFACT" >&2

printf '%s\n' "$OUTPUT"
