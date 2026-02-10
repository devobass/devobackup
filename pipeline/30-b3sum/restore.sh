#!/usr/bin/env sh

set -e

b3sum -c "$ARTIFACT.b3sum" > /dev/null && printf "Archive checksum ok.\n" >&2 || printf "WARNING: b3sum mismatch, your backup might be corrupted!\n" >&2

printf '%s\n' "$ARTIFACT"
