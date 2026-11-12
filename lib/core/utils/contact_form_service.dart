import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:adarsh_portfolio/features/portfolio/data/portfolio_data.dart';

/// Result returned after attempting to submit the portfolio contact form.
class ContactSubmitResult {
  final bool sent;
  final bool needsActivation;
  final String message;
  final String fallbackMailtoUri;

  const ContactSubmitResult({
    required this.sent,
    this.needsActivation = false,
    required this.message,
    required this.fallbackMailtoUri,
  });
}

/// Sends portfolio contact form messages over HTTPS via Formspree or FormSubmit,
/// returning a pre-filled mailto fallback if offline or pending activation.
class ContactFormService {
  ContactFormService._();

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Formats any instant into India Standard Time (UTC+05:30), e.g.
  /// `12 Nov 2026, 02:03 PM IST (UTC+05:30)`.
  static String formatIstTimestamp([DateTime? instant]) {
    final ist = (instant ?? DateTime.now()).toUtc().add(
          const Duration(hours: 5, minutes: 30),
        );
    final day = ist.day.toString().padLeft(2, '0');
    final month = _months[ist.month - 1];
    final year = ist.year;
    final hour12 = ist.hour % 12 == 0 ? 12 : ist.hour % 12;
    final hourStr = hour12.toString().padLeft(2, '0');
    final minuteStr = ist.minute.toString().padLeft(2, '0');
    final period = ist.hour >= 12 ? 'PM' : 'AM';
    return '$day $month $year, $hourStr:$minuteStr $period IST (UTC+05:30)';
  }

  static Future<ContactSubmitResult> sendMessage({
    required String name,
    required String senderEmail,
    required String message,
    http.Client? client,
    DateTime? submittedAt,
  }) async {
    final submittedIst = formatIstTimestamp(submittedAt);
    final fallbackMailto = PortfolioData.contactMailto(
      name: name,
      senderEmail: senderEmail,
      message: message,
    );
    final httpClient = client ?? http.Client();
    final shouldCloseClient = client == null;

    try {
      final endpoint = PortfolioData.activeContactEndpoint;
      final response = await httpClient
          .post(
            Uri.parse(endpoint),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'email': senderEmail,
              'message': message,
              'submittedAtIst': submittedIst,
              'Submitted Time (IST)': submittedIst,
              '_subject': 'Portfolio Contact from $name',
              '_replyto': senderEmail,
              '_template': 'table',
              '_captcha': 'false',
            }),
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final parsed = _tryDecodeMap(response.body);
        final success = parsed?['success'];
        final serverMsg = (parsed?['message'] ?? '').toString();

        if (success == true ||
            success == 'true' ||
            parsed?['ok'] == true ||
            PortfolioData.formspreeEndpoint.trim().isNotEmpty) {
          return ContactSubmitResult(
            sent: true,
            message:
                'Message sent to ${PortfolioData.email}! Thanks for reaching out, $name.',
            fallbackMailtoUri: fallbackMailto,
          );
        }

        if (serverMsg.toLowerCase().contains('activat')) {
          return ContactSubmitResult(
            sent: false,
            needsActivation: true,
            message:
                'Check ${PortfolioData.email} once to activate web form delivery, or open your email app to send now.',
            fallbackMailtoUri: fallbackMailto,
          );
        }
      }
    } catch (_) {
      // Network error or blocked host — fall back cleanly to email client.
    } finally {
      if (shouldCloseClient) {
        httpClient.close();
      }
    }

    return ContactSubmitResult(
      sent: false,
      message: 'Opening your email app to send directly to ${PortfolioData.email}.',
      fallbackMailtoUri: fallbackMailto,
    );
  }

  static Map<String, dynamic>? _tryDecodeMap(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }
}
