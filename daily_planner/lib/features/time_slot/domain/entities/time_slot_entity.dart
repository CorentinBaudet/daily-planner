import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

class TimeSlot {
  final int id;
  final TimeOfDay startTime;
  final int duration; // in minutes
  final Task task;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.duration,
    required this.task,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: json['startTime'],
      duration: json['duration'],
      task: Task.fromJson(json['task']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'duration': duration,
      'task': task.toJson(),
    };
  }
}
