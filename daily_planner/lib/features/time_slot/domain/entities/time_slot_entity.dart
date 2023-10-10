import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

class TimeSlot {
  final int id;
  final TimeOfDay startTime;
  final int duration; // in minutes
  final Task content;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.duration,
    required this.content,
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
      startTime: json['startTime'],
      duration: json['duration'],
      content: content,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'duration': duration,
      'content': content.toJson(),
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
