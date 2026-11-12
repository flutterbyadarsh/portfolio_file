import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:adarsh_portfolio/core/utils/contact_form_service.dart';
import 'package:adarsh_portfolio/features/hero/presentation/hero_orbit_view.dart';
import 'package:adarsh_portfolio/features/portfolio/data/portfolio_data.dart';
import 'package:adarsh_portfolio/main.dart';

void main() {
  testWidgets(
      'Mobile (<768px): Avatar on top, Adarsh Gupta below, 48px touch targets, clears status bar',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    tester.view.padding = const FakeViewPadding(top: 48);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetPadding();
    });

    await tester.pumpWidget(const AdarshPortfolioApp());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('SYS_BOOT // V3.24'), findsOneWidget);

    // Complete boot splash sequence
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pump(const Duration(milliseconds: 600));

    // AppBar clears 48px status bar
    final menuRect = tester.getRect(find.byTooltip('Open Menu'));
    expect(menuRect.top, greaterThanOrEqualTo(48.0));

    // Both header logo and Hero heading render "Adarsh Gupta" without period
    final titleFinder = find.text('Adarsh Gupta', findRichText: true);
    expect(titleFinder, findsNWidgets(2));
    expect(find.text('PUNE & NOIDA, INDIA (IST)'), findsOneWidget);
    expect(find.text('Flutter Developer'), findsAtLeastNWidgets(1));
    expect(find.text(PortfolioData.heroBio), findsOneWidget);
    expect(find.text('★ 8.4 CGPA'), findsOneWidget);
    expect(find.text('in'), findsOneWidget);
    expect(find.byIcon(Icons.share_outlined), findsNothing);

    // Mobile order: HeroOrbitView sits ABOVE Hero "Adarsh Gupta" heading
    final heroTitleFinder = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: titleFinder,
    );
    final orbitRect = tester.getRect(find.byType(HeroOrbitView));
    final heroTitleRect = tester.getRect(heroTitleFinder);
    expect(orbitRect.top, lessThan(heroTitleRect.top));

    // Touch targets >= 48px height
    final techSkillsBtn = find.ancestor(
      of: find.text('Tech Skills'),
      matching: find.byWidgetPredicate((w) => w is FilledButton),
    );
    final viewProjectsBtn = find.ancestor(
      of: find.text('View Projects'),
      matching: find.byWidgetPredicate((w) => w is OutlinedButton),
    );
    await tester.ensureVisible(techSkillsBtn);
    expect(tester.getRect(techSkillsBtn).height, greaterThanOrEqualTo(48.0));
    expect(tester.getRect(viewProjectsBtn).height, greaterThanOrEqualTo(48.0));

    // Toggle theme cleanly
    await tester.tap(find.byTooltip('Switch to Light Mode'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(find.byTooltip('Switch to Dark Mode'), findsOneWidget);
  });

  testWidgets('Tablet (768px-1024px): Condensed 2-column layout with 15% reduced typography',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(820, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const AdarshPortfolioApp(showSplashOnLaunch: false));
    await tester.pump(const Duration(milliseconds: 600));

    final heroTitleFinder = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.text('Adarsh Gupta', findRichText: true),
    );
    final orbitFinder = find.byType(HeroOrbitView);
    expect(heroTitleFinder, findsOneWidget);
    expect(orbitFinder, findsOneWidget);

    // 2-column side-by-side placement
    expect(
      tester.getRect(orbitFinder).left,
      greaterThan(tester.getRect(heroTitleFinder).left),
    );

    // 15% font reduction on tablet (54 * 0.85 = 45.9)
    final richText = tester.widget<RichText>(heroTitleFinder);
    final rootSpan = richText.text as TextSpan;
    final innerSpan = rootSpan.children!.first as TextSpan;
    expect(innerSpan.style?.fontSize, closeTo(45.9, 0.01));
  });

  testWidgets('Compact 320px slide drawer navigates across all screens', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    tester.view.padding = const FakeViewPadding(top: 36);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetPadding();
    });

    await tester.pumpWidget(const AdarshPortfolioApp(showSplashOnLaunch: false));
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.byTooltip('Open Menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('PORTFOLIO SECTIONS'), findsOneWidget);

    await tester.drag(find.text('PORTFOLIO SECTIONS'), const Offset(0, -240));
    await tester.pump();
    expect(find.text('All Projects'), findsOneWidget);
    expect(find.text('Follow Me'), findsOneWidget);

    await tester.tap(find.text('All Projects'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();
    expect(find.text('INDEX REV. 2026.4'), findsOneWidget);

    await tester.tap(find.byTooltip('Open Menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.drag(find.text('PORTFOLIO SECTIONS'), const Offset(0, -240));
    await tester.pump();
    await tester.tap(find.text('Follow Me'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();
    expect(find.text('CHANNELS & ECOSYSTEM'), findsOneWidget);
    expect(find.textContaining(PortfolioData.email), findsOneWidget);
  });

  testWidgets('Desktop (>1024px): Split 2-column Hero & all routes render properly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const AdarshPortfolioApp(showSplashOnLaunch: false));
    await tester.pump(const Duration(milliseconds: 600));

    // Split 2-column Hero on Desktop
    final heroTitleFinder = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.text('Adarsh Gupta', findRichText: true),
    );
    final orbitFinder = find.byType(HeroOrbitView);
    expect(
      tester.getRect(orbitFinder).left,
      greaterThan(tester.getRect(heroTitleFinder).left),
    );

    // Tech Skills button scrolls to #skills section
    await tester.tap(find.text('Tech Skills'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 650));
    expect(find.text('02. // SKILLS'), findsOneWidget);

    // Open Follow Me screen
    final followBtn = find.text('Follow me');
    await tester.ensureVisible(followBtn);
    await tester.pump();
    await tester.tap(followBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('CHANNELS & ECOSYSTEM'), findsOneWidget);

    // Return home
    await tester.tap(find.text('BACK TO PORTFOLIO'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();
    expect(find.text('01. // ABOUT ME'), findsOneWidget);

    // Open All Projects screen and verify dynamic category filter counts
    final projectsBtn = find.text('View Projects');
    await tester.ensureVisible(projectsBtn);
    await tester.pump();
    await tester.tap(projectsBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();
    expect(find.text('INDEX REV. 2026.4'), findsOneWidget);
    expect(find.text('ALL (9)'), findsOneWidget);
    expect(find.text('MOBILE APPS (8)'), findsOneWidget);
    expect(find.text('AI INTEGRATIONS (1)'), findsOneWidget);
    expect(find.text('Todo App'), findsOneWidget);
    expect(find.text('Profile Page App'), findsOneWidget);
    expect(find.text('Currency Converter App'), findsOneWidget);
    expect(find.text('E-Commerce Shoes App'), findsOneWidget);
    await tester.tap(find.text('AI INTEGRATIONS (1)'));
    await tester.pump();
    expect(find.text('AI Intern Assessment App'), findsOneWidget);
    expect(find.text('Weather App'), findsNothing);

    // Initiate Contact scrolls straight to the Contact section
    final initContactBtn = find.text('Initiate Contact');
    await tester.ensureVisible(initContactBtn);
    await tester.pump();
    await tester.tap(initContactBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 700));
    final contactLabelRect = tester.getRect(find.text('06. // CONTACT'));
    expect(contactLabelRect.top, lessThan(900.0));
    expect(contactLabelRect.bottom, greaterThan(0.0));

    // Verify Stats, About Resume, Journey Certificates, Projects tabs, and Contact Form

    expect(find.text('2+'), findsOneWidget);
    expect(find.text('50+'), findsOneWidget);

    final downloadResumeBtn = find.text('Download Resume');
    await tester.ensureVisible(downloadResumeBtn);
    await tester.pump();
    expect(downloadResumeBtn, findsOneWidget);
    expect(PortfolioData.resumeUrl, endsWith('/Adarsh_Gupta_Resume.pdf'));

    expect(find.text('Tutedude'), findsAtLeastNWidgets(2));
    expect(find.text('Ongoing UI/UX Design Program'), findsAtLeastNWidgets(2));

    final certButtons = find.text('View Certificate');
    await tester.ensureVisible(certButtons.first);
    await tester.pump();
    expect(certButtons, findsNWidgets(2));
    await tester.tap(certButtons.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byTooltip('Close Certificate'), findsOneWidget);
    await tester.tap(find.byTooltip('Close Certificate'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(Dialog), findsNothing);

    final aiTab = find.text('AI Integrations (1)');
    await tester.ensureVisible(aiTab);
    await tester.pump();
    expect(find.text('All (9)'), findsOneWidget);
    expect(find.text('Mobile Apps (8)'), findsOneWidget);
    expect(
      PortfolioData.projects.where((p) => p.repoUrl != null).length,
      6,
    );
    expect(
      PortfolioData.projects.any((p) =>
          p.title.toLowerCase().contains('money') ||
          p.title.toLowerCase().contains('auth')),
      isFalse,
    );
    await tester.tap(aiTab);
    await tester.pump();
    expect(find.text('AI Intern Assessment App'), findsOneWidget);
    expect(find.text('TrackFlow'), findsNothing);

    expect(find.text(PortfolioData.email), findsOneWidget);
    expect(find.text(PortfolioData.phone), findsOneWidget);
    expect(find.text(PortfolioData.linkedinDisplayHandle), findsOneWidget);
    expect(find.text(PortfolioData.githubDisplayHandle), findsOneWidget);
    expect(PortfolioData.leetcodeUrl, 'https://leetcode.com/u/codebyadarsh02/');
    final nameField = find.widgetWithText(TextFormField, 'Name');
    await tester.ensureVisible(nameField);
    await tester.pump();
    expect(nameField, findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Message'), findsOneWidget);
    expect(find.text('Send Message'), findsOneWidget);

    // Open 404 route demo
    final demo404 = find.text('404 Route View');
    await tester.ensureVisible(demo404);
    await tester.pump();
    await tester.tap(demo404);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();
    expect(find.text('404'), findsOneWidget);
    expect(find.text('Take Me Home'), findsOneWidget);
  });

  test('ContactFormService posts JSON to endpoint and handles activation/fallback',
      () async {
    late Map<String, dynamic> capturedBody;
    final okClient = MockClient((request) async {
      capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        jsonEncode({'success': 'true', 'message': 'Submitted'}),
        200,
      );
    });

    final okResult = await ContactFormService.sendMessage(
      name: 'Recruiter',
      senderEmail: 'hire@company.com',
      message: 'Let us schedule a Flutter interview.',
      client: okClient,
      submittedAt: DateTime.utc(2026, 11, 12, 8, 33),
    );
    expect(okResult.sent, isTrue);
    expect(capturedBody['name'], 'Recruiter');
    expect(capturedBody['_replyto'], 'hire@company.com');
    expect(capturedBody['_captcha'], 'false');
    expect(
      capturedBody['Submitted Time (IST)'],
      '12 Nov 2026, 02:03 PM IST (UTC+05:30)',
    );
    expect(
      capturedBody['submittedAtIst'],
      '12 Nov 2026, 02:03 PM IST (UTC+05:30)',
    );

    final resendClient = MockClient((_) async {
      return http.Response(
        jsonEncode({'ok': true, 'id': 're_test_123'}),
        200,
      );
    });
    final resendResult = await ContactFormService.sendMessage(
      name: 'Adarsh',
      senderEmail: 'visitor@example.com',
      message: 'Resend serverless check',
      client: resendClient,
    );
    expect(resendResult.sent, isTrue);

    final activateClient = MockClient(
      (_) async => http.Response(
        jsonEncode({
          'success': 'false',
          'message': 'This form needs Activation. Check your inbox.',
        }),
        200,
      ),
    );
    final activateResult = await ContactFormService.sendMessage(
      name: 'Recruiter',
      senderEmail: 'hire@company.com',
      message: 'Hello Adarsh',
      client: activateClient,
    );
    expect(activateResult.sent, isFalse);
    expect(activateResult.needsActivation, isTrue);
    expect(activateResult.fallbackMailtoUri, startsWith('mailto:${PortfolioData.email}'));

    final failClient = MockClient((_) async => http.Response('Error', 500));
    final failResult = await ContactFormService.sendMessage(
      name: 'Recruiter',
      senderEmail: 'hire@company.com',
      message: 'Hello Adarsh',
      client: failClient,
    );
    expect(failResult.sent, isFalse);
    expect(failResult.needsActivation, isFalse);
    expect(failResult.fallbackMailtoUri, contains('Hello%20Adarsh'));
  });
}
