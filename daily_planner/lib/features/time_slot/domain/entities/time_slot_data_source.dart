import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotDataSource extends CalendarDataSource {
  TimeSlotDataSource(List<Appointment> source) {
    appointments = source;
  }

  static CalendarDataSource getPlannerDataSource(List<TimeSlot> timeSlots) {
    List<Appointment> appointments =
        <Appointment>[]; // the SfCalendar requires a list of Appointment objects

    for (var timeSlot in timeSlots) {
      appointments.add(Appointment(
        startTime: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            timeSlot.startTime.hour,
            timeSlot.startTime.minute),
        endTime: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                timeSlot.startTime.hour,
                timeSlot.startTime.minute)
            .add(Duration(minutes: timeSlot.duration)),
        isAllDay: false,
        subject: timeSlot.content.name,
        color: Colors.grey.shade400,
      ));
    }

    return TimeSlotDataSource(appointments);
  }
}
