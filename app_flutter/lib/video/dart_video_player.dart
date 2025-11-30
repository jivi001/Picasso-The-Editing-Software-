import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class DartVideoPlayer extends StatefulWidget {
  final String videoPath;
  final Duration currentTime;

  const DartVideoPlayer({
    super.key,
    required this.videoPath,
    this.currentTime = Duration.zero,
  });

  @override
  State<DartVideoPlayer> createState() => _DartVideoPlayerState();
}

class _DartVideoPlayerState extends State<DartVideoPlayer> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();

    // Initialize media_kit player
    player = Player();
    controller = VideoController(player);

    // Open video file
    player.open(Media(widget.videoPath));

    // Seek to initial position
    if (widget.currentTime != Duration.zero) {
      player.seek(widget.currentTime);
    }
  }

  @override
  void didUpdateWidget(DartVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle video path change
    if (widget.videoPath != oldWidget.videoPath) {
      player.open(Media(widget.videoPath));
    }

    // Update playback position when timeline changes
    if (widget.currentTime != oldWidget.currentTime) {
      player.seek(widget.currentTime);
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: controller,
      controls: NoVideoControls,
    );
  }
}
