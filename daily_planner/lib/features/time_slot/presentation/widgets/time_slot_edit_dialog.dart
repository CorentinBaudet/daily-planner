import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TimeSlotEditDialog extends StatefulWidget {
  TimeSlot timeSlot;

  TimeSlotEditDialog({super.key, required this.timeSlot});

  @override
  State<TimeSlotEditDialog> createState() => _TimeSlotEditDialogState();
}

class _TimeSlotEditDialogState extends State<TimeSlotEditDialog> {
  Row _editStartTime(BuildContext context) {
    return Row(
      children: [
        const Text("from"),
        const SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: () async {
            final selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(widget.timeSlot.startTime),
                initialEntryMode: TimePickerEntryMode.dial);
            if (selectedTime != null) {
              setState(() {
                widget.timeSlot.startTime = DateTime(
                    widget.timeSlot.startTime.year,
                    widget.timeSlot.startTime.month,
                    widget.timeSlot.startTime.day,
                    selectedTime.hour,
                    selectedTime.minute);
              });
            }
          },
          child: Text(Utils().formatTime(widget.timeSlot.startTime),
              style: TextStyle(color: Theme.of(context).primaryColor)),
        )
      ],
    );
  }

  Row _editEndTime(BuildContext context) {
    return Row(
      children: [
        const Text("to"),
        const SizedBox(
          width: 16,
        ),
        InkWell(
          onTap: () async {
            final selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(widget.timeSlot.endTime),
                initialEntryMode: TimePickerEntryMode.dial);
            if (selectedTime != null) {
              setState(() {
                widget.timeSlot.endTime = DateTime(
                    widget.timeSlot.endTime.year,
                    widget.timeSlot.endTime.month,
                    widget.timeSlot.endTime.day,
                    selectedTime.hour,
                    selectedTime.minute);
              });
            }
          },
          child: Text(Utils().formatTime(widget.timeSlot.endTime),
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('edit time slot'),
          IconButton(
            onPressed: () {
              // delete the time slot
              Navigator.of(context).pop(false);
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      insetPadding: const EdgeInsets.all(0),
      content: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_editStartTime(context), _editEndTime(context)],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('cancel'),
        ),
        TextButton(
          style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                  (Set<MaterialState> states) => Colors.white),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary)),
          onPressed: () {
            // edit the time slot
            Navigator.of(context).pop(widget.timeSlot);
          },
          child: const Text('edit'),
        ),
      ],
    );
  }
}
