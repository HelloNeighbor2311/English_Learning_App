import 'package:flutter/material.dart';

import 'package:english_learning_app/core/services/authentication_service.dart';
import 'package:english_learning_app/core/services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _status = 'Chưa lưu dữ liệu';
  bool _isSaving = false;

  Future<void> _saveTestData() async {
    setState(() {
      _isSaving = true;
      _status = 'Đang lưu...';
    });

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final userId = AuthenticationService.instance.currentUser?.uid;
      await FirestoreService.instance.setDocument(
        collectionPath: 'app_logs',
        documentId: id,
        data: {
          'type': 'firestore_connection_test',
          'createdAt': DateTime.now().toUtc().toIso8601String(),
          'message': 'Kết nối Firestore thành công',
          'userId': userId,
        },
      );

      if (!mounted) return;
      setState(() {
        _status = 'Đã lưu thành công, docId: $id';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _status = 'Lỗi lưu Firestore: $error';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _signOut() async {
    await AuthenticationService.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthenticationService.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(onPressed: _signOut, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Xin chào, ${user?.email ?? 'Người dùng'}'),
            const SizedBox(height: 24),
            const Text('Nhấn nút để kiểm tra ghi dữ liệu lên Firestore'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isSaving ? null : _saveTestData,
              child: Text(_isSaving ? 'Đang lưu...' : 'Lưu dữ liệu test'),
            ),
            const SizedBox(height: 16),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
