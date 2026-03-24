import '../models/course_model.dart';
import '../models/quiz_model.dart';
import '../models/quiz_question_model.dart';
import '../services/content_service.dart';
import '../services/course_service.dart';
import 'course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseService service;
  final ContentService contentService;

  CourseRepositoryImpl(this.service, this.contentService);

  @override
  Future<CourseModel> getCourseDetails(String courseId) async {
    try {
      return await service.getCourseDetails(courseId);
    } catch (e) {
      throw Exception('Failed to fetch course details: $e');
    }
  }

  @override
  Future<List<CourseModel>> getEnrolledCourses() async {
    try {
      return await service.getEnrolledCourses();
    } catch (e) {
      throw Exception('Failed to fetch enrolled courses: $e');
    }
  }

  @override
  Future<List<QuizModel>> getCourseQuizzes(String courseId) async {
    try {
      return await contentService.getCourseQuizzes(courseId);
    } catch (e) {
      throw Exception('Failed to fetch course quizzes: $e');
    }
  }

  @override
  Future<List<QuizQuestionModel>> getQuizQuestions(String quizId) async {
    try {
      return await contentService.getQuizQuestions(quizId);
    } catch (e) {
      throw Exception('Failed to fetch quiz questions: $e');
    }
  }
}
