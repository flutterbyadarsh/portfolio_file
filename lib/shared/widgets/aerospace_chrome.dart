import 'package:flutter/material.dart';
import 'package:adarsh_portfolio/core/theme/aerospace_theme.dart';
import 'package:adarsh_portfolio/features/portfolio/data/portfolio_data.dart';

/// Subtle architectural blueprint grid + atmospheric radial glow behind screens.
class BlueprintGridBackground extends StatelessWidget {
  final Widget child;

  const BlueprintGridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _BlueprintGridPainter(isDark: palette.isDark),
          ),
        ),
        Positioned(
          top: -120,
          right: -120,
          child: IgnorePointer(
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AerospaceTheme.accentScarlet
                        .withValues(alpha: palette.isDark ? 0.14 : 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -140,
          left: -120,
          child: IgnorePointer(
            child: Container(
              width: 460,
              height: 460,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (palette.isDark
                            ? const Color(0xFF1D4ED8)
                            : AerospaceTheme.navyPrimary)
                        .withValues(alpha: palette.isDark ? 0.12 : 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _BlueprintGridPainter extends CustomPainter {
  final bool isDark;

  const _BlueprintGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const step = 48.0;
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.03)
          : AerospaceTheme.navyPrimary.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BlueprintGridPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

/// Interactive Material 3 surface card with subtle hover lift and scarlet rim.
class HoverLiftCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const HoverLiftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 16,
    this.onTap,
    this.backgroundColor,
  });

  @override
  State<HoverLiftCard> createState() => _HoverLiftCardState();
}

class _HoverLiftCardState extends State<HoverLiftCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    final baseColor = widget.backgroundColor ?? palette.surface;

    return MouseRegion(
      cursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _hovered
                  ? AerospaceTheme.accentScarlet.withValues(alpha: 0.45)
                  : palette.hairline,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: (palette.isDark
                              ? Colors.black
                              : AerospaceTheme.navyPrimary)
                          .withValues(alpha: palette.isDark ? 0.35 : 0.10),
                      offset: const Offset(0, 10),
                      blurRadius: 24,
                      spreadRadius: -4,
                    ),
                  ]
                : palette.cardShadow,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Responsive multi-column grid that keeps every card in the same row equal height.
class EqualHeightCardGrid extends StatelessWidget {
  final int columns;
  final double spacing;
  final double runSpacing;
  final List<Widget> children;

  const EqualHeightCardGrid({
    super.key,
    required this.columns,
    required this.spacing,
    required this.runSpacing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    if (columns <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: runSpacing),
            children[i],
          ],
        ],
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < children.length; i += columns) {
      if (i > 0) rows.add(SizedBox(height: runSpacing));
      final rowChildren = <Widget>[];
      for (int c = 0; c < columns; c++) {
        if (c > 0) rowChildren.add(SizedBox(width: spacing));
        final idx = i + c;
        rowChildren.add(
          Expanded(
            child: idx < children.length
                ? children[idx]
                : const SizedBox.shrink(),
          ),
        );
      }
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rowChildren,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

/// Smooth initial entrance animation (fade + vertical slide).
class FadeSlideReveal extends StatelessWidget {
  final Widget child;
  final int delayMs;
  final double offsetY;

  const FadeSlideReveal({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.offsetY = 18,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 450 + delayMs.clamp(0, 500)),
      curve: Curves.easeOutCubic,
      builder: (context, value, widgetChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, offsetY * (1 - value)),
            child: widgetChild,
          ),
        );
      },
      child: child,
    );
  }
}

/// Status indicator pill with optional pulsing green/red beacon dot.
class StatusPill extends StatelessWidget {
  final String label;
  final Color dotColor;
  final bool subtleBackground;

  const StatusPill({
    super.key,
    required this.label,
    this.dotColor = AerospaceTheme.accentScarlet,
    this.subtleBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: subtleBackground
            ? dotColor.withValues(alpha: palette.isDark ? 0.14 : 0.08)
            : palette.surface,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: subtleBackground
              ? dotColor.withValues(alpha: 0.28)
              : palette.hairline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: subtleBackground ? dotColor : palette.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared Material 3 top navigation bar (safe-area aware for mobile status bars
/// and notches) plus slide-out [AerospaceSlideDrawer] integration.
class AerospaceNavbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onToggleTheme;
  final void Function(String section)? onNavigateSection;
  final VoidCallback onOpenFollowMe;
  final VoidCallback onOpenContact;
  final VoidCallback onBrandTap;
  final VoidCallback? onOpenAllProjects;
  final String? activeSection;

  const AerospaceNavbar({
    super.key,
    required this.onToggleTheme,
    required this.onOpenFollowMe,
    required this.onOpenContact,
    required this.onBrandTap,
    this.onNavigateSection,
    this.onOpenAllProjects,
    this.activeSection,
  });

  static const List<String> navItems = [
    'About',
    'Skills',
    'Experience',
    'Journey',
    'Projects',
    'Contact',
  ];

  static IconData sectionIcon(String section) {
    switch (section) {
      case 'About':
        return Icons.person_outline_rounded;
      case 'Skills':
        return Icons.code_rounded;
      case 'Experience':
        return Icons.workspace_premium_outlined;
      case 'Journey':
        return Icons.timeline_rounded;
      case 'Projects':
        return Icons.grid_view_rounded;
      case 'Contact':
        return Icons.mail_outline_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 1024;
    final isCompact = width < 380;

    final brandLogo = InkWell(
      onTap: onBrandTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text.rich(
          TextSpan(
            text: 'Adarsh ',
            style: TextStyle(
              fontSize: isCompact ? 17 : 20,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(
                text: 'Gupta',
                style: TextStyle(
                  color: AerospaceTheme.accentScarlet,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      titleSpacing: 0,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: palette.canvas.withValues(alpha: 0.96),
      surfaceTintColor: Colors.transparent,
      shape: Border(bottom: BorderSide(color: palette.hairline)),
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 36 : (isCompact ? 12 : 16),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1220),
            child: Row(
              children: [
                if (!isDesktop) ...[
                  Builder(
                    builder: (scaffoldContext) {
                      return IconButton(
                        tooltip: 'Open Menu',
                        onPressed: () {
                          final scaffoldState =
                              Scaffold.maybeOf(scaffoldContext);
                          if (scaffoldState?.hasDrawer ?? false) {
                            scaffoldState!.openDrawer();
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: palette.surface,
                          fixedSize: const Size(36, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: palette.hairline),
                          ),
                        ),
                        icon: Icon(
                          Icons.menu_rounded,
                          size: 19,
                          color: palette.textPrimary,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: isCompact ? 8 : 12),
                ],
                if (isDesktop)
                  brandLogo
                else
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: brandLogo,
                      ),
                    ),
                  ),
                if (isDesktop && onNavigateSection != null)
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: navItems.map((item) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: TextButton(
                                onPressed: () => onNavigateSection!(item),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                  foregroundColor: activeSection == item
                                      ? AerospaceTheme.accentScarlet
                                      : palette.textSecondary,
                                ),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: activeSection == item
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
                else if (isDesktop)
                  const Spacer(),
                const SizedBox(width: 8),
                // Light / Dark Mode Toggle (Material 3 IconButton)
                IconButton(
                  tooltip: palette.isDark
                      ? 'Switch to Light Mode'
                      : 'Switch to Dark Mode',
                  onPressed: onToggleTheme,
                  style: IconButton.styleFrom(
                    backgroundColor: palette.surface,
                    fixedSize: const Size(36, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: palette.hairline),
                    ),
                  ),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      palette.isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      key: ValueKey(palette.isDark),
                      size: 18,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                SizedBox(width: isCompact ? 6 : 10),
                if (width >= 600) ...[
                  FilledButton(
                    onPressed: onOpenContact,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(48, 44),
                      backgroundColor: palette.isDark
                          ? AerospaceTheme.accentScarlet
                          : AerospaceTheme.navyPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text('Get in Touch'),
                  ),
                  const SizedBox(width: 10),
                ],
                // Avatar trigger to open Follow Me card
                Tooltip(
                  message: 'Open Profile Card (Follow Me)',
                  child: InkWell(
                    onTap: onOpenFollowMe,
                    borderRadius: BorderRadius.circular(9999),
                    child: const _ProfileCircleAvatar(size: 36, borderWidth: 1.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Material 3 slide-in navigation drawer containing all AppBar links, routes, and theme switch.
class AerospaceSlideDrawer extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final void Function(String section)? onNavigateSection;
  final VoidCallback onOpenFollowMe;
  final VoidCallback onOpenContact;
  final VoidCallback? onOpenAllProjects;
  final VoidCallback? onOpen404Demo;
  final String? activeSection;

  const AerospaceSlideDrawer({
    super.key,
    required this.onToggleTheme,
    required this.onOpenFollowMe,
    required this.onOpenContact,
    this.onNavigateSection,
    this.onOpenAllProjects,
    this.onOpen404Demo,
    this.activeSection,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);

    return Drawer(
      backgroundColor: palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
              decoration: BoxDecoration(
                color: palette.isDark
                    ? AerospaceTheme.canvasDark
                    : palette.surfaceElevated,
                border: Border(bottom: BorderSide(color: palette.hairline)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _ProfileCircleAvatar(size: 46, borderWidth: 2),
                      IconButton(
                        tooltip: 'Close Menu',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Adarsh Gupta',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Flutter Developer • Clean Architecture',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const StatusPill(
                    label: 'AVAILABLE FOR HIRE',
                    dotColor: AerospaceTheme.accentGreen,
                  ),
                ],
              ),
            ),

            // Scrollable Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                children: [
                  if (onNavigateSection != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 6),
                      child: Text(
                        'PORTFOLIO SECTIONS',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: palette.textSecondary,
                        ),
                      ),
                    ),
                    ...AerospaceNavbar.navItems.map((item) {
                      final isActive = activeSection == item;
                      return _DrawerNavTile(
                        icon: AerospaceNavbar.sectionIcon(item),
                        label: item,
                        isActive: isActive,
                        onTap: () {
                          Navigator.of(context).pop();
                          onNavigateSection!(item);
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    Divider(color: palette.hairline, height: 1),
                    const SizedBox(height: 12),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 6),
                    child: Text(
                      'SCREENS & PROFILE',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                  if (onOpenAllProjects != null)
                    _DrawerNavTile(
                      icon: Icons.apps_rounded,
                      label: 'All Projects',
                      onTap: () {
                        Navigator.of(context).pop();
                        onOpenAllProjects!();
                      },
                    ),
                  _DrawerNavTile(
                    icon: Icons.badge_outlined,
                    label: 'Follow Me',
                    onTap: () {
                      Navigator.of(context).pop();
                      onOpenFollowMe();
                    },
                  ),
                  if (onOpen404Demo != null)
                    _DrawerNavTile(
                      icon: Icons.terminal_rounded,
                      label: '404 Route View',
                      onTap: () {
                        Navigator.of(context).pop();
                        onOpen404Demo!();
                      },
                    ),
                  const SizedBox(height: 8),
                  Divider(color: palette.hairline, height: 1),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    secondary: Icon(
                      palette.isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: AerospaceTheme.accentScarlet,
                    ),
                    title: Text(
                      palette.isDark ? 'Dark Theme' : 'Light Theme',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    value: palette.isDark,
                    activeThumbColor: AerospaceTheme.accentScarlet,
                    onChanged: (_) => onToggleTheme(),
                  ),
                ],
              ),
            ),

            // Drawer Bottom CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onOpenContact();
                  },
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('Get in Touch'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerNavTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: isActive
              ? AerospaceTheme.accentScarlet.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isActive
              ? const Border(
                  left: BorderSide(
                    color: AerospaceTheme.accentScarlet,
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? AerospaceTheme.accentScarlet
                  : palette.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? palette.textPrimary : palette.textSecondary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: palette.textSecondary.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCircleAvatar extends StatelessWidget {
  final double size;
  final double borderWidth;

  const _ProfileCircleAvatar({
    required this.size,
    this.borderWidth = 1.8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AerospaceTheme.navyPrimary,
        border: Border.all(
          color: AerospaceTheme.accentScarlet,
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          PortfolioData.profileImageAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                'AG',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.34,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Shared bottom footer matching the UI/UX design across all screens.
class AerospaceFooter extends StatelessWidget {
  final VoidCallback? onScrollTop;
  final VoidCallback? onOpen404Demo;

  const AerospaceFooter({
    super.key,
    this.onScrollTop,
    this.onOpen404Demo,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AerospacePalette.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: palette.isDark ? AerospaceTheme.surfaceDark : palette.surface,
        border: Border(top: BorderSide(color: palette.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Wrap(
              alignment:
                  isWide ? WrapAlignment.spaceBetween : WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                Text(
                  '© 2026 Adarsh Gupta • Crafted with Precision & Flutter Material 3',
                  textAlign: isWide ? TextAlign.start : TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: palette.textSecondary),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onOpen404Demo != null) ...[
                      TextButton(
                        onPressed: onOpen404Demo,
                        child: Text(
                          '404 Route View',
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (onScrollTop != null)
                      InkWell(
                        onTap: onScrollTop,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: palette.surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: palette.hairline),
                          ),
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            size: 18,
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
