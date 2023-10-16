import 'package:daily_planner/utils/utils.dart';

class TimeSlotUseCases {
  // method to get all 15min start time slots for today
  List<String> getStartTimeSlots() {
    final timeSlots = <String>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final tomorrow = today.add(const Duration(days: 1));
    const timeSlotDuration = Duration(minutes: 15);

    for (var i = today; i.isBefore(tomorrow); i = i.add(timeSlotDuration)) {
      timeSlots.add(Utils().formatTime(i));
    }
    return timeSlots;
  }
}
