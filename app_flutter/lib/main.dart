import 'package:flutter/material.dart';
import 'core/theme/picasoo_theme.dart';
import 'ui/layouts/main_window_layout.dart';

void main() {
  runApp(const PicasooApp());
}

class PicasooApp extends StatelessWidget {
  const PicasooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picasoo Video Editor',
      theme: PicasooTheme.darkTheme,
      home: const MainWindowLayout(),
    );
  }
}
