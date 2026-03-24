class QuizQuestionModel {
  final String id;
  final String? quizId;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final DateTime createdAt;

  QuizQuestionModel({
    required this.id,
    this.quizId,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.createdAt,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String?,
      questionText: json['question_text'] as String,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correct_option_index'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'question_text': questionText,
      'options': options,
      'correct_option_index': correctOptionIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
