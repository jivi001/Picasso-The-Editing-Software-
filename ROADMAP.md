# 90-Day Execution Roadmap (6 Sprints)

## Sprint 1: Core Architecture & Video Engine (Days 1-14)
*   **Goal**: Establish the C++ engine foundation and basic video playback.
*   **Deliverables**:
    *   [x] Repo setup (CMake, vcpkg, Flutter).
    *   [x] IPC Bridge (Named Pipes + Shared Memory) prototype.
    *   [x] Video Engine: FFmpeg decoding to DX12 Texture.
    *   [x] Basic Flutter Shell hosting the native texture.
*   **Testing**: Playback of 1080p H.264 file in Flutter window.

## Sprint 2: UI Shell & Node Editor (Days 15-28)
*   **Goal**: Implement the visual interface and node graph data structure.
*   **Deliverables**:
    *   [x] Docking Window System in Flutter.
    *   [x] Node Editor UI (Canvas, Nodes, Edges).
    *   [x] C++ Node Runtime (DAG execution).
    *   [x] Basic "Transform" and "Blur" nodes.
*   **Testing**: Connect two nodes and see the result in the viewer.

## Sprint 3: VFX & Color Engine (Days 29-42)
*   **Goal**: Implement the rendering pipeline and color science.
*   **Deliverables**:
    *   [x] OpenFX Host integration.
    *   [x] OCIO Color Management (ACEScg pipeline).
    *   [x] Shader Graph Compiler (GLSL/HLSL generation).
    *   [x] GPU Scopes (Histogram, Waveform).
*   **Testing**: Load an EXR, apply a LUT, and view the waveform.

## Sprint 4: Audio & AI Engine (Days 43-56)
*   **Goal**: Add sound and intelligence.
*   **Deliverables**:
    *   [x] Audio Engine (JUCE) synchronized with Video.
    *   [x] Audio Waveform rendering.
    *   [x] AI Engine integration (ONNX Runtime).
    *   [x] "Magic Mask" feature (RVM/MODNet).
*   **Testing**: Play video with synced audio; run background removal on a clip.

## Sprint 5: Performance & Media Management (Days 57-70)
*   **Goal**: Optimize for high-res footage and long timelines.
*   **Deliverables**:
    *   [x] Proxy Generation Worker.
    *   [x] Tiled Caching System.
    *   [x] Database Layer (SQLite) for project persistence.
    *   [x] Multithreading optimization (Worker Pool).
*   **Testing**: Scrubbing a 4K timeline with 50 clips smoothly.

## Sprint 6: Polish, Packaging & Beta (Days 71-90)
*   **Goal**: Prepare for release.
*   **Deliverables**:
    *   [x] MSIX Packaging & Signing.
    *   [x] Crash Reporting & Telemetry.
    *   [x] User Manual & Documentation.
    *   [x] Final Bug Fixes & UI Polish.
*   **Milestone**: Alpha Release to internal testers.

## Sprint 7: Animation & Titling (Days 91-104)
*   **Goal**: Enable dynamic motion graphics and text overlays.
*   **Deliverables**:
    *   [ ] **Keyframe System**: C++ backend for Bezier interpolation of parameters.
    *   [ ] **Curve Editor**: Flutter UI for visualizing and editing keyframes.
    *   [ ] **Titling Engine**: Native text rendering using FreeType/HarfBuzz.
    *   [ ] **Text Node**: New node type for generating text textures.
*   **Testing**: Animate a text overlay moving across the screen with ease-in/out.

## Sprint 8: Timeline & Media Pool (Days 105-118)
*   **Goal**: Build the core non-linear editing (NLE) interface.
*   **Deliverables**:
    *   [ ] **Timeline UI**: High-performance Flutter widget for multi-track editing.
    *   [ ] **Media Pool**: Asset management interface with drag-and-drop support.
    *   [ ] **Timeline Backend**: C++ data structures for Tracks, Clips, and Composition.
    *   [ ] **Property Inspector**: UI to edit clip/node parameters.
*   **Testing**: Drag a clip from Media Pool to Timeline, move it, and adjust its opacity.

## Sprint 9: Delivery & Audio Mixing (Days 119-132)
*   **Goal**: Complete the production pipeline with Export and Audio Mixing interfaces.
*   **Deliverables**:
    *   [ ] **Deliver Page**: UI for configuring render settings (Format, Codec, Resolution).
    *   [ ] **Audio Mixer**: UI with Faders, Meters, and Pan controls.
    *   [ ] **Shortcut Manager**: JSON-based keymapping system for keyboard shortcuts.
    *   [ ] **Render Queue UI**: Monitor progress of background render jobs.
*   **Testing**: Mix audio levels, set export to H.264 1080p, and verify output file.

## Sprint 10: Advanced Workflows & Optimization (Days 133-146)
*   **Goal**: Implement professional workflows and optimize performance.
*   **Deliverables**:
    *   [ ] **Multi-Cam Support**: UI for viewing multiple angles and switching.
    *   [ ] **Proxy Workflow**: Toggle to switch between Original and Proxy media.
    *   [ ] **Scripting API**: Lua bindings for automating timeline tasks.
    *   [ ] **Hardware Encoding**: Integrate NVENC/QSV in Render Worker.
*   **Testing**: Sync 2 clips by audio, toggle proxies during playback, run a Lua script to add a clip.

## Sprint 11: Cloud Collaboration & Remote Review (Days 147-160)
*   **Goal**: Enable remote team collaboration and review workflows.
*   **Deliverables**:
    *   [ ] **Cloud Client**: C++ REST client for API communication.
    *   [ ] **Review Panel**: UI for displaying time-coded comments.
    *   [ ] **Project Sync**: Logic to sync project database to cloud.
    *   [ ] **Documentation**: Comprehensive README and Developer Guide.
*   **Testing**: Post a comment on a timestamp, verify it appears on another client (mocked).

## Sprint 12: Quality Assurance & CI/CD (Days 161-174)
*   **Goal**: Establish a robust testing framework and automated build pipeline.
*   **Deliverables**:
    *   [ ] **Unit Testing Framework**: Integrate Google Test (GTest) for C++ core.
    *   [ ] **CI Pipeline**: GitHub Actions workflow for Windows build.
    *   [ ] **Static Analysis**: Integrate `clang-tidy` or `cppcheck`.
    *   [ ] **Flutter Tests**: Widget tests for critical UI components.
*   **Testing**: Run `ctest` and see 100% pass rate. Push to main and see green checkmark.
