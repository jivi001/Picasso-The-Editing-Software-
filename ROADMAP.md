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
