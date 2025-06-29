#!/bin/bash

# Cleanup script for avm AVM project
# This script removes all generated output files and build artifacts

set -e # Exit on any error

# Get the project root directory (parent of scripts directory)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== Cleaning up avm AVM Project ==="

# List of generated output files to remove
OUTPUT_FILES=(
    "stitched_result_with_su7.jpg"
    "bird_front.jpg"
    "bird_back.jpg"
    "bird_left.jpg"
    "bird_right.jpg"
    "bird_front_2.jpg"
    "bird_back_2.jpg"
    "bird_left_2.jpg"
    "bird_right_2.jpg"
    "front_img_contrast.jpg"
    "back_img_contrast.jpg"
    "left_img_contrast.jpg"
    "right_img_contrast.jpg"
    "front_img_thresh.jpg"
    "back_img_thresh.jpg"
    "left_img_thresh.jpg"
    "right_img_thresh.jpg"
    "front_undis_1.jpg"
    "back_undis_1.jpg"
    "left_undis_1.jpg"
    "right_undis_1.jpg"
    "front_undis.jpg"
    "back_undis.jpg"
    "left_undis.jpg"
    "right_undis.jpg"
)

# Remove generated output files
echo "Removing generated output files..."
REMOVED_COUNT=0
for file in "${OUTPUT_FILES[@]}"; do
    if [ -f "$file" ]; then
        rm "$file"
        echo "  Removed: $file"
        REMOVED_COUNT=$((REMOVED_COUNT + 1))
    fi
done

if [ $REMOVED_COUNT -eq 0 ]; then
    echo "  No generated output files found to remove."
else
    echo "  Removed $REMOVED_COUNT output files."
fi

# Remove build directory and all build artifacts
if [ -d "build" ]; then
    echo "Removing build directory..."
    rm -rf build
    echo "  Removed: build/ directory and all build artifacts"
else
    echo "  Build directory not found (already clean)."
fi

echo ""
echo "To rebuild and run the project:"
echo "  ./build.sh"
echo "  ./run.sh"
