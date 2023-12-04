import 'package:daily_planner/features/task/domain/entities/priority_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event_entity.dart';
import 'package:daily_planner/utils/extension.dart';

class Task extends TimeSlotEvent {
  int? id;
  String name;
  final Priority priority;
  bool isPlanned;
  DateTime? plannedOn;
  bool isDone;
  bool isRescheduled;

  Task({
    this.id,
    required this.name,
    required this.priority,
    required super.createdAt,
    this.isPlanned = false,
    this.plannedOn,
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
      plannedOn: DateTime.parse(json['plannedOn']),
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
      'createdAt': createdAt.troncateDateTime().toString(),
      'isPlanned': isPlanned,
      'plannedOn': plannedOn?.formatDate(),
      'isDone': isDone,
      'isRescheduled': isRescheduled,
    };
  }
}
