import 'package:equatable/equatable.dart';
import '../models/quiz_model.dart';
import '../models/quiz_question_model.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizInProgress extends QuizState {
  final QuizModel quiz;
  final List<QuizQuestionModel> questions;
  final int currentQuestionIndex;
  final Map<int, int> selectedOptions; // questionIndex -> optionIndex

  const QuizInProgress({
    required this.quiz,
    required this.questions,
    required this.currentQuestionIndex,
    required this.selectedOptions,
  });

  @override
  List<Object?> get props => [quiz, questions, currentQuestionIndex, selectedOptions];

  QuizInProgress copyWith({
    int? currentQuestionIndex,
    Map<int, int>? selectedOptions,
  }) {
    return QuizInProgress(
      quiz: quiz,
      questions: questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }
}

class QuizCompleted extends QuizState {
  final QuizModel quiz;
  final List<QuizQuestionModel> questions;
  final Map<int, int> selectedOptions;
  final int score;
  final bool isPassed;

  const QuizCompleted({
    required this.quiz,
    required this.questions,
    required this.selectedOptions,
    required this.score,
    required this.isPassed,
  });

  @override
  List<Object?> get props => [quiz, questions, selectedOptions, score, isPassed];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}
