import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/project_state.dart';
import '../organisms/media_pool_widget.dart';
import '../organisms/timeline_widget.dart';
import '../organisms/inspector_widget.dart';
import '../organisms/video_viewer.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projectState = context.watch<ProjectState>();

    return Column(
      children: [
        // Top Half
        Expanded(
          flex: 2,
          child: Row(
            children: [
              // Media Pool
              const Expanded(
                flex: 3,
                child: MediaPoolWidget(),
              ),
              // Viewers
              Expanded(
                flex: 6,
                child: Container(
                  color: Colors.black,
                  margin: const EdgeInsets.all(1),
                  child: VideoViewer(timeline: projectState.timeline),
                ),
              ),
              // Inspector
              const Expanded(
                flex: 3,
                child: InspectorWidget(),
              ),
            ],
          ),
        ),
        // Bottom Half (Timeline)
        const Expanded(
          flex: 1,
          child: TimelineWidget(),
        ),
      ],
    );
  }
}
