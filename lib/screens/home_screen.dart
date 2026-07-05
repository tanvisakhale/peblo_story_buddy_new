import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/tts_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_constants.dart';
import '../widgets/robot_buddy.dart';
import '../widgets/story_card.dart';
import '../widgets/quiz_section.dart';
import '../widgets/starfield_painter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ConfettiController _confettiCtrl;
  bool _showQuiz = false;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for TTS finish to transition to Quiz
    ref.listen(ttsProvider.select((s) => s.status), (previous, next) {
      if (next == TtsStatus.finished) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) setState(() => _showQuiz = true);
        });
      }
    });

    // Listen for Quiz success to fire confetti
    ref.listen(quizProvider.select((s) => s.isCorrect), (previous, next) {
      if (next) _confettiCtrl.play();
    });

    final ttsStatus = ref.watch(ttsProvider.select((s) => s.status));
    final quizCorrect = ref.watch(quizProvider.select((s) => s.isCorrect));

    BuddyMood buddyMood = BuddyMood.idle;
    if (ttsStatus == TtsStatus.loading) buddyMood = BuddyMood.thinking;
    if (quizCorrect) buddyMood = BuddyMood.happy;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Magical Pastel Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppConstants.backgroundGradient,
              ),
            ),
          ),

          // Background twinkles (Softer stars)
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: StarfieldPainter(
                  starCount: 40,
                  starColor: AppConstants.deepPurple.withValues(alpha: 0.15),
                ),
              ),
            ),
          ),
          
          // Confetti (requirement: capped particles)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiCtrl,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 50,
              colors: const [AppConstants.coral, AppConstants.yellow, AppConstants.mint, AppConstants.skyBlue],
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(),
                  const SizedBox(height: 20),
                  
                  // Robot Buddy
                  RobotBuddy(mood: buddyMood),
                  
                  const SizedBox(height: 30),

                  // Transition logic: animate story away and reveal quiz
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.elasticOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _showQuiz 
                      ? const QuizSection(key: ValueKey('quiz'))
                      : const StoryCard(key: ValueKey('story')),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Story Buddy',
                style: GoogleFonts.fredoka(
                  color: AppConstants.deepPurple,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Let\'s learn together! ✨',
                style: GoogleFonts.nunito(
                  color: AppConstants.deepPurple.withValues(alpha: 0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppConstants.deepPurple.withValues(alpha: 0.1),
                  blurRadius: 10,
                )
              ],
            ),
            child: const Icon(Icons.face_retouching_natural_rounded, color: AppConstants.coral, size: 28),
          ),
        ],
      ),
    );
  }
}
