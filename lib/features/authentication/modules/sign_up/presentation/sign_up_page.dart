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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB83AF3), Color(0xFF6366F1), Color(0xFF00B4D8)],
          ),
        ),
        child: Stack(
          children: [
            const _Bubble(top: 36, left: 20, size: 22),
            const _Bubble(top: 90, right: 54, size: 16),
            const _Bubble(top: 180, left: 40, size: 14),
            const _Bubble(bottom: 120, right: 26, size: 18),
            const _Bubble(bottom: 48, left: 58, size: 26),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 390),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x2A13214D),
                                blurRadius: 24,
                                offset: Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 98,
                                right: 0,
                                child: Container(
                                  width: 142,
                                  height: 90,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFA066FF),
                                        Color(0xFF7F82FF),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(28),
                                      bottomLeft: Radius.circular(28),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 62,
                                left: 0,
                                child: Container(
                                  width: 138,
                                  height: 86,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFBB59D7),
                                        Color(0xFF6E8BFF),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(36),
                                      bottomRight: Radius.circular(36),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  24,
                                  20,
                                  16,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'LOGO',
                                        style: TextStyle(
                                          fontSize: 36,
                                          letterSpacing: 2.4,
                                          color: Color(0xFF9AA0B5),
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: _state.isLoading
                                                ? null
                                                : widget.onSignInPressed,
                                            child: const Text(
                                              'Đăng nhập',
                                              style: TextStyle(
                                                color: Color(0xFF8A93A8),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Text(
                                            'Đăng ký',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF4A5A85),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        16,
                                        16,
                                        14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x201B1A3D),
                                            blurRadius: 20,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          _buildInput(
                                            controller: _emailController,
                                            hint: 'Email',
                                            icon: Icons.email_outlined,
                                            enabled: !_state.isLoading,
                                          ),
                                          const SizedBox(height: 12),
                                          _buildInput(
                                            controller: _passwordController,
                                            hint: 'Mật khẩu',
                                            icon: Icons.lock_outline,
                                            enabled: !_state.isLoading,
                                            obscureText: true,
                                          ),
                                          const SizedBox(height: 12),
                                          _buildInput(
                                            controller:
                                                _confirmPasswordController,
                                            hint: 'Xác nhận mật khẩu',
                                            icon: Icons.lock_reset_rounded,
                                            enabled: !_state.isLoading,
                                            obscureText: true,
                                          ),
                                          const SizedBox(height: 14),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF5F7FF),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: SegmentedButton<String>(
                                              style: const ButtonStyle(
                                                visualDensity:
                                                    VisualDensity.compact,
                                              ),
                                              segments: const [
                                                ButtonSegment(
                                                  label: Text('Beginner'),
                                                  value: 'Beginner',
                                                ),
                                                ButtonSegment(
                                                  label: Text('Inter'),
                                                  value: 'Intermediate',
                                                ),
                                                ButtonSegment(
                                                  label: Text('Adv'),
                                                  value: 'Advanced',
                                                ),
                                              ],
                                              selected: {_selectedLevel},
                                              onSelectionChanged:
                                                  (Set<String> value) {
                                                    if (_state.isLoading)
                                                      return;
                                                    setState(() {
                                                      _selectedLevel =
                                                          value.first;
                                                    });
                                                  },
                                            ),
                                          ),
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 220,
                                            ),
                                            child: _state.isFailure
                                                ? Padding(
                                                    key: ValueKey(
                                                      _state.errorMessage,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 12,
                                                        ),
                                                    child: StatusMessageBanner(
                                                      message:
                                                          _state.errorMessage ??
                                                          'Đã xảy ra lỗi',
                                                      isError: true,
                                                    ),
                                                  )
                                                : _state.isSuccess
                                                ? Padding(
                                                    key: ValueKey(
                                                      _state.successMessage,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 12,
                                                        ),
                                                    child: StatusMessageBanner(
                                                      message:
                                                          _state
                                                              .successMessage ??
                                                          'Thành công',
                                                      isError: false,
                                                    ),
                                                  )
                                                : const SizedBox(
                                                    key: ValueKey('no_message'),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: const Offset(0, -12),
                                      child: Center(
                                        child: AnimatedScale(
                                          scale: _state.isLoading ? 0.98 : 1,
                                          duration: const Duration(
                                            milliseconds: 150,
                                          ),
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF3AD8F6),
                                                  Color(0xFF4F8BFF),
                                                ],
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x5544A3FF),
                                                  blurRadius: 14,
                                                  offset: Offset(0, 7),
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              onPressed: _state.isLoading
                                                  ? null
                                                  : _handleSignUp,
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                shadowColor: Colors.transparent,
                                                backgroundColor:
                                                    Colors.transparent,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 34,
                                                      vertical: 14,
                                                    ),
                                              ),
                                              child: _state.isLoading
                                                  ? const SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Colors.white,
                                                          ),
                                                    )
                                                  : const Text('Sign up'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Đã có tài khoản?',
                                          style: TextStyle(
                                            color: Color(0xFF6F7890),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: _state.isLoading
                                              ? null
                                              : widget.onSignInPressed,
                                          child: const Text(
                                            'Đăng nhập',
                                            style: TextStyle(
                                              color: Color(0xFF7E45D6),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool enabled,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        suffixIcon: Icon(icon, size: 20, color: const Color(0xFF98A1B9)),
        filled: true,
        fillColor: const Color(0xFFF8FAFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;

  const _Bubble({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.55),
            width: 1.6,
          ),
        ),
      ),
    );
  }
}
