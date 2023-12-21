import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/block/domain/entities/work_block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/repositories/time_slot_base_repository.dart';
import 'package:hive/hive.dart';

class TimeSlotLocalStorageRepository extends TimeSlotBaseRepository {
  final Box _myTimeSlots = Hive.box('my_time_slots');

  TimeSlotLocalStorageRepository();

  @override
  List<TimeSlot> getTimeSlots() {
    final jsonTimeSlots = _myTimeSlots.values;

    List<TimeSlot> timeSlotList = [];

    for (var item in jsonTimeSlots) {
      switch (item['type']) {
        case 'Task':
          timeSlotList.add(Task.fromJson(item));
          break;
        case 'Block':
          timeSlotList.add(Block.fromJson(item));
          break;
        case 'WorkBlock':
          timeSlotList.add(WorkBlock.fromJson(item));
          break;
        default:
        // TODO: handle this case by logging an error
      }
    }
    return timeSlotList;
  }

  @override
  TimeSlot getTimeSlot(int id) {
    TimeSlot timeSlot;
    try {
      timeSlot = getTimeSlots().firstWhere((timeSlot) => timeSlot.id == id);
    } catch (e) {
      timeSlot =
          TimeSlot(startTime: DateTime(0), endTime: DateTime(0), subject: '');
    }
    return timeSlot;
  }

  @override
  Future<void> create(TimeSlot timeSlot) async {
    timeSlot.id = timeSlot.hashCode;
    await _myTimeSlots.put(timeSlot.id, timeSlot.toJson());
  }

  @override
  Future<void> update(TimeSlot timeSlot) {
    return _myTimeSlots.put(timeSlot.id, timeSlot.toJson());
  }

  @override
  Future<void> delete(int id) async {
    await _myTimeSlots.delete(id);
  }
}
