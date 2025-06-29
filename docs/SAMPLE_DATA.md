# Sample Data Description

## Input Images Overview

The AVM system comes with sample fisheye camera images that demonstrate the complete processing pipeline.

### Image Specifications

- **Resolution**: 1280×960 pixels
- **Format**: PNG
- **Camera Type**: Fisheye lens with wide field of view
- **Calibration Pattern**: 2×4 rectangular grid visible in each image

### Camera Positions

#### Front Camera (`assets/images/front.png`)

- Position: Front bumper center
- Field of view: Covers front area and left/right sides
- Calibration board: Positioned on ground in front of vehicle

#### Back Camera (`assets/images/back.png`)

- Position: Rear bumper center  
- Field of view: Covers rear area and left/right sides
- Calibration board: Positioned on ground behind vehicle

#### Left Camera (`assets/images/left.png`)

- Position: Left side mirror or door
- Field of view: Covers left side area
- Calibration board: Positioned on ground to the left of vehicle

#### Right Camera (`assets/images/right.png`)

- Position: Right side mirror or door
- Field of view: Covers right side area
- Calibration board: Positioned on ground to the right of vehicle

### Vehicle Model

#### Vehicle Overlay (`assets/images/su7.png`)

- **Type**: Top-down vehicle silhouette
- **Format**: PNG with alpha channel for transparency
- **Usage**: Overlaid on final stitched result to show vehicle position
- **Positioning**: Automatically centered in panoramic view

### Mask Images

The system uses blending masks to create smooth transitions between camera views:

#### Mask Specifications

- **Location**: `assets/masks/`
- **Files**:
  - `maskFront.jpg` - Front camera blending mask
  - `maskBack.jpg` - Back camera blending mask
  - `maskLeft.jpg` - Left camera blending mask
  - `maskRight.jpg` - Right camera blending mask
- **Purpose**: Define blending regions for seamless image stitching
- **Format**: Grayscale images where brightness indicates blending weight

### Calibration Board Details

#### Pattern Configuration

- **Grid Size**: 2 rows × 4 columns
- **Corner Count**: 8 total corners
- **Board Size**: Approximately 50cm × 100cm (physical dimensions)
- **Visibility**: Clearly visible in all four camera views

#### Detection Requirements

- **Contrast**: High contrast between board and ground
- **Lighting**: Even illumination without shadows
- **Position**: Fully within camera field of view
- **Orientation**: Rectangular pattern aligned with vehicle axes

## Using Your Own Images

### Camera Setup Requirements

To use your own images with the AVM system:

1. **Camera Positioning**:
   - Install fisheye cameras at four positions around vehicle
   - Ensure overlapping fields of view between adjacent cameras
   - Maintain consistent height and angle

2. **Calibration Board**:
   - Create a 2×4 rectangular calibration pattern
   - Position board in overlapping areas between camera views
   - Ensure board is flat and clearly visible

3. **Image Capture**:
   - Capture images simultaneously from all four cameras
   - Maintain consistent lighting conditions
   - Ensure calibration board is visible in each image

4. **File Preparation**:
   - Save images as PNG or JPG format
   - Name files: `front.png`, `back.png`, `left.png`, `right.png`
   - Place in `assets/images/` directory

### Camera Parameter Adjustment

If using different cameras, you may need to adjust parameters in the source code:

- **Focal Length**: Modify based on your camera specifications
- **Distortion Coefficients**: Calibrate using OpenCV calibration tools
- **Image Resolution**: Update if using different image sizes
- **Fisheye Scale Factor**: Adjust based on lens characteristics

For detailed parameter tuning, refer to the [Technical Specifications](TECHNICAL_SPECS.md).
