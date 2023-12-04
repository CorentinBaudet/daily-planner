import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event_entity.dart';
import 'package:daily_planner/utils/extension.dart';

class WorkBlock extends TimeSlotEvent {
  int? taskId;

  WorkBlock({required super.createdAt, this.taskId});

  factory WorkBlock.fromJson(Map<dynamic, dynamic> json) {
    return WorkBlock(
      createdAt: DateTime.parse(json['createdAt']),
      taskId: json['taskId'],
    );
  }

  @override
  Map toJson() {
    return {
      'createdAt': createdAt.troncateDateTime().toString(),
      'taskId': taskId ?? 0,
    };
  }
}
