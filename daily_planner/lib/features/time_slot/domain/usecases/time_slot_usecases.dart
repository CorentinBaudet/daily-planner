import 'package:daily_planner/features/time_slot/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/work_block_entity.dart';
import 'package:flutter/material.dart';

// TODO this class might have too much methods, some of them may be moved to extensions for example
class TimeSlotUseCases {
  // method to get all 15min start time slots for tomorrow
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

  // method to retrieve timeslots that contains a work block
  static List<TimeSlot> getWorkBlockTimeSlots(List<TimeSlot> timeSlots) {
    return timeSlots
        .where((timeSlot) => timeSlot.runtimeType == WorkBlock)
        .toList();
  }

  static List<TimeSlot> getTomorrowTimeSlots(List<TimeSlot> timeSlots) {
    final tomorrowTimeSlots = <TimeSlot>[];
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    for (var timeSlot in timeSlots) {
      // if this is a block time slot, keep it
      if (timeSlot.runtimeType == Block) {
        tomorrowTimeSlots.add(timeSlot);
        continue;
      }
      if (timeSlot.startTime.day == tomorrow.day) {
        tomorrowTimeSlots.add(timeSlot);
      }
    }
    return tomorrowTimeSlots;
  }

  // method to sort time slots by start time and end time
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
    return first.hour <= second.hour ||
        (first.hour == second.hour && first.minute <= second.minute);
  }

  static bool isAfterInDay(DateTime second, DateTime first) {
    return second.hour > first.hour ||
        (second.hour == first.hour && second.minute > first.minute);
  }

  // method to check if a given time is between two boundaries
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

  // method to check if two time slots are starting and ending at the same hour and minute
  static bool isSameTimeSlot(TimeSlot timeSlot, first) {
    return timeSlot.startTime.hour == first.startTime.hour &&
        timeSlot.startTime.minute == first.startTime.minute &&
        timeSlot.endTime.hour == first.endTime.hour &&
        timeSlot.endTime.minute == first.endTime.minute;
  }

  static bool isValidTimeSlot(TimeSlot timeSlot) {
    // test if the end time is before the start time
    if (timeSlot.endTime.isBefore(timeSlot.startTime) ||
        timeSlot.endTime.isAtSameMomentAs(timeSlot.startTime)) {
      return false;
    }

    // test if the time slot duration is at least 15 min
    if (timeSlot.endTime.difference(timeSlot.startTime).inMinutes < 15) {
      return false;
    }

    return true;
  }

  // TimeSlot? searchForEmptyTimeSlot(BuildContext context, Task task) {
  //   List<TimeSlot> timeSlots = [];

  //   if (context.read<TimeSlotCubit>().state is LoadedState) {
  //     timeSlots =
  //         (context.read<TimeSlotCubit>().state as LoadedState).timeSlots;
  //   }

  //   // only keep time slots of tomorrow and block time slots
  //   timeSlots = TimeSlotUseCases().getTomorrowTimeSlots(timeSlots);

  //   TimeSlot? resultTimeSlot = _searchForWorkBlock(timeSlots);
  //   if (resultTimeSlot != null) {
  //     // if there is an empty work block, return it
  //     return resultTimeSlot;
  //   }
  //   return _searchForTimeSlot(timeSlots, task);
  // }

  // static TimeSlot? getEmptyTimeSlotForTask(List<TimeSlot> timeSlots, Task task) {
  //   // first look for the first empty work block
  //   _searchForWorkBlock(timeSlots);

  //   DateTime taskStartTime =
  //       DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //   bool isTaskStartTimeFound = false;

  //   // search for the first empty time slot by looking at start times of today
  //   while (isTaskStartTimeFound == false) {
  //     // is the current start time at the same time as a time slot tomorrow ?
  //     if (timeSlots.any((element) => TimeSlotUseCases()
  //         .isBetweenInDay(taskStartTime, element.startTime, element.endTime))) {
  //       // the current start time is not free, so we reset the flag
  //       taskStartTime = taskStartTime.add(const Duration(minutes: 15));
  //     } else {
  //       isTaskStartTimeFound = true;
  //     }
  //   }

  //   return null;
  // }

  // TimeSlot? _searchForWorkBlock(List<TimeSlot> timeSlots) {
  //   List<TimeSlot> blockTimeSlots =
  //       TimeSlotUseCases().getWorkBlockTimeSlots(timeSlots);

  //   print("blockTimeSlots: $blockTimeSlots");

  //   // for (var block in blockTimeSlots) {
  //   //   if (block.runtimeType != WorkBlock) {
  //   //     continue;
  //   //   }

  //   //   // is there a time slot that starts at the same time as the block ?
  //   //   if (!timeSlots.any((timeSlot) {
  //   //     // if the time slot is a block, we don't compare it
  //   //     if (timeSlot.event is Block) {
  //   //       return false;
  //   //     }
  //   //     // if the task time slot starts at the same time as the block time slot
  //   //     if (timeSlot.startTime.hour == block.startTime.hour &&
  //   //         timeSlot.startTime.minute == block.startTime.minute) {
  //   //       // the block is already used
  //   //       return true;
  //   //     }
  //   //     // the block is not used
  //   //     return false;
  //   //   })) {
  //   //     return block;
  //   //   }
  //   // }
  //   return null;
  // }

  // TimeSlot? _searchForTimeSlot(List<TimeSlot> timeSlots, Task task) {
  //   // search for the first empty time slot by looking at start times of today
  //   List<DateTime> startTimes = TimeSlotUseCases().getTomorrowStartTimes();
  //   int sixtyMinFlag = 0;
  //   for (DateTime currentStartTime in startTimes) {
  //     // is the current start time at the same time as a time slot tomorrow ?
  //     if (timeSlots.any((element) => TimeSlotUseCases().isBetweenInDay(
  //         currentStartTime, element.startTime, element.endTime))) {
  //       // the current start time is not free, so we reset the flag
  //       sixtyMinFlag = 0;
  //     } else {
  //       sixtyMinFlag++;
  //       // we count to 4 to see if there is a 60 min empty time slot
  //       if (sixtyMinFlag == 4) {
  //         // substract 45 min to the current start time to get the right empty start time
  //         currentStartTime =
  //             currentStartTime.subtract(const Duration(minutes: 45));
  //         return TimeSlot(
  //             startTime: currentStartTime,
  //             endTime: currentStartTime.add(const Duration(minutes: 60)),
  //             event: task,
  //             createdAt: Utils().troncateDateTime(DateTime.now()));
  //       }
  //     }
  //   }
  //   // if no empty time slot was found
  //   return null;
  // }
}
