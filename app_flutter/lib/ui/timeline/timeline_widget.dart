import 'package:flutter/material.dart';

class TimelineWidget extends StatefulWidget {
  const TimelineWidget({super.key});

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  final ScrollController _scrollController = ScrollController();
  double _zoomLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar
        Container(
          height: 40,
          color: Colors.grey[850],
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.zoom_in), onPressed: () => setState(() => _zoomLevel *= 1.2)),
              IconButton(icon: const Icon(Icons.zoom_out), onPressed: () => setState(() => _zoomLevel /= 1.2)),
            ],
          ),
        ),
        // Tracks
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 2000 * _zoomLevel, // Virtual width
              child: Stack(
                children: [
                  // Time Ruler
                  Positioned(top: 0, left: 0, right: 0, height: 30, child: Container(color: Colors.grey[800])),
                  
                  // Track 1
                  Positioned(
                    top: 30, left: 0, right: 0, height: 100,
                    child: Container(
                      color: Colors.black26,
                      child: Stack(
                        children: [
                          // Clip 1
                          Positioned(
                            left: 50 * _zoomLevel,
                            top: 10,
                            width: 200 * _zoomLevel,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.blueAccent),
                              ),
                              child: const Center(child: Text("Clip 1.mp4", style: TextStyle(color: Colors.white))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Playhead
                  Positioned(
                    left: 150 * _zoomLevel, // Mock position
                    top: 0,
                    bottom: 0,
                    width: 2,
                    child: Container(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
