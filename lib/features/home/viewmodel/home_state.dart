import '../../course/models/course_model.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.message,
    this.courses = const [],
  });

  final HomeStatus status;
  final String? message;
  final List<CourseModel> courses;

  HomeState copyWith({
    HomeStatus? status,
    String? message,
    List<CourseModel>? courses,
  }) =>
      HomeState(
        status: status ?? this.status,
        message: message ?? this.message,
        courses: courses ?? this.courses,
      );
}
