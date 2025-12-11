#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$ROOT_DIR/out"

if [ ! -f "$ROOT_DIR/module.prop" ]; then
  echo "module.prop not found, aborting."
  exit 1
fi

VERSION="$(grep '^version=' "$ROOT_DIR/module.prop" | cut -d '=' -f2-)"
VERSION_CODE="$(grep '^versionCode=' "$ROOT_DIR/module.prop" | cut -d '=' -f2-)"
if [ -z "$VERSION" ] || [ -z "$VERSION_CODE" ]; then
  echo "Unable to read version information from module.prop, aborting."
  exit 1
fi
ZIP_NAME="Clash-MIX-${VERSION}-${VERSION_CODE}.zip"

mkdir -p "$OUTPUT_DIR"
cd "$ROOT_DIR"

echo "Building Magisk module package..."
zip -r9 "$OUTPUT_DIR/$ZIP_NAME" . \
  -x "*.git*" \
     "out/*" \
     "build.sh" \
     "*.md" \
     ".gitignore" \
     ".vscode/*" \
     ".idea/*" \
     "tests/*"
echo "Package created: $OUTPUT_DIR/$ZIP_NAME"
