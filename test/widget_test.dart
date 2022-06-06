// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ekimood/page/mood_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ekimood/main.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets('Test the main screen with calendar',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    // Verify that there is a Calendar on the main page
    expect(find.byKey(const Key("calendar")), findsOneWidget);
  });
  testWidgets("Test main calendar button", (WidgetTester tester) async {
    DateTime date = DateTime.now();
    DateFormat format = DateFormat.yMMMd();
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byType(Icon).last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key("mood_page")), findsOneWidget);
  });
}
