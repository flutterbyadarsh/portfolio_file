import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/aerospace_theme.dart';
import '../../portfolio/data/portfolio_data.dart';
import '../../../shared/widgets/anti_gravity_wrapper.dart';
import '../../../shared/widgets/breathing_avatar.dart';
import '../../../shared/widgets/glassmorphic_badge.dart';
import '../../../shared/widgets/zero_gravity_particles.dart';

/// Hero Orbit presentation implementing asynchronous Zero-G levitation
/// across Desktop (>1024px), Tablet (768-1024px), and Mobile (<768px).
class HeroOrbitView extends StatelessWidget {
  final bool isDarkMode;
  final String avatarUrl;

  const HeroOrbitView({
    super.key,
    this.isDarkMode = false,
    this.avatarUrl = PortfolioData.profileImageAsset,
  });

  ImageProvider _resolveAvatarProvider() {
    if (avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://')) {
      return NetworkImage(avatarUrl);
    }
    return AssetImage(avatarUrl);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth >= 768 && screenWidth <= 1024;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxAvailable = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : screenWidth;

        // Breakpoint-aware orbit & avatar sizing:
        // - Desktop (>1024px): Large orbit (420) + large avatar (86)
        // - Tablet (768-1024px): Condensed orbit (330) + shrunk avatar (66)
        // - Mobile (<768px): Centered mobile orbit clamped to available width
        final double orbitSize;
        final double avatarRadius;
        if (isDesktop) {
          orbitSize = math.min(420.0, maxAvailable);
          avatarRadius = orbitSize * 0.205;
        } else if (isTablet) {
          orbitSize = math.min(330.0, maxAvailable - 8);
          avatarRadius = orbitSize * 0.20;
        } else {
          orbitSize = (maxAvailable - 16).clamp(230.0, 325.0);
          avatarRadius = orbitSize * 0.21;
        }

        final isCompact = orbitSize < 310;
        final badgeScale = isCompact ? 0.84 : (isDesktop ? 1.0 : 0.90);
        final edgeInset = isDesktop ? -12.0 : 0.0;

        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: ZeroGravityParticles(
                count: 5,
                isDarkMode: isDarkMode,
              ),
            ),
            SizedBox(
              width: orbitSize,
              height: orbitSize,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Outer Concentric Orbital Track
                  CustomPaint(
                    size: Size(orbitSize, orbitSize),
                    painter: _OrbitTrackPainter(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.14)
                          : const Color(0x2E0A192F),
                      isDashed: true,
                    ),
                  ),

                  // Inner Subtle Orbit Ring
                  CustomPaint(
                    size: Size(orbitSize * 0.72, orbitSize * 0.72),
                    painter: _OrbitTrackPainter(
                      color: AerospaceTheme.accentScarlet.withValues(
                        alpha: isDarkMode ? 0.25 : 0.14,
                      ),
                      isDashed: false,
                    ),
                  ),

                  // Central Avatar (6-second Zero-G loop)
                  BreathingAvatar(
                    imageProvider: _resolveAvatarProvider(),
                    radius: avatarRadius,
                    isDarkMode: isDarkMode,
                  ),

                  // FLOATING BADGE 1: "Flutter Dev" (4-second full loop: 2000ms half-cycle)
                  Positioned(
                    top: isDesktop ? 18 : 4,
                    left: edgeInset,
                    child: Transform.scale(
                      alignment: Alignment.topLeft,
                      scale: badgeScale,
                      child: AntiGravityWrapper(
                        duration: const Duration(milliseconds: 2000),
                        yOffset: 12.0,
                        xOffset: 2.0,
                        maxTiltAngle: 0.024, // ~1.38° (within ±1.5°)
                        curve: Curves.easeInOut,
                        initialPhase: 0.0,
                        child: GlassmorphicBadge(
                          isDarkMode: isDarkMode,
                          leading: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: const Color(0x2602569B),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0x4D02569B)),
                            ),
                            child: const Icon(
                              Icons.flutter_dash,
                              size: 15,
                              color: Color(0xFF38BDF8),
                            ),
                          ),
                          title: 'Flutter Dev',
                          subtitle: 'Dart • Riverpod',
                        ),
                      ),
                    ),
                  ),

                  // FLOATING BADGE 2: "8.4 CGPA" (5.5-second full loop: 2750ms half-cycle)
                  Positioned(
                    bottom: isDesktop ? 32 : (isCompact ? 50 : 46),
                    right: edgeInset,
                    child: Transform.scale(
                      alignment: Alignment.bottomRight,
                      scale: badgeScale,
                      child: AntiGravityWrapper(
                        duration: const Duration(milliseconds: 2750),
                        yOffset: 14.0,
                        xOffset: -2.5,
                        maxTiltAngle: -0.025, // ~-1.43° (within ±1.5°)
                        curve: Curves.easeInOut,
                        initialPhase: 0.45,
                        child: GlassmorphicBadge(
                          isDarkMode: isDarkMode,
                          leading: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: const Color(0x26D97706),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0x4DD97706)),
                            ),
                            child: const Icon(
                              Icons.star_rounded,
                              size: 17,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                          title: '★ 8.4 CGPA',
                          subtitle: 'Engineering Academics',
                        ),
                      ),
                    ),
                  ),

                  // FLOATING BADGE 3: "Clean Architecture" (4.7-second full loop: 2350ms half-cycle)
                  Positioned(
                    bottom: isDesktop ? 16 : 0,
                    left: isDesktop ? 32 : 0,
                    child: Transform.scale(
                      alignment: Alignment.bottomLeft,
                      scale: badgeScale,
                      child: AntiGravityWrapper(
                        duration: const Duration(milliseconds: 2350),
                        yOffset: 10.5,
                        xOffset: 1.5,
                        maxTiltAngle: 0.019, // ~1.09° (within ±1.5°)
                        curve: Curves.easeInOut,
                        initialPhase: 0.78,
                        child: GlassmorphicBadge(
                          isDarkMode: isDarkMode,
                          leading: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AerospaceTheme.accentGreen,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x8010B981),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          title: 'Clean Architecture',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OrbitTrackPainter extends CustomPainter {
  final Color color;
  final bool isDashed;

  _OrbitTrackPainter({
    required this.color,
    required this.isDashed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    if (!isDashed) {
      canvas.drawCircle(center, radius, paint);
      return;
    }

    const double dashLength = 6.0;
    const double gapLength = 6.0;
    final circumference = 2 * math.pi * radius;
    final totalSteps = (circumference / (dashLength + gapLength)).floor();

    for (int i = 0; i < totalSteps; i++) {
      final startAngle = (i * (dashLength + gapLength) / radius);
      final sweepAngle = dashLength / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitTrackPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isDashed != isDashed;
}
