import 'package:appideias/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks(
  [
    FirebaseFirestore,

  ],
  customMocks: [
    MockSpec<CollectionReference<Map<String, dynamic>>>(
      as: #MockCollectionReference,
    ),
    MockSpec<Query<Map<String, dynamic>>>(
      as: #MockQuery,
    ),
    MockSpec<QuerySnapshot<Map<String, dynamic>>>(
      as: #MockQuerySnapshot,
    ),
    MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(
      as: #MockQueryDocumentSnapshot,
    ),
    MockSpec<FirestoreService>(
      as: #MockFirestoreService,
    ),
  ],
)
void main() {}