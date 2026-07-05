import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

enum BuddyMood { idle, thinking, happy, sad }

class RobotBuddy extends StatefulWidget {
  final BuddyMood mood;
  final double size;

  const RobotBuddy({
    super.key,
    this.mood = BuddyMood.idle,
    this.size = 200,
  });

  @override
  State<RobotBuddy> createState() => _RobotBuddyState();
}

class _RobotBuddyState extends State<RobotBuddy> with SingleTickerProviderStateMixin {
  late AnimationController _bobbingCtrl;

  @override
  void initState() {
    super.initState();
    _bobbingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bobbingCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _bobbingCtrl,
        builder: (context, child) {
          final double offset = 10 * sin(_bobbingCtrl.value * pi * 2);
          return Transform.translate(
            offset: Offset(0, offset),
            child: child,
          );
        },
        child: SizedBox(
          width: widget.size,
          height: widget.size * 1.2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Shadow/Glow at bottom
              Positioned(
                bottom: 10,
                child: Container(
                  width: widget.size * 0.5,
                  height: 15,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),

              // Legs
              Positioned(
                bottom: widget.size * 0.1,
                left: widget.size * 0.32,
                child: _buildLeg(),
              ),
              Positioned(
                bottom: widget.size * 0.1,
                right: widget.size * 0.32,
                child: _buildLeg(),
              ),

              // Arms
              Positioned(
                top: widget.size * 0.65,
                left: widget.size * 0.15,
                child: _buildArm(isLeft: true),
              ),
              Positioned(
                top: widget.size * 0.65,
                right: widget.size * 0.15,
                child: _buildArm(isLeft: false),
              ),

              // Body
              Positioned(
                top: widget.size * 0.55,
                child: _buildBody(),
              ),

              // Head
              Positioned(
                top: widget.size * 0.1,
                child: _buildHead(),
              ),

              // Antenna
              Positioned(
                top: 0,
                child: _buildAntenna(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHead() {
    return SizedBox(
      width: widget.size * 0.75,
      height: widget.size * 0.6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ear Muffins (Sides)
          Positioned(left: 0, child: _buildEar(isLeft: true)),
          Positioned(right: 0, child: _buildEar(isLeft: false)),

          // Main White Head
          Container(
            width: widget.size * 0.65,
            height: widget.size * 0.55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.size * 0.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),

          // Visor (Black Screen)
          Container(
            width: widget.size * 0.52,
            height: widget.size * 0.4,
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D2D),
              borderRadius: BorderRadius.circular(widget.size * 0.18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildVisorEye(),
                    const SizedBox(width: 25),
                    _buildVisorEye(),
                  ],
                ),
                const SizedBox(height: 8),
                _buildVisorMouth(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisorEye() {
    Color eyeColor = widget.mood == BuddyMood.thinking ? AppConstants.yellow : const Color(0xFFFFB5CF);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 14,
      height: widget.mood == BuddyMood.happy ? 6 : 22,
      decoration: BoxDecoration(
        color: eyeColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: eyeColor.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildVisorMouth() {
    return CustomPaint(
      size: const Size(18, 10),
      painter: _VisorMouthPainter(mood: widget.mood),
    );
  }

  Widget _buildEar({required bool isLeft}) {
    return Container(
      width: widget.size * 0.15,
      height: widget.size * 0.25,
      decoration: BoxDecoration(
        color: const Color(0xFFFFADC7).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(widget.size * 0.08),
      ),
      child: Center(
        child: Icon(
          Icons.favorite,
          size: widget.size * 0.08,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      width: widget.size * 0.45,
      height: widget.size * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.size * 0.15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Detail line on chest
          Positioned(
            top: 15,
            child: Container(
              width: widget.size * 0.3,
              height: widget.size * 0.2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          // Heart on chest
          const Icon(
            Icons.favorite,
            size: 30,
            color: Color(0xFFFFADC7),
          ),
        ],
      ),
    );
  }

  Widget _buildAntenna() {
    return Column(
      children: [
        const Icon(
          Icons.favorite,
          size: 16,
          color: Color(0xFFFFADC7),
        ),
        Container(
          width: 3,
          height: 15,
          color: const Color(0xFF636E72),
        ),
      ],
    );
  }

  Widget _buildLeg() {
    return Column(
      children: [
        Container(
          width: widget.size * 0.12,
          height: widget.size * 0.15,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          width: widget.size * 0.14,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFFFADC7),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _buildArm({required bool isLeft}) {
    return Transform.rotate(
      angle: isLeft ? 0.3 : -0.3,
      child: Column(
        children: [
          Container(
            width: 12,
            height: widget.size * 0.15,
            decoration: BoxDecoration(
              color: const Color(0xFF636E72),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFF4A4A4A),
              shape: BoxShape.circle,
            ),
            child: isLeft ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFADC7),
                  shape: BoxShape.circle,
                ),
              ),
            ) : null,
          ),
        ],
      ),
    );
  }
}

class _VisorMouthPainter extends CustomPainter {
  final BuddyMood mood;
  _VisorMouthPainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB5CF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (mood == BuddyMood.happy) {
      path.moveTo(0, 0);
      path.quadraticBezierTo(size.width / 2, size.height * 1.2, size.width, 0);
    } else if (mood == BuddyMood.thinking) {
      path.moveTo(size.width * 0.2, size.height / 2);
      path.lineTo(size.width * 0.8, size.height / 2);
    } else {
      path.moveTo(size.width * 0.2, 5);
      path.quadraticBezierTo(size.width / 2, size.height, size.width * 0.8, 5);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
