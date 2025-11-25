import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caf/main.dart';

void main() {
  testWidgets('App loads and shows Login page', (WidgetTester tester) async {
    // Load the app
    await tester.pumpWidget(MyApp());

    // Check that the login screen appears
    expect(find.text("Login"), findsOneWidget);

    // Example: Check if email field exists
    expect(find.byType(TextField), findsWidgets);

    // Example: Check if there is at least one button
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
