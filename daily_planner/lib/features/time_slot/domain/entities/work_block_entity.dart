import 'dart:ui';

import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

class WorkBlock extends TimeSlot {
  int taskId;

  WorkBlock({
    required super.startTime,
    required super.endTime,
    required super.subject,
    super.id,
    super.color = const Color(0xFFffe7dc),
    DateTime? createdAt,
    this.taskId = 0,
  }) : super(createdAt: createdAt ?? DateTime.now());
  // if createdAt is not provided, the superclass's constructor will handle its initialization

  factory WorkBlock.fromJson(Map<dynamic, dynamic> json) {
    TimeSlot timeSlot = TimeSlot.fromJson(json);

    return WorkBlock(
      startTime: timeSlot.startTime,
      endTime: timeSlot.endTime,
      subject: timeSlot.subject,
      id: timeSlot.id,
      color: timeSlot.color,
      createdAt: timeSlot.createdAt,
      taskId: json['taskId'],
    );
  }

  @override
  Map toJson() {
    Map timeSlotJson = super.toJson();

    timeSlotJson.addAll({
      'taskId': taskId,
      'type': runtimeType.toString(),
    });

    return timeSlotJson;
    // return {
    //   'createdAt': createdAt.troncateDateTime().toString(),
    //   'taskId': taskId ?? 0,
    // };
  }
}
