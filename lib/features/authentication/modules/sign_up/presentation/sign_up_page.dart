import 'package:flutter/material.dart';
import 'package:english_learning_app/core/services/authentication_service.dart';
import 'package:english_learning_app/core/services/firestore_service.dart';
import 'package:english_learning_app/shared/widgets/auth/status_message_banner.dart';
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

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  late final SignUpUseCase _signUpUseCase;
  late SignUpState _state;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late String _selectedLevel;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _selectedLevel = 'Beginner';
    _state = SignUpState();

    final authService = AuthenticationService.instance;
    final firestoreService = FirestoreService.instance;
    final userDataSource = UserRemoteDataSourceImpl(firestoreService);
    final repository = SignUpRepositoryImpl(authService, userDataSource);
    _signUpUseCase = SignUpUseCase(repository);

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    setState(() {
      _state = SignUpState();
    });

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

      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chào mừng, ${user.email}!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder: (child, animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: _state.isFailure
                        ? Container(
                            key: ValueKey(_state.errorMessage ?? 'error'),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: StatusMessageBanner(
                              message: _state.errorMessage ?? 'Đã xảy ra lỗi',
                              isError: true,
                            ),
                          )
                        : _state.isSuccess
                        ? Container(
                            key: ValueKey(_state.successMessage ?? 'success'),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: StatusMessageBanner(
                              message: _state.successMessage ?? 'Thành công',
                              isError: false,
                            ),
                          )
                        : const SizedBox(key: ValueKey('message_empty')),
                  ),
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
                              setState(() {
                                _selectedLevel = newSelection.first;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: AnimatedScale(
                      scale: _state.isLoading ? 0.985 : 1,
                      duration: const Duration(milliseconds: 150),
                      child: ElevatedButton(
                        onPressed: _state.isLoading ? null : _handleSignUp,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: _state.isLoading
                              ? const SizedBox(
                                  key: ValueKey('loading'),
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Đăng Ký',
                                  key: ValueKey('label'),
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Đã có tài khoản? '),
                      TextButton(
                        onPressed: _state.isLoading
                            ? null
                            : widget.onSignInPressed,
                        child: const Text('Đăng Nhập'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
