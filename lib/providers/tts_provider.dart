import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../utils/app_constants.dart';

enum TtsStatus { idle, loading, speaking, finished, error }

class TtsState {
  final TtsStatus status;
  final String? errorMessage;
  final int currentSentenceIndex;

  TtsState({
    this.status = TtsStatus.idle,
    this.errorMessage,
    this.currentSentenceIndex = -1,
  });

  TtsState copyWith({
    TtsStatus? status,
    String? errorMessage,
    int? currentSentenceIndex,
  }) {
    return TtsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentSentenceIndex: currentSentenceIndex ?? this.currentSentenceIndex,
    );
  }
}

final ttsProvider = StateNotifierProvider<TtsNotifier, TtsState>((ref) {
  return TtsNotifier();
});

class TtsNotifier extends StateNotifier<TtsState> {
  final FlutterTts _tts = FlutterTts();
  final List<String> _sentences = AppConstants.kStoryText.split(RegExp(r'(?<=[.!?])\s+'));

  TtsNotifier() : super(TtsState()) {
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-IN');
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.2);

    // Cache voice list (requirement)
    await _tts.getVoices;

    _tts.setStartHandler(() {
      state = state.copyWith(status: TtsStatus.speaking);
    });

    _tts.setCompletionHandler(() {
      state = state.copyWith(status: TtsStatus.finished, currentSentenceIndex: -1);
    });

    _tts.setErrorHandler((msg) {
      state = state.copyWith(status: TtsStatus.error, errorMessage: "Oops, I lost my voice! Tap to try again");
    });

    _tts.setProgressHandler((String text, int start, int end, String word) {
      // Logic for sentence highlighting based on character offset
      int accumulatedLength = 0;
      for (int i = 0; i < _sentences.length; i++) {
        accumulatedLength += _sentences[i].length + 1; // +1 for the space split
        if (start < accumulatedLength) {
          if (state.currentSentenceIndex != i) {
            state = state.copyWith(currentSentenceIndex: i);
          }
          break;
        }
      }
    });
  }

  Future<void> speak() async {
    state = state.copyWith(status: TtsStatus.loading);
    try {
      await _tts.stop();
      await _tts.speak(AppConstants.kStoryText);
    } catch (e) {
      state = state.copyWith(status: TtsStatus.error, errorMessage: "Oops, I lost my voice! Tap to try again");
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
