import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/work_block_entity.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// TODO refactor this entity, too much logic in it
class TimeSlotDataSource extends CalendarDataSource {
  TimeSlotDataSource(List<TimeSlot> source) {
    appointments = source;
  }

  // /* #region SfCalendar methods */
  // @override
  // DateTime getStartTime(int index) {
  //   return appointments?[index].from;
  // }

  // @override
  // DateTime getEndTime(int index) {
  //   return appointments?[index].to;
  // }

  // @override
  // String getSubject(int index) {
  //   return appointments?[index].eventName;
  // }

  // @override
  // bool isAllDay(int index) {
  //   return appointments?[index].isAllDay;
  // }

  // @override
  // Color getColor(int index) {
  //   return appointments?[index].background;
  // }
  // /* #endregion */

  List<TimeSlot> get timeSlots {
    List<TimeSlot> timeSlots = <TimeSlot>[];

    for (var appointment in appointments!) {
      timeSlots.add(TimeSlot(
        id: appointment.id,
        startTime: appointment.from,
        endTime: appointment.to,
        subject: appointment.eventName,
        color: appointment.background,
        event: appointment.event,
        recurrenceRule: appointment.recurrenceRule,
      ));
    }

    return timeSlots;
  }

  static TimeSlotDataSource getCalendarDataSource(
      List<TimeSlot> storedTimeSlots,
      {bool isTomorrow = false}) {
    // TODO something is wrong : buildTimeSlots is created two times
    List<TimeSlot> builtTimeSlots =
        <TimeSlot>[]; // the SfCalendar requires a list of Appointment objects to build the data source

    for (var timeSlot in storedTimeSlots) {
      switch (timeSlot.event.runtimeType) {
        case Task:
          // this will never be called I think
          // TODO handle overlapping tasks
          builtTimeSlots.add(timeSlot);
          break;

        case Block:
          _handleBlock(builtTimeSlots, timeSlot);
          break;

        case WorkBlock:
          _handleWorkBlock(builtTimeSlots, timeSlot, isTomorrow);
          break;
      }
    }

    // update the tasks visually if they are passed
    // _handleTasksPassed(context, builtTimeSlots);

    return TimeSlotDataSource(builtTimeSlots);
  }

  static void _handleBlock(List<TimeSlot> builtTimeSlots, TimeSlot timeSlot) {
    // if the end time is before the start time, it means that the block ends the next day
    bool isOverlap =
        timeSlot.endTime.isBefore(timeSlot.startTime) ? true : false;

    // if the block ends the next day, we add it again to the calendar the next day
    if (!isOverlap) {
      builtTimeSlots.add(timeSlot);
      return;
    }

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
    builtTimeSlots.add(_addOverlap(timeSlot));
  }

  // TODO : make WorkBlock non recurring, handle today and tomorrow difference
  static void _handleWorkBlock(
      List<TimeSlot> builtTimeSlots, TimeSlot timeSlot, bool isTomorrow) {
    bool isOverlap =
        timeSlot.endTime.isBefore(timeSlot.startTime) ? true : false;

    // if the block ends the next day, we add it again to the calendar the next day
    if (!isOverlap) {
      builtTimeSlots.add(timeSlot);
      return;
    }

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
    builtTimeSlots.add(_addOverlap(timeSlot));
  }

  static TimeSlot _addOverlap(TimeSlot timeSlot, {bool isTomorrow = false}) {
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

  // static void _handleTasksPassed(
  //     BuildContext context, List<Appointment> appointments) {
  //   for (var appointment in appointments) {
  //     if (appointment.appointmentType != AppointmentType.normal) {
  //       continue;
  //     }

  //     // if the appointment is passed, we change its color to grey
  //     if (appointment.endTime.isBefore(DateTime.now())) {
  //       appointment.color = Colors.grey.shade300;

  //       // TimeSlot timeSlot = context
  //       //     .read<TimeSlotCubit>()
  //       //     .repository
  //       //     .getTimeSlot(appointment.id as int);
  //       // Task task = context
  //       //     .read<TaskCubit>()
  //       //     .repository
  //       //     .getTask((timeSlot.event as Task).id as int);
  //       // task.isPlanned = true;
  //     }
  //   }
  // }
}
