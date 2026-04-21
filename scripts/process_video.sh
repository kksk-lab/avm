#!/bin/bash

# ============================================
# AVM Video Stitching Processing Script
# ============================================
# 
# This script demonstrates how to use the AVM system
# for processing multi-camera video input
#
# Usage:
#   ./scripts/process_video.sh <front_video> <back_video> <left_video> <right_video> [output_file]
#
# Examples:
#   ./scripts/process_video.sh front.mp4 back.mp4 left.mp4 right.mp4
#   ./scripts/process_video.sh front.mp4 back.mp4 left.mp4 right.mp4 my_output.mp4
#   ./scripts/process_video.sh videos/front.mp4 videos/back.mp4 videos/left.mp4 videos/right.mp4 output.mp4

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if AVM executable exists
if [ ! -f "build/bin/avm" ]; then
    print_error "AVM executable not found at build/bin/avm"
    print_info "Please build the project first:"
    print_info "  ./scripts/build.sh"
    exit 1
fi

# Check command line arguments
if [ $# -lt 4 ]; then
    print_error "Insufficient arguments"
    echo ""
    echo "Usage: $0 <front_video> <back_video> <left_video> <right_video> [output_file]"
    echo ""
    echo "Arguments:"
    echo "  <front_video>    Path to front camera video (mp4, avi, mov, etc.)"
    echo "  <back_video>     Path to back camera video"
    echo "  <left_video>     Path to left camera video"
    echo "  <right_video>    Path to right camera video"
    echo "  [output_file]    Output video path (optional, default: build/stitched_output.mp4)"
    echo ""
    echo "Examples:"
    echo "  $0 front.mp4 back.mp4 left.mp4 right.mp4"
    echo "  $0 front.mp4 back.mp4 left.mp4 right.mp4 output.mp4"
    echo "  $0 /data/videos/front.mp4 /data/videos/back.mp4 /data/videos/left.mp4 /data/videos/right.mp4"
    exit 1
fi

# Parse arguments
FRONT_VIDEO="$1"
BACK_VIDEO="$2"
LEFT_VIDEO="$3"
RIGHT_VIDEO="$4"
OUTPUT_VIDEO="${5:-build/stitched_output.mp4}"

# Validate input files exist
print_info "Validating input files..."
for video in "$FRONT_VIDEO" "$BACK_VIDEO" "$LEFT_VIDEO" "$RIGHT_VIDEO"; do
    if [ ! -f "$video" ]; then
        print_error "Video file not found: $video"
        exit 1
    fi
    print_success "Found: $video"
done

# Create build directory if it doesn't exist
if [ ! -d "build" ]; then
    mkdir -p build
    print_info "Created build directory"
fi

# Print processing information
echo ""
print_info "=========================================="
print_info "Starting AVM Video Stitching Processing"
print_info "=========================================="
print_info "Input videos:"
print_info "  Front:  $FRONT_VIDEO"
print_info "  Back:   $BACK_VIDEO"
print_info "  Left:   $LEFT_VIDEO"
print_info "  Right:  $RIGHT_VIDEO"
print_info "Output video: $OUTPUT_VIDEO"
print_info "=========================================="
echo ""

# Run AVM video processing
print_info "Executing AVM video processing..."
if ./build/bin/avm video "$FRONT_VIDEO" "$BACK_VIDEO" "$LEFT_VIDEO" "$RIGHT_VIDEO" "$OUTPUT_VIDEO"; then
    print_success "=========================================="
    print_success "Video processing completed successfully!"
    print_success "=========================================="
    print_success "Output saved to: $OUTPUT_VIDEO"
    
    # Display output file information
    if [ -f "$OUTPUT_VIDEO" ]; then
        FILE_SIZE=$(ls -lh "$OUTPUT_VIDEO" | awk '{print $5}')
        print_info "Output file size: $FILE_SIZE"
    fi
else
    print_error "Video processing failed!"
    exit 1
fi

echo ""
print_info "Processing finished!"
