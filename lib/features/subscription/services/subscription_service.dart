import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionService {
  final _supabase = Supabase.instance.client;

  Future<void> subscribeToCourse(String courseId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _supabase.from('user_courses').insert({
      'user_id': user.id,
      'course_id': courseId,
    });
  }

  Future<bool> isSubscribed(String courseId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final response = await _supabase
        .from('user_courses')
        .select()
        .eq('user_id', user.id)
        .eq('course_id', courseId)
        .maybeSingle();

    return response != null;
  }
}
