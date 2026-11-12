import 'package:flutter/material.dart';
import 'package:adarsh_portfolio/core/theme/aerospace_theme.dart';
import 'package:adarsh_portfolio/features/portfolio/data/portfolio_data.dart';
import 'package:adarsh_portfolio/shared/widgets/aerospace_chrome.dart';

/// Shared project showcase card with bespoke miniature UI preview artwork.
class PortfolioProjectCard extends StatelessWidget {
  final ProjectItem project;
  final VoidCallback onLiveDemo;
  final VoidCallback onSecondaryAction;

  const PortfolioProjectCard({
    super.key,
    required this.project,
    required this.onLiveDemo,
    required this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);

    return HoverLiftCard(
      padding: EdgeInsets.zero,
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Interactive Mockup Banner
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(17)),
                child: _ProjectBannerArtwork(project: project),
              ),

              // Card Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags strip above title
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: project.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: palette.isDark
                                ? AerospaceTheme.surfaceDarkElevated
                                : palette.surfaceElevated,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: palette.hairline),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: palette.textSecondary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: palette.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _projectIcon(project.visualStyle),
                          size: 18,
                          color: palette.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.55,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Pinned CTA Row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: onLiveDemo,
                  style: FilledButton.styleFrom(
                    backgroundColor: AerospaceTheme.accentScarlet,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                  icon: const Icon(Icons.arrow_outward_rounded, size: 15),
                  label: const Text(
                    'Live Demo',
                    style: TextStyle(fontSize: 12.5),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onSecondaryAction,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                  icon: const Icon(Icons.code_rounded, size: 15),
                  label: Text(
                    project.secondaryActionLabel,
                    style: const TextStyle(fontSize: 12.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static IconData _projectIcon(ProjectVisualStyle style) {
    switch (style) {
      case ProjectVisualStyle.trackFlow:
        return Icons.trending_up_rounded;
      case ProjectVisualStyle.connectCall:
        return Icons.video_call_rounded;
      case ProjectVisualStyle.aiAssessment:
        return Icons.auto_awesome_rounded;
      case ProjectVisualStyle.weatherApp:
        return Icons.wb_sunny_outlined;
      case ProjectVisualStyle.favouritePlace:
        return Icons.location_on_outlined;
    }
  }
}

class _ProjectBannerArtwork extends StatelessWidget {
  final ProjectItem project;

  const _ProjectBannerArtwork({required this.project});

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);

    return Container(
      height: 186,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette.isDark
              ? [
                  const Color(0xFF0A1426),
                  const Color(0xFF101F38),
                ]
              : [
                  const Color(0xFFE6EDF5),
                  const Color(0xFFF3F7FB),
                ],
        ),
        border: Border(bottom: BorderSide(color: palette.hairline)),
      ),
      padding: const EdgeInsets.all(14),
      child: Stack(
        children: [
          Center(child: _buildMiniDeviceMockup(project.visualStyle)),
          Positioned(
            top: 0,
            left: 0,
            child: _BannerTag(
              text: '● ${project.badge}',
              isAccent: true,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _BannerTag(
              text: project.version,
              isAccent: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDeviceMockup(ProjectVisualStyle style) {
    switch (style) {
      case ProjectVisualStyle.trackFlow:
        return _MiniPhoneShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TrackFlow',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.circle, size: 6, color: AerospaceTheme.accentScarlet),
                ],
              ),
              const Column(
                children: [
                  _MiniBar(widthFactor: 0.85, color: AerospaceTheme.accentScarlet),
                  SizedBox(height: 5),
                  _MiniBar(widthFactor: 1.0, color: Color(0xFF1E3A5F)),
                  SizedBox(height: 5),
                  _MiniBar(widthFactor: 0.65, color: Color(0xFF1E3A5F)),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Play Store v2.4',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 7.5, color: Colors.white54),
                ),
              ),
            ],
          ),
        );

      case ProjectVisualStyle.connectCall:
        return _MiniPhoneShell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '● LIVE',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AerospaceTheme.accentGreen,
                    ),
                  ),
                  Text(
                    'Agora RTC',
                    style: TextStyle(fontSize: 7.5, color: Colors.white54),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF162B4D),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A5F),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: AerospaceTheme.accentScarlet,
                    child: Icon(Icons.call_end, size: 9, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: AerospaceTheme.accentGreen,
                    child: Icon(Icons.mic, size: 9, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );

      case ProjectVisualStyle.aiAssessment:
        return _MiniPhoneShell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AI Engine',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 11,
                    color: AerospaceTheme.accentScarlet,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AerospaceTheme.accentScarlet.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AerospaceTheme.accentScarlet.withValues(alpha: 0.35),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MiniBar(widthFactor: 0.9, color: Colors.white70),
                    SizedBox(height: 4),
                    _MiniBar(
                      widthFactor: 0.65,
                      color: AerospaceTheme.accentScarlet,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '7-Day Sprint Ship',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 7.5, color: Colors.white54),
                ),
              ),
            ],
          ),
        );

      case ProjectVisualStyle.weatherApp:
        return _MiniPhoneShell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pune, IN',
                    style: TextStyle(fontSize: 8, color: Colors.white70),
                  ),
                  Icon(
                    Icons.wb_sunny_rounded,
                    size: 12,
                    color: Color(0xFFF59E0B),
                  ),
                ],
              ),
              const Text(
                '28°C',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Clear Sky • Live API',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 7.5, color: Colors.white54),
                ),
              ),
            ],
          ),
        );

      case ProjectVisualStyle.favouritePlace:
        return _MiniPhoneShell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GPS Sync',
                    style: TextStyle(fontSize: 8, color: Colors.white70),
                  ),
                  Text(
                    'GeoTag',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AerospaceTheme.accentGreen,
                    ),
                  ),
                ],
              ),
              Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF132742),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 22,
                  color: AerospaceTheme.accentScarlet,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'SQLite Offline',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 7.5, color: Colors.white54),
                ),
              ),
            ],
          ),
        );
    }
  }
}

class _MiniPhoneShell extends StatelessWidget {
  final Widget child;

  const _MiniPhoneShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 146,
      height: 126,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AerospaceTheme.canvasDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MiniBar extends StatelessWidget {
  final double widthFactor;
  final Color color;

  const _MiniBar({required this.widthFactor, required this.color});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _BannerTag extends StatelessWidget {
  final String text;
  final bool isAccent;

  const _BannerTag({required this.text, required this.isAccent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AerospaceTheme.canvasDark.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isAccent
              ? AerospaceTheme.accentScarlet.withValues(alpha: 0.45)
              : Colors.white24,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: isAccent
              ? AerospaceTheme.accentScarletBright
              : Colors.white54,
        ),
      ),
    );
  }
}
