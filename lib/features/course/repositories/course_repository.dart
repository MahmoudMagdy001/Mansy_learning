import '../models/course_model.dart';
import '../models/quiz_model.dart';
import '../models/quiz_question_model.dart';

abstract class CourseRepository {
  Future<CourseModel> getCourseDetails(String courseId);
  Future<List<CourseModel>> getEnrolledCourses();
  Future<List<QuizModel>> getCourseQuizzes(String courseId);
  Future<List<QuizQuestionModel>> getQuizQuestions(String quizId);
}


