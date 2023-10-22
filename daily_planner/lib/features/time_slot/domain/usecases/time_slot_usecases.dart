import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

class TimeSlotUseCases {
  // method to get all 15min start time slots for today
  List<DateTime> getTodayStartTimes() {
    final timeSlots = <DateTime>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final tomorrow = today.add(const Duration(days: 1));
    const timeSlotDuration = Duration(minutes: 15);

    for (var i = today; i.isBefore(tomorrow); i = i.add(timeSlotDuration)) {
      timeSlots.add(i);
    }
    return timeSlots;
  }

  List<DateTime> getTomorrowStartTimes() {
    final timeSlots = <DateTime>[];
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    final afterTomorrow = tomorrow.add(const Duration(days: 1));
    const timeSlotDuration = Duration(minutes: 15);

    for (var i = tomorrow;
        i.isBefore(afterTomorrow);
        i = i.add(timeSlotDuration)) {
      timeSlots.add(i);
    }
    return timeSlots;
  }

  // method to retrieve timeslots that contains a block
  List<TimeSlot> getBlockTimeSlots(List<TimeSlot> timeSlots) {
    return timeSlots
        .where((timeSlot) => timeSlot.event.runtimeType == Block)
        .toList();
  }

  List<TimeSlot> getTomorrowTimeSlots(List<TimeSlot> timeSlots) {
    final tomorrowTimeSlots = <TimeSlot>[];
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    for (var timeSlot in timeSlots) {
      // if this is a block time slot, keep it
      if (timeSlot.event.runtimeType == Block) {
        tomorrowTimeSlots.add(timeSlot);
        continue;
      }
      if (timeSlot.startTime.day == tomorrow.day) {
        tomorrowTimeSlots.add(timeSlot);
      }
    }
    return tomorrowTimeSlots;
  }

  // method to sort time slots by start time and duration
  List<TimeSlot> sortTimeSlots(List<TimeSlot> timeSlots) {
    // TODO : fix car ça ne marche pas
    // timeSlots.sort((a, b) {
    //   final aStart = a.startTime;
    //   final bStart = b.startTime;
    //   final aEnd = aStart.add(Duration(minutes: a.duration));
    //   final bEnd = bStart.add(Duration(minutes: b.duration));

    //   if (aStart.isBefore(bStart)) {
    //     return -1;
    //   } else if (aStart.isAfter(bStart)) {
    //     return 1;
    //   } else {
    //     if (aEnd.isBefore(bEnd)) {
    //       return -1;
    //     } else if (aEnd.isAfter(bEnd)) {
    //       return 1;
    //     } else {
    //       return 0;
    //     }
    //   }
    // });
    return timeSlots;
  }

  bool isBeforeOrSameTimeInDay(DateTime first, DateTime second) {
    return first.hour <= second.hour ||
        (first.hour == second.hour && first.minute <= second.minute);
  }

  bool isAfterInDay(DateTime second, DateTime first) {
    return second.hour > first.hour ||
        (second.hour == first.hour && second.minute > first.minute);
  }

  bool isBetweenInDay(DateTime time, DateTime startTime, DateTime endTime) {
    return isBeforeOrSameTimeInDay(startTime, time) &&
        isAfterInDay(endTime, time);
  }
}
