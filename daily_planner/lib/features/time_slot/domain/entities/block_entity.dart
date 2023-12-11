import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

class Block extends TimeSlot {
  Block(
      {required super.startTime,
      required super.endTime,
      required super.subject,
      required super.createdAt});

  factory Block.fromJson(Map<dynamic, dynamic> json) {
    TimeSlot timeSlot = TimeSlot.fromJson(json);

    return Block(
      startTime: timeSlot.startTime,
      endTime: timeSlot.endTime,
      subject: timeSlot.subject,
      createdAt: timeSlot.createdAt,
    );
  }

  @override
  Map toJson() {
    Map timeSlotJson = super.toJson();

    return timeSlotJson;
    // return {
    //   'createdAt': createdAt.troncateDateTime().toString(),
    // };
  }
}
