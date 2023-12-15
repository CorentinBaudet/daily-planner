import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/block/domain/entities/work_block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:flutter/material.dart';

class TimeSlotDataSourceUseCases {
  static TimeSlot? searchForEmptyTimeSlot(
      List<TimeSlot> timeSlots, TimeSlot timeSlot,
      {bool isTomorrow = false}) {
    DateTime startDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    startDate = isTomorrow ? startDate.add(const Duration(days: 1)) : startDate;

    // traitement
    switch (timeSlot.runtimeType) {
      case Task:
        return _searchForEmptyTimeSlotForTask(timeSlots, timeSlot as Task);
    }
    return null;
  }

  static TimeSlot? _searchForEmptyTimeSlotForTask(
      List<TimeSlot> timeSlots, Task task) {
    debugPrint('searching for empty time slot for task');

    // first look for the first empty work block
    WorkBlock? emptyWorkBlock = _searchForWorkBlock(timeSlots);

    // if a work block was found, return it
    if (emptyWorkBlock != null) {
      return emptyWorkBlock;
    }

    // if no work block was found, look for an empty time slot
    TimeSlot? emptyTimeSlot = _searchForTimeSlot(timeSlots);

    if (emptyTimeSlot != null) {
      return emptyTimeSlot;
    }

    return null;
  }

  static WorkBlock? _searchForWorkBlock(List<TimeSlot> timeSlots) {
    List<WorkBlock> workBlockTimeSlots =
        TimeSlotUseCases.getWorkBlockTimeSlots(timeSlots);

    for (WorkBlock workBlock in workBlockTimeSlots) {
      if (workBlock.todayTaskId == 0) {
        return workBlock;
      }
    }
    return null;
  }

  static TimeSlot? _searchForTimeSlot(List<TimeSlot> timeSlots) {
    // search for the first empty time slot by looking at start times of today
    List<DateTime> startTimes = TimeSlotUseCases.getTomorrowStartTimes();
    int sixtyMinFlag = 0;
    for (DateTime currentStartTime in startTimes) {
      // is the current start time at the same time as a time slot tomorrow ?
      if (timeSlots.any((element) => TimeSlotUseCases.isBetweenInDay(
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
              subject: "");
        }
      }
    }
    // if no empty time slot was found
    return null;
  }
}
