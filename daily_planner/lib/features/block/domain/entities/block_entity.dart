import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event.dart';

// TODO : maybe a work block should be a separate entity with a task nested inside
class Block extends TimeSlotEvent {
  bool isWork;

  Block({super.id, required super.name, this.isWork = false});

  factory Block.fromJson(Map<dynamic, dynamic> json) {
    return Block(
      id: json['id'] as int?,
      name: json['name'],
      isWork: json['isWork'] as bool,
    );
  }

  @override
  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isWork': isWork,
    };
  }
}
