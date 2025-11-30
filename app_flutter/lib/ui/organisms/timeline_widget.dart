import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';
import '../../core/project_state.dart';
import '../../timeline/timeline_model.dart';

class TimelineWidget extends StatefulWidget {
  final double pixelsPerSecond;
  final bool showTools;
  final bool showHeaders;
  final bool fitToWidth;
  final Timeline? timelineOverride; // Optional override for Source Tape

  const TimelineWidget({
    super.key,
    this.pixelsPerSecond = 10.0,
    this.showTools = true,
    this.showHeaders = true,
    this.fitToWidth = false,
    this.timelineOverride,
  });

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  final ScrollController _verticalController1 = ScrollController();
  final ScrollController _verticalController2 = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  // Sync vertical scrolling
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _verticalController1.addListener(() {
      if (!_isSyncing) {
        _isSyncing = true;
        if (_verticalController1.hasClients &&
            _verticalController2.hasClients) {
          _verticalController2.jumpTo(_verticalController1.offset);
        }
        _isSyncing = false;
      }
    });
    _verticalController2.addListener(() {
      if (!_isSyncing) {
        _isSyncing = true;
        if (_verticalController1.hasClients &&
            _verticalController2.hasClients) {
          _verticalController1.jumpTo(_verticalController2.offset);
        }
        _isSyncing = false;
      }
    });
  }

  @override
  void dispose() {
    _verticalController1.dispose();
    _verticalController2.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectState = context.watch<ProjectState>();
    final timeline = widget.timelineOverride ?? projectState.timeline;

    return ListenableBuilder(
      listenable: timeline,
      builder: (context, child) {
        double pixelsPerSecond = widget.pixelsPerSecond;

        if (widget.fitToWidth) {
          final width = MediaQuery.of(context).size.width -
              (widget.showHeaders ? 120 : 0);
          final durationSecs =
              math.max(1.0, timeline.duration.inMilliseconds / 1000);
          pixelsPerSecond = width / durationSecs;
        }

        // Calculate total width based on duration
        final double durationWidth =
            timeline.duration.inMilliseconds / 1000 * pixelsPerSecond;

        // Ensure we have enough space to drop things at the end (only if not fitting to width)
        final double contentWidth =
            widget.fitToWidth ? durationWidth : math.max(durationWidth, 3000.0);

        return Column(
          children: [
            // Top Bar (Tools)
            if (widget.showTools)
              Container(
                height: 32,
                color: PicasooColors.surface2,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Text('Timeline 1', style: PicasooTypography.h2),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.play_arrow,
                          size: 16, color: PicasooColors.textMed),
                      onPressed: () {
                        // TODO: Implement playback
                      },
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.grid_on,
                        size: 16, color: PicasooColors.textMed),
                    const SizedBox(width: 16),
                    const Icon(Icons.link,
                        size: 16, color: PicasooColors.textMed),
                  ],
                ),
              ),
            // Timeline Area
            Expanded(
              child: Container(
                color: PicasooColors.surface0,
                child: Column(
                  children: [
                    // Ruler Row (Fixed Header + Scrollable Ruler)
                    SizedBox(
                      height: 24,
                      child: Row(
                        children: [
                          // Header Spacer
                          if (widget.showHeaders)
                            Container(
                              width: 120,
                              decoration: const BoxDecoration(
                                color: PicasooColors.surface1,
                                border: Border(
                                  bottom:
                                      BorderSide(color: PicasooColors.border),
                                  right:
                                      BorderSide(color: PicasooColors.border),
                                ),
                              ),
                            ),
                          // Scrollable Ruler
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _horizontalController,
                              scrollDirection: Axis.horizontal,
                              physics:
                                  const ClampingScrollPhysics(), // Prevent bouncing desync
                              child: GestureDetector(
                                onTapUp: (details) {
                                  final pos = details.localPosition.dx;
                                  final seconds = pos / pixelsPerSecond;
                                  timeline.setPlayheadPosition(Duration(
                                      milliseconds: (seconds * 1000).round()));
                                },
                                child: CustomPaint(
                                  painter: _RulerPainter(
                                      duration: timeline.duration,
                                      pixelsPerSecond: pixelsPerSecond),
                                  size: Size(contentWidth, 24),
                                  foregroundPainter: _PlayheadPainter(
                                    position: timeline.playheadPosition,
                                    height: 24,
                                    pixelsPerSecond: pixelsPerSecond,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tracks Area
                    Expanded(
                      child: Row(
                        children: [
                          // Fixed Headers (Vertical Scroll)
                          if (widget.showHeaders)
                            SizedBox(
                              width: 120,
                              child: SingleChildScrollView(
                                controller: _verticalController1,
                                physics: const ClampingScrollPhysics(),
                                child: Column(
                                  children: [
                                    ...timeline.videoTracks.map((track) =>
                                        _TrackHeader(track: track, height: 64)),
                                    ...timeline.audioTracks.map((track) =>
                                        _TrackHeader(track: track, height: 48)),
                                    // Extra space at bottom
                                    const SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ),
                          // Scrollable Content (Bidirectional)
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller:
                                  _horizontalController, // Sync with Ruler
                              physics: const ClampingScrollPhysics(),
                              child: SizedBox(
                                width: contentWidth,
                                child: DragTarget<FileSystemEntity>(
                                  onAcceptWithDetails: (details) {
                                    projectState
                                        .addClipToTimeline(details.data);
                                  },
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    return Stack(
                                      children: [
                                        // Tracks Content
                                        SingleChildScrollView(
                                          controller:
                                              _verticalController2, // Sync with Headers
                                          physics:
                                              const ClampingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              ...timeline.videoTracks.map(
                                                  (track) => _TrackContent(
                                                      track: track,
                                                      height: 64,
                                                      pixelsPerSecond:
                                                          pixelsPerSecond)),
                                              ...timeline.audioTracks.map(
                                                  (track) => _TrackContent(
                                                      track: track,
                                                      height: 48,
                                                      pixelsPerSecond:
                                                          pixelsPerSecond)),
                                              // Extra space at bottom
                                              const SizedBox(height: 100),
                                            ],
                                          ),
                                        ),
                                        // Playhead Line (Overlay)
                                        Positioned(
                                          left: timeline.playheadPosition
                                                  .inMilliseconds /
                                              1000 *
                                              pixelsPerSecond,
                                          top: 0,
                                          bottom: 0,
                                          width: 1,
                                          child: Container(color: Colors.red),
                                        ),
                                        // Drag Highlight
                                        if (candidateData.isNotEmpty)
                                          Positioned.fill(
                                            child: Container(
                                              color: PicasooColors.primary
                                                  .withValues(alpha: 0.1),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
}

class _TrackHeader extends StatelessWidget {
  final Track track;
  final double height;

  const _TrackHeader({required this.track, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: PicasooColors.surface1,
        border: Border(
          bottom: BorderSide(color: PicasooColors.border),
          right: BorderSide(color: PicasooColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(track.name,
              style: PicasooTypography.small
                  .copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              const _TrackIcon(Icons.lock_open),
              const SizedBox(width: 4),
              _TrackIcon(track.type == ClipType.video
                  ? Icons.visibility
                  : Icons.volume_up),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackContent extends StatelessWidget {
  final Track track;
  final double height;
  final double pixelsPerSecond;

  const _TrackContent(
      {required this.track,
      required this.height,
      required this.pixelsPerSecond});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: PicasooColors.surface0,
        border: Border(bottom: BorderSide(color: PicasooColors.border)),
      ),
      child: Stack(
        children: track.clips.map((clip) {
          final left =
              clip.timelinePosition.inMilliseconds / 1000 * pixelsPerSecond;
          final width = clip.duration.inMilliseconds / 1000 * pixelsPerSecond;

          return Positioned(
            left: left,
            top: 2,
            bottom: 2,
            width: width,
            child: Container(
              decoration: BoxDecoration(
                color: track.type == ClipType.video
                    ? PicasooColors.primary.withValues(alpha: 0.5)
                    : PicasooColors.success.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                    color: track.type == ClipType.video
                        ? PicasooColors.primary
                        : PicasooColors.success),
              ),
              child: Center(
                child: Text(
                  path.basename(clip.mediaPath),
                  style: PicasooTypography.small,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TrackIcon extends StatelessWidget {
  final IconData icon;
  const _TrackIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 12, color: PicasooColors.textMed);
  }
}

class _RulerPainter extends CustomPainter {
  final Duration duration;
  final double pixelsPerSecond;

  _RulerPainter({required this.duration, required this.pixelsPerSecond});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PicasooColors.textLow
      ..strokeWidth = 1;

    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = PicasooColors.surface1,
    );

    // Draw ticks
    // Calculate interval based on pixelsPerSecond to avoid clutter
    double intervalSecs = 1.0;
    if (pixelsPerSecond < 10) intervalSecs = 10.0;
    if (pixelsPerSecond < 1) intervalSecs = 60.0;

    final double intervalPx = intervalSecs * pixelsPerSecond;

    for (double i = 0; i < size.width; i += intervalPx) {
      final isMajor = (i / intervalPx).round() % 5 == 0;
      final height = isMajor ? 12.0 : 6.0;
      canvas.drawLine(
        Offset(i, size.height),
        Offset(i, size.height - height),
        paint,
      );

      if (isMajor) {
        final seconds = (i / pixelsPerSecond).round();
        final textSpan = TextSpan(
          text: _formatTime(seconds),
          style: const TextStyle(color: PicasooColors.textMed, fontSize: 10),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(i + 2, 2));
      }
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PlayheadPainter extends CustomPainter {
  final Duration position;
  final double height;
  final double pixelsPerSecond;

  _PlayheadPainter(
      {required this.position,
      required this.height,
      required this.pixelsPerSecond});

  @override
  void paint(Canvas canvas, Size size) {
    final x = position.inMilliseconds / 1000 * pixelsPerSecond;

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(x, 0),
      Offset(x, height),
      paint,
    );

    // Draw handle
    final path = Path();
    path.moveTo(x - 5, 0);
    path.lineTo(x + 5, 0);
    path.lineTo(x, 10);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
