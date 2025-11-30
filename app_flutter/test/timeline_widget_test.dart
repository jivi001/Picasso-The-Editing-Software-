import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picasoo/ui/timeline/timeline_widget.dart';

void main() {
  testWidgets('TimelineWidget renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: TimelineWidget()),
    ));

    // Verify that the timeline ruler is present (by finding a container, simplified)
    expect(find.byType(TimelineWidget), findsOneWidget);
    
    // Verify zoom buttons exist
    expect(find.byIcon(Icons.zoom_in), findsOneWidget);
    expect(find.byIcon(Icons.zoom_out), findsOneWidget);
  });
}
