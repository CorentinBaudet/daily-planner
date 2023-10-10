// import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

class Task {
  // extends TimeSlotContent
  int? id;
  final String name;
  final Priority priority;
  bool isDone;
  DateTime createdAt;

  Task({
    // super.id,
    // required super.name,
    this.id,
    required this.name,
    required this.priority,
    this.isDone = false,
    required this.createdAt,
  });

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    return Task(
      id: json['id'] as int?,
      name: json['name'],
      priority: Priority.values.firstWhere(
        (priority) => priority.toString() == 'Priority.${json['priority']}',
        orElse: () => Priority.normal,
      ),
      isDone: json['isDone'] as bool,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // @override
  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'priority': priority.toString().split('.').last,
      'isDone': isDone,
      'createdAt': createdAt.toString(),
    };
  }
}

enum Priority {
  normal,
  high,
}
