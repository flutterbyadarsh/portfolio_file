import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/aerospace_theme.dart';

/// Glassmorphic floating pill badge as featured in Adarsh's Aerospace Modernist UI.
class GlassmorphicBadge extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isDarkMode;

  const GlassmorphicBadge({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode
        ? const Color(0xCC0D1C32)
        : const Color(0xE6FFFFFF);

    final borderColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.22)
        : const Color(0xFFE2E8F0);

    final titleColor = isDarkMode
        ? AerospaceTheme.textPrimaryDark
        : AerospaceTheme.textPrimaryLight;

    final subtitleColor = isDarkMode
        ? AerospaceTheme.textSecondaryDark
        : AerospaceTheme.textSecondaryLight;

    final shadows = isDarkMode
        ? AerospaceTheme.floatingBadgeShadowDark
        : AerospaceTheme.floatingBadgeShadowLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9999),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: shadows,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                leading,
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: subtitleColor,
                        ),
                      ),
                    ],
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
