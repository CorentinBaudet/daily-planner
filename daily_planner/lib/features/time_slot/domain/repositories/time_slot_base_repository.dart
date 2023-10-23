import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

abstract class TimeSlotBaseRepository {
  List<TimeSlot> getTimeSlots();
  TimeSlot getTimeSlot(int id);
  Future<void> create(TimeSlot timeSlot);
  Future<void> update(TimeSlot timeSlot);
  Future<void> delete(int id);
}
