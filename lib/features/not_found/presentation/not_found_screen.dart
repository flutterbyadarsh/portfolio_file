import 'package:flutter/material.dart';
import 'package:adarsh_portfolio/core/theme/aerospace_theme.dart';
import 'package:adarsh_portfolio/shared/widgets/aerospace_chrome.dart';

/// 404 Widget Tree Missing screen matching the UX error specification.
class NotFoundScreen extends StatelessWidget {
  final String routeName;
  final VoidCallback onTakeMeHome;
  final VoidCallback onBackToProjects;
  final VoidCallback onContactMe;

  const NotFoundScreen({
    super.key,
    this.routeName = '/unknown_widget',
    required this.onTakeMeHome,
    required this.onBackToProjects,
    required this.onContactMe,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);

    return Scaffold(
      body: BlueprintGridBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: FadeSlideReveal(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const StatusPill(label: 'BUILD_CONTEXT: NULL_POINTER'),
                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: palette.isDark
                                ? const [Color(0xFFFCA5A5), Color(0xFF991B1B)]
                                : const [
                                    AerospaceTheme.navyPrimary,
                                    AerospaceTheme.accentScarlet,
                                  ],
                          ).createShader(bounds);
                        },
                        child: const Text(
                          '404',
                          style: TextStyle(
                            fontSize: 96,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                            color: Colors.white,
                            letterSpacing: -3.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Oops! Looks like this widget is missing from the widget tree.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'The route you navigated toward does not exist, has been unmounted during garbage collection, or was refactored into a different branch.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.55,
                          color: palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Terminal Stack Trace Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AerospaceTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 9,
                                      color: AerospaceTheme.accentScarlet,
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.circle,
                                      size: 9,
                                      color: Color(0xFFF59E0B),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.circle,
                                      size: 9,
                                      color: AerospaceTheme.accentGreen,
                                    ),
                                  ],
                                ),
                                Text(
                                  'flutter_framework.log',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              "(!) RouteNotFoundException: '/' -> '$routeName'",
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: Color(0xFFFCA5A5),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '    at NavigatorState._pushNamed (navigator.dart:404)',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11.5,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '    state: BuildOwner#unmounted [state=deactivated]',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),

                      // Recovery Action Buttons
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          FilledButton.icon(
                            onPressed: onTakeMeHome,
                            icon: const Icon(Icons.home_outlined, size: 17),
                            label: const Text('Take Me Home'),
                          ),
                          OutlinedButton.icon(
                            onPressed: onBackToProjects,
                            icon: const Icon(Icons.arrow_back_rounded, size: 17),
                            label: const Text('Back to Projects'),
                          ),
                          TextButton.icon(
                            onPressed: onContactMe,
                            icon: Icon(
                              Icons.send_outlined,
                              size: 16,
                              color: palette.textSecondary,
                            ),
                            label: Text(
                              'Contact Me',
                              style: TextStyle(color: palette.textPrimary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Adarsh Mahesh Gupta  •  Flutter & UI/UX Architect',
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
