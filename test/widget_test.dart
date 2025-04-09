// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import 'package:campus_buddy/main.dart';
import 'package:campus_buddy/presentation/screens/splash/splash_screen.dart';
import 'package:campus_buddy/presentation/screens/auth/login_screen.dart';
import 'package:campus_buddy/presentation/screens/home/home_screen.dart';
import 'package:campus_buddy/logic/blocs/auth/auth_bloc.dart';
import 'package:campus_buddy/logic/blocs/courses/courses_bloc.dart';
import 'package:campus_buddy/presentation/blocs/events/events_bloc.dart';
import 'package:campus_buddy/domain/usecases/events_usecase.dart';

// Mock class for AuthBloc
class MockAuthBloc extends Mock implements AuthBloc {}

// Mock class for CoursesBloc
class MockCoursesBloc extends Mock implements CoursesBloc {}

// Mock class for EventsBloc
class MockEventsBloc extends Mock implements EventsBloc {}

// Mock class for EventsUseCase
class MockEventsUseCase extends Mock implements EventsUseCase {}

void main() {
  group('CampusBuddy App Tests', () {
    late AuthBloc authBloc;
    late CoursesBloc coursesBloc;
    late EventsBloc eventsBloc;
    late EventsUseCase eventsUseCase;

    setUp(() {
      eventsUseCase = EventsUseCase();
      authBloc = AuthBloc();
      coursesBloc = CoursesBloc();
      eventsBloc = EventsBloc(eventsUseCase);
    });

    tearDown(() {
      authBloc.close();
      coursesBloc.close();
      eventsBloc.close();
    });

    testWidgets('Login screen renders correctly', (WidgetTester tester) async {
      // Create a test app with MultiBlocProvider and GoRouter
      final testApp = MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<CoursesBloc>.value(value: coursesBloc),
          BlocProvider<EventsBloc>.value(value: eventsBloc),
        ],
        child: MaterialApp(
          home: const LoginScreen(),
        ),
      );

      // Build our test app and trigger a frame
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify that login form elements are present
      final emailField = find.byKey(const Key('loginEmailField'));
      final passwordField = find.byKey(const Key('loginPasswordField'));
      final loginButton = find.byKey(const Key('loginButton'));

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);

      // Enter credentials
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      // Tap the login button
      await tester.tap(loginButton);
      await tester.pump();

      // Verify that the AuthBloc received the LoggedIn event
      // This is a simplified test - in a real test, you would use mockito to verify
      // that the bloc received the correct event
    });

    testWidgets('Home screen renders correctly', (WidgetTester tester) async {
      // Set a larger surface size to avoid overflow errors
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      // Create a test app with MultiBlocProvider and GoRouter starting at the home route
      final testApp = MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<CoursesBloc>.value(value: coursesBloc),
          BlocProvider<EventsBloc>.value(value: eventsBloc),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/home',
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
        ),
      );

      // Build our test app and trigger a frame
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify that we're on the home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      // Verify that the app bar is present with the title 'Home'
      expect(find.text('Home'), findsOneWidget);

      // Verify that the welcome message is displayed
      expect(find.text('Welcome back, Student!'), findsOneWidget);

      // Reset the window size
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}
