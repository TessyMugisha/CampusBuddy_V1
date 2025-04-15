import 'package:flutter/material.dart';

import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/emergency_screen.dart';
import '../presentation/screens/directory_screen.dart';
import '../presentation/screens/dining_screen.dart';
import '../presentation/screens/events_screen.dart';
import '../presentation/screens/map/map_screen.dart';
import '../presentation/screens/map/enhanced_map_screen.dart';
import '../presentation/screens/profile_screen.dart';
import '../presentation/screens/chat/campus_oracle_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String emergency = '/emergency';
  static const String directory = '/directory';
  static const String dining = '/dining';
  static const String events = '/events';
  static const String map = '/map';
  static const String enhancedMap = '/enhanced-map';
  static const String profile = '/profile';
  static const String campusOracle = '/campus-oracle';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case emergency:
        return MaterialPageRoute(builder: (_) => EmergencyScreen());
      case directory:
        return MaterialPageRoute(builder: (_) => DirectoryScreen());
      case dining:
        return MaterialPageRoute(builder: (_) => DiningScreen());
      case events:
        return MaterialPageRoute(builder: (_) => EventsScreen());
      case map:
        return MaterialPageRoute(builder: (_) => MapScreen());
      case enhancedMap:
        final args = settings.arguments as Map<String, dynamic>?;
        final initialLocationId = args?['locationId'] as String?;
        return MaterialPageRoute(
          builder: (_) =>
              EnhancedMapScreen(initialLocationId: initialLocationId),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case campusOracle:
        return MaterialPageRoute(builder: (_) => CampusOracleScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
