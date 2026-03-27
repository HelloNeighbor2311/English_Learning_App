// Feature: authentication | Module: sign_up

import 'package:english_learning_app/core/services/firestore_service.dart';
import 'user_model.dart';

abstract class UserRemoteDataSource {
  /// Save user profile to Firestore under /users/{uid}
  Future<void> saveUserProfile(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirestoreService _firestoreService;

  UserRemoteDataSourceImpl(this._firestoreService);

  @override
  Future<void> saveUserProfile(UserModel user) async {
    try {
      await _firestoreService.setDocument(
        collectionPath: 'users',
        documentId: user.uid,
        data: user.toJson(),
      );
    } catch (e) {
      throw Exception('Lưu profile thất bại: $e');
    }
  }
}
