#!/bin/bash

# =================================================================
#  Hassan's Downloads Organizer - Firmware & CS Edition
# =================================================================

TARGET_DIR="$HOME/Downloads"
cd "$TARGET_DIR" || exit

echo "🔧 Organizing $TARGET_DIR for a clean workspace..."

# 📂 Create the directory structure first
mkdir -p images documents archives web videos others scripts firmware general

# 🔄 Loop through every file in the current directory (non-recursive)
for file in *; do
    # Skip if it's a directory
    [[ -d "$file" ]] && continue

    # Extract extension and convert to lowercase
    ext="${file##*.}"
    ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

    case "$ext_lower" in
    # 🖼️ Images
    png | jpg | jpeg | svg | webp | gif | ico)
        mv "$file" images/
        ;;

    # 📄 Documents (SDLC handouts, PDFs, etc.)
    pdf | docx | doc | txt | pptx | xlsx)
        mv "$file" documents/
        ;;

    # 📦 Archives
    zip | tar | gz | 7z | rar | bz2 | xz)
        mv "$file" archives/
        ;;

    # 🌐 Web Files
    html | htm | css | js | php)
        mv "$file" web/
        ;;

    # 🎥 Videos
    mp4 | mkv | mov | avi | flv)
        mv "$file" videos/
        ;;

    # 💻 Scripts (C++, Python, Bash)
    sh | py | cpp | hpp | c | h | cmd | bat)
        mv "$file" scripts/
        ;;

    # 📟 Firmware & Hardware (STM32, JSON, etc.)
    json | hex | bin | elf | kicad_pcb | sch)
        mv "$file" firmware/
        ;;

    # 🛠️ Others (Partial downloads, specific tool formats)
    part | crdownload | tmp)
        mv "$file" others/
        ;;

    # 📥 General (Anything else)
    *)
        mv "$file" general/
        ;;
    esac
done

echo "✅ Done! Your $TARGET_DIR is now organized like an 1800-rated Chess game. ♟️🔥"
