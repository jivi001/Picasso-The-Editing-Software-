import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picasoo_app/ui/organisms/timeline_widget.dart';

void main() {
  testWidgets('TimelineWidget renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: TimelineWidget()),
    ));

    // Verify that the timeline widget is present
    expect(find.byType(TimelineWidget), findsOneWidget);

    // Verify timeline text is present
    expect(find.text('Timeline 1'), findsOneWidget);
  });
}
