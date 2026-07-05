import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that shakes its child horizontally when [shouldShake] is true.
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool shouldShake;
  final Duration duration;

  const ShakeWidget({
    super.key,
    required this.child,
    this.shouldShake = false,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldShake && !oldWidget.shouldShake) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = _controller.value;
        if (progress == 0.0) return child!;
        
        // Sine wave for shaking effect
        final double offset = sin(progress * pi * 4) * 8;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
