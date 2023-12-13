import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_appointment_builder.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotTodayPlanner extends StatelessWidget {
  final BuildContext context;
  final List<TimeSlot> timeSlots;

  const TimeSlotTodayPlanner(
      {super.key, required this.context, required this.timeSlots});

  @override
  Widget build(BuildContext context) {
    // TODO center the calendar on the current time
    return Expanded(
      child: SfCalendar(
        dataSource: TimeSlotDataSource(),
        headerHeight: 0,
        backgroundColor: Colors.transparent,
        allowDragAndDrop: true,
        viewNavigationMode:
            ViewNavigationMode.none, // prevent from swiping to other days
        // timeSlotViewSettings: const TimeSlotViewSettings(timeRulerSize: 35), // reduce the width of the time ruler
        timeSlotViewSettings: const TimeSlotViewSettings(
            timeIntervalHeight:
                75), // increase the height of 1 hour slot to make text appear for 15 min slots
        dragAndDropSettings: const DragAndDropSettings(
          allowNavigation: false,
        ),
        appointmentTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
        showCurrentTimeIndicator: true,
        appointmentBuilder: (context, calendarAppointmentDetails) {
          return TimeSlotAppointmentBuilder(
            appointmentDetails: calendarAppointmentDetails,
          );
        },
      ),
    );
  }
}
