import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/skills_screen.dart';
import 'screens/softskills_screen.dart';
import 'screens/domains_screen.dart';
import 'screens/timeslot_screen.dart';
import 'screens/video_screen.dart';
import 'screens/guidelines_screen.dart';
import 'screens/final_report_screen.dart';
import 'widgets/nav_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider auth) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: auth,
    redirect: (context, state) {
      final isLogin = state.matchedLocation == '/login';
      final isHome = state.matchedLocation == '/';

      if (!auth.isLoggedIn && !isLogin && !isHome) {
        return '/login';
      }
      if (auth.isLoggedIn && (isLogin || isHome)) {
        return '/skills';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (_, __, child) => NavShell(child: child),
        routes: [
          GoRoute(
            path: '/skills',
            pageBuilder: (_, __) => const NoTransitionPage(child: SkillsScreen()),
          ),
          GoRoute(
            path: '/softskills',
            pageBuilder: (_, __) => const NoTransitionPage(child: SoftSkillsScreen()),
          ),
          GoRoute(
            path: '/select-domain',
            pageBuilder: (_, __) => const NoTransitionPage(child: DomainsScreen()),
          ),
          GoRoute(
            path: '/timeslot',
            pageBuilder: (_, __) => const NoTransitionPage(child: TimeSlotScreen()),
          ),
          GoRoute(
            path: '/guidelines',
            pageBuilder: (_, __) => const NoTransitionPage(child: GuidelinesScreen()),
          ),
          GoRoute(
            path: '/final-report',
            pageBuilder: (_, __) => const NoTransitionPage(child: FinalReportScreen()),
          ),
          GoRoute(
            path: '/video',
            pageBuilder: (_, __) => const NoTransitionPage(child: VideoScreen()),
          ),
        ],
      ),
    ],
  );
}
