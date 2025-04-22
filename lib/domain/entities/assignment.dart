import 'package:equatable/equatable.dart';

class Assignment extends Equatable {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String status; // 'Completed', 'Pending', 'Upcoming'
  final double? grade;
  final String? feedback;

  const Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.grade,
    this.feedback,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    dueDate,
    status,
    grade,
    feedback,
  ];
}
