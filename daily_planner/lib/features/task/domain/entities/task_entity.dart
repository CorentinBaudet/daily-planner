import 'dart:ui';

import 'package:daily_planner/features/task/domain/entities/priority_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

class Task extends TimeSlot {
  final Priority priority;
  bool isPlanned;
  bool isDone;
  bool isRescheduled;

  // default constructor
  Task({
    required super.startTime,
    required super.endTime,
    required super.subject,
    required this.priority,
    super.id,
    super.color = const Color(0xFFffc2a9),
    DateTime? createdAt,
    this.isPlanned = true,
    this.isDone = false,
    this.isRescheduled = false,
  }) : super(createdAt: createdAt ?? DateTime.now());

  // named constructor
  Task.unplanned({
    required super.subject,
    required this.priority,
    super.color = const Color(0xFFffc2a9),
    this.isPlanned = false,
    this.isDone = false,
    this.isRescheduled = false,
  }) : super(
          startTime: DateTime(0), // able to give a default value
          endTime: DateTime(0),
          createdAt: DateTime.now(),
        );

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    TimeSlot timeSlot = TimeSlot.fromJson(json);

    return Task(
      startTime: timeSlot.startTime,
      endTime: timeSlot.endTime,
      subject: timeSlot.subject,
      id: timeSlot.id,
      color: timeSlot.color,
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
      'type': runtimeType.toString(),
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
