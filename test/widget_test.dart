import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games/main.dart';

void main() {
  testWidgets('GrowMe app launches with setup screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: GrowMeApp()));
    expect(find.text('Welcome to GrowMe!'), findsOneWidget);
  });
}
