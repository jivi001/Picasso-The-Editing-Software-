# Picasoo Video Editor

**Picasoo** is a professional, node-based video editing and VFX application designed for high-performance workflows on Windows. It combines a Flutter-based UI with a native C++ engine for real-time processing.

## Architecture

*   **Frontend**: Flutter (Windows Desktop)
*   **Backend**: C++20 (FFmpeg, OpenCV, OpenFX, OCIO, ONNX Runtime)
*   **Communication**: Named Pipes (IPC) & Shared Memory

## Prerequisites

*   **Windows 10/11**
*   **Visual Studio 2022** (C++ Desktop Development)
*   **Flutter SDK** (3.0+)
*   **CMake** (3.20+)
*   **vcpkg** (Package Manager)

## Build Instructions

1.  **Clone the repository**:
    ```powershell
    git clone https://github.com/your-org/picasoo.git
    cd picasoo
    ```

2.  **Install Dependencies (vcpkg)**:
    Ensure `vcpkg` is installed and integrated. The build script assumes `vcpkg` is available.

3.  **Build the Project**:
    Run the automated build script:
    ```powershell
    .\tools\build.ps1
    ```
    This will:
    *   Configure and build the C++ native engine (`picasoo_core.dll`).
    *   Build the Flutter application.
    *   Copy native binaries to the Flutter runner directory.

4.  **Run**:
    ```powershell
    cd app_flutter
    flutter run -d windows
    ```

## Modules

*   **Video Engine**: FFmpeg-based playback and rendering.
*   **Node Engine**: Graph-based processing for VFX.
*   **Color Engine**: OCIO and ACEScg pipeline.
*   **Audio Engine**: PortAudio/JUCE mixing.
*   **AI Engine**: ONNX Runtime integration.

## License

Proprietary / Closed Source.
