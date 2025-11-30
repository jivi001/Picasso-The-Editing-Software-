import 'package:flutter/material.dart';
import 'native_video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final Duration currentTime;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
    this.currentTime = Duration.zero,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  NativeVideoPlayer? _player;
  int? _textureId;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      _player = NativeVideoPlayer();
      await _player!.open(widget.videoPath);

      final textureId = await _player!.getFrameTextureId(widget.currentTime);

      setState(() {
        _textureId = textureId;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentTime != oldWidget.currentTime) {
      _updateFrame();
    }
  }

  Future<void> _updateFrame() async {
    if (_player == null) return;

    try {
      final textureId = await _player!.getFrameTextureId(widget.currentTime);
      setState(() {
        _textureId = textureId;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child:
            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
      );
    }

    if (_textureId == null || _textureId! < 0) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text('No video frame', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Texture(textureId: _textureId!);
  }
}
