import 'package:flutter/material.dart';

import 'bootstrap/firebase_bootstrap.dart';
import 'core/services/firestore_service.dart';

Future<void> main() async {
  await FirebaseBootstrap.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const FirestoreConnectionPage(),
    );
  }
}

class FirestoreConnectionPage extends StatefulWidget {
  const FirestoreConnectionPage({super.key});

  @override
  State<FirestoreConnectionPage> createState() =>
      _FirestoreConnectionPageState();
}

class _FirestoreConnectionPageState extends State<FirestoreConnectionPage> {
  String _status = 'Chua luu du lieu';
  bool _isSaving = false;

  Future<void> _saveTestData() async {
    setState(() {
      _isSaving = true;
      _status = 'Dang luu...';
    });

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await FirestoreService.instance.setDocument(
        collectionPath: 'app_logs',
        documentId: id,
        data: {
          'type': 'firestore_connection_test',
          'createdAt': DateTime.now().toUtc().toIso8601String(),
          'message': 'Ket noi Firestore thanh cong',
        },
      );

      if (!mounted) return;

      setState(() {
        _status = 'Da luu thanh cong docId: $id';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _status = 'Loi luu Firestore: $error';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nhan nut de test luu du lieu len Firestore'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isSaving ? null : _saveTestData,
              child: Text(_isSaving ? 'Dang luu...' : 'Luu du lieu test'),
            ),
            const SizedBox(height: 16),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
