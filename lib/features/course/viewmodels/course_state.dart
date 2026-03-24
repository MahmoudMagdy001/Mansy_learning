import 'package:equatable/equatable.dart';
import '../models/course_model.dart';

import '../models/video_model.dart';
import '../models/file_model.dart';
import '../models/quiz_model.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseSuccess extends CourseState {
  final CourseModel course;
  final List<VideoModel> videos;
  final List<FileModel> files;
  final List<QuizModel> quizzes;

  const CourseSuccess({
    required this.course,
    required this.videos,
    required this.files,
    required this.quizzes,
  });

  @override
  List<Object?> get props => [course, videos, files, quizzes];
}

class CourseError extends CourseState {
  final String message;

  const CourseError(this.message);

  @override
  List<Object?> get props => [message];
}
class MyCoursesSuccess extends CourseState {
  final List<CourseModel> courses;

  const MyCoursesSuccess({required this.courses});

  @override
  List<Object?> get props => [courses];
}
