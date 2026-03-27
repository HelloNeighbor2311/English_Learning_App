// Feature: authentication | Module: sign_up

import 'sign_up_repository.dart';
import 'user_entity.dart';

class SignUpUseCase {
  final SignUpRepository repository;

  SignUpUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Validation
    if (email.trim().isEmpty) {
      throw const FormatException('Email không được để trống');
    }

    if (password.isEmpty) {
      throw const FormatException('Mật khẩu không được để trống');
    }

    if (password != confirmPassword) {
      throw const FormatException('Mật khẩu không khớp');
    }

    if (password.length < 6) {
      throw const FormatException('Mật khẩu phải có ít nhất 6 ký tự');
    }

    // Call repository to sign up
    return await repository.signUpWithEmail(
      email: email.trim(),
      password: password,
    );
  }
}
