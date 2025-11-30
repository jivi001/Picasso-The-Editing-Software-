import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

// Native function signatures
typedef VideoDecoderCreateNative = ffi.Pointer<ffi.Void> Function(
    ffi.Pointer<Utf8>);
typedef VideoDecoderCreate = ffi.Pointer<ffi.Void> Function(ffi.Pointer<Utf8>);

typedef VideoDecoderDestroyNative = ffi.Void Function(ffi.Pointer<ffi.Void>);
typedef VideoDecoderDestroy = void Function(ffi.Pointer<ffi.Void>);

typedef VideoDecoderDecodeFrameNative = ffi.Int64 Function(
    ffi.Pointer<ffi.Void>, ffi.Int64);
typedef VideoDecoderDecodeFrame = int Function(ffi.Pointer<ffi.Void>, int);

typedef VideoDecoderSeekNative = ffi.Bool Function(
    ffi.Pointer<ffi.Void>, ffi.Int64);
typedef VideoDecoderSeek = bool Function(ffi.Pointer<ffi.Void>, int);

typedef VideoDecoderGetIntNative = ffi.Int32 Function(ffi.Pointer<ffi.Void>);
typedef VideoDecoderGetInt = int Function(ffi.Pointer<ffi.Void>);

typedef VideoDecoderGetInt64Native = ffi.Int64 Function(ffi.Pointer<ffi.Void>);
typedef VideoDecoderGetInt64 = int Function(ffi.Pointer<ffi.Void>);

class VideoEngineBindings {
  late ffi.DynamicLibrary _lib;

  late VideoDecoderCreate videoDecoderCreate;
  late VideoDecoderDestroy videoDecoderDestroy;
  late VideoDecoderDecodeFrame videoDecoderDecodeFrame;
  late VideoDecoderSeek videoDecoderSeek;
  late VideoDecoderGetInt videoDecoderGetWidth;
  late VideoDecoderGetInt videoDecoderGetHeight;
  late VideoDecoderGetInt64 videoDecoderGetDuration;
  late VideoDecoderGetInt videoDecoderGetFpsNum;
  late VideoDecoderGetInt videoDecoderGetFpsDen;

  VideoEngineBindings() {
    // Load native library
    if (Platform.isWindows) {
      _lib = ffi.DynamicLibrary.open('picasoo_video_engine.dll');
    } else if (Platform.isMacOS) {
      _lib = ffi.DynamicLibrary.open('libpicasoo_video_engine.dylib');
    } else {
      throw UnsupportedError('Platform not supported');
    }

    // Bind functions
    videoDecoderCreate = _lib
        .lookup<ffi.NativeFunction<VideoDecoderCreateNative>>(
            'video_decoder_create')
        .asFunction();

    videoDecoderDestroy = _lib
        .lookup<ffi.NativeFunction<VideoDecoderDestroyNative>>(
            'video_decoder_destroy')
        .asFunction();

    videoDecoderDecodeFrame = _lib
        .lookup<ffi.NativeFunction<VideoDecoderDecodeFrameNative>>(
            'video_decoder_decode_frame')
        .asFunction();

    videoDecoderSeek = _lib
        .lookup<ffi.NativeFunction<VideoDecoderSeekNative>>(
            'video_decoder_seek')
        .asFunction();

    videoDecoderGetWidth = _lib
        .lookup<ffi.NativeFunction<VideoDecoderGetIntNative>>(
            'video_decoder_get_width')
        .asFunction();

    videoDecoderGetHeight = _lib
        .lookup<ffi.NativeFunction<VideoDecoderGetIntNative>>(
            'video_decoder_get_height')
        .asFunction();

    videoDecoderGetDuration = _lib
        .lookup<ffi.NativeFunction<VideoDecoderGetInt64Native>>(
            'video_decoder_get_duration')
        .asFunction();

    videoDecoderGetFpsNum = _lib
        .lookup<ffi.NativeFunction<VideoDecoderGetIntNative>>(
            'video_decoder_get_fps_num')
        .asFunction();

    videoDecoderGetFpsDen = _lib
        .lookup<ffi.NativeFunction<VideoDecoderGetIntNative>>(
            'video_decoder_get_fps_den')
        .asFunction();
  }
}
