import '../../course/models/file_model.dart';
import '../../course/models/quiz_model.dart';
import '../../course/models/video_model.dart';
import 'package:e_learning/features/course/services/content_service.dart';

abstract class ContentRepository {
  Future<List<VideoModel>> getCourseVideos(String courseId);
  Future<List<FileModel>> getCourseFiles(String courseId);
  Future<List<QuizModel>> getCourseQuizzes(String courseId);
}

class ContentRepositoryImpl implements ContentRepository {
  final ContentService service;

  ContentRepositoryImpl(this.service);

  @override
  Future<List<VideoModel>> getCourseVideos(String courseId) async {
    return await service.getCourseVideos(courseId);
  }

  @override
  Future<List<FileModel>> getCourseFiles(String courseId) async {
    return await service.getCourseFiles(courseId);
  }

  @override
  Future<List<QuizModel>> getCourseQuizzes(String courseId) async {
    return await service.getCourseQuizzes(courseId);
  }
}
