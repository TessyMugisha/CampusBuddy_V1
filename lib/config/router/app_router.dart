import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import screens
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/assignments/assignments_screen.dart';
import '../../presentation/screens/courses/courses_screen.dart';
import '../../presentation/screens/dining/dining_screen.dart';
import '../../presentation/screens/events/events_screen.dart';
import '../../presentation/screens/map/map_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/schedule/schedule_screen.dart';
import '../../presentation/screens/transit/transit_screen.dart';
import '../../presentation/screens/courses/course_detail_screen.dart';
import '../../presentation/screens/events/event_detail_screen.dart';

/// AppRouter handles all navigation in the app using GoRouter
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// Creates the GoRouter instance with all routes
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // Splash screen as initial route
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      
      // Main app shell with nested routes
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          // Home tab
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          
          // Events tab
          GoRoute(
            path: '/events',
            builder: (context, state) => const EventsScreen(),
          ),
          // Event details
          GoRoute(
            path: '/events/:id',
            builder: (context, state) => EventDetailScreen(
              eventId: state.pathParameters['id'] ?? '',
            ),
          ),
          
          // Courses tab
          GoRoute(
            path: '/courses',
            builder: (context, state) => const CoursesScreen(),
          ),
          // Course details
          GoRoute(
            path: '/courses/:id',
            builder: (context, state) => CourseDetailScreen(
              courseId: state.pathParameters['id'] ?? '',
            ),
          ),
          
          // Map tab
          GoRoute(
            path: '/map',
            builder: (context, state) => const MapScreen(),
          ),
          
          // Schedule tab
          GoRoute(
            path: '/schedule',
            builder: (context, state) => const ScheduleScreen(),
          ),
          
          // Assignments tab
          GoRoute(
            path: '/assignments',
            builder: (context, state) => const AssignmentsScreen(),
          ),
          GoRoute(
            path: '/dining',
            builder: (context, state) => const DiningScreen(),
          ),
          GoRoute(
            path: '/transit',
            builder: (context, state) => const TransitScreen(),
          ),
          // Profile tab
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
}

/// Scaffold with bottom navigation bar for the main app shell
class ScaffoldWithBottomNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithBottomNavBar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ScaffoldWithBottomNavBar> createState() => _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int _currentIndex = 0;

  static const List<_BottomNavItem> _bottomNavItems = [
    _BottomNavItem(
      icon: Icons.home,
      label: 'Home',
      initialLocation: '/home',
    ),
    _BottomNavItem(
      icon: Icons.event,
      label: 'Events',
      initialLocation: '/events',
    ),
    _BottomNavItem(
      icon: Icons.school,
      label: 'Courses',
      initialLocation: '/courses',
    ),
    _BottomNavItem(
      icon: Icons.map,
      label: 'Map',
      initialLocation: '/map',
    ),
    _BottomNavItem(
      icon: Icons.person,
      label: 'Profile',
      initialLocation: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _goOtherTab(context, index);
        },
        items: _bottomNavItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
  
  void _goOtherTab(BuildContext context, int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    context.go(_bottomNavItems[index].initialLocation);
  }
}

class _BottomNavItem {
  final IconData icon;
  final String label;
  final String initialLocation;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.initialLocation,
  });
}
