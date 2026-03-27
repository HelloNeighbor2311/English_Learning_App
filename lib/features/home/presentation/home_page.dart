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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLevelSelected();
    });
  }

  Future<void> _ensureLevelSelected() async {
    final userId = AuthenticationService.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final data = await FirestoreService.instance.getDocument(
        collectionPath: 'users',
        documentId: userId,
      );
      final level = (data?['level'] as String? ?? '').trim();

      if (!mounted || level.isNotEmpty) return;

      final selected = await _showLevelSetupDialog();
      if (!mounted || selected == null) return;

      await FirestoreService.instance.setDocument(
        collectionPath: 'users',
        documentId: userId,
        data: {
          'level': selected,
          'updatedAt': DateTime.now().toUtc().toIso8601String(),
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã lưu trình độ: $selected'),
          backgroundColor: const Color(0xFF1E8A4D),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể kiểm tra trình độ: $e'),
          backgroundColor: const Color(0xFFC73A4D),
        ),
      );
    }
  }

  Future<String?> _showLevelSetupDialog() async {
    String selectedLevel = 'Beginner';

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Chọn trình độ học'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Thiết lập nhanh để cá nhân hóa nội dung học cho bạn.',
                  ),
                  const SizedBox(height: 14),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Beginner', label: Text('Beginner')),
                      ButtonSegment(
                        value: 'Intermediate',
                        label: Text('Intermediate'),
                      ),
                      ButtonSegment(value: 'Advanced', label: Text('Advanced')),
                    ],
                    selected: {selectedLevel},
                    onSelectionChanged: (value) {
                      setModalState(() {
                        selectedLevel = value.first;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(selectedLevel),
                  child: const Text('Xác nhận'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveTestData() async {
    setState(() {
      _isSaving = true;
      _status = 'Đang lưu...';
    });

    try {
      final userId = AuthenticationService.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('Bạn chưa đăng nhập.');
      }

      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await FirestoreService.instance.setDocument(
        collectionPath: 'users/$userId/app_logs',
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF4F8FF), Color(0xFFEAF1FF), Color(0xFFE1ECFF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Trang chủ',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF122847),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Xin chào, ${user?.email ?? 'Người dùng'}',
                            style: const TextStyle(
                              color: Color(0xFF4D607A),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        onPressed: _signOut,
                        icon: const Icon(Icons.logout_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF516BFF), Color(0xFF7D4DFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3B4B62FF),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiến trình hôm nay',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Giữ streak mỗi ngày để lên cấp nhanh hơn!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A1B2B55),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kiểm tra kết nối Firestore',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A2A47),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _isSaving ? null : _saveTestData,
                        child: Text(
                          _isSaving ? 'Đang lưu...' : 'Lưu dữ liệu test',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _status,
                        style: const TextStyle(color: Color(0xFF5A6D86)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
