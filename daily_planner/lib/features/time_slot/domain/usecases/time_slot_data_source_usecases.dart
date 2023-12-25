import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/block/domain/entities/work_block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';

class TimeSlotDataSourceUseCases {
  static TimeSlot? searchEmptyTimeSlot(
      List<TimeSlot> timeSlots, TimeSlot timeSlot,
      {bool isTomorrow = false}) {
    // DateTime startDate =
    //     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // startDate = isTomorrow ? startDate.add(const Duration(days: 1)) : startDate;

    switch (timeSlot.runtimeType) {
      case Task:
        return _searchEmptyTimeSlotForTask(timeSlots, timeSlot as Task,
            isTomorrow: isTomorrow);
    }
    return null;
  }

  static TimeSlot? _searchEmptyTimeSlotForTask(
      List<TimeSlot> timeSlots, Task task,
      {bool isTomorrow = false}) {
    // first look for the first empty work block
    WorkBlock? emptyWorkBlock =
        _searchForWorkBlock(timeSlots, isTomorrow: isTomorrow);

    // if a work block was found, return it
    if (emptyWorkBlock != null) {
      return emptyWorkBlock;
    }

    // if no work block was found, look for an empty time slot
    TimeSlot? emptyTimeSlot =
        _searchForTimeSlot(timeSlots, isTomorrow: isTomorrow);

    if (emptyTimeSlot != null) {
      return emptyTimeSlot;
    }

    return null;
  }

  static WorkBlock? _searchForWorkBlock(List<TimeSlot> timeSlots,
      {bool isTomorrow = false}) {
        return null;
      
    // List<WorkBlock> workBlockTimeSlots =
    //     TimeSlotUseCases.getWorkBlockTimeSlots(timeSlots);

    // if (isTomorrow) {
    //   for (WorkBlock workBlock in workBlockTimeSlots) {
    //     if (workBlock.tomorrowTaskId == 0) {
    //       return workBlock;
    //     }
    //   }
    // } else {
    //   for (WorkBlock workBlock in workBlockTimeSlots) {
    //     if (workBlock.todayTaskId == 0) {
    //       return workBlock;
    //     }
    //   }
    // }
    // return null;
  }

  static TimeSlot? _searchForTimeSlot(List<TimeSlot> timeSlots,
      {bool isTomorrow = false}) {
    // Search for the first empty time slot by looking at available start times
    List<DateTime> startTimes;
    if (isTomorrow) {
      startTimes = TimeSlotUseCases.getTomorrowStartTimes();
    } else {
      startTimes = [];
    }

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

  // Method to retrieve a Task starting at a given time
  static Task? getTaskStartingAt(List<TimeSlot> timeSlots, DateTime startTime) {
    for (TimeSlot timeSlot in timeSlots) {
      if (timeSlot.runtimeType == Task) {
        if (timeSlot.startTime == startTime) {
          return timeSlot as Task;
        }
      }
    }
    return null;
  }
}
