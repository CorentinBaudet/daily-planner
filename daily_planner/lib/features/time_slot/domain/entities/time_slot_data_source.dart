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
        appointments.add(Appointment(
          id: timeSlot.id,
          startTime: DateTime(
              timeSlot.startTime.year,
              timeSlot.startTime.month,
              timeSlot.startTime.day,
              timeSlot.startTime.hour,
              timeSlot.startTime.minute),
          endTime: DateTime(
                  timeSlot.startTime.year,
                  timeSlot.startTime.month,
                  timeSlot.startTime.day,
                  timeSlot.startTime.hour,
                  timeSlot.startTime.minute)
              .add(Duration(minutes: timeSlot.duration)),
          isAllDay: false,
          subject: timeSlot.event.name,
          color: Colors.lightBlue.shade100,
        ));
        // if the event is a block, it is a recurring event
      } else {
        appointments.add(Appointment(
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
                  timeSlot.startTime.hour,
                  timeSlot.startTime.minute)
              .add(Duration(minutes: timeSlot.duration)),
          isAllDay: false,
          subject: timeSlot.event.name,
          color: Colors.grey.shade400,
        ));
      }
    }

    return TimeSlotDataSource(appointments);
  }
}
