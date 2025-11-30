import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import 'timeline_widget.dart';

class DualTimelineWidget extends StatelessWidget {
  const DualTimelineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Upper Timeline (Macro View)
        // Shows the entire timeline fitted to width
        Container(
          height: 60,
          color: PicasooColors.surface1,
          child: const TimelineWidget(
            fitToWidth: true,
            showHeaders: false,
            showTools: false,
            pixelsPerSecond: 1.0, // Will be overridden by fitToWidth
          ),
        ),
        // Divider
        const Divider(height: 1, color: PicasooColors.border),
        // Lower Timeline (Micro View)
        // Zoomed in view for precise editing
        const Expanded(
          child: TimelineWidget(
            fitToWidth: false,
            showHeaders: true,
            showTools: true,
            pixelsPerSecond: 50.0, // Zoomed in
          ),
        ),
      ],
    );
  }
}
