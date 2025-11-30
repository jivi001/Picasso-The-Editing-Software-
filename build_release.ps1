# Build script for Windows
Write-Host "Building Picasoo for Windows..." -ForegroundColor Green

# Clean
Write-Host "Cleaning..."
flutter clean

# Get dependencies
Write-Host "Fetching dependencies..."
flutter pub get
cd app_flutter
flutter pub get
cd ..

# Patch CMake warnings
Write-Host "Patching CMake warnings..."
if (Test-Path "scripts\fix_media_kit_cmake.ps1") {
    .\scripts\fix_media_kit_cmake.ps1
}

# Build
Write-Host "Building Release..."
flutter build windows --release

# Check success
if ($?) {
    Write-Host "Build Successful!" -ForegroundColor Green
    Write-Host "Executable located at: build\windows\x64\runner\Release\picasoo.exe"
    
    # Open the folder
    Invoke-Item build\windows\x64\runner\Release
} else {
    Write-Host "Build Failed!" -ForegroundColor Red
}
