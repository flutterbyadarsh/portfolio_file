import 'package:flutter/material.dart';
import 'package:adarsh_portfolio/core/theme/aerospace_theme.dart';
import 'package:adarsh_portfolio/core/utils/external_launcher.dart';
import 'package:adarsh_portfolio/features/portfolio/data/portfolio_data.dart';
import 'package:adarsh_portfolio/features/projects/presentation/project_card_widget.dart';
import 'package:adarsh_portfolio/shared/widgets/aerospace_chrome.dart';

/// Dedicated All Projects catalog screen matching the "Things I've Built" UI.
class AllProjectsScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final VoidCallback onBackHome;
  final VoidCallback onOpenFollowMe;
  final VoidCallback onOpenContact;

  const AllProjectsScreen({
    super.key,
    required this.onToggleTheme,
    required this.onBackHome,
    required this.onOpenFollowMe,
    required this.onOpenContact,
  });

  @override
  State<AllProjectsScreen> createState() => _AllProjectsScreenState();
}

class _AllProjectsScreenState extends State<AllProjectsScreen> {
  String _selectedCategory = PortfolioData.projectCategories.first;

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 820;
    final isDesktop = width > 1024;

    final filtered = PortfolioData.projectsForCategory(_selectedCategory);

    return Scaffold(
      drawer: isDesktop
          ? null
          : AerospaceSlideDrawer(
              onToggleTheme: widget.onToggleTheme,
              onNavigateSection: (section) => section == 'Contact'
                  ? widget.onOpenContact()
                  : widget.onBackHome(),
              onOpenFollowMe: widget.onOpenFollowMe,
              onOpenAllProjects: () {},
              onOpenContact: widget.onOpenContact,
              activeSection: 'Projects',
            ),
      appBar: AerospaceNavbar(
        onToggleTheme: widget.onToggleTheme,
        onBrandTap: widget.onBackHome,
        onOpenFollowMe: widget.onOpenFollowMe,
        onOpenContact: widget.onOpenContact,
        activeSection: 'Projects',
        onNavigateSection: (section) => section == 'Contact'
            ? widget.onOpenContact()
            : widget.onBackHome(),
      ),
      body: BlueprintGridBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 36 : 16,
                  vertical: 28,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Column(
                      children: [
                        // Top Meta Header Bar
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              OutlinedButton.icon(
                                onPressed: widget.onBackHome,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  size: 15,
                                ),
                                label: const Text(
                                  'BACK TO HOME',
                                  style: TextStyle(fontSize: 11.5),
                                ),
                              ),
                              const StatusPill(label: 'INDEX REV. 2026.4'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Hero Header
                        FadeSlideReveal(
                          child: Column(
                            children: [
                              const StatusPill(
                                label: 'PORTFOLIO • ALL PROJECTS',
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: palette.surface,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: palette.hairline),
                                ),
                                child: Text(
                                  'CLEAN ARCHITECTURE • FIREBASE • AI INTEGRATIONS',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 10.5,
                                    color: palette.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text.rich(
                                TextSpan(
                                  text: "Things I've ",
                                  style: TextStyle(
                                    fontSize: isWide ? 44 : 32,
                                    fontWeight: FontWeight.w800,
                                    color: palette.textPrimary,
                                    letterSpacing: -0.9,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'Built',
                                      style: TextStyle(
                                        color: AerospaceTheme.accentScarlet,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 560),
                                child: Text(
                                  'A collection of cross-platform applications, real-time communication tools, and UI/UX systems crafted with purpose and production quality.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                    color: palette.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Filter Bar
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: palette.surface,
                                  borderRadius:
                                      BorderRadius.circular(isWide ? 999 : 18),
                                  border: Border.all(color: palette.hairline),
                                ),
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  alignment: WrapAlignment.center,
                                  children: PortfolioData.projectCategories
                                      .map((category) {
                                    final selected =
                                        _selectedCategory == category;
                                    final count = PortfolioData
                                        .countProjectsInCategory(category);
                                    return InkWell(
                                      onTap: () {
                                        setState(
                                            () => _selectedCategory = category);
                                      },
                                      borderRadius: BorderRadius.circular(999),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? AerospaceTheme.accentScarlet
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          '${category.toUpperCase()} ($count)',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: selected
                                                ? Colors.white
                                                : palette.textSecondary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Section Label
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 8,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'Main Projects  ',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    color: palette.textPrimary,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: '• FEATURED',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: AerospaceTheme.accentScarlet,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              StatusPill(
                                label: '${filtered.length} Projects Cataloged',
                                subtleBackground: false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 2-column Responsive Equal-Height Grid
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final cols = constraints.maxWidth >= 780 ? 2 : 1;
                            const gap = 22.0;

                            return EqualHeightCardGrid(
                              columns: cols,
                              spacing: gap,
                              runSpacing: gap,
                              children: filtered.map((item) {
                                return PortfolioProjectCard(
                                  project: item,
                                  onLiveDemo: () => launchExternalLink(
                                    context,
                                    PortfolioData.demoRequestMailto(item.title),
                                    fallbackCopyValue: PortfolioData.email,
                                  ),
                                  onSecondaryAction: () => launchExternalLink(
                                    context,
                                    item.repoUrl ?? PortfolioData.githubUrl,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 44),

                        // Bottom Consulting CTA
                        Column(
                          children: [
                            Text(
                              'LOOKING FOR CONTRACT WORK OR SYSTEMS CONSULTING?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11.5,
                                letterSpacing: 1.0,
                                color: palette.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 12,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: widget.onBackHome,
                                  icon: const Icon(
                                    Icons.home_outlined,
                                    size: 16,
                                  ),
                                  label: const Text('Back to Home'),
                                ),
                                FilledButton.icon(
                                  onPressed: widget.onOpenContact,
                                  icon: const Icon(
                                    Icons.mail_outline_rounded,
                                    size: 16,
                                  ),
                                  label: const Text('Initiate Contact'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
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
