/// Events Use Case
///
/// Contains business logic for operations related to campus events.
/// Acts as a mediator between the presentation layer and the data layer,
/// enforcing business rules and validations.
library;

import '../entities/event.dart';
import '../repositories/events_repository_interface.dart';

// Import for factory method only, not direct dependency
import '../../data/repositories/events_repository_factory.dart';

class EventsUseCase {
  final EventsRepositoryInterface _eventsRepository;

  /// Creates an EventsUseCase with a repository injection
  /// If no repository is provided, a mock implementation is used
  EventsUseCase([EventsRepositoryInterface? eventsRepository])
      : _eventsRepository = eventsRepository ?? createMockEventsRepository();

  /// Get all events
  ///
  /// Retrieves the complete list of events from the repository
  Future<List<Event>> getAllEvents() async {
    try {
      final events = await _eventsRepository.getAllEvents();
      return events;
    } catch (e) {
      rethrow;
    }
  }

  /// Get event by ID
  ///
  /// Retrieves a specific event by its unique identifier
  /// Throws ArgumentError if ID is empty
  Future<Event> getEventById(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('ID cannot be empty');
    }

    try {
      return await _eventsRepository.getEventById(id);
    } catch (e) {
      rethrow;
    }
  }

  /// Get upcoming events
  ///
  /// Retrieves events scheduled to occur in the future
  Future<List<Event>> getUpcomingEvents() async {
    try {
      return await _eventsRepository.getUpcomingEvents();
    } catch (e) {
      rethrow;
    }
  }

  /// Get events by category
  ///
  /// Retrieves events filtered by a specific category
  /// Throws ArgumentError if category is empty
  Future<List<Event>> getEventsByCategory(String category) async {
    if (category.isEmpty) {
      throw ArgumentError('Category cannot be empty');
    }

    try {
      return await _eventsRepository.getEventsByCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  /// Get events by date range
  ///
  /// Retrieves events occurring within a specific date range
  /// Throws ArgumentError if end date is before start date
  Future<List<Event>> getEventsByDateRange(
      DateTime startDate, DateTime endDate) async {
    if (endDate.isBefore(startDate)) {
      throw ArgumentError('End date must be after start date');
    }

    try {
      return await _eventsRepository.getEventsByDateRange(startDate, endDate);
    } catch (e) {
      rethrow;
    }
  }

  /// Get events for a specific day
  ///
  /// Convenience method that retrieves events for a single day
  /// by creating a date range from start to end of the specified day
  Future<List<Event>> getEventsForDay(DateTime day) async {
    try {
      final startOfDay = DateTime(day.year, day.month, day.day, 0, 0);
      final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59);

      return await _eventsRepository.getEventsByDateRange(startOfDay, endOfDay);
    } catch (e) {
      rethrow;
    }
  }

  /// Get all unique event categories
  ///
  /// Extracts and returns a sorted list of all unique event categories
  Future<List<String>> getAllEventCategories() async {
    try {
      final events = await _eventsRepository.getAllEvents();
      final categories = <String>{};

      for (final event in events) {
        categories.addAll(event.categories);
      }

      return categories.toList()..sort();
    } catch (e) {
      rethrow;
    }
  }

  /// Add event to personal calendar
  ///
  /// Adds an event to the user's personal calendar
  /// Throws ArgumentError if event ID is empty
  Future<bool> addToPersonalCalendar(String eventId) async {
    if (eventId.isEmpty) {
      throw ArgumentError('Event ID cannot be empty');
    }

    try {
      return await _eventsRepository.addToPersonalCalendar(eventId);
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh events data
  ///
  /// Forces a refresh of the events data by clearing cache
  /// and fetching fresh data from the repository
  Future<void> refreshEvents() async {
    try {
      await _eventsRepository.clearCache();
      await _eventsRepository.getAllEvents();
    } catch (e) {
      rethrow;
    }
  }
}
