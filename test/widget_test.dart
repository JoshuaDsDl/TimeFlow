import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gestion_temps/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp());

    // Cette application n'a pas de compteur, alors nous testons juste le chargement
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
