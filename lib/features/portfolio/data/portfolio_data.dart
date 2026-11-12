import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class StatMetric {
  final String value;
  final String title;
  final String subtitle;
  final IconData icon;

  const StatMetric({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class AboutHighlight {
  final String tag;
  final String title;
  final String subtitle;
  final List<String> pills;
  final IconData icon;

  const AboutHighlight({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.pills,
    required this.icon,
  });
}

class SkillCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> skills;

  const SkillCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.skills,
  });
}

class CredentialItem {
  final String badge;
  final String status;
  final String title;
  final String organization;
  final String description;
  final List<String> tags;
  final IconData icon;
  final String? certificateUrl;
  final String? certificateAsset;

  const CredentialItem({
    required this.badge,
    required this.status,
    required this.title,
    required this.organization,
    required this.description,
    required this.tags,
    required this.icon,
    this.certificateUrl,
    this.certificateAsset,
  });
}

class JourneyMilestone {
  final String period;
  final String title;
  final String institution;
  final String description;
  final List<String> tags;
  final bool isCurrent;
  final String? certificateLabel;
  final String? certificateUrl;
  final String? certificateAsset;

  const JourneyMilestone({
    required this.period,
    required this.title,
    required this.institution,
    required this.description,
    required this.tags,
    this.isCurrent = false,
    this.certificateLabel,
    this.certificateUrl,
    this.certificateAsset,
  });
}

enum ProjectVisualStyle {
  trackFlow,
  connectCall,
  aiAssessment,
  weatherApp,
  favouritePlace,
  todoApp,
  profilePage,
  currencyConvert,
  shoesApp,
}

class ProjectItem {
  final String title;
  final String category;
  final String badge;
  final String version;
  final String description;
  final List<String> tags;
  final String secondaryActionLabel;
  final ProjectVisualStyle visualStyle;
  final String? repoUrl;

  const ProjectItem({
    required this.title,
    required this.category,
    required this.badge,
    required this.version,
    required this.description,
    required this.tags,
    required this.secondaryActionLabel,
    required this.visualStyle,
    this.repoUrl,
  });
}

class SocialChannelItem {
  final String title;
  final String handle;
  final String url;
  final IconData icon;

  const SocialChannelItem({
    required this.title,
    required this.handle,
    required this.url,
    required this.icon,
  });
}

class PortfolioData {
  PortfolioData._();

  static const String profileImageAsset = 'assets/images/adarsh_profile.jpg';
  static const String email = 'dev.adarshgupta@gmail.com';
  static const String mailtoUri = 'mailto:dev.adarshgupta@gmail.com';
  static const String phone = '+91 9137425943';
  static const String telUri = 'tel:+919137425943';
  static const String location = 'PUNE & NOIDA, INDIA (IST)';
  static const String portfolioUrl = 'https://adarshgupta.info';
  static const String profileShareUrl = 'https://adarshgupta.info/#/follow';

  static const String shareMessage =
      'Connect with Adarsh Gupta — Flutter Developer & Mobile Architect:\nhttps://adarshgupta.info';

  static String get whatsappShareUrl =>
      'https://api.whatsapp.com/send?text=${Uri.encodeComponent(shareMessage)}';

  static String get telegramShareUrl =>
      'https://t.me/share/url?url=${Uri.encodeComponent(portfolioUrl)}&text=${Uri.encodeComponent("Adarsh Gupta — Flutter Developer Portfolio")}';

  static String get twitterShareUrl =>
      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent("Check out Adarsh Gupta portfolio:")}&url=${Uri.encodeComponent(portfolioUrl)}';

  static String get linkedinShareUrl =>
      'https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(portfolioUrl)}';

  // Social & Profile URLs (swap in exact handles/PDF links anytime)
  static const String githubDisplayHandle = 'github.com/flutterbyadarsh';
  static const String githubUrl = 'https://github.com/flutterbyadarsh';
  static const String linkedinDisplayHandle = 'linkedin.com/in/adarsh-gupta-b850903b8';
  static const String linkedinUrl = 'https://www.linkedin.com/in/adarsh-gupta-b850903b8';
  static const String leetcodeDisplayHandle = 'leetcode.com/u/codebyadarsh02';
  static const String leetcodeUrl = 'https://leetcode.com/u/codebyadarsh02/';
  static const String twitterUrl = 'https://x.com/';
  static const String instagramUrl = 'https://instagram.com/';
  static const String resumePdfPath = '/Adarsh_Gupta_Resume.pdf';

  /// Hosted resume PDF URL on the active web origin, falling back to live domain.
  static String get resumeUrl {
    if (kIsWeb && Uri.base.scheme.startsWith('http')) {
      return '${Uri.base.origin}$resumePdfPath';
    }
    return 'https://adarshgupta.info$resumePdfPath';
  }
  static const String uiuxCertificateUrl = '';
  static const String flutterCertificateUrl = '';
  static const String flutterCertificateAsset =
      'assets/images/tutedude_flutter_certificate.jpg';
  static const String flutterCertificateId = 'TD-ADAR-FL-0910';

  /// Deployed Vercel Serverless Function URL backed by Resend (`https://<app>.vercel.app/api/contact`).
  static const String resendVercelEndpoint =
      'https://portfolio-send-message.vercel.app/api/contact';

  /// Optional Formspree endpoint if preferred over FormSubmit fallback.
  static const String formspreeEndpoint = '';

  static String get activeContactEndpoint {
    if (resendVercelEndpoint.trim().isNotEmpty) {
      return resendVercelEndpoint.trim();
    }
    if (formspreeEndpoint.trim().isNotEmpty) {
      return formspreeEndpoint.trim();
    }
    return 'https://formsubmit.co/ajax/$email';
  }

  /// Builds a pre-filled mailto URI from the contact form fields.
  static String contactMailto({
    required String name,
    required String senderEmail,
    required String message,
  }) {
    final subject = Uri.encodeComponent('Portfolio Contact from $name');
    final body = Uri.encodeComponent(
      'Name: $name\nEmail: $senderEmail\n\n$message\n',
    );
    return 'mailto:$email?subject=$subject&body=$body';
  }

  /// Builds a pre-filled mailto URI to request a live demo for a project.
  static String demoRequestMailto(String projectTitle) {
    final subject = Uri.encodeComponent('Live Demo Request - $projectTitle');
    final body = Uri.encodeComponent(
      'Hi Adarsh,\n\nI saw $projectTitle on your portfolio and would like to request a live demo.\n',
    );
    return 'mailto:$email?subject=$subject&body=$body';
  }

  static const String heroBio =
      'Crafting fluid, cross-platform mobile applications utilizing Clean Architecture. Focused on robust backend integrations with Firebase and currently exploring Supabase for scalable data solutions. Possesses foundational UI/UX knowledge to effectively bridge design and engineering.';

  static const String aboutBio =
      'I am an engineering undergraduate deeply focused on mobile development and clean software architecture. My expertise lies in crafting robust Flutter applications, utilizing modern backend solutions like Firebase and exploring Supabase. With a foundational understanding of UI/UX design, I bridge the gap between aesthetic interfaces and scalable engineering.';

  static const List<StatMetric> stats = [
    StatMetric(
      value: '2+',
      title: 'Apps Released',
      subtitle: 'Production on Play & App Stores',
      icon: Icons.rocket_launch_outlined,
    ),
    StatMetric(
      value: '8.4',
      title: 'Undergrad CGPA',
      subtitle: 'B.Tech Computer Science',
      icon: Icons.school_outlined,
    ),
    StatMetric(
      value: '50+',
      title: 'DSA Solved',
      subtitle: 'Algorithmic Problem Solving',
      icon: Icons.psychology_outlined,
    ),
    StatMetric(
      value: '99.9%',
      title: 'Crash-Free Rate',
      subtitle: 'Telemetry & Robust Unit Tests',
      icon: Icons.verified_outlined,
    ),
  ];

  static const List<AboutHighlight> aboutHighlights = [
    AboutHighlight(
      tag: 'EDUCATION',
      title: 'B.Tech Computer Science & Engineering',
      subtitle: 'Noida International University',
      pills: ['2023 - 2027', '8.4 CGPA'],
      icon: Icons.account_balance_outlined,
    ),
    AboutHighlight(
      tag: 'CORE ENGINEERING',
      title: 'Flutter Developer',
      subtitle: 'Clean Architecture • Firebase • Riverpod',
      pills: ['Riverpod', '60/120 FPS'],
      icon: Icons.phone_android_rounded,
    ),
    AboutHighlight(
      tag: 'DESIGN BRIDGE',
      title: 'Foundational UI/UX',
      subtitle: 'Material Design 3 • Figma • Responsive UI',
      pills: ['Figma', 'User Flows'],
      icon: Icons.layers_outlined,
    ),
  ];

  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      title: 'Languages',
      subtitle: 'Core programming foundations and database queries.',
      icon: Icons.code_rounded,
      skills: ['C++', 'SQL', 'Dart', 'Python'],
    ),
    SkillCategory(
      title: 'Mobile Engineering',
      subtitle: 'Cross-platform Flutter apps built on Clean Architecture.',
      icon: Icons.smartphone_rounded,
      skills: [
        'Flutter',
        'Clean Architecture',
        'Riverpod',
        'exploring BLoC',
        'Provider',
      ],
    ),
    SkillCategory(
      title: 'Backend & DB',
      subtitle: 'Firebase backends, REST APIs, and local/cloud storage.',
      icon: Icons.dns_outlined,
      skills: [
        'Firebase',
        'exploring Supabase',
        'Firestore',
        'REST APIs',
        'SQLite',
        'Hive',
        'SharedPreferences',
      ],
    ),
    SkillCategory(
      title: 'Tools',
      subtitle: 'Daily engineering IDEs, API testing, and design tools.',
      icon: Icons.handyman_outlined,
      skills: [
        'Git & GitHub',
        'Android Studio',
        'VS Code',
        'Figma',
        'Canvas',
        'Postman',
        'exploring Gemini AI Tool',
      ],
    ),
  ];

  static const List<CredentialItem> credentials = [
    CredentialItem(
      badge: 'ONGOING',
      status: 'Ongoing',
      title: 'UI/UX Internship',
      organization: 'Ongoing UI/UX Design Program',
      description:
          'Currently pursuing an intensive UI/UX program covering user flows, wireframing, Figma prototyping, and Material Design 3 component systems.',
      tags: ['Figma', 'UI/UX', 'Prototyping', 'Ongoing'],
      icon: Icons.palette_outlined,
    ),
    CredentialItem(
      badge: 'CERTIFIED',
      status: '10 Nov 2026 • ID: $flutterCertificateId',
      title: 'Flutter & Dart App Development Training',
      organization: 'Tutedude',
      description:
          'Awarded Certificate of Completion for the Tutedude Flutter course on 10th November 2026 (ID: $flutterCertificateId), covering Clean Architecture, Riverpod, Firebase integrations, and production Flutter apps.',
      tags: ['Flutter', 'Dart', 'Clean Architecture', flutterCertificateId],
      icon: Icons.flutter_dash,
      certificateAsset: flutterCertificateAsset,
      certificateUrl: flutterCertificateUrl,
    ),
  ];

  /// Reverse chronological order (Newest at Top).
  static const List<JourneyMilestone> milestones = [
    JourneyMilestone(
      period: '2023 - 2027',
      title: 'B.Tech Computer Science & Engineering',
      institution: 'Noida International University',
      description:
          'Pursuing undergraduate engineering in Computer Science with an 8.4 CGPA, focused on mobile architecture, data structures, and scalable software engineering.',
      tags: ['8.4 CGPA', 'Data Structures', 'Clean Architecture'],
      isCurrent: true,
    ),
    JourneyMilestone(
      period: '2025 - Present',
      title: 'Flutter Developer Intern & Freelance',
      institution: 'Production Mobile Engineering',
      description:
          'Successfully built a production-ready application integrated with AI features within a strict 1-week assessment deadline.',
      tags: ['Flutter', 'AI Integration', '1-Week Sprint'],
      isCurrent: true,
    ),
    JourneyMilestone(
      period: 'Ongoing',
      title: 'UI/UX Internship',
      institution: 'Ongoing UI/UX Design Program',
      description:
          'Currently pursuing an intensive UI/UX design & prototyping program focused on design systems, interactive Figma prototypes, and foundational user experience principles.',
      tags: ['Figma', 'User Flows', 'Design Systems', 'Ongoing'],
      isCurrent: true,
    ),
    JourneyMilestone(
      period: 'Completed • 10 Nov 2026',
      title: 'Flutter & Dart App Development Training',
      institution: 'Tutedude',
      description:
          'Successfully completed the Tutedude Flutter course on 10th November 2026 (Certificate ID: $flutterCertificateId), mastering Flutter, Dart, Riverpod, REST APIs, and Firebase workflows.',
      tags: ['Flutter', 'Dart', 'Riverpod', flutterCertificateId],
      certificateLabel: 'View Certificate',
      certificateAsset: flutterCertificateAsset,
      certificateUrl: flutterCertificateUrl,
    ),
    JourneyMilestone(
      period: '2021 - 2023',
      title: 'Higher Secondary Certificate (HSC)',
      institution: 'Maharashtra State Board',
      description:
          'Completed Higher Secondary education with core focus in Science and Mathematics.',
      tags: ['Science & Math', 'Maharashtra Board'],
    ),
  ];

  static const List<String> projectCategories = [
    'All',
    'Mobile Apps',
    'AI Integrations',
  ];

  static const List<ProjectItem> projects = [
    ProjectItem(
      title: 'TrackFlow',
      category: 'Mobile Apps',
      badge: 'FEATURED MOBILE PROJECT',
      version: 'v2.4.0',
      description:
          'Productivity and task management application built with Clean Architecture, Riverpod, Firebase backend, and custom calendar scheduling.',
      tags: ['Flutter', 'Clean Arch', 'Riverpod', 'Firebase'],
      secondaryActionLabel: 'Source Code',
      visualStyle: ProjectVisualStyle.trackFlow,
    ),
    ProjectItem(
      title: 'ConnectCall',
      category: 'Mobile Apps',
      badge: 'REAL-TIME RTC ENGINE',
      version: 'WebRTC P2P',
      description:
          'Real-time audio and video calling application designed for low-latency communication using Agora RTC, WebRTC protocols, and Firebase signaling.',
      tags: ['Flutter', 'WebRTC', 'Agora RTC', 'Firebase'],
      secondaryActionLabel: 'Architecture',
      visualStyle: ProjectVisualStyle.connectCall,
      repoUrl: 'https://github.com/flutterbyadarsh/connect_call',
    ),
    ProjectItem(
      title: 'AI Intern Assessment App',
      category: 'AI Integrations',
      badge: '1-WEEK ASSESSMENT SPRINT',
      version: 'AI Powered',
      description:
          'A fully functional, real-world application built with AI features, developed under a strict 1-week deadline for an internship assessment.',
      tags: ['Flutter', 'AI Features', 'Clean Arch', 'REST APIs'],
      secondaryActionLabel: 'Case Study',
      visualStyle: ProjectVisualStyle.aiAssessment,
    ),
    ProjectItem(
      title: 'Weather App',
      category: 'Mobile Apps',
      badge: 'LIVE TELEMETRY & REST API',
      version: 'Forecast UI',
      description:
          'Updated Flutter Weather App featuring live meteorological data, hourly updates, and 5-day forecasts with a clean dark UI.',
      tags: ['Flutter', 'REST APIs', 'Geolocator', 'Dark UI'],
      secondaryActionLabel: 'Source Code',
      visualStyle: ProjectVisualStyle.weatherApp,
      repoUrl: 'https://github.com/flutterbyadarsh/weather_update_v2',
    ),
    ProjectItem(
      title: 'Todo App',
      category: 'Mobile Apps',
      badge: 'FIREBASE + NOTIFICATIONS',
      version: 'Dart • Flutter',
      description:
          'Flutter-based Todo app with Firebase authentication, task management, categories, priority levels, due dates, search, filtering, and local notifications.',
      tags: ['Flutter', 'Firebase Auth', 'Local Notifications', 'Search'],
      secondaryActionLabel: 'Source Code',
      visualStyle: ProjectVisualStyle.todoApp,
      repoUrl: 'https://github.com/flutterbyadarsh/Todo_app',
    ),
    ProjectItem(
      title: 'Profile Page App',
      category: 'Mobile Apps',
      badge: 'RESPONSIVE PROFILE UI',
      version: 'SharedPrefs',
      description:
          'Modern, responsive User Profile application built with Flutter featuring clean UI/UX for displaying and editing user profiles with persistent local storage.',
      tags: ['Flutter', 'UI/UX', 'SharedPreferences', 'Responsive'],
      secondaryActionLabel: 'Source Code',
      visualStyle: ProjectVisualStyle.profilePage,
      repoUrl: 'https://github.com/flutterbyadarsh/profile_page',
    ),
    ProjectItem(
      title: 'Currency Converter App',
      category: 'Mobile Apps',
      badge: 'MULTI-CURRENCY ENGINE',
      version: 'Material UI',
      description:
          'Cross-platform currency converter mobile application designed for instant rate calculations with a crisp, intuitive Flutter Material interface.',
      tags: ['Flutter', 'Dart', 'Conversion Logic', 'Material 3'],
      secondaryActionLabel: 'Source Code',
      visualStyle: ProjectVisualStyle.currencyConvert,
      repoUrl: 'https://github.com/flutterbyadarsh/currency_convert_app',
    ),
    ProjectItem(
      title: 'E-Commerce Shoes App',
      category: 'Mobile Apps',
      badge: 'SHOPPING FLOW & CART UI',
      version: 'Sliver UI',
      description:
          'Flutter e-commerce footwear application featuring category browsing, detailed product showcases, Sliver scroll layouts, and interactive cart management.',
      tags: ['Flutter', 'Provider', 'Slivers', 'E-Commerce UI'],
      secondaryActionLabel: 'Source Code',
      visualStyle: ProjectVisualStyle.shoesApp,
      repoUrl: 'https://github.com/flutterbyadarsh/Flutter_Shoes_App',
    ),
    ProjectItem(
      title: 'Favourite Place',
      category: 'Mobile Apps',
      badge: 'NATIVE HARDWARE + DB',
      version: 'Camera + GPS',
      description:
          'Location saving app using hardware camera integration, geotagging coordinate resolution, and local SQLite persistence for offline discovery.',
      tags: ['Flutter', 'Riverpod', 'Geolocator', 'SQLite'],
      secondaryActionLabel: 'Releases',
      visualStyle: ProjectVisualStyle.favouritePlace,
    ),
  ];

  /// Computes exact count for a given category ("All", "Mobile Apps", "AI Integrations").
  static int countProjectsInCategory(String category) {
    if (category == 'All') return projects.length;
    return projects.where((p) => p.category == category).length;
  }

  /// Filters projects for the active category.
  static List<ProjectItem> projectsForCategory(String category) {
    if (category == 'All') return projects;
    return projects.where((p) => p.category == category).toList();
  }

  static const List<SocialChannelItem> channels = [
    SocialChannelItem(
      title: 'LinkedIn',
      handle: linkedinDisplayHandle,
      url: linkedinUrl,
      icon: Icons.groups_outlined,
    ),
    SocialChannelItem(
      title: 'GitHub',
      handle: githubDisplayHandle,
      url: githubUrl,
      icon: Icons.terminal_rounded,
    ),
    SocialChannelItem(
      title: 'LeetCode',
      handle: leetcodeDisplayHandle,
      url: leetcodeUrl,
      icon: Icons.data_object_rounded,
    ),
    SocialChannelItem(
      title: 'Portfolio',
      handle: 'Case Studies & Demos',
      url: 'https://adarshgupta.info',
      icon: Icons.grid_view_rounded,
    ),
    SocialChannelItem(
      title: 'Twitter / X',
      handle: 'x.com',
      url: twitterUrl,
      icon: Icons.alternate_email_rounded,
    ),
    SocialChannelItem(
      title: 'Instagram',
      handle: 'instagram.com',
      url: instagramUrl,
      icon: Icons.camera_alt_outlined,
    ),
  ];
}
