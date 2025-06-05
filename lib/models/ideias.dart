import 'package:cloud_firestore/cloud_firestore.dart';

class Ideia {
  final String nome;
  final String email;
  final String ideia;
  final DateTime timestamp;

  Ideia({
    required this.nome,
    required this.email,
    required this.ideia,
    required this.timestamp,
  });

   factory Ideia.fromMap(Map<String, dynamic> map) {
    return Ideia(
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      ideia: map['ideia'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}