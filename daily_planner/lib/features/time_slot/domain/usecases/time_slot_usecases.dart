import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSlotUseCases {
  // method to get all 15min start time slots for tomorrow
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

  // method to sort time slots by start time and end time
  List<TimeSlot> sortTimeSlots(List<TimeSlot> timeSlots) {
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

  bool isBeforeOrSameTimeInDay(DateTime first, DateTime second) {
    return first.hour <= second.hour ||
        (first.hour == second.hour && first.minute <= second.minute);
  }

  bool isAfterInDay(DateTime second, DateTime first) {
    return second.hour > first.hour ||
        (second.hour == first.hour && second.minute > first.minute);
  }

  bool isBetweenInDay(DateTime time, DateTime startTime, DateTime endTime) {
    // if the time slot is in the same day
    if (startTime.isBefore(endTime)) {
      return isBeforeOrSameTimeInDay(startTime, time) &&
          isAfterInDay(endTime, time);
      // if the time slot is between two days
    } else {
      return !isBeforeOrSameTimeInDay(endTime, time);
    }
  }

  TimeSlot? searchForTimeSlot(BuildContext context, Task task) {
    List<TimeSlot> timeSlots = [];

    if (context.read<TimeSlotCubit>().state is LoadedState) {
      timeSlots =
          (context.read<TimeSlotCubit>().state as LoadedState).timeSlots;
    }

    // only keep time slots of tomorrow and block time slots
    timeSlots = TimeSlotUseCases().getTomorrowTimeSlots(timeSlots);

    TimeSlot? resultTimeSlot = _searchForWorkBlock(timeSlots);
    if (resultTimeSlot != null) {
      // if there is an empty work block, return it
      return resultTimeSlot;
    }

    return _searchForEmptyTimeSlot(timeSlots, task);
  }

  TimeSlot? _searchForWorkBlock(List<TimeSlot> timeSlots) {
    for (var block in TimeSlotUseCases().getBlockTimeSlots(timeSlots)) {
      if ((block.event as Block).isWork == false) {
        continue;
      }

      // is there a time slot that starts at the same time as the block ?
      if (!timeSlots.any((timeSlot) {
        // if the time slot is a block, we don't compare it
        if (timeSlot.event is Block) {
          return false;
        }
        // if the task time slot starts at the same time as the block time slot
        if (timeSlot.startTime.hour == block.startTime.hour &&
            timeSlot.startTime.minute == block.startTime.minute) {
          // the block is already used
          return true;
        }
        // the block is not used
        return false;
      })) {
        return block;
      }
    }
    return null;
  }

  TimeSlot? _searchForEmptyTimeSlot(List<TimeSlot> timeSlots, Task task) {
    // search for the first empty time slot by looking at start times of today
    List<DateTime> startTimes = TimeSlotUseCases().getTomorrowStartTimes();
    int sixtyMinFlag = 0;
    for (DateTime currentStartTime in startTimes) {
      // is the current start time at the same time as a time slot tomorrow ?
      if (timeSlots.any((element) => TimeSlotUseCases().isBetweenInDay(
          currentStartTime, element.startTime, element.endTime))) {
        // the current start time is not free, so we reset the flag
        sixtyMinFlag = 0;
      } else {
        sixtyMinFlag++;
        // we count to 4 to see if there is a 60 min empty time slot
        if (sixtyMinFlag == 4) {
          // substract 45 min to the current start time to get the right empty start time
          currentStartTime =
              currentStartTime.subtract(const Duration(minutes: 45));
          return TimeSlot(
              startTime: currentStartTime,
              endTime: currentStartTime.add(const Duration(minutes: 60)),
              event: task,
              createdAt: Utils().troncateDateTime(DateTime.now()));
        }
      }
    }
    // if no empty time slot was found
    return null;
  }
}
