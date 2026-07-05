import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_constants.dart';
import 'shake_widget.dart';

class QuizSection extends ConsumerWidget {
  const QuizSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              quizState.question.question,
              style: GoogleFonts.fredoka(
                color: AppConstants.deepPurple,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Data-driven renderer: iterating over options list (requirement)
          ...List.generate(
            quizState.question.options.length,
            (index) => _OptionTile(index: index),
          ),
          if (quizState.isCorrect) _SuccessBanner(),
        ],
      ),
    );
  }
}

class _OptionTile extends ConsumerWidget {
  final int index;
  const _OptionTile({required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Select specific state to avoid rebuilding all tiles (requirement)
    final optionText = ref.watch(quizProvider.select((s) => s.question.options[index]));
    final isSelected = ref.watch(quizProvider.select((s) => s.selectedIndex == index));
    final isCorrect = ref.watch(quizProvider.select((s) => s.isCorrect));

    final bool showWrong = isSelected && !isCorrect;
    final bool showCorrect = isSelected && isCorrect;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: ShakeWidget(
        shouldShake: showWrong,
        child: InkWell(
          onTap: () => ref.read(quizProvider.notifier).selectOption(index),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: showCorrect 
                  ? AppConstants.mint 
                  : showWrong 
                      ? AppConstants.coral 
                      : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.deepPurple.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
              border: Border.all(
                color: showCorrect 
                    ? Colors.white 
                    : showWrong 
                        ? Colors.white.withValues(alpha: 0.5) 
                        : AppConstants.skyBlue.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (showCorrect || showWrong) 
                        ? Colors.white.withValues(alpha: 0.3)
                        : AppConstants.skyBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index),
                      style: GoogleFonts.fredoka(
                        color: (showCorrect || showWrong) ? Colors.white : AppConstants.skyBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    optionText,
                    style: GoogleFonts.nunito(
                      color: (showCorrect || showWrong) ? Colors.white : AppConstants.deepPurple,
                      fontSize: 18,
                      fontWeight: (showCorrect || showWrong) ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
                if (showCorrect)
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.mint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppConstants.mint.withValues(alpha: 0.5), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Text("🎉", style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Yay! You did it!",
                  style: GoogleFonts.fredoka(
                    color: AppConstants.mint,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "You are a superstar! ⭐",
                  style: GoogleFonts.nunito(
                    color: AppConstants.mint.withValues(alpha: 0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
