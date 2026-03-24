enum LoginStatus { initial, loading, success, error }

class LoginState {
  const LoginState({this.status = LoginStatus.initial, this.message});
  final LoginStatus status;
  final String? message;

  LoginState copyWith({LoginStatus? status, String? message}) => LoginState(
    status: status ?? this.status,
    message: message ?? this.message,
  );
}
