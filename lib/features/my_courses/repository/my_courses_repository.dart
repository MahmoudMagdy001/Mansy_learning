import '../../course/models/course_model.dart';

abstract class MyCoursesRepository {
  Future<List<CourseModel>> getMyCourses();
}
