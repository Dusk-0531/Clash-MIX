#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$ROOT_DIR/out"

if [ ! -f "$ROOT_DIR/module.prop" ]; then
  echo "module.prop not found, aborting."
  exit 1
fi

if ! command -v zip >/dev/null 2>&1; then
  echo "zip command not found, aborting."
  exit 1
fi

MODULE_ID="$(grep '^id=' "$ROOT_DIR/module.prop" | cut -d '=' -f2-)"
VERSION="$(grep '^version=' "$ROOT_DIR/module.prop" | cut -d '=' -f2-)"
VERSION_CODE="$(grep '^versionCode=' "$ROOT_DIR/module.prop" | cut -d '=' -f2-)"
if [ -z "$MODULE_ID" ] || [ -z "$VERSION" ] || [ -z "$VERSION_CODE" ]; then
  echo "Unable to read module id/version information from module.prop, aborting."
  exit 1
fi

for field in MODULE_ID VERSION VERSION_CODE; do
  value="${!field}"
  case "$field" in
    VERSION_CODE)
      if [[ "$value" =~ [^0-9] ]]; then
        echo "Invalid value for $field: $value (digits only)"
        exit 1
      fi
      ;;
    *)
      if [[ "$value" =~ [^A-Za-z0-9._+-] ]]; then
        echo "Invalid value for $field: $value (allowed: letters, digits, ., _, -, +)"
        exit 1
      fi
      ;;
  esac
done

ZIP_NAME="${MODULE_ID}-${VERSION}-${VERSION_CODE}.zip"

mkdir -p "$OUTPUT_DIR"
cd "$ROOT_DIR"

EXCLUDES=(
  "*.git*"
  "out/*"
  "build.sh"
  "*.md"
  ".gitignore"
  ".vscode/*"
  ".idea/*"
  "tests/*"
  ".DS_Store"
  "node_modules/*"
  "__pycache__/*"
)

if [ -f "$ROOT_DIR/.buildignore" ]; then
  while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*$ ]] && continue
    case "$line" in
      \#*) continue ;;
    esac
    if [[ "$line" == /* || "$line" == ../* || "$line" == */../* || "$line" == *../* || "$line" == *//* || "$line" == ~* || "$line" == '*/..'* || "$line" == .. ]]; then
      echo "Invalid .buildignore entry: $line"
      exit 1
    fi
    EXCLUDES+=("$line")
  done < "$ROOT_DIR/.buildignore"
fi

echo "Building Magisk module package..."
if [ ${#EXCLUDES[@]} -gt 0 ]; then
  ZIP_ARGS=("-x" "${EXCLUDES[@]}")
else
  ZIP_ARGS=()
fi
zip -r9 "$OUTPUT_DIR/$ZIP_NAME" . "${ZIP_ARGS[@]}"
echo "Package created: $OUTPUT_DIR/$ZIP_NAME"
