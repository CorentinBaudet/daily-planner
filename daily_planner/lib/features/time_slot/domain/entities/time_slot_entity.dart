import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event.dart';

class TimeSlot {
  int? id;
  DateTime startTime;
  DateTime endTime;
  // int duration; // in minutes
  final TimeSlotEvent event;
  DateTime createdAt;

  TimeSlot({
    this.id,
    required this.startTime,
    required this.endTime,
    // required this.duration,
    required this.event,
    required this.createdAt,
  });

  factory TimeSlot.fromJson(Map<dynamic, dynamic> json) {
    TimeSlotEvent event;
    try {
      event = Task.fromJson(json['event']);
    } catch (e) {
      event = Block.fromJson(json['event']);
    }
    return TimeSlot(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      // duration: json['duration'],
      event: event,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
      // 'duration': duration,
      'event': event.toJson(),
      'createdAt': createdAt.toString(),
    };
  }
}
