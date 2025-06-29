# Installation Guide

## System Requirements

### Operating System

- Linux (Ubuntu 18.04+, CentOS 7+)
- macOS 10.14+
- Windows 10+ (with WSL2 recommended)

### Hardware Requirements

- **Memory**: Minimum 4GB RAM, recommended 8GB+
- **Storage**: 1GB free space for build and outputs
- **CPU**: Multi-core processor recommended for optimal performance

## Dependencies

### Required Dependencies

#### OpenCV (Version 3.0+)

OpenCV is the core dependency for image processing operations.

**Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install libopencv-dev libopencv-contrib-dev
```

**CentOS/RHEL:**

```bash
sudo yum install opencv-devel
# or for newer versions:
sudo dnf install opencv-devel
```

**macOS (using Homebrew):**

```bash
brew install opencv
```

**Manual Installation:**
If package managers don't provide a recent enough version:

```bash
# Download OpenCV source
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout 4.x  # or your preferred version

# Build and install
mkdir build && cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D WITH_TBB=ON \
      -D WITH_V4L=ON \
      -D WITH_QT=OFF \
      -D WITH_OPENGL=ON \
      ..
make -j$(nproc)
sudo make install
```

#### CMake (Version 3.10+)

Required for building the project.

**Ubuntu/Debian:**

```bash
sudo apt install cmake
```

**CentOS/RHEL:**

```bash
sudo yum install cmake
# or: sudo dnf install cmake
```

**macOS:**

```bash
brew install cmake
```

### Optional Dependencies

#### Git (for version control)

```bash
# Ubuntu/Debian
sudo apt install git

# CentOS/RHEL  
sudo yum install git

# macOS
git --version  # Usually pre-installed
```

## Installation Steps

### Method 1: Clone from GitHub (Recommended)

```bash
# Clone the repository
git clone https://github.com/xixu-me/AVM.git
cd AVM

# Make scripts executable
chmod +x scripts/*.sh

# Build the project
./scripts/build.sh
```

### Method 2: Download and Build

```bash
# Download and extract source code
wget https://github.com/xixu-me/AVM/archive/main.zip
unzip main.zip
cd AVM-main

# Make scripts executable
chmod +x scripts/*.sh

# Build the project
./scripts/build.sh
```

### Manual Build Process

If you prefer to build manually:

```bash
# Create build directory
mkdir -p build
cd build

# Configure with CMake
cmake ..

# Build (adjust -j flag based on your CPU cores)
make -j$(nproc)

# Verify build
ls bin/avm  # Should exist if build successful
```

## Verification

### Test Installation

```bash
# Quick test with provided sample images
./scripts/run.sh

# Check output
ls build/stitched_result_with_su7.jpg  # Should exist after successful run
```

### Expected Output Files

After successful execution, you should see:

```
build/
├── front_undis.jpg         # Undistorted front view
├── back_undis.jpg          # Undistorted back view  
├── left_undis.jpg          # Undistorted left view
├── right_undis.jpg         # Undistorted right view
├── bird_front_2.jpg        # Front bird's eye view
├── bird_back_2.jpg         # Back bird's eye view
├── bird_left_2.jpg         # Left bird's eye view
├── bird_right_2.jpg        # Right bird's eye view
└── stitched_result_with_su7.jpg  # Final panoramic result
```

## Troubleshooting

### OpenCV Not Found

```
CMake Error: Could not find OpenCV
```

**Solution:**

- Verify OpenCV installation: `pkg-config --modversion opencv`
- Set OpenCV path manually: `export OpenCV_DIR=/path/to/opencv`
- Reinstall OpenCV development packages

### Build Errors

```
error: opencv2/opencv.hpp: No such file or directory
```

**Solution:**

- Install OpenCV development headers
- Check include paths in CMakeLists.txt
- Verify compiler can find OpenCV includes

### Runtime Errors

```
error while loading shared libraries: libopencv_core.so
```

**Solution:**

- Update library path: `sudo ldconfig`
- Add to LD_LIBRARY_PATH: `export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH`

### Permission Errors

```
Permission denied: ./scripts/build.sh
```

**Solution:**

```bash
chmod +x scripts/*.sh
```

### Missing Input Images

```
[ERROR] Unable to read input image files
```

**Solution:**

- Ensure input images exist in `assets/images/`
- Check file permissions and formats (PNG/JPG supported)
- Verify image files are not corrupted

## Performance Optimization

### Build Optimizations

For maximum performance, build in Release mode:

```bash
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
```

### Runtime Optimizations

- Use SSD storage for faster I/O operations
- Ensure sufficient RAM to avoid swapping
- Close unnecessary applications during processing

## Next Steps

After successful installation:

1. **Read the Documentation**: Check `README.md` for usage instructions
2. **Try Custom Images**: Replace sample images with your own fisheye images
3. **Explore Configuration**: Review camera parameters in the source code
4. **Contribute**: See `CONTRIBUTING.md` for development guidelines

## Getting Help

If you encounter issues:

1. Check this troubleshooting section
2. Search existing GitHub issues
3. Create a new issue with detailed error information
4. Include your system information and build logs
