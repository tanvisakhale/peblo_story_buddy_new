import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/tts_provider.dart';
import '../utils/app_constants.dart';

class StoryCard extends ConsumerWidget {
  const StoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState = ref.watch(ttsProvider);
    final sentences = AppConstants.kStoryText.split(RegExp(r'(?<=[.!?])\s+'));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: _getStatusColor(ttsState.status).withValues(alpha: 0.2),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.deepPurple.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Story Text with sentence highlighting
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(sentences.length, (index) {
                final isCurrent = ttsState.currentSentenceIndex == index;
                return _AnimatedSentence(
                  text: sentences[index],
                  isHighlighted: isCurrent,
                );
              }),
            ),
            const SizedBox(height: 24),
            
            if (ttsState.status == TtsStatus.error)
              _ErrorDisplay(message: ttsState.errorMessage!),

            _NarrationButton(status: ttsState.status),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TtsStatus status) {
    switch (status) {
      case TtsStatus.speaking: return AppConstants.mint;
      case TtsStatus.error: return AppConstants.coral;
      case TtsStatus.loading: return AppConstants.yellow;
      default: return AppConstants.skyBlue;
    }
  }
}

class _AnimatedSentence extends StatelessWidget {
  final String text;
  final bool isHighlighted;

  const _AnimatedSentence({required this.text, required this.isHighlighted});

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: GoogleFonts.nunito(
        fontSize: 18,
        height: 1.6,
        fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
        color: isHighlighted ? AppConstants.skyBlue : AppConstants.deepPurple.withValues(alpha: 0.7),
      ),
      child: Text(text),
    );
  }
}

class _NarrationButton extends ConsumerWidget {
  final TtsStatus status;
  const _NarrationButton({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = status == TtsStatus.loading;
    final bool isSpeaking = status == TtsStatus.speaking;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (isLoading || isSpeaking) 
          ? null 
          : () => ref.read(ttsProvider.notifier).speak(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.yellow,
          foregroundColor: AppConstants.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppConstants.deepPurple),
              )
            else
              Icon(isSpeaking ? Icons.volume_up_rounded : Icons.play_arrow_rounded),
            const SizedBox(width: 10),
            Text(
              isLoading ? 'Preparing...' : isSpeaking ? 'Listening...' : 'Read Me a Story',
              style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorDisplay extends StatelessWidget {
  final String message;
  const _ErrorDisplay({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        message,
        style: GoogleFonts.nunito(color: AppConstants.coral, fontWeight: FontWeight.bold),
      ),
    );
  }
}
