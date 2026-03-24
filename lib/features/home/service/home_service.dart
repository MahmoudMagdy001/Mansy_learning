import 'package:supabase_flutter/supabase_flutter.dart';
import '../../course/models/course_model.dart';

class HomeService {
  final _supabase = Supabase.instance.client;

  Future<List<CourseModel>> getCourses() async {
    final response = await _supabase.from('courses').select();
    return (response as List).map((json) => CourseModel.fromJson(json)).toList();
  }
}
