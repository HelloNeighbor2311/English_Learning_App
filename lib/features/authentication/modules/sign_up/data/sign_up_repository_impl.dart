// Feature: authentication | Module: sign_up

import 'package:english_learning_app/core/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    } on FirebaseAuthException catch (e) {
      throw FormatException(_mapFirebaseAuthError(e));
    } on FormatException {
      rethrow;
    } catch (e) {
      throw FormatException('Đăng ký thất bại. Vui lòng thử lại sau. ($e)');
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return 'Đăng ký bằng Email/Mật khẩu chưa được bật trong Firebase Console. '
            'Vào Authentication > Sign-in method > bật Email/Password.';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng. Vui lòng dùng email khác hoặc đăng nhập.';
      case 'invalid-email':
        return 'Email không hợp lệ. Vui lòng kiểm tra lại.';
      case 'weak-password':
        return 'Mật khẩu quá yếu. Vui lòng dùng ít nhất 6 ký tự.';
      case 'network-request-failed':
        return 'Lỗi mạng. Vui lòng kiểm tra kết nối internet và thử lại.';
      default:
        return 'Đăng ký thất bại (${e.code}). Vui lòng thử lại.';
    }
  }
}
