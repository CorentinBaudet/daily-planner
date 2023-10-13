import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/repositories/time_slot_base_repository.dart';
import 'package:hive/hive.dart';

class TimeSlotLocalStorageRepository extends TimeSlotBaseRepository {
  final Box _myTimeSlots = Hive.box('my_time_slots');

  TimeSlotLocalStorageRepository();

  @override
  List<TimeSlot> getTimeSlots() {
    final timeSlots = _myTimeSlots.values;

    List<TimeSlot> timeSlotList = [];

    for (var timeSlot in timeSlots) {
      timeSlotList.add(TimeSlot.fromJson(timeSlot));
    }
    return timeSlotList;
  }

  @override
  Future<void> create(TimeSlot timeSlot) async {
    timeSlot.id = timeSlot.hashCode;
    await _myTimeSlots.put(timeSlot.id, timeSlot.toJson());
  }

  @override
  Future<TimeSlot> read(int id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<void> update(TimeSlot timeSlot) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> delete(int id) async {
    await _myTimeSlots.delete(id);
  }
}
