#!/usr/bin/env bash

SRC=$HOME/.local/share/trilium-data/
DST=$HOME/.secure_vault/

mkdir -p "$DST"

if [ -f "$SRC/document.db" ]; then
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

    cp "$SRC/document.db" "$DST/trilium_notes.db"
    echo "Backup created Successfully: $TIMESTAMP"
else
    echo "ERROR: Trilium database not found at $SRC"
    exit 1
fi
