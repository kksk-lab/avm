#!/bin/bash

# Build script for avm AVM project
# This script builds the OpenCV-based Around View Monitoring system

set -e # Exit on any error

echo "=== Building avm AVM Project ==="

# Get the project root directory (parent of scripts directory)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

# Check if we're in the right directory
if [ ! -f "CMakeLists.txt" ]; then
    echo "Error: CMakeLists.txt not found. Please run this script from the project root directory."
    exit 1
fi

# Check if OpenCV is installed
if ! pkg-config --exists opencv4 && ! pkg-config --exists opencv; then
    echo "Error: OpenCV not found. Please install OpenCV development packages."
    echo "On Ubuntu/Debian: sudo apt-get install libopencv-dev"
    exit 1
fi

# Display OpenCV version
OPENCV_VERSION=$(pkg-config --modversion opencv4 2>/dev/null || pkg-config --modversion opencv 2>/dev/null)
echo "Found OpenCV version: $OPENCV_VERSION"

# Create build directory if it doesn't exist
if [ ! -d "build" ]; then
    echo "Creating build directory..."
    mkdir build
fi

# Change to build directory
cd build

# Configure with CMake
echo "Configuring with CMake..."
cmake ..

# Build the project
echo "Building project..."
make -j$(nproc)

# Check if build was successful
if [ -f "bin/avm" ]; then
    echo "=== Build completed successfully! ==="
    echo "Executable created: build/bin/avm"
else
    echo "=== Build failed! ==="
    exit 1
fi
