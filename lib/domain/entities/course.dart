import 'package:equatable/equatable.dart';
import 'assignment.dart';

class Course extends Equatable {
  final String id;
  final String name;
  final String instructor;
  final String schedule;
  final String location;
  final int credits;
  final String status; // 'Current', 'Upcoming', or 'Completed'
  final double progress;
  final String? grade;
  final String description;
  final List<Assignment> assignments;

  const Course({
    required this.id,
    required this.name,
    required this.instructor,
    required this.schedule,
    required this.location,
    required this.credits,
    required this.status,
    required this.progress,
    this.grade,
    required this.description,
    required this.assignments,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        instructor,
        schedule,
        location,
        credits,
        status,
        progress,
        grade,
        description,
        assignments,
      ];

  bool get isInProgress => status == 'Current';
  bool get isUpcoming => status == 'Upcoming';
  bool get isCompleted => status == 'Completed';
}
