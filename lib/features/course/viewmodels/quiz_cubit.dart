import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/course_repository.dart';
import '../models/quiz_model.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final CourseRepository repository;

  QuizCubit(this.repository) : super(QuizInitial());

  Future<void> loadQuiz(QuizModel quiz) async {
    emit(QuizLoading());
    try {
      if (quiz.questions != null && quiz.questions!.isNotEmpty) {
        emit(QuizInProgress(
          quiz: quiz,
          questions: quiz.questions!,
          currentQuestionIndex: 0,
          selectedOptions: {},
        ));
        return;
      }

      final questions = await repository.getQuizQuestions(quiz.id);
      if (questions.isEmpty) {
        emit(const QuizError('لا توجد أسئلة لهذا الكويز'));
        return;
      }

      emit(QuizInProgress(
        quiz: quiz,
        questions: questions,
        currentQuestionIndex: 0,
        selectedOptions: {},
      ));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  void selectOption(int optionIndex) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final newSelectedOptions = Map<int, int>.from(currentState.selectedOptions);
      newSelectedOptions[currentState.currentQuestionIndex] = optionIndex;

      emit(currentState.copyWith(selectedOptions: newSelectedOptions));
    }
  }

  void nextQuestion() {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
        emit(currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
        ));
      } else {
        submitQuiz();
      }
    }
  }

  void previousQuestion() {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      if (currentState.currentQuestionIndex > 0) {
        emit(currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex - 1,
        ));
      }
    }
  }

  void submitQuiz() {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      
      int correctAnswers = 0;
      for (int i = 0; i < currentState.questions.length; i++) {
        if (currentState.selectedOptions[i] == currentState.questions[i].correctOptionIndex) {
          correctAnswers++;
        }
      }

      final score = (correctAnswers / currentState.questions.length * 100).round();
      final isPassed = score >= currentState.quiz.passingScore;

      emit(QuizCompleted(
        quiz: currentState.quiz,
        questions: currentState.questions,
        selectedOptions: currentState.selectedOptions,
        score: score,
        isPassed: isPassed,
      ));
    }
  }
}
