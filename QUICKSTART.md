# Picasso - Quick Start Guide

## 🚀 Quick Start (Flutter Only)

For now, you can run Picasso with the Flutter UI without building the native C++ video engine:

```bash
# Run the Flutter app
cd app_flutter
flutter pub get
flutter run -d windows
```

The app will run with the UI framework. Video playback requires the native engine (see below).

---

## 📦 Full Build (With Native Video Engine)

### Prerequisites

1. **Enable Developer Mode** (Windows)
   - Go to Settings > Privacy & security > For developers
   - Toggle **Developer Mode** to **On**
   - This is required for Flutter plugins to use symlinks.

2. **Install Flutter SDK**

2. **Install Visual Studio 2022**
   - With "Desktop development with C++" workload

3. **Install vcpkg**
   ```bash
   git clone https://github.com/Microsoft/vcpkg.git
   .\vcpkg\bootstrap-vcpkg.bat
   ```

### Build Steps

```bash
# 1. Install dependencies via vcpkg
vcpkg install --triplet=x64-windows

# 2. Build native core
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=[path-to-vcpkg]/scripts/buildsystems/vcpkg.cmake
cmake --build build --config Release

# 3. Copy DLL to Flutter
copy build\Release\picasoo_video_engine.dll app_flutter\windows\

# 4. Build Flutter app
cd app_flutter
flutter build windows --release
```

---

## 🎯 Current Status

**Working:**
- ✅ Flutter UI with multi-page navigation
- ✅ Timeline widget
- ✅ Media pool
- ✅ Inspector panel
- ✅ Professional dark theme

**Requires Native Build:**
- ⏳ Video playback
- ⏳ Real-time decoding
- ⏳ GPU acceleration

---

## 🔧 Development Mode

Run without native engine for UI development:

```bash
flutter run -d windows
```

Navigate between pages using the sidebar. The UI is fully functional, video playback will show placeholders until the native engine is built.

---

## 📝 Next Steps

1. **Install CMake** (if you want video playback)
2. **Run Flutter app** (UI works without CMake)
3. **Test navigation** (click sidebar icons)
4. **Build native engine** (when ready for video)

---

## ⚡ Quick Commands

```bash
# Just run the UI
flutter run -d windows

# Build release (UI only)
flutter build windows --release

# Full build (with native engine)
cmake --build build --config Release
flutter build windows --release
```
