#!/bin/bash

# Image Optimization Script
# This script creates optimized WebP versions and resized variants of your images
# ./optimize-images.sh
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Image Optimization Script${NC}"
echo "This will create optimized WebP versions of your images"
echo ""

# Check if required tools are installed
if ! command -v convert &> /dev/null && ! command -v magick &> /dev/null; then
    echo "ImageMagick is not installed."
    echo "Install it with: brew install imagemagick"
    exit 1
fi

# Determine which command to use (ImageMagick 7 uses 'magick', older versions use 'convert')
if command -v magick &> /dev/null; then
    CONVERT_CMD="magick"
else
    CONVERT_CMD="convert"
fi

# Create optimized directory if it doesn't exist
mkdir -p photos/optimized

# Function to optimize images in a directory
optimize_directory() {
    local source_dir=$1
    local dir_name=$(basename "$source_dir")

    echo -e "${GREEN}Processing $dir_name...${NC}"

    # Create output directory
    mkdir -p "photos/optimized/$dir_name"

    # Process each image
    for ext in jpg JPG jpeg JPEG; do
        for img in "$source_dir"/*."$ext"; do
            [ -e "$img" ] || continue

            filename=$(basename "$img")
            name="${filename%.*}"

            echo "  - Optimizing $filename"

            # Create WebP version (80% quality, good balance)
            $CONVERT_CMD "$img" -quality 80 -define webp:method=6 "photos/optimized/$dir_name/${name}.webp"

            # Create responsive sizes (optional - uncomment if needed)
            # $CONVERT_CMD "$img" -resize 800x -quality 80 "photos/optimized/$dir_name/${name}-800w.webp"
            # $CONVERT_CMD "$img" -resize 400x -quality 80 "photos/optimized/$dir_name/${name}-400w.webp"
        done
    done
}

# Optimize each photo directory
if [ -d "photos/Glacier" ]; then
    optimize_directory "photos/Glacier"
fi

if [ -d "photos/Seattle" ]; then
    optimize_directory "photos/Seattle"
fi

if [ -d "photos/SF" ]; then
    optimize_directory "photos/SF"
fi

if [ -d "photos/Spain" ]; then
    optimize_directory "photos/Spain"
fi

echo ""
echo -e "${GREEN}✓ Optimization complete!${NC}"
echo "Optimized images are in photos/optimized/"
echo ""
echo "Next steps:"
echo "1. Check the optimized images to ensure quality is acceptable"
echo "2. Run the script again with responsive sizes if needed (uncomment lines in script)"
echo "3. The HTML will automatically use WebP with JPEG fallback"
