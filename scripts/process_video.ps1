# ============================================
# AVM Video Stitching Processing Script (PowerShell)
# ============================================
# 
# This script demonstrates how to use the AVM system
# for processing multi-camera video input on Windows
#
# Usage:
#   .\scripts\process_video.ps1 -Front <path> -Back <path> -Left <path> -Right <path> [-Output <path>]
#
# Examples:
#   .\scripts\process_video.ps1 -Front front.mp4 -Back back.mp4 -Left left.mp4 -Right right.mp4
#   .\scripts\process_video.ps1 -Front front.mp4 -Back back.mp4 -Left left.mp4 -Right right.mp4 -Output my_output.mp4

param(
    [Parameter(Mandatory = $true, HelpMessage = "Path to front camera video")]
    [string]$Front,
    
    [Parameter(Mandatory = $true, HelpMessage = "Path to back camera video")]
    [string]$Back,
    
    [Parameter(Mandatory = $true, HelpMessage = "Path to left camera video")]
    [string]$Left,
    
    [Parameter(Mandatory = $true, HelpMessage = "Path to right camera video")]
    [string]$Right,
    
    [Parameter(Mandatory = $false, HelpMessage = "Output video file path")]
    [string]$Output = "build/stitched_output.mp4"
)

# Color codes
$InfoColor = "Cyan"
$SuccessColor = "Green"
$WarningColor = "Yellow"
$ErrorColor = "Red"

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] " -ForegroundColor $InfoColor -NoNewline
    Write-Host $Message
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] " -ForegroundColor $SuccessColor -NoNewline
    Write-Host $Message
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] " -ForegroundColor $WarningColor -NoNewline
    Write-Host $Message
}

function Write-Error2 {
    param([string]$Message)
    Write-Host "[ERROR] " -ForegroundColor $ErrorColor -NoNewline
    Write-Host $Message
}

# Check if AVM executable exists
if (-not (Test-Path "build/bin/avm.exe") -and -not (Test-Path "build/bin/avm")) {
    Write-Error2 "AVM executable not found at build/bin/"
    Write-Info "Please build the project first:"
    Write-Info "  Ensure CMake and OpenCV are installed"
    Write-Info "  Run: cmake .. (from build directory)"
    Write-Info "  Run: cmake --build . --config Release"
    exit 1
}

# Validate input files exist
Write-Info "Validating input files..."
$videos = @{
    "Front" = $Front
    "Back"  = $Back
    "Left"  = $Left
    "Right" = $Right
}

$allFilesExist = $true
foreach ($direction in $videos.Keys) {
    $filepath = $videos[$direction]
    if (Test-Path $filepath) {
        Write-Success "Found $direction video: $filepath"
    }
    else {
        Write-Error2 "Video file not found: $filepath"
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    exit 1
}

# Create build directory if it doesn't exist
if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Path "build" | Out-Null
    Write-Info "Created build directory"
}

# Print processing information
Write-Host ""
Write-Info "=========================================="
Write-Info "Starting AVM Video Stitching Processing"
Write-Info "=========================================="
Write-Info "Input videos:"
Write-Info "  Front:  $Front"
Write-Info "  Back:   $Back"
Write-Info "  Left:   $Left"
Write-Info "  Right:  $Right"
Write-Info "Output video: $Output"
Write-Info "=========================================="
Write-Host ""

# Determine the AVM executable path
$avmExe = if (Test-Path "build/bin/avm.exe") { "build/bin/avm.exe" } else { "build/bin/avm" }

# Run AVM video processing
Write-Info "Executing AVM video processing..."
Write-Info "Command: $avmExe video `"$Front`" `"$Back`" `"$Left`" `"$Right`" `"$Output`""
Write-Host ""

& $avmExe video "$Front" "$Back" "$Left" "$Right" "$Output"
$exitCode = $LASTEXITCODE

Write-Host ""

if ($exitCode -eq 0) {
    Write-Success "=========================================="
    Write-Success "Video processing completed successfully!"
    Write-Success "=========================================="
    Write-Success "Output saved to: $Output"
    
    # Display output file information
    if (Test-Path $Output) {
        $fileSize = (Get-Item $Output).Length
        $fileSizeFormatted = if ($fileSize -gt 1GB) {
            "{0:N2} GB" -f ($fileSize / 1GB)
        }
        elseif ($fileSize -gt 1MB) {
            "{0:N2} MB" -f ($fileSize / 1MB)
        }
        else {
            "{0:N2} KB" -f ($fileSize / 1KB)
        }
        Write-Info "Output file size: $fileSizeFormatted"
    }
}
else {
    Write-Error2 "Video processing failed with exit code: $exitCode"
    exit $exitCode
}

Write-Host ""
Write-Info "Processing finished!"
