import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conecta_shopping_online/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

// Mock para FirebaseFirestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Criar instâncias mock para Firestore
    final conectaShoppingDB = MockFirebaseFirestore();
    final conectaSystemDB = MockFirebaseFirestore();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      conectaShoppingDB: conectaShoppingDB,
      conectaSystemDB: conectaSystemDB,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
