import 'dart:math' as math;
import 'package:flutter/material.dart';

/// [AntiGravityWrapper] creates an organic, weightless zero-gravity levitation effect.
/// It combines vertical floating, subtle horizontal drift, and micro-tilt rotation.
///
/// Features:
/// - Desynchronization via [phaseDelay] or varied [duration].
/// - Pure Flutter native implementation (zero external dependency required).
/// - 60/120 FPS hardware-accelerated Transform matrix.
class AntiGravityWrapper extends StatefulWidget {
  final Widget child;
  
  /// Peak vertical travel distance in pixels (default: 12.0)
  final double yOffset;
  
  /// Subtle horizontal micro-drift in pixels (default: 3.0)
  final double xOffset;
  
  /// Maximum angular tilt in radians (e.g., 0.02 rad ≈ 1.15 degrees)
  final double maxTiltAngle;
  
  /// Time taken to complete one half-cycle (travel up or down)
  final Duration duration;
  
  /// Phase offset between 0.0 and 1.0 to desynchronize multiple floating elements
  final double initialPhase;

  /// Custom easing curve (default: smooth weightless sine curve)
  final Curve curve;

  const AntiGravityWrapper({
    super.key,
    required this.child,
    this.yOffset = 12.0,
    this.xOffset = 2.5,
    this.maxTiltAngle = 0.025,
    this.duration = const Duration(milliseconds: 3200),
    this.initialPhase = 0.0,
    this.curve = Curves.easeInOutSine,
  });

  @override
  State<AntiGravityWrapper> createState() => _AntiGravityWrapperState();
}

class _AntiGravityWrapperState extends State<AntiGravityWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.initialPhase.clamp(0.0, 1.0),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant AntiGravityWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
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
      animation: _animation,
      builder: (context, child) {
        // Value ranges smoothly between 0.0 and 1.0, then reverses
        final t = _animation.value;
        
        // Map 0.0..1.0 to -1.0..1.0 for symmetric oscillation
        final factor = (t * 2.0) - 1.0; 

        final currentY = factor * widget.yOffset;
        final currentX = math.sin(t * math.pi) * widget.xOffset;
        final currentRotation = factor * widget.maxTiltAngle;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.translationValues(currentX, currentY, 0.0)
            ..rotateZ(currentRotation),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
