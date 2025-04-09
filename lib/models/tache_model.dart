import 'comment_model.dart';

class TacheModel {
  final String id;
  final String title;
  final String priority;
  final String status;
  final DateTime dueDate;
  final String description;
  final String assigneeName;
  final double progress;
  final List<CommentModel> comments;
  final String projectId;

  TacheModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.description,
    required this.assigneeName,
    required this.progress,
    required this.comments,
    required this.projectId,
  });

  String get dueDateFormatted {
    return "${dueDate.day.toString().padLeft(2, '0')}/${dueDate.month.toString().padLeft(2, '0')}/${dueDate.year}";
  }

  String get assignedTo => assigneeName;
}