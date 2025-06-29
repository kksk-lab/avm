#!/bin/bash

# Run script for avm AVM project
# This script runs the Around View Monitoring system

set -e # Exit on any error

# Get the project root directory (parent of scripts directory)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== Running avm AVM System ==="

# Check if executable exists
if [ ! -f "build/bin/avm" ]; then
    echo "Error: avm executable not found."
    echo "Please run the build script first: ./scripts/build.sh"
    exit 1
fi

# Check if required input images exist
REQUIRED_IMAGES=("assets/images/front.png" "assets/images/back.png" "assets/images/left.png" "assets/images/right.png")
MISSING_IMAGES=()

for img in "${REQUIRED_IMAGES[@]}"; do
    if [ ! -f "$img" ]; then
        MISSING_IMAGES+=("$img")
    fi
done

if [ ${#MISSING_IMAGES[@]} -gt 0 ]; then
    echo "Warning: Some required input images are missing:"
    for img in "${MISSING_IMAGES[@]}"; do
        echo "  - $img"
    done
    echo "The program may not work correctly without all input images."
    echo ""
fi

# Check if mask images exist
MASK_IMAGES=("assets/masks/maskFront.jpg" "assets/masks/maskBack.jpg" "assets/masks/maskLeft.jpg" "assets/masks/maskRight.jpg")
MISSING_MASKS=()

for mask in "${MASK_IMAGES[@]}"; do
    if [ ! -f "$mask" ]; then
        MISSING_MASKS+=("$mask")
    fi
done

if [ ${#MISSING_MASKS[@]} -gt 0 ]; then
    echo "Warning: Some required mask images are missing:"
    for mask in "${MISSING_MASKS[@]}"; do
        echo "  - $mask"
    done
    echo "The final stitching may not work correctly without all mask images."
    echo ""
fi

# Check if su7.png exists for final overlay
if [ ! -f "assets/images/su7.png" ]; then
    echo "Warning: su7.png overlay image is missing. Final image will not include the car overlay."
    echo ""
fi

echo "Starting AVM processing..."
echo "This will:"
echo "1. Detect corner points in fisheye camera images"
echo "2. Apply undistortion and perspective transformation"
echo "3. Generate bird's eye view images"
echo "4. Stitch images together with masks"
echo "5. Create final 360-degree around view image"
echo ""

# Run the program
./build/bin/avm

# Check if output was generated
if [ -f "build/stitched_result_with_su7.jpg" ]; then
    echo ""
    echo "=== AVM Processing completed successfully! ==="
    echo ""
    echo "Generated output files:"
    echo "  - build/stitched_result_with_su7.jpg (Final stitched image)"
    echo "  - build/bird_front_2.jpg, build/bird_back_2.jpg, build/bird_left_2.jpg, build/bird_right_2.jpg (Bird's eye views)"
    echo "  - build/*_img_contrast.jpg (Contrast enhanced images)"
    echo "  - build/*_img_thresh.jpg (Thresholded images with detected points)"
    echo "  - build/*_undis_1.jpg (Undistorted images with corner points)"
    echo ""
    echo "You can view the final result: build/stitched_result_with_su7.jpg"
else
    echo "=== Warning: Expected output file not found ==="
    echo "The program completed but build/stitched_result_with_su7.jpg was not generated."
    echo "This might be due to missing input files or processing errors."
fi
