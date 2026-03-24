import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileService {
  final _supabase = Supabase.instance.client;

  Future<ProfileModel> getProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    
    final user = _supabase.auth.currentUser;
    
    final profile = ProfileModel.fromJson(response);
    return profile.copyWith(
      email: user?.email ?? '',
      phone: user?.phone ?? '',
    );
  }

  Future<void> updateProfile(ProfileModel profile) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User is not logged in');
    }

    await _supabase.from('profiles').update({
      'full_name': profile.fullName,
      'avatar_url': profile.avatarUrl,
    }).eq('id', userId);
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _supabase.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  }
}

