import 'package:flutter/material.dart';
import '../../core/theme/aerospace_theme.dart';

/// Central profile avatar with asynchronous 6-second Zero-G floating animation
/// (12px Y-axis travel, ±1.2° micro-rotation, ease-in-out curve, and depth glow).
class BreathingAvatar extends StatefulWidget {
  final ImageProvider imageProvider;
  final double radius;
  final bool isDarkMode;

  const BreathingAvatar({
    super.key,
    required this.imageProvider,
    this.radius = 85.0,
    this.isDarkMode = false,
  });

  @override
  State<BreathingAvatar> createState() => _BreathingAvatarState();
}

class _BreathingAvatarState extends State<BreathingAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 6-second full Zero-G loop (3s ascent, 3s descent)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.repeat(reverse: true);
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
        final t = _animation.value;
        final factor = (t * 2.0) - 1.0; // -1.0 .. +1.0
        // Smooth 12px peak-to-peak vertical float (-6px to +6px)
        final translateY = factor * -6.0;
        // Micro-rotation within -1.2° to +1.2° (±0.021 rad, strictly within ±1.5°)
        final tiltAngle = factor * 0.021;

        // Depth-expansion: shadow spread and blur expand as the avatar rises
        final blurRadius = 24.0 + (16.0 * t);
        final spreadRadius = 2.0 + (6.0 * t);
        final glowOpacity =
            widget.isDarkMode ? (0.16 + (0.14 * t)) : (0.08 + (0.08 * t));

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.translationValues(0.0, translateY, 0.0)
            ..rotateZ(tiltAngle),
          child: Container(
            width: widget.radius * 2,
            height: widget.radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AerospaceTheme.accentScarlet,
                  widget.isDarkMode
                      ? const Color(0xFF0F2342)
                      : const Color(0xFFE2E8F0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AerospaceTheme.accentScarlet
                      .withValues(alpha: glowOpacity),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                  offset: Offset(0, 10 + (6 * t)),
                ),
                BoxShadow(
                  color: widget.isDarkMode
                      ? Colors.black.withValues(alpha: 0.5)
                      : const Color(0x140A192F),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3.5),
            child: ClipOval(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: widget.imageProvider,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: widget.isDarkMode
                            ? AerospaceTheme.surfaceDark
                            : AerospaceTheme.surfaceLight,
                        alignment: Alignment.center,
                        child: Text(
                          'AG',
                          style: TextStyle(
                            fontSize: widget.radius * 0.45,
                            fontWeight: FontWeight.w800,
                            color: widget.isDarkMode
                                ? AerospaceTheme.textPrimaryDark
                                : AerospaceTheme.textPrimaryLight,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
