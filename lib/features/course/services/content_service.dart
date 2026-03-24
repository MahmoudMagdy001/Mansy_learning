import 'package:supabase_flutter/supabase_flutter.dart';
import '../../course/models/file_model.dart';
import '../../course/models/quiz_model.dart';
import '../../course/models/quiz_question_model.dart';
import '../../course/models/video_model.dart';

class ContentService {
  final _supabase = Supabase.instance.client;

  Future<List<VideoModel>> getCourseVideos(String courseId) async {
    final response = await _supabase
        .from('videos')
        .select()
        .eq('course_id', courseId)
        .order('order_index', ascending: true);

    return (response as List).map((e) => VideoModel.fromJson(e)).toList();
  }

  Future<List<FileModel>> getCourseFiles(String courseId) async {
    final response = await _supabase
        .from('files')
        .select()
        .eq('course_id', courseId);

    return (response as List).map((e) => FileModel.fromJson(e)).toList();
  }

  Future<List<QuizModel>> getCourseQuizzes(String courseId) async {
    final response = await _supabase
        .from('quizzes')
        .select('*, quiz_questions(*)')
        .eq('course_id', courseId);

    return (response as List).map((e) => QuizModel.fromJson(e)).toList();
  }

  Future<List<QuizQuestionModel>> getQuizQuestions(String quizId) async {
    final response = await _supabase
        .from('quiz_questions')
        .select()
        .eq('quiz_id', quizId);

    return (response as List)
        .map((e) => QuizQuestionModel.fromJson(e))
        .toList();
  }
}
