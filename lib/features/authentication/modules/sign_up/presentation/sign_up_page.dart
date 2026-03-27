import 'package:flutter/material.dart';
import 'package:english_learning_app/core/services/authentication_service.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onSignInPressed;

  const SignUpPage({super.key, required this.onSignInPressed});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedLevel = 'Beginner';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Mat khau khong khop');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthenticationService.instance.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      setState(() {
        _errorMessage = null;
        _isLoading = false;
      });
      // TODO: Save user profile to Firestore with selected level
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Dang ky that bai: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dang Ky')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Mat khau',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Xac nhan mat khau',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              const Text('Chon trinh do tieng Anh:'),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(label: Text('Beginner'), value: 'Beginner'),
                  ButtonSegment(
                    label: Text('Intermediate'),
                    value: 'Intermediate',
                  ),
                  ButtonSegment(label: Text('Advanced'), value: 'Advanced'),
                ],
                selected: {_selectedLevel},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() => _selectedLevel = newSelection.first);
                },
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              FilledButton(
                onPressed: _isLoading ? null : _signUp,
                child: Text(_isLoading ? 'Dang xu ly...' : 'Dang Ky'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : widget.onSignInPressed,
                child: const Text('Da co tai khoan? Dang nhap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
