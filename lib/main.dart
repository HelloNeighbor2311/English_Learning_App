import 'package:flutter/material.dart';

import 'bootstrap/firebase_bootstrap.dart';
import 'core/services/authentication_service.dart';
import 'core/services/firestore_service.dart';
import 'core/services/supabase_service.dart';
import 'features/authentication/modules/sign_in/presentation/sign_in_page.dart';
import 'features/authentication/modules/sign_up/presentation/sign_up_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize Firebase
      await FirebaseBootstrap.initialize();

      // Initialize Supabase
      await SupabaseService.instance.initialize(
        supabaseUrl: 'https://addjdomywbpzguehtdgi.supabase.co',
        supabaseAnonKey: 'sb_publishable_d183qj_43wFoD28oqON4Fg_7qru0CFp',
      );
    } catch (e) {
      print('Initialization error: $e');
      // Continue anyway, but services may not work
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder<void>(
        future: _initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Đang khởi động ứng dụng...'),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    const Text('Lỗi khởi động ứng dụng'),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }

          // Initialization successful, show auth wrapper
          return const AuthWrapper();
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthenticationService.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text('Lỗi xác thực'),
                  const SizedBox(height: 8),
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => setState(() => _isSignIn = true),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            // User is signed in, show home
            return const FirestoreConnectionPage();
          } else {
            // User is not signed in, show auth pages
            return _isSignIn
                ? SignInPage(
                    onSignUpPressed: () {
                      setState(() => _isSignIn = false);
                    },
                  )
                : SignUpPage(
                    onSignInPressed: () {
                      setState(() => _isSignIn = true);
                    },
                  );
          }
        }

        // Loading state
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
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
      final userId = AuthenticationService.instance.currentUser?.uid;
      await FirestoreService.instance.setDocument(
        collectionPath: 'app_logs',
        documentId: id,
        data: {
          'type': 'firestore_connection_test',
          'createdAt': DateTime.now().toUtc().toIso8601String(),
          'message': 'Ket noi Firestore thanh cong',
          'userId': userId,
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

  Future<void> _signOut() async {
    await AuthenticationService.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthenticationService.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: _signOut, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Xin chao, ${user?.email ?? 'User'}'),
            const SizedBox(height: 24),
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
