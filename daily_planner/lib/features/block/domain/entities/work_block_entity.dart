import 'dart:ui';

import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

class WorkBlock extends TimeSlot {
  WorkBlock({
    required super.startTime,
    required super.endTime,
    required super.subject,
    super.id,
    super.color = const Color(0xFFffe7dc),
    String? recurrenceRule,
    DateTime? createdAt,
  }) : super(
            // if recurrenceRule is not provided, the superclass's constructor will handle its initialization
            recurrenceRule: recurrenceRule ?? 'FREQ=DAILY',
            createdAt: createdAt ?? DateTime.now());

  factory WorkBlock.fromJson(Map<dynamic, dynamic> json) {
    TimeSlot timeSlot = TimeSlot.fromJson(json);

    return WorkBlock(
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
  }
}
