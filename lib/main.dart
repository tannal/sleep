// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/tracking_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/history_screen.dart';
import 'screens/log_sleep_screen.dart';
import 'screens/sleep_detail_screen.dart';
import 'screens/reminders_screen.dart';
import 'models/sleep_record.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primary,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await dotenv.load(fileName: '.env');  // 加这行，在 Supabase.initialize 之前

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: SleepTrackerApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isAuth = session != null;
    final isAuthRoute = state.matchedLocation == '/auth';
    if (!isAuth && !isAuthRoute) return '/auth';
    if (isAuth && isAuthRoute) return '/';
    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/tracking', builder: (_, __) => const TrackingScreen()),
        GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),
    GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
    GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
    GoRoute(
      path: '/log',
      builder: (_, state) =>
          LogSleepScreen(existing: state.extra as SleepRecord?),
    ),
    GoRoute(
      path: '/sleep/:id',
      builder: (_, state) =>
          SleepDetailScreen(recordId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/reminders', builder: (_, __) => const RemindersScreen()),
  ],
);

class SleepTrackerApp extends StatelessWidget {
  const SleepTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '睡眠精灵',
      theme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    switch (location) {
      case '/': return 0;
      case '/tracking': return 1;
      case '/analytics': return 2;
      case '/profile': return 3;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: _currentIndex(context),
        onTap: (i) {
          switch (i) {
            case 0: context.go('/'); break;
            case 1: context.go('/tracking'); break;
            case 2: context.go('/analytics'); break;
            case 3: context.go('/profile'); break;
          }
        },
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const _FloatingNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.accent.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: '首页', isActive: currentIndex == 0, onTap: () => onTap(0)),
            _NavItem(icon: Icons.bedtime_outlined, activeIcon: Icons.bedtime_rounded, label: '追踪', isActive: currentIndex == 1, onTap: () => onTap(1), isCenter: true),
            _NavItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart_rounded, label: '分析', isActive: currentIndex == 2, onTap: () => onTap(2)),
            _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: '我的', isActive: currentIndex == 3, onTap: () => onTap(3)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final bool isActive, isCenter;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.isActive, required this.onTap, this.isCenter = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isCenter && isActive ? 10 : 6),
              decoration: BoxDecoration(
                gradient: isCenter && isActive ? AppColors.sleepScoreGradient : null,
                color: !isCenter && isActive ? AppColors.accent.withOpacity(0.15) : null,
                borderRadius: BorderRadius.circular(isCenter ? 16 : 10),
                boxShadow: isCenter && isActive ? [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))] : null,
              ),
              child: Icon(isActive ? activeIcon : icon, color: isActive ? (isCenter ? Colors.white : AppColors.accent) : AppColors.textMuted, size: isCenter ? 24 : 22),
            ),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontFamily: 'Sora', fontSize: 10, color: isActive ? AppColors.accent : AppColors.textMuted, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
