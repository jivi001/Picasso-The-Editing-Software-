# Build Script for Picasoo

Write-Host "Building Picasoo Core (C++)..."
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=./vcpkg/scripts/buildsystems/vcpkg.cmake
cmake --build build --config Release

Write-Host "Building Flutter App..."
cd app_flutter
flutter build windows --release
cd ..

Write-Host "Copying Native Binaries..."
# Copy DLLs from build/Release to app_flutter/build/windows/runner/Release
Copy-Item "build/Release/*.dll" "app_flutter/build/windows/runner/Release" -Force

Write-Host "Build Complete!"
