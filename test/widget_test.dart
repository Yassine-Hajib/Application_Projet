import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:CAF/main.dart';  
void main() {
  testWidgets('App loads and shows Login page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text("Login"), findsOneWidget);

    expect(find.byType(TextField), findsWidgets);

    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
