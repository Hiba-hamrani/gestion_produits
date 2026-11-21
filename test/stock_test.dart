import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gestion_produits/main.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Le bouton + met à jour le stock et le total automatiquement',
      (tester) async {
    await tester.pumpWidget(const AppRoot());
    await tester.pumpAndSettle();

    // Stock initial du produit 1 (Ordinateur portable) = 5, total = 29
    expect(find.text('En stock : 5'), findsOneWidget);
    expect(find.textContaining('Total en stock : 29'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('inc_1')));
    await tester.pump();

    expect(find.text('En stock : 6'), findsOneWidget);
    expect(find.textContaining('Total en stock : 30'), findsOneWidget);
  });

  testWidgets('Le bouton - fait passer un produit en rupture',
      (tester) async {
    await tester.pumpWidget(const AppRoot());
    await tester.pumpAndSettle();

    // Souris (id 6) : stock 1 -> 0
    await tester.scrollUntilVisible(find.byKey(const ValueKey('dec_6')), 200);
    await tester.tap(find.byKey(const ValueKey('dec_6')));
    await tester.pump();

    expect(find.textContaining('En rupture : 2'), findsOneWidget);
  });
}
