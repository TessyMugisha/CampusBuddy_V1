/// Events Repository Interface
///
/// Defines the contract for data operations related to Events.
/// This interface follows Clean Architecture principles by keeping
/// the domain layer independent of implementation details.
library;

import '../entities/event.dart';

abstract class EventsRepositoryInterface {
  /// Fetches all events
  Future<List<Event>> getAllEvents();

  /// Fetches a specific event by ID
  Future<Event> getEventById(String id);

  /// Fetches upcoming events (events with a start time after current time)
  Future<List<Event>> getUpcomingEvents();

  /// Fetches events by category
  Future<List<Event>> getEventsByCategory(String category);

  /// Fetches events within a specified date range
  Future<List<Event>> getEventsByDateRange(
      DateTime startDate, DateTime endDate);

  /// Adds an event to the user's personal calendar
  Future<bool> addToPersonalCalendar(String eventId);

  /// Clears any cached event data
  Future<void> clearCache();
}
