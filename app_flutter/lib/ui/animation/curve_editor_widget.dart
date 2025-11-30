import 'package:flutter/material.dart';

class CurveEditorWidget extends StatefulWidget {
  const CurveEditorWidget({super.key});

  @override
  State<CurveEditorWidget> createState() => _CurveEditorWidgetState();
}

class _CurveEditorWidgetState extends State<CurveEditorWidget> {
  final List<Offset> points = [
    const Offset(0.0, 0.5),
    const Offset(0.2, 0.2),
    const Offset(0.8, 0.8),
    const Offset(1.0, 0.5),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: CustomPaint(
        painter: CurvePainter(points: points),
        size: Size.infinite,
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final List<Offset> points;

  CurvePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (points.isNotEmpty) {
      // Map normalized points (0..1) to size
      Offset toScreen(Offset p) => Offset(p.dx * size.width, (1.0 - p.dy) * size.height);

      path.moveTo(toScreen(points[0]).dx, toScreen(points[0]).dy);
      
      for (int i = 0; i < points.length - 1; i++) {
        final p1 = toScreen(points[i]);
        final p2 = toScreen(points[i+1]);
        
        // Simple linear for now, would be Bezier in real app
        path.lineTo(p2.dx, p2.dy);
        
        // Draw points
        canvas.drawCircle(p1, 4, Paint()..color = Colors.white..style = PaintingStyle.fill);
      }
      canvas.drawCircle(toScreen(points.last), 4, Paint()..color = Colors.white..style = PaintingStyle.fill);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
