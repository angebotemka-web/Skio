import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_action_mobile/main.dart';

void main() {
  testWidgets('shows alpha screen', (tester) async {
    await tester.pumpWidget(const CardActionApp());
    expect(find.text('Card Action • Alpha'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });
}
