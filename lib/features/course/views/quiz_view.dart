import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_typography.dart';
import '../models/quiz_model.dart';
import '../viewmodels/quiz_cubit.dart';
import '../viewmodels/quiz_state.dart';

class QuizView extends StatelessWidget {
  final QuizModel quiz;

  const QuizView({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizCubit(getIt())..loadQuiz(quiz),
      child: const QuizScreen(),
    );
  }
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<QuizCubit, QuizState>(
          builder: (context, state) {
            if (state is QuizInProgress) {
              return Text(state.quiz.title);
            }
            return const Text('الاختبار');
          },
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QuizError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(state.message, style: AppTypography.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('رجوع'),
                  ),
                ],
              ),
            );
          }

          if (state is QuizInProgress) {
            final question = state.questions[state.currentQuestionIndex];
            final totalQuestions = state.questions.length;
            final currentIndex = state.currentQuestionIndex;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: (currentIndex + 1) / totalQuestions,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'السؤال ${currentIndex + 1} من $totalQuestions',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question.questionText,
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView.builder(
                      itemCount: question.options.length,
                      itemBuilder: (context, index) {
                        final option = question.options[index];
                        final isSelected =
                            state.selectedOptions[currentIndex] == index;

                        return GestureDetector(
                          onTap: () =>
                              context.read<QuizCubit>().selectOption(index),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey.shade400,
                                    ),
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: AppTypography.bodyLarge.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentIndex > 0)
                        OutlinedButton(
                          onPressed: () =>
                              context.read<QuizCubit>().previousQuestion(),
                          child: const Text('السابق'),
                        )
                      else
                        const SizedBox.shrink(),
                      ElevatedButton(
                        onPressed: state.selectedOptions[currentIndex] != null
                            ? () => context.read<QuizCubit>().nextQuestion()
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 48),
                        ),
                        child: Text(
                          currentIndex == totalQuestions - 1
                              ? 'إنهاء'
                              : 'التالي',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          if (state is QuizCompleted) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      state.isPassed ? Icons.check_circle : Icons.cancel,
                      color: state.isPassed ? Colors.green : Colors.red,
                      size: 100,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      state.isPassed
                          ? 'تهانينا! لقد اجتزت الاختبار'
                          : 'للأسف، لم تجتز الاختبار',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'درجتك: ${state.score}%',
                      style: AppTypography.titleLarge,
                    ),
                    Text(
                      'درجة النجاح: ${state.quiz.passingScore}%',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('العودة للدورة'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
