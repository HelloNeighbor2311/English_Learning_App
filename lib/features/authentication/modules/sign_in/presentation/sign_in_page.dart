import 'package:flutter/material.dart';

import 'package:english_learning_app/core/services/authentication_service.dart';
import 'package:english_learning_app/shared/widgets/auth/status_message_banner.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback onSignUpPressed;

  const SignInPage({super.key, required this.onSignUpPressed});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  static const String _appName = 'English Learning App';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
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
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập đầy đủ email và mật khẩu.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthenticationService.instance.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      setState(() {
        _errorMessage = null;
        _isLoading = false;
      });
    } on FormatException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } on Exception {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await AuthenticationService.instance.signInWithGoogle();
      if (!mounted) return;
      setState(() {
        _errorMessage = null;
        _isLoading = false;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Đăng nhập Google thất bại: ${e.toString()}';
        _isLoading = false;
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
                            color: const Color(0xFFFDFEFF),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x2A13214D),
                                blurRadius: 24,
                                offset: Offset(0, 14),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 136,
                                  left: 0,
                                  child: Container(
                                    width: 136,
                                    height: 82,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xAA5C8EFF),
                                          Color(0xAA739BFF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(28),
                                        bottomRight: Radius.circular(28),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 72,
                                  right: 0,
                                  child: Container(
                                    width: 126,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0x99CC57D1),
                                          Color(0x997E67F2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(36),
                                        bottomLeft: Radius.circular(36),
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
                                          _appName,
                                          style: TextStyle(
                                            fontSize: 28,
                                            letterSpacing: 0.2,
                                            color: Color(0xFF7C86A3),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F4FF),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                'Đăng nhập',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF4A5A85),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                onPressed: _isLoading
                                                    ? null
                                                    : widget.onSignUpPressed,
                                                child: const Text(
                                                  'Đăng ký',
                                                  style: TextStyle(
                                                    color: Color(0xFF8A93A8),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          16,
                                          16,
                                          14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFBFCFF),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
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
                                              enabled: !_isLoading,
                                            ),
                                            const SizedBox(height: 12),
                                            _buildInput(
                                              controller: _passwordController,
                                              hint: 'Mật khẩu',
                                              icon: _obscurePassword
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                        .visibility_off_outlined,
                                              enabled: !_isLoading,
                                              obscureText: _obscurePassword,
                                              onIconTap: () {
                                                if (_isLoading) return;
                                                setState(() {
                                                  _obscurePassword =
                                                      !_obscurePassword;
                                                });
                                              },
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: TextButton(
                                                onPressed: _isLoading
                                                    ? null
                                                    : () {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Tính năng quên mật khẩu sẽ được cập nhật sớm.',
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                child: const Text(
                                                  'Quên mật khẩu?',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                milliseconds: 220,
                                              ),
                                              child: _errorMessage == null
                                                  ? const SizedBox(
                                                      key: ValueKey('no_error'),
                                                    )
                                                  : Padding(
                                                      key: ValueKey(
                                                        _errorMessage,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 8,
                                                          ),
                                                      child:
                                                          StatusMessageBanner(
                                                            message:
                                                                _errorMessage!,
                                                            isError: true,
                                                          ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: const Offset(0, -12),
                                        child: Center(
                                          child: AnimatedScale(
                                            scale: _isLoading ? 0.98 : 1,
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
                                                onPressed: _isLoading
                                                    ? null
                                                    : _signInWithEmail,
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 34,
                                                        vertical: 14,
                                                      ),
                                                ),
                                                child: _isLoading
                                                    ? const SizedBox(
                                                        width: 18,
                                                        height: 18,
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      )
                                                    : const Text('Login'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: _isLoading
                                            ? null
                                            : _signInWithGoogle,
                                        icon: const Icon(
                                          Icons.g_mobiledata_rounded,
                                          size: 24,
                                        ),
                                        label: const Text(
                                          'Tiếp tục với Google',
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Chưa có tài khoản?',
                                            style: TextStyle(
                                              color: Color(0xFF6F7890),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: _isLoading
                                                ? null
                                                : widget.onSignUpPressed,
                                            child: const Text(
                                              'Đăng ký',
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
    VoidCallback? onIconTap,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        suffixIcon: IconButton(
          onPressed: enabled ? onIconTap : null,
          icon: Icon(icon, size: 20, color: const Color(0xFF98A1B9)),
        ),
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
