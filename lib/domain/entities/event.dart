import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  bool get isUpcoming => startTime.isAfter(DateTime.now());

  bool get isOngoing {
    final now = DateTime.now();
    return startTime.isBefore(now) && endTime.isAfter(now);
  }

  bool get isPast => endTime.isBefore(DateTime.now());

  bool get isFull =>
      maxAttendees != null &&
      currentAttendees != null &&
      currentAttendees! >= maxAttendees!;

  String get timeRangeString {
    final startFormat =
        '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}';
    final endFormat =
        '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$startFormat - $endFormat';
  }

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

  String get formattedDate {
    return DateFormat('MMM d, yyyy').format(startTime);
  }

  String get formattedTime {
    return '${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}';
  }

  Color get categoryColor {
    switch (category.toLowerCase()) {
      case 'academic':
        return Colors.blue;
      case 'social':
        return Colors.purple;
      case 'sports':
        return Colors.green;
      case 'career':
        return Colors.orange;
      case 'arts':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'academic':
        return Icons.school;
      case 'social':
        return Icons.people;
      case 'sports':
        return Icons.sports;
      case 'career':
        return Icons.work;
      case 'arts':
        return Icons.palette;
      default:
        return Icons.event;
    }
  }

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
