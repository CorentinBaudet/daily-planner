import 'dart:ui';

import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/work_block_entity.dart';
import 'package:daily_planner/utils/extension.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlot extends Appointment {
  final TimeSlotEvent event;
  // final DateTime createdAt;

  TimeSlot({
    super.id,
    required super.startTime,
    required super.endTime,
    required super.subject,
    required this.event,
    super.color,
    super.recurrenceRule = '',
    // required this.createdAt,
  });

  factory TimeSlot.fromJson(Map<dynamic, dynamic> json) {
    TimeSlotEvent event;
    try {
      event = Task.fromJson(json['event']);
    } catch (e) {
      try {
        event = WorkBlock.fromJson(json['event']);
      } catch (e) {
        event = Block.fromJson(json['event']);
      }
    }
    return TimeSlot(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      subject: json['subject'],
      event: event,
      color: Color(int.parse(json['color'])),
      recurrenceRule: json['recurrenceRule'],
      // createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.troncateDateTime().toString(),
      'endTime': endTime.troncateDateTime().toString(),
      'subject': subject,
      'event': event.toJson(),
      'color': color.value.toString(),
      'recurrenceRule': recurrenceRule,
      // 'createdAt': createdAt.troncateDateTime().toString(),
    };
  }
}
