import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event_entity.dart';
import 'package:daily_planner/utils/extension.dart';

class Block extends TimeSlotEvent {
  Block({required super.createdAt});

  factory Block.fromJson(Map<dynamic, dynamic> json) {
    return Block(
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  Map toJson() {
    return {
      'createdAt': createdAt.troncateDateTime().toString(),
    };
  }
}
