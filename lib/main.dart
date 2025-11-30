import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:picasoo_app/core/theme/picasoo_theme.dart';
import 'package:picasoo_app/ui/layouts/main_window_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize media_kit
  MediaKit.ensureInitialized();

  runApp(const PicasooApp());
}

class PicasooApp extends StatelessWidget {
  const PicasooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picasoo - Professional Video Editor',
      debugShowCheckedModeBanner: false,
      theme: PicasooTheme.darkTheme,
      home: const MainWindowLayout(),
    );
  }
}
