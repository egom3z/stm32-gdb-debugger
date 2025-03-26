#!/bin/sh

USER_PROJ="$1"
if [ -z "$USER_PROJ" ]; then
  echo "Usage: $0 <USER_PROJ>" >&2
  exit 1
fi

# Pattern to match the ELF files for the given USER_PROJ
MATCH="build/bin/kernel_${USER_PROJ}_*.elf"
FILES=$(ls -t $MATCH 2>/dev/null)

if [ -z "$FILES" ]; then
  echo "No matching ELF files for USER_PROJ=${USER_PROJ}" >&2
  exit 1
fi

# Pick the most recent file
LATEST=$(echo "$FILES" | head -n 1)
LINK=".vscode/latest.elf"

# Obtain an absolute path in a portable way
LATEST_DIR=$(dirname "$LATEST")
LATEST_FILE=$(basename "$LATEST")
cd "$LATEST_DIR" || exit 1
ABS_PATH="$(pwd -P)/$LATEST_FILE"
cd - > /dev/null || exit 1

rm -f "$LINK"
ln -s "$ABS_PATH" "$LINK"

echo "Linked $LINK -> $ABS_PATH"
