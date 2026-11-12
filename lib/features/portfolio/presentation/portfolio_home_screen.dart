import 'package:flutter/material.dart';
import 'package:adarsh_portfolio/core/theme/aerospace_theme.dart';
import 'package:adarsh_portfolio/core/utils/contact_form_service.dart';
import 'package:adarsh_portfolio/core/utils/external_launcher.dart';
import 'package:adarsh_portfolio/features/hero/presentation/hero_orbit_view.dart';
import 'package:adarsh_portfolio/features/portfolio/data/portfolio_data.dart';
import 'package:adarsh_portfolio/features/projects/presentation/project_card_widget.dart';
import 'package:adarsh_portfolio/shared/widgets/aerospace_chrome.dart';

/// Complete multi-section Portfolio Home screen implementing the UX layout
/// across Material 3 Light (Navy + White + Red) and Dark (Navy + White54 + Red) modes.
class PortfolioHomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenFollowMe;
  final VoidCallback onOpenAllProjects;
  final VoidCallback onOpen404Demo;
  final String? initialSection;

  const PortfolioHomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.onOpenFollowMe,
    required this.onOpenAllProjects,
    required this.onOpen404Demo,
    this.initialSection,
  });

  @override
  State<PortfolioHomeScreen> createState() => _PortfolioHomeScreenState();
}

class _PortfolioHomeScreenState extends State<PortfolioHomeScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _scrollHintController;

  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _journeyKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  String _selectedProjectCategory = PortfolioData.projectCategories.first;
  String? _activeNavSection;

  final GlobalKey<FormState> _contactFormKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _messageCtrl = TextEditingController();
  bool _isSendingContact = false;

  @override
  void initState() {
    super.initState();
    _scrollHintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    if (widget.initialSection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollToSection(widget.initialSection!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollHintController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _scrollToSection(String section) {
    setState(() => _activeNavSection = section);
    final map = <String, GlobalKey>{
      'About': _aboutKey,
      'Skills': _skillsKey,
      'Experience': _experienceKey,
      'Journey': _journeyKey,
      'Projects': _projectsKey,
      'Contact': _contactKey,
    };
    final targetContext = map[section]?.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
    );
  }

  void _showSnack(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        action: action,
      ),
    );
  }

  Future<void> _submitContactForm() async {
    if (_isSendingContact) return;
    if (!(_contactFormKey.currentState?.validate() ?? false)) return;

    final name = _nameCtrl.text.trim();
    final senderEmail = _emailCtrl.text.trim();
    final message = _messageCtrl.text.trim();

    setState(() => _isSendingContact = true);

    // TODO: Connect this form submission to Formspree endpoint for dev.adarshgupta@gmail.com.
    final result = await ContactFormService.sendMessage(
      name: name,
      senderEmail: senderEmail,
      message: message,
    );

    if (!mounted) return;
    setState(() => _isSendingContact = false);

    if (result.sent) {
      _contactFormKey.currentState?.reset();
      _nameCtrl.clear();
      _emailCtrl.clear();
      _messageCtrl.clear();
      _showSnack(result.message);
      return;
    }

    if (result.needsActivation) {
      _showSnack(
        result.message,
        action: SnackBarAction(
          label: 'Email App',
          onPressed: () => launchExternalLink(
            context,
            result.fallbackMailtoUri,
            fallbackCopyValue: PortfolioData.email,
          ),
        ),
      );
      return;
    }

    // Fallback: open pre-filled email client directly so message is never lost.
    await launchExternalLink(
      context,
      result.fallbackMailtoUri,
      fallbackCopyValue: PortfolioData.email,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 1024;
    final isTablet = width >= 768 && width <= 1024;
    final isTwoColumn = isDesktop || isTablet;
    final isCompact = width < 480;
    final sectionGap = isDesktop ? 72.0 : (isTablet ? 56.0 : 44.0);

    return Scaffold(
      drawer: isDesktop
          ? null
          : AerospaceSlideDrawer(
              onToggleTheme: widget.onToggleTheme,
              onNavigateSection: _scrollToSection,
              onOpenFollowMe: widget.onOpenFollowMe,
              onOpenAllProjects: widget.onOpenAllProjects,
              onOpen404Demo: widget.onOpen404Demo,
              onOpenContact: () => _scrollToSection('Contact'),
              activeSection: _activeNavSection,
            ),
      appBar: AerospaceNavbar(
        onToggleTheme: widget.onToggleTheme,
        onBrandTap: _scrollToTop,
        onNavigateSection: _scrollToSection,
        onOpenFollowMe: widget.onOpenFollowMe,
        onOpenAllProjects: widget.onOpenAllProjects,
        onOpenContact: () => _scrollToSection('Contact'),
        activeSection: _activeNavSection,
      ),
      body: BlueprintGridBackground(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 36 : (isCompact ? 14 : 20),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: isDesktop ? 44 : 20),
                        _buildHeroSection(
                          palette,
                          isDesktop: isDesktop,
                          isTablet: isTablet,
                          isCompact: isCompact,
                        ),
                        const SizedBox(height: 24),
                        Center(child: _buildScrollIndicator(palette)),
                        const SizedBox(height: 28),
                        _buildStatsRow(palette),
                        SizedBox(height: sectionGap),
                        Container(
                          key: _aboutKey,
                          child: _buildAboutSection(palette, isTwoColumn),
                        ),
                        SizedBox(height: sectionGap),
                        Container(
                          key: _skillsKey,
                          child: _buildSkillsSection(palette),
                        ),
                        SizedBox(height: sectionGap),
                        Container(
                          key: _experienceKey,
                          child: _buildCredentialsSection(palette),
                        ),
                        SizedBox(height: sectionGap),
                        Container(
                          key: _journeyKey,
                          child: _buildJourneySection(palette, isCompact),
                        ),
                        SizedBox(height: sectionGap),
                        Container(
                          key: _projectsKey,
                          child: _buildProjectsSection(palette),
                        ),
                        SizedBox(height: sectionGap),
                        Container(
                          key: _contactKey,
                          child: _buildContactSection(palette, isTwoColumn),
                        ),
                        const SizedBox(height: 44),
                      ],
                    ),
                  ),
                ),
              ),
              AerospaceFooter(
                onScrollTop: _scrollToTop,
                onOpen404Demo: widget.onOpen404Demo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(
    AerospacePalette palette, {
    required bool isDesktop,
    required bool isTablet,
    required bool isCompact,
  }) {
    final isMobile = !isDesktop && !isTablet;
    // Tablet font reduction: 15% smaller than desktop (scale factor 0.85)
    final double headlineSize = isDesktop
        ? 54.0
        : (isTablet ? 54.0 * 0.85 : (isCompact ? 34.0 : 38.0));
    final double subtitleSize =
        isDesktop ? 21.0 : (isTablet ? 21.0 * 0.85 : 17.5);
    final double bodySize =
        isDesktop ? 15.0 : (isTablet ? 15.0 * 0.85 : 14.0);

    final crossAlign =
        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = isMobile ? TextAlign.center : TextAlign.start;
    final wrapAlign = isMobile ? WrapAlignment.center : WrapAlignment.start;

    final copy = FadeSlideReveal(
      child: Column(
        crossAxisAlignment: crossAlign,
        children: [
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusPill(
                label: 'AVAILABLE FOR OPPORTUNITIES',
                dotColor: AerospaceTheme.accentScarlet,
              ),
              StatusPill(
                label: PortfolioData.location,
                dotColor: AerospaceTheme.accentGreen,
                subtleBackground: false,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'FLUTTER SYSTEMS & CLEAN ARCHITECTURE',
            textAlign: textAlign,
            style: TextStyle(
              fontSize: isTablet ? 10.5 : 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: 'Adarsh ',
              style: TextStyle(
                fontSize: headlineSize,
                fontWeight: FontWeight.w800,
                height: 1.08,
                letterSpacing: -1.2,
                color: palette.textPrimary,
              ),
              children: const [
                TextSpan(
                  text: 'Gupta',
                  style: TextStyle(
                    color: AerospaceTheme.accentScarlet,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            textAlign: textAlign,
          ),
          const SizedBox(height: 14),
          Text(
            'Flutter Developer',
            textAlign: textAlign,
            style: TextStyle(
              fontSize: subtitleSize,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              PortfolioData.heroBio,
              textAlign: textAlign,
              style: TextStyle(
                fontSize: bodySize,
                height: 1.65,
                color: palette.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: wrapAlign,
            spacing: 12,
            runSpacing: 12,
            children: [
              // Primary Button 1 (Red Filled): Tech Skills -> scrolls to #skills
              FilledButton.icon(
                onPressed: () => _scrollToSection('Skills'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  backgroundColor: AerospaceTheme.accentScarlet,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.layers_rounded, size: 17),
                label: const Text('Tech Skills'),
              ),
              // Secondary Button 2 (Outlined): View Projects
              OutlinedButton.icon(
                onPressed: widget.onOpenAllProjects,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
                icon: const Icon(Icons.grid_view_rounded, size: 17),
                label: const Text('View Projects'),
              ),
              // Secondary Button 3 (Outlined): Follow me
              OutlinedButton.icon(
                onPressed: widget.onOpenFollowMe,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
                icon: const Icon(Icons.person_outline_rounded, size: 17),
                label: const Text('Follow me'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            alignment: wrapAlign,
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  'CONNECT:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: palette.textSecondary,
                  ),
                ),
              ),
              _ConnectIconBox(
                icon: Icons.terminal_rounded,
                tooltip: 'GitHub',
                onTap: () => launchExternalLink(context, PortfolioData.githubUrl),
              ),
              _ConnectIconBox(
                customSymbol: 'in',
                tooltip: 'LinkedIn',
                onTap: () =>
                    launchExternalLink(context, PortfolioData.linkedinUrl),
              ),
              _ConnectIconBox(
                icon: Icons.mail_outline_rounded,
                tooltip: 'Email (${PortfolioData.email})',
                onTap: () => launchExternalLink(
                  context,
                  PortfolioData.mailtoUri,
                  fallbackCopyValue: PortfolioData.email,
                ),
              ),
              _ConnectIconBox(
                icon: Icons.code_rounded,
                tooltip: 'LeetCode (codebyadarsh02 • 50+ Solved)',
                onTap: () =>
                    launchExternalLink(context, PortfolioData.leetcodeUrl),
              ),
            ],
          ),
        ],
      ),
    );

    final orbit = SizedBox(
      height: isDesktop ? 460 : (isTablet ? 360 : (isCompact ? 300 : 345)),
      child: HeroOrbitView(isDarkMode: palette.isDark),
    );

    // Mac & Desktop Web (>1024px) or Condensed Tablet (768px-1024px): 2-column Row
    if (isDesktop || isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 6, child: copy),
          SizedBox(width: isDesktop ? 32 : 20),
          Expanded(flex: 5, child: orbit),
        ],
      );
    }

    // iOS & Android Mobile (<768px): Avatar with floating badges ON TOP (centered),
    // typography ("Adarsh Gupta") and buttons BELOW (centered).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: orbit),
        const SizedBox(height: 24),
        copy,
      ],
    );
  }

  Widget _buildScrollIndicator(AerospacePalette palette) {
    return AnimatedBuilder(
      animation: _scrollHintController,
      builder: (context, _) {
        final dy = _scrollHintController.value * 5.0;
        return GestureDetector(
          onTap: () => _scrollToSection('About'),
          child: Column(
            children: [
              Container(
                width: 24,
                height: 38,
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: palette.hairline),
                ),
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 7),
                child: Transform.translate(
                  offset: Offset(0, dy),
                  child: Container(
                    width: 4,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AerospaceTheme.accentScarlet,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'SCROLL',
                style: TextStyle(
                  fontSize: 9.5,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w700,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(AerospacePalette palette) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 900
            ? 4
            : (constraints.maxWidth >= 340 ? 2 : 1);
        final gap = cols == 2 && constraints.maxWidth < 480 ? 12.0 : 16.0;
        final compactCard = constraints.maxWidth < 480;

        return EqualHeightCardGrid(
          columns: cols,
          spacing: gap,
          runSpacing: gap,
          children: PortfolioData.stats.map((stat) {
            return HoverLiftCard(
              padding: EdgeInsets.all(compactCard ? 14 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        stat.icon,
                        size: compactCard ? 18 : 20,
                        color: AerospaceTheme.accentScarlet,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          stat.value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: compactCard ? 24 : 30,
                            fontWeight: FontWeight.w800,
                            color: palette.textPrimary,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stat.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stat.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAboutSection(AerospacePalette palette, bool isDesktop) {
    final narrative = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PortfolioData.aboutBio,
          style: TextStyle(
            fontSize: 14.5,
            height: 1.7,
            color: palette.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: palette.hairline),
            boxShadow: palette.cardShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 3.5,
                height: 44,
                decoration: BoxDecoration(
                  color: AerospaceTheme.accentScarlet,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  '"Code should solve real problems; design should spark effortless emotion—and architecture binds them together."',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    height: 1.55,
                    color: palette.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () => launchExternalLink(
            context,
            PortfolioData.resumeUrl,
            emptyMessage:
                'Resume PDF link ready — attach URL in PortfolioData.resumeUrl',
          ),
          icon: const Icon(Icons.description_outlined, size: 18),
          label: const Text('Download Resume'),
        ),
      ],
    );

    final highlights = Column(
      children: PortfolioData.aboutHighlights.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: HoverLiftCard(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AerospaceTheme.accentScarlet.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    size: 19,
                    color: AerospaceTheme.accentScarlet,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.tag,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: AerospaceTheme.accentScarlet,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: item.pills
                            .map((p) => _SkillTagChip(label: p))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('01. // ABOUT ME'),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: 'Passionate about ',
            style: TextStyle(
              fontSize: isDesktop ? 34 : 26,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
              letterSpacing: -0.7,
            ),
            children: const [
              TextSpan(
                text: 'building things',
                style: TextStyle(
                  color: AerospaceTheme.accentScarlet,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(text: ' that matter to real users.'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: narrative),
              const SizedBox(width: 28),
              Expanded(flex: 5, child: highlights),
            ],
          )
        else ...[
          narrative,
          const SizedBox(height: 24),
          highlights,
        ],
      ],
    );
  }

  Widget _buildSkillsSection(AerospacePalette palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('02. // SKILLS'),
        const SizedBox(height: 8),
        Text(
          'My Tech Stack',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth >= 960
                ? 4
                : (constraints.maxWidth >= 560 ? 2 : 1);
            const gap = 16.0;

            return EqualHeightCardGrid(
              columns: cols,
              spacing: gap,
              runSpacing: gap,
              children: PortfolioData.skillCategories.map((cat) {
                return HoverLiftCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AerospaceTheme.accentScarlet
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          cat.icon,
                          size: 18,
                          color: AerospaceTheme.accentScarlet,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        cat.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat.subtitle,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.5,
                          color: palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: cat.skills
                            .map((s) => _SkillTagChip(label: s))
                            .toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCredentialsSection(AerospacePalette palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('03. // EXPERIENCE & CREDENTIALS'),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: 'Work History & ',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
              letterSpacing: -0.6,
            ),
            children: const [
              TextSpan(
                text: 'Certifications',
                style: TextStyle(
                  color: AerospaceTheme.accentScarlet,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Verified industry credentials, engineering milestones, and real-world project engagements.',
          style: TextStyle(fontSize: 14, color: palette.textSecondary),
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth >= 780 ? 2 : 1;
            const gap = 18.0;

            return EqualHeightCardGrid(
              columns: cols,
              spacing: gap,
              runSpacing: gap,
              children: PortfolioData.credentials.map((cred) {
                final hasCertificate = cred.certificateAsset != null ||
                    (cred.certificateUrl?.isNotEmpty ?? false);
                return HoverLiftCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AerospaceTheme.accentScarlet
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    cred.icon,
                                    size: 20,
                                    color: AerospaceTheme.accentScarlet,
                                  ),
                                ),
                                StatusPill(
                                  label: cred.status,
                                  dotColor: AerospaceTheme.accentGreen,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            cred.badge,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: AerospaceTheme.accentScarlet,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cred.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: palette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cred.organization,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            cred.description,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.55,
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: cred.tags
                                .map((t) => _SkillTagChip(label: t))
                                .toList(),
                          ),
                        ],
                      ),
                      if (hasCertificate)
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: _buildCertificateButton(
                            url: cred.certificateUrl ?? '',
                            assetPath: cred.certificateAsset,
                            title: cred.title,
                            subtitle: '${cred.organization} • ${cred.status}',
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildJourneySection(AerospacePalette palette, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('04. // JOURNEY'),
        const SizedBox(height: 8),
        Text(
          'My Journey & Milestones',
          style: TextStyle(
            fontSize: isCompact ? 26 : 30,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 24),
        Column(
          children: PortfolioData.milestones.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.only(top: 18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item.isCurrent
                              ? AerospaceTheme.accentScarlet
                              : palette.surface,
                          border: Border.all(
                            color: AerospaceTheme.accentScarlet,
                            width: 2.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: isCompact ? 10 : 16),
                  Expanded(
                    child: HoverLiftCard(
                      padding: EdgeInsets.all(isCompact ? 16 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 6,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: palette.textPrimary,
                                ),
                              ),
                              StatusPill(
                                label: item.period,
                                dotColor: item.isCurrent
                                    ? AerospaceTheme.accentScarlet
                                    : AerospaceTheme.accentGreen,
                                subtleBackground: item.isCurrent,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.institution,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.description,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.55,
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: item.tags
                                .map((t) => _SkillTagChip(label: t))
                                .toList(),
                          ),
                          if (item.certificateLabel != null &&
                              (item.certificateAsset != null ||
                                  (item.certificateUrl?.isNotEmpty ?? false))) ...[
                            const SizedBox(height: 14),
                            _buildCertificateButton(
                              url: item.certificateUrl ?? '',
                              assetPath: item.certificateAsset,
                              label: item.certificateLabel!,
                              title: item.title,
                              subtitle: '${item.institution} • ${item.period}',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _showCertificatePreviewDialog({
    required String title,
    required String subtitle,
    required String assetPath,
    String? externalUrl,
  }) async {
    final palette = AerospacePalette.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: palette.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: palette.hairline),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: palette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11.5,
                                color: palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close Certificate',
                        onPressed: () => Navigator.of(dialogCtx).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: palette.hairline),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InteractiveViewer(
                          minScale: 1.0,
                          maxScale: 3.0,
                          child: Image.asset(
                            assetPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (externalUrl != null && externalUrl.isNotEmpty) ...[
                        OutlinedButton.icon(
                          onPressed: () => launchExternalLink(
                            dialogCtx,
                            externalUrl,
                          ),
                          icon: const Icon(Icons.open_in_new_rounded, size: 15),
                          label: const Text('Open Link'),
                        ),
                        const SizedBox(width: 10),
                      ],
                      FilledButton(
                        onPressed: () => Navigator.of(dialogCtx).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCertificateButton({
    required String url,
    String? assetPath,
    String label = 'View Certificate',
    String title = 'Certificate of Completion',
    String subtitle = '',
  }) {
    return OutlinedButton.icon(
      onPressed: () {
        if (assetPath != null && assetPath.isNotEmpty) {
          _showCertificatePreviewDialog(
            title: title,
            subtitle: subtitle,
            assetPath: assetPath,
            externalUrl: url,
          );
          return;
        }
        launchExternalLink(
          context,
          url,
          emptyMessage: 'Certificate link ready — attach URL in PortfolioData',
        );
      },
      icon: const Icon(Icons.north_east_rounded, size: 15),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildProjectsSection(AerospacePalette palette) {
    final filtered = PortfolioData.projectsForCategory(_selectedProjectCategory);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('05. // PROJECTS'),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.end,
          runSpacing: 14,
          spacing: 16,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Things I've Built",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cross-platform apps, AI integrations, and real-time mobile architectures.',
                  style: TextStyle(fontSize: 14, color: palette.textSecondary),
                ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: widget.onOpenAllProjects,
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('Open Full Gallery'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PortfolioData.projectCategories.map((category) {
            final selected = _selectedProjectCategory == category;
            final count = PortfolioData.countProjectsInCategory(category);
            return ChoiceChip(
              label: Text('$category ($count)'),
              selected: selected,
              onSelected: (_) {
                setState(() => _selectedProjectCategory = category);
              },
              selectedColor: AerospaceTheme.accentScarlet,
              backgroundColor: palette.surface,
              side: BorderSide(
                color: selected
                    ? AerospaceTheme.accentScarlet
                    : palette.hairline,
              ),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : palette.textSecondary,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth >= 780 ? 2 : 1;
            const gap = 20.0;

            return EqualHeightCardGrid(
              columns: cols,
              spacing: gap,
              runSpacing: gap,
              children: filtered.map((project) {
                return PortfolioProjectCard(
                  project: project,
                  onLiveDemo: () => launchExternalLink(
                    context,
                    PortfolioData.demoRequestMailto(project.title),
                    fallbackCopyValue: PortfolioData.email,
                  ),
                  onSecondaryAction: () => launchExternalLink(
                    context,
                    PortfolioData.githubUrl,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContactSection(AerospacePalette palette, bool isDesktop) {
    final channels = Column(
      children: [
        _ContactInfoCard(
          icon: Icons.email_outlined,
          label: 'DIRECT EMAIL',
          value: PortfolioData.email,
          onTap: () => launchExternalLink(
            context,
            PortfolioData.mailtoUri,
            fallbackCopyValue: PortfolioData.email,
          ),
        ),
        const SizedBox(height: 12),
        _ContactInfoCard(
          icon: Icons.phone_outlined,
          label: 'PHONE / WHATSAPP',
          value: PortfolioData.phone,
          onTap: () => launchExternalLink(
            context,
            PortfolioData.telUri,
            fallbackCopyValue: PortfolioData.phone,
          ),
        ),
        const SizedBox(height: 12),
        _ContactInfoCard(
          icon: Icons.work_outline_rounded,
          label: 'LINKEDIN PROFILE',
          value: PortfolioData.linkedinDisplayHandle,
          onTap: () => launchExternalLink(context, PortfolioData.linkedinUrl),
        ),
        const SizedBox(height: 12),
        _ContactInfoCard(
          icon: Icons.code_rounded,
          label: 'GITHUB REPOSITORIES',
          value: PortfolioData.githubDisplayHandle,
          onTap: () => launchExternalLink(context, PortfolioData.githubUrl),
        ),
      ],
    );

    final isCompactForm = MediaQuery.sizeOf(context).width < 520;
    final formCard = HoverLiftCard(
      padding: EdgeInsets.all(isCompactForm ? 18 : 24),
      child: Form(
        key: _contactFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _messageCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Message',
                alignLabelWithHint: true,
              ),
              validator: (v) => (v == null || v.trim().length < 6)
                  ? 'Please enter a short message'
                  : null,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSendingContact ? null : _submitContactForm,
                icon: _isSendingContact
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 17),
                label: Text(_isSendingContact ? 'Sending...' : 'Send Message'),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('06. // CONTACT'),
        const SizedBox(height: 8),
        Text(
          "Let's Work Together",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Have a project in mind or looking for a Flutter & UI/UX Engineer? Send a quick message below.',
          style: TextStyle(fontSize: 14, color: palette.textSecondary),
        ),
        const SizedBox(height: 24),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: channels),
              const SizedBox(width: 24),
              Expanded(flex: 6, child: formCard),
            ],
          )
        else ...[
          channels,
          const SizedBox(height: 20),
          formCard,
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.3,
        color: AerospaceTheme.accentScarlet,
      ),
    );
  }
}

class _SkillTagChip extends StatelessWidget {
  final String label;

  const _SkillTagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: palette.isDark
            ? AerospaceTheme.surfaceDarkElevated
            : palette.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.hairline),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: palette.textSecondary,
        ),
      ),
    );
  }
}

class _ConnectIconBox extends StatelessWidget {
  final IconData? icon;
  final String? customSymbol;
  final String tooltip;
  final VoidCallback onTap;

  const _ConnectIconBox({
    this.icon,
    this.customSymbol,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.hairline),
          ),
          child: customSymbol != null
              ? Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: palette.textPrimary,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    customSymbol!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      letterSpacing: -0.4,
                      color: palette.textPrimary,
                    ),
                  ),
                )
              : Icon(icon, size: 18, color: palette.textPrimary),
        ),
      ),
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    return HoverLiftCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AerospaceTheme.accentScarlet.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AerospaceTheme.accentScarlet),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.north_east_rounded,
            size: 16,
            color: palette.textSecondary,
          ),
        ],
      ),
    );
  }
}
