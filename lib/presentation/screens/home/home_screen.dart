import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_theme.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/news.dart';
import '../../blocs/events/events_bloc.dart';
import '../../blocs/events/events_state.dart';
import '../../blocs/events/events_event.dart';
import '../../../logic/blocs/courses/courses_bloc.dart';
import '../../widgets/animations/animated_list_item.dart' hide FadeInWidget;
import '../../components/welcome_header.dart';
import '../../widgets/cards/event_card.dart';
import '../../widgets/cards/news_card.dart';
import '../../widgets/cards/class_card.dart';
import '../../components/quick_action_grid.dart'
    show FadeInWidget, QuickActionGrid, QuickActionItem, QuickActionHeader;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Home', 'Classes', 'Events', 'News'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: FadeInWidget(
          child: Text(
            'Campus Buddy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          AnimatedTapContainer(
            onTap: () {
              // Show notifications
              _showNotificationsBottomSheet(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(Icons.notifications_outlined),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedTapContainer(
            onTap: () {
              // Show search dialog
              _showSearchDialog(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.accentColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: _tabs.map((String tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Home Tab
          RefreshIndicator(
            onRefresh: () async {
              // Refresh data
              await Future.delayed(const Duration(seconds: 1));
              // Reload events
              context.read<EventsBloc>().add(LoadEvents());
              context.read<CoursesBloc>().add(LoadCourses());
              setState(() {});
            },
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome header with personalized greeting
                  GestureDetector(
                    onTap: () {
                      context.go('/profile');
                    },
                    child: WelcomeHeader(
                      userName: 'Student',
                      showWeather: true,
                      tipText:
                          'Remember to check your upcoming assignments and exams!',
                      onNotificationTap: () =>
                          _showNotificationsBottomSheet(context),
                      weatherData: {
                        'temp': '72°F',
                        'condition': 'Sunny',
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick actions with header
                  QuickActionHeader(
                    title: 'Quick Actions',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.touch_app,
                              size: 16, color: AppTheme.primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            'Tap to access',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  QuickActionGrid(
                    crossAxisCount: 4,
                    spacing: 16,
                    items: _getQuickActionItems(),
                  ),
                  const SizedBox(height: 24),

                  // Upcoming classes with header
                  QuickActionHeader(
                    title: 'Today\'s Classes',
                    onViewAll: () {
                      context.go('/schedule');
                    },
                    viewAllText: 'View all',
                  ),
                  BlocBuilder<CoursesBloc, CoursesState>(
                    builder: (context, state) {
                      if (state is CoursesLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is CoursesLoaded) {
                        final courses = state.filteredCourses;
                        if (courses.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text('No classes today'),
                            ),
                          );
                        }

                        // Find the next class (closest to current time)
                        final now = TimeOfDay.now();
                        final currentTime = now.hour * 60 + now.minute;

                        Course? nextClass;
                        int? minTimeDiff;

                        for (final course in courses) {
                          // Default values in case we can't parse the schedule
                          int hour = 8 +
                              (course.id.hashCode %
                                  6); // Random-ish hour between 8 and 14
                          int minute = (course.name.length % 4) *
                              15; // Random-ish minute: 0, 15, 30, 45

                          // Debug information
                          print(
                              'Parsing schedule for ${course.name}: "${course.schedule}"');

                          try {
                            // Try to extract time from schedule (safely handle different formats)
                            final scheduleString = course.schedule;
                            // Look for time patterns like "10:00" or "10:00 AM"
                            final timeRegex =
                                RegExp(r'(\d+):(\d+)(?:\s*(AM|PM))?');
                            final match = timeRegex.firstMatch(scheduleString);

                            if (match != null) {
                              hour = int.parse(match.group(1)!);
                              minute = int.parse(match.group(2)!);
                              final period = match.group(3);

                              // Format minute with leading zero for debug output
                              print(
                                  '  - Parsed time: $hour:${minute.toString().padLeft(2, '0')} ${period ?? ''}');

                              // Convert to 24-hour format if we have AM/PM
                              if (period != null) {
                                if (period == 'PM' && hour < 12) {
                                  hour += 12;
                                } else if (period == 'AM' && hour == 12) {
                                  hour = 0;
                                }
                              }
                            } else {
                              print(
                                  '  - No time pattern found, using default time');
                            }
                          } catch (e) {
                            // If parsing fails, just use default values
                            print(
                                'Error parsing time from schedule: ${course.schedule}');
                            print('  - Error details: $e');
                          }

                          final classTime = hour * 60 + minute;
                          final timeDiff = classTime - currentTime;

                          // If class is in the future and closer than current next class
                          if (timeDiff > 0 &&
                              (minTimeDiff == null || timeDiff < minTimeDiff)) {
                            minTimeDiff = timeDiff;
                            nextClass = course;
                          }
                        }

                        return Column(
                          children: [
                            for (int i = 0; i < courses.length; i++)
                              ClassCard(
                                course: courses[i],
                                index: i,
                                onTap: () {
                                  // Navigate to course details with error handling
                                  try {
                                    context.go('/courses/${courses[i].id}');
                                  } catch (e) {
                                    print('Navigation error: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Could not navigate to course details')),
                                    );
                                  }
                                },
                              ),
                          ],
                        );
                      } else if (state is CoursesError) {
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      }
                      return const Center(
                        child: Text('No classes available'),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Campus events with header
                  QuickActionHeader(
                    title: 'Upcoming Events',
                    onViewAll: () {
                      context.go('/events');
                    },
                    viewAllText: 'View all',
                  ),
                  SizedBox(
                    height: 320,
                    child: BlocBuilder<EventsBloc, EventsState>(
                      builder: (context, state) {
                        if (state is EventsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is EventsLoaded) {
                          // Get only upcoming events (filter out past events)
                          final allEvents = state.filteredEvents;
                          final upcomingEvents = allEvents
                              .where((event) => event.isUpcoming)
                              .toList();

                          // Sort events by start time
                          upcomingEvents.sort(
                              (a, b) => a.startTime.compareTo(b.startTime));

                          // Take only the next 5 events
                          final events = upcomingEvents.take(5).toList();

                          if (events.isEmpty) {
                            return const Center(
                              child: Text(
                                'No upcoming events',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            );
                          }

                          // Use ConstrainedBox to ensure the ListView has proper dimensions
                          return ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: 300, maxHeight: 350),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: events.length,
                              // Add physics to improve scrolling behavior
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final event = events[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  // Use ConstrainedBox instead of SizedBox for better constraint handling
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: 280, maxWidth: 280),
                                    child: EventCard(
                                      event: event,
                                      index: index,
                                      onTap: () {
                                        // Navigate to event details with error handling
                                        try {
                                          context.go('/events/${event.id}');
                                        } catch (e) {
                                          print('Navigation error: $e');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Could not navigate to event details')),
                                          );
                                        }
                                      },
                                      onRegister: !event.isPast
                                          ? () {
                                              // Show registration dialog
                                              _showEventRegistrationDialog(
                                                  context, event);
                                            }
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is EventsError) {
                          return Center(
                            child: Text('Error: ${state.message}'),
                          );
                        }
                        return const Center(
                          child: Text('No events available'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Campus news with header
                  QuickActionHeader(
                    title: 'Campus News',
                    onViewAll: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('News archive coming soon!')),
                      );
                    },
                    viewAllText: 'View all',
                  ),
                  Column(
                    children: _getCampusNews().map((newsItem) {
                      return NewsCard(
                        newsItem: newsItem,
                        index: _getCampusNews().indexOf(newsItem),
                        onTap: () {
                          // Show news details in bottom sheet
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => NewsDetailBottomSheet(
                              newsItem: newsItem,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          // Classes Tab
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              context.read<CoursesBloc>().add(LoadCourses());
              setState(() {});
            },
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInWidget(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'View your complete class schedule and assignments',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  QuickActionHeader(
                    title: 'All Classes',
                    trailing: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        // Filter classes
                      },
                    ),
                  ),
                  BlocBuilder<CoursesBloc, CoursesState>(
                    builder: (context, state) {
                      if (state is CoursesLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is CoursesLoaded) {
                        final courses = state.filteredCourses;
                        if (courses.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text('No classes found'),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            for (int i = 0; i < courses.length; i++)
                              ClassCard(
                                course: courses[i],
                                index: i,
                                onTap: () {
                                  // Navigate to course details with error handling
                                  try {
                                    context.go('/courses/${courses[i].id}');
                                  } catch (e) {
                                    print('Navigation error: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Could not navigate to course details')),
                                    );
                                  }
                                },
                              ),
                          ],
                        );
                      } else if (state is CoursesError) {
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      }
                      return const Center(
                        child: Text('No classes available'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Events Tab
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              context.read<EventsBloc>().add(LoadEvents());
              setState(() {});
            },
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInWidget(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event_note,
                            color: AppTheme.accentColor,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Browse and register for upcoming campus events',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  QuickActionHeader(
                    title: 'All Events',
                    trailing: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        // Filter events
                      },
                    ),
                  ),
                  BlocBuilder<EventsBloc, EventsState>(
                    builder: (context, state) {
                      if (state is EventsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is EventsLoaded) {
                        final events = state.filteredEvents;
                        if (events.isEmpty) {
                          return const Center(
                            child: Text('No upcoming events'),
                          );
                        }

                        return Column(
                          children: [
                            for (int i = 0; i < events.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: EventCard(
                                  event: events[i],
                                  index: i,
                                  showFullDetails: true,
                                  onTap: () {
                                    // Navigate to event details
                                    context.go('/events/${events[i].id}');
                                  },
                                  onRegister: events[i].isVirtual == false
                                      ? () {
                                          // Show registration dialog
                                          _showEventRegistrationDialog(
                                              context, events[i]);
                                        }
                                      : null,
                                ),
                              ),
                          ],
                        );
                      } else if (state is EventsError) {
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      }
                      return const Center(
                        child: Text('No events available'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // News Tab
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              setState(() {});
            },
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInWidget(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.newspaper,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Stay updated with the latest campus news and announcements',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  QuickActionHeader(
                    title: 'Latest News',
                    trailing: IconButton(
                      icon: const Icon(Icons.sort),
                      onPressed: () {
                        // Sort news
                      },
                    ),
                  ),
                  Column(
                    children: _getCampusNews().map((newsItem) {
                      return NewsCard(
                        newsItem: newsItem,
                        index: _getCampusNews().indexOf(newsItem),
                        onTap: () {
                          // Show news details in bottom sheet
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => NewsDetailBottomSheet(
                              newsItem: newsItem,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<QuickActionItem> _getQuickActionItems() {
    return [
      QuickActionItem(
        icon: Icons.restaurant,
        label: 'Dining',
        iconColor: Colors.orange,
        onTap: () {
          // Navigate to dining screen
          context.go('/dining');
        },
      ),
      QuickActionItem(
        icon: Icons.directions_bus,
        label: 'Transit',
        iconColor: Colors.green,
        onTap: () {
          // Navigate to transit screen
          context.go('/transit');
        },
      ),
      QuickActionItem(
        icon: Icons.map,
        label: 'Campus Map',
        iconColor: Colors.blue,
        onTap: () {
          // Navigate to map screen
          context.go('/map');
        },
      ),
      QuickActionItem(
        icon: Icons.calendar_today,
        label: 'Schedule',
        iconColor: Colors.purple,
        onTap: () {
          // Navigate to schedule screen
          context.go('/schedule');
        },
      ),
      QuickActionItem(
        icon: Icons.book,
        label: 'Courses',
        iconColor: Colors.indigo,
        badgeCount: 2,
        onTap: () {
          // Navigate to courses screen
          context.go('/courses');
        },
      ),
      QuickActionItem(
        icon: Icons.event,
        label: 'Events',
        iconColor: Colors.red,
        badgeCount: 3,
        onTap: () {
          // Navigate to events screen
          context.go('/events');
        },
      ),
      QuickActionItem(
        icon: Icons.school,
        label: 'Grades',
        iconColor: Colors.teal,
        onTap: () {
          // Navigate to grades screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Grades feature coming soon!')),
          );
        },
      ),
      QuickActionItem(
        icon: Icons.library_books,
        label: 'Library',
        iconColor: Colors.brown,
        isNew: true,
        onTap: () {
          // Navigate to library screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Library feature coming soon!')),
          );
        },
      ),
    ];
  }

  Widget _buildUpcomingClasses() {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state is CoursesInitial) {
          // Load courses when the screen is first opened
          context.read<CoursesBloc>().add(LoadCourses());
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CoursesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CoursesError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(height: 8),
                Text('Error: ${state.message}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<CoursesBloc>().add(LoadCourses());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is CoursesLoaded) {
          // Filter only current courses for today's classes
          final currentCourses = state.allCourses
              .where((course) => course.status == 'Current')
              .toList();

          if (currentCourses.isEmpty) {
            return const Center(
              child: Text('No classes scheduled for today'),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: currentCourses.length,
            itemBuilder: (context, index) {
              final course = currentCourses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    _showClassDetailsBottomSheet(context, course);
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.class_,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      course.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(course.schedule),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(course.location),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(course.instructor),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        // Navigate to courses screen
                        context.go('/courses');
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }

        return const Center(child: Text('No classes found'));
      },
    );
  }

  List<News> _getCampusNews() {
    return [
      News(
        id: '1',
        title: 'Campus Library Extends Hours During Finals Week',
        summary:
            'The university library will be open 24/7 during finals week to accommodate student study needs.',
        content:
            'The university library will be open 24/7 during finals week to accommodate student study needs. Additional staff will be available to assist with research and technical support. Students are encouraged to reserve study rooms in advance as they are expected to fill up quickly.',
        publishDate: DateTime.now(),
        category: 'Announcement',
        author: 'University Admin',
        tags: ['library', 'finals', 'study resources'],
      ),
      News(
        id: '2',
        title: 'New Student Center Opening Next Month',
        summary:
            'The long-awaited student center will open its doors on May 15th with new dining options, study spaces, and recreational facilities.',
        content:
            'The long-awaited student center will open its doors on May 15th with new dining options, study spaces, and recreational facilities. The grand opening ceremony will feature live music and free food for all attendees. Campus clubs will have booths showcasing their activities.',
        publishDate: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Campus Life',
        author: 'Development Office',
        imageUrl: 'assets/images/student_center.jpg',
        tags: ['new building', 'student center', 'campus improvement'],
      ),
      News(
        id: '3',
        title: 'Registration for Fall Semester Opens Next Week',
        summary:
            'Students can begin registering for Fall semester classes starting Monday.',
        content:
            'Students can begin registering for Fall semester classes starting Monday. Priority registration will be available based on class standing and academic program. Make sure to meet with your advisor before registration opens to ensure you are selecting the right courses for your degree path.',
        publishDate: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Academic',
        author: 'Registrar\'s Office',
        tags: ['registration', 'fall semester', 'academic planning'],
      ),
    ];
  }

  // Helper methods for navigation

  void _showComingSoonSnackbar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showMoreOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('More Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoonSnackbar('Help & Support');
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('Resources'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoonSnackbar('Resources');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Academic Calendar'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoonSnackbar('Academic Calendar');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context
                    .go('/profile'); // Navigate to profile which has settings
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClassDetailsBottomSheet(BuildContext context, Course course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Class title
                    Text(
                      course.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Class details
                    _buildDetailRow(Icons.access_time, 'Time', course.schedule),
                    _buildDetailRow(
                        Icons.location_on, 'Location', course.location),
                    _buildDetailRow(
                        Icons.person, 'Instructor', course.instructor),
                    _buildDetailRow(
                        Icons.school, 'Credits', course.credits.toString()),
                    if (course.grade != null)
                      _buildDetailRow(Icons.grade, 'Grade', course.grade!),
                    _buildDetailRow(Icons.trending_up, 'Progress',
                        '${(course.progress * 100).toInt()}%'),

                    const Divider(height: 32),

                    // Class description
                    const Text(
                      'Course Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.description,
                      style: const TextStyle(height: 1.5),
                    ),

                    if (course.assignments.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Assignments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...course.assignments.map((assignment) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.assignment),
                            title: Text(assignment.title),
                            subtitle: Text('Due: ${assignment.dueDate}'),
                            trailing: Text(
                              assignment.status,
                              style: TextStyle(
                                color: assignment.status == 'Completed'
                                    ? Colors.green
                                    : assignment.status == 'Pending'
                                        ? Colors.orange
                                        : Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                    ],

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              context.go('/courses');
                            },
                            icon: const Icon(Icons.menu_book),
                            label: const Text('View Course'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showComingSoonSnackbar('Assignment submission');
                            },
                            icon: const Icon(Icons.assignment),
                            label: const Text('Assignments'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNewsDetailsBottomSheet(BuildContext context, News newsItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // News title
                    Text(
                      newsItem.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // News date
                    Text(
                      newsItem.formattedDate,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // News content
                    Text(
                      '${newsItem.summary}\n\n${newsItem.content}',
                      style: const TextStyle(height: 1.5),
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            Navigator.pop(context);
                            _showComingSoonSnackbar('Share');
                          },
                          tooltip: 'Share',
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {
                            Navigator.pop(context);
                            _showComingSoonSnackbar('Save');
                          },
                          tooltip: 'Save',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNotificationsBottomSheet(BuildContext context) {
    final notifications = [
      {
        'title': 'Assignment Due',
        'message': 'Your CS101 assignment is due tomorrow',
        'time': '2 hours ago',
        'icon': Icons.assignment,
        'color': Colors.orange,
      },
      {
        'title': 'Event Reminder',
        'message': 'Career Fair starts in 3 hours',
        'time': '3 hours ago',
        'icon': Icons.event,
        'color': Colors.blue,
      },
      {
        'title': 'Grade Posted',
        'message': 'New grade posted for Mathematics 202',
        'time': '1 day ago',
        'icon': Icons.school,
        'color': Colors.green,
      },
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showComingSoonSnackbar('Mark all as read');
                    },
                    child: const Text('Mark all as read'),
                  ),
                ],
              ),
            ),

            // Notifications list
            Expanded(
              child: ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: notification['color'] as Color,
                      child: Icon(
                        notification['icon'] as IconData,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(notification['title'] as String),
                    subtitle: Text(notification['message'] as String),
                    trailing: Text(
                      notification['time'] as String,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Handle notification tap based on type
                      if (notification['icon'] == Icons.assignment) {
                        _showComingSoonSnackbar('Assignments');
                      } else if (notification['icon'] == Icons.event) {
                        context.go('/events');
                      } else if (notification['icon'] == Icons.school) {
                        context.go('/courses');
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Campus Buddy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search for courses, events, etc.',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                Navigator.pop(context);
                if (value.toLowerCase().contains('event') ||
                    value.toLowerCase().contains('concert') ||
                    value.contains('fair')) {
                  context.read<EventsBloc>().add(SearchEvents(value));
                  context.go('/events');
                } else if (value.toLowerCase().contains('course') ||
                    value.toLowerCase().contains('class') ||
                    value.toLowerCase().contains('lecture')) {
                  context.go('/courses');
                } else if (value.toLowerCase().contains('map') ||
                    value.toLowerCase().contains('location') ||
                    value.toLowerCase().contains('building')) {
                  context.go('/map');
                } else {
                  _showComingSoonSnackbar('Search for "$value"');
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Recent Searches',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildSearchChip('Events'),
                _buildSearchChip('Computer Science'),
                _buildSearchChip('Library'),
                _buildSearchChip('Career Fair'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return InputChip(
      label: Text(label),
      onPressed: () {
        Navigator.pop(context);
        if (label.toLowerCase().contains('event') ||
            label.toLowerCase().contains('fair')) {
          context.read<EventsBloc>().add(SearchEvents(label));
          context.go('/events');
        } else if (label.toLowerCase().contains('computer science')) {
          context.go('/courses');
        } else if (label.toLowerCase().contains('library')) {
          context.go('/map');
        } else {
          _showComingSoonSnackbar('Search for "$label"');
        }
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEventRegistrationDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Register for ${event.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${event.formattedDate}'),
            const SizedBox(height: 8),
            Text('Time: ${event.formattedTime}'),
            const SizedBox(height: 8),
            Text('Location: ${event.location}'),
            const SizedBox(height: 16),
            const Text('Would you like to register for this event?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add registration logic here
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration successful!')),
              );
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}

class NewsDetailBottomSheet extends StatelessWidget {
  final News newsItem;

  const NewsDetailBottomSheet({
    Key? key,
    required this.newsItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView(
          controller: controller,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              newsItem.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              newsItem.formattedDate,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            if (newsItem.imageUrl != null && newsItem.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  newsItem.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              child: Text(
                newsItem.content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
