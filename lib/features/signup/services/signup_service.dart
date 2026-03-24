import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/signup_model.dart';

class SignupService {
  final _supabase = Supabase.instance.client;

  Future<void> signup(SignupModel model) async {
    final response = await _supabase.auth.signUp(
      email: model.email,
      password: model.password,
      data: {
        'full_name': '${model.firstName} ${model.lastName}',
        'role': 'student',
        'phone': model.phone,
      },
    );

    if (response.user == null) {
      throw Exception('Signup failed: no user returned.');
    }

    debugPrint('Signup successful: ${response.user!.id}');
    // The Supabase trigger handles inserting the profile row automatically.
  }
}
