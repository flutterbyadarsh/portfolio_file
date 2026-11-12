import 'package:flutter/material.dart';
import 'package:adarsh_portfolio/core/theme/aerospace_theme.dart';
import 'package:adarsh_portfolio/shared/widgets/aerospace_chrome.dart';

/// Animated Aerospace boot sequence matching the UX splash screen specification.
class BootSplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const BootSplashScreen({super.key, required this.onComplete});

  @override
  State<BootSplashScreen> createState() => _BootSplashScreenState();
}

class _BootSplashScreenState extends State<BootSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _cursorController;
  bool _completed = false;

  static const List<String> _bootMessages = [
    '> Initializing Aerospace Theme Tokens...',
    '> Mounting Riverpod & Hero Orbit Engine...',
    '> Compiling UI Shaders & 60 FPS Pipelines...',
    '> System Ready. Launching Portfolio...',
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..repeat(reverse: true);

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_completed) {
        _finishBoot();
      }
    });

    _progressController.forward();
  }

  void _finishBoot() {
    if (_completed) return;
    _completed = true;
    widget.onComplete();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AerospaceTheme.canvasDark,
      body: SafeArea(
        child: Stack(
          children: [
            // Subtle central radial glow
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.75,
                    colors: [
                      AerospaceTheme.accentScarlet.withValues(alpha: 0.10),
                      AerospaceTheme.surfaceDark.withValues(alpha: 0.45),
                      AerospaceTheme.canvasDark,
                    ],
                  ),
                ),
              ),
            ),

            // Top telemetry bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 7,
                          color: AerospaceTheme.accentScarlet,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'SYS_BOOT // V3.24',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              letterSpacing: 1.0,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _finishBoot,
                    child: const Text(
                      'SKIP →',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        letterSpacing: 1.0,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Center Boot Card Sequence
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _progressController,
                      _cursorController,
                    ]),
                    builder: (context, _) {
                      final progress = CurvedAnimation(
                        parent: _progressController,
                        curve: Curves.easeInOutCubic,
                      ).value;
                      final pct = (progress * 100).round();
                      final msgIndex = (progress * (_bootMessages.length - 1))
                          .floor()
                          .clamp(0, _bootMessages.length - 1);

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const StatusPill(label: 'PORTFOLIO SYSTEM'),
                          const SizedBox(height: 18),
                          const Text.rich(
                            TextSpan(
                              text: 'Adarsh ',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -1.2,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Gupta',
                                  style: TextStyle(
                                    color: AerospaceTheme.accentScarlet,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          const Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(
                                'Flutter Developer',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.circle,
                                size: 5,
                                color: AerospaceTheme.accentScarlet,
                              ),
                              Text(
                                'Clean Architecture',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // Progress track
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              height: 3.5,
                              width: double.infinity,
                              color: AerospaceTheme.surfaceDarkElevated,
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress.clamp(0.02, 1.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AerospaceTheme.accentScarlet,
                                        Color(0xFFFCA5A5),
                                        Colors.white,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'STATUS SEQUENCE',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10.5,
                                  letterSpacing: 1.2,
                                  color: Colors.white54,
                                ),
                              ),
                              Text(
                                '$pct%',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AerospaceTheme.accentScarletBright,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),

                          // Terminal status block
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: AerospaceTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _bootMessages[msgIndex],
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 11.5,
                                      color: Colors.white70,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Opacity(
                                  opacity:
                                      _cursorController.value > 0.5 ? 1.0 : 0.2,
                                  child: Container(
                                    width: 7,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: AerospaceTheme.accentScarlet,
                                      borderRadius: BorderRadius.circular(1.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            // Bottom telemetry bar
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      Text(
                        'FPS_TARGET: 120HZ',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10.5,
                          letterSpacing: 1.0,
                          color: Colors.white54,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'LATENCY: ',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10.5,
                            letterSpacing: 1.0,
                            color: Colors.white54,
                          ),
                          children: [
                            TextSpan(
                              text: '12ms',
                              style: TextStyle(
                                color: AerospaceTheme.accentScarletBright,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
