# Technical Specifications

## Camera Parameters

### Fisheye Camera Specifications

- **Focal Length**: 910.0 pixels
- **Pixel Size**: 3.0μm × 3.0μm
- **Image Resolution**: 1280×960 pixels
- **Fisheye Scaling Factor**: 0.5
- **Undistortion Scaling**: 1.55

### Distortion Model

The system uses a polynomial fisheye distortion model:

```
θ_distorted = θ_undistorted + k₁θ³ + k₂θ⁵ + k₃θ⁷ + k₄θ⁹
```

Default distortion coefficients:

- k₁ = -0.05611147
- k₂ = -0.05377447
- k₃ = 0.0115717
- k₄ = 0.0030788

## Calibration Board Specifications

### Pattern Configuration

- **Pattern Type**: Rectangular grid
- **Grid Size**: 2×4 (2 rows, 4 columns)
- **Corner Count**: 8 corners total
- **Detection Method**: Histogram-based adaptive thresholding

### Detection Parameters

- **Contrast Enhancement**: 2.5× gamma correction
- **Valid Detection Region**: Y-axis 20%-70% of image height
- **Corner Refinement**: Sub-pixel accuracy using `cornerSubPix`
- **Backup Detection**: Adaptive threshold with 401×401 kernel

## Bird's Eye View Parameters

### Image Dimensions

- **Front/Back Views**: 792×305 pixels
- **Left/Right Views**: 1131×281 pixels
- **Final Stitched Image**: Variable based on layout

### Transformation Matrices

Each camera view uses homography transformation calculated from:

- Source: Detected corner points in undistorted image
- Target: Predefined bird's eye view coordinates

### Rotation Corrections

- **Front View**: 0° (no rotation)
- **Back View**: 180°
- **Left View**: 90° clockwise
- **Right View**: 90° counter-clockwise

## Image Stitching Parameters

### Layout Configuration

- **Back Image Offset**: Y = 643 pixels
- **Right Image Offset**: X = 398 pixels
- **Vehicle Overlay**: Center positioned with alpha blending

### Blending Masks

- Individual masks for each camera view
- Smooth transition zones between adjacent views
- Alpha channel support for vehicle model overlay

## Performance Characteristics

### Processing Pipeline Timing

1. **Image Loading**: ~10ms per image
2. **Undistortion**: ~50ms per image
3. **Corner Detection**: ~100-200ms per image
4. **Perspective Transform**: ~30ms per image
5. **Image Stitching**: ~100ms total

### Memory Requirements

- **Input Images**: ~5MB (4 × 1280×960×3)
- **Intermediate Results**: ~20MB
- **Output Image**: ~2-3MB
- **Total Peak Usage**: ~30-40MB

## Algorithm Details

### Corner Detection Algorithm

1. **Preprocessing**:
   - Convert to grayscale
   - Apply gamma correction for contrast enhancement
   - Set valid detection region (20%-70% Y-axis)

2. **Binarization**:
   - Histogram analysis for optimal threshold
   - Bimodal distribution detection
   - Adaptive fallback if histogram method fails

3. **Contour Analysis**:
   - Find contours in binary image
   - Filter by area (minimum threshold)
   - Approximate polygonal shapes

4. **Rectangle Validation**:
   - Verify 4-sided polygon structure
   - Check geometric constraints
   - Sort corners in consistent order

5. **Coordinate Transformation**:
   - Transform from fisheye to undistorted coordinates
   - Apply sub-pixel refinement
   - Validate final corner positions

### Homography Calculation

Uses OpenCV's `findHomography` with:

- **Method**: Direct Linear Transform (DLT)
- **Source Points**: 8 detected corners
- **Target Points**: Predefined bird's eye coordinates
- **Robustness**: No RANSAC (assumes clean input)
