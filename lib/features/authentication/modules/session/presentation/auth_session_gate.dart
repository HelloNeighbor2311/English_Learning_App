import 'package:flutter/material.dart';

import 'package:english_learning_app/core/services/authentication_service.dart';
import 'package:english_learning_app/features/authentication/modules/sign_in/presentation/sign_in_page.dart';
import 'package:english_learning_app/features/authentication/modules/sign_up/presentation/sign_up_page.dart';
import 'package:english_learning_app/features/home/presentation/home_page.dart';

class AuthSessionGate extends StatefulWidget {
  const AuthSessionGate({super.key});

  @override
  State<AuthSessionGate> createState() => _AuthSessionGateState();
}

class _AuthSessionGateState extends State<AuthSessionGate> {
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    const Text('Lỗi xác thực'),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => setState(() => _isSignIn = true),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.data != null) {
          return const HomePage();
        }

        final authPage = _isSignIn
            ? SignInPage(
                key: const ValueKey('sign_in_page'),
                onSignUpPressed: () {
                  setState(() => _isSignIn = false);
                },
              )
            : SignUpPage(
                key: const ValueKey('sign_up_page'),
                onSignInPressed: () {
                  setState(() => _isSignIn = true);
                },
              );

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: authPage,
        );
      },
    );
  }
}
