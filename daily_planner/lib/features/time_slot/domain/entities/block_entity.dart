import 'dart:ui';

import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

class Block extends TimeSlot {
  Block({
    required super.startTime,
    required super.endTime,
    required super.subject,
    required super.recurrenceRule,
    super.id,
    super.color = const Color(0xFFffe7dc),
    DateTime? createdAt,
  }) : super(createdAt: createdAt ?? DateTime.now());
  // if createdAt is not provided, the superclass's constructor will handle its initialization

  factory Block.fromJson(Map<dynamic, dynamic> json) {
    TimeSlot timeSlot = TimeSlot.fromJson(json);

    return Block(
      startTime: timeSlot.startTime,
      endTime: timeSlot.endTime,
      subject: timeSlot.subject,
      id: timeSlot.id,
      color: timeSlot.color,
      recurrenceRule: timeSlot.recurrenceRule,
      createdAt: timeSlot.createdAt,
    );
  }

  @override
  Map toJson() {
    Map timeSlotJson = super.toJson();

    timeSlotJson.addAll({
      'type': runtimeType.toString(),
    });

    return timeSlotJson;
    // return {
    //   'createdAt': createdAt.troncateDateTime().toString(),
    // };
  }
}
