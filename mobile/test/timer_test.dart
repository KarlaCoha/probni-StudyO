import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/screens/play_quiz.dart';

void main() {
  testWidgets('Timer starts and updates timer text correctly',
      (WidgetTester tester) async {
    // Create a mock widget
    final TestWidget = MaterialApp(
      home: QuizPage(
          lessonId:
              1), // You may need to adjust this depending on your implementation
    );

    // Pump the widget
    await tester.pumpWidget(TestWidget);

    // Ensure that the initial timer text is '00:00'
    expect(find.text('00:00'), findsOneWidget);

    // Pump the widget for 1 second
    await tester.pump(Duration(seconds: 1));

    // Ensure that the timer text has updated after 1 second
    expect(find.text('00:01'), findsOneWidget);

    // Pump the widget for 60 seconds
    await tester.pump(Duration(seconds: 60));

    // Ensure that the timer text has updated after 60 seconds
    expect(find.text('01:00'), findsOneWidget);

    // Pump the widget for 61 seconds
    await tester.pump(Duration(seconds: 1));

    // Ensure that the timer text has updated after 61 seconds
    expect(find.text('01:01'), findsOneWidget);
  });
}
