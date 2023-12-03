import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event_entity.dart';
import 'package:daily_planner/utils/extension.dart';

class WorkBlock extends TimeSlotEvent {
  Task? task;

  WorkBlock({required super.createdAt, this.task});

  factory WorkBlock.fromJson(Map<dynamic, dynamic> json) {
    return WorkBlock(
      createdAt: DateTime.parse(json['createdAt']),
      task: Task.fromJson(json['task']),
    );
  }

  @override
  Map toJson() {
    return {
      'createdAt': createdAt.troncateDateTime().toString(),
      'task': task!.toJson(),
    };
  }
}
