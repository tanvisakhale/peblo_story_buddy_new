import 'package:flutter/material.dart';

class AppConstants {
  // ── New Cute & Kids Attracting Palette ──────────────────────────────────────
  static const Color deepPurple = Color(0xFF6C5CE7); // Soft Lavender-Purple
  static const Color midPurple  = Color(0xFF8E44AD);
  static const Color softWhite  = Color(0xFFFFFFFF);
  static const Color yellow     = Color(0xFFFFD93D); // Brighter Sunny Yellow
  static const Color coral      = Color(0xFFFF6B6B); // Soft Watermelon
  static const Color mint       = Color(0xFF6BCB77); // Fresh Grass Green
  static const Color skyBlue    = Color(0xFF4D96FF); // Clear Sky Blue
  static const Color pinkHeart  = Color(0xFFFFADC7); // Soft Heart Pink
  static const Color darkGrey   = Color(0xFF4A4A4A); // For robot joints/visor
  static const Color cardBg     = Color(0xFFFFFFFF); // Clean White for contrast

  static const Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF5FD), // Very Light Pink
      Color(0xFFE8F9FD), // Very Light Blue
    ],
  );

  static const Gradient buddyGlow = RadialGradient(
    colors: [
      Color(0x44FFD93D),
      Colors.transparent,
    ],
  );

  // ── Story Content ─────────────────────────────────────────────────────────
  static const String kStoryText =
      "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";

  // ── Quiz Data ──────────────────────────────────────────────────────────────
  static const Map<String, dynamic> kQuizJson = {
    "question": "What colour was Pip the Robot's lost gear?",
    "options": ["Red", "Green", "Blue", "Yellow"],
    "answer": "Blue"
  };

  // ── Animation Timings ─────────────────────────────────────────────────────
  static const Duration revealDuration = Duration(milliseconds: 600);
  static const Duration shakeDuration  = Duration(milliseconds: 400);
}
