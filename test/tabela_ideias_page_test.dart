import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:appideias/main.dart';
import 'mocks/mocks.mocks.dart';

void main() {
  late MockFirestoreService mockService;

  setUp(() {
    mockService = MockFirestoreService();
  });

  testWidgets('Exibe uma ideia na tela', (WidgetTester tester) async {
    when(mockService.getIdeias()).thenAnswer(
      (_) => Stream.value([
        {
          'nome': 'Maria',
          'ideia': 'App de receitas saudáveis',
          'email': 'maria@teste.com',
          'timestamp': Timestamp.now(),
        }
      ]),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: IdeiasScreen(firestoreService: mockService),
      ),
    );

    await tester.pump(); // Primeira construção
    await tester.pump(); // Reatiuilder

    expect(find.text('Maria'), findsOneWidget);
    expect(find.text('App de receitas saudáveis'), findsOneWidget);
    expect(find.byIcon(Icons.email), findsWidgets);
  });
}
