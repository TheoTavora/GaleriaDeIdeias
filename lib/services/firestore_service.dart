import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db;

  FirestoreService({FirebaseFirestore? firestore})
      : db = firestore ?? FirebaseFirestore.instance;

 Stream<List<Map<String, dynamic>>> getIdeias() {
  return db
      .collection('ideias')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList());
}
}