#!/usr/bin/env bash
# Syncs VS Code extensions from ~/.vscode to ~/.vscode-server
# This makes Nix-managed extensions available in VS Code Remote WSL

set -euo pipefail

SOURCE_DIR="$HOME/.vscode/extensions"
TARGET_DIR="$HOME/.vscode-server/extensions"

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Source directory $SOURCE_DIR does not exist"
    exit 1
fi

mkdir -p "$TARGET_DIR"

# Remove stale Nix-managed symlinks (point to /nix/store but no longer in source)
shopt -s nullglob
for target_path in "$TARGET_DIR"/*; do
    ext_name=$(basename "$target_path")

    # Skip metadata files
    [[ "$ext_name" == "extensions.json" || "$ext_name" == ".extensions-immutable.json" ]] && continue

    # Only clean up symlinks pointing to Nix store (not manual installs)
    if [[ -L "$target_path" ]] && [[ "$(readlink "$target_path")" == /nix/store/* ]]; then
        if [[ ! -e "$SOURCE_DIR/$ext_name" ]]; then
            rm "$target_path"
            echo "✗ $ext_name (removed stale)"
        fi
    fi
done

# Sync current extensions
for ext_path in "$SOURCE_DIR"/*; do
    ext_name=$(basename "$ext_path")

    # Skip metadata files
    [[ "$ext_name" == "extensions.json" || "$ext_name" == ".extensions-immutable.json" ]] && continue

    target_path="$TARGET_DIR/$ext_name"

    # Resolve symlink to get actual path (for Nix store paths)
    if [[ -L "$ext_path" ]]; then
        real_path=$(readlink -f "$ext_path")
    else
        real_path="$ext_path"
    fi

    # Check if target already exists and points to same location
    if [[ -L "$target_path" ]]; then
        existing_target=$(readlink -f "$target_path")
        if [[ "$existing_target" == "$real_path" ]]; then
            echo "✓ $ext_name (already synced)"
            continue
        fi
        # Remove stale symlink
        rm "$target_path"
    elif [[ -e "$target_path" ]]; then
        # Target exists but is not a symlink - skip to avoid overwriting manual installs
        echo "⊘ $ext_name (manual install exists, skipping)"
        continue
    fi

    # Create symlink
    ln -s "$real_path" "$target_path"
    echo "→ $ext_name (synced)"
done

# Update extensions.json with correct paths for .vscode-server
if [[ -f "$SOURCE_DIR/extensions.json" ]]; then
    sed 's|/.vscode/extensions/|/.vscode-server/extensions/|g' \
        "$SOURCE_DIR/extensions.json" > "$TARGET_DIR/extensions.json"
    echo "→ extensions.json (updated)"
fi

# Sync settings to .vscode-server for Remote WSL
SETTINGS_SRC="$HOME/.config/Code/User/settings.json"
SETTINGS_DST="$HOME/.vscode-server/data/Machine/settings.json"
if [[ -f "$SETTINGS_SRC" ]]; then
    mkdir -p "$(dirname "$SETTINGS_DST")"
    cp "$SETTINGS_SRC" "$SETTINGS_DST"
    echo "→ settings.json (synced)"
fi

echo ""
echo "Synced from $SOURCE_DIR to $TARGET_DIR"
