// lib/navigation/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_state.dart';
import '../providers/providers.dart';
import '../utils/logger.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/testimonials/testimonials_screen.dart';
import '../screens/features/features_screen.dart';
import '../screens/expense/expense_form_screen.dart';
import '../screens/error/error_screen.dart';

// Router provider with refresh listening
final routerProvider = Provider<GoRouter>((ref) {
  final logger = ref.read(loggerProvider);
  final router = RouterNotifier(ref, logger);

  return GoRouter(
    refreshListenable: router,
    redirect: router.redirect,
    routes: router.routes,
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error.toString(),
    ),
    debugLogDiagnostics: true,
    initialLocation: '/home',
  );
});

class RouterNotifier extends ChangeNotifier {
  final Ref ref;
  final Logger logger;
  bool isAuthenticated = false;

  RouterNotifier(this.ref, this.logger) {
    ref.listen(authProvider, (previous, next) {
      final wasAuthenticated = previous?.isAuthenticated ?? false;
      final isNowAuthenticated = next.isAuthenticated;

      if (wasAuthenticated != isNowAuthenticated) {
        isAuthenticated = isNowAuthenticated;
        notifyListeners();
      }
    });
  }

  String? redirect(BuildContext context, GoRouterState state) {
    logger.debug('Router redirect: ${state.uri.path}, Auth: $isAuthenticated');

    final isLoading = ref.read(authProvider).isLoading;
    if (isLoading) return null;

    final isLoginRoute = state.uri.path == '/login';
    final isRegisterRoute = state.uri.path == '/register';
    final isAuthRoute = isLoginRoute || isRegisterRoute;

    // If not authenticated and trying to access protected route
    if (!isAuthenticated && !isAuthRoute) {
      logger.info('Redirecting to login: Not authenticated');
      return '/login';
    }

    // If authenticated and trying to access auth routes
    if (isAuthenticated && isAuthRoute) {
      logger.info('Redirecting to home: Already authenticated');
      return '/home';
    }

    logger.debug('No redirect needed for ${state.uri.path}');
    return null;
  }

  List<RouteBase> get routes => [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) =>  LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) =>  RegisterScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) =>  HomeScreen(),
        ),
        GoRoute(
          path: '/analytics',
          name: 'analytics',
          builder: (context, state) =>  AnalyticsScreen(),
        ),
        GoRoute(
          path: '/testimonials',
          name: 'testimonials',
          builder: (context, state) =>  TestimonialsScreen(),
        ),
        GoRoute(
          path: '/features',
          name: 'features',
          builder: (context, state) =>  FeaturesScreen(),
        ),
        GoRoute(
          path: '/expense',
          name: 'addExpense',
          builder: (context, state) =>  ExpenseFormScreen(),
        ),
        GoRoute(
          path: '/expense/:id',
          name: 'editExpense',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            if (id == null) {
              logger.error('Missing expense ID in route parameters');
              throw const RouteException('Missing expense ID');
            }
            return ExpenseFormScreen(expenseId: id);
          },
        ),
      ],
    ),
  ];
}

class ScaffoldWithNav extends ConsumerStatefulWidget {
  final Widget child;
  
  const ScaffoldWithNav({super.key, required this.child});

  @override
  ConsumerState<ScaffoldWithNav> createState() => _ScaffoldWithNavState();
}

class _ScaffoldWithNavState extends ConsumerState<ScaffoldWithNav> {
  static const _navigationItems = [
    NavigationItem(
      path: '/home',
      icon: Icons.home,
      label: 'Home',
    ),
    NavigationItem(
      path: '/analytics',
      icon: Icons.analytics,
      label: 'Analytics',
    ),
    NavigationItem(
      path: '/testimonials',
      icon: Icons.star,
      label: 'Testimonials',
    ),
    NavigationItem(
      path: '/features',
      icon: Icons.featured_play_list,
      label: 'Features',
    ),
  ];

  String get currentLocation => GoRouterState.of(context).uri.path;

  void _handleNavigation(String location) {
    if (location != currentLocation) {
      ref.read(loggerProvider).debug('Navigating to: $location');
      context.go(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 800;
    final logger = ref.read(loggerProvider);

    logger.debug('Building ScaffoldWithNav, width: $screenWidth');

    return Scaffold(
      body: Row(
        children: [
          NavigationRailTheme(
            data: NavigationRailThemeData(
              labelType: isWideScreen 
                  ? NavigationRailLabelType.none 
                  : NavigationRailLabelType.selected,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: NavigationRail(
                extended: isWideScreen,
                minExtendedWidth: 200,
                selectedIndex: _calculateSelectedIndex(),
                onDestinationSelected: _onItemTapped,
                leading: isWideScreen
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Expense Tracker',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
                destinations: _navigationItems
                    .map((item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          label: Text(item.label),
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex() {
    return _navigationItems
        .indexWhere((item) => item.path == currentLocation)
        .clamp(0, _navigationItems.length - 1);
  }

  void _onItemTapped(int index) {
    if (index >= 0 && index < _navigationItems.length) {
      _handleNavigation(_navigationItems[index].path);
    }
  }
}

class NavigationItem {
  final String path;
  final IconData icon;
  final String label;

  const NavigationItem({
    required this.path,
    required this.icon,
    required this.label,
  });
}

class RouteException implements Exception {
  final String message;
  
  const RouteException(this.message);
  
  @override
  String toString() => message;
}