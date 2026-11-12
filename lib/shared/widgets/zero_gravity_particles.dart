import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/aerospace_theme.dart';

/// Cosmic/Aerospace ambient particles that float slowly across the canvas,
/// enhancing the zero-gravity atmosphere without impacting UI performance.
class ZeroGravityParticles extends StatefulWidget {
  final int count;
  final bool isDarkMode;

  const ZeroGravityParticles({
    super.key,
    this.count = 6,
    this.isDarkMode = false,
  });

  @override
  State<ZeroGravityParticles> createState() => _ZeroGravityParticlesState();
}

class _ZeroGravityParticlesState extends State<ZeroGravityParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ParticleModel> _particles = [];
  final math.Random _random = math.Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generate initial particle configurations
    for (int i = 0; i < widget.count; i++) {
      _particles.add(
        _ParticleModel(
          initialX: _random.nextDouble(),
          initialY: _random.nextDouble(),
          radius: 30.0 + _random.nextDouble() * 90.0,
          driftRadius: 15.0 + _random.nextDouble() * 30.0,
          phase: _random.nextDouble() * 2 * math.pi,
          speedMultiplier: 0.6 + _random.nextDouble() * 0.8,
          isScarlet: i % 2 == 0,
        ),
      );
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
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            isDarkMode: widget.isDarkMode,
          ),
        );
      },
    );
  }
}

class _ParticleModel {
  final double initialX;
  final double initialY;
  final double radius;
  final double driftRadius;
  final double phase;
  final double speedMultiplier;
  final bool isScarlet;

  _ParticleModel({
    required this.initialX,
    required this.initialY,
    required this.radius,
    required this.driftRadius,
    required this.phase,
    required this.speedMultiplier,
    required this.isScarlet,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_ParticleModel> particles;
  final double progress;
  final bool isDarkMode;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final angle = (progress * 2 * math.pi * p.speedMultiplier) + p.phase;
      final dx = (p.initialX * size.width) + (math.cos(angle) * p.driftRadius);
      final dy = (p.initialY * size.height) + (math.sin(angle) * p.driftRadius);

      final color = p.isScarlet
          ? AerospaceTheme.accentScarlet
              .withValues(alpha: isDarkMode ? 0.08 : 0.04)
          : (isDarkMode ? const Color(0xFF1E3A8A) : const Color(0xFF93C5FD))
              .withValues(alpha: isDarkMode ? 0.07 : 0.06);

      final paint = Paint()
        ..color = color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 0.65);

      canvas.drawCircle(Offset(dx, dy), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
