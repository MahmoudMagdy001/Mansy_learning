import '../../course/models/course_model.dart';
import 'home_repository.dart';
import '../service/home_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this.service);
  final HomeService service;

  @override
  Future<List<CourseModel>> getCourses() => service.getCourses();
}
