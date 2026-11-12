import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:adarsh_portfolio/core/theme/aerospace_theme.dart';
import 'package:adarsh_portfolio/features/not_found/presentation/not_found_screen.dart';
import 'package:adarsh_portfolio/features/portfolio/presentation/portfolio_home_screen.dart';
import 'package:adarsh_portfolio/features/profile/presentation/follow_me_screen.dart';
import 'package:adarsh_portfolio/features/projects/presentation/all_projects_screen.dart';
import 'package:adarsh_portfolio/features/splash/presentation/boot_splash_screen.dart';

void main() {
  runApp(const AdarshPortfolioApp());
}

/// Enables touch, mouse, stylus, and trackpad drag scrolling across Mac, Web, iOS, and Android.
class _CrossPlatformScrollBehavior extends MaterialScrollBehavior {
  const _CrossPlatformScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

/// Root Aerospace Modernist Material 3 Flutter application.
class AdarshPortfolioApp extends StatefulWidget {
  final bool showSplashOnLaunch;

  const AdarshPortfolioApp({
    super.key,
    this.showSplashOnLaunch = true,
  });

  @override
  State<AdarshPortfolioApp> createState() => _AdarshPortfolioAppState();
}

class _AdarshPortfolioAppState extends State<AdarshPortfolioApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final ValueNotifier<bool> _bootFinished;
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _bootFinished = ValueNotifier<bool>(!widget.showSplashOnLaunch);
  }

  @override
  void dispose() {
    _bootFinished.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _completeBoot() {
    if (!_bootFinished.value && mounted) {
      _bootFinished.value = true;
    }
  }

  void _navigateHome() {
    _navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (r) => false);
  }

  void _navigateToContact() {
    _navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/',
      (r) => false,
      arguments: 'Contact',
    );
  }

  void _navigateTo(String route) {
    _navigatorKey.currentState?.pushNamed(route);
  }

  PageRoute<void> _animatedRoute(RouteSettings settings, Widget page) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Adarsh Portfolio',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _CrossPlatformScrollBehavior(),
      themeMode: _themeMode,
      theme: AerospaceTheme.lightTheme(),
      darkTheme: AerospaceTheme.darkTheme(),
      themeAnimationDuration: const Duration(milliseconds: 300),
      themeAnimationCurve: Curves.easeInOutCubic,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            final initialSection = settings.arguments as String?;
            return _animatedRoute(
              settings,
              ValueListenableBuilder<bool>(
                valueListenable: _bootFinished,
                builder: (context, finished, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 520),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: finished
                        ? PortfolioHomeScreen(
                            key: ValueKey('home_${initialSection ?? 'top'}'),
                            initialSection: initialSection,
                            onToggleTheme: _toggleTheme,
                            onOpenFollowMe: () => _navigateTo('/follow'),
                            onOpenAllProjects: () => _navigateTo('/projects'),
                            onOpen404Demo: () => _navigateTo('/unknown_widget'),
                          )
                        : BootSplashScreen(
                            key: const ValueKey('boot_splash'),
                            onComplete: _completeBoot,
                          ),
                  );
                },
              ),
            );
          case '/follow':
            return _animatedRoute(
              settings,
              FollowMeScreen(
                onToggleTheme: _toggleTheme,
                onBackHome: _navigateHome,
                onOpenProjects: () => _navigateTo('/projects'),
                onOpenContact: _navigateToContact,
              ),
            );
          case '/projects':
            return _animatedRoute(
              settings,
              AllProjectsScreen(
                onToggleTheme: _toggleTheme,
                onBackHome: _navigateHome,
                onOpenFollowMe: () => _navigateTo('/follow'),
                onOpenContact: _navigateToContact,
              ),
            );
          default:
            return _animatedRoute(
              settings,
              NotFoundScreen(
                routeName: settings.name ?? '/unknown_widget',
                onTakeMeHome: _navigateHome,
                onBackToProjects: () => _navigateTo('/projects'),
                onContactMe: _navigateToContact,
              ),
            );
        }
      },
      onUnknownRoute: (settings) {
        return _animatedRoute(
          settings,
          NotFoundScreen(
            routeName: settings.name ?? '/unknown_widget',
            onTakeMeHome: _navigateHome,
            onBackToProjects: () => _navigateTo('/projects'),
            onContactMe: _navigateToContact,
          ),
        );
      },
    );
  }
}
