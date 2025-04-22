import 'package:intl/intl.dart';

/// Event Entity
///
/// Represents a campus event in the domain layer.
/// This class should not contain any UI or framework dependencies.
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String category;
  final String organizer;
  final String? imageUrl;
  final bool isRegistrationRequired;
  final int? maxAttendees;
  final int? currentAttendees;
  final bool isUserRegistered;
  final List<String> categories;
  final bool isVirtual;
  final String? virtualLink;
  final List<String> tags;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.category,
    required this.organizer,
    this.imageUrl,
    this.isRegistrationRequired = false,
    this.maxAttendees,
    this.currentAttendees,
    this.isUserRegistered = false,
    this.categories = const [],
    this.isVirtual = false,
    this.virtualLink,
    this.tags = const [],
  });

  /// Whether the event is upcoming (starts in the future)
  bool get isUpcoming => startTime.isAfter(DateTime.now());

  /// Whether the event is currently ongoing
  bool get isOngoing {
    final now = DateTime.now();
    return startTime.isBefore(now) && endTime.isAfter(now);
  }

  /// Whether the event has already ended
  bool get isPast => endTime.isBefore(DateTime.now());

  /// Whether the event has reached its attendance capacity
  bool get isFull =>
      maxAttendees != null &&
      currentAttendees != null &&
      currentAttendees! >= maxAttendees!;

  /// Time range as a formatted string (e.g. "10:00 - 12:00")
  String get timeRangeString {
    final startFormat =
        '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}';
    final endFormat =
        '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$startFormat - $endFormat';
  }

  /// Date in a readable format (e.g. "Jan 15, 2025")
  String get dateString {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[startTime.month - 1]} ${startTime.day}, ${startTime.year}';
  }

  /// Formatted date using intl package
  String get formattedDate {
    return DateFormat('MMM d, yyyy').format(startTime);
  }

  /// Formatted time range using intl package
  String get formattedTime {
    return '${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}';
  }

  /// Creates a copy of this Event with the given fields replaced by new values
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? category,
    String? organizer,
    String? imageUrl,
    bool? isRegistrationRequired,
    int? maxAttendees,
    int? currentAttendees,
    bool? isUserRegistered,
    List<String>? categories,
    bool? isVirtual,
    String? virtualLink,
    List<String>? tags,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      category: category ?? this.category,
      organizer: organizer ?? this.organizer,
      imageUrl: imageUrl ?? this.imageUrl,
      isRegistrationRequired:
          isRegistrationRequired ?? this.isRegistrationRequired,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      currentAttendees: currentAttendees ?? this.currentAttendees,
      isUserRegistered: isUserRegistered ?? this.isUserRegistered,
      categories: categories ?? this.categories,
      isVirtual: isVirtual ?? this.isVirtual,
      virtualLink: virtualLink ?? this.virtualLink,
      tags: tags ?? this.tags,
    );
  }
}
