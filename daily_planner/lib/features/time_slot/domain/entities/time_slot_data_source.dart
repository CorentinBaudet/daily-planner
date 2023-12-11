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

  List<TimeSlot> get timeSlots {
    List<TimeSlot> timeSlots = <TimeSlot>[];

    for (var appointment in appointments!) {
      timeSlots.add(TimeSlot(
        startTime: appointment.from,
        endTime: appointment.to,
        subject: appointment.eventName,
        id: appointment.id,
        color: appointment.background,
        recurrenceRule: appointment.recurrenceRule,
        createdAt: appointment.createdAt,
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
      switch (timeSlot.runtimeType) {
        case Task:
          // TODO handle overlapping tasks
          if ((timeSlot as Task).isPlanned)
            builtTimeSlots.add(timeSlot as Task);
          break;

        case Block:
          _handleBlock(builtTimeSlots, timeSlot);
          break;

        case WorkBlock:
          _handleWorkBlock(builtTimeSlots, timeSlot, isTomorrow);
          break;

        default:
          // TODO: handle this case by logging an error
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
      color: timeSlot.color,
      recurrenceRule: timeSlot.recurrenceRule,
      // createdAt: timeSlot.createdAt,
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
      color: timeSlot.color,
      recurrenceRule: timeSlot.recurrenceRule,
      // createdAt: timeSlot.createdAt,
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
