#!/usr/bin/env sh

set -e

b3sum "$ARTIFACT" > "$ARTIFACT.b3sum"
