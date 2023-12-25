import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/block/domain/entities/work_block_entity.dart';
import 'package:flutter/material.dart';

// TODO this class might have too much methods, some of them may be moved to extensions for example
class TimeSlotUseCases {
  // Method to get all 15 min start time slots for tomorrow
  static List<DateTime> getTomorrowStartTimes() {
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

  // Method to retrieve timeslots that contains a work block
  static List<WorkBlock> getWorkBlockTimeSlots(List<TimeSlot> timeSlots) {
    List<WorkBlock> workBlocks = [];
    for (var timeSlot in timeSlots) {
      if (timeSlot.runtimeType == WorkBlock) {
        workBlocks.add(timeSlot as WorkBlock);
      }
    }
    return workBlocks;
  }

  // Method to sort time slots by start time and end time
  static List<TimeSlot> sortTimeSlots(List<TimeSlot> timeSlots) {
    timeSlots.sort((a, b) {
      final aStart = TimeOfDay.fromDateTime(a.startTime);
      final bStart = TimeOfDay.fromDateTime(b.startTime);
      final aEnd = TimeOfDay.fromDateTime(a.endTime);
      final bEnd = TimeOfDay.fromDateTime(b.endTime);

      if (aStart.hour < bStart.hour ||
          (aStart.hour == bStart.hour && aStart.minute < bStart.minute)) {
        return -1;
      } else if (aStart.hour > bStart.hour ||
          (aStart.hour == bStart.hour && aStart.minute > bStart.minute)) {
        return 1;
      } else {
        if (aEnd.hour < bEnd.hour ||
            (aEnd.hour == bEnd.hour && aEnd.minute < bEnd.minute)) {
          return -1;
        } else if (aEnd.hour > bEnd.hour ||
            (aEnd.hour == bEnd.hour && aEnd.minute > bEnd.minute)) {
          return 1;
        } else {
          return 0;
        }
      }
    });
    return timeSlots;
  }

  static bool isBeforeOrSameTimeInDay(DateTime first, DateTime second) {
    TimeOfDay time1 = TimeOfDay.fromDateTime(first);
    TimeOfDay time2 = TimeOfDay.fromDateTime(second);

    return time1.hour <= time2.hour ||
        (time1.hour == time2.hour && time1.minute <= time2.minute);
  }

  static bool isAfterInDay(DateTime second, DateTime first) {
    return second.hour > first.hour ||
        (second.hour == first.hour && second.minute > first.minute);
  }

  // Method to check if a given time is between two boundaries
  static bool isBetweenInDay(
      DateTime time, DateTime startTime, DateTime endTime) {
    // if the time slot is in the same day
    if (startTime.isBefore(endTime)) {
      return isBeforeOrSameTimeInDay(startTime, time) &&
          isAfterInDay(endTime, time);
      // if the time slot is between two days
    } else {
      return !isBeforeOrSameTimeInDay(endTime, time);
    }
  }

  static bool isValidTimeSlot(TimeSlot timeSlot) {
    // Check if the end time is before the start time
    if (isBeforeOrSameTimeInDay(timeSlot.endTime, timeSlot.startTime)) {
      return false;
    }

    // test if the time slot duration is at least 15 min
    if (timeSlot.endTime.difference(timeSlot.startTime).inMinutes < 15) {
      return false;
    }

    return true;
  }
}
