import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// TODO refactor this entity, too much logic in it
class TimeSlotDataSource extends CalendarDataSource {
  TimeSlotDataSource(List<Appointment> source) {
    appointments = source;
  }

  static CalendarDataSource getPlannerDataSource(
      BuildContext context, List<TimeSlot> timeSlots,
      {bool isTomorrow = false}) {
    List<Appointment> appointments =
        <Appointment>[]; // the SfCalendar requires a list of Appointment objects

    for (var timeSlot in timeSlots) {
      if (timeSlot.event.runtimeType == Task) {
        // if the event is a task, it is a one-time event

        List<TimeSlot> allTimeSlots =
            context.read<TimeSlotCubit>().repository.getTimeSlots();
        bool taskIsOnWorkBlock = false;
        // look for a timeslot containing a work block starting and ending at the same time as the current appointment
        for (var timeSlotItem in allTimeSlots) {
          if (timeSlotItem.event is Block &&
              (timeSlotItem.event as Block).isWork &&
              TimeSlotUseCases().isSameTimeSlot(timeSlotItem, timeSlot)) {
            // if a work block is found, we don't add the task
            taskIsOnWorkBlock = true;
            break;
          }
        }
        if (!taskIsOnWorkBlock) {
          // if no work block is found, we add the task
          addTaskToCalendar(appointments, timeSlot);
        }
      } else {
        // else the event is a block, it is a recurring event
        addBlockToCalendar(timeSlot, appointments, isTomorrow);
      }
    }

    // update the tasks visually if they are passed
    handleTasksPassed(context, appointments);

    return TimeSlotDataSource(appointments);
  }

  static void addTaskToCalendar(
      // TODO handle overlapping tasks
      List<Appointment> appointments,
      TimeSlot timeSlot) {
    appointments.add(Appointment(
        id: timeSlot.id,
        startTime: timeSlot.startTime,
        endTime: timeSlot.endTime,
        subject: timeSlot.event.name,
        // color: Colors.lightBlue.shade100,
        color: const Color(0xFFffc2a9)));
  }

  static void addBlockToCalendar(
      TimeSlot timeSlot, List<Appointment> appointments, bool isTomorrow) {
    // if the end time is before the start time, it means that the block ends the next day
    bool isOverlap =
        timeSlot.endTime.isBefore(timeSlot.startTime) ? true : false;
    RecurrenceProperties recurrenceProperties =
        RecurrenceProperties(startDate: DateTime.now());
    recurrenceProperties.recurrenceType = RecurrenceType.daily;

    appointments.add(Appointment(
        id: timeSlot.id,
        startTime: DateTime(
            timeSlot.startTime.year,
            timeSlot.startTime.month,
            // isTomorrow ? DateTime.now().day + 1 : DateTime.now().day,
            timeSlot.startTime.day,
            timeSlot.startTime.hour,
            timeSlot.startTime.minute),
        endTime: DateTime(
            timeSlot.endTime.year,
            timeSlot.endTime.month,
            // isTomorrow ? DateTime.now().day + 1 : DateTime.now().day,
            timeSlot.startTime.day,
            // in case of overlap, end at 24:00 makes a double arrow appear which hides the block name
            isOverlap ? 23 : timeSlot.endTime.hour,
            isOverlap ? 59 : timeSlot.endTime.minute),
        subject: timeSlot.event.name,
        // notes: timeSlot.event.name,
        // color: Colors.indigo.shade50,
        color: const Color(0xFFffe7dc),
        recurrenceRule: SfCalendar.generateRRule(
          recurrenceProperties,
          timeSlot.startTime,
          timeSlot.endTime,
        )));

    // if the block ends the next day, we add it again to the calendar the next day
    if (isOverlap) {
      addOverlap(appointments, timeSlot, isTomorrow);
    }
  }

  static void addOverlap(
      List<Appointment> appointments, TimeSlot timeSlot, bool isTomorrow) {
    appointments.add(Appointment(
        id: timeSlot.id,
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            isTomorrow ? DateTime.now().day + 1 : DateTime.now().day, 0, 0),
        endTime: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            isTomorrow ? DateTime.now().day + 1 : DateTime.now().day,
            timeSlot.endTime.hour,
            timeSlot.endTime.minute),
        subject: timeSlot.event.name,
        // color: Colors.indigo.shade50,
        color: const Color(0xFFffe7dc),
        recurrenceRule: 'FREQ=DAILY;INTERVAL=1'));
  }

  static void handleTasksPassed(
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
}
