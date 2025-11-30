# Picasso - Pure Dart Video Editor

**No C++ or CMake required!** Uses pure Dart packages for video playback.

## 🚀 Quick Start

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app
flutter run -d windows

# 3. Build release
flutter build windows --release
```

That's it! No CMake, no vcpkg, no native compilation needed.

---

## 📦 Video Engine: media_kit

We use **media_kit** instead of C++ FFmpeg:
- ✅ Pure Dart/Flutter
- ✅ Hardware acceleration
- ✅ Frame-accurate seeking
- ✅ Professional features
- ✅ Cross-platform

---

## ✨ Features

- **Multi-page workflow** (Media, Edit, Color, Fusion, Audio, Deliver)
- **Real-time video playback** via media_kit
- **Timeline editing** with multiple tracks
- **Professional UI** with dark theme
- **Cross-platform** (Windows, macOS, Linux)

---

## 🎬 Usage

1. Launch Picasso
2. Go to **Edit** page
3. Import video files
4. Add to timeline
5. Playback and edit
6. Export (coming soon)

---

## 🔧 Build

```bash
# Development
flutter run -d windows

# Release
flutter build windows --release
```

Output: `build\windows\x64\runner\Release\picasoo.exe`

---

## 📊 Architecture

```
Flutter UI (Dart)
    ↓
media_kit (Pure Dart)
    ↓
libmpv (Bundled)
    ↓
Hardware Acceleration
```

**No C++ compilation needed!**

---

## 🎯 Advantages

**vs C++ FFmpeg:**
- ✅ Easier to build
- ✅ Faster development
- ✅ No toolchain setup
- ✅ Smaller codebase
- ✅ Better cross-platform

**Trade-offs:**
- ⚠️ Less low-level control
- ⚠️ Slightly larger app size

---

## 📝 Dependencies

```yaml
media_kit: ^1.1.10              # Video engine
media_kit_video: ^1.2.4         # Video widgets
media_kit_libs_windows_video    # Windows binaries
```

All managed by Flutter - no manual setup!
