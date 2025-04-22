import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class News {
  final String id;
  final String title;
  final String summary;
  final String content;
  final DateTime publishDate;
  final String category;
  final String? imageUrl;
  final String author;
  final List<String> tags;

  News({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.publishDate,
    required this.category,
    this.imageUrl,
    required this.author,
    this.tags = const [],
  });

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final publishDay =
        DateTime(publishDate.year, publishDate.month, publishDate.day);

    final difference = today.difference(publishDay).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(publishDate);
    }
  }

  String get formattedTime {
    return DateFormat('h:mm a').format(publishDate);
  }

  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'academic':
        return Icons.school;
      case 'announcement':
        return Icons.campaign;
      case 'campus life':
        return Icons.people;
      case 'sports':
        return Icons.sports_soccer;
      case 'research':
        return Icons.science;
      case 'events':
        return Icons.event;
      default:
        return Icons.article;
    }
  }

  Color get categoryColor {
    switch (category.toLowerCase()) {
      case 'academic':
        return Colors.blue;
      case 'announcement':
        return Colors.orange;
      case 'campus life':
        return Colors.green;
      case 'sports':
        return Colors.red;
      case 'research':
        return Colors.purple;
      case 'events':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
