// Feature: authentication | Module: sign_up

class UserEntity {
  final String uid;
  final String email;
  final String level; // Beginner, Intermediate, Advanced
  final DateTime createdAt;
  final bool emailVerified;

  UserEntity({
    required this.uid,
    required this.email,
    required this.level,
    required this.createdAt,
    this.emailVerified = false,
  });
}
