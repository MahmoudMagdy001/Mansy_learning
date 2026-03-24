import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart';

/// Manages authentication state and persists it via [SharedPreferences].
///
/// Data flow:
///   View → AuthCubit → SharedPreferences
///                ↓
///            AuthState
///                ↓
///              View
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  /// Key used to persist the auth status in SharedPreferences.
  static const _statusKey = 'auth_status';

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Reads persisted auth status and emits the resolved state.
  /// Called once from the splash screen after the intro animation.
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.get(_statusKey)?.toString();

    final status = switch (stored) {
      'authenticated' => AuthStatus.authenticated,
      'guest' => AuthStatus.guest,
      _ => AuthStatus.unauthenticated,
    };

    emit(AuthState(status: status));
  }

  /// Sets the user as fully authenticated and persists.
  Future<void> login() async {
    await _persist(AuthStatus.authenticated);
    emit(const AuthState(status: AuthStatus.authenticated));
  }

  /// Sets the user as a guest and persists.
  Future<void> continueAsGuest() async {
    await _persist(AuthStatus.guest);
    emit(const AuthState(status: AuthStatus.guest));
  }

  /// Clears the persisted session and sets the user as unauthenticated.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statusKey);
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _persist(AuthStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statusKey, status.name);
  }
}
