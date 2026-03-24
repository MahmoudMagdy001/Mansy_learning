import '../../course/models/quiz_question_model.dart';

class QuizModel {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int passingScore;
  final DateTime createdAt;
  final List<QuizQuestionModel>? questions;

  QuizModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    this.passingScore = 50,
    required this.createdAt,
    this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      passingScore: json['passing_score'] as int? ?? 50,
      createdAt: DateTime.parse(json['created_at'] as String),
      questions: json['quiz_questions'] != null
          ? (json['quiz_questions'] as List)
              .map((e) => QuizQuestionModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'passing_score': passingScore,
      'created_at': createdAt.toIso8601String(),
      if (questions != null) 'quiz_questions': questions!.map((e) => e.toJson()).toList(),
    };
  }

  QuizModel copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    int? passingScore,
    DateTime? createdAt,
    List<QuizQuestionModel>? questions,
  }) {
    return QuizModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      passingScore: passingScore ?? this.passingScore,
      createdAt: createdAt ?? this.createdAt,
      questions: questions ?? this.questions,
    );
  }
}
