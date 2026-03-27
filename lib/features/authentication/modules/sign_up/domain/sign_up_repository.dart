// Feature: authentication | Module: sign_up

import 'user_entity.dart';

abstract class SignUpRepository {
  /// Sign up with email and password, then save user profile to Firestore
  /// Returns the created UserEntity
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String level,
  });
}
