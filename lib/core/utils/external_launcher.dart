import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches external HTTP/HTTPS URLs, mailto, and tel URIs cleanly across Web, macOS, iOS, and Android.
Future<void> launchExternalLink(
  BuildContext context,
  String rawUrl, {
  String? fallbackCopyValue,
  String? emptyMessage,
}) async {
  final trimmed = rawUrl.trim();
  if (trimmed.isEmpty) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(emptyMessage ?? 'Link ready — attach URL in PortfolioData.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  final uri = Uri.parse(trimmed);
  final isDirectScheme = uri.scheme == 'mailto' || uri.scheme == 'tel';

  try {
    final launched = await launchUrl(
      uri,
      mode: isDirectScheme
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
      webOnlyWindowName: isDirectScheme ? '_self' : '_blank',
    );
    if (launched) return;
  } catch (_) {
    // Fall through to graceful fallback notification below.
  }

  if (!context.mounted) return;
  final copyTarget = fallbackCopyValue ?? trimmed;
  await Clipboard.setData(ClipboardData(text: copyTarget));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Copied $copyTarget to clipboard'),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
