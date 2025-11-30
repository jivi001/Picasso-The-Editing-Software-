import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picasoo_app/core/theme/picasoo_theme.dart';
import 'package:picasoo_app/ui/layouts/main_window_layout.dart';
import 'package:picasoo_app/core/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const KeyboardShortcutHandler(child: MainWindowLayout()),
    );
  }
}

class KeyboardShortcutHandler extends StatefulWidget {
  final Widget child;

  const KeyboardShortcutHandler({super.key, required this.child});

  @override
  State<KeyboardShortcutHandler> createState() =>
      _KeyboardShortcutHandlerState();
}

class _KeyboardShortcutHandlerState extends State<KeyboardShortcutHandler> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          // Keyboard shortcuts for page navigation
          if (event.logicalKey == LogicalKeyboardKey.digit1 &&
              HardwareKeyboard.instance.isControlPressed) {
            // Ctrl+1: Media page
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit2 &&
              HardwareKeyboard.instance.isControlPressed) {
            // Ctrl+2: Edit page
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit3 &&
              HardwareKeyboard.instance.isControlPressed) {
            // Ctrl+3: Color page
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit4 &&
              HardwareKeyboard.instance.isControlPressed) {
            // Ctrl+4: Fusion page
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: widget.child,
    );
  }
}
