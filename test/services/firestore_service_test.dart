import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mocks.mocks.dart';
import 'dart:io';

class FirestoreService {
  final FirebaseFirestore db;

  FirestoreService({FirebaseFirestore? firestore})
      : db = firestore ?? FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getIdeias() async {
    try {
      final snapshot = await db
          .collection('ideias')
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      stdout.write('Erro ao buscar ideias: $e');
      return [];
    }
  }
}

void main() {
  group('FirestoreService Tests', () {
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockCollection;
    late MockQuery mockQuery;
    late MockQuerySnapshot mockQuerySnapshot;
    late MockQueryDocumentSnapshot mockDoc;
    late FirestoreService service;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference();
      mockQuery = MockQuery();
      mockQuerySnapshot = MockQuerySnapshot();
      mockDoc = MockQueryDocumentSnapshot();
      service = FirestoreService(firestore: mockFirestore);
    });

    test('getIdeias retorna lista de mapas com dados corretos', () async {
      when(mockFirestore.collection('ideias')).thenReturn(mockCollection);
      when(mockCollection.orderBy('timestamp', descending: true))
          .thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockDoc]);
      when(mockDoc.id).thenReturn('doc1');
      when(mockDoc.data()).thenReturn({
        'nome': 'Teste',
        'ideia': 'Ideia incrível',
        'email': 'teste@example.com',
        'timestamp': Timestamp.now(),
      });

      final result = await service.getIdeias();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 1);
      expect(result[0]['id'], 'doc1');
      expect(result[0]['nome'], 'Teste');
      expect(result[0]['ideia'], 'Ideia incrível');
      expect(result[0]['email'], 'teste@example.com');
    });

    test('getIdeias retorna lista vazia em caso de erro', () async {
      when(mockFirestore.collection('ideias')).thenReturn(mockCollection);
      when(mockCollection.orderBy('timestamp', descending: true))
          .thenReturn(mockQuery);
      when(mockQuery.get()).thenThrow(Exception('Erro no Firestore'));

      final result = await service.getIdeias();

      expect(result, isEmpty);
    });
  });
}