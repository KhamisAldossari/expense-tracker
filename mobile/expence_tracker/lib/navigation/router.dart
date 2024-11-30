// lib/navigation/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/testimonials/testimonials_screen.dart';
import '../screens/features/features_screen.dart';
import '../screens/expense/expense_form_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    redirect: (context, state) {
      final isAuth = ref.read(authProvider).value != null;
      final isLoginRoute = state.uri.path == '/login';
      final isRegisterRoute = state.uri.path == '/register';

      if (!isAuth && !isLoginRoute && !isRegisterRoute) return '/login';
      if (isAuth && (isLoginRoute || isRegisterRoute)) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNav(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/testimonials',
            builder: (context, state) => const TestimonialsScreen(),
          ),
          GoRoute(
            path: '/features',
            builder: (context, state) => const FeaturesScreen(),
          ),
          GoRoute(
            path: '/expense',
            name: 'addExpense',
            builder: (context, state) => const ExpenseFormScreen(),
          ),
          GoRoute(
            path: '/expense/:id',
            name: 'editExpense',
            builder: (context, state) => ExpenseFormScreen(
              expenseId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
    ],
  );
});

class ScaffoldWithNav extends ConsumerStatefulWidget {
  final Widget child;
  
  const ScaffoldWithNav({super.key, required this.child});

  @override
  ConsumerState<ScaffoldWithNav> createState() => _ScaffoldWithNavState();
}

class _ScaffoldWithNavState extends ConsumerState<ScaffoldWithNav> {
  String currentLocation = '/home';

  void _handleNavigation(String location) {
    if (location != currentLocation) {
      setState(() => currentLocation = location);
      context.go(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 800;

    return Scaffold(
      body: Row(
        children: [
          Container(
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
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.analytics),
                  label: Text('Analytics'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.star),
                  label: Text('Testimonials'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.featured_play_list),
                  label: Text('Features'),
                ),
              ],
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
    switch (currentLocation) {
      case '/analytics':
        return 1;
      case '/testimonials':
        return 2;
      case '/features':
        return 3;
      default:
        return 0;
    }
  }

  void _onItemTapped(int index) {
    final locations = [
      '/home',
      '/analytics',
      '/testimonials',
      '/features',
    ];
    _handleNavigation(locations[index]);
  }
}