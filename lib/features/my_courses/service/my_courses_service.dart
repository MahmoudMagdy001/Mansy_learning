import 'package:supabase_flutter/supabase_flutter.dart';
import '../../course/models/course_model.dart';

class MyCoursesService {
  final _supabase = Supabase.instance.client;

  Future<List<CourseModel>> getMyCourses() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('user_courses')
        .select('course:courses(*)')
        .eq('user_id', user.id);

    return (response as List)
        .map((json) => CourseModel.fromJson(json['course'] as Map<String, dynamic>))
        .toList();
  }
}
