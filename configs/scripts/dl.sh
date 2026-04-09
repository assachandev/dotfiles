#!/bin/bash
MUSIC_DIR="$(dirname "$0")"

read -p "Artist/Folder (default: .): " folder
folder="${folder:-.}"

dest="$MUSIC_DIR/$folder"
mkdir -p "$dest"

read -p "URL: " url

yt-dlp -x --audio-format mp3 --embed-thumbnail --add-metadata \
  -o "$dest/%(title)s [%(id)s].%(ext)s" "$url"

mpc update --wait
mpc add "$(mpc listall | tail -1)"

echo "Done!"
