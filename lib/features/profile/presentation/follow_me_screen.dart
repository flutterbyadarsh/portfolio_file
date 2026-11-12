import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adarsh_portfolio/core/theme/aerospace_theme.dart';
import 'package:adarsh_portfolio/core/utils/external_launcher.dart';
import 'package:adarsh_portfolio/features/portfolio/data/portfolio_data.dart';
import 'package:adarsh_portfolio/shared/widgets/aerospace_chrome.dart';
import 'package:adarsh_portfolio/shared/widgets/breathing_avatar.dart';

/// Profile & Ecosystem card screen matching the Follow Me UI (Light & Dark).
class FollowMeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final VoidCallback onBackHome;
  final VoidCallback onOpenProjects;
  final VoidCallback onOpenContact;

  const FollowMeScreen({
    super.key,
    required this.onToggleTheme,
    required this.onBackHome,
    required this.onOpenProjects,
    required this.onOpenContact,
  });

  void _copyEmail(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: PortfolioData.email));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied ${PortfolioData.email} to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _notifyAction(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(label),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 780;
    final isDesktop = width > 1024;

    return Scaffold(
      drawer: isDesktop
          ? null
          : AerospaceSlideDrawer(
              onToggleTheme: onToggleTheme,
              onNavigateSection: (section) =>
                  section == 'Contact' ? onOpenContact() : onBackHome(),
              onOpenFollowMe: () {},
              onOpenAllProjects: onOpenProjects,
              onOpenContact: onOpenContact,
            ),
      appBar: AerospaceNavbar(
        onToggleTheme: onToggleTheme,
        onBrandTap: onBackHome,
        onOpenFollowMe: () {},
        onOpenAllProjects: onOpenProjects,
        onOpenContact: onOpenContact,
        onNavigateSection: (section) =>
            section == 'Contact' ? onOpenContact() : onBackHome(),
      ),
      body: BlueprintGridBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32 : 16,
                  vertical: 32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 880),
                    child: FadeSlideReveal(
                      child: Container(
                        padding: EdgeInsets.all(isWide ? 36 : 20),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: palette.hairline),
                          boxShadow: palette.isDark
                              ? [
                                  const BoxShadow(
                                    color: Color(0x55000000),
                                    blurRadius: 36,
                                    offset: Offset(0, 16),
                                  ),
                                ]
                              : AerospaceTheme.floatingBadgeShadowLight,
                        ),
                        child: Column(
                          children: [
                            // Card Top Bar
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                runSpacing: 10,
                                spacing: 12,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: onBackHome,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_back_rounded,
                                      size: 16,
                                    ),
                                    label: const Text(
                                      'BACK TO PORTFOLIO',
                                      style: TextStyle(fontSize: 11.5),
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      Clipboard.setData(
                                        const ClipboardData(
                                          text: 'https://adarsh.dev/follow',
                                        ),
                                      );
                                      _notifyAction(
                                        context,
                                        'Profile card link copied to clipboard',
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.share_outlined,
                                      size: 15,
                                    ),
                                    label: const Text(
                                      'SHARE CARD',
                                      style: TextStyle(fontSize: 11.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Central Breathing Avatar + Status Chip
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomCenter,
                              children: [
                                BreathingAvatar(
                                  imageProvider: const AssetImage(
                                    PortfolioData.profileImageAsset,
                                  ),
                                  radius: 56,
                                  isDarkMode: palette.isDark,
                                ),
                                Positioned(
                                  bottom: -10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: palette.isDark
                                          ? AerospaceTheme.canvasDark
                                          : palette.surface,
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: palette.hairline,
                                      ),
                                      boxShadow: palette.cardShadow,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: AerospaceTheme.accentGreen,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Available for Hire',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: palette.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Name + Verified Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Adarsh Gupta',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isWide ? 30 : 24,
                                      fontWeight: FontWeight.w800,
                                      color: palette.textPrimary,
                                      letterSpacing: -0.6,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.verified_rounded,
                                  color: AerospaceTheme.accentScarlet,
                                  size: 22,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Flutter Developer • Clean Architecture & Firebase',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: palette.isDark
                                    ? AerospaceTheme.accentScarletBright
                                    : palette.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pune & Noida, India (IST)  •  4+ Production Apps',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: palette.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: Text(
                                '"${PortfolioData.heroBio}"',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontStyle: FontStyle.italic,
                                  height: 1.55,
                                  color: palette.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Email Mailto + Copy Pill
                            InkWell(
                              onTap: () => launchExternalLink(
                                context,
                                PortfolioData.mailtoUri,
                                fallbackCopyValue: PortfolioData.email,
                              ),
                              onLongPress: () => _copyEmail(context),
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: palette.surfaceElevated,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: AerospaceTheme.accentScarlet
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.email_outlined,
                                      size: 15,
                                      color: AerospaceTheme.accentScarlet,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Email: ${PortfolioData.email}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: palette.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.copy_rounded,
                                      size: 14,
                                      color: palette.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Channels Header
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        size: 7,
                                        color: AerospaceTheme.accentScarlet,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'CHANNELS & ECOSYSTEM',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.1,
                                            color: palette.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '06 CONNECTIONS',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 10.5,
                                      color: palette.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 3x2 Responsive Channels Grid
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final cols = constraints.maxWidth >= 640
                                    ? 3
                                    : (constraints.maxWidth >= 420 ? 2 : 1);
                                const gap = 12.0;
                                final cardW =
                                    (constraints.maxWidth - (gap * (cols - 1))) /
                                        cols;

                                return Wrap(
                                  spacing: gap,
                                  runSpacing: gap,
                                  children: PortfolioData.channels.map((ch) {
                                    return SizedBox(
                                      width: cardW,
                                      child: HoverLiftCard(
                                        padding: const EdgeInsets.all(14),
                                        borderRadius: 14,
                                        backgroundColor: palette.isDark
                                            ? AerospaceTheme.canvasDark
                                            : palette.surface,
                                        onTap: () {
                                          if (ch.title == 'Portfolio') {
                                            onOpenProjects();
                                            return;
                                          }
                                          launchExternalLink(
                                            context,
                                            ch.url,
                                            fallbackCopyValue: ch.handle,
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: AerospaceTheme
                                                    .accentScarlet
                                                    .withValues(alpha: 0.12),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                ch.icon,
                                                size: 18,
                                                color: AerospaceTheme
                                                    .accentScarlet,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ch.title,
                                                    style: TextStyle(
                                                      fontSize: 13.5,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          palette.textPrimary,
                                                    ),
                                                  ),
                                                  Text(
                                                    ch.handle,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 11.5,
                                                      color:
                                                          palette.textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.north_east_rounded,
                                              size: 14,
                                              color: palette.textSecondary,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            const SizedBox(height: 22),

                            // Contract Banner
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: palette.isDark
                                    ? AerospaceTheme.canvasDark
                                    : palette.surfaceElevated,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: palette.hairline),
                              ),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 16,
                                runSpacing: 14,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CONTRACT & FULL-TIME',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.0,
                                          color: palette.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Let's build something exceptional",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: palette.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Mobile architecture, Flutter migrations, and UI/UX design execution.',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: palette.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      FilledButton.icon(
                                        onPressed: onOpenContact,
                                        icon: const Icon(
                                          Icons.bolt_rounded,
                                          size: 16,
                                        ),
                                        label: const Text('Hire Me'),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () => launchExternalLink(
                                          context,
                                          PortfolioData.resumeUrl,
                                          emptyMessage:
                                              'Resume PDF link ready — attach URL in PortfolioData.resumeUrl',
                                        ),
                                        icon: const Icon(
                                          Icons.description_outlined,
                                          size: 16,
                                        ),
                                        label: const Text('Resume (PDF)'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Card bottom line
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 7,
                                      color: AerospaceTheme.accentScarlet,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'Verified Direct Access • Adarsh Mahesh Gupta • 2026',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: palette.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'End-to-End Encrypted Connect',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: palette.textSecondary,
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
                ),
              ),
              const AerospaceFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
