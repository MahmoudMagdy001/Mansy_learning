import '../../course/models/course_model.dart';

abstract class HomeRepository {
  Future<List<CourseModel>> getCourses();
}
