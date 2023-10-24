import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotAppointmentBuilder extends StatefulWidget {
  final CalendarAppointmentDetails appointmentDetails;

  const TimeSlotAppointmentBuilder(
      {super.key, required this.appointmentDetails});

  @override
  State<TimeSlotAppointmentBuilder> createState() =>
      _TimeSlotAppointmentBuilderState();
}

class _TimeSlotAppointmentBuilderState
    extends State<TimeSlotAppointmentBuilder> {
  @override
  Widget build(BuildContext context) {
    final Appointment appointment =
        widget.appointmentDetails.appointments.first;
    if (appointment.appointmentType != AppointmentType.normal) {
      return Container(
        width: widget.appointmentDetails.bounds.width,
        height: widget.appointmentDetails.bounds.height,
        color: widget.appointmentDetails.appointments.first.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(appointment.subject),
            ),
            IconButton(
              icon: const Icon(
                Icons.change_circle_rounded,
                size: 19,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () {},
            )
          ],
        ),
      );
    } else {
      return Container(
        width: widget.appointmentDetails.bounds.width,
        height: widget.appointmentDetails.bounds.height,
        color: widget.appointmentDetails.appointments.first.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(appointment.subject),
            ),
            widget.appointmentDetails.appointments.first.endTime
                    .isBefore(DateTime.now())
                ? Checkbox(
                    value: false,
                    onChanged: (c) {
                      // TODO : handle task completion
                    })
                : const SizedBox.shrink()
          ],
        ),
      );
    }
  }
}
