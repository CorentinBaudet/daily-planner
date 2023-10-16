import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event.dart';

class Block extends TimeSlotEvent {
  final bool isWork;

  Block({super.id, required super.name, required this.isWork});

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
