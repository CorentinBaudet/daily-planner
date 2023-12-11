import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

class WorkBlock extends TimeSlot {
  int taskId;

  WorkBlock({
    required super.startTime,
    required super.endTime,
    required super.subject,
    required super.createdAt,
    this.taskId = 0,
  });

  factory WorkBlock.fromJson(Map<dynamic, dynamic> json) {
    TimeSlot timeSlot = TimeSlot.fromJson(json);

    return WorkBlock(
      startTime: timeSlot.startTime,
      endTime: timeSlot.endTime,
      subject: timeSlot.subject,
      createdAt: timeSlot.createdAt,
      taskId: json['taskId'],
    );
  }

  @override
  Map toJson() {
    Map timeSlotJson = super.toJson();

    timeSlotJson.addAll({
      'taskId': taskId,
    });

    return timeSlotJson;
    // return {
    //   'createdAt': createdAt.troncateDateTime().toString(),
    //   'taskId': taskId ?? 0,
    // };
  }
}
