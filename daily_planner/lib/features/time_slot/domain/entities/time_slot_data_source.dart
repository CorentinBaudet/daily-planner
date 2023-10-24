import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotDataSource extends CalendarDataSource {
  TimeSlotDataSource(List<Appointment> source) {
    appointments = source;
  }

  static CalendarDataSource getPlannerDataSource(List<TimeSlot> timeSlots,
      {bool isTomorrow = false}) {
    List<Appointment> appointments =
        <Appointment>[]; // the SfCalendar requires a list of Appointment objects

    for (var timeSlot in timeSlots) {
      // if the event is a task, it is a one-time event
      if (timeSlot.event.runtimeType == Task) {
        addTaskToCalendar(appointments, timeSlot);
        // if the event is a block, it is a recurring event
      } else {
        addBlockToCalendar(timeSlot, appointments, isTomorrow);
      }
    }

    // update the tasks visualy if they are passed
    isTaskPassed(appointments);

    return TimeSlotDataSource(appointments);
  }

  static void addTaskToCalendar(
      // TODO : handle overlapping tasks
      List<Appointment> appointments,
      TimeSlot timeSlot) {
    appointments.add(Appointment(
      id: timeSlot.id,
      startTime: DateTime(
          timeSlot.startTime.year,
          timeSlot.startTime.month,
          timeSlot.startTime.day,
          timeSlot.startTime.hour,
          timeSlot.startTime.minute),
      endTime: DateTime(timeSlot.endTime.year, timeSlot.endTime.month,
          timeSlot.endTime.day, timeSlot.endTime.hour, timeSlot.endTime.minute),
      subject: timeSlot.event.name,
      color: Colors.lightBlue.shade100,
    ));
  }

  static void addBlockToCalendar(
      TimeSlot timeSlot, List<Appointment> appointments, bool isTomorrow) {
    // if the end time is before the start time, it means that the block ends the next day
    bool isOverlap =
        timeSlot.endTime.isBefore(timeSlot.startTime) ? true : false;

    (timeSlot.event as Block).isWork
        ? null // if this is a work block, we don't add it since we don't find a way to display it without hiding the task linked to
        : appointments.add(Appointment(
            id: timeSlot.id,
            startTime: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                isTomorrow ? DateTime.now().day + 1 : DateTime.now().day,
                timeSlot.startTime.hour,
                timeSlot.startTime.minute),
            endTime: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                isTomorrow ? DateTime.now().day + 1 : DateTime.now().day,
                // in case of overlap, end at 24:00 makes a double arrow appear which hides the block name
                isOverlap ? 23 : timeSlot.endTime.hour,
                isOverlap ? 59 : timeSlot.endTime.minute),
            subject: timeSlot.event.name,
            color: Colors.indigo.shade50,
            recurrenceRule: 'FREQ=DAILY;INTERVAL=1'));

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
        color: Colors.indigo.shade50,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=1'));
  }

  static void isTaskPassed(List<Appointment> appointments) {
    for (var appointment in appointments) {
      if (appointment.appointmentType != AppointmentType.normal) {
        continue;
      }

      // if the task is passed, we change its visual
      if (appointment.endTime.isBefore(DateTime.now())) {
        appointment.color = Colors.grey.shade300;
      }
    }
  }
}
