import '../../course/models/course_model.dart';
import 'my_courses_repository.dart';
import '../service/my_courses_service.dart';

class MyCoursesRepositoryImpl implements MyCoursesRepository {
  MyCoursesRepositoryImpl(this.service);
  final MyCoursesService service;

  @override
  Future<List<CourseModel>> getMyCourses() => service.getMyCourses();
}
