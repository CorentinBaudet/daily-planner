import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_event_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/work_block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// TODO refactor this entity, too much logic in it
class TimeSlotDataSource extends CalendarDataSource {
  TimeSlotDataSource(this.source);

  List<TimeSlot> source;

  @override
  List<dynamic> get appointments => source;

  static TimeSlotDataSource getDataSource(
      BuildContext context, List<TimeSlot> storedTimeSlots,
      {bool isTomorrow = false}) {
    List<TimeSlot> builtTimeSlots =
        _buildDataSource(context, storedTimeSlots, isTomorrow: isTomorrow);

    // update the tasks visually if they are passed
    _handleTasksPassed(context, builtTimeSlots);

    return TimeSlotDataSource(builtTimeSlots);
  }

  static List<TimeSlot> _buildDataSource(
      BuildContext context, List<TimeSlot> storedTimeSlots,
      {bool isTomorrow = false}) {
    // TODO something is wrong : buildTimeSlots is created two times
    List<TimeSlot> builtTimeSlots =
        <TimeSlot>[]; // the SfCalendar requires a list of Appointment objects to build the data source

    for (var timeSlot in storedTimeSlots) {
      switch (timeSlot.event.runtimeType) {
        case Task:
          // if the event is a task, it is a one-time event
          _handleTask(builtTimeSlots, timeSlot);
          break;

        case Block:
        case WorkBlock:
          _handleBlock(builtTimeSlots, timeSlot, isTomorrow);
          break;
      }
    }

    return builtTimeSlots;
  }

  // this function will never be called I think
  // TODO handle overlapping tasks
  static void _handleTask(List<TimeSlot> builtTimeSlots, TimeSlot timeSlot) {
    builtTimeSlots.add(timeSlot);
    // appointments.add(TimeSlot(
    //     id: timeSlotEvent.id,
    //     startTime: timeSlotEvent.startTime,
    //     endTime: timeSlotEvent.endTime,
    //     subject: timeSlotEvent.event.name,
    //     color: const Color(0xFFffc2a9)));
  }

  static void _handleBlock(
      List<TimeSlot> builtTimeSlots, TimeSlot timeSlot, bool isTomorrow) {
    // if the end time is before the start time, it means that the block ends the next day
    bool isOverlap =
        timeSlot.endTime.isBefore(timeSlot.startTime) ? true : false;

    // if the block ends the next day, we add it again to the calendar the next day
    if (isOverlap) {
      builtTimeSlots.add(TimeSlot(
        id: timeSlot.id,
        startTime: timeSlot.startTime,
        endTime: DateTime(
            timeSlot.endTime.year,
            timeSlot.endTime.month,
            timeSlot.startTime.day,
            // in case of overlap, end at 24:00 makes a double arrow appear which hides the block name
            23,
            59),
        subject: timeSlot.subject,
        event: timeSlot.event,
        color: timeSlot.color,
        recurrenceRule: timeSlot.recurrenceRule,
      ));
      builtTimeSlots.add(_addOverlap(timeSlot, isTomorrow));
    } else {
      builtTimeSlots.add(timeSlot);
    }
  }

  static TimeSlot _addOverlap(TimeSlot timeSlot, bool isTomorrow) {
    return TimeSlot(
        id: timeSlot.id,
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            isTomorrow ? DateTime.now().day + 1 : DateTime.now().day, 0, 0),
        endTime: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            isTomorrow ? DateTime.now().day + 1 : DateTime.now().day,
            timeSlot.endTime.hour,
            timeSlot.endTime.minute),
        subject: timeSlot.subject,
        event: timeSlot.event,
        color: timeSlot.color,
        recurrenceRule: 'FREQ=DAILY;');
  }

  static void _handleTasksPassed(
      BuildContext context, List<Appointment> appointments) {
    for (var appointment in appointments) {
      if (appointment.appointmentType != AppointmentType.normal) {
        continue;
      }

      // if the appointment is passed, we change its color to grey
      if (appointment.endTime.isBefore(DateTime.now())) {
        appointment.color = Colors.grey.shade300;

        // TimeSlot timeSlot = context
        //     .read<TimeSlotCubit>()
        //     .repository
        //     .getTimeSlot(appointment.id as int);
        // Task task = context
        //     .read<TaskCubit>()
        //     .repository
        //     .getTask((timeSlot.event as Task).id as int);
        // task.isPlanned = true;
      }
    }
  }

  TimeSlot? searchForEmptyTimeSlot(TimeSlotEvent timeSlotEvent,
      {bool isTomorrow = false}) {
    DateTime startDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    startDate = isTomorrow ? startDate.add(const Duration(days: 1)) : startDate;

    print("source: $source");
    List<Appointment> appointments = getVisibleAppointments(startDate, '');

    // traitement
    switch (timeSlotEvent.runtimeType) {
      case Task:
        return _searchForEmptyTimeSlotForTask(source, timeSlotEvent as Task);
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

  TimeSlot? _searchForEmptyTimeSlotForTask(
      List<TimeSlot> timeSlots, Task task) {
    print('searching for empty time slot for task');

    // traitement dans TimeSlotUseCases
    TimeSlot? emptyTimeSlot =
        TimeSlotUseCases().getEmptyTimeSlotForTask(timeSlots, task);

    if (emptyTimeSlot == null) {
      return null;
    }

    // sinon retourne l'objet time slot complet
    return null;
  }
}
