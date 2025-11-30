import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Bar (Tools)
        Container(
          height: 32,
          color: PicasooColors.surface2,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Text('Timeline 1', style: PicasooTypography.h2),
              const Spacer(),
              const Icon(Icons.grid_on, size: 16, color: PicasooColors.textMed),
              const SizedBox(width: 16),
              const Icon(Icons.link, size: 16, color: PicasooColors.textMed),
            ],
          ),
        ),
        // Timeline Area
        Expanded(
          child: Container(
            color: PicasooColors.surface0,
            child: Column(
              children: [
                // Ruler Row
                SizedBox(
                  height: 24,
                  child: Row(
                    children: [
                      // Header Spacer
                      Container(
                        width: 120,
                        decoration: const BoxDecoration(
                          color: PicasooColors.surface1,
                          border: Border(
                            bottom: BorderSide(color: PicasooColors.border),
                            right: BorderSide(color: PicasooColors.border),
                          ),
                        ),
                      ),
                      // Ruler
                      Expanded(
                        child: CustomPaint(
                          painter: _RulerPainter(),
                          size: Size.infinite,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tracks Area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _VideoTrack(name: 'Video 1'),
                        _VideoTrack(name: 'Video 2'),
                        _AudioTrack(name: 'Audio 1'),
                        _AudioTrack(name: 'Audio 2'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _VideoTrack extends StatelessWidget {
  final String name;

  const _VideoTrack({required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          // Track Header
          Container(
            width: 120,
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
                Text(name,
                    style: PicasooTypography.small
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _TrackIcon(Icons.lock_open),
                    SizedBox(width: 4),
                    _TrackIcon(Icons.visibility),
                  ],
                ),
              ],
            ),
          ),
          // Track Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: PicasooColors.surface0,
                border: Border(bottom: BorderSide(color: PicasooColors.border)),
              ),
              child: Stack(
                children: [
                  // Placeholder Clip
                  Positioned(
                    left: 50,
                    top: 2,
                    bottom: 2,
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: PicasooColors.primary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: PicasooColors.primary),
                      ),
                      child: Center(
                        child: Text('Clip 001', style: PicasooTypography.small),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioTrack extends StatelessWidget {
  final String name;

  const _AudioTrack({required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // Track Header
          Container(
            width: 120,
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
                Text(name,
                    style: PicasooTypography.small
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _TrackIcon(Icons.lock_open),
                    SizedBox(width: 4),
                    _TrackIcon(Icons.volume_up),
                  ],
                ),
              ],
            ),
          ),
          // Track Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: PicasooColors.surface0,
                border: Border(bottom: BorderSide(color: PicasooColors.border)),
              ),
              child: Stack(
                children: [
                  // Placeholder Clip
                  Positioned(
                    left: 100,
                    top: 2,
                    bottom: 2,
                    width: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: PicasooColors.success.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: PicasooColors.success),
                      ),
                      child: Center(
                        child:
                            Text('Audio 001', style: PicasooTypography.small),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    for (double i = 0; i < size.width; i += 10) {
      final isMajor = i % 100 == 0;
      final height = isMajor ? 12.0 : 6.0;
      canvas.drawLine(
        Offset(i, size.height),
        Offset(i, size.height - height),
        paint,
      );

      if (isMajor) {
        // Draw text (simplified)
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
