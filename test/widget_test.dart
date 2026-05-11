import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_recive/main.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeReciveApp());
    expect(find.byType(RecipeReciveApp), findsOneWidget);
  });
}
