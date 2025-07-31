#!/bin/bash

# Source and destination directories
SRC_DIR="$PWD/claude"
DEST_DIR="$HOME/.claude"

# Check if destination directory exists
if [ ! -d "$DEST_DIR" ]; then
  echo "Destination directory $DEST_DIR does not exist. Exiting."
  exit 1
fi

# Copy agents directory
cp -R "$SRC_DIR/agents" "$DEST_DIR/"

# Copy hooks directory
cp -R "$SRC_DIR/hooks" "$DEST_DIR/"

# Copy commands directory
cp -R "$SRC_DIR/commands" "$DEST_DIR/"

# Copy settings.json
cp "$SRC_DIR/settings.json" "$DEST_DIR/"

# Copy CLAUDE.md to user settings
cp "$SRC_DIR/CLAUDE.md" "$DEST_DIR/"

echo "Copied agents, hooks, commands, settings.json, and CLAUDE.md to $DEST_DIR"