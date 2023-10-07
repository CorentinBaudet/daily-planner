import 'package:daily_planner/constants/intl.dart';

class Task {
  int? id;
  final String name;
  final Priority priority;
  bool isDone;
  DateTime createdAt;

  Task({
    this.id,
    required this.name,
    required this.priority,
    this.isDone = false,
    required this.createdAt,
  });

  int compareCreationDate(Task a, Task b) {
    if (a == b) return 0;
    return a.createdAt.compareTo(b.createdAt) * -1;
  }

  int comparePriority(Task a, Task b) {
    if (a == b) return 0;
    switch (a.priority) {
      case Priority.normal:
        return 1;
      case Priority.high:
        return -1;
    }
  }

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      priority: Priority.values.firstWhere(
        (priority) => priority.toString() == 'Priority.${json['priority']}',
        orElse: () => Priority.normal,
      ),
      isDone: json['isDone'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
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
