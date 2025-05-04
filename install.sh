#!/usr/bin/env bash
set -euo pipefail

# 1. Configuration
URL="https://github.com/kazisean/jab-coming-soon/releases/download/0.01/Jab-140.0.en-US.mac.dmg"
DMG_NAME="Jab-140.0.en-US.mac.dmg"
APP_NAME="Jab.app"
MOUNT_POINT=$(mktemp -d)

# 2. Download the DMG
echo "Downloading $DMG_NAME..."
curl -L -o "$DMG_NAME" "$URL"

# 3. Mount the DMG (silent, no Finder window)
echo "Mounting DMG..."
hdiutil attach "$DMG_NAME" \
    -mountpoint "$MOUNT_POINT" \
    -nobrowse -quiet

# 4. Copy the .app bundle to /Applications
echo "Copying $APP_NAME to /Applications..."
cp -R "$MOUNT_POINT/$APP_NAME" /Applications/

# 5. Unmount and clean up
echo "Unmounting and cleaning up..."
hdiutil detach "$MOUNT_POINT" -quiet
rm -rf "$MOUNT_POINT" "$DMG_NAME"

echo "✅ $APP_NAME has been installed to /Applications."
