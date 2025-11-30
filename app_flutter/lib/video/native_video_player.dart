import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'video_engine_bindings.dart';

class VideoInfo {
  final int width;
  final int height;
  final Duration duration;
  final double fps;

  VideoInfo({
    required this.width,
    required this.height,
    required this.duration,
    required this.fps,
  });
}

class NativeVideoPlayer {
  final VideoEngineBindings _bindings = VideoEngineBindings();
  ffi.Pointer<ffi.Void>? _decoder;
  VideoInfo? _info;

  Future<void> open(String filePath) async {
    final pathPtr = filePath.toNativeUtf8();
    try {
      _decoder = _bindings.videoDecoderCreate(pathPtr);
      if (_decoder == null || _decoder!.address == 0) {
        throw Exception('Failed to open video file: $filePath');
      }

      // Load video info
      final width = _bindings.videoDecoderGetWidth(_decoder!);
      final height = _bindings.videoDecoderGetHeight(_decoder!);
      final durationMs = _bindings.videoDecoderGetDuration(_decoder!);
      final fpsNum = _bindings.videoDecoderGetFpsNum(_decoder!);
      final fpsDen = _bindings.videoDecoderGetFpsDen(_decoder!);

      _info = VideoInfo(
        width: width,
        height: height,
        duration: Duration(milliseconds: durationMs),
        fps: fpsNum / fpsDen,
      );
    } finally {
      malloc.free(pathPtr);
    }
  }

  Future<int> getFrameTextureId(Duration timestamp) async {
    if (_decoder == null) {
      throw StateError('Video not opened');
    }

    final textureId = _bindings.videoDecoderDecodeFrame(
      _decoder!,
      timestamp.inMilliseconds,
    );

    return textureId;
  }

  Future<void> seek(Duration timestamp) async {
    if (_decoder == null) {
      throw StateError('Video not opened');
    }

    final success = _bindings.videoDecoderSeek(
      _decoder!,
      timestamp.inMilliseconds,
    );

    if (!success) {
      throw Exception('Seek failed');
    }
  }

  VideoInfo? get info => _info;

  void dispose() {
    if (_decoder != null) {
      _bindings.videoDecoderDestroy(_decoder!);
      _decoder = null;
    }
  }
}
