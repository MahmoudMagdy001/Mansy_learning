import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService {
  final _supabase = Supabase.instance.client;

  Future<void> login(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login failed: no user returned.');
    }

    debugPrint('Login successful: ${response.user!.id}');
  }
}
