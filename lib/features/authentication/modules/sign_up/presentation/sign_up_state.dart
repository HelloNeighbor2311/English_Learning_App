// Feature: authentication | Module: sign_up

enum SignUpStatus { initial, loading, success, failure }

class SignUpState {
  final SignUpStatus status;
  final String? errorMessage;
  final String? successMessage;

  SignUpState({
    this.status = SignUpStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  SignUpState copyWith({
    SignUpStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  bool get isLoading => status == SignUpStatus.loading;
  bool get isSuccess => status == SignUpStatus.success;
  bool get isFailure => status == SignUpStatus.failure;
}
