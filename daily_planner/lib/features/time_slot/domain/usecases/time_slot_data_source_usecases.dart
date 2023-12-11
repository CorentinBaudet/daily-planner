import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';

class TimeSlotDataSourceUseCases {
  static TimeSlot? searchForEmptyTimeSlot(
      List<TimeSlot> timeSlots, TimeSlot timeSlot,
      {bool isTomorrow = false}) {
    DateTime startDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    startDate = isTomorrow ? startDate.add(const Duration(days: 1)) : startDate;

    print("timeSlots: $timeSlots");
    // List<Appointment> appointments = getVisibleAppointments(startDate, '');

    // traitement
    switch (timeSlot.runtimeType) {
      case Task:
        return _searchForEmptyTimeSlotForTask(timeSlots, timeSlot as Task);
    }
    return null;

    // return TimeSlot(
    //   startTime: appointments[0].startTime,
    //   endTime: appointments[0].endTime.add(const Duration(minutes: 60)),
    //   subject: timeSlotEvent.subject,
    //   color: timeSlotEvent.color,
    //   event: timeSlotEvent.event,
    //   recurrenceRule: timeSlotEvent.event is Block ? 'FREQ=DAILY;' : null,
    // );
  }

  static TimeSlot? _searchForEmptyTimeSlotForTask(
      List<TimeSlot> timeSlots, Task task) {
    print('searching for empty time slot for task');

    // first look for the first empty work block
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

    // if (emptyTimeSlot == null) {
    //   return null;
    // }

    // sinon retourne l'objet time slot complet
    return null;
  }

  // static TimeSlot? _searchForWorkBlock(List<TimeSlot> timeSlots) {
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

  // static TimeSlot? _searchForTimeSlot(List<TimeSlot> timeSlots, Task task) {
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
