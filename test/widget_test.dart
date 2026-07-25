import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey/app/app.dart';

void main() {
  testWidgets('Journey app loads home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const JourneyApp());

    expect(find.text('Write your story, one chapter at a time.'), findsOneWidget);
    expect(find.text('Write your story, one chapter at a time.'), findsOneWidget);
    expect(find.byIcon(Icons.auto_stories_outlined), findsOneWidget);
  });
}
