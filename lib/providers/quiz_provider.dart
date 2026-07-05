import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_question.dart';
import '../utils/app_constants.dart';

class QuizState {
  final QuizQuestion question;
  final int? selectedIndex;
  final bool isCorrect;
  final int attemptCount;

  QuizState({
    required this.question,
    this.selectedIndex,
    this.isCorrect = false,
    this.attemptCount = 0,
  });

  QuizState copyWith({
    int? selectedIndex,
    bool? isCorrect,
    int? attemptCount,
  }) {
    return QuizState(
      question: question,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      attemptCount: attemptCount ?? this.attemptCount,
    );
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  final question = QuizQuestion.fromJson(AppConstants.kQuizJson);
  return QuizNotifier(question);
});

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier(QuizQuestion question) : super(QuizState(question: question));

  void selectOption(int index) {
    if (state.isCorrect) return;

    final isCorrect = state.question.options[index] == state.question.answer;
    
    if (isCorrect) {
      HapticFeedback.heavyImpact();
      state = state.copyWith(
        selectedIndex: index,
        isCorrect: true,
        attemptCount: state.attemptCount + 1,
      );
    } else {
      HapticFeedback.mediumImpact();
      state = state.copyWith(
        selectedIndex: index,
        isCorrect: false,
        attemptCount: state.attemptCount + 1,
      );
      // Reset selection after shake duration so it can be re-tapped
      Future.delayed(AppConstants.shakeDuration, () {
        if (!state.isCorrect) {
          state = state.copyWith(selectedIndex: null);
        }
      });
    }
  }
}
