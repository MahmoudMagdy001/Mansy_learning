import '../../course/models/course_model.dart';

enum MyCoursesStatus { initial, loading, success, error }

class MyCoursesState {
  const MyCoursesState({
    this.status = MyCoursesStatus.initial,
    this.courses = const [],
    this.message,
  });

  final MyCoursesStatus status;
  final List<CourseModel> courses;
  final String? message;

  MyCoursesState copyWith({
    MyCoursesStatus? status,
    List<CourseModel>? courses,
    String? message,
  }) =>
      MyCoursesState(
        status: status ?? this.status,
        courses: courses ?? this.courses,
        message: message ?? this.message,
      );
}
