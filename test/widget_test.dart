import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games/screens/setup/setup_screen.dart';

void main() {
  testWidgets('Setup screen renders first step', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SetupScreen(),
        ),
      ),
    );

    expect(find.text('GrowMeへようこそ！'), findsOneWidget);
    expect(find.text('性別を選択してください'), findsOneWidget);
  });
}
