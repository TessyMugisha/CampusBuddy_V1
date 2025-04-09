import '../../domain/entities/assignment.dart';

class AssignmentModel extends Assignment {
  AssignmentModel({
    required String id,
    required String title,
    required String description,
    required String dueDate,
    required String status,
    double? grade,
    String? feedback,
  }) : super(
          id: id,
          title: title,
          description: description,
          dueDate: dueDate,
          status: status,
          grade: grade,
          feedback: feedback,
        );

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] ?? '',
      status: json['status'] ?? '',
      grade: json['grade'],
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'status': status,
      'grade': grade,
      'feedback': feedback,
    };
  }

  factory AssignmentModel.fromEntity(Assignment assignment) {
    return AssignmentModel(
      id: assignment.id,
      title: assignment.title,
      description: assignment.description,
      dueDate: assignment.dueDate,
      status: assignment.status,
      grade: assignment.grade,
      feedback: assignment.feedback,
    );
  }
}
