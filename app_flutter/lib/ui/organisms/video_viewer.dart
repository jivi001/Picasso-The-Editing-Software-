import 'package:flutter/material.dart';
import 'package:picasoo_app/timeline/timeline_model.dart';
import 'package:picasoo_app/video/dart_video_player.dart';

class VideoViewer extends StatelessWidget {
  final Timeline timeline;

  const VideoViewer({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: timeline,
      builder: (context, child) {
        // Get active clips at current playhead position
        final activeClips =
            timeline.getActiveClipsAtTime(timeline.playheadPosition);

        if (activeClips.isEmpty) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'No Clip',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
          );
        }

        // For now, show the top-most video clip
        final topClip = activeClips.first;

        // Calculate the source timestamp based on timeline position
        final clipOffset = timeline.playheadPosition - topClip.timelinePosition;
        final sourceTime = topClip.inPoint + clipOffset;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Black background
            Container(color: Colors.black),

            // Video frame using media_kit
            Center(
              child: DartVideoPlayer(
                videoPath: topClip.mediaPath,
                currentTime: sourceTime,
              ),
            ),

            // Overlay info (debug)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Timeline: ${_formatDuration(timeline.playheadPosition)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      'Source: ${_formatDuration(sourceTime)}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final frames = ((duration.inMilliseconds % 1000) / (1000 / 24)).floor();
    return '$minutes:$seconds:${frames.toString().padLeft(2, '0')}';
  }
}
