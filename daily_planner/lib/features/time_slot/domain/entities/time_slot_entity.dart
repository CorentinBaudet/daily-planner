import 'dart:ui';

import 'package:daily_planner/utils/extension.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlot extends Appointment {
  // final TimeSlotEvent event;
  final DateTime createdAt;

  TimeSlot({
    required super.startTime,
    required super.endTime,
    required super.subject,
    super.id,
    super.color,
    super.recurrenceRule = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory TimeSlot.fromJson(Map<dynamic, dynamic> json) {
    // try {
    //   event = Task.fromJson(json['event']);
    // } catch (e) {
    //   if (json['event']['taskId'] != null) {
    //     event = WorkBlock.fromJson(json['event']);
    //   } else {
    //     event = Block.fromJson(json['event']);
    //   }
    // }
    return TimeSlot(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      subject: json['subject'],
      createdAt: DateTime.parse(json['createdAt']),
      id: json['id'],
      color: Color(int.parse(json['color'])),
      recurrenceRule: json['recurrenceRule'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'startTime': startTime.troncateDateTime().toString(),
      'endTime': endTime.troncateDateTime().toString(),
      'subject': subject,
      'createdAt': createdAt.troncateDateTime().toString(),
      'id': id,
      'color': color.value.toString(),
      'recurrenceRule': recurrenceRule,
    };
  }
}
