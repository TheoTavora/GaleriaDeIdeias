import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await signInAnonymously();
  runApp(MyApp());
}

Future<void> signInAnonymously() async {
  try {
    await FirebaseAuth.instance.signInAnonymously();
    debugPrint('Usuário autenticado anonimamente');
  } catch (e) {
    debugPrint('Erro ao autenticar: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: IdeiasScreen(),
  );
}

class IdeiasScreen extends StatelessWidget {
 final FirestoreService firestoreService;

   IdeiasScreen({super.key, FirestoreService? firestoreService})
      : firestoreService = firestoreService ?? FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar com gradiente e ícone
      appBar: AppBar(
        title: Text(
          'Galeria de Ideias',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
      ),
      // Corpo com fundo sutil
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: firestoreService.getIdeias(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 8),
                    Text(
                      'Erro: ${snapshot.error}',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.grey, size: 48),
                    SizedBox(height: 8),
                    Text(
                      'Nenhuma ideia encontrada.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            final ideias = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: ideias.length,
              itemBuilder: (context, index) {
                final ideia = ideias[index];
                return _buildIdeiaCard(context, ideia, index);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildIdeiaCard(BuildContext context, Map<String, dynamic> ideia, int index) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar com inicial do nome
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  ideia['nome']?.isNotEmpty == true ? ideia['nome'][0].toUpperCase() : '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              // Conteúdo da ideia
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome como título
                    Text(
                      ideia['nome'] ?? 'Sem nome',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    // Descrição da ideia
                    Text(
                      ideia['ideia'] ?? 'Sem descrição',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    // Email com ícone
                    Row(
                      children: [
                        Icon(Icons.email, size: 16, color: Colors.blueAccent),
                        SizedBox(width: 4),
                        Text(
                          ideia['email'] ?? 'Sem email',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // Timestamp com ícone
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          _formatTimestamp(ideia['timestamp']),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Ícone decorativo
              Icon(
                Icons.lightbulb,
                color: Colors.yellow[700],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
    return 'Data inválida';
  }
}