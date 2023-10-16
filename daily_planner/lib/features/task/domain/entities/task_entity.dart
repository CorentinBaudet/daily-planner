import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event.dart';

class Task extends TimeSlotEvent {
  final Priority priority;
  final DateTime createdAt;
  bool isDone;
  bool isPlanned;

  Task({
    super.id,
    required super.name,
    required this.priority,
    required this.createdAt,
    this.isDone = false,
    this.isPlanned = false,
  });

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    return Task(
      id: json['id'] as int?,
      name: json['name'],
      priority: Priority.values.firstWhere(
        (priority) => priority.toString() == 'Priority.${json['priority']}',
        orElse: () => Priority.normal,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      isDone: json['isDone'] as bool,
      isPlanned: json['isPlanned'] as bool,
    );
  }

  @override
  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'priority': priority.toString().split('.').last,
      'createdAt': createdAt.toString(),
      'isDone': isDone,
      'isPlanned': isPlanned,
    };
  }
}

enum Priority {
  normal,
  high,
}
