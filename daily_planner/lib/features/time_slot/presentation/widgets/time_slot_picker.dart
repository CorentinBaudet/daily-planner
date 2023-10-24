import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:flutter/material.dart';

class TimeSlotPicker extends StatefulWidget {
  final TimeSlot timeSlot;
  final bool isEndTime;

  const TimeSlotPicker(
      {super.key, required this.timeSlot, this.isEndTime = false});

  @override
  State<TimeSlotPicker> createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.isEndTime ? const Text("to") : const Text("from"),
        const SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: () async {
            final selectedTime = await showTimePicker(
                context: context,
                initialTime: widget.isEndTime
                    ? TimeOfDay.fromDateTime(widget.timeSlot.endTime)
                    : TimeOfDay.fromDateTime(widget.timeSlot.startTime),
                initialEntryMode: TimePickerEntryMode.dial);
            if (selectedTime != null) {
              setState(() {
                widget.isEndTime
                    ? widget.timeSlot.endTime = DateTime(
                        widget.timeSlot.endTime.year,
                        widget.timeSlot.endTime.month,
                        widget.timeSlot.endTime.day,
                        selectedTime.hour,
                        selectedTime.minute)
                    : widget.timeSlot.startTime = DateTime(
                        widget.timeSlot.startTime.year,
                        widget.timeSlot.startTime.month,
                        widget.timeSlot.startTime.day,
                        selectedTime.hour,
                        selectedTime.minute);
              });
            }
          },
          child: widget.isEndTime
              ? Text(Utils().formatTime(widget.timeSlot.endTime),
                  style: TextStyle(color: Theme.of(context).primaryColor))
              : Text(Utils().formatTime(widget.timeSlot.startTime),
                  style: TextStyle(color: Theme.of(context).primaryColor)),
        )
      ],
    );
  }
}
