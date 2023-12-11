import 'package:daily_planner/features/task/domain/entities/priority_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

class Task extends TimeSlot {
  final Priority priority;
  bool isPlanned;
  bool isDone;
  bool isRescheduled;

  Task({
    required super.startTime,
    required super.endTime,
    required super.subject,
    required super.createdAt,
    required this.priority,
    this.isPlanned = false,
    this.isDone = false,
    this.isRescheduled = false,
  });

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    TimeSlot timeSlot = TimeSlot.fromJson(json);

    return Task(
      startTime: timeSlot.startTime,
      endTime: timeSlot.endTime,
      subject: timeSlot.subject,
      createdAt: timeSlot.createdAt,
      priority: Priority.values.firstWhere(
        (priority) => priority.toString() == 'Priority.${json['priority']}',
        orElse: () => Priority.normal,
      ),
      isPlanned: json['isPlanned'] as bool,
      isDone: json['isDone'] as bool,
      isRescheduled: json['isRescheduled'] as bool,
    );
  }

  @override
  Map<dynamic, dynamic> toJson() {
    Map timeSlotJson = super.toJson();

    timeSlotJson.addAll({
      'priority': priority.toString().split('.').last,
      'isPlanned': isPlanned,
      'isDone': isDone,
      'isRescheduled': isRescheduled,
    });

    return timeSlotJson;
    // return {
    //   'id': id,
    //   'name': name,
    //   'priority': priority.toString().split('.').last,
    //   'createdAt': createdAt.troncateDateTime().toString(),
    //   'isPlanned': isPlanned,
    //   'plannedOn': plannedOn?.formatDate(),
    //   'isDone': isDone,
    //   'isRescheduled': isRescheduled,
    // };
  }
}
