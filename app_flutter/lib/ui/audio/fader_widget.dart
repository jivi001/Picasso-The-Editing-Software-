import 'package:flutter/material.dart';

class FaderWidget extends StatefulWidget {
  const FaderWidget({super.key});

  @override
  State<FaderWidget> createState() => _FaderWidgetState();
}

class _FaderWidgetState extends State<FaderWidget> {
  double _value = 0.75; // 0.0 to 1.0

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Track Line
        Container(
          width: 4,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Handle
        LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            return Positioned(
              bottom: _value * (height - 30),
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _value -= details.delta.dy / height;
                    _value = _value.clamp(0.0, 1.0);
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 2, offset: Offset(0, 2))],
                  ),
                  child: Center(
                    child: Container(height: 2, width: 20, color: Colors.black54),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
