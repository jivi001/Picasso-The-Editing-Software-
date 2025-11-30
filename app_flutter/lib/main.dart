import 'package:flutter/material.dart';
import 'ui/node_editor/node_graph_widget.dart';

void main() {
  runApp(const PicasooApp());
}

class PicasooApp extends StatelessWidget {
  const PicasooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picasoo Video Editor',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainWindow(),
    );
  }
}

class MainWindow extends StatelessWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 60,
            color: Colors.black87,
            child: Column(
              children: [
                IconButton(icon: const Icon(Icons.folder), onPressed: () {}),
                IconButton(icon: const Icon(Icons.movie), onPressed: () {}),
                IconButton(icon: const Icon(Icons.color_lens), onPressed: () {}),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Viewport
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Text('Native Viewport Placeholder'),
                    ),
                  ),
                ),
                // Timeline
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[900],
                    child: const NodeGraphWidget(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
