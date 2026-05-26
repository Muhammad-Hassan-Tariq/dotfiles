#!/usr/bin/env bash

set -e

SRC="$HOME/.secure_vault"
SNAPS="$HOME/.secure_vault/.snapshots"

mkdir -p "$SNAPS/n-1" "$SNAPS/n-2" "$SNAPS/n-3"

# shift snapshots safely
rm -rf "$SNAPS/n-2/"*
mv "$SNAPS/n-1/"* "$SNAPS/n-2/" 2>/dev/null

# create new snapshot
rsync -av --exclude ".*" "$SRC/" "$SNAPS/n-1/"
