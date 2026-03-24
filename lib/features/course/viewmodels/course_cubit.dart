import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/course_repository.dart';
import '../repositories/content_repository.dart';
import 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository courseRepository;
  final ContentRepository contentRepository;

  CourseCubit({
    required this.courseRepository,
    required this.contentRepository,
  }) : super(CourseInitial());

  Future<void> getCourseDetails(String courseId) async {
    emit(CourseLoading());
    try {
      final course = await courseRepository.getCourseDetails(courseId);
      final videos = await contentRepository.getCourseVideos(courseId);
      final files = await contentRepository.getCourseFiles(courseId);
      final quizzes = await contentRepository.getCourseQuizzes(courseId);

      emit(CourseSuccess(
        course: course,
        videos: videos,
        files: files,
        quizzes: quizzes,
      ));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> getEnrolledCourses() async {
    emit(CourseLoading());
    try {
      final courses = await courseRepository.getEnrolledCourses();
      emit(MyCoursesSuccess(courses: courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }
}
