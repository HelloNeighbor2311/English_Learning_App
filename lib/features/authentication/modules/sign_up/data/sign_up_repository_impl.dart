// Feature: authentication | Module: sign_up

import 'package:english_learning_app/core/services/authentication_service.dart';
import '../domain/sign_up_repository.dart';
import '../domain/user_entity.dart';
import 'user_model.dart';
import 'user_remote_datasource.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  final AuthenticationService _authService;
  final UserRemoteDataSource _userDataSource;

  SignUpRepositoryImpl(this._authService, this._userDataSource);

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String level,
  }) async {
    try {
      // Step 1: Create user in Firebase Auth
      final userCredential = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('Không thể lấy UID từ Firebase');
      }

      // Step 2: Create UserModel
      final user = UserModel(
        uid: uid,
        email: email,
        level: level,
        createdAt: DateTime.now(),
        emailVerified: false,
      );

      // Step 3: Save user profile to Firestore
      await _userDataSource.saveUserProfile(user);

      // Step 4: Send email verification
      try {
        await _authService.sendEmailVerification();
      } catch (e) {
        // Log this but don't fail the sign up
        print('Failed to send verification email: $e');
      }

      return user;
    } on FormatException {
      rethrow;
    } catch (e) {
      throw Exception('Đăng ký thất bại: $e');
    }
  }
}
