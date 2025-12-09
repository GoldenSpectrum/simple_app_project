import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tomasino_tycoon/main.dart';

void main() {
  testWidgets('CoreValueClicker loads main screen', (WidgetTester tester) async {

    // Load your app

    // Wait for frames
    await tester.pumpAndSettle();

    // Check for the three core buttons by their text
    expect(find.text('Compassion'), findsOneWidget);
    expect(find.text('Competence'), findsOneWidget);
    expect(find.text('Commitment'), findsOneWidget);

    // Test tapping one stat button
    await tester.tap(find.text('Compassion'));
    await tester.pump();

    // It should update the points (starts at 0 → becomes 1)
    expect(find.text('1 pts'), findsOneWidget);
  });
}
