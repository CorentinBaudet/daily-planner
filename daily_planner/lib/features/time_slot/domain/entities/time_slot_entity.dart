import 'package:daily_planner/features/task/domain/entities/task_entity.dart';

class TimeSlot {
  int? id;
  DateTime startTime;
  int duration; // in minutes
  final Task content;
  DateTime createdAt;

  TimeSlot({
    this.id,
    required this.startTime,
    required this.duration,
    required this.content,
    required this.createdAt,
  });

  factory TimeSlot.fromJson(Map<dynamic, dynamic> json) {
    Task content;
    try {
      content = Task.fromJson(json['content']);
    } catch (e) {
      // content = Block.fromJson(json['block']);
      content = Task.fromJson(json['content']); // TODO: change to Block
    }
    return TimeSlot(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      duration: json['duration'],
      content: content,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toString(),
      'duration': duration,
      'content': content.toJson(),
      'createdAt': createdAt.toString(),
    };
  }
}

abstract class TimeSlotContent {
  int? id;
  final String name;

  TimeSlotContent({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toJson();
}
