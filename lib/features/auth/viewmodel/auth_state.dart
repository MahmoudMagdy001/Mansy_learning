import 'package:equatable/equatable.dart';

/// Represents the user's authentication status throughout the app.
enum AuthStatus {
  /// Initial state — auth check has not yet been performed.
  unknown,

  /// User has logged in with valid credentials.
  authenticated,

  /// User chose "Continue as Guest" without logging in.
  guest,

  /// No persisted session — user must log in or continue as guest.
  unauthenticated,
}

/// Immutable state emitted by [AuthCubit].
class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unknown});

  final AuthStatus status;

  /// Whether the user is fully authenticated (not a guest).
  bool get isLoggedIn => status == AuthStatus.authenticated;

  /// Whether the user entered as a guest.
  bool get isGuest => status == AuthStatus.guest;

  /// Whether the auth check has been completed (no longer unknown).
  bool get isResolved => status != AuthStatus.unknown;

  AuthState copyWith({AuthStatus? status}) =>
      AuthState(status: status ?? this.status);

  @override
  List<Object?> get props => [status];
}
