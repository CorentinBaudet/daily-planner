import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event.dart';

class Task extends TimeSlotEvent {
  final Priority priority;
  final DateTime createdAt;
  bool isPlanned;
  bool isDone;
  bool isRescheduled;

  Task({
    super.id,
    required super.name,
    required this.priority,
    required this.createdAt,
    this.isPlanned = false,
    this.isDone = false,
    this.isRescheduled = false,
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
      isPlanned: json['isPlanned'] as bool,
      isDone: json['isDone'] as bool,
      isRescheduled: json['isRescheduled'] as bool,
    );
  }

  @override
  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'priority': priority.toString().split('.').last,
      'createdAt': createdAt.toString(),
      'isPlanned': isPlanned,
      'isDone': isDone,
      'isRescheduled': isRescheduled,
    };
  }
}

enum Priority {
  normal,
  high,
}
