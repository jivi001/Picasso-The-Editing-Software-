import 'package:flutter/material.dart';
import '../organisms/media_pool_widget.dart';
import '../organisms/timeline_widget.dart';
import '../organisms/inspector_widget.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              // Viewers (Placeholder)
              Expanded(
                flex: 6,
                child: Container(
                  color: Colors.black,
                  margin: const EdgeInsets.all(1),
                  child: const Center(
                    child: Text('Source / Program Viewer',
                        style: TextStyle(color: Colors.white54)),
                  ),
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
