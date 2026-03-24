import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course_model.dart';

class CourseService {
  final _supabase = Supabase.instance.client;

  Future<CourseModel> getCourseDetails(String courseId) async {
    final response = await _supabase
        .from('courses')
        .select()
        .eq('id', courseId)
        .single();
    
    return CourseModel.fromJson(response);
  }

  Future<List<CourseModel>> getEnrolledCourses() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    // Fetch enrolled course IDs
    final enrollments = await _supabase
        .from('user_courses')
        .select('course_id')
        .eq('user_id', userId);

    if (enrollments.isEmpty) return [];

    final List<dynamic> courseIds = enrollments.map((e) => e['course_id']).toList();

    // Fetch courses where ID in courseIds
    final coursesResponse = await _supabase
        .from('courses')
        .select()
        .inFilter('id', courseIds);

    return (coursesResponse as List)
        .map((data) => CourseModel.fromJson(data))
        .toList();
  }
}
