#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$ROOT_DIR/out"

VERSION="$(grep '^version=' "$ROOT_DIR/module.prop" | cut -d '=' -f2-)"
VERSION_CODE="$(grep '^versionCode=' "$ROOT_DIR/module.prop" | cut -d '=' -f2-)"
ZIP_NAME="Clash-MIX-${VERSION}-${VERSION_CODE}.zip"

mkdir -p "$OUTPUT_DIR"
cd "$ROOT_DIR"

zip -r9 "$OUTPUT_DIR/$ZIP_NAME" . \
  -x "*.git*" \
     "out/*" \
     "build.sh"
