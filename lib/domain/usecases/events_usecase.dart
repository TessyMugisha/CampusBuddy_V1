import '../../data/repositories/events_repository.dart';
import '../entities/event.dart';

class EventsUseCase {
  final EventsRepository _eventsRepository;

  EventsUseCase([EventsRepository? eventsRepository])
      : _eventsRepository = eventsRepository ?? EventsRepository.mock();

  // Get all events
  Future<List<Event>> getAllEvents() async {
    try {
      final events = await _eventsRepository.getAllEvents();
      return events;
    } catch (e) {
      throw e;
    }
  }

  // Get event by ID
  Future<Event> getEventById(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('ID cannot be empty');
    }

    try {
      return await _eventsRepository.getEventById(id);
    } catch (e) {
      throw e;
    }
  }

  // Get upcoming events
  Future<List<Event>> getUpcomingEvents() async {
    try {
      return await _eventsRepository.getUpcomingEvents();
    } catch (e) {
      throw e;
    }
  }

  // Get events by category
  Future<List<Event>> getEventsByCategory(String category) async {
    if (category.isEmpty) {
      throw ArgumentError('Category cannot be empty');
    }

    try {
      return await _eventsRepository.getEventsByCategory(category);
    } catch (e) {
      throw e;
    }
  }

  // Get events by date range
  Future<List<Event>> getEventsByDateRange(
      DateTime startDate, DateTime endDate) async {
    if (endDate.isBefore(startDate)) {
      throw ArgumentError('End date must be after start date');
    }

    try {
      return await _eventsRepository.getEventsByDateRange(startDate, endDate);
    } catch (e) {
      throw e;
    }
  }

  // Get events for a specific day
  Future<List<Event>> getEventsForDay(DateTime day) async {
    try {
      final startOfDay = DateTime(day.year, day.month, day.day, 0, 0);
      final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59);

      return await _eventsRepository.getEventsByDateRange(startOfDay, endOfDay);
    } catch (e) {
      throw e;
    }
  }

  // Get all unique event categories
  Future<List<String>> getAllEventCategories() async {
    try {
      final events = await _eventsRepository.getAllEvents();
      final categories = <String>{};

      for (final event in events) {
        categories.addAll(event.categories);
      }

      return categories.toList()..sort();
    } catch (e) {
      throw e;
    }
  }

  // Add event to personal calendar
  Future<bool> addToPersonalCalendar(String eventId) async {
    if (eventId.isEmpty) {
      throw ArgumentError('Event ID cannot be empty');
    }

    try {
      return await _eventsRepository.addToPersonalCalendar(eventId);
    } catch (e) {
      throw e;
    }
  }

  // Refresh events data
  Future<void> refreshEvents() async {
    try {
      await _eventsRepository.clearCache();
      await _eventsRepository.getAllEvents();
    } catch (e) {
      throw e;
    }
  }
}
