#!/bin/bash
set -e

PICO8="/Applications/PICO-8.app/Contents/MacOS/pico8"
CART="berry.p8"

# Run from the project directory regardless of where the script is called from
cd "$(dirname "$0")"

if [[ ! -f "$PICO8" ]]; then
    echo "Error: PICO-8 not found at $PICO8" >&2
    exit 1
fi

echo "Building Berry..."

# Export to HTML/JS in headless mode
"$PICO8" "$CART" -export "berry.html"

# Export to .p8.png cartridge image
"$PICO8" "$CART" -export "berry.p8.png"

# Copy to export/ directory
mkdir -p export
cp berry.html export/
cp berry.js export/
cp berry.p8.png export/

echo "Done. Output: berry.html, berry.js, berry.p8.png, export/"
