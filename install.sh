#!/usr/bin/env bash
set -euo pipefail

# Bail out with a uniform error message if any command fails
trap 'echo "❌ Error on line $LINENO: $BASH_COMMAND"; exit 1' ERR

# 1. Configuration
URL="https://github.com/kazisean/jab-coming-soon/releases/download/0.01/Jab-140.0.en-US.mac.dmg"
DMG_NAME="Jab-140.0.en-US.mac.dmg"
APP_NAME="Jab.app"
MOUNT_POINT=$(mktemp -d)

# 2. Download the DMG
echo "Downloading $DMG_NAME..."
if ! curl -fL -o "$DMG_NAME" "$URL"; then
  echo "❌ Failed to download '$DMG_NAME' from '$URL'"
  exit 1
fi

# 3. Mount the DMG (silent, no Finder window)
echo "Mounting DMG..."
if ! hdiutil attach "$DMG_NAME" \
    -mountpoint "$MOUNT_POINT" \
    -nobrowse -quiet; then
  echo "❌ Failed to mount '$DMG_NAME'"
  exit 1
fi

# 4. Copy the .app bundle to /Applications
echo "Copying $APP_NAME to /Applications..."
if ! cp -R "$MOUNT_POINT/$APP_NAME" /Applications/; then
  echo "❌ Failed to copy '$APP_NAME' to /Applications"
  exit 1
fi

# 5. Unmount and clean up
echo "Unmounting and cleaning up..."
if ! hdiutil detach "$MOUNT_POINT" -quiet; then
  echo "❌ Failed to unmount '$MOUNT_POINT'"
  # continue cleanup even if detach fails
fi

rm -rf "$MOUNT_POINT" "$DMG_NAME"

echo "✅ $APP_NAME has been installed."
