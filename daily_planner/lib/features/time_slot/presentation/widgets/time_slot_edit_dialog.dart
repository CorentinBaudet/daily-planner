import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_picker.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TimeSlotEditDialog extends StatefulWidget {
  TimeSlot timeSlot;

  TimeSlotEditDialog({super.key, required this.timeSlot});

  @override
  State<TimeSlotEditDialog> createState() => _TimeSlotEditDialogState();
}

class _TimeSlotEditDialogState extends State<TimeSlotEditDialog> {
  TimeSlotPicker _editStartTime(BuildContext context) {
    return TimeSlotPicker(timeSlot: widget.timeSlot, isEndTime: false);
  }

  TimeSlotPicker _editEndTime(BuildContext context) {
    return TimeSlotPicker(timeSlot: widget.timeSlot, isEndTime: true);
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
