# 🤖 Peblo Story Buddy 

A magical, interactive story-telling and quiz app built for **Peblo**, designed to engage children in India with a cute AI companion named **Pip**.

## ✨ Design Philosophy: "Cute & Kids-First"
The app uses a **Cute & Pastel aesthetic** designed to be approachable and non-intimidating for children:
- **Pip the Robot**: A custom-drawn Flutter widget (no heavy assets) featuring heart-shaped antennas, earmuffs, and a black visor with expressive glowing eyes.
- **Soft Palette**: Uses Lavender Purple, Watermelon Coral, and Mint Green for a playful yet premium feel.
- **Cloud UI**: All cards use extreme rounded corners (32dp) and airy shadows to look like floating clouds.
- **Elastic Animations**: Every transition uses bouncy, spring-based curves to feel tactile and "toy-like."

## 🛠 Framework Choice & Architecture
- **Framework**: **Flutter (3.2x)** - Chosen for its ability to deliver consistent 60FPS animations and high-quality custom painting (used for the Robot and Starfield) across mid-range Android devices.
- **State Management**: **Riverpod (2.x)** - Used for its compile-time safety and modularity. 
  - `ttsProvider`: Manages the state of the story narration (idle/loading/speaking/error).
  - `quizProvider`: Handles the logic for option selection, shake animations on wrong answers, and the confetti trigger on success.

## 🚀 Performance & Low-End Device Optimization
Targeting devices with **~3GB RAM**, the following optimizations were implemented:
1. **Repaint Boundaries**: Critical sections like the `RobotBuddy` (bobbing animation) and `Starfield` (twinkling) are wrapped in `RepaintBoundary` to prevent the entire screen from repainting every frame.
2. **Capped Particle Systems**: The `confetti` package is configured with a strict limit of 50 particles to avoid GPU spikes.
3. **Asset-Free Robot**: Pip the Robot is built entirely using `CustomPainter` and `Container` widgets. This avoids the memory overhead of loading large PNGs or heavy Lottie files.
4. **Narrow Rebuild Scoping**: Used Riverpod's `ref.select()` to ensure only the specific sentence being narrated highlights, rather than rebuilding the entire Story Card.

## 📖 Feature Implementation Details

### Audio → Quiz Transition
The app tracks the `TtsStatus`. Once the `flutter_tts` completion handler fires, the state switches to `finished`. The `HomeScreen` listens for this change and triggers a **600ms delayed** `AnimatedSwitcher` to transition from the story text to the quiz question.

### Data-Driven Quiz
The quiz renderer is **fully dynamic**:
- It consumes a JSON object and maps it to a `QuizQuestion` model.
- The UI iterates over the `options` list, meaning it can handle 2, 3, 4, or 5+ options without a single line of code change in the widget tree.

### Error & Caching
- **Voice Caching**: The system pre-loads and caches the available TTS voice list on the first provider initialization.
- **Graceful Error Handling**: If TTS fails (e.g., missing engine or network), the app shows a friendly "Oops, I lost my voice!" retry state instead of hanging.

## 🧠 AI Usage & Judgment
During development, an AI suggested using a **Lottie animation** for the Robot's heart pulse.
- **Rejected Suggestion**: I rejected this and implemented the robot using standard Flutter `AnimatedContainer` and `CustomPainter`.
- **Reasoning**: Lottie files, while beautiful, require a heavy runtime and extra memory to parse JSON into vectors every frame. For a 3GB RAM device, keeping the entire character "native" to the Flutter widget tree ensures better frame stability and a smaller APK size.

## 📂 Project Structure
```text
lib/
├── models/      # QuizModel (JSON Parsing)
├── providers/   # Riverpod Controllers (TTS, Quiz)
├── utils/       # AppConstants (Theme, Story Text)
├── widgets/     # RobotBuddy, ShakeWidget, QuizSection, etc.
└── screens/     # HomeScreen (The single-screen hub)
```
