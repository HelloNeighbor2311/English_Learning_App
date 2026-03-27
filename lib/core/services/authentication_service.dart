import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  AuthenticationService._();

  static final AuthenticationService instance = AuthenticationService._();

  static const String _googleWebClientIdFromEnv = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );
  static const String _googleWebClientIdDefault =
      '338474234583-ii6s8ol5j5tuviu50n7i75qelttg8jb9.apps.googleusercontent.com';
  static final String _googleWebClientId = _googleWebClientIdFromEnv.isNotEmpty
      ? _googleWebClientIdFromEnv
      : _googleWebClientIdDefault;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn? _googleSignIn;

  GoogleSignIn _getGoogleSignIn() {
    _googleSignIn ??= _googleWebClientId.isNotEmpty
        ? GoogleSignIn(clientId: _googleWebClientId)
        : GoogleSignIn();
    return _googleSignIn!;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FormatException(_mapSignInError(e));
    }
  }

  String _mapSignInError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Tên đăng nhập hoặc mật khẩu không đúng.';
      case 'invalid-email':
        return 'Email không hợp lệ. Vui lòng kiểm tra lại.';
      case 'user-disabled':
        return 'Tài khoản đã bị vô hiệu hóa. Vui lòng liên hệ hỗ trợ.';
      case 'too-many-requests':
        return 'Bạn thử sai quá nhiều lần. Vui lòng thử lại sau ít phút.';
      case 'network-request-failed':
        return 'Lỗi mạng. Vui lòng kiểm tra kết nối và thử lại.';
      default:
        return 'Đăng nhập thất bại. Vui lòng thử lại.';
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb && _googleWebClientId.isEmpty) {
      throw Exception('Google Sign-In web chưa được cấu hình client ID.');
    }

    final GoogleSignInAccount? googleUser = await _getGoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in cancelled');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  // Sign out
  Future<void> signOut() async {
    final futures = <Future<void>>[_firebaseAuth.signOut()];
    if (_googleSignIn != null) {
      futures.add(_googleSignIn!.signOut());
    }
    await Future.wait(futures);
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Check if user email verified
  Future<void> sendEmailVerification() async {
    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.currentUser!.sendEmailVerification();
    }
  }
}
