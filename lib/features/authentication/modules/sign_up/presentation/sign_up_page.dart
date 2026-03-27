import 'package:flutter/material.dart';
import 'package:english_learning_app/core/services/authentication_service.dart';
import 'package:english_learning_app/core/services/firestore_service.dart';
import '../data/sign_up_repository_impl.dart';
import '../data/user_remote_datasource.dart';
import '../domain/sign_up_use_case.dart';
import 'sign_up_state.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onSignInPressed;

  const SignUpPage({super.key, required this.onSignInPressed});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final SignUpUseCase _signUpUseCase;
  late SignUpState _state;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late String _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = 'Beginner';
    _state = SignUpState();

    // Initialize dependencies
    final authService = AuthenticationService.instance;
    final firestoreService = FirestoreService.instance;
    final userDataSource = UserRemoteDataSourceImpl(firestoreService);
    final repository = SignUpRepositoryImpl(authService, userDataSource);
    _signUpUseCase = SignUpUseCase(repository);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Clear previous messages
    setState(() {
      _state = SignUpState();
    });

    // Call use case
    setState(() {
      _state = _state.copyWith(status: SignUpStatus.loading);
    });

    try {
      final user = await _signUpUseCase(
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        level: _selectedLevel,
      );

      if (!mounted) return;

      setState(() {
        _state = _state.copyWith(
          status: SignUpStatus.success,
          successMessage: 'Đăng ký thành công!',
        );
      });

      // Clear form
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      // Show success message and navigate
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chào mừng, ${user.email}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on FormatException catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: e.message,
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: e.toString(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng Ký Tài Khoản')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Error message
              if (_state.isFailure)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _state.errorMessage ?? 'Đã xảy ra lỗi',
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),

              // Success message
              if (_state.isSuccess)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _state.successMessage ?? 'Thành công',
                    style: TextStyle(color: Colors.green.shade800),
                  ),
                ),

              // Email field
              TextField(
                controller: _emailController,
                enabled: !_state.isLoading,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                enabled: !_state.isLoading,
                decoration: InputDecoration(
                  hintText: 'Mật Khẩu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  helperText: 'Tối thiểu 6 ký tự',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Confirm password field
              TextField(
                controller: _confirmPasswordController,
                enabled: !_state.isLoading,
                decoration: InputDecoration(
                  hintText: 'Xác Nhận Mật Khẩu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Level selector
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chọn Trình Độ Tiếng Anh:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          label: Text('Beginner'),
                          value: 'Beginner',
                        ),
                        ButtonSegment(
                          label: Text('Intermediate'),
                          value: 'Intermediate',
                        ),
                        ButtonSegment(
                          label: Text('Advanced'),
                          value: 'Advanced',
                        ),
                      ],
                      selected: {_selectedLevel},
                      onSelectionChanged: (Set<String> newSelection) {
                        if (!_state.isLoading) {
                          setState(() => _selectedLevel = newSelection.first);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sign up button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _state.isLoading ? null : _handleSignUp,
                  child: _state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Đăng Ký', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),

              // Sign in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Đã có tài khoản? '),
                  TextButton(
                    onPressed: _state.isLoading ? null : widget.onSignInPressed,
                    child: const Text('Đăng Nhập'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
