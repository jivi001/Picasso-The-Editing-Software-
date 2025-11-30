# Video Editor Engineering Blueprint

## 1. System Architecture

### High-Level Architecture Diagram
```ascii
+---------------------------------------------------------------+
|                   Application Layer (Flutter)                 |
|  +----------------+   +----------------+   +---------------+  |
|  |   Main Window  |   |   Node Editor  |   |  Media Pool   |  |
|  +-------+--------+   +-------+--------+   +-------+-------+  |
|          |                    |                    |          |
|          v                    v                    v          |
+----------+--------------------+--------------------+----------+
|                     IPC Bridge (Named Pipes)                  |
+---------------------------------------------------------------+
|                   Native Core (C++ / Windows)                 |
|                                                               |
|  +----------------+   +----------------+   +---------------+  |
|  |  Video Engine  |   |   Node Runtime |   |  Audio Engine |  |
|  | (FFmpeg/GSt)   |   | (OpenFX/Shader)|   | (JUCE/PortA)  |  |
|  +-------+--------+   +-------+--------+   +-------+-------+  |
|          |                    |                    |          |
|          v                    v                    v          |
|  +----------------+   +----------------+   +---------------+  |
|  | Hardware Accel |   |   AI Engine    |   |    Database   |  |
|  | (CUDA/DX12)    |   | (ONNX/DirectML)|   |    (SQLite)   |  |
|  +----------------+   +----------------+   +---------------+  |
+---------------------------------------------------------------+
```

### Module Breakdown

1.  **UI / Application Layer (Flutter)**
    *   **Responsibility**: Main application shell, window management, high-level user interaction, timeline rendering (UI components), property inspectors.
    *   **Tech**: Flutter Desktop (Windows).
    *   **Integration**: Hosts Native C++ Panels via `Texture` widgets (using shared handles) or `PlatformView` (though `Texture` is preferred for high-perf rendering).

2.  **Native Panels (C++)**
    *   **Responsibility**: High-performance viewports (Source Viewer, Timeline Viewer, Color Scopes, Node Graph Canvas).
    *   **Tech**: Direct3D 12 / Vulkan swapchain rendering into a shared surface consumed by Flutter.

3.  **Node Engine (C++)**
    *   **Responsibility**: Managing the dependency graph of effects, compositing operations, and rendering flow.
    *   **Tech**: Custom DAG (Directed Acyclic Graph) engine, OpenFX host.

4.  **Video Engine (C++)**
    *   **Responsibility**: Decoding, caching, seeking, and playback synchronization.
    *   **Tech**: FFmpeg (demuxing/software decode), GStreamer (pipeline management), Hardware Decoders (NVDEC, QSV, AMF).

5.  **Audio Engine (C++)**
    *   **Responsibility**: Audio mixing, VST/AU plugin hosting, waveform generation, synchronization with video.
    *   **Tech**: JUCE (primary audio framework), PortAudio (low-level I/O), SoX (resampling/effects).

6.  **AI Engine (C++)**
    *   **Responsibility**: Offline inference for magic mask, transcription, upscaling.
    *   **Tech**: ONNX Runtime (DirectML execution provider), MediaPipe.

7.  **Render Worker (C++)**
    *   **Responsibility**: Background rendering, proxy generation, export encoding.
    *   **Tech**: Independent process or thread pool, FFmpeg CLI/Lib wrapper.

### IPC Design (Flutter ⇄ Native C++)

*   **Control Plane**: **Named Pipes** (Windows).
    *   Low-latency, reliable, ordered.
    *   Protocol: Protobuf or FlatBuffers over Named Pipes for strict typing and performance.
    *   Used for: Transport controls (Play/Pause), Timeline updates, Node graph mutations.
*   **Data Plane (Video/UI)**: **Shared Memory (DX12/Vulkan Interop)**.
    *   The C++ engine renders frames to a DX12 Texture.
    *   A Shared Handle is passed to Flutter.
    *   Flutter displays this texture using the `flutter_texture` API (or a custom FFI bridge for zero-copy if supported by the Flutter engine version, otherwise minimal copy).
*   **Data Plane (Audio)**: **Shared Memory Ring Buffer**.
    *   Audio engine writes to a ring buffer.
    *   UI reads for waveform visualization (decimated data).

### GPU Acceleration Paths

*   **CUDA**: Primary compute path for NVIDIA GPUs. Used for heavy image processing, neural network inference (if TensorRT/CUDA provider used), and color transforms.
*   **DirectX 12**: Primary rendering backend for Windows. Used for UI composition, swapchain management, and interoperability with Flutter.
*   **NVENC / NVDEC**: Hardware encoding/decoding for H.264/H.265.
*   **QSV (Intel QuickSync)**: Hardware acceleration for Intel GPUs.
*   **AMF (AMD Advanced Media Framework)**: Hardware acceleration for AMD GPUs.

### Real-time Preview Pipeline

1.  **Decode**: Frame requested -> Cache Check -> Hardware Decode (NVDEC/QSV) -> GPU Texture.
2.  **Process**: GPU Texture -> OpenFX Graph -> Color Pipeline (OCIO/Shader) -> Compositing -> Output Texture.
3.  **Display**: Output Texture -> Shared Handle -> Flutter Texture Widget -> Screen.
4.  **Latency Budget**: < 16ms per frame (60fps). Pipeline depth: 2-3 frames max.

## 2. Repository / Codebase Structure

**Monorepo Layout**

```text
/
├── app_flutter/              # Flutter Application (UI Shell)
│   ├── lib/
│   │   ├── ui/               # Widgets, Layouts, Theme
│   │   ├── bridge/           # FFI / IPC Communication Layer
│   │   ├── state/            # BLoC / Provider State Management
│   │   └── main.dart
│   └── windows/              # Windows-specific runner code
│
├── native/                   # C++ Core
│   ├── common/               # Shared utilities, math, logging
│   ├── panels/               # Native Viewport Renderers (DX12)
│   ├── node_runtime/         # DAG Engine, OpenFX Host
│   ├── video_engine/         # FFmpeg/GStreamer wrappers, Decoders
│   ├── audio_engine/         # JUCE integration, Mixer
│   ├── ai_engine/            # ONNX Runtime, MediaPipe wrappers
│   ├── render_worker/        # Export and Proxy generation logic
│   └── database/             # SQLite schemas and managers
│
├── vfx_plugins/              # Built-in OpenFX plugins
│   ├── blur/
│   ├── transform/
│   └── color/
│
├── shaders/                  # HLSL / GLSL / SPIR-V Shaders
│   ├── compositing/
│   ├── color_science/
│   └── ui/
│
├── tools/                    # Build scripts, code generators
│   ├── shader_compiler/
│   └── asset_packer/
│
├── installer/                # MSIX packaging, WiX config
│
├── docs/                     # Architecture documentation
│
├── CMakeLists.txt            # Root CMake
└── vcpkg.json                # Dependency manifest
```

## 3. UI & Node Editor Design

### Flutter Shell Layout
*   **Docking System**: Custom tiling window manager implemented in Flutter.
*   **Workspaces**: Tabs for "Media", "Cut", "Edit", "Fusion", "Color", "Fairlight", "Deliver" (mimicking industry standard).
*   **Theming**: Dark mode default, high contrast, resolution-independent vector icons.

### Native C++ Panel Embedding
*   **Mechanism**: `Texture` widget in Flutter backed by a `PixelBuffer` or GPU Surface.
*   **Interaction**: Mouse/Keyboard events captured by Flutter `Listener` and forwarded via IPC to the C++ engine for handling (e.g., drawing masks in the viewer).

### Node Editor Design
*   **Visuals**: Flutter-based Canvas (CustomPainter) for the graph. It's performant enough for 1000+ nodes if optimized (R-Tree culling).
*   **Structure**:
    *   **Nodes**: JSON serializable objects. Inputs (left), Outputs (right).
    *   **Ports**: Typed (Image, Mask, Audio, Data).
    *   **Edges**: Bezier curves.
*   **Serialization**: JSON format storing NodeID, Type, Position, Parameters, Connections.

### GPU Scopes
*   **Types**: Histogram, Waveform (Luma/RGB), Vectorscope, Parade.
*   **Implementation**: Compute Shader (HLSL) on the GPU.
    *   Input: Current Frame Texture.
    *   Process: AtomicAdd into histogram bins or scatter plot for vectorscope.
    *   Output: Texture displayed in a native panel or passed back to Flutter.

### Drag-drop Media Workflow
*   **OS Integration**: Windows Drag & Drop API hooked in `windows/runner`.
*   **Internal**: Drag from Media Pool (Flutter ListView) to Timeline (Flutter CustomScrollView/RenderBox).
*   **Payload**: AssetID (UUID).

## 4. Video Pipeline

### Proxy Strategy
*   **Generation**: Background worker (FFmpeg) generates ProRes 422 Proxy or DNxHR LB at 1/2 or 1/4 resolution.
*   **Format**:
    *   Container: MOV / MXF.
    *   Codec: ProRes Proxy (Mac/Win) or DNxHR LB (Win).
    *   Audio: PCM Copy.
*   **Switching**: Instant toggle via UI. Engine seamlessly swaps file handles, maintaining frame index.

### GPU Preview Render Pipeline
1.  **Fetch**: Reader thread pulls frame (Original or Proxy).
2.  **Upload**: PBO (Pixel Buffer Object) or DirectGMA upload to GPU Texture.
3.  **Compute**:
    *   Apply Input LUT (OCIO).
    *   Apply Timeline Effects (OpenFX).
    *   Apply Color Grading (Shader).
    *   Composite Tracks (Alpha Blending).
4.  **Display**: Render to Swapchain.

### Final Export Pipeline
*   **Engine**: FFmpeg (via libavcodec/libavformat) or GStreamer pipeline.
*   **Flow**:
    *   Render Graph executes at full resolution.
    *   Readback to CPU (if encoding on CPU) or keep on GPU (if NVENC/AMF).
    *   Encode -> Mux -> Write to Disk.
*   **Codecs**:
    *   **H.264/H.265**: NVENC (NVIDIA), AMF (AMD), QSV (Intel).
    *   **ProRes/DNxHR**: FFmpeg software encoders (high quality).
    *   **AV1**: SVT-AV1 (CPU) or NVENC AV1 (RTX 40-series).

### Frame Caching & Tiled Readers
*   **RAM Cache**: LRU Cache of decoded `AVFrame` objects.
*   **Texture Cache**: LRU Cache of GPU Textures for composited frames.
*   **Tiled Reading**: For >4K footage, read only visible tiles (if format supports, e.g., EXR tiled). For video, decode full frame but downscale on upload if preview resolution is low.

### Timeline Implementation
*   **Data Structure**: Gap Buffer or Piece Table for efficient insertion/deletion of clips.
*   **Rendering**: Virtualized List in Flutter. Only visible clips are queried for thumbnails/waveforms.

## 5. VFX / Fusion / Compositing Engine

### OpenFX Host Integration
*   **Standard**: Implements OpenFX 1.4 API.
*   **Host Interface**: `OfxHost`, `OfxPropertySuite`, `OfxImageEffectSuite`.
*   **Plugin Discovery**: Scans `C:\Program Files\Common Files\OFX`.
*   **Execution**: Plugins render into GPU buffers (if OpenGL/OpenCL supported) or CPU buffers.

### Shader Graph Compiler
*   **Input**: Node Graph (DAG).
*   **Process**:
    *   Topological Sort.
    *   Identify subgraphs that can be fused.
    *   Generate GLSL/HLSL code for fused operations (e.g., Blur -> ColorCorrect -> Transform).
    *   Compile at runtime using shader compiler (glslang / DXC).

### GPU Compute Pipeline
*   **API**: DirectX 12 (Windows).
*   **Memory**: Shared Heaps for zero-copy between Compute and Graphics queues.
*   **Scheduling**: Async Compute for heavy effects while UI renders on Graphics queue.

### Image & Texture Memory Management
*   **Pool**: Pre-allocated pool of textures (RGBA16F or RGBA32F for HDR).
*   **Recycling**: Textures are returned to pool after display/encode.
*   **OOM Handling**: If VRAM full, evict oldest cache entries to system RAM (DirectStorage).

### 3D & Volumetrics
*   **Assimp**: Import OBJ/FBX/GLTF. Rendered via standard rasterization pipeline.
*   **OpenVDB**: Sparse volume rendering using Raymarching Compute Shaders.

## 6. Color Engine Implementation

### OCIO Pipeline
*   **Config**: ACES 1.3 Studio Config bundled.
*   **Process**:
    *   IDT (Input Device Transform): Source Color Space -> ACEScg.
    *   Grading: Operations in ACEScg (Linear).
    *   RRT+ODT (Output Transform): ACEScg -> Rec.709 / sRGB / Rec.2020.
*   **Implementation**: `OCIO::GpuShaderDesc` to generate GLSL/HLSL for the view transform.

### Color Transforms
*   **Primary**: Lift/Gamma/Gain (Shader).
*   **Secondary**: HSL Qualifiers (Shader - RGB to HSL conversion, mask generation).
*   **Curves**: 1D LUT generated on CPU, uploaded to GPU 1D Texture.
*   **3D LUTs**: Tetrahedral interpolation in Shader.

### Waveform/Vectorscope Generation
*   **Method**: Compute Shader Histogram.
*   **Optimization**:
    *   Downsample input to 1080p or 720p before scope generation to save bandwidth.
    *   Use `InterlockedAdd` (HLSL) for histogram bins.

## 7. AI Engine Architecture

### Implementation Plans
*   **Whisper (Transcription)**:
    *   **Model**: `whisper-tiny/base` (Quantized INT8).
    *   **Execution**: ONNX Runtime with CPU provider (fast enough) or DirectML if GPU available.
    *   **Integration**: Audio buffer -> Resample 16kHz -> Mel Spectrogram -> ONNX Inference -> Text Tokens -> SRT/VTT.
*   **RVM / MODNet (Matting)**:
    *   **Model**: Robust Video Matting (RVM) or MODNet.
    *   **Execution**: ONNX Runtime with DirectML (GPU mandatory).
    *   **Performance**: Process at 512x512, upscale alpha mask to 1080p/4K using guided filter.
*   **ESRGAN (Upscaling)**:
    *   **Model**: Real-ESRGAN (x4).
    *   **Execution**: DirectML. Tile-based processing to avoid VRAM OOM.
*   **MediaPipe (Tracking)**:
    *   **Task**: Face Mesh, Hand Tracking, Objectron.
    *   **Integration**: C++ API.
    *   **Data**: Output normalized coordinates (0..1) stored in metadata track.

### Performance & Caching
*   **Batching**: Audio transcription batched in 30s chunks. Video inference frame-by-frame (real-time) or batched (offline).
*   **Model Caching**: Load models once at startup.
*   **Result Caching**: Store inference results (masks, keyframes) in SQLite/Disk Cache to avoid re-running.

## 8. Audio Engine

### Core Components
*   **Playback**: JUCE `AudioDeviceManager` -> PortAudio (WASAPI Exclusive/Shared).
*   **Processing**: JUCE `AudioProcessorGraph`.
*   **Filters**: SoX (via `libsox`) for high-quality resampling, EQ, compression.
*   **FFmpeg Filters**: `afade`, `atempo`, `volume` wrapped as VST-like nodes.

### Multi-track Audio Timeline
*   **Mixing**: 32-bit Float internal mixing.
*   **Bussing**: Tracks -> Submixes -> Master.
*   **Automation**: Bezier curves for Volume/Pan.

### Audio Waveform Generation
*   **Background Task**: Read audio file -> Decimate (Min/Max per chunk) -> Store as `.peak` file.
*   **Chunk Size**: 100ms for zoom-out, 1ms for zoom-in.

### Latency Strategy
*   **Buffer Size**: User configurable (128 - 2048 samples).
*   **Lookahead**: Pre-read 2 seconds of audio into ring buffer.

## 9. Database Layer

### SQLite Schemas

**Projects**
```sql
CREATE TABLE projects (
    id TEXT PRIMARY KEY,
    name TEXT,
    created_at INTEGER,
    modified_at INTEGER,
    settings_json TEXT
);
```

**Timeline JSON**
```sql
CREATE TABLE timelines (
    id TEXT PRIMARY KEY,
    project_id TEXT,
    name TEXT,
    data_blob BLOB, -- Compressed JSON of the timeline model
    version INTEGER
);
```

**Assets**
```sql
CREATE TABLE assets (
    id TEXT PRIMARY KEY,
    project_id TEXT,
    path TEXT,
    metadata_json TEXT, -- Duration, Resolution, Codec
    proxy_path TEXT,
    cache_key TEXT
);
```

**Render Jobs**
```sql
CREATE TABLE render_jobs (
    id TEXT PRIMARY KEY,
    project_id TEXT,
    status TEXT, -- PENDING, RENDERING, COMPLETED, FAILED
    progress REAL,
    output_path TEXT,
    error_log TEXT
);
```

### Strategy
*   **Indexing**: Index on `project_id` for fast load.
*   **Versioning**: Keep last 10 versions of `data_blob` in a `timeline_history` table.
*   **Cache Eviction**: LRU policy for `assets` metadata if DB grows > 1GB (unlikely).

## 10. Media Management

### Folder Layout
```text
/ProjectRoot
  /Proxies       # Generated Proxy Media
  /Cache         # Render Cache, Waveforms, Thumbnails
  /Exports       # Default Export Location
  project.db     # SQLite Database
```

### Proxy Generation
*   **Command**:
    ```bash
    ffmpeg -i input.mp4 -c:v prores_ks -profile:v 0 -q:v 4 -c:a copy -s 960x540 output_proxy.mov
    ```

### Tiled IO
*   **Strategy**: Use `OpenImageIO` (OIIO) for reading EXR/TIFF. Enable `OIIO_CACHE_SIZE` limit (e.g., 4GB).
*   **Optimized Decode**: Use hardware decoder for GOP-based formats. For Intra-frame (ProRes), use multi-threaded software decode.

## 11. Build / Toolchain / Packaging

### Windows MSVC Toolchain
*   **Compiler**: MSVC v143 (VS2022).
*   **Standard**: C++20.

### vcpkg Dependency List
*   `ffmpeg`, `gstreamer`, `opencv`, `assimp`, `openvdb`, `portaudio`, `sqlite3`, `nlohmann-json`, `protobuf`, `directxtk12`.

### CMake Structure
*   **Root**: Defines global flags (`/std:c++20`, `/O2`).
*   **Subdirectories**: `add_subdirectory(native/video_engine)`, etc.
*   **Flutter Integration**: `flutter_windows` library linked to `native_core`.

### Packaging
*   **MSIX**: Use `windows_packaging` tool.
*   **Code Signing**: Sign with EV Certificate for SmartScreen reputation.

## 12. Performance Strategy

### GPU Memory Management
*   **Budget**: Target 70% VRAM usage.
*   **Eviction**: If usage > 80%, release cached textures and non-visible node graph intermediates.

### Shader Hot-Reload
*   **Dev Mode**: File watcher on `/shaders`. Recompile with `dxc` on change.
*   **Prod**: Pre-compiled SPIR-V / DXIL.

### Multithreading Model
*   **UI Thread (Flutter)**: 60fps. Minimal logic. IPC dispatch.
*   **Render Thread (C++)**: High priority. Submits Command Lists to GPU.
*   **Worker Threads**: Thread Pool (N-2 cores) for Decoding, AI, Proxy Gen.

### Caching Strategy
*   **RAM**: 32GB+ recommended. 8GB reserved for OS.
*   **Disk Tile Cache**: For high-res compositing, cache intermediate node outputs to NVMe SSD (uncompressed raw or LZ4).

### FPS/Latency Budget
*   **Preview**: 24/30/60 fps (matches timeline).
*   **Latency**: Input to Screen < 50ms.



